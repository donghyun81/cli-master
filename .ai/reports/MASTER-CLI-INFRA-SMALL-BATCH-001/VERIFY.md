# VERIFY — MASTER-CLI-INFRA-SMALL-BATCH-001

## Verify Commands
| 명령 | Exit Code | 결과 |
|---|---|---|
| `bash -n` × 3 (instructions-loaded · pencil-pending-sweep · propagate.sh) | 0 | PASS 3/3 |
| `echo '{}' \| CLAUDE_PROJECT_DIR=. bash .claude/hooks/instructions-loaded-baseline-verify.sh` | 0 | 6-repo HEAD 블록 emit (PDOCS=1db90fc 포함) · 보호 drift 0 |
| `bash scripts/propagate.sh .claude/skills/run-master/SKILL.md --targets GB` (가드 self-test) | 2 | WARN "run-* recipe 제외" + "파일 미지정" exit 2 — **비변경**(cp 0) |
| `bash scripts/propagate.sh .claude/hooks/instructions-loaded-baseline-verify.sh --targets all` | 0 | ok=5 fail=0 (가드 통과 = 정상 file) |
| `bash scripts/propagate.sh scripts/pencil-pending-sweep.sh --targets FND,GB,GD,GT` | 0 | ok=4 fail=0 (PDOCS 제외 = seeding 회피) |
| `bash scripts/verify-sync.sh` | 0 | **PASS 160 / DRIFT 0 / MISS 0** |
| pencil-pending-sweep 4-child `git hash-object` 대조 | 0 | master=`6875f63e` = FND/GB/GD/GT 전수 일치 · PDOCS ABSENT(의도) |
| GT `git config --local core.hooksPath` | 0 | `scripts/githooks` = GB/GD 동형 (3-child 일치) |

## Verification Summary
- ① instructions-loaded = 6-repo byte-identical(`67d47ac6` · verify-sync 추적) · pencil-pending-sweep = 4-child byte-identical(`6875f63e` · verify-sync 미추적 수동) + PDOCS absent 의도
- ② 가드 = run-* skip+WARN(비변경 실증) · 정상 file 통과(instructions/pending propagation ok)
- ③ GT core.hooksPath = scripts/githooks(repo-local · 비커밋) · pre-push 실존+executable
- 보호 5 sha drift 0 · 기존 dirty 무접촉 + 신규 dirty 0 · production 0 LOC

## UNKNOWN
- (없음)

## LOG
```
[LOG] 2026-06-11 KST
CMD: bash scripts/verify-sync.sh
EXIT: 0
STDOUT: PASS: 160 / DRIFT: 0 / MISS: 0
```
