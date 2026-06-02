# Testing Strategy — 무엇을, 어떤 우선순위로, 몇 가지 경우로, 어떻게 유지하는가

> **목적**: 테스트를 **어떤 ROI 순서**로 고르고, **어떤 경우들**(정상 + 경계 + 실패 등)로 쓰고, 그것을 **문서처럼 지속 유지·개선**하는지에 대한 전략·관리 layer. 코드를 *테스트 가능하게* 만드는 법과 *언제* TDD 가 의무인지는 별도 문서가 이미 다룬다(아래 §1).
> **무엇이 아닌가**: 본 문서는 커버리지 수치 게이트를 강제하지 않는다(§9). 실 테스트 코드를 여기서 작성하지도 않는다 — 본 문서는 governing layer 이고, 테스트 작성은 각 구현 cycle 의 몫이다.
> **연관 문서**:
> - [`TDD_WORKFLOW.md`](./TDD_WORKFLOW.md) — *언제* 테스트가 의무인가(UseCase/Repository/Coordinator/StateFlow ViewModel) + Red→Green→Refactor
> - [`TESTABILITY_SEAMS.md`](./TESTABILITY_SEAMS.md) — *어떻게* 테스트 가능하게 하는가(8 seam · clock/dispatcher/identity/logger/uuid + network/DB/file)
> - `.claude/rules/code-principles.md` §4.E — 코드 리뷰 시 테스트 체크리스트
> - `.claude/rules/workflow-core.md` §implement — PLAN `## 7. TestabilitySeams` 기록 의무
> SOT: `CLAUDE.md`

---

## 1. 이 문서의 자리 (기존 테스트 문서와의 관계)

세 문서는 서로 다른 질문에 답한다. 중복하지 않고 가리킨다.

| 질문 | 답하는 문서 |
|---|---|
| **언제** 테스트를 의무로 쓰는가 | [`TDD_WORKFLOW.md`](./TDD_WORKFLOW.md) §1 (UseCase / Repository interface / Coordinator / StateFlow ViewModel = 필수) |
| **어떻게** 테스트 가능하게 의존을 끊는가 | [`TESTABILITY_SEAMS.md`](./TESTABILITY_SEAMS.md) §1 (8 seam + `FakeXxx` 주입) |
| **무엇을** ROI 순으로, 몇 경우로, 어떻게 유지하는가 | **본 문서** |

본 문서가 "FakeXxx 패턴"이나 "8 seam 목록"을 다시 적지 않는다. 필요하면 위 두 문서를 연다.

---

## 2. 테스트 피라미드

빠르고 좁은 테스트를 많이, 느리고 넓은 테스트를 적게 둔다.

| 층 | 비중(지향) | 무엇을 검증 | 본 패키지 위치 |
|---|---|---|---|
| **unit** (다수) | ~70% | I/O 없는 순수 로직 — UseCase, mapper, 상태 기계 | `commonTest` (`shared/domain` ([app-foundation/shared/domain/](../../../../app-foundation/shared/domain/)) · `shared/feature-state` ([app-foundation/shared/feature-state/](../../../../app-foundation/shared/feature-state/))) |
| **integration** (소수) | ~20% | Repository + Fake/in-memory, Room migration, JSON 직렬화 | `commonTest` + Robolectric (`shared/data` ([app-foundation/shared/data/](../../../../app-foundation/shared/data/))) |
| **e2e** (극소수) | ~10% | 화면 흐름 전체 | Compose UI test(`androidTest`) · iOS XCUITest |

70/20/10 은 절대 규칙이 아니라 지향이다. 도메인이 로직 위주이면 unit 이 더 두꺼워도 좋다. 역피라미드(느린 e2e 다수 + unit 희소)는 신호: 빌드가 느려지고 실패 원인이 모호해진다.

---

## 3. Google Test Size — 가장 작은 크기 우선

같은 신뢰를 준다면 더 작은 크기를 고른다. 큰 크기는 느리고 비결정적이기 쉽다.

