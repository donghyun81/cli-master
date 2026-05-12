# Testability Seams — Inject External Dependencies

> **목적**: 테스트가 실제 시계·디스패처·인증 SDK 없이 실행 가능하도록 외부 의존을 추상 인터페이스로 주입한다.
> **표준 8개 심**: clock, dispatcher, identity, logger, uuid + (network, DB, file system 변동성 경계)

---

## 1. 심 주입 대상

| 심 | 인터페이스 예 | 직접 사용 금지 대상 |
|---|---|---|
| 시간 | `Clock` / `DateProvider` | `System.currentTimeMillis()`, `Clock.System.now()`, `Date()` |
| 코루틴 디스패처 | `DispatcherProvider` 또는 생성자 주입 `CoroutineDispatcher` | `Dispatchers.IO`, `Dispatchers.Main`, `Dispatchers.Default` 직접 호출 |
| 사용자 정체성 | `UserIdentityProvider` | domain 에서 인증 SDK (Supabase Auth, Firebase Auth) 직접 호출 |
| 로거 | 추상 `Logger` 인터페이스 | `Log.d()`, `println()`, `Timber` 직접 호출 |
| 무작위값/UUID | `UuidProvider` / `RandomProvider` | `UUID.randomUUID()`, `Random.nextInt()` 직접 호출 |
| 네트워크 | Repository interface | data layer 외부에서 HTTP 클라이언트 직접 호출 |
| DB | DAO interface (data 내부) → Repository interface | domain 에서 DAO 직접 호출 |
| 파일 시스템 | `FileStorage` 인터페이스 | `java.io.File`, `okio.FileSystem` 직접 호출 (data layer 외부) |

---

## 2. Clock 심 예

```kotlin
// shared/domain
interface Clock {
    fun now(): Instant
}

// shared/data 또는 shared/app
class SystemClock : Clock {
    override fun now(): Instant = kotlinx.datetime.Clock.System.now()
}

// shared/domain/commonTest
class FakeClock(var instant: Instant = Instant.fromEpochMilliseconds(0)) : Clock {
    override fun now(): Instant = instant
    fun advance(duration: Duration) { instant = instant.plus(duration) }
}
```

---

## 3. Dispatcher 심 예

```kotlin
// 생성자 주입 패턴
class GetThingsUseCase(
    private val repo: ThingsRepository,
    private val ioDispatcher: CoroutineDispatcher,
) {
    suspend operator fun invoke(): Result<List<Thing>, DomainError> =
        withContext(ioDispatcher) {
            repo.getAll()
        }
}

// 테스트
val useCase = GetThingsUseCase(FakeThingsRepository(), UnconfinedTestDispatcher())
```

---

## 4. Identity 심 예

```kotlin
// shared/domain
interface UserIdentityProvider {
    fun currentUserId(): UserId?
    val currentUser: Flow<User?>
}

// shared/data
class SupabaseAuthIdentityProvider(
    private val supabase: SupabaseClient,
) : UserIdentityProvider { ... }

// commonTest
class FakeIdentityProvider(initial: User? = null) : UserIdentityProvider {
    private val user = MutableStateFlow(initial)
    override fun currentUserId(): UserId? = user.value?.id
    override val currentUser: Flow<User?> = user
    fun setUser(u: User?) { user.value = u }
}
```

---

## 5. PLAN.md 기록 의무

PLAN `## 7. TestabilitySeams` 섹션:

```markdown
## 7. TestabilitySeams

- 테스트 파일: `shared/domain/src/commonTest/.../GetThingsUseCaseTest.kt` ([app-foundation/shared/domain/](../../../../app-foundation/shared/domain/))
- FakeXxx 사용: FakeThingsRepository, FakeClock
- 심 주입 대상: clock (생성자), dispatcher (생성자) — 둘 다 적용
- 심 연기 시 명시적 사유: identity/logger/uuid 는 이 task 에서 사용하지 않음 (single-use case 범위)
```

연기 사유는 구체적이어야 한다 — "필요 없음" 같은 모호한 표현은 review FAIL 위험.

---

## 6. REVIEW.md 7번 섹션 검사

reviewer 가 `## 7. TDD Evidence & Testability Seams` 섹션에서 검사:
- FakeXxx 존재 또는 N/A 사유
- StateFlow 테스트 (해당 시)
- 심 기반 테스트 (clock·dispatcher·identity·logger·uuid) 또는 연기 사유

비블로커 — 단, 심 주입 누락이 회귀 위험이 큰 경우 follow-up TODO 권장.

---

## 7. 관련 문서

- `TDD_WORKFLOW.md` — 테스트 우선 흐름
- `KOIN_DI_BASELINE.md` — 심 인터페이스를 Koin 모듈에서 wiring
- `.claude/rules/workflow.md` — 변동성 경계 추상화 원칙
