# VERIFY — MASTER-CLI-CONTEXT-DIET-2-002

## Verify Commands

| 검증 | 명령 | 결과 | Exit |
|---|---|---|---|
| baseline (live re-measure) | `git rev-parse HEAD` + `git status --porcelain` | master `f4e66ba`(001 마감) · dirty 0 | 0 |
| 6-repo HEAD baseline | `git -C <r> rev-parse --short HEAD` ×6 | FND `8300b1e`/GB `81e7d8f`/GD `6d6341d`/GT `68dab90`/PDOCS `e2493f1` (001 propagation-status 일치) | 0 |
| 보호 5 git-sha1 drift | `git hash-object` ×5 (pre+post) | drift 0 (8b46bb49/aba157e0/ce9c0d3e/0aeac86d/0d265e0b 무변동) | 0 |
| 자식4 content-parity | `diff GB/CLAUDE.md <r>/CLAUDE.md` ×3 | FULL IDENTICAL ✓ (post-T1/T2) | 0 |
| T5 hook self-test | `GSM_CONTEXT_HEALTH_FORCE=1 bash measure-gsm-cycle.sh` | surface OK(신 ctx_실측 line 렌더) · append 미실행(advisory) | 0 |
| T5 printf 12-col | `printf ... \| awk NF` | 12 columns · header/separator 12-col 일치 | 0 |
| propagate (2 file) | `bash scripts/propagate.sh <f> --targets all` ×2 | ok=5/0 각 · 신규 gitignore patch 0 | 0 |
| post-propagate byte-id | `shasum -a 256` unique-count ×2 | unique sha = 1 각 (byte-identical) | 0 |
| 자식 commit name-only | `git show --name-only HEAD` ×5 | edit-set exact (WIP 무혼입) | 0 |
| verify-sync | `bash scripts/verify-sync.sh` | **164 PASS / 0 DRIFT / MISS 5**(pre-existing master-only runbook) | (MISS-only 비차단) |
| secret grep | (edit-set = doc/rule/hook · secret 무) | 0 match | 0 |

## T6 MCP 실측 (record · STOP 무관)

- MCP tool defs = **deferred** (SessionStart 시스템 reminder: "schemas are NOT loaded" · ToolSearch on-demand).
- base context ~**242,708 tok** (= subagent spawn "Prompt too long" error 실측 · 200K 초과 → subagent blocked) — MCP full schema 미포함(deferred).
- `.mcp.json` disk = 929 byte (config only · 3 supabase server + pencil).
- **판정**: MCP 실점유 ≈ 0 → `.mcp.json` 무접촉 (T6 deferred 분기 · 실로드 ≥10K STOP 분기 아님).

## LOG
```
[LOG] 2026-07-10 KST
CMD: bash scripts/verify-sync.sh
RESULT: PASS 164 / DRIFT 0 / MISS 5 (docs/ops/production-cli-access-tokens.md master-only · pre-existing)
CMD: GSM_CONTEXT_HEALTH_FORCE=1 bash .claude/hooks/measure-gsm-cycle.sh
EXIT: 0  (advisory surface · ctx_실측 line OK · append 미실행)
```
