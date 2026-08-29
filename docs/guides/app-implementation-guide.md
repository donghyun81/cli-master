# App Implementation Guide — Claude CLI 진입 1차 가이드

> **단일 목적**: Claude CLI (Claude Code) 가 **자식 repo 안에서 앱 구현 task 진입 시 첫 reading 의무 문서**.
> **C6-COMMON-DOCS-AND-TEMPLATES-001 신설**.
> **공식 근거**: Anthropic Claude Code Best Practices + Google Android Developers (Compose Architecture / SSOT / UDF).
> **연관**: `docs/agent/architecture/COMMON_ARCHITECTURE.md` (13 architecture 문서 ToC) + `docs/rules/code-principles.md` (SOLID + 코드 리뷰) + 도메인 templates (`docs/templates/`).

---

## 0. 진입 1 차 reading order

자식 repo 안 `/fulfill-requirement <한 줄>` 또는 `/plan-first` 진입 시 본 가이드가 첫 reading.

```
1. <repo>/CLAUDE.md                          (자식 repo 도메인 + master 인용)
2. .claude/settings.json                     (권한 + hook)
3. docs/guides/app-implementation-guide.md   ← 본 문서
4. docs/agent/architecture/COMMON_ARCHITECTURE.md   (전체 layered architecture)
5. (필요한 task-specific 문서만)
```

---

## 1. 우리 architecture 의 핵심 원칙 (= Google 공식 5 + 우리 1 · §1.6)

### 1.1 Single Source of Truth (SSOT)

State 는 한 곳에서만 변경. 모든 read = 해당 SoT 참조.

- UI state SoT = ViewModel
- 도메인 model SoT = UseCase 또는 Repository
- 디자인 SoT = Pencil .pen + ui-spec.json (dual-layer · `design-sot-policy.md` 박힘)
- cli infra SoT = master (claude-cli-master)

