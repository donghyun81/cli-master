# VERIFY — MASTER-CLI-CONTEXT-DIET-2-001

## Verify Commands
| 명령 | Exit Code | 결과 |
|---|---|---|
| `diff <(git show HEAD:.claude/rules/cycle-discipline.md) <(tail -n +9 .auto-memory/cycle-discipline-COLD.md)` | 0 | PASS (COLD 전문 verbatim) |
| `diff` index §B(126,143)/§F(180,193) ↔ index-COLD (11,28)/(34,47) | 0 | PASS ×2 (verbatim) |
| `diff` reporting §5(137,243)/§7(274,377) ↔ 템플릿 tail | 0 | PASS ×2 (verbatim) |
| 표본 grep 15쌍 (원문 ↔ COLD/템플릿) | 0 | **15/15 PASS** (계약 ≥10 상회) |
| `shasum -a 256` 보호 5 file ↔ manifest baseline | 0 | 5/5 일치 (8502c014/b09b8d50/2bfc81c5/4d0b5279/92a5e998 · drift 0 · manifest 갱신 불요) |
| `find .claude/rules -name '*.md' \| wc -l` | 0 | 49 (= 48 member + index 자신 · index §D #5 정합) |
| `bash scripts/propagate.sh <30 file> --targets all` | 0 | ok=150 fail=0 |
| `bash scripts/verify-sync.sh` (원문 = `logs-verify-sync.txt`) | 1 | **164 PASS / 0 DRIFT / MISS 5** — exit 1 = MISS 한정 (= `docs/ops/production-cli-access-tokens.md` master-only runbook · supabase-handling §3.1 의도적 제외 · pre-existing · 판정 = 비차단 PASS · 선례 §15 다수 동형) |
| 자식 5 commit `git show --name-only \| wc -l` | 0 | 각 30 file exact (WIP 무혼입 · 잔여 staged 0) |
| `git log -1 --format=%s/%b` 자기 검증 (content commit `cf063a8`) | 0 | expected 일치 (drift 0) |

## Verification Summary
- T1~T8 전량 landed. 정보 소실 0 = COLD/템플릿 verbatim(diff 0) + 표본 grep 15/15 로 이중 검증.
- 보호 5 무접촉 (STOP #5 미발동) · production/도메인 0 LOC · rule 의미 변경 0 (배치/로드 시점만 · T3 N/A 집계·T5 재정독 개정 = paste 계약 명시 항목).
- char 감축 실측: cycle-discipline 49,353→12,728 byte (hot 9,854 cp) · intake 정독 36,325→3,368 byte · Mode 1 합계 235,005→145,199/107,180 byte.

## UNKNOWN (검증 불가 항목)
- `/context` interactive 실측 = cli session 자체 실행 불가 → disk char 카테고리별 실측으로 갈음 (EVIDENCE 박제 · 사용자 측 `/context` 전/후 육안 대조 = 선택).

## LOG
```
[LOG] 2026-07-10 KST
CMD: bash scripts/verify-sync.sh
EXIT: 1 (MISS 5 한정 · DRIFT 0)
STDOUT: PASS: 164 파일 / DRIFT: 0 / MISS: 5 — 원문 = .ai/reports/MASTER-CLI-CONTEXT-DIET-2-001/logs-verify-sync.txt
```
