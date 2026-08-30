# Workflow Core Rules

> **단일 목적**: 모든 task 의 단계 흐름 + 각 단계 (intake / collect / plan / implement / verify / review) 규칙.
> **분할 출처**: 기존 workflow.md (662 줄) 의 line 1~340 발췌 (C2-RULES-RESTRUCTURE-001).
> **연관 파일**:
> - `cycle-discipline.md` — Cycle Discipline §1~11 + §13~14a (4-repo 정합 / commit 표준 / 환경 정합)
> - `pencil-automation.md` — Pencil .pen 저장 자동화 (§12)
> - `verification-and-review.md` — /verify 와 /review 세부 규칙
> SOT: `CLAUDE.md`

---

> 이 규칙은 모든 태스크에 적용되는 단계 흐름 규약이다.
> SOT: `CLAUDE.md` | 세부 검증 규칙: `verification-and-review.md`

---

## 단계 흐름

```
intake normalization → /collect → /plan → implement → cleanup pass → /verify → /review → DONE 또는 replan
```

구현 변경이 있을 때:
```
implement → cleanup pass → Pre-DocSync Verify(PASS) → DocSync → /verify → /review → DONE
```

- **cleanup pass** 는 구현 완료 직후, verify 전 단계다. code-level task 는
  `docs/rules/legacy-cleanup-governance.md` 에 따른 cleanup assessment 를 EVIDENCE.md 에
  남기고 dead code / 미사용 참조 / 중복 포맷터 경로 / 교체된 구 버전 mapper 등을 제거 또는
  `TODO.md` 에 deferred 로 적는다.
- **DocSync** 는 cleanup pass + Pre-DocSync Verify PASS 이후, `/verify` 진입 전 단계다.
  갱신 대상 영역 = `.ai/reports/<taskId>/*.md` task 산출물 + `docs/agent/` 운영 레이어 문서 +
  **자식 repo 출시 docs 영역** (= `docs/release-readiness/INITIATIVES.md` + `docs/CLAUDE.md`
  또는 자식 root `CLAUDE.md` + `docs/setup/*`). 자식 출시 docs 갱신 본 paradigm =
  `MASTER-CLI-DOCS-AUTOSYNC-PARADIGM-001` 안 영구 정착. 세부 본문 = `cycle-discipline.md`
  §20 + `.claude/agents/active/docs-change-communicator.md` Key questions.
- ops-layer task 는 cleanup pass 를 `N/A (ops-layer task)` 로 EVIDENCE.md 에 명시한다.
- **낡은 문면 등재**: 요청 확인 / 조사 / 구현 각 단계에서 문면↔실물 갈림을 발견하면 `<repo>/STALE-DEBT.md` 에
  1행 등재한다 (**등재하면 진행 허용** — 이 의무는 cycle 을 멈추지 않는다 · 이력·박제 문면은 대상 밖).
  본문 = `docs/rules/stale-artifact-tracking.md`.
- verifier 또는 reviewer가 reject하면 → change-planner/system-architect 단계로 되돌린다.

---

## Context Reset Policy (long-running task)

장기 실행 세션에서는 context window 가 가장 먼저 고갈된다. compaction 으로 문맥을 이어가는
것보다 **명시적 context reset** 후 HANDOFF 문서로 재진입하는 것이 품질이 높다. reset 은
"실패 신호" 가 아니라 정상 운영 신호다.

### 언제 reset 을 선택하는가

- 현재 세션이 compaction summary 1 회 이상을 거쳤고, 남은 작업이 새 단위 구현인 경우
- 대용량 파일을 bulk read 하다가 token budget 이 빠르게 줄어드는 경우
- implementer 가 이전 단계에서 결정된 세부 맥락을 이미 PLAN / EVIDENCE 로 고정한 경우
- 하위 단계 (구현 1 단위, 검증, 리뷰) 가 독립적으로 진행 가능한 경우

### reset 재진입 읽기 순서

