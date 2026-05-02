# Screen Flow — `<RepoName>`

> **template 출처**: master `docs/templates/screen-flow.template.md`.
> **단일 목적**: 본 repo 의 모든 화면 + 화면 간 navigation + state 진입 / 종료 조건.
> **연관**: `pencil-uiux-workflow.md` + `design-sot-policy.md` + `KMP_CMP_LAYER_DIRECTION.md`.

## 1. 화면 inventory

| ID | 화면 이름 | route | lifecycle | 진입 조건 | 종료 조건 |
|---|---|---|---|---|---|
| A-0 | 디자인 토큰 | (Pencil only) | active | - | - |
| A-1 | `<예: 스플래시>` | `splash` | active | 앱 시작 | 인증 상태 따라 분기 |

## 2. navigation graph

```
splash → onboarding (첫 실행) 또는 home (인증됨)
home ⟷ <feature1>
home → settings → ...
```

## 3. 화면 별 state matrix

| 화면 | state 1 | state 2 | state 3 |
|---|---|---|---|
| A-1 splash | loading | error | navigate-to-onboarding |

## 4. SoT 매핑

| 화면 | Visual SoT (`.pen`) | Structural SoT (`.ui-spec.json`) | Compose entry |
|---|---|---|---|
| A-1 | `docs/design/pencil-sot/A-1.pen` | `docs/design/pencil-sot/A-1.ui-spec.json` | `app/src/main/java/com/example/<repo>/feature/splash/SplashScreen.kt` |

## 5. 변경 정책

화면 추가 / 삭제 → `pencil-uiux-workflow.md` 5-type 분류 적용 + 본 표 갱신.
