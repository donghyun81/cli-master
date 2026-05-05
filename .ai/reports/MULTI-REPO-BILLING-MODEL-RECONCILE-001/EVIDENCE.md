# MULTI-REPO-BILLING-MODEL-RECONCILE-001 — EVIDENCE

## Cycle 정보
- Cycle ID: MULTI-REPO-BILLING-MODEL-RECONCILE-001
- 일자: 2026-05-05
- scope: 다중 repo (GB + GT + GD) 결제 모델 본심 정합
- 본심: 3-repo `docs/design/billing.md` (구독 X · INAPP + consumeAsync · 단발 5/15/30/50)

## Pre-cycle baseline (2026-05-05 진입 시점)
- 보호 5 + cli infra 5 = 10 file × 4-repo byte-identical OK ✓ (drift 0)
- 부모 audit cycle (MULTI-REPO-UIUX-AUDIT-AGAINST-UX-LAWS-001) Phase 1 마감
  - EVIDENCE.md sha = `76e43e6819c77597fd255313e47df869a437a69a4e98a67e50c246c53c393103` (269 line)
  - 별 cycle BORDERLINE-CONTEXTUAL-REVIEW-001 의 6 line append 정합 (turn 3 STEP 0.3 baseline update mitigation)
- BillingManager / BillingClientManager pre-cycle sha:
  - GB: `650dad64d68bbc211548a4977e93b472ff3eb01ba88073b63ae14bc0046c07bb`
  - GD: `edf671aed44bd581a95518a9189a120fdf66547784c98c432e18a265339be964`
  - GT: `3e35ac6a17025fb111fb2d014daf531f3f1fe613b7d309593c61b5c39ae799a7`
- 3-repo billing.md pre-cycle sha:
  - GB: `13326583fd28ca53f12643db66181b3958f8ef5ee76ea1bc37f3e9c2cb5d1f7c` (1223 line)
  - GD: `7218de3297f873dcb946f41f3be2746ed99ef42e3e61ec17b13be3c38e698bd3` (969 line)
  - GT: `7b1c693e5672bb9d219bf7ece59552bbe9ebdc93da39486beca8850a017b7308` (473 line)

## Coin 결정 영역 (총 7 건)
1. sub-cycle 진입 = A. cowork sub-cycle A1 직접 + Coin sub-cycle A2 병렬
2. GB TicketShopScreen.kt 처리 = deprecated + 제거
3. GB paywall intent enum = LOCKED 유지 + screenName/pencilFrameCode rename + description 갱신
4. GB ticket-shop SoT 영역 = 모두 deprecated/제거
5. wording 정정 = default 적용 (billing.md 본심 직접 매핑)
6. EVIDENCE.md sha drift 처리 = A. baseline update + sub-cycle B 진입
7. cowork 측 baseline 추출 사고 mitigation = 기존 feedback_prompt_authoring_baseline_verification.md 갱신
8. sub-cycle D 진행 = (a) .ui-spec.json 신설 + .pen 다음 cycle

## baseline 정정 사고 3 건 (cowork sub-cycle A1 + turn 3)
1. **GB TicketShopScreen.kt = SUBS hardcoded dead code** — 사용자 prompt §3 영역 1 단순 정정 가정 X · 본질 정리 영역 (SUBS 패턴 hardcoded 212 line + TODO user-prep 미완성 + ticket_shop_* stringResource 사용 0 회). cowork 측 turn 1 baseline 추출 시 file 본문 read 누락.
2. **paywall intent ONBOARDING_PLEDGE = schema enum 미허용** — `["CURRENT","TARGET","LOCKED"]` 만. cowork 측 turn 2 prompt 안 enum 정정 가정 X · LOCKED 유지 결정.
3. **EVIDENCE.md sha drift** (turn 3 CLI 측 STOP) — cowork 측 turn 1 baseline 추출 시 사용자 prompt 의 `20838bb7...` sha 그대로 신뢰 + memory `multi_repo_uiux_audit_phase1.md` 안 명시된 갱신 sha (`20838bb7→76e43e68`) cross-verify 누락. 별 cycle BORDERLINE-CONTEXTUAL-REVIEW-001 의 append-only 정상 마감 영역.

## 변경 영역 종합 (3-repo + master)

