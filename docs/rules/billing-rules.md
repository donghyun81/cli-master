# Billing Rules — 명시 조합(explicit composition) paradigm + Edge Function 영수증 검증 paradigm

> **단일 목적**: 자식 repo (GT/GD/GB) 의 결제 / 구독 / IAP / entitlement / SKU / refund / Google Play Billing / RevenueCat 정책 SoT.
> **MASTER-BILLING-DOMAIN-ACTIVATE-001 신설** (GT CLAUDE.md §6 명시된 Mock-first 패러다임 + Edge Function 영수증 검증 의무 코드화).
> ⚠ **위 신설 유래 줄의 "Mock-first" = 2026-05-10 신설 시점 서술 (= 이력 · 삭제 X)**. **현행 paradigm = §1 명시 조합** — 구 Mock-first / NoOp 기본 bind 서술은 §1.1 supersede 절에 verbatim 보존되며 **현재형 규정 아님** (`MASTER-CLI-COMPOSITION-RULES-S3-001` · 2026-07-26).
> **연관 파일**:
> - `deferred-domains.md` §1 STOP trigger + §2 도메인 활성화 매트릭스 (Billing = ACTIVE)
> - `safety-and-secrets.md` 시크릿 / PII 처리 + EncryptedSharedPreferences 정책
> - `routing-and-delegation.md` `billing-payments-guardian` agent 매핑 (active)
> - `workflow-core.md` §implement Testability Seams (`EntitlementRepository` 인터페이스 주입)
> - `cycle-discipline.md` §15 패턴 3 (도메인 활성화 절차)
> SOT: `CLAUDE.md`

---

## §1 명시 조합 paradigm (default · FND-BILLING-SEAMS-S1-001 + SELFWARD-COMPOSITION-ROOT-S2-001 마감)

**라이브러리는 계약과 구현을 제공할 뿐, 기본 선택을 하지 않는다.** 결제 / 광고 seam 의 실체 선택은
소비하는 앱의 **조합 루트**가 한 곳에서 전부 말한다.

- **기본값 금지**: foundation 측 seam 묶음(`BillingSeams`) = **기본값 0** — 앱이 하나라도 빠뜨리면
  **컴파일되지 않는다.** aggregate 진입점(`foundationCoreModules(billing: BillingSeams)`)도 **기본 인자 0**.
- **조합 루트 단일 자리**: 앱은 조합 루트(= 수동 DI 컨테이너 · Android 공식 AppContainer 형태 ·
  **`object` 싱글턴 아님** · 앱이 수명을 소유)에서 seam 실체를 **이름을 불러** 주입한다.
- **등록 순서 의존 금지**: "뒤에 등록한 쪽이 이긴다"(module 후행 override)로 실체를 바꾸지 않는다 —
  등록을 **빠뜨려도 아무것도 깨지지 않으므로** 누구도 알아채지 못한다.
- **Mock 은 이름을 불러야만 들어온다** + **debug guard 의무**: production 빌드 mock 결과 노출 금지
  (= **불변** · build flavor 분리 · `BuildConfig.DEBUG` guard · §7 · §8 정합). **통짜 mock 조합 금지** —
  4 seam 을 한 번에 Mock 으로 만들면 entitlement 까지 Mock 으로 되돌아간다(= 되찾은 실물의 반납).
  **per-seam 선택 의무.**
- **NoOp = 삭제 아님 · 강등**: 의도한 미배선은 앱이 **명시적으로 고르는 선택지**로 남는다
  (조용한 기본값이 아니라 이름을 불러 고른 결과).
- **★도구로는 잡히지 않는다**: Koin verify / Compiler Plugin 의 계약은
  *"structural dependency presence, **not semantic correctness**"* — 존재하지만 **의미가 틀린**
  바인딩(NoOp)은 언제나 정상 해석된다. **기본값을 없애는 것이 유일한 구조적 방어다.**

### §1.1 supersede (구 서술 폐기 · **삭제 아님** · additive-ledger 보존)

- **(구 · MASTER-BILLING-DOMAIN-ACTIVATE-001 · 2026-05-10 · GT CLAUDE.md §6 계승)**
  *"§1 Mock-first paradigm (default · Phase 4 진입 전) — 결제 도메인 첫 도입 시 = Mock implementation
  우선(`EntitlementRepository` 인터페이스 + `MockEntitlementRepository` impl) · 실 Google Play Billing
  연동 = Phase 4 별 cycle 의무 · Mock 단계에서 UI / UX / entitlement 잔액 paradigm 검증."*
