# Compose Stability & Baseline Profile Guide

> 이 문서는 multi-repo propagation 대상이며 byte-identical 로 복사된다.
> SOT: `docs/agent/architecture/COMPOSE_STABILITY.md`
> 관련: `docs/agent/architecture/DEPENDENCY_DECISION_CHECKLIST.md`, `docs/rules/ui-ux-analysis.md`

---

## 1. 목적

Jetpack Compose / Compose Multiplatform 환경에서 **불필요한 recomposition** 을 줄이고,
앱 startup / scroll 성능을 예측 가능한 수준으로 유지하기 위한 공통 원칙을 정의한다.

이 문서는 **가이드** 이며 실제 build.gradle 플러그인 적용, baseline profile 생성 등은
각 repo 의 별도 후속 제품 task 에서 수행한다.

---

## 2. 왜 안정성이 중요한가

Compose runtime 은 입력 타입의 안정성 (`Stable` / `Immutable`) 을 기반으로
동일 입력 시 recomposition 을 skip 할 수 있다. 타입이 `Unstable` 로 추론되면
runtime 은 skip 가능 여부를 알 수 없어 보수적으로 재실행한다.

**결과**: 리스트/차트/애니메이션에서 의도치 않은 recomposition 비용이 누적되며
scroll jank, 불필요한 frame drop, 전력 소모가 발생한다.

---

## 3. 기본 분류 규칙

### 3.1 Stable 로 추론되는 타입

- `Int`, `Long`, `Float`, `Double`, `Boolean`, `Char`, `String`
- `val` 로만 구성된 primitive / String data class
- `@Stable` / `@Immutable` 어노테이션이 붙은 클래스
- Compose 가 제공하는 stable collection 어댑터 (예: `ImmutableList` — kotlinx.collections.immutable)

### 3.2 Unstable 로 추론되는 타입

- Kotlin stdlib 의 `List`, `Set`, `Map` 등 mutable 가능 인터페이스
- `var` 프로퍼티를 포함한 data class (중 하나라도 var 이면 전체가 unstable)
- 외부 모듈의 unknown 타입 (compiler 가 시야 밖에 있으면 unstable 로 추론)
- `Any` 또는 sealed interface 의 일부 분기가 unstable 인 경우

### 3.3 판정 순서

1. `@Immutable` — 모든 프로퍼티가 영구 불변이며 내부 상태가 observable 하지 않음
2. `@Stable` — 프로퍼티가 변할 수 있으나 변경은 public 관측 가능하며 `equals` 가 일관됨
3. 어노테이션 없음 — compiler 가 구조를 보고 추론 (가장 위험한 경로)

---

## 4. 권장 패턴

### 4.1 UiState 는 항상 `@Immutable` data class

```kotlin
@Immutable
data class ScreenUiState(
    val items: ImmutableList<ItemUi> = persistentListOf(),
    val isLoading: Boolean = false,
    val error: UserFacingError? = null,
)
```

- `var` 프로퍼티 사용 금지
- 내부 collection 은 `kotlinx.collections.immutable` 의 `ImmutableList` / `ImmutableSet` / `ImmutableMap` 사용
- `List<T>` / `Set<T>` / `Map<K,V>` 직접 노출 금지 (unstable 로 추론됨)

### 4.2 Stable flag 는 equals 가 안전할 때만

```kotlin
@Stable
interface ErrorFormatter {
    fun format(error: DomainError): String
}
```

- 인터페이스가 stable 로 선언되면 구현체의 identity 가 유지되는 동안 skip 가능
- singleton / Koin scope 로 주입되는 포매터/매퍼에 적합

### 4.3 Lambda 캡처 주의

- 매번 새 lambda 를 만들면 parameter identity 가 바뀌어 child 가 재실행된다
- `remember { { ... } }` 또는 method reference 로 안정화
- `LaunchedEffect(key1 = ...)` 의 key 에 unstable 타입을 넣지 않는다

### 4.4 Key 기반 list rendering

```kotlin
LazyColumn {
    items(
        items = state.items,
        key = { it.id },
        contentType = { it::class },
    )
}
```

- `key` 는 stable 식별자 (`String`/`Long`) 를 사용
- `contentType` 을 주면 viewType recycle 효율이 오른다

---

## 5. KMP / Compose Multiplatform 주의사항

Compose Multiplatform 환경에서는 동일 stability 원칙이 적용되지만 몇 가지 추가 제약이 있다:

| 항목 | 주의 |
|---|---|
| common `expect/actual` 타입 | actual 쪽이 unstable 이면 common 에서도 전파됨 — 양쪽 모두 `@Immutable` 보장 필요 |
| 플랫폼 의존 타입 노출 | common UiState 가 platform-only 타입을 직접 참조하지 않도록 경계 매핑에서 변환 |
| Coroutines Flow | `StateFlow<UiState>` 가 기본. `Flow<T>` 를 직접 Composable 에 구독시키지 말고 `collectAsStateWithLifecycle()` 경계에서 소비 |
| iOS interop | `@Stable` / `@Immutable` 은 Kotlin 선언 시점에만 유효 — Swift 쪽에서 만든 객체를 common UiState 에 직접 넣지 않는다 |

