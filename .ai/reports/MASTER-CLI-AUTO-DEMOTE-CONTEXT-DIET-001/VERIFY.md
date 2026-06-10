# VERIFY — MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001

## Verify Commands
| 명령 | Exit Code | 결과 |
|---|---|---|
| `bash -n .claude/hooks/measure-gsm-cycle.sh` | 0 | PASS (syntax) |
| hook fixture self-test (= §15 14행 fixture · `GSM_CONTEXT_HEALTH_FORCE=1`) | 0 | PASS — `[GSM-S15-HOT] ... 14 > 10` advisory 발화 + exit 0 |
| hook 실 master self-test (= hot 6행) | 0 | PASS — 무발화 (= trigger 미만 silent-success) |
| `awk '/^## 15\./...' CLAUDE.md \| grep -cv '^\| cycle ID'` | 0 | hot row = **6** (< 10 trigger · 재이전 전 14) |
| cold verbatim 검증 (python · 이전 9 row + 자식 6 row ∈ cold exact-string) | 0 | PASS — 9+/9− symmetric · 자식 6/6 verbatim 기포함 · dupe 0 · cold 103 entry |
| 4-repo CLAUDE.md sha-256 | 0 | `b5d80303d8a05eab` ×4 identical |
| `bash scripts/verify-sync.sh` | 0 | PASS 160 / DRIFT 0 / MISS 0 |
| 보호 5 sha-256 vs `protected-file-hashes.md` | 0 | 5/5 MATCH (drift 0) |
| 구 sub-§ 참조 sweep (`grep -rnE '§2[3-9]\.[0-9]'` .claude docs CLAUDE.md) | 0 | live 참조 = §23.2(anchor-list A7) 1건 → §23 pointer 본문 "구 §23.2 흡수" 명시 · §25.2 = 보존(참조 유지) |

## 정량 before/after (codepoint · proxy ≠ token)
| 대상 | before | after | Δ |
|---|---|---|---|
| master CLAUDE.md | 32,531 | 25,514 (entry append 후) | −21.6% (§15 hot 14→6) |
| 자식 CLAUDE.md ×4 | 19,260 | 9,581 | −50.3% |
| cycle-discipline.md | 43,819 | 36,866 | −15.9% (§23~§29 후퇴 · §21/§22 보존) |
| cold file | 94 entry | 103 entry | +9 verbatim (무손실) |

## UNKNOWN
- (없음)

## LOG
```
[LOG] 2026-06-10 KST
CMD: bash scripts/verify-sync.sh
EXIT: 0
STDOUT: PASS 160 / DRIFT 0 / MISS 0 — 모든 sha 일치
```
