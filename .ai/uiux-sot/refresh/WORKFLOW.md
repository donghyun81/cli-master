# UI/UX SoT Refresh Workflow

## Read Order

1. current task prompt and task/report artifacts
2. `.ai/uiux-sot/latest/manifest.md`
3. `.ai/uiux-sot/refresh/TRIGGERS.md`
4. `.ai/uiux-sot/refresh/PRECONDITIONS.md` when blocked/unknown gap routes are in scope (repo-specific, optional)
5. `<APP_ROUTES>`
6. `<APP_ROOT_COMPOSABLE>`
7. `<APP_ROOT_STATE>`
8. relevant screen files under the repo's screen Composable directory
9. `<IOS_SHELL_VIEW>` and `<IOS_APP_CONTAINER>` if iOS shell scope exists
10. `.ai/uiux-sot/lineage/seed_audit_reference.md` for historical context only

## Core Principles

- current live code is authoritative
- previous `latest/` is compared, not trusted blindly
- seed lineage is historical reference only
- package policy is latest-only
- authoritative proof requires PNG + XML + matrix row + route/state note
- screenshot-only transient proof is never promoted to current baseline
- package-internal snapshots/history are forbidden
- history and audit trail live in git branch/commit diff

## Refresh Steps

1. classify the task as `FULL`, `PARTIAL`, or `DOC-ONLY`
2. re-read current live code in the authoritative order above
3. compare current code and previous baseline with `git diff`
4. if blocked/unknown gap routes are in scope, update the repo's `.ai/uiux-sot/refresh/PRECONDITIONS.md` (when maintained per repo) before any refresh retry
5. refresh artifact set:
   - screenshots PNG
   - hierarchy XML
   - route inventory
   - screen state matrix
   - manifest diff summary
6. only promote a route/state to `captured` when the authoritative proof bundle is complete
7. replace `.ai/uiux-sot/latest/` in place with the new baseline
8. if runtime capture is unavailable, or proof bundle is incomplete, keep the route as `blocked` / `unknown` and update preconditions docs instead
9. verify with at least one real command
10. report in `[EVIDENCE] -> [DIFF] -> [LOG]` order

## Gap Route Preconditions

When unresolved gap routes remain, each route must record:

- route host
- current known entry CTA / source action
- runtime state gate
- data precondition
- why the current refresh could not close it
- classification: `RESOLVABLE_IN_REPO` / `REQUIRES_RUNTIME_STATE` / `REQUIRES_EXTERNAL_PREP` / `BLOCKED_NO_ENTRY` / `UNKNOWN`
- next best proof method
- proof success criteria

Canonical location (when maintained per repo): `.ai/uiux-sot/refresh/PRECONDITIONS.md`

## Authoritative Proof Rule

A route/state becomes authoritative current baseline proof only when all of the following exist together:

- screenshot PNG under `latest/screenshots/`
- hierarchy XML under `latest/hierarchy/`
- `screen_state_matrix.csv` row
- `route_inventory.md` or latest-doc note with concrete route/state explanation

Special case:

- screenshot-only transient proof is not promotable for any route that renders content not visually self-evident. XML and route/matrix notes are mandatory in those cases.

## Comparison Rules

- compare current live code against previous `latest/` before overwriting it
- use `git diff -- .ai/uiux-sot/latest/` for baseline-only changes
- use `git diff <old-commit>..<new-commit> -- <live-ui-paths>` for source-to-baseline explanation
- do not create `snapshots/`, `archive/`, or date-stamped baseline folders inside the package

## State Classification

| State | Meaning | Action |
|---|---|---|
| `RESOLVABLE_IN_REPO` | repo를 더 읽으면 refresh scope를 확정할 수 있음 | reading order 확장 |
| `UNKNOWN` | repo가 현재 사실을 증명하지 못함 | 추정 금지, 문서에 남김 |
| `BLOCKED` | 권한, 도구, 환경 부족으로 refresh 불가 | 필요한 조건과 함께 중단 |
| `STOP` | auth, billing, money, DB migration, secret, unexpected system state | 즉시 중단 후 보고 |

## Verify Requirement

- 최소 1개 이상의 실제 명령 실행은 필수다.
- `0-command` refresh verify는 금지다.
- recommended commands live in `.ai/uiux-sot/refresh/VERIFY.md`

## STOP Conditions

- auth 영향
- billing or money 영향
- DB migration or schema 영향
- secret or PII exposure
- unexpected system state
- irreversible change pressure

## Reporting

- `[EVIDENCE]` current live inventory, trigger level, diff reasoning, lineage reference
- `[DIFF]` updated files and latest-only replacement summary
- `[LOG]` verify commands, exit code, important output
