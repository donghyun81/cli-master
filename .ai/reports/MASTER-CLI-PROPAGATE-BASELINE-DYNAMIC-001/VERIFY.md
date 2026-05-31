# VERIFY — MASTER-CLI-PROPAGATE-BASELINE-DYNAMIC-001

## Verify Commands
| 명령 | Exit | 결과 |
|---|---|---|
| `bash -n scripts/propagate.sh` | 0 | PASS (syntax) |
| `grep -cE 'bba7745e\|af8e7e26\|1f97ac1f\|487d57a2' scripts/propagate.sh` | — | 0 (stale 4 sha 제거) |
| `grep -c 'design-sot-policy' scripts/propagate.sh` | — | 2 (≥1 · 5번째 보호 file ACTUAL 포함) |
| `grep -c 'protected-file-hashes' scripts/propagate.sh` | — | 3 (≥1 · manifest 동적 reference 도입) |
| `grep -c '보호 파일 4종 / 5종'` | — | 4종=0 · 5종=1 |
| block sim `set -euo pipefail` | 0 | NO WARN (EQUAL) · set-e survived |
| `bash scripts/propagate.sh scripts/propagate.sh` | 0 | ok=4 fail=0 · **WARN noise 0** (`보호 파일 baseline 변경 감지` 발화 0) |
| `bash scripts/verify-sync.sh` | 0 | PASS 154 / DRIFT 0 / MISS 0 |

## Verification Summary
- stale-hardcode heredoc(4 sha) 폐기 → manifest 5-row sha-256 동적 parse 전환.
- ACTUAL loop 4→5 file (design-sot-policy.md 추가) · explicit 5-file list (verify-sync.sh PROTECTED 정합).
- WARN noise 0 실증 (propagate run 측 baseline WARN 미발화) · WARN-only non-blocking 거동 보존 (기능 무변동).
- propagate.sh 5-repo byte-identical (git-sha1 `9aad6ab9` · verify-sync PASS 154/0/0).
- 보호 5 file sha-256 변동 0 (master pre=post · 5-repo git-sha1 byte-identical).
- production code touch 0 LOC.

## UNKNOWN
- (없음)

## LOG
```
[LOG] 2026-05-31 KST
CMD: bash scripts/propagate.sh scripts/propagate.sh
EXIT: 0
STDOUT: ok=4 fail=0 · '보호 파일 baseline 변경 감지' 발화 = 0 (WARN noise 제거 실증)
CMD: bash scripts/verify-sync.sh
EXIT: 0
STDOUT: PASS 154 / DRIFT 0 / MISS 0
```

## 알려진 scope-out (무접촉)
- `.ai/baseline-snapshot/latest.json` 측 pencil sha `f1825013...` stale 잔존 = Cycle 5 D-area 후보 (umbrella §2.50 명시 · 본 cycle scope-out).
- verify-sync git-lock daemon 미활성 WARN = 환경 noise (본 cycle 무관).
