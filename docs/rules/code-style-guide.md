# Code Style Guide — L2 단일 진입점 (Kotlin code-level)

> **단일 목적**: code-level(Kotlin) 행동 시 적용하는 스타일·관용의 단일 진입점. 흩어진 스타일 SoT 4곳 + L2 아키텍처 7 docs 를 *가리키고*, 그들이 커버하지 않는 안정·객관·광범위 규칙만 신설한다. **pointer-first · 본문 복제 0**.
> **신설**: RULE-ARCH-PHASE2-001 (2026-05-31).
> **계층**: L2 (프로그래밍) — `rule-routing-index.md` §A L2 + §B(구현형/UI-UX형/API-서버형) 정합. code-level 행동 시 로드.
> **연관 파일**:
> - `rule-routing-index.md` — 본 guide 의 계층·행동 라우팅 위치 + amend loop
> - `code-principles.md` — SOLID/DRY/KISS/YAGNI + 리뷰 체크리스트 (설계 원칙 SoT · 본 guide 는 그 위의 Kotlin 표면 관용)
> - 네이밍 SoT = 본 guide §C 가이드라인 「명명·관용」 (= 2026-07-29 `MASTER-CLI-JUDGMENT-SHIFT-001` · 구 `abbreviation-policy.md` 금지어 list 대조 → **주변 코드 관용 준수 판단 위임** · 구 rule 원문 = [`.auto-memory/abbreviation-policy-COLD.md`](../../.auto-memory/abbreviation-policy-COLD.md) verbatim 보존)
> SOT: `CLAUDE.md`

---

## §A. 목적 + 사용법

- 본 guide = L2 단일 진입점. "코드를 어떻게 쓰는가"의 흩어진 SoT 를 한 곳에서 가리키고, 빈 칸(미커버 안정 규칙)만 채운다.
- **pointer-first**: 포맷 / 축약 / 설계 원칙 / 커밋 / 아키텍처는 각 SoT 가 단일 진실이다. 본 guide 는 그 본문을 복제하지 않는다(복제 발견 = STOP · `rule-routing-index.md §D`).
- **로드 시점**: code-level(Kotlin) 행동 — 구현형 / UI-UX형 / API-서버형(`rule-routing-index.md §B`). cli-infra ops(bash·md)는 본 guide 대상이 아니다(Kotlin 표면 관용이라서).
- **무엇을 신설하는가**: 아래 §C 의 안정·객관·광범위 규칙만. 도구가 강제하는 영역(포맷·import 정렬·modifier 순서)이나 주관적 영역(LOC budget·KDoc 의무)은 신설하지 않는다(§C 탈락 표).
- **enforcement 수준 = warn (advisory)**: 본 guide 규칙은 차단(blocking) 아님 — IDE/리뷰 advisory 로 강제하고 신 blocking gate 는 신설하지 않는다(사용자 본심). 빌드 강제화(ktlint warn-gate 등)는 별 후보 cycle. (2026-07-29 `MASTER-CLI-JUDGMENT-SHIFT-001` supersede: 구 문면이 근거로 든 warn hook 2종[`check-abbreviation.sh` + `post-edit-degeneration-check.sh`] = **제거** — 명명·출력 품질은 hook 대조가 아니라 모델 판단에 위임. warn 등급 자체는 불변.)

---

## §B. SoT pointer 표 (본문 X · "무엇을 가리키는가" 1줄)

| 영역 | SoT pointer | 가리키는 것 |
|---|---|---|
| 포맷·들여쓰기·EOL | [`.editorconfig`](../../.editorconfig) | charset utf-8 / LF / indent 4 / max 120 + `[*.{kt,kts}]` ktlint_standard 선언 = **advisory**(IDE/수기) · 빌드 비강제(플러그인 미연결) · 강제화(ktlint warn-gate) = 후보 cycle `MASTER-CLI-KTLINT-WARN-GATE-NNN` |
| 식별자 명명·축약 | 본 guide §C 가이드라인 「명명·관용」 | 주변 코드 관용 준수 (= 판단 위임 · 금지어 list 대조 폐기 · 구 원문 = `.auto-memory/abbreviation-policy-COLD.md`) |
| 설계 원칙·리뷰 | [`code-principles.md`](./code-principles.md) | SOLID 5 + DRY/KISS/YAGNI + 코드 리뷰 체크리스트(A~H) |
| 커밋 메시지 | [`COMMIT_CONVENTION.md`](../../docs/agent/process/COMMIT_CONVENTION.md) | Conventional Commits type/scope/subject/body + `ops` 확장 |
| 레이어 방향 | [`KMP_CMP_LAYER_DIRECTION.md`](../../docs/agent/architecture/KMP_CMP_LAYER_DIRECTION.md) | shared-first 단방향 레이어 흐름 강제 |
| 모델 분리 | [`MODEL_SEPARATION.md`](../../docs/agent/architecture/MODEL_SEPARATION.md) | DTO/Entity/DomainModel/UiState 횡단 재사용 금지 |
| 오류 정책 | [`ERROR_RESULT_POLICY.md`](../../docs/agent/architecture/ERROR_RESULT_POLICY.md) | typed 도메인 오류 / `Result<T, DomainError>` 우선 |
| 테스트 심 | [`TESTABILITY_SEAMS.md`](../../docs/agent/architecture/TESTABILITY_SEAMS.md) | clock/dispatcher/identity 등 외부 의존 인터페이스 주입 |
| TDD | [`TDD_WORKFLOW.md`](../../docs/agent/architecture/TDD_WORKFLOW.md) | FakeXxx-first 테스트 우선 흐름 |
| DI | [`KOIN_DI_BASELINE.md`](../../docs/agent/architecture/KOIN_DI_BASELINE.md) | Koin DI 구성 레포 간 일관성 |
| Compose 안정성 | [`COMPOSE_STABILITY.md`](../../docs/agent/architecture/COMPOSE_STABILITY.md) | recomposition stability + baseline profile |