근거: [Compose UI Architecture](https://developer.android.com/develop/ui/compose/architecture) + 우리 `SSOT_PRINCIPLES.md`.

### 1.2 Unidirectional Data Flow (UDF)

State **down** + Events **up**. 양방향 binding 금지.

```
ViewModel.uiState (StateFlow) → Compose @Composable (read-only)
Compose @Composable → ViewModel.onEvent(Event) → state mutation
```

근거: [UDF in Compose](https://developer.android.com/develop/ui/compose/architecture) + 우리 `KMP_CMP_LAYER_DIRECTION.md`.

### 1.3 Layered Architecture (UI / Domain / Data)

- **UI layer** — Compose @Composable + ViewModel + UiState
- **Domain layer** — UseCase + DomainModel + DomainError (typed Result)
- **Data layer** — Repository + DataSource + DTO + Entity (DTO ≠ DomainModel ≠ UiState)

각 layer 모델 혼용 금지. `MODEL_SEPARATION.md` 참조.

### 1.4 Multi-module 책임 분리

- `app/` — Activity / Compose entry / Navigation / Koin module wire
- `shared/domain/` (KMP 도입 후) — UseCase + DomainModel · framework import 금지
- `shared/feature-state/` — ViewModel + UiState
- DI baseline = Koin (위치: `app/` 또는 `shared/app` glue)

근거: 우리 `KMP_CMP_LAYER_DIRECTION.md` + `KOIN_DI_BASELINE.md`.

### 1.5 Immutable state + State hoisting

- UiState = immutable data class
- @Composable 안에서 mutableStateOf 가 ViewModel 외부 leak 금지
- state hoist = 가장 낮은 공통 ancestor 까지 올림

근거: [State and Jetpack Compose](https://developer.android.com/jetpack/compose/state) + 우리 `COMPOSE_STABILITY.md`.

### 1.6 상태의 소유와 수명 (= 6 번째 원칙 · SSOT/UDF 가 답하지 않는 축)

★**한 줄 원칙**: **상태의 수명 = 그것을 보는 화면의 수명.** 소유자는 **그 화면의 ViewModel** 이다.

§1.1 SSOT 는 「상태가 **어디 하나**에 있나」를, §1.2 UDF 는 「상태가 **어느 방향**으로 흐르나」를 답한다. 둘 다 ★**「그 상태가 언제 죽나」를 답하지 않는다** — 그 빈칸에서 화면 상태가 **앱 수명을 사는** 형태가 자란다.

- ★**§1.5 state hoisting 의 경계**: hoist 의 **상한은 화면(navigation entry)** 이다. 「가장 낮은 공통 ancestor」가 **App / Root 조립부**로 계산되면 그건 hoist 가 아니라 **누수**다 — 공통 ancestor 를 찾기 전에 **그 상태가 어느 화면의 것인지**를 먼저 정한다.
- **앱 수명에 두는 것** = repository · store · seam(clock / dispatcher / logger 등). **화면 상태 · 표시물 · 이벤트 버스는 앱 층에 두지 않는다.**
- **조립부는 그래프를 세울 뿐 상태를 갖지 않는다** — 조립부의 `remember { XxxViewModel(...) }` 는 그 VM 을 **앱 컴포지션 수명에 묶는다**(화면을 떠나도 안 죽는다).
- **위반 신호**: 화면을 떠나도 살아 있는 상태 · 조립부의 VM 필드 · `remember` 밖으로 새는 화면 상태 · 정의만 있고 안 불리는 정리 함수.

> **본문 SoT = [`KOIN_DI_BASELINE.md` §4a](../agent/architecture/KOIN_DI_BASELINE.md)** (= 소유·수명 규약 본문 · 본 §은 진입 가이드 층 · **본문 중복 0**). 원칙 층 = [`code-principles.md` §0.2](../rules/code-principles.md) (= SRP 의 「하나의 변경 이유」에 **생존주기** 포함).

---

## 2. 13 architecture 문서 ToC (master `docs/agent/architecture/`)

자식 repo 의 모든 implement task 가 본 13 문서 의 해당 부분 참조 의무:

| 문서 | 단일 목적 | task 진입 시점 |
|---|---|---|
| `COMMON_ARCHITECTURE.md` | 운영 vs 제품 layer 분리 + propagation discipline | 모든 implement task 첫 읽기 |
| `KMP_CMP_LAYER_DIRECTION.md` | I2 불변 + 단방향 흐름 | UI / state task |
| `KOIN_DI_BASELINE.md` | DI 위치 제한 | 신규 module 또는 ViewModel |
| `MODEL_SEPARATION.md` | DTO/Entity/DomainModel/UiState 분리 | data layer + UI layer task |
| `ERROR_RESULT_POLICY.md` | typed Result + sealed DomainError | 에러 처리 추가 task |
| `TESTABILITY_SEAMS.md` | 8 심 (clock/dispatcher/identity/logger/uuid 등) 인터페이스 주입 | 신규 UseCase / Coordinator |
| `TDD_WORKFLOW.md` | FakeXxx 우선 흐름 | 신규 logic task |
| `SSOT_PRINCIPLES.md` | 단일 출처 표시 규칙 | SoT 신설 / 변경 task |
| `DEPENDENCY_DECISION_CHECKLIST.md` | 8 항목 (도입 / 비교 / 라이선스 / 트리 / size / R8 / CVE / 제거) | 신규 의존성 |
| `COMPOSE_STABILITY.md` | Compose 안정성 (immutable / Stable annotation) | UI task |
| `LEGACY_CLEANUP_GOVERNANCE.md` | code-level cleanup 거버넌스 | implement → cleanup pass |
| `PROPAGATION_PARAMETERS.md` | repo-config.sh 의 export 변수 매핑 | uiux-refresh / multi-repo task |
| `ADR_TEMPLATE.md` | 아키텍처 결정 기록 (ADR) | 큰 결정 발생 시 |

---

## 3. 자식 repo 도메인 작성 절차

### 3.1 신규 화면 (UI) 작성 절차

```
1. master 의 docs/templates/screen-flow.template.md cp → docs/design/screen-flow.md (해당 섹션 추가)
2. UX 정의 (intake-router → requirements-analyst → ux-auditor)
3. Pencil SoT 작성 (Pencil → Compose · pencil-uiux-workflow.md §Type 2)
4. ui-spec.json 신설 + lastSyncedDesignToolStateHash 갱신
5. ★상태 소유자·수명 지정 (§1.6 · 화면 VM = navigation entry scope · 앱/조립부 층 승격 금지)
6. Compose 코드 작성 (ui-implementer · MODEL_SEPARATION 의무)
7. cleanup pass + verify + review (PromptFit 평가)
```

### 3.2 신규 도메인 model (Data) 작성 절차

```
1. master 의 docs/templates/data-model.template.md cp → docs/design/data-model.md
2. DTO 정의 (Backend 활성 시 api-spec.template.md 도 cp)
3. Entity 정의 (Room 등 활성 시 deferred-domains.md §1 STOP 후 활성화 cycle)
4. DomainModel + DomainError 정의 (typed Result · ERROR_RESULT_POLICY)
5. Repository + UseCase 작성 (Koin 모듈 추가)
6. FakeXxx 기반 테스트 (TDD_WORKFLOW)
```

### 3.3 신규 의존성 추가 절차

```
1. PLAN.md ## 2. DependencyDecision 8 항목 모두 작성 (DEPENDENCY_DECISION_CHECKLIST)
2. libs.versions.toml 추가 (자식 repo 안)
3. APK size 측정 (BundleAnalyzer)
4. R8 keep rule 검토
5. ADR 작성 (큰 의존성이면 · ADR_TEMPLATE.md cp)
```

### 3.4 신규 자식 repo 신설 절차

```
1. <PARENT>/<NewRepo>/ 디렉터리 신설 (Android Compose 단일 모듈)
2. master 의 7 template cp:
   - api-spec.template.md → docs/design/api-spec.md (도메인 채움)
   - data-model.template.md → docs/design/data-model.md
   - screen-flow.template.md → docs/design/screen-flow.md
   - billing.template.md → docs/design/billing.md (활성 시)
   - ai-prompt-guide.template.md → docs/design/ai-prompt-guide.md (활성 시)
   - setup-guide.template.md → docs/setup/00_SETUP_GUIDE.md
   - pencil-dev-prompt.template.md → docs/design/pencil-dev-prompt.md
3. master 의 child-claude-md-header.template.md cp → CLAUDE.md (Nested 패턴 박음)
4. bash scripts/propagate.sh --all --targets <NewRepo> (master cli infra cp)
5. 자식 repo CLAUDE.md 의 도메인 섹션 채움
6. master CLAUDE.md §1 자식 repo 등록 표 행 추가
7. master propagation-status.md 표 행 추가
8. cycle 마감
```

---

## 4. Claude CLI 가 task 진입 시 의무 흐름 (intake-router 자동)

```
[1] 사용자 prompt 수신
    ↓
[2] intake-router 발화
    ├── work type / reading mode 판정
    ├── master 의 본 가이드 + COMMON_ARCHITECTURE.md 인용 의무
    ├── 정보 공백 분류 (RESOLVABLE_IN_REPO / UNKNOWN / BLOCKED)
    ├── STOP 위험 감지 (Auth/DB/Billing 키워드 → deferred-domains.md §5 trigger)
    └── implementer entry 판정
    ↓
[3] requirements-analyst → 실제 문제 + 측정 가능한 성공 조건
    ↓
[4] read-only fan-out (병렬 가능 · 3 조건 충족 시):
    ├── ux-auditor (UI task)
    ├── auth-security-privacy (Auth 감지 → STOP)
    ├── data-schema-guardian (DBMig → STOP)
    ├── billing-payments-guardian (MoneyAuth → STOP)
    └── 기타 필요 전문가
    ↓
[5] change-planner → PLAN.md (10-section 정규 스키마 · reporting.md §5)
    ↓
[6] implement (ui-implementer / docs-change-communicator 등)
    ├── 13 architecture 문서 의 해당 부분 자동 인용
    ├── code-principles.md SOLID 의무 준수
    └── cleanup pass (legacy-cleanup-governance.md)
    ↓
[7] verifier → 1+ 명령 실행 (0 command 금지)
    ↓
[8] reviewer → REVIEW.md 12-section + PromptFit (PLAYBOOK.md)
    ↓
[9] DONE 또는 replan
```

---

## 4.5 UX Laws 자동 적용 (C7 신설)

모든 UI/UX task 진입 시 `intake-router` 가 work type 식별 후 `ux-auditor` agent 가 자동 호출:

1. `docs/rules/ux-laws.md` 자동 reading
2. §5 task 유형별 매트릭스 row 자동 선별 (예: 신규 화면 → A-1~4 + B-3 + F-1~5 + I-3)
3. 권장 22 법칙 → PLAN.md / IMPL / REVIEW.md §B [UX Laws] 자동 인용
4. 신중 12 → 양면 박음 (적용 패턴 + 위험 패턴 분리)
5. 비권장 1 (Cognitive Bias 활용) → STOP + Coin 명시 승인 의무
6. Dark Patterns 5 종 (Roach Motel / Confirmshaming / Disguised Ads / Forced Continuity / Hidden Costs) 자동 검증 → 위반 = REVIEW FAIL

### Task 유형별 의무 적용 법칙 (요약)

| task | 의무 법칙 |
|---|---|
| 신규 화면 | 인지 부하 4 + Mental Model + Gestalt 5 + Occam |
| Form | Working Memory + Choice/Hick + Fitts + Postel + Parkinson autofill |
| multi-step / Onboarding | 정직 진행 + Hick 점진 + 인라인 도움말 |
| 결제 / 가입 | Tesler + Postel + 긍정 완료 모먼트 + **Dark Pattern 5종 STOP 검증 의무** |
| Navigation / 버튼 / list / 검색 등 | `ux-laws.md` §5 매트릭스 참조 |

세부: `docs/rules/ux-laws.md`.

---

## 5. 본 가이드의 변경 정책

본 파일 = master 가 SoT 보유 (cli infra 권장 byte-identical).
변경 시 master cycle 신설 + propagation 의무.

자식 repo 가 본 가이드를 직접 수정 금지 — drift 발견 시 즉시 STOP + master 정정 cycle.

---

`Sources:`
- [Compose UI Architecture - Android Developers](https://developer.android.com/develop/ui/compose/architecture)
- [Guide to App Architecture - Android Developers](https://developer.android.com/topic/architecture)
- [Android Architecture Recommendations](https://developer.android.com/topic/architecture/recommendations)
- [Best Practices for Claude Code](https://code.claude.com/docs/en/best-practices)
- [Writing a good CLAUDE.md (HumanLayer)](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
