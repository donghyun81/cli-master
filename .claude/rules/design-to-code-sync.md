# Design → Code Sync Rules (도구 무관)

> **단일 목적**: Design SoT → Code 단방향 sync 의 **도구 무관 일반 패턴** — Phase 분류 / 5-type IMPL 흐름 / Output Checklist / STOP 조건 / Refresh Trigger 연계.
> **C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 신설** (Q2 답 추가).
> **도구 바인딩 분리**: 본 파일 = 70% 공통. 도구별 바인딩 = 별 파일:
> - Pencil 바인딩: `pencil-uiux-workflow.md` (도구 바인딩 30%)
> - Figma 바인딩: 향후 신설 시 `figma-uiux-workflow.md` patterns
> - Sketch / Adobe XD: 향후 신설 시 동일 patterns
>
> **연관 파일**:
> - `design-sot-policy.md` (보호 · dual-layer SoT 정책)
> - `design-sot-refresh.md` (보호 · refresh trigger 분류)
> - `pencil-uiux-workflow.md` (Pencil 도구 바인딩 구체화)
> SOT: `CLAUDE.md`

---

## 1. SoT 계층 (Option B dual-layer)

모든 화면은 두 SoT 파일 유지:
- **Visual SoT** (`<screen>.<ext>`) — 디자인 도구의 캔버스 파일 (Pencil = .pen / Figma = .fig)
- **Structural SoT** (`<screen>.ui-spec.json`) — 구조 + 의미 + sync hash

두 SoT 가 sha 로 동기 (`lastSyncedDesignToolStateHash` 필드).

---

## 2. 프레임 층위 라벨 (도구 무관)

각 frame 의 lifecycle 라벨:
- `[CURRENT]` — 현 production reflect
- `[TARGET]` — 다음 cycle 목표
- `[LOCKED]` — Stage 3 검증 완료 + 변경 시 즉시 STOP
- `[ARCHIVED]` — 사용 안 함 + history 보존

---

## 3. Phase 분류 (5-type IMPL)

자식 repo 의 Compose / SwiftUI 등 코드 안에서 Design SoT 를 IMPL 할 때 5-type 분류:

| type | 정의 | 진입 조건 | 흐름 |
|---|---|---|---|
| **1. drift 정정** | SoT = 정답 / Code outdated | `verify-sync.sh` drift 발견 | SoT → Code 단방향 sync (Path 2-A 표준) |
| **2. SoT 신설** | 신규 화면 / SoT + Code 동시 신설 | 신규 feature cycle | SoT 먼저 + Code 후 (도구 바인딩 별 절차) |
| **3. Phase R (역공학)** | SoT 부분 부재 + Code + preview.png 로 [CURRENT] 역공학 | `.<design-tool-ext>` 부재 화면 진입 | 도구 바인딩 별 patterns + `design-sot-policy.md` §Phase R |
| **4. 초기 신설** | 빈 repo + 모든 화면 SoT 동시 신설 | 신규 자식 repo 신설 cycle | bulk SoT 신설 + Code stub |
| **5. 일괄 갱신** | 여러 화면 동시 변경 (예: 디자인 시스템 v2 도입) | 디자인 시스템 cycle | sub-batch 분할 + 진행도 가시화 |

---

## 4. Output Checklist P1~P9

모든 IMPL cycle 마감 시 본 9 체크 의무:

- **P1**: Visual SoT (`<screen>.<ext>`) 디스크 존재 + sha 갱신
- **P2**: Structural SoT (`<screen>.ui-spec.json`) 디스크 존재 + `lastSyncedDesignToolStateHash` = full 64자 sha
- **P3**: 두 SoT 의 sha 일치 (`verify-sync.sh` 자식 repo 안)
- **P4**: Code (Compose / SwiftUI 등) 빌드 PASS
- **P5**: preview.png 갱신 (Phase D 검증 자동화 · 도구 바인딩별 patterns)
- **P6**: lifecycle 라벨 정합 (`[CURRENT]` / `[TARGET]` / `[LOCKED]` / `[ARCHIVED]`)
- **P7**: cleanup pass (`legacy-cleanup-governance.md` 명시됨)
- **P8**: VERIFY.md exit code 기록
- **P9**: REVIEW.md PromptFit 평가 + INDEX.md 갱신

---

## 5. STOP 조건 (도구 무관)

- `[LOCKED]` 라벨 frame 변경 시도 → 즉시 STOP + Coin 명시 승인 의무
- 두 SoT 의 sha 불일치 + 어느 것이 정답인지 모호 → STOP + Phase 1 (drift 정정) 또는 Phase R (역공학) 결정 의무
- 디자인 도구 자동화 실패 + fallback 도 실패 → STOP + Coin GUI 손 작업 분리
- Code 빌드 깨짐 + SoT 변경이 원인 추정 → STOP + rollback 평가

---

## 6. DELETE / Lifecycle 절차

- `[ARCHIVED]` 전환 = SoT 파일 mv (`docs/design/<tool>-sot/archive/<yyyymmdd>/`) + ui-spec.json `lifecycle: archived`
- 완전 삭제 = Coin 명시 승인 + commit body `[Sha]` + propagation 의무

---

## 7. Refresh Trigger 연계

`design-sot-refresh.md` (보호) 의 FULL / PARTIAL / DOC-ONLY 분류 따름.

---

## 8. 도구 바인딩 의무 (구체화)

본 rule = 도구 무관 패턴. 실 자동화 + 도구 호출은 별 파일에서 추가:

| 도구 | 바인딩 파일 | 자동화 hook |
|---|---|---|
| Pencil | `.claude/rules/pencil-uiux-workflow.md` + `.claude/rules/pencil-automation.md` | `.claude/hooks/pencil-auto-save.sh` + `save-as-result-check.sh` |
| Figma | (향후 신설) `figma-uiux-workflow.md` + `figma-automation.md` | (향후) `figma-auto-export.sh` |
| Sketch | (향후) `sketch-uiux-workflow.md` | (향후) `sketch-auto-export.sh` |

신규 도구 도입 시:
1. 본 `design-to-code-sync.md` 의 5-type 분류 + Output Checklist 그대로 사용
2. 도구별 `<tool>-uiux-workflow.md` + `<tool>-automation.md` + `<tool>-auto-save.sh` 신설
3. master cycle 으로 신설 + propagation