| size | 허용 | 금지 | 본 패키지 도구 |
|---|---|---|---|
| **Small** | 단일 프로세스 · in-memory | network · disk · real DB · sleep | kotlin-test / JUnit + coroutines-test |
| **Medium** | 단일 머신 · localhost · in-memory DB | 외부 네트워크 · 멀티 기기 | Robolectric · in-memory Room |
| **Large** | 멀티 프로세스 · 실 기기/에뮬레이터 | — | Compose UI test · Roborazzi · XCUITest |

판단 기준: "이 동작을 Small 로 확인할 수 있는가?" 가능하면 Small 로 멈춘다. ViewModel 상태 전이는 대부분 Small(coroutines-test)로 충분하고, Robolectric(Medium)은 Android API 표면이 꼭 필요할 때만 쓴다.

---

## 4. Behavior > Implementation

관찰 가능한 출력과 상태를 public API 로 검증한다. 내부 구현에 결합하지 않는다.

- **검증한다**: 반환값, 노출된 상태(StateFlow 값), 발생한 도메인 오류, 외부로 나간 효과(저장된 엔트리 등).
- **피한다**: private 함수 직접 호출, 호출 횟수 단정(`verify(exactly = 1)`), 내부 자료구조 모양. 호출 횟수는 그 자체가 계약일 때만(예: "결제는 정확히 한 번만 consume") 단정한다.
- **효과**: 구현을 리팩터해도 살아남는 테스트. 리팩터마다 깨지는 테스트는 구현을 베낀 테스트라는 신호다.

이는 [`TESTABILITY_SEAMS.md`](./TESTABILITY_SEAMS.md) 의 `FakeXxx` 주입과 같은 방향이다 — mock 으로 상호작용을 단정하기보다 Fake 로 상태를 관찰한다.

---

## 5. ROI 우선순위 — 어디부터 테스트하는가

테스트 예산은 유한하다. 깨졌을 때 비용이 큰 곳부터 덮는다.

