# VERIFY — MASTER-CLI-REPO-COUNT-VOCAB-SWEEP-001

## Verify Commands
| 명령 | Exit Code | 결과 |
|---|---|---|
| `shasum -a 256` 보호 5 (진입/마감 2회) | 0 | PASS — `8502c014`/`e3b9891d`/`4c566615`/`2ec100bf`/`ae20a79c` 변동 0 |
| `grep -rn -i "5-repo"` live 영역 (마감) | 0 | PASS — 잔존 62행 = 역사 46 + 실태정합 8 + 키워드 병기 4 + 모호 4 · **현재형 서술 잔존 0** |
| `python3 apply_sweep.py` (2-phase 단언 치환표) | 0 | PASS — 51 file · 179 pair + 후속 1(crpe:73) = 180 · 단언 실패 0 |
| `bash scripts/propagate.sh <44+1 file>` | 0 | ok=225 fail=0 (45×5 · 이 중 run-master 5건 = 직후 자식 git rm 회수 → 실효 44×5=220) |
| 자식 5 `git rm run-master + commit --amend -- .claude` | 0 | run-master 부재✓ ×5 · 신규 staged dirty 0 ×5 |
| `bash scripts/verify-sync.sh` | 0 | **PASS 160 / DRIFT 0 / MISS 0** · propagation-status.md 자동 갱신 |
| `grep design-sot-refresh design-to-code-sync.md` | 0 | 잔존 2 = 의미 병기(`의미 = design-sot-refresh`)만 · 파일명 오기 0 |
| `grep -rn scripts/agent/repo-config.sh` (rules/agents/skills/commands) | 1 | 0 matches = PASS |
| `shasum -a 256 ../CLAUDE.md` (부모 root) | 0 | 신 baseline `64ebf82c8981d22930fa6368ab3810f141a09a9de9cf55fcd33d87c5a41c029c` |
| 6-repo `git status --porcelain` (자식 신규 dirty) | 0 | 신규 0 — 기존 dirty(GB 2 · GD 1 · GT 1)만 잔존 (§7.1 dirty baseline 정합) |

## Verification Summary
- live 정정 157행 + scope ② 8곳 + 명칭 2곳 + enumeration 동반 4곳. 역사·실태정합·키워드·모호 = 62행 보존 (분류 = EVIDENCE.md).
- propagation 실효 44 file × 5 자식 byte-identical (run-master = repo-specific 제외 · 재seeding 자체 회수).
- production / 도메인 코드 0 LOC · script 로직 0 변경 (주석/echo/usage 문자열 한정).

## UNKNOWN
- (없음)

## LOG
```
[LOG] 2026-06-10 KST
CMD: bash scripts/verify-sync.sh
EXIT: 0
STDOUT: [verify-sync] 6-repo sha 동기 검증 · PASS: 160 파일 · DRIFT: 0 · MISS: 0 · PASS — 모든 sha 일치
```