### GB (commit `8ee777d`)
- 16 file changed / +19 / -503
- 제거 영역:
  - `app/src/main/java/com/example/gentlybreath/presentation/ticket/TicketShopScreen.kt` (212 line · SUBS dead code)
  - `docs/design/pencil-sot/ticket-shop-screen.ui-spec.json` (171 line · SUBS 패턴 SoT)
  - `docs/design/pencil-exports/A-8_ticket_shop/` (5 file · 디렉터리 + 4 png + meta.json)
- rename 영역:
  - `paywall-screen.ui-spec.json` → `onboarding-pledge-screen.ui-spec.json` (intent LOCKED 유지)
  - `pencil-exports/A-1_05_paywall/` → `A-1_05_onboarding_pledge/` (디렉터리 + 2 png + meta.json frame/variants 본문)
- 정정 영역:
  - `strings.xml` line 30/32/238 wording + line 178~191 ticket_shop_* 13 line 제거
  - `MainScaffold.kt` import + composable 영역 제거
  - `Destinations.kt:19` const 제거
  - `SettingsScreen.kt:293` TODO 주석 wording
  - `pencil-exports/README.md` 4 영역 정합 (line 31~34/72~76/94/102)

### GT (commit `3b5d38f`)
- 3 file changed / +4 / -10
- 정정 영역:
  - `strings.xml:245` settings_section_subscription '구독' → '한입 티켓'
  - `SettingsUiState.kt:13` subscription field 제거 + line 56~59 `SubscriptionState` data class 제거
  - `SettingsScreen.kt:189` subtitle binding `state.subscription.planLabel` → `'보유: ${state.ticketCount}한입'`
  - `SettingsScreen.kt:505 + 522` preview 'Gentle Pro' 제거 → ticketCount = 25 / 50

### GD (commit `e24e972`)
- 1 file changed / +106
- 신설 영역:
  - `docs/design/pencil-sot/ticketshop-screen.ui-spec.json` (schemaVersion 0.3 · intent CURRENT · pencilFrameCode null · 3 states · 5 a11y · 3 wcag samples · 1 frame node · lifecycle active)
- 다음 cycle 영역:
  - `ticketshop-screen.pen` frame 신설 (Pencil GUI Save As Type 2 의무)
  - `ticketshop-screen.preview.{light,dark}.png` 신설
  - `visualSotPath` + `lastSyncedPencilStateHash` 갱신

## Post-cycle 검증 (E.1 cross-verify)
- 보호 5 + cli infra 5 = 10 file × 4-repo drift 0 ✓ (sha 무변동)
- BillingManager / BillingClientManager 본질 무변동 ✓ (pre/post sha 동일):
  - GB: `650dad64...` (변동 X)
  - GD: `edf671ae...` (변동 X)
  - GT: `3e35ac6a...` (변동 X)
- 3-repo billing.md 무변동 ✓ (pre/post sha 동일)
- EVIDENCE.md (Phase 1) sha 보존 ✓ (`76e43e68...` · 269 line)
- 잔존 grep 0 ✓:
  - GB: `TicketShopScreen / TICKET_SHOP / ticket_shop_ / paywall / 구독` 코드 영역 = 0
  - GT: `SubscriptionState / Gentle Pro / state.subscription / 구독` 코드 영역 = 0

## 영향
- FTC + EU DMA 위험 제거 (3-repo 모두 구독 시사 wording 제거)
- TicketPurchaseScreen (GB) / TicketScreen (GD) / 한입 ticketshop (GT) = 본심 정합 file 단독 유지
- onboarding flow 정합 (GB paywall → onboarding-pledge rename)
- code-first SoT registration (GD ticketshop SoT 신설 · 다음 cycle Pencil 정밀 정합 영역)

## 다음 cycle 후보
- **GB**: TicketPurchaseScreen 의 SoT (`ticket-purchase-screen.ui-spec.json`) 신설
- **GD**: `ticketshop-screen.pen` frame 신설 + `.preview.{light,dark}.png` 신설 (Pencil Type 2 = Coin GUI Save As 1회 의무)
- **GB**: `pencil-exports/README.md` A-9 다음 영역 번호 정합 검토 (A-8 제거 후 정합)
- 3-repo `.auto-memory/decision-log.md` + `.auto-memory/incident-log.md` 별 cycle 처리 (본 cycle 외 staged 영역)
