# Common Architecture — App-Neutral CLI Ops Foundation

> **목적**: Claude Code 운영 헌법(`CLAUDE.md`)이 모든 Android 앱 레포에서 동일하게 동작하도록 보장하는 공통 아키텍처 SoT.
> **적용 대상**: SteadyWell, GentlyDay, GentlyBreath, GentlyTable 및 향후 propagation 대상 레포.
> **SoT**: 이 문서. 변경은 SteadyWell에서 먼저 반영 후 propagation.

---

## 1. 운영 레이어 vs 제품 레이어

| 레이어 | 경로 | 변경 권한 |
|---|---|---|
| 운영 레이어 (CLI ops) | `CLAUDE.md`, `.claude/`, `scripts/agent/`, `docs/agent/`, `.ai/` | 모든 레포 공통 — propagation 대상 |
| 제품 레이어 (코드) | `app/`, `shared/` ([app-foundation/shared/domain/](../../../../app-foundation/shared/domain/) · [app-foundation/shared/data/](../../../../app-foundation/shared/data/) · [app-foundation/shared/feature-state/](../../../../app-foundation/shared/feature-state/)), `iosApp/`, `feature/`, `gradle/` | 레포별 고유 — propagation 대상 아님 |

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

## 4. Propagation Discipline

1. **SoT 원본**: 변경은 SteadyWell repo에서 먼저 반영
2. **Verify in source**: SteadyWell에서 lint·verify·review PASS
3. **Propagate**: 변경된 파일을 각 target repo에 복사 + 레포-고유 부분 재적용
4. **Verify in target**: 각 target에서 lint·verify·review PASS
5. **Drift Audit**: 정기적으로 SteadyWell ↔ targets 간 drift 점검

운영 레이어 drift는 `/fulfill-doc-governance` 트랙으로 처리한다.

---

## 5. 관련 문서

- `KMP_CMP_LAYER_DIRECTION.md` — shared/domain ← shared/feature-state ← shared/app ← app/iosApp 흐름
- `KOIN_DI_BASELINE.md` — Koin DI 배치 정책
- `TDD_WORKFLOW.md` — FakeXxx 기반 테스트 우선 흐름
- `SSOT_PRINCIPLES.md` — Single Source of Truth 원칙
- `MODEL_SEPARATION.md` — DTO/Entity/DomainModel/UiState 분리
- `ERROR_RESULT_POLICY.md` — typed Result / sealed error
- `TESTABILITY_SEAMS.md` — clock/dispatcher/identity/logger/uuid 주입
- `DEPENDENCY_DECISION_CHECKLIST.md` — 신규 의존성 8개 항목
- `LEGACY_CLEANUP_GOVERNANCE.md` — 코드 제거 거버넌스 (rules/legacy-cleanup-governance.md 의 architecture-level 보충)
