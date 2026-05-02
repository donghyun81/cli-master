# Refresh Verification Checklist

최소 1개 이상 실제 명령을 실행하고 exit code를 기록한다.

## Recommended Commands

| Goal | Command | Expected signal |
|---|---|---|
| package inventory | `find .ai/uiux-sot -maxdepth 4 -type f | sort` | required files exist |
| refresh docs inventory | `find .ai/uiux-sot/refresh -maxdepth 2 -type f | sort` | refresh docs set exists (PRECONDITIONS.md present when the repo maintains a gap route map) |
| policy markers | `rg -n "BASELINE_PENDING_REFRESH|CURRENT_BASELINE|latest-only|lineage|git diff" .ai/uiux-sot` | required policy strings exist |
| live route authority sanity | `. scripts/agent/repo-config.sh && rg -n "composable\(\|navigate\(" "$REPO_APP_ROUTES" "$REPO_APP_ROOT_COMPOSABLE"` | route inventory stays live-code-first |
| unresolved gap authority sanity | repo-specific gap route grep over the repo's screen / shared / manifest sources — concrete route names, state gates, and query params live in the repo's `PRECONDITIONS.md` when maintained | target routes, state gates, query params, and no-deep-link constraints are evidence-backed |
| precondition/doc sync | `rg -n "precondition\|blocked\|unknown\|authoritative proof\|XML" .ai/uiux-sot/refresh/*.md .ai/uiux-sot/semantic/*.md .ai/uiux-sot/latest/*.md` | preconditions and blocked/unknown rationale are synced across refresh/semantic/latest docs |
| task artifact completeness | `bash scripts/agent/compound-lint.sh <taskId>` | task reports complete |
| scope summary | `git diff --stat -- .ai/uiux-sot CLAUDE.md .claude docs/agent` | changed scope is visible |

## Refresh Completion Gate

- `latest/manifest.md` status is correct
- `latest/coverage_summary.md` reflects capture availability
- `latest/route_inventory.md` and `latest/screen_state_matrix.csv` were regenerated from live code
- when the repo maintains gap route preconditions, `.ai/uiux-sot/refresh/PRECONDITIONS.md` maps unresolved gap routes with host, entry, gate, data, and next-proof method
- blocked/unknown routes reference preconditions rather than generic failure wording only
- screenshot-only transient proof is not promoted; routes that render non-self-evident content need authoritative XML too
- seed audit stayed in lineage only
- output/report order is `[EVIDENCE] -> [DIFF] -> [LOG]`
