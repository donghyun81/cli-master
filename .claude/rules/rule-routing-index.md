# Rule Routing Index — 계층 taxonomy + 행동→규칙 라우팅 색인

> **단일 목적**: `.claude/rules/` 43 rule 의 논리적 계층(L0~L3) 외화 + Reading Mode 7종(행동) → 의무 로드 규칙 집합 매핑 + 행동별 측정 가능 목표(GSM) + deviation 경로 + 색인 갱신 규약. **물리 폴더 이동 없음 · frontmatter 없음** — 본 색인 한 file 이 계층을 표현한다.
> **본 색인 = pointer only**. 각 rule 의 본문은 해당 file 단일 SoT. 본 색인은 어느 본문도 복제하지 않는다.
> **신설**: RULE-ARCH-PHASE1-001 (2026-05-31 · Phase 0 audit `cc-audit-RULE-ARCH-PHASE0-001.md` §4 매핑 후보 + cli session 42-file 재측정 정합).
> **연관 파일**:
> - `workflow-core.md` §Intake Normalization — Reading Mode 7종 정의 source
> - `cycle-discipline.md` §2 (OPS 신설 원칙 · L1-1 예외) + §15 패턴 1 (master cycle + propagation) + §18~§19 (정기 review + self-improving loop)
> - `mode-system.md` — Mode(행동 layer) ↔ 본 색인 Reading Mode(행동 유형) 정합
> - `anchor-list.md` — L0 anchor 의 일부(A1·A2·A4 등) 본문 SoT
> - master `CLAUDE.md §5` — STOP 조건 canonical(L0 항상 적용)
> SOT: `CLAUDE.md`

---

## §0. 계층 본질 + 사용법

`.claude/rules/` 는 평면 폴더다(subfolder 0). 본 색인은 자신을 제외한 **46 rule** 을 그 평면 위에 **논리적 4층**으로 덮어 행동별로 무엇을 먼저 읽어야 하는지 가리킨다.

| 층 | 이름 | 로드 시점 | 본질 |
|---|---|---|---|
| **L0** | 불변 | 매 cycle 진입 시 항상 | 안전 / STOP / anchor / 단방향 propagation — 어느 행동이든 깔린다 |
| **L1** | 프로세스·워크플로우 | 작업을 시작할 때 | cycle 운영 / 검증 / 리뷰 / 보고 / 라우팅 / 정책 |
| **L2** | 프로그래밍 | code-level 행동에 진입할 때 | 코드 원칙 / 식별자 / design→code |
| **L3** | 도메인·팀 | 도메인 키워드가 잡힐 때 | Auth / Billing / Backend / Pencil / UI·UX |

사용 흐름: **(1)** Reading Mode 판정(`workflow-core.md` §Intake) → **(2)** §B 표에서 해당 행동의 의무 로드 집합 추출 → **(3)** L0 는 무조건 + 표가 가리키는 L1/L2/L3 subset 만 연다(§A 멤버 목록에서 file 진입). bulk read 금지(`CLAUDE.md §9`).

---

## §A. 계층 taxonomy (L0~L3 · 46 rule 배치)

> 각 file 옆 1줄 = 1차 목적(분류 문구). 본문은 해당 file 단일 SoT — 여기서 복제하지 않는다. (보호) = 보호 5종 byte-identical 영역.

### L0 — 불변 (항상 로드 · 3 rule + file 외 헌법)

| rule | 1차 목적 |
|---|---|
| [`safety-and-secrets.md`](./safety-and-secrets.md) | 금지 명령 / 금지 경로 / 시크릿·PII 기록 금지 / 역할별 경로 매트릭스 |
| [`anchor-list.md`](./anchor-list.md) | 누락 시 cycle 실패하는 10 anchor(A1~A10 · baseline drift / 보호 sha / scope / propagation 등) |
| [`cross-repo-parallel-exec.md`](./cross-repo-parallel-exec.md) **(kernel)** | 6-repo 단방향 propagation(A4) + subscription pool 정합(A6 · `claude -p` 회피 · billing) + 영역 1/2/3 1-줄 요약 + STOP/trigger · 실행 본문 = `cross-repo-parallel-exec-detail.md`(behavior-triggered · L1) |

> file 외 L0: master `CLAUDE.md §5`(STOP 9항 canonical) + 부모 mount root `CLAUDE.md`(6-repo umbrella). 두 헌법은 `.claude/rules/` 밖이라 본 46 집합에 포함되지 않으나 L0 로 항상 적용.

### L1 — 프로세스·워크플로우 (작업 시작 시 · 20 rule)

