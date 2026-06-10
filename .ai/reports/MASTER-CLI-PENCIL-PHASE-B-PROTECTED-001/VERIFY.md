# VERIFY — MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001

## Verify Commands
| 명령 | Exit Code | 결과 |
|---|---|---|
| `claude --version` + `claude mcp list` + ToolSearch "+pencil" | 0 | PASS (2.1.170 · pencil Connected · 9종 전수 + 제거 4종 부재) |
| `shasum -a 256` 보호 2 (정정 후) | 0 | `b09b8d50…` / `2bfc81c5…` — manifest·snapshot 양층 일치 |
| `git hash-object` 보호 5 (정정 후) | 0 | pencil 2 = `aba157e0…`/`ce9c0d3e…` (§14a 동기) · 나머지 3 = §14a baseline 그대로 (변동 0) |
| `grep -cE "open_document"` 정정 3 file | 0 | workflow 4 · sot-policy 2 · cycle-discipline 2 = 전수 제거-라벨/게이트 정합 서술만 (실호출 0) |
| `bash scripts/propagate.sh <3 file> --targets all` | 0 | ok=15 fail=0 (cp+sha cross-verify) |
| `bash scripts/verify-sync.sh` | 0 | **PASS 160 / DRIFT 0 / MISS 0** |
| baseline-snapshot 재생성 후 latest.json 대조 | 0 | 6-repo 전수 `b09b8d50`/`2bfc81c5` + PDOCS block 포함 + 6 HEAD 신 commit 반영 |

## Verification Summary
- 보호 2 신 sha == manifest sha-256 == baseline-snapshot sha-256 == §14a git-sha1 (algorithm 라벨 분리) — 3-layer coherence PASS
- 6-repo byte-identical: master `57af6de` → FND `1c3ce90` / GB `9170dd8` / GD `68cbe3e` / GT `41683b0` / PDOCS `b963ac8` (각 3 file · path-limited commit)
- 기존 dirty 무접촉 + 신규 dirty 0 (아래 LOG) · production/도메인 0 LOC

## UNKNOWN
- (없음)

## LOG
```
[LOG] 2026-06-10 KST
CMD: bash scripts/verify-sync.sh
EXIT: 0
STDOUT: PASS: 160 파일 / DRIFT: 0 / MISS: 0 — propagation-status.md 갱신
```
