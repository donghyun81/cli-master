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

## 5a. foundation ↔ 앱 책임 경계 (= 기본 선택은 앱의 몫)

- **foundation 은 계약(interface) 과 구현(impl) 을 제공한다.** `EntitlementRepository` 같은 계약과
  `NoOpX` / `MockX` 같은 구현을 **둘 다** 제공하되, **어느 것을 쓸지는 정하지 않는다.**
- **선택은 앱의 조합 루트가 한다.** 앱은 seam 묶음을 **이름을 불러** 구성해 foundation aggregate 에
  넘긴다. foundation 은 넘겨받은 것을 **그대로 bind** 할 뿐이다.
- **aggregate 에 기본 인자를 두지 않는다** — 두는 순간 "앱이 말하지 않아도 돌아가는" 경로가 생기고,
  그 경로는 도구로 검출되지 않는다 (`docs/rules/code-principles.md` §2 암묵 기본값 금지 ·
  Koin verify / Compiler Plugin = *"structural dependency presence, not semantic correctness"*).
- **supersede (구 서술 보존 · 삭제 아님)**: (구 · FND-BILLING-SEAM-001 · 2026-06-05)
  *"foundation 이 production-safe 기본 bind 를 제공하고 자식이 필요 시 override 한다."*
  → 자식이 override 를 **빠뜨려도 아무것도 깨지지 않아** F1(= production entitlement 가 잔액 0 NoOp 으로
  잔존)이 발생. `FND-BILLING-SEAMS-S1-001`(app-foundation `b1ff997`) 로 대체.
- **경계 요약**: foundation = *무엇이 가능한가* · 앱 = *무엇을 쓰는가*.
- 정합: `docs/rules/billing-rules.md` §1 명시 조합 paradigm · 조합 루트는 **`object` 싱글턴이 아니라**
  앱이 수명을 소유하는 인스턴스(= 위 §6 thin bridge 경로와 구분 · Android 공식 AppContainer 형태).

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
