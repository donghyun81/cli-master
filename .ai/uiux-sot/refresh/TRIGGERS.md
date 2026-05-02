# Refresh Triggers

## Trigger Paths

| Path or file | Default level | Why |
|---|---|---|
| repo screen Composable directory (Android UI source under `<APP_PKG>` 네임스페이스) | `PARTIAL` | 화면 copy, icon, layout, leaf UI drift 가능성 |
| `app/src/main/res/**` | `PARTIAL` | strings, drawable, icon, resource drift 가능성 |
| `shared/feature-state/**` | `FULL` | shared route and visible state authority |
| `shared/app/**` | `FULL` | shared shell and visible-state glue |
| iOS app source root (shell / visible state / route 관련 파일) | `FULL` | iOS shell baseline 영향 |
| `<APP_ROUTES>` | `FULL` | route authority 직접 변경 |
| `<APP_ROOT_COMPOSABLE>` | `FULL` | Android NavHost and route wiring 직접 변경 |
| `<APP_ROOT_STATE>` | `FULL` | visible-state orchestration 직접 변경 |
| `.ai/uiux-sot/**`, `CLAUDE.md`, `.claude/skills/**`, `.claude/rules/**`, `docs/agent/**` | `DOC-ONLY` | baseline package / workflow / policy sync only |

## Level Promotion Rules

- `FULL` refresh:
  - navigation, shell, route, visible state, overlay return path, or iOS shell behavior가 바뀐 경우
  - `<APP_ROUTES>`, `<APP_ROOT_COMPOSABLE>`, `<APP_ROOT_STATE>`, `shared/app/**`, relevant iOS shell files touch
- `PARTIAL` refresh:
  - copy, icon, layout, resource 변경만 있고 route/state wiring은 그대로인 경우
  - screenshots/XML 재캡처 범위는 changed surface로 제한 가능
- `DOC-ONLY` sync:
  - package manifest, coverage, route inventory, workflow docs, rules, skills만 갱신하는 경우
  - runtime capture 미실행이면 `BASELINE_PENDING_REFRESH` 를 유지한다

## Decision Notes

- ambiguous case는 `FULL` 로 상향한다.
- seed audit 재사용은 trigger 수준과 무관하게 금지다.
- history comparison은 `git diff` 로 수행하며 package 내부 snapshot으로 대체하지 않는다.
