# Common Architecture — App-Neutral CLI Ops Foundation

> **목적**: Claude Code 운영 헌법(`CLAUDE.md`)이 모든 Android 앱 레포에서 동일하게 동작하도록 보장하는 공통 아키텍처 SoT.
> **적용 대상**: 4-active — `claude-cli-master`(master) · `app-foundation` · `toward-product-docs` · `Selfward` 및 향후 propagation 대상 레포. (GentlyBreath · GentlyDay · GentlyTable = 2026-07-17 T6 **동결 계승 원천** — 전파 대상 아님 · 쓰기 0)
> **SoT**: 이 문서. 변경은 `claude-cli-master` 에서 먼저 반영 후 자식으로 단방향 propagation.

---

## 1. 운영 레이어 vs 제품 레이어

| 레이어 | 경로 | 변경 권한 |
|---|---|---|
| 운영 레이어 (CLI ops) | `CLAUDE.md`, `.claude/`, `scripts/agent/`, `docs/agent/`, `.ai/` | 모든 레포 공통 — propagation 대상 |
| 제품 레이어 (코드) | `app/`, `shared/` ([app-foundation/shared/domain/](../../../../app-foundation/shared/domain/) — 실측 `shared/` = `domain` 단독 · 모듈 열거 SoT = `app-foundation/CLAUDE.md §0.2`), `iosApp/`, `feature/`, `gradle/` | 레포별 고유 — propagation 대상 아님 |

운영 레이어는 **앱-중립**으로 유지한다. 제품 컨텍스트(앱 이름, 도메인 정책, 결제 모델, AI 사용 정책 등)는 운영 레이어에 침투하지 않는다.

---

## 2. 운영 레이어 구성 요소

```
<repo-root>/
├── CLAUDE.md                          # 최상위 운영 헌법 (각 레포가 PREFIX/AppName만 다름)
├── check-architecture.sh              # KMP/단일모듈 구조 점검 (레포 구조에 맞게 starter)
├── .claude/
│   ├── settings.json                  # deny + hooks (deny 목록은 모든 레포 동일)
│   ├── hooks/
│   │   ├── session-start.sh           # 세션 시작 시 상태 dump (배너만 레포별)
│   │   ├── pre-tool-use.sh            # /tmp 차단 (공통)
│   │   ├── post-policy-watch.sh       # 정책 파일 변경 경고 (공통)
│   │   └── stop-gate.sh               # VERIFY/REVIEW/Cleanup Assessment 가드 (공통)
│   ├── rules/                         # 12개 공통 규칙 (앱-중립)
│   ├── agents/                        # ~22개 공통 역할 (앱-중립)
│   ├── skills/                        # fulfill-requirement, fulfill-doc-governance, uiux-sot-refresh
│   └── commands/                      # 7개 슬래시 커맨드 (앱-중립)
├── scripts/agent/
│   └── frontmatter-grep.sh            # frontmatter 검사 helper (구 compound-lint.sh = deprecated · 부재 — 산출물·시크릿 검증 = verify-all + 시크릿 grep)
├── docs/agent/
│   ├── architecture/                  # 이 문서 포함 — 공통 아키텍처 SoT
│   ├── process/                       # intake / doc governance 워크플로
│   └── solutions/                     # PromptFit rubric, agent solutions README
└── .ai/
    ├── tasks/                         # task 정의 (불변)
    ├── reports/                       # 단계별 보고서
    ├── promptfit/                     # PromptFit 인덱스/플레이북
    └── uiux-sot/                      # UI/UX evidence companion (placeholder 가능)
```

---

## 3. 앱-고유 vs 앱-중립 구분 원칙

**앱-중립 (모든 레포 공통)**
- 워크플로 단계, STOP 조건, 보고서 스키마, lint 정책
- 역할 정의, 라우팅 로직, 검증/리뷰 체크리스트
- DI baseline, 모델 분리, 오류 정책, 테스트 심 등 아키텍처 원칙

**앱-고유 (레포별 차이 허용)**
- TaskId PREFIX (`SW-`, `GD-`, `GB-`, `GT-` 등)
- AppName 배너 (`session-start.sh`)
- KMP 모듈 경로 (`shared/...`, `iosApp/...`) 또는 단일모듈 경로
- `additionalDirectories`(레포에 실제 존재하는 추가 SoT 경로만)
- `check-architecture.sh` 의 expected module 목록
- 도메인 정책·결제·AI 정책 (해당 레포만 가짐 — 운영 레이어에 침투 금지)

---

## 4. 사용자 데이터 source of truth (앱-중립 데이터 아키텍처 원칙)

> 결정 기록: `LOCK-DATA-SOT-SERVER-AUTHORITATIVE-001` (Coin 확정 2026-06-15). 본 절 = 그 결정의 아키텍처 명문화이며, 변경은 foundational(STOP 영역).

모든 propagation 대상 앱이 공유하는 **사용자 데이터 흐름 계약**이다. 도메인 정책이 아니라 persistence 아키텍처 원칙이므로 운영 레이어 SoT에 둔다(`SSOT_PRINCIPLES` · `MODEL_SEPARATION` 와 동족). 특정 도메인 스키마·테이블·앱별 적용 상태는 본 절에 박지 않는다(앱-고유).