1. `.ai/reports/<taskId>/HANDOFF.md` (존재하면 **가장 먼저**) — 현재 상태, 남은 TODO, 다음
   단계 진입 조건이 2k token 이내에 요약되어 있어야 한다.
2. `.ai/tasks/<taskId>.md` — 요구사항과 성공 조건.
3. 필요한 섹션만 `.ai/reports/<taskId>/{EVIDENCE,PLAN,VERIFY,REVIEW,TODO}.md` 에서 발췌
   읽기. **bulk 전수 읽기 금지**.
4. touched files — 이번 단계에서 실제로 편집할 파일만.

### HANDOFF.md 작성 원칙

- 2k token 이하 요약. 긴 인용은 파일 path pointer 로 대체.
- 섹션: **Current Status** / **Last Verified State** / **Remaining Work** / **Next Entry
  Conditions** / **Known Risks**.
- HANDOFF.md 자체가 EVIDENCE/PLAN 을 대체하지 않는다. 이미 작성된 artifact 의 "읽을 만한
  단일 진입점" 역할.
- HANDOFF.md 가 없으면 기존 EVIDENCE/PLAN 에서 발췌 읽기. 여전히 bulk read 는 피한다.

### HANDOFF.md YAML 프런트매터 표준

HANDOFF.md는 선택적 YAML 프런트매터를 가질 수 있다. 프런트매터가 있으면
resume-task 재진입 시 파싱 우선순위가 높아진다.

```yaml
---
taskId: GB-UI-001
status: IMPLEMENT          # COLLECT / PLAN / IMPLEMENT / VERIFY / REVIEW / STOP / BLOCKED
lastVerifiedStep: PLAN     # 마지막으로 PASS된 단계
remainingSteps: 3          # 남은 작업 단위 수
blockers: []               # 빈 배열이면 블로커 없음
nextEntry: implementer     # 다음 진입 역할
riskFlags:
  MoneyAuth: false
  DBMig: false
  scopeExpansion: false
createdKST: "2026-04-10 14:30"
---
```

프런트매터가 없으면 기존 마크다운 섹션(Current Status / Last Verified State /
Remaining Work / Next Entry Conditions / Known Risks)만으로 동작한다.
프런트매터와 본문 섹션이 모두 있으면 프런트매터가 빠른 파싱용, 본문이 상세 맥락용이다.
둘의 내용이 충돌하면 **본문 섹션이 우선**한다 (프런트매터는 요약).

### Reset 금지 조건

- verify/review 진행 중 (Evaluator 판정이 완료되지 않은 상태)
- STOP 신호가 있는 상태 (MoneyAuth, DBMig, 비가역 변경 징후 등)
- pre-EVIDENCE 계약이 미완성인 상태 (implementer 진입 전이면 계약부터 먼저)

관련: `.claude/commands/resume-task.md` (reset 후 재진입 엔트리), `docs/rules/reporting.md` §9
(Subagent Return Contract — 하위 호출 결과 요약 규칙).

---

## Intake Normalization 규칙

프롬프트 수신 직후 아래를 먼저 판정한다:

