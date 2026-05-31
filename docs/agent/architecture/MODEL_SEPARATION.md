# Model Separation — DTO / Entity / DomainModel / UiState

> **목적**: 레이어를 횡단하는 객체 재사용을 금지하여 결합도를 낮추고 회귀 위험을 차단한다.
> **불변 원칙**: 동일 객체를 여러 레이어에 직접 전달하지 않는다. 경계 통과 시 반드시 변환한다.

---

## 1. 4가지 모델 종류

| 모델 | 위치 | 책임 |
|---|---|---|
| `DTO` | `data/remote/` (data layer) | 네트워크·직렬화 경계 표현 (Json, Protobuf) |
| `Entity` | `data/local/` (data layer) | DB 테이블 매핑 (Room `@Entity`) |
| `DomainModel` | `domain/` 또는 `shared/domain/` ([app-foundation/shared/domain/](../../../../app-foundation/shared/domain/)) | 비즈니스 로직이 다루는 순수 모델 |
| `UiState` | `ui/` 또는 `feature-state/` (presentation) | UI 렌더링 전용 불변 상태 |

---

## 2. 변환 위치 (경계 매핑)

| 변환 | 위치 |
|---|---|
| `DTO` → `DomainModel` | Repository (data → domain 경계 진입점) |
| `Entity` → `DomainModel` | Repository (data → domain 경계 진입점) |
| `DomainModel` → `UiState` | ViewModel 또는 전용 Mapper (feature-state → UI 경계) |
| `UiState` → 사용자 액션 | ViewModel 의 Intent/Event handler — Domain UseCase 호출 |

경계 매핑(데이터 변환)은 **Repository · UseCase · ViewModel(또는 전용 Mapper) 경계에서만** 수행한다. 내부 계층은 하위 계층 모델에 직접 의존하지 않는다(I2 불변 원칙 준수). 경계를 넘는 변환이 추가·변경되면 PLAN `## 4. ModelBoundaryPlan` 에 기록한다.

---

## 3. 금지 패턴

### 3.1 DTO 를 ViewModel 까지 그대로 전달
```kotlin
// ❌ 금지
class HomeViewModel(repo: HomeRepository) {
    val state: StateFlow<HomeDto> = ...  // DTO 가 UI 까지 노출
}
```

### 3.2 DomainModel 을 UiState 로 직접 사용
```kotlin
// ❌ 금지
data class JournalUiState(
    val entries: List<JournalEntry>  // JournalEntry 가 DomainModel — UI 가 domain 에 의존
)
```

### 3.3 Entity 를 도메인 로직에서 직접 참조
```kotlin
// ❌ 금지
class CalculateAverage {
    fun invoke(entries: List<JournalEntryEntity>): Double = ...  // Entity 가 domain 에 침투
}
```

---

## 4. 허용 패턴

```kotlin
// ✅ DTO → DomainModel 변환은 Repository 안에서
class HomeRepositoryImpl(
    private val api: HomeApi,  // returns HomeDto
) : HomeRepository {
    override suspend fun getHome(): Result<Home, DomainError> =
        api.getHome().mapToDomain()  // DTO → DomainModel 변환
}

// ✅ DomainModel → UiState 변환은 ViewModel 안에서
class HomeViewModel(
    private val getHome: GetHomeUseCase,
) : ViewModel() {
    val state: StateFlow<HomeUiState> = getHome()
        .map { home -> HomeUiState.from(home) }
        .stateIn(...)
}
```

---

## 5. PLAN.md 기록 의무

모델 변경이 있는 task 는 PLAN `## 4. ModelBoundaryPlan` 섹션 작성:

```markdown
## 4. ModelBoundaryPlan

- DTO 변경: HomeDto.{newField} 추가
- Entity 변경: N/A
- DomainModel 변경: Home.{newField} 추가
- UiState 변경: HomeUiState.{newField} 추가 (DomainModel → UiState 변환에서 매핑)
- 경계 매핑 추가/변경: HomeRepositoryImpl.mapToDomain() 갱신
- I2 import 방향 영향: 없음 (data → domain 단방향 유지)
```

---

## 6. REVIEW.md 5번 섹션 검사

reviewer 가 `## 5. Model Separation` 섹션에서 검사:
- UiState 가 DomainModel 과 분리됨: 확인
- UI 단방향 흐름: 확인
- 경계 매핑 변환 위치: 확인 (Repository · UseCase · ViewModel 안에서만)

위반 시 블로커 — REVIEW FAIL.

---

## 7. 관련 문서

- `KMP_CMP_LAYER_DIRECTION.md` — 레이어 흐름과 import 방향
- `SSOT_PRINCIPLES.md` — 단일 출처 표시 규칙
- `.claude/rules/workflow.md` — 모델 분리 원칙
- `.claude/rules/ui-ux-analysis.md` — UiState 정책
