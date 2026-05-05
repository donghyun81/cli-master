# MULTI-REPO-BILLING-MODEL-RECONCILE-001 — PLAN

## 본심
3-repo `docs/design/billing.md` 본심 (구독 X · 소비형 INAPP · 단발 티켓 5/15/30/50) 와 실측 (GB SUBS hardcoded dead code + GT SubscriptionState 잔존 + GD SoT 부재) 정합.

## sub-cycle 진행

### sub-cycle A1 — cowork 직접 5+ 영역 baseline 실측
- ui-spec.schema.json intent enum 검증
- GT SubscriptionState 사용 영역 grep
- GD TicketScreen + TicketViewModel 본질 read
- GD/GT billing.md 본심 단위명 read
- NavHost paywall route 명 grep + 3-repo git log
- 추가: GD TicketSku enum + GB TicketShopScreen.kt 본문 + GB ticket-shop SoT 본질

### sub-cycle A2 — Coin 측 환경 검증
- claude --version 2.1.114 ✓
- Pencil 모달 부재 ✓

### sub-cycle B — GB 정리 (commit `8ee777d`)
- B.1 strings.xml line 30/32/178~191/238 정정
- B.2 TicketShopScreen.kt 제거 + MainScaffold.kt + Destinations.kt + SettingsScreen.kt:293 정정
- B.3 ticket-shop SoT 영역 (.ui-spec.json + pencil-exports/A-8) 제거
- B.4 paywall → onboarding-pledge rename (intent LOCKED 유지)
- B.5 GB commit (sub-cycle B)

### sub-cycle C — GT 정정 (commit `3b5d38f`)
- C.1 strings.xml:245 wording
- C.2 SettingsUiState.kt SubscriptionState 제거
- C.3 SettingsScreen.kt:189 binding 정정
- C.4 SettingsScreen.kt:505/522 preview 정정
- C.5 GT commit (sub-cycle C)

### sub-cycle D — GD ticketshop SoT 신설 (commit `e24e972`)
- D.1 ticketshop-screen.ui-spec.json 신설 (.pen 다음 cycle 영역 분리)
- D.2 GD commit (sub-cycle D)
- D.다음cycle: .pen + .preview.png + visualSotPath 갱신

### sub-cycle E — master cross-verify + 보고서 + audit commit
- E.1 보호 sha drift 0 + BillingManager 무변동 + billing.md 무변동 + EVIDENCE.md 보존 검증
- E.2 EVIDENCE.md + PLAN.md + REVIEW.md 작성
- E.3 .auto-memory/decision-log.md append
- E.4 master audit commit
- E.5 cowork 측 마감 보고

## 영역 분리 (cycle scope 부풀음 방지)
- 3-repo `.auto-memory/*.md` M 영역 = 별 cycle 처리 (본 cycle staged 영역 외)
- GB `Phase4_PartA_Audit_Summary.md` D 영역 = 별 cycle 처리

## STOP 조건 발화 영역 (실시 결과)
- ✗ B.4.2 .pen rename = paywall-screen.pen 부재 ✓ (회피)
- ✗ D.1 ticketshop-screen.pen 첫 저장 = Pencil Type 2 영역 → Coin 결정 (a) .ui-spec.json 만 신설 + .pen 다음 cycle (회피)
- ✗ STEP 0.3 EVIDENCE.md sha drift = turn 3 발화 → baseline update mitigation (해소)

## Coin 결정 누적
turn 1: A 옵션 (cowork A1 + Coin A2 병렬) · GB TicketShopScreen 제거 · paywall LOCKED 유지 · ticket-shop SoT 제거 · wording default
turn 3: A 옵션 (baseline update) · feedback memory 갱신
turn 4: A 옵션 (.ui-spec.json 신설 + .pen 다음 cycle)
