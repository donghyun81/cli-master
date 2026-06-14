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

## 4. 사용자 데이터 source of truth (앱-중립 데이터 아키텍처 원칙)

> 결정 기록: `LOCK-DATA-SOT-SERVER-AUTHORITATIVE-001` (Coin 확정 2026-06-15). 본 절 = 그 결정의 아키텍처 명문화이며, 변경은 foundational(STOP 영역).

모든 propagation 대상 앱이 공유하는 **사용자 데이터 흐름 계약**이다. 도메인 정책이 아니라 persistence 아키텍처 원칙이므로 운영 레이어 SoT에 둔다(`SSOT_PRINCIPLES` · `MODEL_SEPARATION` 와 동족). 특정 도메인 스키마·테이블·앱별 적용 상태는 본 절에 박지 않는다(앱-고유).

- **source of truth = 서버(Supabase Postgres).** 사용자가 생성한 데이터(세션·로그·기록 등)는 서버가 authoritative. 클라이언트 로컬 저장소를 단독 SoT로 두지 않는다.
- **Room = offline-first 캐시 + 서버 hydration(복원) 층.** 빠른·오프라인 렌더를 위한 종속 캐시이며, 서버에서 read-back으로 복원된다. Room 단독 SoT 금지.
- **집계(곡선·통계·리포트) = 서버 Edge Function.** 모든 앱 일관. 클라이언트는 서버 집계 결과를 소비·캐시한다.
- **durability 요건**: 재설치·기기 변경 후에도 이력 생존. 모든 신규 사용자 데이터는 서버 SoT + hydration 경로를 가져야 한다(업로드 전용 sync = 미충족).

근거(요약): 제품 thesis = 리셋되지 않는 누적 곡선 → 로컬-only는 재설치 시 리셋 → durability ⇒ 서버 SoT. 상세 근거·기각안(Room authoritative)·앱별 현 적용 상태 및 정합(gap 보완) 방향은 `LOCK-DATA-SOT-SERVER-AUTHORITATIVE-001` 및 각 repo 데이터층 문서에서 추적한다.

---

## 5. Propagation Discipline

1. **SoT 원본**: 변경은 SteadyWell repo에서 먼저 반영
2. **Verify in source**: SteadyWell에서 lint·verify·review PASS
3. **Propagate**: 변경된 파일을 각 target repo에 복사 + 레포-고유 부분 재적용
4. **Verify in target**: 각 target에서 lint·verify·review PASS
5. **Drift Audit**: 정기적으로 SteadyWell ↔ targets 간 drift 점검

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