- Work Type: 구현 / 조사 / 문서 / 검증 / 리뷰 / 운영 레이어 변경
- Reading Mode: 구현형 / UI-UX형 / API-서버형 / 빌드-릴리즈형 / 정책-계획 점검형 / CLI 운영 레이어형 / task 재개-후속형
- Requirement Source 충족 여부
- Authority Boundary
- 정보 공백: `RESOLVABLE_IN_REPO` / `UNKNOWN` / `BLOCKED`
- STOP 위험
- 필요한 read-only fan-out
- implementer 진입 가능 여부
- ★**배경 재진술** — 태스크의 `## 배경`(또는 발주 `§0`)을 읽고 **자기 말 1 문단**으로 되짚었는가 (= ⑴ 목적 ⑵ 상위 목표 **좌표** 지목 ⑶ 이 태스크가 **아닌** 것). ★**「읽었다」 선언은 판정이 아니다** — 「읽었나」는 검증 불가하고 **「되짚었나」는 검증 가능**하다. **verbatim 복붙 = 미이행**(안 읽은 것과 구별되지 않는다).
  - 배경 절이 **없는** 태스크 = **`RESOLVABLE_IN_REPO`** 로 분류하고 **먼저 채운다**. ★**추론으로 메우지 않는다** — 그 메움이 곧 할루시다. 채울 근거가 repo 에 없으면 **`UNKNOWN`**(+ 확인 위치).
  - 형식 SoT = [`reporting.md §3`](./reporting.md) `## 배경` · 발주 측 대응 칸 = [`disk-verification/SKILL.md`](../../.claude/skills/disk-verification/SKILL.md) §4 ⑥ 세부 **6** + ⑦ 세부 **3**.

> **Reading Mode consult**: 판정된 Reading Mode 의 의무 로드 규칙 집합 = [`rule-routing-table.md`](../../.claude/rules/rule-routing-table.md) 에서 consult 한다 (= L0 + 해당 L1/L2/L3 subset 만 · bulk read 금지 · index 전문 정독 = 색인 갱신 cycle 한정 · T2).

task-aware reading order와 공통 intake 절차:
`docs/agent/process/REPO_FIRST_INTAKE_WORKFLOW.md`

구현 또는 문서 수정이 있는 task는 intake normalization 결과를
`EVIDENCE.md` 의 pre-EVIDENCE 계약으로 먼저 남긴다.

---

## /collect 규칙

- **제품 파일 변경 금지** (운영 레이어 파일 포함)
- 검색·수집만 수행 (Read, Glob, Grep 전용)
- **0 matches도 반드시 기록** (부재 증거는 양성 증거와 동등)
- 제외 경로: `build/`, `.gradle/`, `generated/`, `.git/`, `app/build/`
- 수집 결과 → `.ai/reports/<taskId>/EVIDENCE.md`
- `EVIDENCE.md` 는 사후 요약이 아니라 implement 진입 전 계약을 먼저 포함한다

### 수집 대상 (우선순위)
1. `CLAUDE.md`, `.claude/rules/`, `.claude/agents/`
2. `.ai/tasks/INDEX.md`, 기존 관련 보고서
3. 제품 개요: `docs/CLAUDE.md` + 제품 상위 SoT (`../toward-product-docs/docs/PRODUCT-VISION-SOT.md` → `PRODUCT-PRINCIPLES-SOT.md` → `PRODUCT-STRATEGY-SOT.md` · sibling 상대경로 · rule-routing-index §I)
4. 아키텍처: `docs/agent/architecture/**`
5. 실제 소스 파일 (요구사항 관련 영역)

---

## /plan 규칙

- 수집 근거를 바탕으로만 계획 작성 (근거 없는 추정 금지)
- **ChangeBudget 표 필수 포함** (CLAUDE.md 형식 준수)
- VerifyCmds: 1개 선호, 없으면 `UNKNOWN(사유)` 명시
- 경미한 불일치 → PLAN 갱신 후 계속
- 범위·리스크 상승 → **즉시 STOP, 사용자 보고**
- 결과 → `.ai/reports/<taskId>/PLAN.md`

### PLAN.md 필수 섹션 (10-section 정규 스키마)
1. **ChangeBudget** — FilesN, Modules, Risk, DBMig, MoneyAuth
2. **DependencyDecision** — libs.versions.toml 변경 시 8개 항목 필수; 없으면 N/A
3. **ArchitectureImpact** — 새 인터페이스·추상화 시 변동성 경계 유형; 없으면 N/A
4. **ModelBoundaryPlan** — DTO/Entity/DomainModel/UiState 분리 영향; 없으면 N/A
5. **ErrorPolicy** — typed Result/sealed error; 새 UseCase 없으면 N/A
6. **UIStateFlowPlan** — UiState 변경; UI 없으면 N/A
7. **TestabilitySeams** — FakeXxx, 심 주입 대상; 없으면 N/A
8. **VerificationPlan** — VerifyCmds (또는 UNKNOWN(사유))
9. **RollbackStrategy** — 문서 전용: git revert 명시; 제품 코드: 롤백 지점·조건·복구 경로 필수
10. **ExternalPrep / DeferredItems** — user-prep 연기 항목; 없으면 N/A

