# Billing Rules — Mock-first paradigm + Edge Function 영수증 검증 paradigm

> **단일 목적**: 자식 repo (GT/GD/GB) 의 결제 / 구독 / IAP / entitlement / SKU / refund / Google Play Billing / RevenueCat 정책 SoT.
> **MASTER-BILLING-DOMAIN-ACTIVATE-001 신설** (GT CLAUDE.md §6 명시된 Mock-first 패러다임 + Edge Function 영수증 검증 의무 코드화).
> **연관 파일**:
> - `deferred-domains.md` §1 STOP trigger + §2 도메인 활성화 매트릭스 (Billing = ACTIVE)
> - `safety-and-secrets.md` 시크릿 / PII 처리 + EncryptedSharedPreferences 정책
> - `routing-and-delegation.md` `billing-payments-guardian` agent 매핑 (active)
> - `workflow-core.md` §implement Testability Seams (`EntitlementRepository` 인터페이스 주입)
> - `cycle-discipline.md` §15 패턴 3 (도메인 활성화 절차)
> SOT: `CLAUDE.md`

---

## §1 Mock-first paradigm (default · Phase 4 진입 전)

- 결제 도메인 첫 도입 시 = Mock implementation 우선 (`EntitlementRepository` 인터페이스 + `MockEntitlementRepository` impl)
- 실 Google Play Billing 연동 = Phase 4 별 cycle 의무 (lazy · 자연 trigger 의 사용자 요청 시)
- Mock 단계에서 UI / UX / entitlement 잔액 paradigm 검증 (Edge Function 미준비 시점에도 화면 진입 가능)
- production 빌드에 mock 결과 노출 금지 (build flavor 분리 · `BuildConfig.DEBUG` guard)

---

## §2 영수증 검증 변동성 경계 (Edge Function 단일 진입점)

- 클라이언트 직접 Google Play Developer API 호출 금지 (인증 + RLS 우회 위험)
- 영수증 검증 = Supabase Edge Function (`verify-purchase`) 단일 진입점 의무
- 클라이언트는 `purchaseToken` + `productId` 만 Edge Function 에 전달
- Edge Function 측 Google Play Developer API 호출 + 검증 + DB upsert 완전 처리
- 검증 결과 실패 = `BillingError.ReceiptInvalid` 반환 (entitlement 부여 X)

---

## §3 시크릿 저장 의무

- Google Service Account JSON = Supabase Vault 저장 의무 (`safety-and-secrets.md` 정합)
- Edge Function 환경변수 주입 (값은 코드 / 파일에 기록 X)
- 클라이언트 측 Google Play API key 저장 금지 (Edge Function 단일 진입점이므로 클라이언트 미보유)
- entitlement 잔액 캐시 = `EncryptedSharedPreferences` 사용 의무 (plaintext SharedPreferences 금지)

---

## §4 BillingRepository 패턴

- `interface BillingRepository { suspend fun launchBilling(productId: String): BillingResult; suspend fun consumePurchase(purchaseToken: String): Result<Unit, BillingError> }` 의무
- `interface EntitlementRepository { fun currentBalance(): Flow<Int>; suspend fun refresh(): Result<Int, BillingError> }` 의무
- domain 계층에서 Google Play Billing SDK 직접 호출 금지 (`workflow-core.md` §implement 정합)
- impl 만 `BillingClient` (Google Play Billing Library 6.x) 단일 진입점

---

## §5 entitlement / 잔액 paradigm (소비형 인앱 상품)

- 자식별 ticket 상품 = Google Play 소비형 인앱 상품 (consumable in-app product · 실 구현 예: GB `rest_tickets` 잔액 충전)
- `consumePurchase` 호출 의무 (consumable 미consume 시 재구매 불가)
- entitlement 잔액 = Supabase DB 단일 진실 (RLS 의무 · 클라이언트 조작 불가)
- 클라이언트 측 잔액 = 캐시 (UI 표시 용도) · 결제 / 사용 시점 = 서버 검증 의무
- offline 잔액 차감 금지 (낙관적 업데이트 X · 네트워크 끊김 시 STOP)

---

## §6 RevenueCat / 다른 IAP provider Phase 2 (별 trail · lazy)

- RevenueCat / Stripe / 다른 IAP provider = Phase 2 별 cycle 의무 (lazy · 자연 trigger 시)
- 본 §1 Mock-first + §2 Edge Function paradigm 마감 후 도입 검토
- iOS / cross-platform 확장 시점 진입 (현 시점 Android Google Play Billing 단일)
- 신규 provider 도입 = `BillingRepository` 인터페이스 재사용 + impl 추가 (도메인 계층 변경 X)

---

## §7 STOP trigger (즉시 STOP + 본 rule reading 의무)

- 결제 / 구독 / IAP / entitlement / SKU / refund / Google Play Billing / RevenueCat 키워드 감지
- 클라이언트 측 직접 Google Play Developer API 호출 시도
- mock 결과 production 빌드 노출 (build flavor 분리 위반)
- 시크릿 (Service Account JSON / API key) 하드코딩 시도
- entitlement 잔액 클라이언트 측 직접 조작 시도 (RLS 우회)
- offline 잔액 차감 / 낙관적 업데이트 시도

---

## §8 절대 금지

- 시크릿 하드코딩 (`safety-and-secrets.md` 정합)
- mock 결제 결과 production 노출
- 클라이언트 직접 Google Play Developer API 호출 (Edge Function 단일 진입점 우회)
- entitlement 잔액 plaintext SharedPreferences 저장
- HTTP (HTTPS only)
- consumable 상품 미 `consumePurchase` 처리 (재구매 불가 사고)
- Supabase RLS 정책 우회 (entitlement 테이블 클라이언트 직접 INSERT/UPDATE)

---

## §9 본 rule 의 변경 정책

- master 측 단방향 propagation 영역 (cli infra 권장 byte-identical · 보호 파일 5종 외)
- 변경 시 master cycle 신설 + 6-repo propagation 의무
- 자식 repo 직접 수정 금지

---

## §10 명시된 cycle 이력

- 2026-05-10 · MASTER-BILLING-DOMAIN-ACTIVATE-001 · 본 rule 신설 + billing-payments-guardian [DEFERRED]→ACTIVE
