# GT-PLAN-VS-IMPL-GAP-AUDIT-001 — ISSUES (우선순위 분류)

**작성일**: 2026-05-08
**부적합 영역 누적**: 40건
**P0 즉시 정정**: 3건 ★★ (본 cycle 영역)
**P1~P5 영역**: 별 cycle 분리 또는 deferred

---

## P0 — 차별화 영역 본심 위반 (즉시 정정 의무) ★★

### #15+#37 — AI 처방 영역 식사 환경 paradigm 미연동 ★★

**비판**: billing.md line 9-15 명시 차별화 영역 (구내식당+편의점+배달 한식 추천) Domain ↔ Repository ↔ Edge Function 모든 영역 `mealEnvironment` 영역 미연동.

**근거**:
- `Repositories.kt` line 49-57 (`generateDaily` 시그니처 mealEnvironment X)
- `RecommendationRepositoryImpl.kt` line 73-79 (Edge Function 호출 영역 X)
- `UseCases.kt` line 46-53 (UseCase 영역 X)
- `ConditionInputViewModel.kt` line 86 (`mealEnvironment = null` hardcoded)

**정정 영역** (client 영역만 · 5 file):
1. `Repositories.kt` — `generateDaily` 시그니처 `mealEnvironment: String? = null` 추가
2. `RecommendationRepositoryImpl.kt` — `GenerateRecommendationsRequest` 호출 영역 mealEnvironment 추가
3. `EdgeDtos.kt` (`GenerateRecommendationsRequest` DTO) — `mealEnvironment: String? = null` field 추가
4. `UseCases.kt` (`GenerateDailyRecommendationUseCase`) — `profile?.mealEnvironments?.firstOrNull()` default 매핑
5. `ConditionInputViewModel.kt` — onSubmit 영역 (UI 영역 변경 X · onboarding 영역 mealEnvironments[0] default)

**별 cycle 의뢰 영역 (Edge Function 측 server)**:
- Supabase `generate-recommendations` 함수 영역 mealEnvironment input 영역 받기 + Claude 프롬프트 영역 mealEnvironment 전달 영역 추가 — TODO(user-prep) 영역 추가

### #21 — 엄격 칼로리 추적 영역 잔존 ★

**비판**: billing.md line 14 명시 "제거할 기능: 엄격한 칼로리 추적" 영역 위반.

**근거**:
- `DietDetailScreen.kt` line 98-119 (`CalorieCard` Slider 1200~3000)
- `DietConfigState.calorieGoal: Int` field
- `SettingsViewModel.updateCalorieGoal()`
- strings.xml `settings_diet_calorie_*` 3 string

**정정 영역** (3 file + strings):
1. `DietDetailScreen.kt` line 98-119 (`CalorieCard` 함수) — 제거
2. `DietDetailScreen.kt` line 73-76 (`CalorieCard` 호출 영역) — 제거
3. `SettingsViewModel.kt` line 122-126 (`updateCalorieGoal`) — 제거
4. `SettingsUiState.kt` (`DietConfigState.calorieGoal`) — field 제거
5. `SettingsScreen.kt` (`DietDetailScreen` 호출 인자 `onCalorie = viewModel::updateCalorieGoal`) — 제거
6. strings.xml `settings_diet_calorie_title` + `settings_diet_calorie_value_format` 2 string 제거

### #29 — Exercise 분당 6 kcal placeholder 잔존 ★

