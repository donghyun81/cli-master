# PLAN — MULTI-REPO-EDGEFN-VAULT-KEY-RENAME-001

> Risk: **Low** → Lightweight 3-section (cycle-discipline §11 + workflow-core Risk-based 경량화).

## GATESv2
| Field | Value |
|---|---|
| TaskId | MULTI-REPO-EDGEFN-VAULT-KEY-RENAME-001 |
| Mode | refactor (rename) — 3-repo propagation |
| Workflow | Collect → Plan → Implement (3 child) → Verify → Review |
| Requirements Source | Coin 직접 prompt (A/B/C 위임) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 3 (GB:1 / GD:2 / GT:1) — sibling 3 commit 합산 |
| Modules | supabase/functions (GB/GD) + docs/setup/03_edge_functions (GT) |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `grep -rn "ANTHROPIC_API_KEY" {GB,GD,GT}` (= 0 expect) + `grep -rn "CLAUDE_API_KEY" {GB,GD,GT}` (= 8 expect) + `shasum -a 256` 보호 6 file (= baseline 그대로) |

## Plan

1. **GB child cycle** — `supabase/functions/claude-proxy/index.ts` 안 2 hit rename + child task file + INDEX + decision-log + commit (cycle-discipline §6 v2 + §7).
2. **GD child cycle** — `supabase/functions/ai_insights/claude_client.ts` 2 hit + README.md 4 occurrences rename + child task file + INDEX + decision-log + commit.
3. **GT child cycle** — `docs/setup/03_edge_functions/README.md` 4 hit rename (claude_client.ts 는 GT-PHASE-2-001 사전 정합) + child task file + INDEX + decision-log + commit.
4. **Master parent cycle** — 4-file reports (EVIDENCE / PLAN / VERIFY / REVIEW) + master commit (3 sibling commit 인용).

## Notes
- 보호 6 file 변동 X 의무 (감지 시 STOP).
- Vault registration / Edge Function deploy / `supabase secrets set` 실행 = out-of-scope (Coin direct).
- 3 child commit subject = `refactor(<scope>): <task-id> <summary>` 표준 (cycle-discipline §6).