각 섹션은 해당 없어도 삭제하지 않고 `N/A` 명시.
단계별 Plan 목록과 Notes는 섹션 뒤에 추가한다.
형식 상세: `docs/rules/reporting.md` §5 PLAN.md (= 직전 report-formats.md 본문 통합 default)

### 신규 출시 deliverable 등재 (upstream · 추적 2-세계 분리 차단)

/plan 단계에서 **사용자 대면 신규 deliverable(신규 기능 / 화면 / 수익화 task)** 이 식별되면, 해당 자식 출시 task 층(`docs/release-readiness/INITIATIVES.md` §3 · 개념 = INITIATIVES)에 **3축 분류 + KR 귀속 태그**로 등재하는 항목을 PLAN 산출물에 포함한다. 신규 출시 task 등재 = DocSync(downstream)뿐 아니라 plan(upstream) 의무다 — 구현 cycle 추적(`.ai/tasks/INDEX.md`)과 출시 목표 추적(§3)이 분리(2-세계)되어 신규 출시분이 §3 에 누락되는 drift 를 plan 단계에서 차단한다.

- 대상: 사용자 대면 신규 기능 / 화면 / 수익화(결제·가격·티켓) task. 내부 리팩터 · cli infra · 문서 전용 = N/A 명시.
- §3 등재 본문 + KR 귀속 검증 mechanics = downstream counterpart [`initiatives-sync` skill](../../.claude/skills/initiatives-sync/SKILL.md)(REVIEW PASS 시점 ④ KR 귀속 gate · ⑤ 완료분 always-fresh) 단일 SoT. 본 § = upstream 게이트(plan 산출물 포함 의무)만 소유(본문 복제 0).

---

## implement 규칙

- **최소 변경 원칙**: 요청된 것만, 그 이상 변경 금지
- intake normalization과 pre-EVIDENCE 계약 완료 전 implement direct entry 금지
- **색인 consult**: 구현 진입 시 [`rule-routing-table.md`](../../.claude/rules/rule-routing-table.md) 의 해당 행동 의무 로드 집합(L0 + L1/L2/L3 subset)을 따른다 — code-level 이면 L2 [`code-style-guide.md`](./code-style-guide.md) 포함(bulk read 금지)
- SoftBudget 기준 (단일 Screen+ViewModel+UiState 실측 기반):
  - Low Risk: 200 LOC 이하
  - Medium Risk: 120 LOC 이하
  - High Risk: 60 LOC 이하
- 초과 예상 시 → 분할(sub-task)로 계획 수정 후 진행
- same-file 충돌 가능성 → 순차 실행
- 독립 트랙 → 병렬 실행 가능

### 직접 구현 우선 원칙

새 추상화(인터페이스·헬퍼 클래스·베이스 클래스)를 추가하기 전, 직접 구현이 더 단순하고 안전한지 먼저 평가한다.
추상화는 변동성 경계(아래 항목 참조)에서만 도입한다. PLAN `## 3. ArchitectureImpact` 섹션에 이유를 기록한다.
SoftBudget 초과 예상 시 추상화 레이어 추가보다 task 분할을 우선한다.

### Risk 기반 산출물 경량화

