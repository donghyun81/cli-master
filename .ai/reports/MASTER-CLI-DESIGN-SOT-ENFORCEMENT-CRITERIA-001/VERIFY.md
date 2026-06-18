# VERIFY — MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001

## Verify Commands
| 명령 | Exit | 결과 |
|---|---|---|
| `bash scripts/propagate.sh <6 file> --targets all` | 0 | ok=30 fail=0 (6 file × 5 자식) |
| `bash scripts/verify-sync.sh` | (FAIL by docs/ops MISS) | **160 PASS / 0 DRIFT** / 5 MISS(무관) |
| `shasum -a 256` 보호 5 × 6-repo matrix | 0 | byte-identical 전수 |
| `git hash-object` 보호 2 (§14a) | 0 | uiux 0aeac86d · dsp 0d265e0b |

## sha 변동 표 (master · sha-256 16-char)
| file | 분류 | pre | post |
|---|---|---|---|
| `uiux-sot-refresh.md` | 보호#2 | `e3b9891d4be59219` | `4d0b52798cb47f06` |
| `design-sot-policy.md` | 보호#3 | `4c5666152f09009b` | `92a5e99804ff712f` |
| `design-to-code-sync.md` | cli-infra | `746cb9a2501408b2` | `dfb2b1472f76d80d` |
| `verification-and-review.md` | cli-infra | `ce6c4b9e11fa108c` | `f1faead5dd254a43` |
| `rule-routing-index.md` | cli-infra | `ad226ad69ab8c710` | `b8f2ed1963c4c451` |
| `reporting.md` | cli-infra | `22a75fc5054158a4` | `9fd34ebcb167e476` |

## 보호 manifest resync 전/후 (2층)
| layer | uiux-sot-refresh | design-sot-policy |
|---|---|---|
| manifest sha-256 | `e3b9891d…` → `4d0b5279…` | `4c566615…` → `92a5e998…` |
| §14a git-sha1 | `d2c62265…` → `0aeac86d…` | `69649a36…` → `0d265e0b…` |
| 보호 3 unchanged | ui-spec `8502c014` · pencil-uiux `b09b8d50` · pencil-sot `2bfc81c5` (변동 0) | |

## Verification Summary
- propagate ok=30/0 · verify-sync DRIFT 0 (byte-identical 확정) · 보호 5 6-repo 일치.
- MISS 5 = pre-existing `docs/ops/production-cli-access-tokens.md` (미추적 · 본 cycle 무관 · 분류 보고 · 자율 해소 X).
- production / ui-spec.schema.json / pencil 보호 2종 = 0 LOC touch.

## LOG
```
[LOG] 2026-06-18 KST
CMD: bash scripts/propagate.sh .claude/rules/uiux-sot-refresh.md docs/design/design-sot-policy.md .claude/rules/design-to-code-sync.md .claude/rules/verification-and-review.md .claude/rules/rule-routing-index.md .claude/rules/reporting.md --targets all
EXIT: 0
STDOUT: 전체 요약: ok=30 fail=0

CMD: bash scripts/verify-sync.sh
STDOUT: PASS 160 / DRIFT 0 / MISS 5 (docs/ops pre-existing)
```