| rule | 1차 목적 |
|---|---|
| [`workflow-core.md`](./workflow-core.md) | 단계 흐름(intake→collect→plan→implement→verify→review) + Reading Mode 7종 정의 + Context Reset |
| [`cycle-discipline.md`](./cycle-discipline.md) | cycle 운영 표준 + commit 규약 + 환경 정합 §13 + 패턴 1~3 + §17~§29 |
| [`verification-and-review.md`](./verification-and-review.md) | /verify 0-command 금지 + REVIEW 12-section + Risk 경량화 + 복구 경로 |
| [`reporting.md`](./reporting.md) | 산출물 경로 + EVIDENCE/PLAN/VERIFY/REVIEW 스키마 + Subagent Return Contract §9 |
| [`routing-and-delegation.md`](./routing-and-delegation.md) | intake-router 위임 + Planner/Generator/Evaluator 경계 + cross-repo sub-section |
| [`mode-system.md`](./mode-system.md) | M1/M3/M5 행동 mode + Mode picker + 잘못 결정 recovery |
| [`automation-policy.md`](./automation-policy.md) | Transport 자동화 OK / Inspection 자동화 X + sub-agent spawn 금지 |
| [`plugin-policy.md`](./plugin-policy.md) | plugin 조건부 허용(공식+커스텀 불요) vs 회피(자식 차별화) 판단 기준 |
| [`workflow-policy.md`](./workflow-policy.md) | `Workflow` 도구(dynamic workflows) 조건부 허용 + gate 실측(pool 귀속/버전/활성화 전제) + 허용·회피 영역 + 200k 토큰 예산 통제 |
| [`legacy-cleanup-governance.md`](./legacy-cleanup-governance.md) | cleanup pass + 제거 허용 근거 + code removal vs file deletion STOP |
| [`working-file-lifecycle.md`](./working-file-lifecycle.md) | cc-paste / cycle-prompt 등 working file archive + frontmatter 3키 |
| [`recommended-option-disk-verification.md`](./recommended-option-disk-verification.md) | 추천/scope 결정 전 disk 실측 의무 (thin pointer → skill) |
| [`paste-authoring-disk-verification.md`](./paste-authoring-disk-verification.md) | paste source authoring 측 disk 실측 의무 (thin pointer → skill) |
| [`initiatives-auto-sync.md`](./initiatives-auto-sync.md) | INITIATIVES + INDEX + task file 갱신 의무 (thin pointer → skill) |
| [`libs-versions-cross-verify.md`](./libs-versions-cross-verify.md) | libs.versions.toml ↔ artifact ↔ import 3-source 사후 정합 |
| [`terminology.md`](./terminology.md) | SoT/SSOT 등 일반 어휘 단일 사전 |
| [`text-degeneration-prevention.md`](./text-degeneration-prevention.md) | 출력 token degeneration 3 metric + paraphrase 의무 |
| [`architecture-foundation-link-policy.md`](./architecture-foundation-link-policy.md) | architecture 문서 → app-foundation 실 path markdown link 의무 |
| [`cross-repo-parallel-exec-detail.md`](./cross-repo-parallel-exec-detail.md) | cross-repo 실행 본문(영역 1/2/3 + dispatch + 자식별 cwd 분리 + sub-agent token cost + 정합 처리) · cross-repo 행동 trigger 로드(= L0 kernel demote 본문) |
| [`gsm-measurement.md`](./gsm-measurement.md) | GSM 계측 canonical form(G/S/M 3-tuple) + DORA 4-key + Metric family 지도 + amend 정량 trigger · anchor/§C/context-health 정합 기준 · 계측·amend 시점 consult |

### L2 — 프로그래밍 (code-level 행동 시 · 5 rule)

| rule | 1차 목적 |
|---|---|
| [`code-style-guide.md`](./code-style-guide.md) | L2 단일 진입점 · 스타일 SoT pointer(포맷/축약/원칙/커밋/아키텍처) + 신규 안정 규칙(nullability · visibility · concurrency 노출) |
| [`code-principles.md`](./code-principles.md) | SOLID + DRY/KISS/YAGNI + 코드 리뷰 체크리스트(reviewer 자동 참조) |
| [`abbreviation-policy.md`](./abbreviation-policy.md) | 사용자 정의 축약 금지 seed + 허용 표준 약어 + hook 정합 |
| [`design-to-code-sync.md`](./design-to-code-sync.md) | Design SoT → Code 단방향 sync 도구 무관 패턴(5-type / Output Checklist) |
| [`design-prompting-paradigm.md`](./design-prompting-paradigm.md) | design 도구 agent prompt 4원칙(measurable / context / reference / iterative) |

> L2 인접 docs pointer(본문 X · 인용만): `KMP_CMP_LAYER_DIRECTION` · `MODEL_SEPARATION` · `ERROR_RESULT_POLICY` · `TESTABILITY_SEAMS` · `TDD_WORKFLOW` · `TESTING_STRATEGY` · `KOIN_DI_BASELINE` · `COMPOSE_STABILITY` — 각 자식 `docs/agent/architecture/**` 측 실본문. 본 색인은 가리키기만 한다. 테스트 3 docs 분담: `TDD_WORKFLOW`(언제 의무) · `TESTABILITY_SEAMS`(어떻게 가능) · `TESTING_STRATEGY`(무엇을 ROI 순·여러 케이스·지속 유지).

### L3 — 도메인·팀 (키워드 trigger 시 · 18 rule)

**도메인 정책 (5)**

| rule | 1차 목적 |
|---|---|
| [`auth-rules.md`](./auth-rules.md) | Supabase 익명 부트스트랩 + 토큰 저장 + JSON backup |
| [`supabase-handling.md`](./supabase-handling.md) | Edge Function / migration / RLS / Vault — CLI 자동 vs Dashboard 분기 |
| [`billing-rules.md`](./billing-rules.md) | Mock-first + Edge Function 영수증 검증 + entitlement |
| [`domain-roles.md`](./domain-roles.md) | 도메인 역할 navigation index(active/deferred agent 매핑) |
| [`deferred-domains.md`](./deferred-domains.md) | 미정의 도메인 통합 STOP + 활성화 trigger 매트릭스 |

**Pencil cluster (8)**

| rule | 1차 목적 |
|---|---|
| [`pencil-uiux-workflow.md`](./pencil-uiux-workflow.md) **(보호)** | Pencil 도구 바인딩 + 5-type IMPL + headless 평문-JSON 경로 위계 |
| [`pencil-automation.md`](./pencil-automation.md) | .pen 저장 자동화 (thin pointer → skill) |
| [`pencil-cli-headless.md`](./pencil-cli-headless.md) | CLI headless 진입점 (thin pointer → skill) |
| [`pencil-mcp-tools-reference.md`](./pencil-mcp-tools-reference.md) | 12 official + 1 package-verified MCP tool reference |
| [`pencil-pen-format-schema.md`](./pencil-pen-format-schema.md) | .pen format `"2.11"` schema + 13 Entity type |
| [`pencil-component-paradigm.md`](./pencil-component-paradigm.md) | reusable Component + ref Instance + descendants + slot |
| [`pencil-theme-multi-axis.md`](./pencil-theme-multi-axis.md) | themes multi-axis(mode/spacing/device) + Compose mapping |
| [`pencil-visual-primitives.md`](./pencil-visual-primitives.md) | Fill/Stroke/Effect/BlendMode/Flexbox/icon_font |