- **(구 · FND-BILLING-SEAM-001 · 2026-06-05)**
  *"billingModule = production-safe NoOp 기본 bind · billingMockModule = debug opt-in 분리 ·
  자식 측 single override 로 실 구현 교체."*
- **→ 판정: F1 의 구조적 원인.** 앱이 한 줄도 쓰지 않은 자리를 foundation 이 조용히 NoOp 으로 채웠고,
  자식이 override 를 빠뜨려도 **컴파일·기동이 전부 성공**했다 (= production `EntitlementRepository` 가
  **잔액 0 하드코딩 NoOp** 으로 남은 사고).
- **→ 대체**: `FND-BILLING-SEAMS-S1-001` (app-foundation `b1ff997`) +
  `SELFWARD-COMPOSITION-ROOT-S2-001` (Selfward `317f4e8`).
  `billingMockModule` = **폐기**(실 심볼 0 · 2026-07-26 실측) — 공유 인스턴스 배선 지식은
  **이름을 불러 쓰는** `mockBillingSeams()` factory 로 이관(삭제 아님).
- **불변 항목**: mock 결과 production 노출 금지(§7·§8) · 잔액 = 서버 단일 진실(§5) · EF 단일 진입점(§2).

### §1.2 착지 좌표 (실측 · 2026-07-26)

| 좌표 | 실체 |
|---|---|
| `core/billing/…/BillingSeams.kt:39` | `class BillingSeams(billing, entitlement, rewardedAd, adCredit)` — **기본값 0** |
| `core/billing/…/di/BillingModule.kt:36` | `fun billingModule(seams: BillingSeams): Module` |
| `core/di/…/FoundationKoin.kt:62` | `fun foundationCoreModules(billing: BillingSeams)` — **기본 인자 0** |
| 자식 조합 루트 (실례 = Selfward `SelfwardAppContainer.kt:61`) | `class …AppContainer(…)` — **`object` 아님** |
| per-seam 선택 (실례 = 동 `:144` + 선행 KDoc 표) | `fun selfwardBillingSeams(invoker, entitlementCache, isDebug): BillingSeams` |

per-seam 선택 실례 (Selfward `SelfwardAppContainer.kt:144` KDoc · 자식별 상이 가능):

| seam | production | debug/staging | 근거 |
|---|---|---|---|
| entitlement | `SupabaseEntitlementRepository` | **동일(실물)** | 잔액 = 서버 단일 진실(§5) · staging 도 실 잔액 |
| adCredit | `CheckQuotaAdCreditRepository` | 동일(실물) | 동일 check-quota EF 1-call |
| billing | `NoOpBillingRepository` | `MockBillingRepository` | 실 Play BillingClient 미배선 · 에뮬 미동작 |
| rewardedAd | `NoOpRewardedAdRepository` | `MockRewardedAdRepository` | 실 AdMob 미배선 |

> ★**본 생성자에 기본값을 추가하는 순간 F1 이 부활한다** — 금지. 도구는 잡지 못한다(위 §1 마지막 bullet).

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

## §5a 지불 정산 paradigm (`settle-after-success` default · 2026-07-26 Coin 확정 · MASTER-CLI-RULES-SETTLE-001)

### §5a.1 지불은 **결과에 대해서만** (B-1 · default)

- **`settle-after-success` = 기본값**: 잔액 차감(= 정산)은 **사용자가 받을 결과가 성립한 뒤**에 일어난다. 시도에 대해 과금하지 않는다.
- **`deduct-first` = 예외로만** — 채택 시 **사유 기재 의무**(PLAN + REVIEW 양쪽). 사유 없는 선차감 = REVIEW §1 FAIL.
- 실측 근거: **같은 3 시도**에서 구 판 = **3 차감 / 결과 1**, 신 판 = **1 차감 / 결과 1**. 원장이 직접 실증했다 (= 관측 가능하게 만든 뒤 바꾼 순서 · `verification-and-review.md` §성공 경로 관측 가능성 정합).

### §5a.2 모호하면 **차감하지 않는다** (B-2)

- 결과 성립 여부가 **판정 불가**(= 응답 유실 · timeout · 미지 상태)면 **차감 보류**가 기본이다.
- **비대칭 손실**: 과금 실패(under-charge) **<** 이중 과금(over-charge). 전자는 수익 누수 1회, 후자는 **신뢰 손상 + 환불 + 분쟁**이다. 회복 비용이 싼 쪽으로 기울인다.
- 보류 건은 **계측**한다(예: `skipped_ambiguous`) — 조용히 버리면 **비대칭의 대가**를 측정할 수 없다.

### §5a.3 degrade = **내용 규칙 위반 경로 한정** (B-3)