> 위 11개 본문은 각 file 단일 SoT. 본 표는 진입점만 제공한다 — 규칙 본문이 필요하면 해당 file 을 연다(bulk read 금지 · `CLAUDE.md §9`).

---

## §C. 신규 규칙 (§1 5원칙 gate 통과분만)

> gate = 규칙 설계 5원칙(양 최소화 / 읽을 대상 / 일관성 / 변동성 회피 / 예외 허용). 통과 = 안정 + 객관 + 광범위 + 기존 SoT 비중복. 각 규칙 = [규칙] + [근거] + [deviation].

### 채택 — 하드 규칙 3

**C-1. Nullability & Immutability**
- 규칙: 선언은 `val` 우선(`var` 는 재할당이 본질일 때만). 플랫폼 타입을 `!!` 로 단언하지 말고 `?.` / `?:` / `requireNotNull(...)` 로 의도를 드러낸다.
- 근거: 불변 선언은 aliasing·재할당 버그를 줄이고, `!!` 는 추적 어려운 NPE 의 대표 원인이다.
- deviation: 핫루프 누산 등 `var` 가 본질이면 PLAN `## 3. ArchitectureImpact` 에 1줄 근거.

**C-2. Visibility minimization**
- 규칙: 공개 표면을 최소로 둔다. 모듈 내부는 `internal`, 타입 내부는 `private` 우선. `public` 은 의도된 API 경계에서만.
- 근거: 최소 표면은 의도치 않은 결합을 차단하고 리팩터 자유를 키운다(캡슐화·OCP 정합 · `code-principles.md §1`).
- deviation: 테스트 가시성이 필요하면 `@VisibleForTesting` 명시 — 무표식 `public` 승격 금지.

**C-3. Concurrency exposure**
- 규칙: 가변 동시성 타입을 노출하지 않는다 — `MutableStateFlow` / `MutableSharedFlow` 는 `private`, 외부에는 `StateFlow` / `Flow` 만. 일시중단 함수는 부수효과·I/O 를 이름에 드러낸다.
- 근거: 가변 상태 노출은 단방향 흐름(UiState ownership · `ui-ux-analysis.md` + `workflow-core.md §implement`)을 깨고 외부 변경을 허용한다.
- deviation: 읽기 노출이 필요하면 `asStateFlow()` 등 read-only projection 추가(가변 타입 직접 노출 금지).

### 후퇴 → pointer (원칙 1 중복 회피)

- **식별자 case** (PascalCase 타입 / camelCase 멤버 / UPPER_SNAKE const): `.editorconfig` 의 `ktlint_standard` + Kotlin 컴파일러 관용 + 아래 가이드라인 「명명·관용」이 이미 커버한다. 본 guide 는 명문화하지 않고 그 pointer 로 후퇴한다(원칙 1: 양 최소 · 이중 진실 0).

### 가이드라인 (비강제 · Kotlin 공식 스타일 수준)

