# TDD Workflow — FakeXxx First

> **목적**: 새 UseCase, Repository, Coordinator 작성 시 테스트 우선 흐름을 강제한다.
> **표준 패턴**: `FakeXxx` / `StubXxx` 주입 — 실제 플랫폼 의존 없이 commonTest / JVM unit test 에서 실행 가능.

---

## 1. TDD 적용 대상

| 컴포넌트 | TDD 의무 |
|---|---|
| 새 UseCase | 필수 |
| 새 Repository interface | 필수 |
| 새 Coordinator / Orchestrator | 필수 |
| StateFlow 흐름이 있는 ViewModel | 필수 |
| 단순 Composable (UI 렌더링만) | 선택 |
| 데이터 변환 함수 (pure function) | 선택 |

---

## 2. FakeXxx 표준 패턴

```kotlin
// shared/domain/src/commonMain
interface JournalRepository {
    suspend fun save(entry: JournalEntry): Result<Unit, DomainError>
    fun observe(): Flow<List<JournalEntry>>
}

// shared/domain/src/commonTest
class FakeJournalRepository : JournalRepository {
    private val entries = MutableStateFlow<List<JournalEntry>>(emptyList())
    val savedEntries: List<JournalEntry> get() = entries.value

    override suspend fun save(entry: JournalEntry): Result<Unit, DomainError> {
        entries.value = entries.value + entry
        return Result.Success(Unit)
    }

    override fun observe(): Flow<List<JournalEntry>> = entries
}
```

---

## 3. 테스트 위치

| 테스트 종류 | 위치 |
|---|---|
| domain 순수 로직 | `shared/domain/src/commonTest` ([app-foundation/shared/domain/](../../../../app-foundation/shared/domain/)) (KMP) 또는 `app/src/test` (단일 모듈) |
| ViewModel + StateFlow | `shared/feature-state/src/commonTest` ([app-foundation/shared/feature-state/](../../../../app-foundation/shared/feature-state/)) 또는 `app/src/test` |
| Android UI (Compose) | `app/src/androidTest` (instrumented) |
| iOS UI | `iosApp/<...>Tests` (XCUI) |

---

## 4. 심 주입 항목

테스트에서 fake 가능해야 하는 외부 의존:
- **시간**: `Clock` 또는 `DateProvider` — `System.currentTimeMillis()` / `Clock.System.now()` 직접 사용 금지
- **디스패처**: `CoroutineDispatcher` 주입 — `Dispatchers.IO` / `Dispatchers.Main` 직접 사용 금지
- **사용자 정체성**: `UserIdentityProvider` — domain 에서 인증 SDK 직접 호출 금지
- **로거**: 추상 로거 인터페이스 사용
- **무작위값/UUID**: 주입 가능한 provider

상세: `TESTABILITY_SEAMS.md`

---

## 5. PLAN.md 기록 의무

새 테스트 파일은 PLAN `## 7. TestabilitySeams` 섹션에 명시:

```markdown
## 7. TestabilitySeams

- 테스트 파일: `shared/domain/src/commonTest/.../GetJournalUseCaseTest.kt`
- FakeXxx 사용: `FakeJournalRepository`, `FakeClock`
- 심 주입 대상: clock, dispatcher (둘 다 생성자 주입)
- 심 연기 시 명시적 사유: N/A
```

연기 사유가 있다면 명시:
- "single-shot data fetcher 라 dispatcher 주입 불필요" 등 구체적 근거 필수

---

## 6. Red → Green → Refactor 사이클

1. **Red**: 실패하는 테스트 작성 (FakeXxx 으로 의존 격리)
2. **Green**: 최소 코드로 통과
3. **Refactor**: 중복 제거, 명확화 — 테스트는 항상 통과 유지

SoftBudget 초과 예상 시 추상화 추가보다 task 분할.

---

## 7. 관련 문서

- `TESTABILITY_SEAMS.md` — 심 주입 대상 상세
- `MODEL_SEPARATION.md` — 테스트 시 모델 경계
- `.claude/rules/workflow.md` — TDD 우선 흐름
- `.claude/rules/verification-and-review.md` — 검증 명령 의무
