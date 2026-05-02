# Data Model — `<RepoName>`

> **template 출처**: master `docs/templates/data-model.template.md`.
> **단일 목적**: 본 repo 의 도메인 model + entity + DTO 매핑 단일 출처.
> **연관**: `MODEL_SEPARATION.md` + `ERROR_RESULT_POLICY.md` + `data-and-migrations` (활성 시 deferred-domains.md §1 trigger).

## 1. DomainModel (도메인 typed)

```kotlin
data class <Domain>(
    val id: <Domain>Id,    // value class 권장
    val createdAt: Instant,
    // ...
)
```

## 2. Entity (Room / SQLite · 활성 시)

```kotlin
@Entity(tableName = "<table>")
data class <Domain>Entity(
    @PrimaryKey val id: String,
    // ...
)
```

## 3. DTO ↔ Entity ↔ DomainModel 매핑 표

| 필드 | DTO | Entity | DomainModel | 변환 비고 |
|---|---|---|---|---|
| id | `String` | `String` | `<Domain>Id (value class)` | DTO 생성 시 검증 |

## 4. Migration patterns (Room 활성 시)

- `fallbackToDestructiveMigration()` 금지 (`safety-and-secrets.md`)
- 모든 schema 변경 = `MIGRATION_X_Y` 클래스 + 단위 테스트 의무

## 5. 변경 정책

DB schema 변경 → STOP + `data-schema-guardian` agent 발화 + Coin 승인.
