# VERIFY — MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001

## Verify Commands

| 명령 | Exit Code | 결과 |
|---|---|---|
| `bash .claude/hooks/baseline-snapshot.sh` (= hook self-test · master cwd) | 0 | PASS · baseline JSON 6 file 안 5-repo entry 정합 ✓ + Proto* entry 부재 ✓ |
| `git hash-object <repo>/.claude/hooks/baseline-snapshot.sh` × 5-repo | 0 | PASS · 5-repo byte-identical sha `18fb59c80f64e520c84b0720cfb133276b54752e` |
| `bash scripts/propagate.sh .claude/hooks/baseline-snapshot.sh --targets FND,GB,GD,GT` | 0 | PASS · ok=4 fail=0 · 4 자식 byte-identical cp 마감 |
| `bash scripts/verify-sync.sh` | 1 | PARTIAL · 본 cycle file PASS ✓ · pre-existing scope 외 DRIFT 2 (= gradlew + gradlew.bat · app-foundation 측) + MISS 4 (= 1 doc 4 자식 부재 · 본 cycle 무관) |
| `bash scripts/report-gen.sh MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001` | 0 | PASS · propagation-reports/MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001/{REPORT,DIFF,VERIFY}.md 3 file 자동 생성 |

## Verification Summary

본 cycle scope 측 baseline-snapshot.sh 5-repo byte-identical paradigm 정합 = **PASS**. 5-repo 모두 sha `18fb59c80f64e520c84b0720cfb133276b54752e` 단일 정합 ✓.

hook self-test PASS:
- exit 0 (= 비차단 영역 default 정합)
- baseline JSON 본문 안 `claude-cli-master` + `app-foundation` + `GentlyBreath` + `GentlyDay` + `GentlyTable` 5 entry 정합 ✓
- `ProtoGently*` 3 entry 부재 ✓

verify-sync.sh 본 cycle 측 file = PASS (= baseline-snapshot.sh 측 master sha = 4 자식 sha 일치). 본 결과 측 exit 1 = pre-existing scope 외 영역 default:
- gradlew + gradlew.bat = app-foundation 측 sha ≠ master (= 본 cycle 무관 · 별 cycle 후보 default)
- 1 doc miss (= `docs/baseline/cowork-project-instructions-§20-redline-20260517.md` 측 4 자식 모두 MISS · 본 cycle 무관)

## UNKNOWN (검증 불가 항목)

없음 (= 모든 verify 명령 실측 마감).

## LOG

```
[LOG] 2026-05-19 23:04 KST
CMD: bash .claude/hooks/baseline-snapshot.sh (master cwd · self-test)
EXIT: 0
STDOUT: (baseline JSON disk write · stderr 0 byte default)

[LOG] 2026-05-19 23:05 KST
CMD: git hash-object <repo>/.claude/hooks/baseline-snapshot.sh × 5-repo (master commit 후 propagation 마감 시점)
EXIT: 0
STDOUT:
  18fb59c80f64e520c84b0720cfb133276b54752e  claude-cli-master/.claude/hooks/baseline-snapshot.sh
  18fb59c80f64e520c84b0720cfb133276b54752e  app-foundation/.claude/hooks/baseline-snapshot.sh
  18fb59c80f64e520c84b0720cfb133276b54752e  GentlyBreath/.claude/hooks/baseline-snapshot.sh
  18fb59c80f64e520c84b0720cfb133276b54752e  GentlyDay/.claude/hooks/baseline-snapshot.sh
  18fb59c80f64e520c84b0720cfb133276b54752e  GentlyTable/.claude/hooks/baseline-snapshot.sh

[LOG] 2026-05-19 23:06 KST
CMD: bash scripts/propagate.sh .claude/hooks/baseline-snapshot.sh --targets FND,GB,GD,GT
EXIT: 0
STDOUT: 전체 요약: ok=4 fail=0 · 4 자식 모두 byte-identical cp 마감

[LOG] 2026-05-19 23:06 KST
CMD: bash scripts/verify-sync.sh
EXIT: 1 (= partial · pre-existing scope 외 drift)
STDOUT: 요약 PASS:130 DRIFT:2 MISS:4 · 본 cycle file baseline-snapshot.sh = 5-repo byte-identical PASS

[LOG] 2026-05-19 23:07 KST
CMD: bash scripts/report-gen.sh MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001 --commit-msg "..."
EXIT: 0
STDOUT: 보고서 3 file 자동 생성 마감 (REPORT.md + DIFF.md + VERIFY.md)
```
