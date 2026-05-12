# Koin DI Baseline

> **목적**: 모든 레포에서 Dependency Injection 구성을 일관되게 유지한다.
> **선택 근거**: KMP/CMP 양쪽에서 동작하며, framework-neutral 한 `shared/domain` ([app-foundation/shared/domain/](../../../../app-foundation/shared/domain/)) 을 오염시키지 않는다.

---

## 1. 기본 정책

- 레포 기본 DI는 **Koin**.
- 다른 DI 프레임워크(Hilt, Dagger, Anvil 등) 추가는 금지.
- DI 모듈 정의 위치는 아래 3곳으로 제한.

---

## 2. Koin 배치 허용 위치

| 위치 | 역할 |
|---|---|
| `shared/app/` | 공통 Koin 모듈 정의 (`appModule`, `dataModule`, `domainModule`) |
| `app/` (Android) | Android-specific Koin 모듈 + `startKoin {}` 호출 |
| `iosApp/` (iOS, 향후) | iOS-specific Koin 모듈 + `initKoin()` bridge |

**금지 위치**:
- `shared/domain/**` ([app-foundation/shared/domain/](../../../../app-foundation/shared/domain/)) — Koin import 금지 (framework-neutral 유지)
- `shared/feature-state/**` ([app-foundation/shared/feature-state/](../../../../app-foundation/shared/feature-state/)) — Koin import 금지 (ViewModel은 생성자 주입만, Koin이 ViewModel 만들 때 wiring)
- `shared/data/**` ([app-foundation/shared/data/](../../../../app-foundation/shared/data/)) — Koin import 금지 (Repository 구현체는 생성자 주입만)

---

## 3. 단일 모듈 레포의 시작점

target 레포가 단일 `app/` 모듈인 경우:
- `app/src/main/java/<package>/di/` 디렉토리에 Koin 모듈 정의
- `Application.onCreate()` 에서 `startKoin {}` 호출
- 향후 `shared/app` 으로 모듈을 옮길 때 동일 코드가 그대로 이전 가능하도록 작성

---

## 4. ViewModel 주입

**KMP 환경 (CMP ViewModel)**:
```kotlin
// shared/feature-state
class HomeViewModel(
    private val getThings: GetThingsUseCase,
    private val clock: Clock,
) : ViewModel() { ... }

// shared/app
val featureStateModule = module {
    factory { HomeViewModel(get(), get()) }
}
```

**Android 단독 환경 (androidx.lifecycle.ViewModel)**:
```kotlin
// koin-androidx-compose
val viewModel: HomeViewModel = koinViewModel()
```

---

## 5. Koin 의존성 추가 시 DependencyDecision

새 Koin artifact 추가는 `libs.versions.toml` 변경에 해당 → PLAN `## 2. DependencyDecision` 8개 항목 필수.
- `io.insert-koin:koin-core` (KMP common)
- `io.insert-koin:koin-android` (Android)
- `io.insert-koin:koin-androidx-compose` (Compose Android)

---

## 6. 기존 container 잔존 처리

기존에 직접 만든 DI container 가 남아 있다면:
- thin bridge로 유지 — Koin 으로의 진입점 역할만
- 실질 wiring source of truth 는 Koin 모듈 정의 파일이어야 한다
- 점진적으로 thin bridge 제거

---

## 7. 관련 문서

- `KMP_CMP_LAYER_DIRECTION.md` — Koin 배치 위치의 레이어 근거
- `TESTABILITY_SEAMS.md` — DI 통한 심 주입
- `.claude/rules/workflow.md` — 직접 구현 우선 원칙
