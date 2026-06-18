# Design SoT Policy (도구 무관)

> **단일 목적**: Design SoT (Visual + Structural dual-layer) 의 도구 무관 일반 정책 — SoT 계층 / lifecycle / 라벨 / Phase R 예외 / drift 판정 / LOCKED 승격 / 고위험 STOP.
> **C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 신설** (Q2 답 박음 · pencil-sot-policy.md 의 75% 공통 추출).
> **본 파일 = 보호 (강제 byte-identical)**.
> **연관 파일**:
> - `design-to-code-sync.md` — Design SoT → Code 단방향 sync 일반 패턴 (5-type 분류)
> - `uiux-sot-refresh.md` (보호) — refresh trigger 분류
> - 도구 바인딩: `docs/design/pencil-sot-binding.md` (Pencil) / `figma-sot-binding.md` (향후)
> - 기계 스키마: `docs/schemas/ui-spec.schema.json` v0.2 (도구 무관 필드명)
> SOT: `CLAUDE.md`

---

## §1 SoT 계층 (Option B dual-layer · 도구 무관)

| 순위 | 계층 | 경로 (placeholder) | 역할 |
|---|---|---|---|
| 1a | Structural SoT | `docs/design/<design-tool>-sot/<screen>.ui-spec.json` | 기계 가독 단일 출처. schema-validated. CLI read/edit/verify 의 canonical input. lifecycle 관리 진입점. |
| 1b | Visual SoT | `docs/design/<design-tool>-sot/<screen>.<visual-ext>` | 디자인 도구 네이티브 캔버스 파일 (Pencil = .pen / Figma = .fig 등). 도구 MCP read/edit 진입점. Coin GUI fallback 편집 경로. `ui-spec.json.visualSotPath` 가 이 경로를 참조. |
| 2 | 텍스트 계약 | `docs/design/<design-tool>-dev-prompt.md` §N | free-text 수용 기준 · 레이아웃 · 상태 · 에러 서술. 톤 · 근거 문서화. |
| 3 | 기계 가독 토큰 | `docs/design/<design-tool>-exports/<screen>/<tool>-vars-after.json` | Reference 토큰 hex/sp/dp 리터럴. Code 수입 기준값. |
| 3a | 토큰 diff 근거 | `docs/design/<design-tool>-exports/<screen>/<tool>-vars-before.json` | 변경 전후 비교 (P4 before/after pair). |
| 4 | 검수 artifact | `docs/design/<design-tool>-sot/<screen>.preview.{light,dark}.png` | 시각 검수용. **SoT 아님**. P6 pixel-diff 검증에만 사용. |
| 5 | 런타임 참조 | `.ai/uiux-sot/latest/<screen>/*.png` | 에뮬레이터 / 시뮬레이터 캡처. 회귀 비교용. **SoT 아님**. |
| 5a | 런타임 archive | `.ai/uiux-sot/archive/<yyyymmdd>/<screen>/` | 구 runtime 캡처 보관. P3 archive 원칙. |

- 우선순위 상위가 하위를 오버라이드. 충돌 시 1a → 1b → 2 → 3 → 3a → 4 → 5 → 5a 순으로 신뢰.
- 1a (`ui-spec.json`) 와 1b (`.<visual-ext>`) = **dual-layer** 상호 투영. 동시 유지 필수.
- 계층 1a 부재 + 1b 존재 → v0.1→v0.2 마이그레이션 미완. IMPL 진입 가능 + migration task 권장.
- 계층 1b 부재 → Phase R 예외 (§3) 로 재건 의무.

### §1.1 · 1a ↔ 1b 동기화 계약 (도구 바인딩 추상)

- `ui-spec.json` write → 도구 MCP 의 캔버스 ops 로 1b 투영 → `lastSyncedDesignToolStateHash` 갱신
- 1b Coin GUI 수정 (Path B fallback) → 도구 MCP 의 read 로 복원 후 `ui-spec.json` 재생성 → `capturedAt` + `lastSyncedDesignToolStateHash` 갱신
- 충돌: `capturedAt` 최신 쪽 우선. 동일 시각 충돌 시 STOP.
- drift 기계 감지: `visualSotPath` 존재 && `lastSyncedDesignToolStateHash` 가 현 1b sha 불일치 → drift warn (수동 sha 대조 · 구 compound-lint warn = deprecated · 도구 부재 · MASTER-CLI-COMPOUND-LINT-DEPRECATE-001).
- 1a write 후 1b 재 export 누락 (또는 반대) → REVIEW FAIL (P9 · 구 compound-lint FAIL = deprecated).