**UI·UX + design (4)**

| rule | 1차 목적 |
|---|---|
| [`ui-ux-analysis.md`](./ui-ux-analysis.md) | ux-auditor / ui-implementer 역할 + UI 라이브러리 억제 |
| [`ux-laws.md`](./ux-laws.md) | Laws of UX 30 → 권장 17 / 신중 12 / 비권장 1 + dark pattern 회피 |
| [`uiux-sot-refresh.md`](./uiux-sot-refresh.md) **(보호)** | `.ai/uiux-sot/latest/` refresh FULL/PARTIAL/DOC-ONLY 분류 |
| [`sot-code-name-map.md`](./sot-code-name-map.md) | SoT 화면명 ↔ Compose 코드 화면명 매핑(자식 GB/GD/GT · volatile) |

**Runtime (1)**

| rule | 1차 목적 |
|---|---|
| [`runtime-crash-mitigation-process.md`](./runtime-crash-mitigation-process.md) | Android runtime crash 9-step mitigation (thin pointer → skill) |

> **Perf = rule 부재**. 성능 도메인은 `.claude/rules/` 측 rule 이 없고 `.claude/agents/deferred/performance-reliability-engineer.md`(deferred agent)만 존재. L3 측 가짜 pointer 신설 금지 — 성능 키워드(ANR/메모리/leak/OOM) 진입 시 위 deferred agent + `deferred-domains.md §1` STOP 영역으로 라우팅한다.

---

## §B. 행동(Reading Mode 7종) → 의무 로드 규칙 집합

> Reading Mode = `workflow-core.md` §Intake Normalization 의 7종. 각 행동은 **L0 항상** + 아래 L1/L2/L3 subset 을 로드한다. L0 = `safety-and-secrets` + `anchor-list` + `cross-repo-parallel-exec` + master `CLAUDE.md §5`(이하 표에서 "L0" 로 축약).

| Reading Mode (행동) | 의무 로드(L0 항상 +) |
|---|---|
| **1. 구현형** (code-level) | L1: `workflow-core` · `cycle-discipline` · `verification-and-review` · `reporting` · `routing-and-delegation` · `legacy-cleanup-governance` · `mode-system`(M1/M3) · `libs-versions-cross-verify`(의존성 변경 시) / L2: `code-style-guide`(진입점) · `code-principles` · `abbreviation-policy` · 테스트 시 `TESTING_STRATEGY`(ROI·multi-case·피라미드)+`TDD_WORKFLOW`+`TESTABILITY_SEAMS` / L3: 키워드 시 도메인 정책(`auth-rules`·`billing-rules`·`supabase-handling`·`deferred-domains`) |
| **2. UI-UX형** | L1: `workflow-core` · `cycle-discipline` · `verification-and-review` · `reporting` / L2: `code-style-guide` · `design-to-code-sync` · `design-prompting-paradigm` · `code-principles` · 테스트 시 `TESTING_STRATEGY`(UI = Compose UI test/Roborazzi e2e 층) / L3: `ui-ux-analysis` · `ux-laws` · `uiux-sot-refresh`(보호) · `sot-code-name-map` + Pencil 사용 시 `pencil-uiux-workflow`(보호) 및 관련 Pencil cluster |
| **3. API-서버형** | L1: `workflow-core` · `cycle-discipline` · `verification-and-review` · `reporting` / L2: `code-style-guide` · `code-principles` · 테스트 시 `TESTING_STRATEGY`(Backend/Data = high-ROI · Repository+Fake/EF 계약) / L3: `supabase-handling` · `auth-rules` · `billing-rules` · `deferred-domains`(Backend/Data STOP) |
| **4. 빌드-릴리즈형** | L1: `cycle-discipline`(§13 환경 정합) · `libs-versions-cross-verify` · `initiatives-auto-sync` · `verification-and-review` · `reporting` · `working-file-lifecycle` |
| **5. 정책-계획 점검형** | L1: `workflow-core` · `cycle-discipline` · `mode-system` · `automation-policy` · `plugin-policy` · `workflow-policy`(Workflow 도구 채택 가부 시) · `recommended-option-disk-verification` · `paste-authoring-disk-verification` · `terminology` · `text-degeneration-prevention` · `architecture-foundation-link-policy` · `reporting` |
| **6. CLI 운영 레이어형** (cli-ops · M5) | L0 강조: `cross-repo-parallel-exec`(kernel · 단방향/subscription) · `safety-and-secrets`(보호 path) / L1: `cycle-discipline`(§3·§15) · `mode-system`(M5) · `automation-policy` · `reporting` · `working-file-lifecycle` · `recommended-option-disk-verification` · `paste-authoring-disk-verification` · `text-degeneration-prevention` · `gsm-measurement`(GSM 계측·amend 시) + **cross-repo 행동 시 `cross-repo-parallel-exec-detail`**(kernel demote 본문) |
| **7. task 재개-후속형** (task-resume) | L1: `workflow-core`(Context Reset / HANDOFF) · `reporting`(§9 Subagent Return) · `cycle-discipline`(§8 future context 회복) |