| Risk | PLAN | REVIEW | PromptFit |
|------|------|--------|-----------|
| Low | ChangeBudget + VerificationPlan + 작업 목록 (3-section) | Requirements + Regression + Secrets (3-section). **UI 레이어 변경(Screen/ViewModel/UiState 신규·수정) 포함 시 §5 Model Separation 추가 필수** | 선택 |
| Medium | 전체 10-section | 전체 12-section | 필수 |
| High | 전체 10-section + 독립 reviewer | 전체 12-section + 독립 reviewer | 필수 |

### 변동성 경계 추상화 원칙

인터페이스·추상 계층은 아래 변동성 경계에서만 도입한다:
- `network` (HTTP / Supabase Edge Functions)
- `DB` (Room / SQLDelight)
- `file system` (파일 읽기·쓰기·백업)
- `time` (DateProvider — `System.currentTimeMillis()` 직접 사용 금지)
- `identity` (UserIdentityProvider / Supabase Auth)
- `billing` (EntitlementRepository / Google Play / StoreKit)
- `feature flags` (RemoteConfigProvider / RemoteConfig — [UNKNOWN] SDK 선택 미결정)
- `platform SDK wrapping` (AdMob, Analytics, Crashlytics 등)

이 목록에 해당하지 않는 안정적 내부 로직에는 인터페이스를 추가하지 않는다.

### 신규 의존성 승인 (DependencyDecision)

`libs.versions.toml` 에 새 항목을 추가하기 전 PLAN `## 2. DependencyDecision` 섹션에 8개 항목(①~⑧)을 모두 기술해야 한다. 8항 본문 + 평가 기준 + 흡수 하위 차원의 canonical = [`docs/agent/architecture/DEPENDENCY_DECISION_CHECKLIST.md`](../../docs/agent/architecture/DEPENDENCY_DECISION_CHECKLIST.md) (= 본 file 은 게이트만 소유 · 8항 본문 복제 X).

`## 2. DependencyDecision` 섹션 없이 `libs.versions.toml` 변경이 감지되면 REVIEW FAIL 조건이다.
감지 방식: `git diff --name-only` 실측 — git 변경 사실 기반 단일 기준 (reviewer 수동 · 구 compound-lint 8c 게이트 = deprecated · 도구 부재). PLAN.md 텍스트 참조 또는 EVIDENCE.md 텍스트 기반 판정은 사용하지 않는다.

### TDD 우선 흐름

새 UseCase, Repository 인터페이스, Coordinator 구현 시 테스트 파일을 먼저 또는 구현과 동시에 작성한다.
- repo 표준: `FakeXxx` / `StubXxx` 주입 패턴 (`FakeDateProvider`, `RecordingJournalRepository`, `FakePreferencesRepository` 등)
- commonTest 또는 JVM unit test 에서 실제 플랫폼 의존 없이 실행 가능해야 한다
- PLAN `## 7. TestabilitySeams` 섹션에 새로 작성할 테스트 파일명과 FakeXxx 여부를 명시한다

### 외부 준비 항목 연기 (user-prep 연기)

백엔드 프로젝트 설정 (Supabase 등)·Play Console SKU·App Store IAP·AdMob ID·OpenAI 키·RemoteConfig 파라미터 등
외부 콘솔·인프라 준비가 필요한 항목은 준비 증거 없이 직접 구현하지 않는다.
- 연기 마커: `// TODO(user-prep): <선행 조건>` 주석 또는 stub 구현
- stub 또는 interface만 제공하고, 실제 연동 코드는 외부 준비 완료 후 별도 task 로 진행한다

### 모델 분리 + 경계 매핑 (Model Separation / Boundary Mapping)

> 본 항목의 SoT = [`docs/agent/architecture/MODEL_SEPARATION.md`](../../docs/agent/architecture/MODEL_SEPARATION.md) (DTO/Entity/DomainModel/UiState 분리 · 경계 변환 위치 = Repository · UseCase · ViewModel · I2 내부 의존 금지 · 금지/허용 패턴). 본 file 은 가리키기만 한다(중복 금지).
> implement 의무: 모델·경계 매핑 변경이 있으면 PLAN `## 4. ModelBoundaryPlan` 에 명시한다.