도구별 구체 절차 = `docs/design/<design-tool>-sot-binding.md` 박힘.

### §1.2 · lifecycle 관리 (ui-spec.json)

`ui-spec.json` 의 `lifecycle` 필드 (도구 무관):

- `active` — 정상 운영 상태. 편집 허용.
- `deprecated` — 대체 화면 확정. `lifecycleReason = "replaced-by:<new-screen>"`. 신규 참조 WARN.
- `frozen` — Auth / Billing / DB STOP 영역 잠정 동결. `lifecycleReason` 사유 명시. 편집 금지.
- `removed` — 제품 완전 제거. `lifecycleReason = "removed-at:<yyyymmdd>"`. 물리 1b 파일 archive 이동.

lifecycle gate:
- `frozen` / `removed` 화면 → `design-to-code-sync.md` 5-type IMPL 진입 전 STOP + IMPL 차단
- `deprecated` → 편집 가능하나 CHANGELOG 에 사유 기록
- `active` 또는 필드 부재 (v0.1 data) → 정상 진행

lifecycle 전이 표 + 물리 파일 처리 + DELETE STOP 상세: `design-to-code-sync.md` "DELETE / Lifecycle 절차".

---

## §2 프레임 층위 라벨 (도구 무관)

프레임 이름 접미 또는 `<design-tool>-dev-prompt.md` 섹션 헤더에 명시:

- **[CURRENT]** — 현재 Code 구현을 역공학으로 복원한 프레임. 최초 골격.
- **[TARGET]** — `<design-tool>-dev-prompt.md` 최신 스펙이 지향하는 프레임. 설계 의도.
- **[LOCKED]** — [TARGET] 이 Code 구현 + 검증 (P6 / 빌드 / 기능) 통과하여 SoT 로 승격된 상태.

드리프트 판정: Code 값과 [LOCKED] `<tool>-vars-after.json` 값 상이 시 코드 측 위반.

---

## §3 역방향 금지 + Phase R 한정 예외

### 원칙

- Design SoT → Code = 유일한 정방향
- Code 먼저 + 사후 Design 반영 (code-first) = **Deferred (design-debt) lane 등재 시 한정 허용** (`uiux-sot-refresh.md` "즉시 의무 vs Deferred" 분기 정합):
  - 미등재 code-first = REVIEW [Design SoT Sync] WARN
  - 출시 후 net-new visual code-first = 위반(선행 의무) → release 게이트 FAIL
  - deferred 항목 = DESIGN-DEBT.md 등재 + 출시 전 해소 (release backstop)

### Phase R (Design SoT Recovery) 한정 역공학 예외

- 조건: 1b (Visual SoT) 원본이 repo 에 존재하지 않는 화면
- 허용 범위: **[CURRENT] 프레임 1 개 생성을 위한** Code + `preview.png` 역참조
- 결과물: [CURRENT] 프레임 + [TARGET] 프레임 (`<design-tool>-dev-prompt.md` 기반) 쌍으로 디자인 도구에 존재
- 종료 조건: Phase R-4 에서 [TARGET] → [LOCKED] 승격 후 본 예외 해제. 이후 정방향 원칙만 적용.
- 범위 초과 사용 금지: 기존 1b 보유 화면에 역공학 적용 → REVIEW FAIL

---

## §4 PNG 정책 (2 종류 분리)

### preview.png (디자인 도구 export)

