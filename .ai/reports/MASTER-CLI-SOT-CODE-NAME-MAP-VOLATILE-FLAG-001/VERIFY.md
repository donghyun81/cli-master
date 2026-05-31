# VERIFY — MASTER-CLI-SOT-CODE-NAME-MAP-VOLATILE-FLAG-001

## Verify Commands
| 명령 | Exit | 결과 |
|---|---|---|
| `grep -c 'chat A' sot-code-name-map.md` | — | 0 (× 5-repo · dead TODO 제거) |
| `grep -cE 'paywall-screen\|TicketScreen'` | — | 0 (dead row 2 제거) |
| `grep -c 'TODO (chat A 의존)'` | — | 0 (§5 집계 row 제거) |
| `grep -ciE 'volatile\|baseline 2026-05-05\|재매핑.*이관\|rule-architecture'` | — | 5 (≥1 · 배너 신설) |
| `grep -cE 'ENTRY-PROMPT-rule-architecture\|rule-architecture'` | — | 4 (≥1 · forward-pointer) |
| `grep -cE 'BreathGuidance\|Meditation\|Nutrition'` | — | 0 (= 재매핑 안 함 · 실재 화면 신규 row 미추가) |
| other stale row spot-check (BreathScreen/RoutineScreen/MealRecommendation) | — | 7 (= 기존 stale row intact · 무접촉) |
| `bash scripts/propagate.sh sot-code-name-map.md` | 0 | ok=4 fail=0 · WARN noise 0 |
| `bash scripts/verify-sync.sh` | 0 | PASS 154 / DRIFT 0 / MISS 0 |

## Verification Summary
- staleness/volatility 배너 신설 + dead "chat A 의존" TODO 2 row (GB paywall · GD TicketScreen) 제거 + §5 집계 TODO row 제거 + §6.3 clause 정정 + §8 forward-pointer.
- 다른 stale row 수기 재매핑 X · 표 카테고리 재판정 X · 실재 화면명 신규 row 미추가 (= grep 0).
- 5-repo byte-identical (git-sha1 8209fc70) · verify-sync PASS 154/0/0.
- 보호 5 file sha 변동 0 (= 본 file 보호 아님 · 무접촉) · propagate WARN noise 0.
- production code touch 0 LOC.

## UNKNOWN
- (없음)

## LOG
```
[LOG] 2026-05-31 KST
CMD: bash scripts/verify-sync.sh
EXIT: 0
STDOUT: PASS 154 / DRIFT 0 / MISS 0
```

## 알려진 scope-out (무접촉)
- §2/§3/§4 다른 stale row + 표 카테고리 + §8 기존 bullet (= rule-architecture 프로그램 이관 · 원칙 4).
- ui-spec SoT 신설/통합/폐기 결정 (= Coin 승인 의무).