---

## 6. Compose Stability 진단

### 6.1 Compose compiler metrics (선택)

compose compiler report 를 켜면 각 Composable 의 skippable / restartable / stable 여부를 확인할 수 있다.
실제 적용은 각 repo 의 build 설정 변경이 필요하므로 본 문서 범위 밖이다.

- `TODO(user-prep)`: build.gradle 에 compose compiler report output 경로 설정
- 측정 후 unstable 타입을 `@Immutable` data class 로 교체

### 6.2 레이어별 점검 우선순위

1. `UiState` 최상위 — 반드시 `@Immutable`
2. list item data class — `@Immutable` + `ImmutableList`
3. ViewModel 이 노출하는 StateFlow 원소 — stable
4. 전역 theme / provider 객체 — `@Stable`

---

## 7. Baseline Profile 가이드

### 7.1 목적

Baseline profile 은 앱이 자주 실행하는 critical path 를 사전에 AOT 컴파일하도록 힌트를 제공한다.
cold start 와 첫 scroll 의 jank 를 유의미하게 줄일 수 있다.

### 7.2 언제 도입하는가

아래 조건 중 **2개 이상** 충족할 때 ROI 가 가장 높다:

1. cold start 시간이 사용자 체감상 느리다 (측정치 필요)
2. 첫 화면이 리스트 또는 복잡 차트를 포함한다
3. 릴리즈 빌드가 R8 shrink 를 사용하고 있다
4. Play Store / App Store 배포를 통해 baseline profile 을 실제로 전달할 수 있는 구조다

### 7.3 도입 절차 (개략)

> 실제 적용은 본 문서 범위 밖. 각 repo 의 별도 제품 task 에서 수행한다.

1. **측정 먼저**: Macrobenchmark 로 cold start / frame timing baseline 기록
2. **critical path 정의**: 앱 시작 후 첫 상호작용까지의 대표 시나리오 1~2개 선택
3. **generator 모듈 추가**: `androidx.benchmark:benchmark-macro-junit4` + BaselineProfileRule 기반 generator
4. **profile 생성 실행**: emulator 또는 physical device 에서 generator 실행 → `baseline-prof.txt` 산출
5. **release variant 에 포함**: 모듈의 assets 또는 appropriate generated location 에 배치
6. **재측정**: 같은 macrobenchmark 로 cold start 개선 확인
7. **회귀 방지**: CI 에 macrobenchmark 주기 실행 고려

### 7.4 주의

- baseline profile 은 **측정되지 않은 추측** 에 쓰면 복잡성만 늘린다 — 측정 우선
- profile 파일은 커밋 자산이므로 PR 에서 diff 가 변경되면 이유를 명시한다
- KMP / Compose Multiplatform 환경에서는 Android target 한정으로 적용된다 (iOS 는 별도 최적화 경로)

---

## 8. Anti-patterns

| 안티패턴 | 왜 문제인가 | 대안 |
|---|---|---|
| `UiState` 에 `var` 프로퍼티 | 전체 state 가 unstable 로 추론됨 | `val` + `copy()` |
| `List<T>` 를 UiState 에 직접 노출 | kotlin.collections.List 는 unstable | `ImmutableList<T>` |
| Composable 안에서 `remember` 없는 lambda 생성 | 매 recomposition 마다 새 identity | `remember { { ... } }` |
| `@Stable` 남용 | 잘못 선언하면 stale state 가 노출됨 | equals 일관성 보장 시에만 |
| 측정 없이 baseline profile 생성 | 실제 critical path 가 아닐 수 있음 | macrobenchmark 로 baseline 먼저 |
| 플랫폼 객체를 common UiState 에 담기 | KMP 경계 위반 + stability 추론 실패 | 경계 매핑에서 변환 |

---

## 9. 체크리스트 (UI PR 리뷰용)

- [ ] UiState 가 `@Immutable` data class 이며 모든 프로퍼티가 `val`
- [ ] UiState 내 collection 이 `ImmutableList` / `ImmutableSet` / `ImmutableMap`
- [ ] ViewModel 이 노출하는 StateFlow 의 원소 타입이 stable
- [ ] list rendering 에 `key` 가 지정됨
- [ ] lambda 가 `remember` 또는 method reference 로 안정화됨
- [ ] KMP common 에서 platform-only 타입 노출이 없음
- [ ] cold start / scroll perf 측정이 필요한 변경이면 macrobenchmark 결과 첨부 (해당 시)

---

## 10. 관련 문서

- `docs/agent/architecture/DEPENDENCY_DECISION_CHECKLIST.md` — 새 라이브러리 (예: kotlinx.collections.immutable) 도입 시 8항목 체크
- `docs/rules/ui-ux-analysis.md` — UI 라이브러리 억제 기본값, UiState 분리 원칙
- `docs/agent/architecture/MODEL_SEPARATION.md` — UiState/DomainModel/DTO 경계 (해당 문서가 존재하는 경우)
- `docs/agent/architecture/ADR_TEMPLATE.md` — stability/perf 결정이 설계 수준 변경을 수반하면 ADR 로 기록