> L3 도메인 rule 은 키워드 trigger 가 본질이다(`deferred-domains.md §5` + 각 도메인 rule §STOP trigger). 위 표의 L3 항목은 "해당 키워드가 잡힐 때만" 로드한다 — 무조건 로드 아님.

---

## §C. 유연성 — 행동별 목표(GSM 3-tuple) + deviation + amend loop

> 행동별 목표 = [`gsm-measurement.md`](./gsm-measurement.md) canonical form 의 **G(의도) / S(관측 신호) / M(정량 지표)** 3-tuple. M = 측정 가능 판정 기준(= 기존 게이트·목표값 그대로 보존). deviation = 표준 집합에서 벗어날 때의 1줄 경로. amend loop = 색인/규칙 자체가 진화하는 통로. **G/S/M form 단일 SoT = `gsm-measurement.md`** (= 본 §C 는 그 form 에 정합 · 규약 본문 복제 X · `§G` SSOT 정합).

| 행동 | G (목표 의도) | S (관측 신호) | M (정량 지표 · 게이트 보존) | deviation 경로 |
|---|---|---|---|---|
| 1. 구현형 | 구현이 모델 경계·빌드 무결성·cleanup·고위험 커버리지를 충족 | 모델 분리 위반 / 빌드 exit / `## Cleanup Assessment` 섹션 / 고위험 변경의 ROI-coverage 테스트 존재 | 모델 분리 위반 0 + 빌드 exit 0 + `## Cleanup Assessment` 기록 존재 + 고위험(Auth/Billing/Data/Backend) 변경 behavior 에 ROI-coverage 테스트 존재(`TESTING_STRATEGY` §5·§10 · review §7 게이트 · enforce=warn) | 표준 외 rule 필요 시 PLAN `## 3. ArchitectureImpact` 에 근거 + reviewer 판정 |
| 2. UI-UX형 | UI 변경이 design SoT 선행(또는 deferred 등재)·테마 토큰 준수·UX Laws 검증을 충족 | `.pen` SoT 존재 또는 `DESIGN-DEBT.md` 등재 / theme 밖 하드코딩 / REVIEW §B 채움 | `.pen` SoT 선행 존재 **또는 `DESIGN-DEBT.md` 등재(deferred lane)** + theme 밖 hex/sp/dp 하드코딩 0 + REVIEW §B [UX Laws] + [Design SoT Sync] 채워짐 | `.pen` 부재 = Phase R 진입(`pencil-uiux-workflow §3 Type 3`) 또는 STOP · deferred 허용 시 = `DESIGN-DEBT.md` 등재 후 code-first(`uiux-sot-refresh` 분기) |
| 3. API-서버형 | 서버 변경이 secret 안전·EF 단일 진입점·RLS 검증을 충족 | secret 평문 / Edge Function 진입점 / RLS role별 SELECT | secret 평문 0 + Edge Function 단일 진입점 + RLS role별 SELECT 검증 | production push/RLS 첫 적용 = 사용자 명시 승인(`supabase-handling §3`) |
| 4. 빌드-릴리즈형 | 빌드·릴리즈가 의존성 정합·출시 상태 정합·승인된 push·출시 화면 design-debt 해소를 충족 | libs 3-source / INITIATIVES HEAD / production push 승인 / 출시 화면 `DESIGN-DEBT.md` OPEN | libs 3-source mismatch 0 + INITIATIVES HEAD 정합 + production push 승인 존재 + 출시 대상 화면 `DESIGN-DEBT.md` OPEN 0(release backstop) | 검증 명령 불가 = `UNKNOWN(사유)` + STOP(`verification-and-review`) |
| 5. 정책-계획 점검형 | 정책·계획이 disk 실측 근거·표현 건강·단일 SoT 를 충족 | disk 실측 인용 / degeneration M1·M2·M3 / 단일 SoT 중복 | disk 실측 인용 존재 + degeneration metric(M1/M2/M3) PASS + 단일 SoT 중복 0 | 신 rule 도메인 매칭 실패 = `cycle-discipline §2`(OPS 신설 금지) 또는 L1-1 예외 본심 회수 |
| 6. CLI 운영 레이어형 | cli infra 변경이 보호 무결성·production 무접촉·6-repo 정합을 충족 | 보호 5 sha / production touch LOC / 6-repo byte-identical | 보호 5 file sha 변동 0 + production code touch 0 LOC + 6-repo byte-identical | 보호 sha drift / 자식 cli infra 직접 수정 징후 = 즉시 STOP(`CLAUDE.md §5` #5·#6) |
| 7. task 재개-후속형 | 재개가 HANDOFF 우선·최소 read·직전 상태 정합을 충족 | HANDOFF read 순서 / bulk read / 직전 PASS 정합 | HANDOFF.md 우선 read + bulk read 0 + 직전 PASS 단계와 정합 | reset 금지 조건(verify 진행 중·STOP 신호·계약 미완) 시 reset 보류(`workflow-core`) |

**amend loop (색인·규칙 진화 통로)**: 행동 수행 중 "기존 규칙으로 안 잡히는 반복 패턴"을 발견하면 `cli infra rule candidate` 로 누적한다. 자동 신설하지 않는다 — `cycle-discipline §19`(stop-reflect.sh self-improving loop · silent 후보 제안) + `§18`(분기 정기 review cadence) + `automation-policy §1.2`(자동화 직후 calibration 강화) 를 통해 사용자 confirm 후 master cycle 로 정착시킨다(`cycle-discipline §2` L1-1 예외 = 사용자 본심 외화 영역만 신 rule 허용). **정량 trigger** (= [`gsm-measurement.md §6`](./gsm-measurement.md)): 동일 행동/anchor 의 M 이 **N(기본 3) cycle 연속 deviation** 이면 amend 후보로 승격한다(= `stop-reflect.sh` 임계 정합 · 게이트 X · 사람 판단 신호).

---

## §D. 갱신 규약

1. **신 rule 신설 시**: 본 색인 §A 해당 층 표에 1행 추가(file link + 1차 목적 1줄) + 그 rule 이 특정 행동의 의무 집합을 바꾸면 §B 표 해당 행 갱신. 본문 복제 금지(pointer only).
2. **rule 이동/통합/폐기 시**: §A 행 제거 또는 이동 + §B 의존 행 동기. 통합(예: 3 file → 1 SoT)은 흡수 후 단일 행으로 정리.
3. **층 재배치 판단**: L0/L1/L2/L3 경계가 모호하면 "로드 시점"으로 판정(항상=L0 / 작업 시작=L1 / code-level=L2 / 키워드 trigger=L3). 재배치는 본 색인 1 file 변경으로 끝난다 — 물리 이동·frontmatter 불요.
4. **갱신 trigger**: 신 rule 신설 cycle 마감 시 + `cycle-discipline §18` 분기 review 시 + Reading Mode 정의(`workflow-core` §Intake) 변경 시.
5. **(선택) verify hook pointer**: 본 색인 §A 멤버 수 + 색인 자신 1 = `find .claude/rules -type f -name '*.md' | wc -l`(현재 46 + 1 = 47) 정합 검증을 분기 review(`cycle-discipline §18`) 측 측정 항목으로 둘 수 있다(자동 hook 신설은 별 cycle).
6. **frontmatter 표준화 = 본 cycle 비포함**: 42 file 에 `layer:` frontmatter 일괄 부여는 자식 propagation cascade + 보호 resync 를 동시에 trigger 하므로 별 의제. 본 색인의 수기 유지가 `cycle-discipline §2`(양 최소·변동성 회피) 측 default.

---

## §E. propagation 정책

- 본 file = cli infra **권장 byte-identical** 영역(`.claude/rules/` · 보호 5종 아님 · `cycle-discipline §3`). 42 rule 이 6-repo byte-identical 이므로 본 색인도 6-repo 에서 동일하게 유효 → `propagate.sh` 대상.
- **본 cycle(RULE-ARCH-PHASE1-001) = master 신설 only**. 5-repo byte-identical propagation = 별 follow-up cycle(`MASTER-CLI-RULE-ROUTING-INDEX-PROPAGATE-NNN` 가칭 · `cycle-discipline §15` 패턴 1). 자식 직접 수정 금지(`CLAUDE.md §4`).

---

## §F. 명시 cycle 이력

- 2026-05-31 · RULE-ARCH-PHASE1-001 · 본 색인 신설(L0 3 + L1 17 + L2 4 + L3 18 = 42 배치 + Reading Mode 7종 라우팅 표 + GSM 목표/deviation + 갱신 규약). 진입 HEAD `f759954`(authoring baseline `c7e03c9` 대비 2 commit 전진 · 사용자 reconcile 승인). 기존 42 file 본문 + 보호 5종 sha 무변경(신 file 1건 only). Phase 0 audit `cc-audit-RULE-ARCH-PHASE0-001.md` §4 후보 + cli 재측정 정합(sot-code-name-map = audit L1 후보 → 본 색인 L3 재배치: 키워드 trigger + 자식 화면 volatile + 해당 file staleness 배너의 "L3 도메인층" 자기 귀속 근거).
- 2026-05-31 · RULE-ARCH-PHASE2-001 · `code-style-guide.md`(L2) 신설 → §A L2 표(4→5 rule) + §B 구현형/UI-UX형/API-서버형 행에 1행 등록. Phase 1 commit `5cb9cdd` 후속. §C: 하드 규칙 3 채택(nullability · visibility · concurrency 노출) + 식별자 case 후퇴 + scope function 가이드라인 + 4 후보 탈락(원칙 4). §B 행 6(CLI 운영)은 제외 — L2 Kotlin 스타일은 bash/md cli-infra ops 에서 로드되지 않음(일관성).
- 2026-05-31 · RULE-ARCH-PHASE3-001 · SSOT 5건 dedup(중복 본문 → canonical pointer · 정보 손실 0) + §G SSOT ownership map 신설. canonical grow-only merge 2건(MODEL_SEPARATION §2 ← UseCase·I2 내부 의존 / verification-and-review /verify ← native `/verify`). 편집 6 file(workflow-core · KMP_CMP_LAYER_DIRECTION · TDD_WORKFLOW · SSOT_PRINCIPLES · reviewer · 본 색인). 진입 HEAD `7277a6d`(Phase 2 step-0 commit). 보호 5종 무변동.
- 2026-05-31 · RULE-ARCH-PHASE4-001 · §H consult·enforce·amend 워크플로우 연결 신설 + `workflow-core.md`(intake/implement consult 1줄씩) + `code-style-guide.md`(editorconfig advisory + L2 enforcement=warn) wiring. 최소 wiring(추가만 · 기존 본문 삭제 0). RULE-ARCH 프로그램 마지막 master cycle. Phase 3 commit `31837ad` 후속.
- 2026-06-01 · MASTER-CLI-GUIDANCE-ROUTING-001 · §I 행동→지침(docs) 라우팅 신설(§H 뒤 · pointer only · 7행 표). 비-rule process/workflow/template 지침(DOC_GOVERNANCE/DOC_TASK_TYPES/REPO_FIRST_INTAKE/COMMIT_CONVENTION/DEPENDENCY_DECISION_CHECKLIST/ADR_TEMPLATE/PROPAGATION_PARAMETERS/PROMPTFIT_RUBRIC/templates 8)을 행동 시점 behavior-routed 로 표면화(GAP-2 docs 판). 대상 docs 실존 disk 검증 PASS · 지침 본문 복제 0 · 기존 §A~§H 무변경 · 보호 5종 무접촉. 진입 HEAD `b2a138e`.
- 2026-06-01 · MASTER-CLI-CONTEXT-OPT-PHASE3-L0-CHILD-DEDUP-001 · (H4) §A L0 `cross-repo-parallel-exec.md` = kernel 표기(subscription/단방향/영역 요약 잔류) + L1 `cross-repo-parallel-exec-detail.md` 신설 등록(17→18 rule · 43→44 · 색인 자신 포함 45) + §B Reading Mode 6 cross-repo 행동 시 detail 로드. L0 always-load 본문 demote(삭제 0 · 18.2K→kernel 8.2K + detail 12.6K). 보호 5종 무접촉.
- 2026-06-01 · MASTER-CLI-TESTING-STRATEGY-001 · 테스트 전략 layer 배선. §A L2 pointer 줄에 `TESTING_STRATEGY` 추가(테스트 3 docs 분담 1줄: TDD_WORKFLOW=언제 / TESTABILITY_SEAMS=어떻게 / TESTING_STRATEGY=무엇을 ROI 순·여러 케이스·지속 유지) + §B 구현형/UI-UX형/API-서버형 3행 L2 에 `TESTING_STRATEGY` 테스트 pointer 추가 + §C 구현형 GSM 에 "고위험 변경 ROI-coverage 테스트 존재(enforce=warn)" 목표 1행 보강. 신 본문 0(pointer only · `docs/agent/architecture/TESTING_STRATEGY.md` 단일 SoT) · 기존 §A~§I 행 무삭제 · 보호 5종 무접촉. 동반: `test-strategist` deferred→active 재활성 + review-task §7 ROI/multi-case/피라미드 확장. 5-repo byte-identical propagation.
- 2026-06-02 · MASTER-CLI-GSM-MEASUREMENT-LAYER-001 · GSM 계측 layer canonical 신설 + §C realign. **(§C realign)** 행동 7종 "복합 Goal 체크리스트" → G(의도)/S(관측 신호)/M(정량 지표) 3-tuple 재구성 (= `gsm-measurement.md` form 정합 · 3열→5열 표). **의미·강도 보존**: 모든 게이트(enforce=warn · `TESTING_STRATEGY §5·§10` · review §7) + deviation 경로 + 고위험 ROI-coverage 목표 = M 열 verbatim 보존 (= 형식 GSM 정합 · 약화 0). **(§A 등록 · Phase 3)** L1 표에 `gsm-measurement.md` 1행 추가(18→19 rule) + §0/§A 헤더/§D count reconcile(44→45 rule · §A 헤더 43→45 = pre-existing -1 stale[sub-header 합 44] + 본 cycle +1 · find 실측 정합 · 색인 자신 1 = 46). **(§B)** Mode 6(CLI 운영) L1 에 `gsm-measurement` consult 추가. **(amend 정량 trigger · Phase 4)** §C amend loop 단락에 "N(기본 3) cycle 연속 deviation → amend 후보 승격"(= `gsm-measurement.md §6` · `stop-reflect.sh` 임계 정합) pointer 추가. 신 본문 규약 복제 0(`gsm-measurement.md` 단일 SoT) · 기존 §A~§I 행 무삭제 · 보호 5종 무접촉. 5-repo byte-identical propagation.
- 2026-06-02 · MASTER-CLI-DEPENDENCY-DECISION-RECONCILE-001 · §G SSOT map +2 row(6→8): **(7)** DependencyDecision 8항 → canonical `DEPENDENCY_DECISION_CHECKLIST.md` (= `code-principles` Android 빌드/보안 축(라이센스·CVE·APK/Bundle·ProGuard/R8·제거 절차·직접구현 LOC) grow-only merge → canonical ②④⑥⑦ 하위 기준 흡수 · workflow-core/code-principles 8항 본문 → pointer · **8 first-class 항 불변**(PLAN 스키마·compound-lint 게이트 정합)) · **(8)** UI 라이브러리 억제 → canonical `ui-ux-analysis.md §UI 라이브러리 억제 기본값` (= 가장 강한 게이트 "직접 구현 우선 default + 외부 UI 라이브러리 도입 금지 default + Coin 승인 필수" 채택 + 비대칭(억제=UI 한정·인프라 8항 허용)/UI-vs-인프라 판별 테스트 신설 + per-category(차트/애니/컴포넌트/이미지/Markdown) 보존 · CHECKLIST §3·code-principles UI·CLAUDE.md §10 → pointer). `conflicting_sot` 1→0(`context-health-metrics.md` master-only). 신 본문 0(canonical merge·pointer only · 정보 소실 0 · UI 강도 보존) · 기존 §A~§I 행 무삭제 · 보호 5종 무접촉. 진입 HEAD `f4691c2`. 5-repo byte-identical propagation(CHECKLIST + workflow-core + code-principles + ui-ux-analysis + rule-routing-index).
- 2026-06-04 · MASTER-CLI-WORKFLOW-ADOPTION-POLICY-002 · §A L1 표에 `workflow-policy.md` 1행 추가(19→20 rule) + §0/§A 헤더(45→46) + §D #5 count(45+1=46 → 46+1=47) reconcile(= `find` 실측 46 file + 색인 자신 1 = 47 정합) + §B Reading Mode 5(정책-계획 점검형) L1 에 `workflow-policy` consult 추가. 동반(별 file): `workflow-policy.md` 신설(= `cross-repo-parallel-exec.md §2.4.1` 본문 이관·유실 0 + 채택 정책 전반 완성) + §2.4.1 = 1줄 kernel pointer 환원(L0 de-bloat · BILLING-GUARD-001 의 H4 역행 교정). 신 본문 복제 0(pointer only) · 기존 §A~§I 행 무삭제 · 보호 5종 무접촉. 5-repo byte-identical propagation(workflow-policy + cross-repo-parallel-exec + rule-routing-index).
- 2026-06-18 · MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001 · §C realign(신 행 0 · M/S/deviation 칸 보강): row 2(UI-UX형) M 에 "`.pen` SoT 선행 존재 **또는 `DESIGN-DEBT.md` 등재(deferred lane)**" + REVIEW [Design SoT Sync] term + deviation 에 deferred 분기 1줄 · row 4(빌드-릴리즈형) M 에 "출시 대상 화면 `DESIGN-DEBT.md` OPEN 0(release backstop)" term. design SoT(`.pen`/`.ui-spec`) "즉시 의무 vs deferred(design-debt)" 기준 명확화 + enforce wiring cycle 의 일부(보호 2 `uiux-sot-refresh.md` split 표/게이트 재배선·`design-sot-policy.md` §3 deferred 예외 + cli-infra `design-to-code-sync.md` §10 Deferred Design Debt lane·`verification-and-review.md` §14 Design SoT Sync row+release backstop·`reporting.md` §7 §14 스키마). 신 REVIEW row token "Design SoT Sync" = 3곳(verification-and-review §14 ↔ reporting §7 §14 ↔ 본 §C row 2/4) 정합. §A/§I pointer 무추가(`design-to-code-sync.md` 이미 §A L2 등록 = lane home reachable · 본문 복제 0) · 기존 §A~§I 행 무삭제. 보호 5종 중 2종 의도적 변경(manifest resync 동반). 6-repo byte-identical propagation.

---

## §G. SSOT ownership map (= 동일 사실의 단일 canonical · RULE-ARCH-PHASE3-001)

> 같은 사실이 여러 file 에 중복되던 8건을 단일 canonical 로 확정하고 과거 중복측을 pointer 로 후퇴시켰다. 사실 → canonical(소유) → 과거 중복측(now pointer). 새 중복 발견 시 canonical 로 merge(grow-only) 후 pointer(§D amend loop 정합).

| # | 사실 | canonical (소유) | 과거 중복측 (now pointer) |
|---|---|---|---|
| 1 | Model 경계 변환 (DTO/Entity/DomainModel/UiState) | `docs/agent/architecture/MODEL_SEPARATION.md` | `workflow-core.md` §모델분리·경계매핑 · `KMP_CMP_LAYER_DIRECTION.md §4` |
| 2 | 테스트 심(seam) | `docs/agent/architecture/TESTABILITY_SEAMS.md` | `TDD_WORKFLOW.md §4` |
| 3 | 운영↔제품 레이어 경계 | `docs/agent/architecture/COMMON_ARCHITECTURE.md §1` | `SSOT_PRINCIPLES.md §4` (경계 정의분만 · SSOT/drift framing 고유 보존) |
| 4 | /verify · /review 규칙 | `.claude/rules/verification-and-review.md` | `workflow-core.md` §/verify·§/review (hub 1줄 + pointer) |
| 5 | 코드 리뷰 12-section 체크리스트 | `.claude/rules/verification-and-review.md` §"12-section 체크리스트" | `reviewer.md` Expected outputs (→ pointer + 역할 고유 보존) · `code-principles.md §4` (기존 pointer 유지) |
| 6 | SoftBudget (Risk별 LOC budget 200/120/60) + Risk 기반 산출물 경량화 | `.claude/rules/workflow-core.md §implement` | `mode-system.md` M1 Verification policy + §7 (→ pointer · 이전 `code-principles.md §SoftBudget` = 부재 § stale pointer 정정 · MASTER-CLI-CONTEXT-OPT-PHASE4-SSOT-SWEEP-METRICS-001) |
| 7 | DependencyDecision 8항 (libs.versions.toml 신규 의존성 판정) | `docs/agent/architecture/DEPENDENCY_DECISION_CHECKLIST.md` | `workflow-core.md §신규 의존성 승인` (→ 게이트 REVIEW FAIL·git diff 실측 감지(구 compound-lint 8c = deprecated)·PLAN §2 위치만 + 8항 pointer) · `code-principles.md §신규 의존성 도입 의무` (→ 코드 원칙 맥락 pointer · Android 빌드/보안 축 고유 차원 = canonical ②④⑥⑦ 하위 기준 grow-only 흡수 · 8 first-class 항 불변) |
| 8 | UI 라이브러리 억제 / 직접 구현 우선 | `.claude/rules/ui-ux-analysis.md §UI 라이브러리 억제 기본값` | `DEPENDENCY_DECISION_CHECKLIST.md §3` (→ pointer · ⑧ 게이트 항만 유지) · `code-principles.md §UI 라이브러리 억제 default` (→ pointer) · master `CLAUDE.md §10` (→ pointer) |

> 형식 vs 기준 분리: REVIEW.md 채우는 **형식 스키마** SoT = `reporting.md §7` · **체크리스트(판정 기준 + 블로커)** SoT = `verification-and-review.md`. 둘은 별개 canonical.

---

## §H. consult · enforce · amend 워크플로우 연결 (RULE-ARCH-PHASE4-001)

> Phase 1~3 산출(본 색인 + `code-style-guide.md` + SSOT dedup)을 실 워크플로우에 연결한다. **확인**(행동 시 색인 consult) → **강제**(warn 수준 · 차단 X) → **개선**(미커버 → amend loop). 최소 wiring(§D·원칙 1) — 신 본문 없이 기존 SoT 를 가리킨다.

| 단계 | 어디서 | SoT pointer |
|---|---|---|
| **확인 (consult)** | 행동 판정 직후 — `workflow-core.md` Intake(Reading Mode 판정) + implement step | 본 색인 §B 라우팅 표 (L0 항상 + L1/L2/L3 subset · bulk read 금지) |
| **강제 (enforce)** | **warn 수준** (차단 X · 신 blocking gate 신설 X · 사용자 본심) | `code-style-guide.md` §A(enforcement=warn) + `check-abbreviation.sh` + `post-edit-degeneration-check.sh` (기존 warn hook) |
| **개선 (amend)** | 색인·가이드 미커버 또는 충돌 발견 시 | `cycle-discipline.md §18`(분기 review) + `§19`(stop-reflect self-improving) + `automation-policy.md §1.2`(calibration) + cowork memory `project_cli_infra_rule_candidates` + 본 색인 §C/§D deviation |

> enforce = warn default 본심: advisory + 기존 warn hook 으로 강제하고 blocking gate 는 신설하지 않는다. 빌드 강제화(ktlint warn-gate 등)는 별 후보 cycle(`MASTER-CLI-KTLINT-WARN-GATE-NNN`).

---

## §I. 행동 → 지침(docs) 라우팅 (= 비-rule 지침 behavior 표면화 · MASTER-CLI-GUIDANCE-ROUTING-001)

> §B 는 행동→**rule** 라우팅. 본 §I 는 행동→**지침(docs/agent/** + templates)** 라우팅 — rule 이 아닌 process/workflow/template 지침을 행동 시점에 표면화한다. architecture 지침(13)은 §A L2 pointer + §G SSOT map 으로 이미 라우팅되므로 본 표는 **비-architecture 지침** 한정. pointer only(본문은 각 docs 단일 SoT).

| 행동(지침 작업) | 의무 로드 지침 | 위치 |
|---|---|---|
| 제품 기획 · 기능·화면 신설 · 수익화·가격·티켓 정책 결정 | `PRODUCT-VISION-SOT` → `PRODUCT-PRINCIPLES-SOT` → `PRODUCT-STRATEGY-SOT` (효력 위계 순 병기 · 충돌 시 상위 우선) | `../gently-product-docs/docs/` |
| 분기 OKR 설정 · 채점 · 진척 갱신 · 북극성 확정 마감 | `OKR.md` (+ 전략 SoT §9 갱신 거버넌스 병기 · 전략 하위 live 분기 운영 층 = 박제 허용 영역) | `../gently-product-docs/docs/` |
| 문서/지침 작성·수정·드리프트 감사 | `DOC_GOVERNANCE_WORKFLOW` + `DOC_TASK_TYPES` + `REPO_FIRST_INTAKE_WORKFLOW` | `docs/agent/process/` |
| commit 메시지 작성 | `COMMIT_CONVENTION` | `docs/agent/process/` |
| 신규 의존성 추가(libs.versions.toml) | `DEPENDENCY_DECISION_CHECKLIST`(8항목) | `docs/agent/architecture/` |
| 아키텍처 결정 기록 | `ADR_TEMPLATE` | `docs/agent/architecture/` |
| cli infra propagation | `PROPAGATION_PARAMETERS` + master `CLAUDE.md §5` | `docs/agent/architecture/` |
| prompt/산출물 품질 점검 | `PROMPTFIT_RUBRIC` | `docs/agent/solutions/` |
| 신 도메인 산출물 작성 | 해당 `*.template.md`(api-spec / data-model / screen-flow / setup-guide / billing / release-checklist / ai-prompt-guide / pencil-dev-prompt) | `docs/templates/` |

> architecture 13 지침(Model/Error/Testability/TDD/KOIN/Compose/COMMON_ARCH/SSOT_PRINCIPLES/LEGACY 등)은 §A L2 pointer + §C deviation + §G SSOT map 에 이미 routed — 본 §I 중복 등록 X(원칙 1). 자식 repo-local 지침(implementation-guide / setup / plan 등)은 자식 `CLAUDE.md` + `DOC_GOVERNANCE_WORKFLOW` 관할(별 영역).
> **cross-repo pointer 주의**: `PRODUCT-VISION-SOT` / `PRODUCT-PRINCIPLES-SOT` / `PRODUCT-STRATEGY-SOT` + `OKR.md` 행의 위치 `../gently-product-docs/docs/` = sibling 상대 경로다. 본 색인이 6-repo byte-identical 로 배포되므로 어느 repo cwd 에서도 유효하다(master-relative `docs/...` 금지). 세 SoT(비전 → 원칙 → 전략 = 효력 위계 · 충돌 시 상위 우선) + OKR(전략 하위 live 분기 운영 층) = GB·GD·GT 공통 상위 제품 헌법(`gently-product-docs`)이자 rule 아닌 docs 지침 → §I 관할.
> **SoT 변경 → 하위 task drift 검출 의무** (추적 2-세계 분리 차단): 위 제품 SoT(`PRODUCT-VISION-SOT` / `PRODUCT-PRINCIPLES-SOT` / `PRODUCT-STRATEGY-SOT`) **변경 행동** 시 → 하위 3앱(GB·GD·GT) 출시 task 층(`docs/release-readiness/INITIATIVES.md` §3 · 개념 = INITIATIVES) 정합(drift)을 1줄 검출한다. SoT 변경분이 하위 출시 task 와 충돌하면(예: 전략 결제 모델 변경 ↔ §3 박제 task) 해당 task 를 재정의 후보로 표면화 — SoT 변경이 하위 task 에 미전파되는 drift 를 차단한다. **SoT 본문 편집 아님**: §3 출시 task 층을 *가리키는* 검출 의무만(SoT 4층 본문 = `gently-product-docs` 단일 SoT · 본문 복제 0). 검출 후 정합 mechanics = [`initiatives-sync` skill](../skills/initiatives-sync/SKILL.md) ④ KR 귀속 gate.