### 오류·결과 정책 (Error/Result Policy)

새로 작성하거나 변경하는 UseCase · Repository 인터페이스에서:
- 예외(Exception) 전파보다 typed 도메인 오류 또는 `Result<T, DomainError>` 반환을 우선한다
- 오류 유형은 sealed class 또는 sealed interface 로 명시적으로 모델링한다
- 기존 코드의 전면 교체는 범위 초과 — 개별 task 로 분리한다
- PLAN `## 5. ErrorPolicy` 섹션에 오류 모델 선택 근거를 기록한다

### 테스트 가능성 심 (Testability Seams)

다음 외부 의존은 인터페이스로 주입한다 (직접 호출 금지):
- **시간**: `DateProvider` — `System.currentTimeMillis()` / `Clock.System.now()` 직접 사용 금지
- **코루틴 디스패처**: `CoroutineDispatcher` 주입 — `Dispatchers.IO` / `Dispatchers.Main` 직접 사용 금지
- **사용자 정체성**: `UserIdentityProvider` — domain 계층에서 인증 SDK (Supabase Auth 등) 직접 호출 금지
- **로거**: 플랫폼 로거 직접 호출 대신 주입 가능한 추상 로거 사용 (해당 경우)
- **무작위값·UUID**: 테스트 가능성이 필요한 경우 주입 가능한 provider 로 분리

심 기반 테스트는 `FakeXxx` / `StubXxx` 패턴으로 작성한다. PLAN `## 7. TestabilitySeams` 에 심 주입 테스트 여부를 명시한다.

### UI 상태 소유권과 단방향 흐름 (UI State Ownership and Flow)

UI 또는 상태 변경을 포함하는 task 에서:
- `UiState` 는 불변(immutable) data class 로 정의한다 — 부분 수정 없이 전체 재생성
- ViewModel 이 `UiState` 의 유일한 생산자다. UI(Composable)는 소비만 한다
- 이벤트: UI → ViewModel (Intent/Event) | 상태: ViewModel → UI (StateFlow) — 방향 역전 금지
- `UiState` 와 `DomainModel` 은 동일 객체로 사용하지 않는다. ViewModel 에서 변환한다
- PLAN `## 6. UIStateFlowPlan` 섹션에 UI 상태 소유권 변경 영향을 명시한다

### Cleanup Assessment (code-level task 필수)

code-level 구현/수정 task에서 cleanup assessment는 기본 절차다. 조사형·문서형·ops-layer task는 예외.

**기본 제거 시점**: 구현 완료 후, verify 전 최종 cleanup pass.
예외 (구현 전·중 즉시 허용): 직접 인접 + 저위험 + 명백 미사용 후보에 한정.
자동 분류 금지: whole-file deletion, package-level deletion, wiring 제거는 저위험 명백 후보가 아님.

**code removal vs file deletion STOP**: line/block 제거(Edit tool)는 근거 충분 시 허용. `rm` 명령은 기존 deny 목록으로 차단됨. whole-file 제거는 PLAN 명시 + reviewer 판정 필요.

**cleanup STOP vs task-level STOP**:
- 기본: 근거 부족 시 제거만 보류, 구현 계속, `TODO.md`에 `deferred`/`follow-up`
- task-level STOP 승격: auth/payment/DB/manifest/DI/public API/observability 경로 후보가 현재 변경 경로 정합성에 직접 영향

**기록 의무**: EVIDENCE.md에 `## Cleanup Assessment` 섹션 필수.
ops-layer task이면 `N/A (ops-layer task)` 명시. stop-gate가 이 섹션 누락 시 차단.
상세: `docs/rules/legacy-cleanup-governance.md`

### Native run/verify integration trigger (2026-05-27 · MASTER-CLI-NATIVE-RUN-VERIFY-SANDBOX-INTEGRATION-001)

