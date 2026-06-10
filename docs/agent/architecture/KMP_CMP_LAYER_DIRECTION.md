# KMP/CMP Layer Direction — Shared-First Architecture

> **목적**: Kotlin Multiplatform / Compose Multiplatform 전환 시 단방향 레이어 흐름을 강제한다.
> **불변 원칙**: I2 — `shared/domain` ([app-foundation/shared/domain/](../../../../app-foundation/shared/domain/)) 은 `shared/data` ([app-foundation/shared/data/](../../../../app-foundation/shared/data/)), `shared/feature-state` ([app-foundation/shared/feature-state/](../../../../app-foundation/shared/feature-state/)), `shared/app`, `app/`, `iosApp/` 어떤 것도 import 할 수 없다.

---

## 1. 표준 레이어 흐름

```
shared/domain  ←  shared/feature-state  ←  shared/app  ←  app/  +  iosApp/
       ↑                                                          
shared/data ────────────────────────────────────────────────────┘ (Repository 구현체만 data → domain interface 에 의존)
```

규칙:
- **`shared/domain`**: 순수 Kotlin, framework-neutral. 다른 모듈을 import 하지 않는다.
- **`shared/data`**: domain interface 의 구현체. domain 으로 단방향 의존.
- **`shared/feature-state`**: ViewModel · 상태 흐름 · 라우트 정의. domain 만 import.
- **`shared/app`**: glue 계층 — Koin DI 모듈, 플랫폼 wiring, common entry point.
- **`app/`** (Android): Android-specific shell, 화면 Composable, navigation host.
- **`iosApp/`** (iOS): SwiftUI shell, KMP 진입점.

---

## 2. 단일 모듈 (Android-only) 레포의 시작점

target 레포가 KMP 전 단계 (단일 `app/` 모듈) 인 경우:
- `app/src/main/java/<package>/data/`, `domain/`, `ui/` 하위 패키지로 동일한 단방향을 시뮬레이션
- 향후 KMP 전환 시 패키지 → 모듈 분리가 단순해지도록 import 방향을 미리 단속
- `check-architecture.sh` 는 레포 구조에 맞춰 starter로 동작 (모듈 부재 시 UNKNOWN, 위반 시 FAIL)

---

## 3. 금지 import (I2 위반)

```
shared/domain/**  →  shared/{data,feature-state,app}/**     # 금지
shared/domain/**  →  app/** , iosApp/**                     # 금지
shared/feature-state/**  →  shared/{data,app}/**            # 금지 (Repository는 domain interface 통해서만)
shared/data/**  →  shared/{feature-state,app}/**            # 금지 (data는 domain만)
```

검사 방법:
- `.claude/agents/layer-checker.md` 의 read-only 스캔
- `.claude/commands/check-layer.md` 슬래시 커맨드

(구 `compound-lint.sh` I2 source check = deprecated · 도구 부재 · MASTER-CLI-COMPOUND-LINT-DEPRECATE-001 — I2 검사 의무는 위 2 실존 수단이 담당)

---

## 4. 경계 매핑 위치

> 본 항목의 SoT = [`MODEL_SEPARATION.md §2`](./MODEL_SEPARATION.md) (DTO/Entity/DomainModel/UiState 경계 변환 위치 = Repository · UseCase · ViewModel · 내부 계층 하위 의존 금지). 본 file 은 가리키기만 한다(중복 금지). 본 §은 위 경계 매핑이 §1 단방향 레이어 흐름·§3 I2 금지 import 와 정합함을 확인하는 navigation 지점이다.

---

## 5. 전환 단계별 체크리스트

**Phase 0 (단일 모듈)**: target 레포 현재 상태
- [x] `app/` 모듈 1개
- [ ] 패키지 단위 단방향 흐름 도입
- [ ] `check-architecture.sh` starter 통과 (UNKNOWN 모듈 수용)

**Phase 1 (shared 모듈 추가)**:
- [ ] `shared/domain` 모듈 생성, framework 의존성 0
- [ ] `shared/data` 모듈 생성, domain interface 구현
- [ ] I2 위반 0 확인

**Phase 2 (feature-state + app glue)**:
- [ ] `shared/feature-state` 에 ViewModel 이전
- [ ] `shared/app` 에 Koin 모듈 통합
- [ ] Android `app/` 는 shell only

**Phase 3 (iOS 추가)**:
- [ ] `iosApp/` SwiftUI shell 추가, shared/app 호출

---

## 6. 관련 문서

- `KOIN_DI_BASELINE.md` — DI 배치 제약
- `MODEL_SEPARATION.md` — 경계 통과 시 모델 변환 원칙
- `.claude/rules/workflow.md` — 변동성 경계 추상화 원칙
