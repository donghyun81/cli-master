# VERIFY — MASTER-CLEANUP-PROPAGATION-BUNDLE-001

## Verify Commands

| 명령 | Exit Code | 결과 |
|---|---|---|
| `git -C <repo> hash-object --no-filters .claude/rules/cycle-discipline.md` (5 회) | 0 | 5-repo 모두 `5726cb44c5f4d53d` (byte-identical 5/5) |
| `git -C <repo> hash-object --no-filters docs/templates/release-checklist.template.md` (5 회) | 0 | 5-repo 모두 `bd112d5457409e7a` (byte-identical 5/5) |
| `git -C claude-cli-master hash-object <보호 5 path>` | 0 | 5 sha 모두 baseline §3 정합 (변동 X) |
| `git -C app-foundation diff --cached --name-only` (commit 전) | 0 | `.claude/rules/cycle-discipline.md` + `docs/templates/release-checklist.template.md` (2 line · scope 정합) |
| `git -C <child> diff --cached --name-only` (commit 전 · GB/GD/GT) | 0 | `docs/templates/release-checklist.template.md` (1 line · scope 정합) |
| `bash scripts/verify-sync.sh` | 0 | PASS 115 · DRIFT 1 (.claude/settings.json · app-foundation only · scope 외) · MISS 1 (.claude/hooks/baseline-snapshot.sh · app-foundation only · scope 외) |

## Verification Summary

본 cycle 측 scope file (cycle-discipline.md + release-checklist.template.md) 측 5-repo byte-identical 5/5 회복 PASS.

DRIFT 1 + MISS 1 = app-foundation 측 별 cli infra (settings.json + baseline-snapshot.sh) 영역 · 본 cycle scope 외 잔존 영역 (= 별 trail 처리 후보).

보호 5 sha 변동 X 재확인 PASS.

## commit sha (= 자식 4 commit · master audit commit 별도)

| repo | commit sha |
|---|---|
| app-foundation | `a68186d3f37aed1155e654b3e35356daeeba0d10` |
| GentlyBreath | `a98a29c17d39d6e87c03891f1c7362912d768a73` |
| GentlyDay | `999e7a795d046d58ae997463d0fdeb78fb6752bb` |
| GentlyTable | `c83536739224359c4b5b866112e2411de3700d80` |

## LOG

```
[LOG] 2026-05-12 16:30 KST
CMD: bash scripts/verify-sync.sh
EXIT: 0
STDOUT (요약): PASS 115 / DRIFT 1 / MISS 1 — 본 cycle scope file (cycle-discipline.md + release-checklist.template.md) 측 byte-identical 5/5 정합. DRIFT/MISS = app-foundation 측 별 cli infra (settings.json + baseline-snapshot.sh) 영역.

CMD: git -C $r hash-object --no-filters .claude/rules/cycle-discipline.md (5 회 · $r = 5-repo 순회)
EXIT: 0
STDOUT:
  claude-cli-master: 5726cb44c5f4d53d
  app-foundation:    5726cb44c5f4d53d
  GentlyBreath:      5726cb44c5f4d53d
  GentlyDay:         5726cb44c5f4d53d
  GentlyTable:       5726cb44c5f4d53d

CMD: git -C $r hash-object --no-filters docs/templates/release-checklist.template.md (5 회)
EXIT: 0
STDOUT:
  claude-cli-master: bd112d5457409e7a
  app-foundation:    bd112d5457409e7a
  GentlyBreath:      bd112d5457409e7a
  GentlyDay:         bd112d5457409e7a
  GentlyTable:       bd112d5457409e7a

CMD: git -C claude-cli-master hash-object <보호 5 path> (5 회)
EXIT: 0
STDOUT:
  ui-spec.schema.json     = 5b84cd9e4bc36165
  uiux-sot-refresh.md     = d3a0b57390bd0414
  design-sot-policy.md    = e580b6d7ca9a88ae
  pencil-uiux-workflow.md = 3a703b30553e0d09
  pencil-sot-policy.md    = b27fbe16edb68821
```

## UNKNOWN (검증 불가 항목)

없음.
