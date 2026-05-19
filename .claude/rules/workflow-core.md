# Workflow Core Rules

> **단일 목적**: 모든 task 의 단계 흐름 + 각 단계 (intake / collect / plan / implement / verify / review) 규칙.
> **분할 출처**: 기존 workflow.md (662 줄) 의 line 1~340 발췌 (C2-RULES-RESTRUCTURE-001).
> **연관 파일**:
> - `cycle-discipline.md` — Cycle Discipline §1~11 + §13~14a (3-repo 정합 / commit 표준 / 환경 정합)
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
  `.claude/rules/legacy-cleanup-governance.md` 에 따른 cleanup assessment 를 EVIDENCE.md 에
  남기고 dead code / 미사용 참조 / 중복 포맷터 경로 / 교체된 구 버전 mapper 등을 제거 또는
  `TODO.md` 에 deferred 로 적는다.
- **DocSync** 는 cleanup pass + Pre-DocSync Verify PASS 이후, `/verify` 진입 전 단계다.
  갱신 대상 영역 = `.ai/reports/<taskId>/*.md` task 산출물 + `docs/agent/` 운영 레이어 문서 +
  **자식 repo 출시 docs 영역** (= `docs/release-readiness/LAUNCH-STATUS.md` + `docs/CLAUDE.md`
  또는 자식 root `CLAUDE.md` + `docs/setup/*`). 자식 출시 docs 갱신 본 paradigm =
  `MASTER-CLI-DOCS-AUTOSYNC-PARADIGM-001` 안 영구 정착. 세부 본문 = `cycle-discipline.md`
  §20 + `.claude/agents/active/docs-change-communicator.md` Key questions.
- ops-layer task 는 cleanup pass 를 `N/A (ops-layer task)` 로 EVIDENCE.md 에 명시한다.
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

관련: `.claude/commands/resume-task.md` (reset 후 재진입 엔트리), `.claude/rules/report-formats.md`
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
3. 제품 개요: `docs/app_overview.ko.md`
4. 아키텍처: `docs/multiplatform-*/**`
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
형식 상세: `.claude/rules/report-formats.md`

---

## implement 규칙

- **최소 변경 원칙**: 요청된 것만, 그 이상 변경 금지
- intake normalization과 pre-EVIDENCE 계약 완료 전 implement direct entry 금지
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

`libs.versions.toml` 에 새 항목을 추가하기 전 PLAN `## 2. DependencyDecision` 섹션에 8개 항목을 모두 기술해야 한다:
1. ①공식·표준 지위 (공식·사실상 표준 여부)
2. ②유지보수 품질 (최근 활동, 이슈 대응)
3. ③KMP·CMP 호환 (공통 artifact 또는 platform-shell-only 범위 명시)
4. ④transitive 비용 (추가되는 간접 의존성)
5. ⑤기존 기능 중복 여부 (repo 내 이미 충족 가능한지)
6. ⑥제거 난이도 (향후 교체·삭제 비용)
7. ⑦직접 구현 대비 우위 (왜 직접 구현보다 라이브러리가 저렴·안전한지)
8. ⑧UI 라이브러리 특별 정당화 (UI 라이브러리의 경우: KMP 호환 + Compose 불가 증거 필수)

`## 2. DependencyDecision` 섹션 없이 `libs.versions.toml` 변경이 감지되면 REVIEW FAIL 조건이다.
감지 방식: compound-lint 8c — git status 기반 실제 파일 변경 감지 (단일 기준). PLAN.md 텍스트 참조 또는 EVIDENCE.md 텍스트 기반 판정은 사용하지 않는다.

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

### 모델 분리 (Model Separation)

레이어 간 모델은 혼용하지 않는다:
- `DTO`: 네트워크·직렬화 경계에서만 사용 (data layer)
- `Entity`: DB 저장소 경계에서만 사용 (data layer)
- `DomainModel`: 비즈니스 로직 계층에서만 사용 (domain layer)
- `UiState`: UI 렌더링 전용 (presentation layer) — `SharedUiState<T>` 패턴 참조

동일 객체를 여러 레이어에 걸쳐 직접 전달하지 않는다. 경계 통과 시 반드시 변환한다.
PLAN `## 4. ModelBoundaryPlan` 섹션에 모델 분리 영향을 명시한다.

### 경계 매핑 원칙 (Boundary Mapping Only)

데이터 변환(mapping)은 레이어 경계(Repository, UseCase, ViewModel)에서만 수행한다:
- DTO → DomainModel: Repository 진입점에서 변환
- DomainModel → UiState: ViewModel 또는 전용 Mapper 에서 변환
- 내부 계층이 하위 계층 모델에 직접 의존하지 않는다 (I2 불변 원칙 준수)

경계를 넘는 변환이 추가되거나 변경되면 PLAN `## 4. ModelBoundaryPlan` 섹션에 기록한다.

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
상세: `.claude/rules/legacy-cleanup-governance.md`

---

## /verify 규칙

- **0 command 금지** (최소 1개 검증 명령 실행 필수)
- 불가피한 경우: `UNKNOWN(사유)` 명시 + 제품 변경 없이 STOP
- 검증 명령과 exit code를 LOG에 남김
- 결과 → `.ai/reports/<taskId>/VERIFY.md`

---

## /review 규칙

- 근거 기반 판정 (CONFIRMED / INFERRED / UNKNOWN)
- 체크리스트:
  - [ ] 요구사항 성공조건 충족 여부
  - [ ] 회귀 위험 없음
  - [ ] 아키텍처 원칙 위배 없음
  - [ ] 누락된 TODO 없음
  - [ ] 문서-구현 드리프트 없음
- 결과 → `.ai/reports/<taskId>/REVIEW.md`

---

## COMPOUND / TODO

- `COMPOUND.md`: compound-lint 결과 + 종합 판정
- `TODO.md`: 완료 후 남은 후속 작업 목록

compound-lint 실행:
```bash
bash scripts/agent/compound-lint.sh <taskId>
```

---

## 완료 조건

다음이 모두 충족되어야 DONE 처리:
1. VERIFY.md 존재 + 검증 명령 exit code 0
2. REVIEW.md 존재 + 최종 판정 PASS
3. TODO.md 잔여 블로커 없음
4. `.ai/tasks/INDEX.md` Status → DONE 업데이트