- 응답 품질 강등(degrade)은 **내용 규칙을 위반한 응답**에만 적용한다(예: `MEASURE_LEAK` = 존치).
- **parse 실패 · 절단은 degrade 대상이 아니다 — 재시도가 정답이다.** (형식 사고를 내용 위반으로 처리하면 정상 응답까지 강등된다 · `supabase-handling.md` §11.2 절단 감지 정합).

### §5a.4 ★금전 변동 RPC 는 **멱등 fence** 를 갖는다 (B-4 · 신설)

- **금전(잔액·크레딧·티켓)을 변동시키는 서버 RPC 는 멱등 fence 를 갖는다** — 재실행이 **2번 반영되지 않도록** 하는 키(멱등 키 · PK dedup · UNIQUE 제약).
- **fence 가 없으면 그 사실을 rule 에 적고, 호출측이 재시도하지 않는다.** 없는 것을 있는 것처럼 다루는 호출측 재시도가 이중 과금을 만든다.
- 실측 근거 — **같은 파일 안의 비대칭**: `grant_ad_credit` = `ad_credit_grants` **PK dedup** ✓ · `credit_purchase` = `external_id` **UNIQUE** ✓ · **`consume_ticket` 만 부재** ✗. **적립 2 경로는 멱등이고 차감만 예외**였다.
- ★**B-4 가 드러낸 것 — 알 수 없는 것을 단언한 주석**: 구 `ConsumeFailed` 주석 *"차감 0 → 재시도 안전"* 은 **증명 불가한 것을 단언**했다. 서버 커밋 후 응답이 유실되면 **차감은 됐고** 재-consume 은 **이중 과금**이다. 정정 후 이 방향은 **과다 청구 → 과소 청구**로 뒤집혔다(= §5a.2 비대칭 정합).
- **미도입 상태의 멱등 키** = `skipped_ambiguous` **계측치와 함께** 재판정한다 (현재 실측 **0건** · 계측 없는 재판정 금지).

---

## §6 RevenueCat / 다른 IAP provider Phase 2 (별 trail · lazy)

- RevenueCat / Stripe / 다른 IAP provider = Phase 2 별 cycle 의무 (lazy · 자연 trigger 시)
- 본 §1 명시 조합 + §2 Edge Function paradigm 마감 후 도입 검토
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

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md) (= 6-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).

---

## §10 명시된 cycle 이력

- 2026-05-10 · MASTER-BILLING-DOMAIN-ACTIVATE-001 · 본 rule 신설 + billing-payments-guardian [DEFERRED]→ACTIVE
- 2026-07-26 · MASTER-CLI-RULES-SETTLE-001 · **§5a 지불 정산 paradigm 신설** — §5a.1 `settle-after-success` default (= B-1 · Coin 확정 · `deduct-first` = 예외 + 사유 기재 의무 · 근거 = 같은 3 시도에서 구 판 **3 차감/결과 1** → 신 판 **1 차감/결과 1** 원장 실증) + §5a.2 모호하면 차감 X (= B-2 · under-charge < over-charge 비대칭 · `skipped_ambiguous` 계측 의무) + §5a.3 degrade = 내용 규칙 위반 한정 (= B-3 · `MEASURE_LEAK` 존치 · **parse 실패 = 재시도가 정답**) + §5a.4 **금전 변동 RPC 멱등 fence** (= B-4 신설 · 근거 = 같은 파일 안 비대칭 실측: `grant_ad_credit` PK dedup ✓ · `credit_purchase` `external_id` UNIQUE ✓ · **`consume_ticket` 만 부재** ✗ · 구 `ConsumeFailed` 주석 *"차감 0 → 재시도 안전"* = 알 수 없는 것을 단언 → 과다→과소 청구로 정정). §1·§1.1·§1.2·§2·§3·§4·§5·§7·§8 **무접촉**. 4-repo byte-identical propagation.
- 2026-07-26 · MASTER-CLI-COMPOSITION-RULES-S3-001 (초안 원천 = SELFWARD-SSOT-COMPOSITION-S4-001 §5) · §1 Mock-first → **명시 조합 paradigm 재저작** + 제목 정정 + 신설 유래 줄(`:4`) supersede 표식 + §1.1 supersede 절 신설(구 서술 2종 verbatim 무삭제 보존) + §1.2 착지 좌표 표 + §6 후속 서술 정합. 근거 = `FND-BILLING-SEAMS-S1-001`(app-foundation `b1ff997`) + `SELFWARD-COMPOSITION-ROOT-S2-001`(Selfward `317f4e8`) 착지 실측. §2·§3·§4·§5·§7·§8 무접촉(전부 유효). 4-repo byte-identical propagation.
