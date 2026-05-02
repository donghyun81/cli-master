# Billing — `<RepoName>`

> **template 출처**: master `docs/templates/billing.template.md`.
> **활성 조건**: Billing 도메인 활성 cycle 진입 (`deferred-domains.md` §1 §5 trigger).
> **STOP 의무**: Billing 변경은 항상 즉시 STOP + Coin direct (`cycle-discipline.md` §5).

## 1. 결제 provider

- platform: `<예: Google Play Billing v6 / Apple StoreKit / RevenueCat>`
- SKU 종류: `<one-time / subscription / consumable>`

## 2. SKU + entitlement 매핑

| SKU ID | 제품 | 가격 (KRW) | 종류 | entitlement |
|---|---|---|---|---|
| `premium_monthly` | 프리미엄 1개월 | 4,900 | subscription | `premium` |

## 3. entitlement 검증 흐름

1. 사용자 결제 → Google Play 검증 (server-side · 의무)
2. Edge Function 이 entitlement 박음 (DB)
3. 앱이 entitlement read → feature gate

## 4. 환불 / refund patterns

- Google Play 환불 webhook 처리
- entitlement 즉시 회수
- 사용자 알림

## 5. 보안

- 영수증 검증 server-side 의무 (client 신뢰 X)
- mock 결제 production 노출 금지
- BillingClient 호출 = `app/` layer 만 (DI 통해 주입)