**high (먼저 · 두껍게)**
- 핵심 도메인 로직 — UseCase, 정책 계산, 상태 기계.
- **고위험 도메인 — Auth / Billing / Data / Backend** (`auth-rules.md` · `billing-rules.md` · `supabase-handling.md` SoT + `CLAUDE.md §5` STOP #1 정합). 여기 회귀는 사용자에게 직접 손실.
- 실패·경계·에러 경로 — 빈 입력, 만료 토큰, 네트워크 끊김, 한도 초과.
- StateFlow 를 노출하는 ViewModel 의 상태 전이.
- mapper / parser — 경계에서 데이터가 깨지기 쉽다.

**low / skip (얇게 또는 생략)**
- trivial getter · 단순 data class(DTO) 의 필드 왕복.
- 로직 없는 순수 렌더링 Composable.
- 생성 코드 · 프레임워크 코드(테스트하면 프레임워크를 테스트하는 셈).

순서가 핵심이다: 커버리지 100% 를 trivial 코드로 채우는 것보다, Auth 토큰 만료 경로 한 줄을 덮는 것이 ROI 가 높다.

---

## 6. 여러 경우 의무 (Multiple-case)

테스트 단위마다 다음 경우를 함께 쓴다. 정상 한 줄로 끝내지 않는다.

| 경우 | 예 |
|---|---|
| **happy** | 정상 입력 → 기대 출력 |
| **경계(boundary)** | 0 / 1 / 최대 / 빈 컬렉션 / 첫·마지막 항목 |
| **에러·실패** | 잘못된 입력, 네트워크 실패, 권한 없음 → typed 오류 반환 |
| **(해당 시) empty/null/동시성** | null 정체성, 빈 backup, 동시 갱신 race |

반복되는 입력-기대 쌍은 parameterized / table-driven 으로 묶는다(kotlin-test parameterized, kotest data-driven). 같은 단언을 복붙하지 않는다.

---

## 7. 네이밍 + 가독성

이름이 깨진 케이스를 설명하게 한다.

- 형식: `대상_조건_기대결과` (예: `getJournal_whenRepositoryFails_returnsDomainError`) 또는 backtick 문장형 `` `should return error when token expired` ``.
- 테스트는 **DAMP > DRY**: 약간의 중복을 감수하더라도 각 테스트가 자기 맥락(given/when/then)을 그대로 읽히게 둔다. 과한 공통 헬퍼는 실패 원인을 숨긴다.
- 한 테스트 = 한 동작. 한 함수에서 여러 무관한 것을 단언하지 않는다.

---

## 8. Flaky 처리 — 결정적 seam 의무

flaky 의 근원은 대부분 주입하지 않은 외부 의존이다. [`TESTABILITY_SEAMS.md`](./TESTABILITY_SEAMS.md) 의 seam 을 끊으면 대부분 사라진다.

- 실 시계 / 실 dispatcher / 실 uuid / 실 network 를 테스트에서 직접 쓰지 않는다(0).
- 코루틴은 `kotlinx-coroutines-test` 의 `TestDispatcher` + `runTest`. `Thread.sleep` / `delay` 실시간 대기 금지.
- Flow 단언은 Turbine(`test { awaitItem() }`).
- flaky 가 발견되면 **격리 후 수정**한다. `@Ignore` / `@Disabled` 로 묻어두고 누적하는 것을 금지한다 — 비활성 테스트가 쌓이면 그 경로는 사실상 무방비다.

---

## 9. 커버리지 = 신호이지 목표가 아님

- 수치 게이트(예: "라인 80% 미만이면 빌드 실패")를 강제하지 않는다. 임의 숫자를 맞추려는 brittle 한 테스트를 유발한다.
- 대신 리뷰가 **변경분의 ROI-coverage** 를 판정한다(`verification-and-review.md` REVIEW §7 + 본 문서 §5). "이번에 바꾼 고위험 동작에 테스트가 붙었는가?" 가 질문이다.
- kover 등 커버리지 도구가 있으면 그 출력을 **신호**로 본다 — 어느 경로가 안 덮였는지 가리키는 지도이지, 통과/실패 기준이 아니다. 수치 게이트 표준화는 별도 cycle(`ktlint-warn-gate` 동종)의 몫이다.

---

## 10. 지속 유지보수 — 테스트는 문서와 동급 context

테스트는 한 번 쓰고 끝나는 산출물이 아니라 계속 따라가는 유지보수 대상이다.

- 매 구현 cycle 에서 바뀐 동작에 테스트를 추가/확장한다. 리뷰 §7 이 이를 점검한다(비블로커지만, 고위험 경로 누락은 follow-up TODO 권장).
- 제거된 API 를 참조하는 테스트, 비활성(`@Ignore`)으로 쌓인 테스트는 **test drift** 로 표면화한다(문서 드리프트와 같은 성격). 방치하면 그 경로의 신뢰가 조용히 사라진다.
- 테스트 자산을 SoT 문서와 동급으로 다룬다 — CLI session 이 지속 관리하는 "유지보수 필수 context"의 일부다.

---

## 11. Per-layer 케이스 예시

각 layer 가 §6 의 여러 경우를 어떻게 갖추는지 구체 예시. (도구 매핑은 §12.)

### 11.1 UseCase — happy / boundary / error

```kotlin
// shared/domain/commonTest
class GetJournalUseCaseTest {

    @Test
    fun invoke_whenEntriesExist_returnsSortedByDate() = runTest {       // happy
        val repo = FakeJournalRepository(seed = listOf(older, newer))
        val result = GetJournalUseCase(repo, FakeClock())()
        assertEquals(listOf(newer, older), (result as Result.Success).value)
    }

    @Test
    fun invoke_whenNoEntries_returnsEmptyList() = runTest {              // boundary
        val result = GetJournalUseCase(FakeJournalRepository(), FakeClock())()
        assertTrue((result as Result.Success).value.isEmpty())
    }

    @Test
    fun invoke_whenRepositoryFails_returnsDomainError() = runTest {      // error
        val repo = FakeJournalRepository(failWith = DomainError.Storage)
        val result = GetJournalUseCase(repo, FakeClock())()
        assertEquals(DomainError.Storage, (result as Result.Failure).error)
    }
}
```

### 11.2 Repository — Fake DAO 주입(integration)

DAO interface 를 in-memory Fake 로 주입해 실 DB 없이 저장/조회 계약을 검증한다. `FakeXxx` 패턴은 [`TDD_WORKFLOW.md`](./TDD_WORKFLOW.md) §2.

```kotlin
val repo = OfflineJournalRepository(dao = FakeJournalDao(), clock = FakeClock())
repo.save(entry)
assertEquals(listOf(entry), repo.observe().first())   // 저장→관찰 왕복
```

### 11.3 ViewModel — StateFlow 전이(Turbine)

```kotlin
@Test
fun load_emitsLoadingThenContent() = runTest {
    val vm = JournalViewModel(GetJournalUseCase(FakeJournalRepository(seed = listOf(entry)), FakeClock()))
    vm.uiState.test {                              // Turbine
        assertEquals(JournalUiState.Loading, awaitItem())
        assertEquals(JournalUiState.Content(listOf(entry)), awaitItem())
        cancelAndIgnoreRemainingEvents()
    }
}
```

### 11.4 mapper — round-trip

```kotlin
@Test
fun dtoToDomainToDto_isLossless() {                // 경계에서 데이터 보존 확인
    val dto = JournalEntryDto(id = "1", body = "x", createdAtMillis = 1_700_000_000_000)
    assertEquals(dto, dto.toDomain().toDto())
}
```

### 11.5 도메인 정책 — Auth / Billing (high-ROI)

```kotlin
// Auth — 익명 부트스트랩 / 토큰 만료 (auth-rules.md SoT)
@Test fun bootstrap_whenNoSession_createsAnonymousUser() = runTest { /* ... */ }
@Test fun currentUserId_whenTokenExpired_triggersReBootstrap() = runTest { /* ... */ }

// Billing — entitlement / consume (billing-rules.md SoT)
@Test fun verify_whenReceiptInvalid_returnsReceiptInvalidError() = runTest { /* ... */ }
@Test fun consume_whenOffline_doesNotDecrementBalance() = runTest { /* 낙관적 차감 금지 */ }
```

이 두 도메인은 §5 의 high-ROI 영역이자 `CLAUDE.md §5` STOP #1 경로다 — 경계·실패 케이스를 반드시 함께 둔다.

---

## 12. 프레임워크 매핑 (본 패키지 실 설치)

전략을 본 패키지에 이미 설치된 도구로 옮긴다. (새 테스트 의존 추가 시 `workflow-core.md` §implement DependencyDecision 8항 적용.)

| 용도 | 도구 | 층 |
|---|---|---|
| 단언 / 러너 | `kotlin-test` · JUnit | unit |
| 코루틴 | `kotlinx-coroutines-test`(`runTest` · `TestDispatcher`) | unit |
| Flow 단언 | Turbine | unit |
| mock(상호작용 계약 한정) | MockK | unit |
| property / data-driven | Kotest | unit |
| Android API 표면 | Robolectric | integration(Medium) |
| 화면 스냅샷 | Roborazzi | integration/e2e |
| Compose 의미트리 | Compose UI test | e2e |
| iOS 화면 | XCUITest | e2e |

mock(MockK)은 상호작용이 계약일 때로 제한한다 — 기본은 §4 대로 Fake 로 상태를 관찰한다.

---

## 13. 본 문서의 변경 정책

- cli infra 권장 byte-identical (5-repo · master + app-foundation + GentlyBreath + GentlyDay + GentlyTable · 보호 5 file 외).
- 변경 시 master cycle 신설 + 5-repo propagation (`cycle-discipline.md` §15 패턴 1). 자식 repo 직접 수정 금지.

---

## 14. 명시 cycle 이력

- 2026-06-01 · MASTER-CLI-TESTING-STRATEGY-001 · 본 문서 신설(피라미드 · test size · behavior · ROI 우선순위 · multiple-case · 네이밍 · flaky · 커버리지 신호 · 지속 유지보수 · per-layer 예시) + `rule-routing-index.md` 배선(§A L2 pointer · §B 구현형/UI-UX형/API-서버형 · §C GSM · §F 이력) + `test-strategist` 재활성 + review §7 확장. 기존 `TDD_WORKFLOW.md` + `TESTABILITY_SEAMS.md` 본문 무변경(pointer 인용만). 5-repo byte-identical propagation.