- 경로 (v2 canonical): `docs/design/<design-tool>-sot/<screen>.preview.{light,dark}.png`
- 경로 (v1 legacy): `docs/design/<design-tool>-exports/<screen>/preview.png` — 존재 시 `ui-spec.json.notes.previewSourceMap` 에 실 경로 기록으로 호환 유지
- 생성: 도구 MCP `export_nodes` 또는 Coin 수동 export
- 역할: P6 pixel-diff 검증 기준값 (±2dp · ΔE≤3)
- SoT 지위: **없음**. 토큰 값의 재원은 `<tool>-vars-after.json`
- 변경 트리거: 1b 편집 → `preview.{light,dark}.png` 재생성 필수

### runtime screenshot PNG

- 경로: `.ai/uiux-sot/latest/<screen>/*.png`
- 생성: Coin 에뮬레이터 / 시뮬레이터 캡처 후 Write 복사
- 역할: 회귀 비교 + `uiux-sot-refresh` 트리거 증거
- SoT 지위: **없음**. preview.png 와 혼동 금지

---

## §5 드리프트 판정 룰 (도구 무관)

| 비교 대상 | Drift 판정 기준 | 조치 |
|---|---|---|
| Code 토큰 vs `<tool>-vars-after.json` | 값 불일치 | Code 측 수정 (단일 ui/theme/ 지점) |
| `<tool>-vars-after.json` vs 1b export | 값 불일치 | 1b 재 export → JSON 덮어쓰기 |
| `preview.{light,dark}.png` vs Code Preview | ΔE > 3 또는 layout ±2dp 초과 | 원인 규명 → 1b 또는 Code 수정 |
| `<design-tool>-dev-prompt.md` [TARGET] vs `<tool>-vars-after.json` | 스펙과 수치 불일치 | 1b → export 재수행 |
| `ui-spec.json.lastSyncedDesignToolStateHash` vs 1b 현재 sha | 불일치 | drift warn (구 compound-lint = deprecated) · 1a ↔ 1b 재동기 (§1.1) |
| `ui-spec.json.visualSotPath` 존재 && 1b 부재 | 경로 끊김 | STOP · `visualSotPath` 갱신 또는 Phase R 진입 |
| `lifecycle == "active"` && `visualSotPath == null` | 1b 미연결 active screen | Phase B (dual-layer migration) 후보 · 별도 task |
| preview.png 파일 부재 | 검수 증거 없음 | `ui-spec.json.notes.previewSourceMap` 기록 · re-export task |

---

## §6 LOCKED 승격 조건 (도구 무관)

모든 항목 PASS 시 [TARGET] → [LOCKED]:

1. 1b 에 [TARGET] 프레임 존재 + export 최신
2. `<tool>-vars-after.json` 과 Code `ui/theme/` 값 동일
3. 자식 repo build PASS (예: `./gradlew :app:assembleDebug`) + 단위 테스트 exit 0
4. P6 pixel-diff 통과 (±2dp · ΔE≤3)
5. hardcoded 색상 / 토큰 0 건 (예: `grep -rn "0xFF" app/src/main/java/ui/ | grep -v "ui/theme/"` = 0)
6. `ui-spec.json.lifecycle == "active"` + `lastSyncedDesignToolStateHash` 최신
7. `CHANGELOG.md` 에 승격 1 줄 기록 (형식: `YYYY-MM-DD · <screen> · LOCKED 승격 · lifecycle=active · by=<role>`)

---

## §7 legacy artifact 격하

- 과거 artifact (예: `meta.json`) = 본 정책 발효 시점부터 **legacy 선언**
- 신규 작성 금지
- 마이그레이션 경로: 토큰 리터럴을 화면별 `<tool>-vars-after.json` 으로 흡수 → 원본 삭제 (Coin 수동)
- Phase R 실행 과정에서 화면별로 순차 처리

---

## §8 고위험 STOP

- Auth · Billing · DB migration · 시크릿 / PII 노출과 UI 변경이 겹치면 본 정책의 우선순위 적용 전 **워크플로우 STOP**. 별도 리뷰 필수.
- 해당 영역 화면은 `ui-spec.json.lifecycle = "frozen"` + `lifecycleReason` 기록
- 1b 원본 in-place 덮어쓰기 시도 → STOP (도구 MCP write tool 은 반드시 복제 → 신규 프레임 patterns)
- `ui-spec.json` + 1b 동시 대규모 교체 (Auth/Billing 경로) → STOP + Coin 명시 승인