**비판**: "엄격 칼로리 추적 X" 영역 정합 X (#21 영역 확대).

**근거**:
- `ExerciseViewModel.kt` line 113 (`(actualSeconds / 60) * 6` hardcoded)
- `ExerciseTimerState.Complete.estimatedKcal: Int` field
- `ExerciseScreen.TimerCompleteBody` kcal Text 표시
- strings.xml `exercise_timer_kcal_format`

**정정 영역** (3 file + strings · Timer 자체는 #28 영역 별 cycle):
1. `ExerciseViewModel.kt` line 105-115 (`onComplete()` kcal 계산 영역) — 제거 + Complete state 영역 estimatedKcal 영역 제거
2. `ExerciseUiState.kt` (`ExerciseTimerState.Complete` data class) — `estimatedKcal: Int` field 제거
3. `ExerciseScreen.kt` (`TimerCompleteBody` kcal Text 영역) — 제거
4. strings.xml `exercise_timer_kcal_format` 1 string 제거

---

## P1 — paradigm 충돌 (정정 의무 · 별 cycle)

| # | 영역 | 정정 영역 (별 cycle) |
|---|---|---|
| **#1** | 식사 환경 enum 4 layer paradigm 충돌 | OnboardingScreen + Settings + ConditionInput 영역 enum 통일 (5 영역 paradigm 채택 또는 3 영역 수렴) — Coin 결정 의뢰 |
| **#5+#8** | ConditionInput 5 질문 영역 = 식사 상황 X (mealEnvironment hardcoded null) | ConditionInput UI 영역 식사 상황 question 추가 또는 onboarding default 사용 (P0-1 영역 정합 후 검토) |
| **#27** | HistoryScreen 영역 = 캘린더 paradigm vs 기획 list paradigm | Coin 결정 의뢰 (캘린더 paradigm 채택 시 기획 갱신 / 기획 채택 시 화면 재구현) |
| **#32** | Exercise paradigm 영역 충돌 (카테고리/루틴/상세 vs 추천+Timer) | 큰 cycle (운동 가이드 영역 대규모 재설계) |
| **#38** | 영양 정보 (protein/carbs/fat) 영역 미저장 (Entity null) | Edge Function 응답 영역 영양 영역 매핑 + Entity upsert 영역 영양 영역 저장 (RecommendationRepositoryImpl line 96/109/122) |

---

## P2 — Gold-Plating · YAGNI 위반 (별 cycle)

| # | 영역 | 정정 |
|---|---|---|
| **#19** | AiStyle 3 (CONSERVATIVE/BALANCED/DIVERSE) — 기획 외 추가 | 기획 갱신 (paradigm 추가) 또는 영역 제거 — Coin 결정 의뢰 |
| **#28** | Exercise Timer 영역 — 기획 외 추가 | 기획 갱신 또는 Timer 영역 제거 — Coin 결정 의뢰 (P0-3 후 검토) |
| **#40** | `REQUEST_MONTHLY_INSIGHT` dead constant | 영역 제거 또는 ReportViewModel monthly generate 영역 호출 추가 (P3 #24 영역 정합) |

---

## P3 — 미구현 영역 (TODO user-prep · 별 cycle)

| # | 영역 | 비고 |
|---|---|---|
| **#6+#18** | AlarmManager/WorkManager 알림 영역 미구현 | 3 토글 모두 state만 갱신 |
| **#11** | MealRecommendationViewModel Edge Function 미연결 + stub hardcoded | exercise + tip 빈 영역 |
| **#12** | TicketShop 결제 영역 = `ticket_shop_user_prep_pending` | Play Console SKU + BillingClient 연동 |
| **#13** | TicketShopViewModel STUB_BALANCE = 3 hardcoded | TicketRepository observeBalance 영역 연결 의무 |
| **#24** | ReportViewModel monthly generate 호출 영역 X | refreshMonthly 만 / generate 영역 추가 의무 |
| **#25** | ReportViewModel.generate() UI 트리거 영역 부재 | ReportContent 영역 CTA 추가 의무 |
| **#31** | InsightCard cost chip (-3 한입) 영역 부재 | InsightUi 영역 cost field 추가 의무 |
| **#33+#34** | MealDetail/Reaction UseCase 미연결 + stub | Cross-domain paradigm 핵심 영역 |
| **#39** | creditAdReward Edge Function 미연동 (로컬만) | SyncRepository 영역 의존 영역 검증 의무 |

---

## P4 — i18n 영역 손실 (선택 정정)

| # | 영역 | 비고 |
|---|---|---|
| **#14** | errorMessage type 불일치 (BillingUiState String / 다른 ViewModel @StringRes Int) | 다국어 영역 손실 + paradigm 일관성 X |
| **#17** | SettingsScreen line 191 hardcoded "보유: ${...}한입" | strings.xml `settings_section_subscription_balance_format` 영역 추가 의무 |
| **#23+#30+#35** | ReportViewModel + ReportContent + MealDetail/Reaction 한국어 hardcoded | 다국어 영역 손실 |

---

## P5 — 보조 영역 (선택 정정)

| # | 영역 | 비고 |
|---|---|---|
| **#9** | 칼로리 type 불일치 (UI Int / DB Decimal) | 영양소 정밀도 손실 |
| **#10** | HomeViewModel.onRequestRecommendation dead code | HomeRoute 영역 navigation 만 사용 |
| **#16** | dietGoal default "건강유지" enum 외 | data-model enum 정합 영역 |
| **#20** | 잔액 영역 paradigm 충돌 | Settings observeBalance / TicketShop hardcoded |
| **#22** | MealEnv 4 layer 정합 (#1 영역 정합 ✓) | (정합 영역 — 비판 X) |
| **#26** | toNutritionUi hardcoded ratio (50%/25%/25%) | 실 데이터 영역 미연동 |
| **#36** | DailyCondition.mealEnvironment nullable paradigm 충돌 | DB NOT NULL 영역 |

---

## 통계

| Priority | 건수 | 본 cycle 정정 | 별 cycle |
|---|---|---|---|
| P0 ★★ | 3 | ✓ | — |
| P1 | 5 | — | ✓ |
| P2 | 3 | — | ✓ |
| P3 | 9 | — | ✓ (TODO user-prep) |
| P4 | 4 | — | ✓ (i18n cycle) |
| P5 | 7 | — | ✓ (보조 cycle) |
| **합** | **40** | **3** | **37** |

---

## 별 cycle 후보 (다음 진행 영역 권장 순서)

1. **PHASE-EDGE-FN-MEAL-ENV-001** (server) — Supabase `generate-recommendations` 함수 영역 mealEnvironment input + Claude 프롬프트 영역 mealEnvironment 전달 (P0-1 server 영역 보강)
2. **PHASE-AI-RECOMMEND-WIRE-001** (client) — MealRecommendationViewModel Edge Function 연결 + GenerateDailyRecommendationUseCase 영역 호출 (#11)
3. **PHASE-NUTRITION-WIRE-001** — 영양 정보 (protein/carbs/fat) Edge Function 응답 영역 매핑 (#38)
4. **PHASE-TICKET-BALANCE-WIRE-001** — TicketShopViewModel observeBalance 연결 (#13)
5. **PHASE-MONTHLY-INSIGHT-001** — ReportViewModel monthly generate + UI 트리거 + InsightCard cost chip (#24+#25+#31+#40)
6. **PHASE-CROSS-DOMAIN-WIRE-001** — MealDetail/Reaction Repository 연결 (#33+#34)
7. **PHASE-NOTIFICATION-001** — AlarmManager/WorkManager 알림 영역 (#6+#18)
8. **PHASE-PARADIGM-RECONCILE-001** — 식사 환경 enum 4 layer 통일 (#1) + ConditionInput 5 질문 영역 (#5+#8)
9. **PHASE-EXERCISE-PARADIGM-001** — 운동 가이드 카테고리/루틴/상세 영역 재설계 (#32) + Timer 영역 결정 (#28)
10. **PHASE-HISTORY-PARADIGM-001** — 캘린더 paradigm 채택 vs 기획 list 채택 결정 (#27)

---

**Sources**:
- [EVIDENCE.md](./EVIDENCE.md)
- [docs/design/billing.md](computer:///Users/yundonghyeon/AndroidStudioProjects/GentlyTable/docs/design/billing.md)
- [docs/design/ai-food-data-legal.md](computer:///Users/yundonghyeon/AndroidStudioProjects/GentlyTable/docs/design/ai-food-data-legal.md)
