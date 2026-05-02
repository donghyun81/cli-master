# API Spec — `<RepoName>`

> **template 출처**: master `docs/templates/api-spec.template.md` (cp 후 도메인 채움).
> **단일 목적**: 본 repo 의 모든 API endpoint + DTO + 에러 모델 단일 출처.
> **연관**: `docs/agent/architecture/MODEL_SEPARATION.md` (DTO ≠ DomainModel 의무) + `ERROR_RESULT_POLICY.md` (typed Result + sealed DomainError).

## 0. 메타

- 도메인: `<예: 호흡 / 일상 / 식단>`
- backend: `<예: Supabase Edge Function · 미연결 시 "TODO(user-prep)">`
- 최종 갱신: `YYYY-MM-DD`

## 1. base URL + 인증

- base: `<https://<project>.supabase.co/functions/v1>`
- 인증: `<예: Authorization: Bearer <jwt> · anon key 노출 금지>`

## 2. endpoint list

| method | path | 목적 | request DTO | response DTO | 에러 |
|---|---|---|---|---|---|
| GET | `/<endpoint>` | `<설명>` | `<DTO>` | `<DTO>` | `<DomainError>` |

## 3. DTO 정의 (Kotlin · @Serializable)

```kotlin
@Serializable
data class <DtoName>Request(
    val field: String,
    // ...
)

@Serializable
data class <DtoName>Response(
    val field: String,
    // ...
)
```

## 4. 에러 모델 (sealed)

```kotlin
sealed interface <Domain>Error {
    object NetworkUnavailable : <Domain>Error
    data class ServerError(val code: Int, val message: String) : <Domain>Error
    // ...
}
```

## 5. Repository → DomainModel 변환

DTO 의 nullable / 표현 제약 → DomainModel 의 strict typing 변환 의무 (MODEL_SEPARATION).

## 6. 변경 정책

API breaking change → STOP + Coin 명시 승인 + version 박음.
