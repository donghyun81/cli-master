# VERIFY — MASTER-BILLING-DOMAIN-ACTIVATE-001

## Verify Commands
| 명령 | Exit Code | 결과 |
|---|---|---|
| `bash scripts/propagate.sh --all` | 0 | PASS (ok=336 fail=0) |
| `bash scripts/verify-sync.sh` | 0 | PASS (112/0/0) |
| `shasum -a 256 .claude/rules/sot-code-name-map.md` (master vs GT) | 0 | MATCH (`7f2f4e61c635d6f425232c4c5f0d5b7caed9a8da3036efcff6c67de9676068d2`) |

## Verification Summary
- STEP-1 drift mitigation: master sot-code-name-map.md ← GT 흡수 (daily-prescription-screen row 추가 · 1:1 직매핑 aggregate 11→12 / 21→22) — sha 일치 검증.
- STEP-2 billing-rules.md SoT 신설: 10-section (Mock-first paradigm + Edge Function 영수증 검증 + 시크릿 저장 + BillingRepository 패턴 + entitlement paradigm + RevenueCat Phase 2 + STOP trigger + 절대 금지 + 변경 정책 + cycle 이력).
- STEP-3 billing-payments-guardian agent: deferred/ → active/ mv (script 자동) + routing-and-delegation.md L55 [DEFERRED] 제거 + path active/ 갱신.
- STEP-4 deferred-domains.md: Billing UNKNOWN×4 → ACTIVE×4 + §6 이력 entry append.
- STEP-5 routing-and-delegation.md: L104 DEFERRED list 의 billing-payments-guardian 항목 제거 (script가 L55 자동 처리).
- STEP-6 propagation: 336 파일 ok / 112 파일 byte-identical (master vs 3 자식).

## UNKNOWN
- 없음.

## LOG
```
[LOG] 2026-05-10 23:41 KST
CMD: bash scripts/propagate.sh --all
EXIT: 0
STDOUT: 전체 요약: ok=336 fail=0

CMD: bash scripts/verify-sync.sh
EXIT: 0
STDOUT: PASS:112 DRIFT:0 MISS:0 — 모든 sha 일치
```
