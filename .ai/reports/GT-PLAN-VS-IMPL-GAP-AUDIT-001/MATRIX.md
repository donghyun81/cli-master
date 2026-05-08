# GT-PLAN-VS-IMPL-GAP-AUDIT-001 — MATRIX

**작성일**: 2026-05-08
**Scope**: 31 카테고리 (18 공통 + GT 도메인 13) — 기획 vs 실 구현 vs runtime 정합 매트릭스

---

## 18 공통 카테고리

| # | 카테고리 | 기획 | 실 구현 | runtime | 판정 | 비고 |
|---|---|---|---|---|---|---|
| C1 | CRUD (생성/조회) | 11 테이블 RLS | Repository 9 + DAO + Edge Function | 14 screenshot | ✓ | refresh + observe Flow |
| C2 | CRUD (수정/삭제) | UPDATE RLS | upsert/upsertAll + delete X | — | 🟡 | 삭제 영역 영역 미구현 (deleted_at soft delete 영역 미구현) |
| C3 | 날짜 영역 | YYYY-MM-DD + condition_date + week_start_date | LocalDate + YearMonth + ISO String | history calendar grid | ✓ | History 영역 ✓ |
| C4 | 통계 영역 | 주간 평균 / 분포 / 따름률 | WeeklyReportSummary 영역 | reports light + dark | 🟡 | toNutritionUi hardcoded ratio (#26) |
| C5 | AI 영역 | Claude API + Edge Function 5 종 | EdgeFunctionDataSource 5 함수 | meal_recommendation light + dark | 🟡 | MealRecommendation Edge Function 미연결 (#11) + monthly generate X (#24) |
| C6 | 알림 영역 | 아침 7시 + 주간 리포트 | 3 토글 + state만 | — | 🟡 | AlarmManager/WorkManager 미구현 (#6+#18) |
| C7 | 광고 영역 | AdMob Rewarded · 1회/일 | RewardedAdManager + creditAdReward | settings 영역 watch_ad button | 🟡 | creditAdReward Edge Function 미연동 (#39) |
| C8 | 권한 영역 | 알림 권한 + SAF | onboarding step4 + SAF JSON backup | onboarding_step4 light | ✓ | SAF JSON backup 영역 ✓ |
| C9 | 접근성 영역 | 48dp + 16sp + WCAG AA + TalkBack | 48dp 모든 영역 + StringRes + semantics | — | ✓ | ux-laws C-2 Fitts 정합 |
| C10 | 흐름 영역 | 5 탭 BottomNav | MainTab 5 (Home/History/Meal/Report/Settings) | F11 home BottomNav | ✓ | Mental Model + Serial Position 정합 |
| C11 | i18n 영역 | strings.xml 한국어 | 일부 hardcoded | — | 🟡 | Report + MealDetail/Reaction + SettingsScreen line 191 영역 (#17+#23+#30+#35) |
| C12 | 오류 영역 | typed Result + sealed | DomainError 7 sealed | — | ✓ | code-principles §3 정합 |
| C13 | 오프라인 영역 | Room + SyncQueue + 7일 캐시 | Entity + DAO + SyncWorker + synced field | — | ✓ | sync paradigm 영역 (creditAdReward synced=false) |
| C14 | 결제 영역 | Play Billing + INAPP consumable | BillingManager + BillingViewModel + cycle 1 graceful | settings F12 + ticket_shop N/A | 🟡 | TicketShop 결제 영역 user-prep pending (#12) |
| C15 | 면책 영역 | AI Disclaimer 3 종 | strings.xml 5 영역 + AiDisclaimerInline + AiDisclaimerDetailCard | meal_recommendation banner | ✓ | ai-food-data-legal 정합 ★ |
| C16 | 인증 영역 | Supabase Auth (익명 부트스트랩) | AuthRepositoryImpl + AnonymousAuthBootstrap | — | ✓ | auth-rules.md §1+§4 정합 ★ |
| C17 | 백업 영역 | JSON formatVersion + SAF | AndroidBackupRepository + JsonAdapters + JsonBackupSerializer | — | ✓ | auth-rules.md §5 정합 |
| C18 | 테마 영역 | Light + Dark + System | ThemeMode 3 + GentlyTableTheme | 14 screenshot 영역 light + dark | ✓ | DataStore Flow 영역 ✓ |

---

## GT 도메인 13 카테고리

### D1 — 일일 컨디션 체크인 (1회/일 · 30초 안)

| 영역 | 기획 | 실 구현 | 정합 |
|---|---|---|---|
| 5 질문 영역 | 컨디션 + 몸 상태 + 목표 + **식사 상황** + 추가 증상 | fatigue + mood + body + symptom + goal | **FAIL** ★ (#5+#8 식사 상황 X) |
| 30초 UX | 5 step 30초 안 | TOTAL_QUESTIONS = 5 + condition_progress_badge "⏱ 약 30초" | ✓ |
| 1회/일 영역 | DUPLICATE_CONDITION_TODAY 영역 | DomainError 영역 | 🟡 (Edge Function 영역 검증 의무) |

### D2 — 상황별 기본 추천 (구내식당/편의점/배달 광고 1회 무료)

| 영역 | 기획 | 실 구현 | 정합 |
|---|---|---|---|
| 한식 카테고리 | 구내식당 + 편의점 + 배달 (3 영역) | strings `한식 추천` + Onboarding `Delivery` 만 | **FAIL** ★ (#1 영역) |
| 식사 환경 paradigm | 5 영역 (NOT NULL) | 4 layer 충돌 (5/4/3/0) | **FAIL** ★ (#1+#5+#8+#15+#37) |
| 광고 1회 영역 | RewardedAd 1/일 | RewardedAdManager + onReward | 🟡 (creditAdReward Edge Function 미연동 #39) |

### D3 — 완전 상황별 추천 (3 식단 + 대안 · 1 한입)

| 영역 | 기획 | 실 구현 | 정합 |
|---|---|---|---|
| 3 식단 영역 | 아침 + 점심 + 저녁 | MealRecommendationScreen MealList | ✓ runtime PASS (B-1 Choice Overload) |
| 대체 메뉴 영역 | 2~3개 alternative | AlternativesRow LazyRow | ✓ |
| 1 한입 영역 | ticketRepo.consume("full_recommendation") | UseCases 영역 ✓ | ✓ |
| AI 호출 영역 | Edge Function generate-recommendations | RecommendationRepositoryImpl | 🟡 (mealEnvironment 영역 X #15+#37 ★★) |
| 영양 정보 영역 | calories + protein + carbs + fat (DECIMAL NOT NULL) | calories만 / protein+carbs+fat = null | **FAIL** ★ (#38) |

### D4 — 조건별 운동 제안 (1 한입)

| 영역 | 기획 | 실 구현 | 정합 |
|---|---|---|---|
| 운동 paradigm | 카테고리 4 → 루틴 → 상세 (영상/텍스트) | 강도 chip 3 + 추천 카드 + Timer | **FAIL** ★ (#28+#32) |
| 1 한입 영역 | ticketRepo.consume 영역 | EdgeFunctionDataSource REQUEST_EXERCISE_SUGGESTION | 🟡 (호출 영역 검증 의무) |
| 칼로리 표시 | "엄격 칼로리 추적 X" (billing.md) | 분당 6 kcal placeholder | **FAIL** ★ (#29 P0) |

### D5 — 주간 영양 트렌드 리포트 (3 한입)

| 영역 | 기획 | 실 구현 | 정합 |
|---|---|---|---|
| 5 영역 paradigm | title + tabs + nutritionCard + trendCard + insight | ReportContent 5 Composable | ✓ (cycle 11a 정합 ✓) |
| 무료 영역 | nutritionCard + trendCard | 두 영역 표시 | ✓ |
| 유료 영역 | insight = -3 한입 | InsightCard cost chip 영역 X | **FAIL** ★ (#31) |
| AI 호출 영역 | generate-weekly-report | GenerateWeeklyReportUseCase + ticketRepo.consume("weekly_report") | ✓ |

### D6 — 월간 건강 인사이트 (5 한입)

| 영역 | 기획 | 실 구현 | 정합 |
|---|---|---|---|
| 월간 generate | refreshMonthly + generate 함수 | refreshMonthly 만 (generate X) | **FAIL** ★ (#24+#25+#40) |
| 5 한입 영역 | ticketRepo.consume("monthly_insight") | REQUEST_MONTHLY_INSIGHT 정의만 + 호출 X | **FAIL** (#40 dead constant) |

### D7 — 식품 영양 disclaimer (FTC 정합)

| 영역 | 기획 (ai-food-data-legal §7.1) | 실 구현 | 정합 |
|---|---|---|---|
| inline disclaimer | "AI가 생성한 영양 정보이며..." | strings.xml `ai_disclaimer_inline` | ✓ |
| body disclaimer | "본 앱의 식품 영양정보는 AI..." 의료 자문 X | `ai_disclaimer_body` 정합 | ✓ |
| food DB accuracy | 식품 DB AI 보정 | `ai_disclaimer_food_db_accuracy` | ✓ |
| AiDisclaimerDetailCard | 면책 detail | components 영역 ✓ (Onboarding + Home + Meal + Exercise + History + AIDetail 통합) | ✓ |

### D8 — AI 영양 정보 badge

| 영역 | 기획 | 실 구현 | 정합 |
|---|---|---|---|
| ⚠️ AI badge | "⚠️ AI가 생성한 영양 정보입니다" | `meal_ai_badge_label` + AiBadgeYellow Composable | ✓ runtime PASS (F10) |

### D9 — 7 일 history (limit + 만료)

| 영역 | 기획 (4.2 + 4.6) | 실 구현 | 정합 |
|---|---|---|---|
| history list paradigm | 일자별 그룹 + 주간/월간 필터 | 캘린더 그리드 + 도트 범례 | 🟡 (#27 paradigm 외부) |
| 7 일 영역 | "최근 7일 히스토리" (무료) | adherence 4 level + DetailSection | ✓ (영역 paradigm 차이만) |
| 진단 아닌 관찰 | 톤 명시 | `history_subtitle` 정합 | ✓ |

### D10 — 한입 티켓 충전 + 광고 보상

| 영역 | 기획 (billing.md) | 실 구현 | 정합 |
|---|---|---|---|
| 4 패키지 | 5/15/30/50 (₩1,100~8,500) | TicketShopViewModel defaultPackages | ✓ wording |
| 결제 흐름 | BillingClient + consumeAsync | BillingManager + consume + verify-purchase | 🟡 (TicketShop checkout user-prep #12) |
| 광고 보상 | 1회/일 | RewardedAdManager + onReward | 🟡 (Edge Function 미연동 #39) |
| 잔액 영역 | observeBalance Flow | Settings observeBalance ✓ / TicketShop STUB_BALANCE=3 ★ | 🟡 (#13+#20 paradigm 충돌) |

### D11 — settings + 결제 영역 (chat A + cycle 1 정합 ✓)

| 영역 | 기획 | 실 구현 | 정합 |
|---|---|---|---|
| 7 section | 계정 + 알림 + 개인정보 + 앱정보 | Profile + Diet NavCard + Exercise NavCard + Notification + AI NavCard + Theme + 한입 NavCard + DataInfo | ✓ runtime PASS (A-4 Chunking) |
| 한입 NavCard 영역 | TicketShop entry | Settings NavCard 영역 (cycle 1 553c40b) | ✓ runtime cycle 1 후 |
| Billing graceful | "결제 서비스 연결 실패" + 보유 0 | BillingViewModel cycle 1 graceful (553c40b) | ✓ runtime PASS (Hidden Costs + Forced Continuity) |

### D12 — "기록하지 마, 물어봐" 빠른 UX (loose recommendations 차별화 영역)

| 영역 | 기획 (billing.md line 9-15) | 실 구현 | 정합 |
|---|---|---|---|
| 슬로건 wording | "기록하지 마, 물어봐" | splash_tagline + settings_tagline | ✓ |
| 30초 UX 표시 | "⏱ 약 30초" | home_condition_eyebrow + condition_progress_badge | ✓ |
| 빠른 추천 | "빠른 추천" | home_quick_action | ✓ |
| 한식 추천 영역 | 구내식당 + 편의점 + 배달 paradigm | 식사 환경 paradigm 미연동 ★ | **FAIL** (#15+#37 ★★) |
| loose 영역 = 엄격 칼로리 X | "제거할 기능: 엄격한 칼로리 추적" | DietDetail Slider 1200~3000 + Exercise 분당 6 kcal | **FAIL** (#21+#29 P0 ★★) |

### D13 — 제거 영역 (상세 식품 DB / 엄격 칼로리 추적)

| 영역 | 기획 | 실 구현 | 정합 |
|---|---|---|---|
| 상세 식품 DB 탐색 | "제거할 기능" 명시 | FoodDbRepository + observeAll + search 영역 (DAO 영역) | 🟡 (food_db Room 영역 잔존 — 영역 사용 영역 검증 의무) |
| 엄격 칼로리 추적 | "제거할 기능" 명시 | DietDetail Slider + Exercise kcal | **FAIL** (#21+#29 P0) |

---

## 통계 (영역 정합)

| 분류 | C1~C18 (18) | D1~D13 (13) | 합 (31) |
|---|---|---|---|
| ✓ PASS | 11 | 4 | 15 |
| 🟡 PARTIAL | 7 | 4 | 11 |
| **FAIL** ★ | 0 | **5** | **5** |

**FAIL 5 영역** (D 도메인 영역 만 · 차별화 영역 위반):
- D1 (식사 상황 X)
- D2 (식사 환경 paradigm 미연동)
- D3 영양 정보 + AI 호출 영역 mealEnvironment X
- D4 운동 paradigm + 칼로리 placeholder
- D6 monthly generate X
- D12 차별화 영역 본심 위반 ★★
- (D5 insight cost chip + D11 chat A/cycle 1 정합 영역 = 일부 PARTIAL)

---

## runtime 영역 (matrix-results.csv GT 26 row)

| theme | 화면 수 | PASS | FAIL | N/A | 비고 |
|---|---|---|---|---|---|
| light | 11 | 13 | 1 | 1 | settings F12 FAIL = cycle 1 마감 영역 (553c40b 후 PASS) |
| dark | 6 | 5 | 0 | 0 | 모두 PASS (Cognitive Load + Common Region + Choice Overload + ...) |

**runtime 누락 6 영역**: condition_input + exercise + meal_detail + meal_reaction + ai_detail + diet_detail — 별 cycle (emulator 재 audit 영역).

---

**Sources**:
- [EVIDENCE.md](./EVIDENCE.md)
- [ISSUES.md](./ISSUES.md)
- [.ai/reports/MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001/matrix-results.csv](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.ai/reports/MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001/matrix-results.csv)
