# VERIFY — MASTER-CLI-CONTEXT-DIET-2-003

## Verify Commands
| 명령 | Exit | 결과 |
|---|---|---|
| `git mv` × 44 → docs/rules/ | 0 | PASS (잔존 5 · docs/rules 44) |
| broken-link 스캔 (python · 49 rule file) | 0 | move-induced **0** |
| hot residual `.claude/rules/<moved>` 스캔 | 0 | **0** (history 제외) |
| `bash scripts/test-protected-file-hooks.sh` | 0 | #3/#4/#5 PASS · #1/#2 pre-existing (stdout↔exit-capture) |
| instructions-loaded-baseline-verify.sh (real master) | 0 | 보호 5 sha 발견 · drift **0** |
| `GSM_STALE_SELFTEST=1 measure-gsm .claude/rules` | 0 | stale 0 (잔존5) |
| `bash scripts/propagate.sh --all --targets all` | 0 | ok=830 fail=0 |
| 자식 surgical `git rm` 44 × 5 | 0 | .claude/rules=5 · docs/rules=44 (6-repo) |
| `bash scripts/verify-sync.sh --skip-daemon-check` | 0 | **164 PASS / 0 DRIFT / MISS 5** |

## Verification Summary
- 정보 소실 0 (이동=내용무변경 · sweep=경로문자열만 · rule 의미 변경 0).
- 보호: 2 moved rebaseline (path+sha256+git1 정합 · manifest↔live 일치) · 3 unmoved 무접촉.
- 6-repo byte-identical (docs/rules 44 + .claude/rules 5) · MISS 5 = docs/ops master-only (accepted · restored).
- production/EF/DB/Money 0 LOC.

## UNKNOWN
- **프로브 B 미반영** = 세션 시작 1회 로드(same-session subagent = pre-move snapshot). 실 token 감축 = **신 세션 확증 필요** (in-session 측정 불가 · 기전 가설 무해).

## LOG
```
[LOG] 2026-07-11 KST
CMD: bash scripts/verify-sync.sh --skip-daemon-check
EXIT: 0
STDOUT: PASS 164 · DRIFT 0 · MISS 5 (docs/ops/production-cli-access-tokens.md master-only)
CMD: bash scripts/propagate.sh --all --targets all
EXIT: 0
STDOUT: ok=830 fail=0
```