- **명명·관용 = 주변 코드를 따른다** — 주변 코드처럼 읽히는 코드를 쓴다: 그 파일의 주석 밀도·명명·관용을 맞춘다. 축약 여부는 고정 금지어 list 가 아니라 **주변 코드가 이미 쓰는 어휘**가 판정한다(주변이 `idx` 를 쓰면 `idx`, `index` 를 쓰면 `index`). 도메인 표준 약어(`id`·`url`·`api`·`dto`)는 그대로 쓴다. **신설 근거**(2026-07-29 `MASTER-CLI-JUDGMENT-SHIFT-001` · Coin 본심 ①): 구 판은 금지어 seed list + `check-abbreviation.sh` PreToolUse hook 대조였으나 — list 는 수동 유지 대상이라 프레임워크 API 명을 false positive 로 차단(선례 = Play Billing `BillingFlowParams` 계열 Edit 차단)했고, 명명 적합성은 list 대조가 아니라 맥락 판단의 문제다. 구 rule 원문(금지 seed + 허용 약어 전량) = [`.auto-memory/abbreviation-policy-COLD.md`](../../.auto-memory/abbreviation-policy-COLD.md) verbatim 보존(정보 소실 0 · hot 복귀 trigger = 명명 퇴행 재발 1+ 회).
- **scope function 의미 분담** (`let` / `run` / `apply` / `also` / `with`): 의도된 의미로만 쓰고 2단계 이상 중첩은 피한다 — **권장(비강제)**. 의미 선택 자체는 주관 여지가 있어(원칙 4) 하드 규칙이 아니라 가이드라인으로 둔다. 본문은 Kotlin 공식 coding conventions.
- **클래스 위임 `by` = 상속 없는 조합** — 인터페이스 구현을 다른 객체에 넘길 때 상속 대신 위임을 쓴다(`class A(b: B) : I by b`). 조합은 결합을 낮추고 교체 지점을 드러낸다. **★Kotlin 공식 주의(반드시 인지)**: *위임 대상(delegate)은 위임하는 클래스의 `override` 를 보지 못한다* — 파생 클래스가 override 한 멤버는 delegate 내부 호출에서 **호출되지 않고**, delegate 는 **자신의 구현만** 참조한다. 따라서 **"일부만 갈아끼우면 나머지가 따라온다"를 가정하지 말 것.** 부분 교체가 필요하면 위임이 아니라 **명시 조합**(필요한 협력자를 전부 이름으로 주입)으로 간다(`code-principles.md` §2 암묵 기본값 금지 · `billing-rules.md` §1 정합). 가이드라인 등급 근거 = 도구 비강제 + 적용 판단에 주관 여지(원칙 4).

### 탈락 — 하드 규칙 신설 X (원칙 4 변동성/주관)

| 탈락 후보 | 왜 하드 규칙이 아닌가 (1줄) |
|---|---|
| import 정렬 실강제 | 도구 영역(`.editorconfig` `ij_kotlin_imports_layout` / ktlint) — rule 에 박으면 도구와 이중 진실(원칙 1·3). 강제 연결은 Phase 4. |
| 함수/파일 LOC budget | 적정선이 맥락 의존(주관) → 하드 숫자는 변동성(원칙 4). LOC 가이드는 `workflow-core.md` SoftBudget 이 이미 제공. |
| modifier 순서 | 도구 영역(ktlint `modifier-order`) — rule 중복 금지(원칙 1). |
| KDoc 의무화 | 전면 의무는 주관·저가치 주석 양산(원칙 4) → public API 한정 권장은 리뷰 판단에 위임. |

---

## §D. deviation + amend

- **deviation**: 위 §C 규칙에서 벗어날 필요가 생기면 각 규칙의 deviation 경로를 따르되, 표준 외 선택은 PLAN `## 3. ArchitectureImpact` 에 근거 + reviewer 판정(`rule-routing-index.md §C` 정합).
- **amend**: code-level 행동 중 "기존 규칙으로 안 잡히는 반복 패턴"을 발견하면 `cli infra rule candidate` 로 누적한다. 자동 신설하지 않는다 — `cycle-discipline.md §19`(반복 패턴 자기관측 loop) + `§18`(분기 정기 review) 를 통해 사용자 confirm 후 master cycle 로 정착(`rule-routing-index.md §D` 정합 · `cycle-discipline.md §2` L1-1 예외).

---

## §E. propagation 정책

- 본 file = cli infra **권장 byte-identical** 영역(`.claude/rules/` · 보호 5종 아님 · `cycle-discipline.md §3`).
- **본 cycle(RULE-ARCH-PHASE2-001) = master 신설 only**. 5-repo byte-identical propagation = 별 follow-up cycle(`cycle-discipline.md §15` 패턴 1). 자식 직접 수정 금지(`CLAUDE.md §4`).

---

## §F. 명시 cycle 이력

- 2026-07-26 · MASTER-CLI-COMPOSITION-RULES-S3-001 · §C 가이드라인 절에 "클래스 위임 `by` = 상속 없는 조합" 1 항목 append (= Kotlin 공식 주의 "delegate 는 위임 클래스의 override 를 보지 못한다" 명기 · 부분 교체 시 명시 조합으로 유도). 하드 규칙 3(C-1~C-3) + 후퇴/탈락 표 + §B pointer 표 무접촉. 4-repo byte-identical propagation.
- 2026-05-31 · RULE-ARCH-PHASE2-001 · 본 guide 신설(§B 4 SoT + 7 아키텍처 pointer · §C 하드 규칙 3 채택 + 식별자 case 후퇴 + scope function 가이드라인 + 4 후보 탈락) + `rule-routing-index.md §A L2 / §B` 등록. 진입 HEAD `f759954`(Phase 1 commit `5cb9cdd` 후속). 4 SoT/7 docs 본문 복제 0(pointer only). `.editorconfig` · production build(`*.gradle.kts`) · 보호 5종 무접촉.