Anthropic v2.1.145+ bundled skill (`/run` + `/verify` + `/run-skill-generator`) 통합 trigger. implement phase 의 자식 repo 진입 시점에 적용한다.

- 자식 repo 첫 진입 + 비표준 build/launch (staging flavor + productFlavor + BuildConfig env 분리) 발견 시 → `/run-skill-generator` 1회 호출로 per-project recipe 를 capture 한다 (`.claude/skills/run-<name>/SKILL.md` commit). 본 패키지 자식별 recipe = run-master / run-foundation / run-GB / run-GD / run-GT (각 자식 한정 · byte-identical 아님 · L1-3 polyrepo 정합).
- recipe capture 후 `/run` (앱 구동 + 변경 동작 시각 확인) + `/verify` (build + 실 앱 실행으로 코드 변경 확인) 가 기록된 recipe 를 따른다 (재발견 회피).
- staging flavor 한정 · production push 금지 (master `CLAUDE.md` §5 STOP #1 + `safety-and-secrets.md` 정합). `/sandbox` isolation 적용 여부는 cli session 자율.
- runtime crash 영역 진입 시점은 `docs/rules/runtime-crash-mitigation-process.md` (본문 SoT = `.claude/skills/runtime-crash-mitigation/SKILL.md` §3 9-step verify 의무 + §3.3 native bundled skill 통합) 를 따른다.

---

## /verify 규칙

> 단계 흐름 hub: implement → cleanup → DocSync 후 **/verify 단계 존재**. 상세 규칙(0 command 금지 · UNKNOWN+STOP · exit code LOG · 허용 검증 명령 유형 · native `/verify` bundled skill · VERIFY.md 필수 항목)의 SoT = [`verification-and-review.md`](./verification-and-review.md). 본 file 은 가리키기만 한다(중복 금지).

---

## /review 규칙

> 단계 흐름 hub: /verify 후 **/review 단계 존재**. 상세 규칙(근거 기반 판정 CONFIRMED/INFERRED/UNKNOWN · 12-section 체크리스트 · Verdict · 루프 재진입)의 SoT = [`verification-and-review.md`](./verification-and-review.md). 본 file 은 가리키기만 한다(중복 금지).

---

## COMPOUND / TODO

- `COMPOUND.md`: 종합 검증 판정 (audit/evidence-heavy task 한정 · 구 compound-lint 결과 영역 = deprecated · 도구 부재 · MASTER-CLI-COMPOUND-LINT-DEPRECATE-001)
- `TODO.md`: 완료 후 남은 후속 작업 목록

검증 일괄 실행 = `/verify-all <taskId>` (= architecture + test + 산출물·시크릿 grep · 구 compound-lint 단독 실행 = deprecated).

---

## 완료 조건

다음이 모두 충족되어야 DONE 처리:
1. VERIFY.md 존재 + 검증 명령 exit code 0
2. REVIEW.md 존재 + 최종 판정 PASS
3. TODO.md 잔여 블로커 없음
4. `.ai/tasks/INDEX.md` Status → DONE 업데이트


---

## 명시 cycle 이력

> 판정 = **실질 개정 있음** (= 2026-08-30 `MASTER-RULE-HISTORY-SECTION-001` 소급 판정 · 축 = `rule-footer-common.md` 「실질 개정 ↔ 기계 치환」 · 판정표 29 행 = 그 판 REPORT). 소급 범위 = **판정 근거 한정**(= 무한 소급 금지 · 전 계보 열거 아님) · **기계 치환 commit 미등재**(= 축 자기 적용).

- 2026-05-02 · `C1-MASTER-BOOTSTRAP-001` · 본 rule 신설 (= 350 행 · `ff65723`).
- 2026-08-30 · `MASTER-RULE-HISTORY-SECTION-001` · **본 절 신설** (= 위 판정의 착지 · `rule-footer-common.md:10` 등재 의무 소급 이행 · 본문 절 무접촉).
