# VERIFY — MASTER-CLI-S15-HOT-DEMOTE-003

## Verify Commands
| 명령 | Exit | 결과 |
|---|---|---|
| `awk '/^## 15\./{f=1;next} /^## /{f=0} f && /^\| /' CLAUDE.md \| grep -cv '^\| cycle ID'` | 0 | **6** (before 13) |
| `awk '/^\| /' …COLD.md \| grep -cv '^\| cycle ID'` | 0 | **111** (before 103 · +8) |
| `python3 verify.py` (vs `git HEAD:CLAUDE.md`) | 0 | ALL STRUCTURE/SYMMETRY CHECKS PASS |
| `GSM_CONTEXT_HEALTH_FORCE=1 bash measure-gsm-cycle.sh` | 0 | `[GSM-S15-HOT]` 발화 0 (silent) |
| `bash -x …measure-gsm-cycle.sh \| grep s15_count=` | 0 | `s15_count=6` (check 실행 확인 · 6 ≤ 10) |
| `shasum -a 256` 보호 5 | 0 | drift 0 (baseline 동일) |
| `git status --porcelain` | 0 | 3 tracked + report dir만 (NEW out-of-scope 0) |

## 무손실 대칭 (8 = 8 exact-string)
- source = git `HEAD:CLAUDE.md` 측 §15 oldest-8 (immutable baseline).
- working COLD 측 8 entry exact-string match = 8/8 (`work_cold.count(row)==1` 전수) · working CLAUDE §15 잔존 0/8.
- 이전 8 IDs: P2-MECHANISM · P2-RENAME-A · PENCIL-SELFTEST-GATE-RECALIBRATE · PENCIL-TOOLSET-REMOVAL-STALE-SWEEP · 25-2-DEDUP-PRUNE-EXCLUDE-LAND · AUTO-DEMOTE-CONTEXT-DIET · DEAD-REF-SWEEP · PROTECTED-STALE-PATH-FIX (모두 `MASTER-CLI-*-001`).

## master char
- 40,464 → 27,432 codepoint (−13,032 · ~27K).

## LOG
```
[LOG] 2026-06-11 KST
CMD: python3 .ai/reports/MASTER-CLI-S15-HOT-DEMOTE-003/verify.py
EXIT: 0
STDOUT: symmetry 8=8 OK · §15 hot before=13 after=6 · ALL STRUCTURE/SYMMETRY CHECKS PASS
CMD: GSM_CONTEXT_HEALTH_FORCE=1 bash .claude/hooks/measure-gsm-cycle.sh  (trace: s15_count=6)
EXIT: 0
STDOUT: (GSM-S15-HOT 무발화 · silent)
```