- **source of truth = 서버(Supabase Postgres).** 사용자가 생성한 데이터(세션·로그·기록 등)는 서버가 authoritative. 클라이언트 로컬 저장소를 단독 SoT로 두지 않는다.
- **Room = offline-first 캐시 + 서버 hydration(복원) 층.** 빠른·오프라인 렌더를 위한 종속 캐시이며, 서버에서 read-back으로 복원된다. Room 단독 SoT 금지.
- **집계(곡선·통계·리포트) = 서버 Edge Function.** 모든 앱 일관. 클라이언트는 서버 집계 결과를 소비·캐시한다.
- **durability 요건**: 재설치·기기 변경 후에도 이력 생존. 모든 신규 사용자 데이터는 서버 SoT + hydration 경로를 가져야 한다(업로드 전용 sync = 미충족).

근거(요약): 제품 thesis = 리셋되지 않는 누적 곡선 → 로컬-only는 재설치 시 리셋 → durability ⇒ 서버 SoT. 상세 근거·기각안(Room authoritative)·앱별 현 적용 상태 및 정합(gap 보완) 방향은 `LOCK-DATA-SOT-SERVER-AUTHORITATIVE-001` 및 각 repo 데이터층 문서에서 추적한다.

### 4.1 다중 값 컬럼 타입 표현 규약 (앱-중립 · persistence 한정)

> ★**정정 · supersede 고지 (2026-08-01)**: 구 「중첩/구조화 객체 = `JSONB`」 + 「중첩 구조가 필요해질 때 `JSONB` 승격」 2항은 `ADR-0001-SERVER-DATA-OWNERSHIP-SEPARATION`(Accepted 2026-08-01)로 **supersede** 되어 아래 3분 갈림길로 대체됐다. **사유**: 구 승격 규칙이 `JSONB` 로 보낸 항목은 **종별 제약(1:1 UNIQUE·종류별 NOT NULL·열거형 CHECK)을 걸 수 없게** 되는데 그 대가가 비용으로 세어지지 않았고, 구 규칙의 `TEXT[]` 실적용처(`user_profiles` 3컬럼)는 **살아있는 적용처가 0**(사문 · P1-1 에서 테이블째 DROP)이었다. **덮어쓰기가 아니라 전이** — 구 문면 verbatim = `claude-cli-master/.ai/reports/MASTER-DATA-OWNERSHIP-RULE-001/REPORT.md`.

다중 값 컬럼은 의미 구조에 따라 일관된 Postgres 타입으로 표현한다(앱 무관).

- **문자열 리스트 = `TEXT[]`** (네이티브 배열). 예: 태그·선호·제한·환경 목록. CSV 문자열(쉼표 구분 한 컬럼) 금지 — 타입 미강제·파싱 오류 회피.
- **구조를 가진 항목의 목록 = 자식 테이블** (필드 2개 이상 · 순서가 의미 있음). `position integer` 로 순서를 지고 PK = `(parent_id, position)`. ★구 「`JSONB` 승격」 대체.
- **우리가 형태를 정하지 않는 외부 페이로드 = `JSONB`**. 예: 타사 응답 원문. 우리 스키마가 아니므로 검사 대상도 아니다.
- **단일 스칼라 = scalar**(`TEXT`/`BOOLEAN`/`TIMESTAMPTZ` 등). 배열로 승격하지 않는다.

★**갈림길 1문**: 「이 안의 필드에 **제약을 걸고 싶어질 것 같은가**?」 → 그렇다면 **자식 테이블**이다. `JSONB` 는 **제약을 걸 수 없다는 선언**이고, 그건 외부 페이로드에만 맞는 말이다.

> 도메인 의미(verbatim recognition·enum 라벨 금지 등)는 본 절이 아니라 각 앱 design SoT·product 원칙에서 다룬다(본 절 = persistence 표현 한정).

> **형태 층 상세** = [`SERVER_DATA_OWNERSHIP.md`](SERVER_DATA_OWNERSHIP.md) — 소유 경계·분리 판단(§2)·스키마 형태 6·삭제 3층·왕복·배포 순서·검증 7. 본 §4 가 「무엇이 SoT 인가」라면, 그 문서가 「그럼 어떤 모양으로 두는가」다.

---

## 5. Propagation Discipline

1. **SoT 원본**: 변경은 `claude-cli-master` repo에서 먼저 반영
2. **Verify in source**: `claude-cli-master` 에서 lint·verify·review PASS
3. **Propagate**: 변경된 파일을 각 target repo에 복사 + 레포-고유 부분 재적용
4. **Verify in target**: 각 target에서 lint·verify·review PASS
5. **Drift Audit**: 정기적으로 `claude-cli-master` ↔ targets 간 drift 점검

운영 레이어 drift는 `/fulfill-doc-governance` 트랙으로 처리한다.

---

## 6. 관련 문서

- `KMP_CMP_LAYER_DIRECTION.md` — shared/domain ← shared/feature-state ← shared/app ← app/iosApp 흐름
- `KOIN_DI_BASELINE.md` — Koin DI 배치 정책
- `TDD_WORKFLOW.md` — FakeXxx 기반 테스트 우선 흐름
- `SSOT_PRINCIPLES.md` — Single Source of Truth 원칙
- `MODEL_SEPARATION.md` — DTO/Entity/DomainModel/UiState 분리
- `ERROR_RESULT_POLICY.md` — typed Result / sealed error
- `TESTABILITY_SEAMS.md` — clock/dispatcher/identity/logger/uuid 주입
- `DEPENDENCY_DECISION_CHECKLIST.md` — 신규 의존성 8개 항목
- `LEGACY_CLEANUP_GOVERNANCE.md` — 코드 제거 거버넌스 (rules/legacy-cleanup-governance.md 의 architecture-level 보충)
- `SERVER_DATA_OWNERSHIP.md` — 서버 소유 데이터의 형태 층 (§4 의 상세 · 분리/스키마/삭제/왕복/배포/검증)
