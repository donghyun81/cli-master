# Error / Result Policy — Typed Domain Errors

> **목적**: 새 코드는 예외(Exception) 전파보다 typed 도메인 오류 또는 `Result<T, DomainError>` 를 우선한다.
> **적용 대상**: 새 UseCase · Repository interface · Coordinator. 기존 코드의 전면 교체는 범위 초과.

---

## 1. 기본 원칙

1. **expected failure** 는 예외가 아니라 typed 결과로 표현한다
   - 네트워크 오류, 인증 만료, 입력 검증 실패, 데이터 없음 등
2. **unexpected failure** (프로그래머 오류, system invariant 위반) 만 예외로 throw
   - NPE, IndexOutOfBoundsException, IllegalStateException
3. 도메인 경계에서 typed Result 사용, UI 경계에서 UiState 의 error 필드로 매핑

---

## 2. Result 타입 표준

```kotlin
// shared/domain
sealed interface Result<out T, out E> {
    data class Success<T>(val value: T) : Result<T, Nothing>
    data class Failure<E>(val error: E) : Result<Nothing, E>
}

inline fun <T, E, R> Result<T, E>.map(transform: (T) -> R): Result<R, E> = when (this) {
    is Success -> Success(transform(value))
    is Failure -> this
}
```

또는 외부 라이브러리 (`kotlin.Result`, `Arrow Either`) 사용 — `libs.versions.toml` 변경 시 DependencyDecision 8개 항목 필수.

---

## 3. DomainError sealed 모델링

```kotlin
// shared/domain
sealed interface JournalError {
    data object NotFound : JournalError
    data object Unauthorized : JournalError
    data class Network(val cause: NetworkErrorReason) : JournalError
    data class Validation(val field: String, val reason: String) : JournalError
    data class Unknown(val message: String) : JournalError
}
```

규칙:
- `sealed class` 또는 `sealed interface` 로 명시 (when expression 강제)
- 메시지 문자열만 담는 generic Error 패턴 금지
- 특수 케이스 (`NotFound`, `Unauthorized`) 는 별도 variant 로 표현

---

## 4. UseCase 시그니처

```kotlin
class GetJournalUseCase(
    private val repo: JournalRepository,
) {
    suspend operator fun invoke(id: JournalId): Result<Journal, JournalError> =
        repo.findById(id)
}
```

`throws` 선언 금지 — 모든 expected failure 는 `Result.Failure` 로 표현.

---

## 5. 기존 코드와의 공존

- 기존 코드의 예외 전파는 점진적으로 변경 (한 번에 전면 교체 금지)
- 새 코드 ↔ 기존 코드 경계에서 `runCatching { ... }.toResult()` 패턴 가능
- 변경 범위는 task 단위로 제한 — 별도 task 로 분리

---

## 6. PLAN.md 기록 의무

새 UseCase / Repository 가 있는 task 는 PLAN `## 5. ErrorPolicy` 섹션 작성:

```markdown
## 5. ErrorPolicy

- typed Result 사용 여부: Yes
- 오류 모델 (sealed class/interface 명): JournalError (sealed interface)
- 기존 코드 교체 범위: N/A (새 코드만 적용 — 기존 코드 교체 없음)
```

---

## 7. REVIEW.md 8번 섹션 검사

reviewer 가 `## 8. Error / Result Policy` 섹션에서 검사:
- typed Result 사용 여부
- sealed 오류 모델 정의
- 기존 코드 전면 교체 없음 (범위 초과 시 task 분리 권장)

비블로커 (PARTIAL 가능) — 단, 새 UseCase 에서 typed 오류 전혀 없으면 reviewer 가 follow-up TODO 권장.

---

## 8. 관련 문서

- `MODEL_SEPARATION.md` — 오류도 모델의 일종 (DomainError → UiState.error 변환)
- `TESTABILITY_SEAMS.md` — Result 반환은 fake 가 작성하기 쉬움
- `.claude/rules/workflow.md` — 명시적 오류 처리 원칙
