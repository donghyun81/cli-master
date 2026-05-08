# GT-PLAN-VS-IMPL-GAP-AUDIT-001 — EVIDENCE

**작성일**: 2026-05-08 (KST)
**Scope**: 단일 repo (GentlyTable) · Cowork audit + 정정 영역
**부모 cycle**:
- 정적 audit Phase 1 = `MULTI-REPO-UIUX-AUDIT-AGAINST-UX-LAWS-001` (master)
- runtime audit GT 영역 = `MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001` (F9~F13)
- 마감 영역 3 commit (audit 시점 baseline):
  - `3b5d38f` chat A GT settings 정정
  - `c2dd287` chat C GT splash §3.2 AND-gate 사유 주석
  - `553c40b` cycle 1 NavCard 한입샵 + Billing graceful

---

## Requirements Source

기획안 SoT 9 file (총 ~225KB · `docs/plan/` + `docs/design/` + `docs/implementation-guide/`):
1. `기획안_보강.md` (15.7K · 369 줄) — 슬로건 + 30초 UX + 5탭 + Claude 식품 DB + 한입 결제 + 리포트 5 영역 paradigm
2. `screen-flow.md` (28.2K · 789 줄) — 14 화면 명세 + meal-reaction cross-domain
3. `ai-food-data-legal.md` (17.7K · 409 줄) ★ — 면책 3종 + Claude 상업용 + 공공 DB 교차 검증 + 의료법 회피
4. `ai-prompt-guide.md` (23.6K · 840 줄) — 시스템 프롬프트 + JSON 스키마 + 한식 7 카테고리
5. `billing.md` (13.9K · 474 줄) ★ — **차별화 영역** (loose recommendations / 30초 UX / 제거할 기능 = 엄격 칼로리 + 상세 식품 DB)
6. `data-model.md` (22K · 732 줄) — 11 테이블 + meal_environment 5 enum + Room 6 entity
7. `api-spec.md` (17.7K · 757 줄) — Edge Function 5 종 + 비즈니스 에러 코드
8. `01_IMPLEMENTATION_PHASES.md` (22.4K · 609 줄) — 16 Phase + Alpha/Beta/GA 마일스톤
9. `02_TODO_LIST.md` (50.6K · 598 줄) — 체크박스 영역 (완료/미완료)

setup 영역 (4 file · ~225KB) = 진행 baseline (변경 X · prompt §3 STOP 8).

---

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | audit (read-only · GT 도메인 + setup 영역 변경 X) + 정정 (P0 3건 영역) |
| Reading Mode | UI-UX형 + 정책-계획 점검형 |
| Requirement Source | docs/plan/ + docs/design/ + docs/implementation-guide/ + setup/ |
| Info Gap | RESOLVABLE_IN_REPO (영역 모두 GT + master 영역 mount) |
| STOP Risk | (a) 보호 sha 변동 X / (b) 다른 repo 수정 X / (c) 기획안 변경 X / (d) BillingManager 본질 변경 X / (e) ai-food-data-legal 변경 X / (f) setup 변경 X |
| Read-Only Fan-Out | requirements-analyst + ux-auditor (인라인 영역) |
| Implementer Entry | Allowed (P0 3건 정정 영역) — pre-EVIDENCE 계약 충족 후 |

---

## Pre-EVIDENCE Contract

- **Read evidence**: 9 기획 file + 35 실 구현 file (presentation 14 + domain 6 + data 핵심 5 + UiState 3 + strings + 기타)
- **Remaining gaps**: SecureTokenStore + DataStorePreferencesRepository + EdgeDtos + SyncWorker = 영역 추정 ↓ (영역 충분 도달)
- **Chosen path**: P0 3건 즉시 정정 + 보고서 4 file 작성 + Coin direct commit
- **Hold / Stop reasons**: Edge Function 측 (Supabase) 변경 = 별 cycle 분리 (TODO user-prep 영역 추가)
- **Implement entry conditions**: 본 EVIDENCE.md + ISSUES.md + MATRIX.md + REVIEW.md 작성 후

---

## Collect Results — 부적합 영역 40건 핵심 인용

### 차별화 영역 위반 (P0 · 본심 위반 ★★)

#### #15+#37 — AI 처방 영역 식사 환경 paradigm 미연동

`Repositories.kt` line 49-57:
```kotlin
suspend fun generateDaily(
    userId: String, condition: String, allergies: List<String>,
    preferences: List<String>, goal: String, excludeFoods: List<String>
): DomainResult<DailyRecommendationBundle>
// ★ mealEnvironment 영역 자체 X
```

`RecommendationRepositoryImpl.kt` line 73-79:
```kotlin
val request = GenerateRecommendationsRequest(
    condition = condition,
    allergies = allergies,
    preferences = preferences,
    goal = goal,
    excludeFoods = excludeFoods
    // ★ mealEnvironment 영역 X
)
```

→ Edge Function 호출 영역 (`generate-recommendations`) 자체 식사 환경 영역 미전달.
→ billing.md line 9-15 명시 차별화 영역 (구내식당+편의점+배달 한식 추천) **본심 paradigm 영역 미구현**.

#### #21 — 엄격 칼로리 추적 영역 잔존

`DietDetailScreen.kt` line 98-119:
```kotlin
private fun CalorieCard(value: Int, onChange: (Int) -> Unit) {
    Slider(value = value.toFloat(), valueRange = 1200f..3000f, ...)
}
```

`billing.md` line 14:
> "**제거할 기능**: 상세 식품 DB 탐색, 엄격한 칼로리 추적"

→ DietDetailScreen Slider 1200~3000 영역 잔존 = **본심 명시 영역 위반**.

#### #29 — Exercise 분당 6 kcal placeholder

`ExerciseViewModel.kt` line 113:
```kotlin
val estimatedKcal = (actualSeconds / 60) * 6  // 분당 6 kcal hardcoded
```

→ "엄격 칼로리 추적 X" 영역 정합 X (#21 영역 확대).

### Paradigm 충돌 (P1)

#### #1 — 식사 환경 enum 4 layer paradigm 충돌

| Layer | enum |
|---|---|
| 기획안 + data-model | 5 영역 (구내식당/편의점/배달/직접요리/외식) NOT NULL |
| OnboardingScreen (`MealEnvironment`) | 4 영역 (Home/Office/EatingOut/Delivery) |
| Settings (`MealEnv`) | 3 영역 (HOME/DINE_OUT/LUNCHBOX) |
| ConditionInput (`mealEnvironment = null` hardcoded) | 0 영역 |

→ 4 layer 영역 모두 다른 paradigm.

#### #5+#8 — ConditionInput 5 질문 영역 = 식사 상황 X

`ConditionInputUiState.kt` line 28: `TOTAL_QUESTIONS = 5`
`ConditionInputViewModel.kt` line 86: `mealEnvironment = null` hardcoded

기획안 §4.1 = 5 질문 (피로도 + 몸 상태 + 목표 + **식사 상황** + 추가 증상)
실 구현 = fatigue + mood + body + symptom + goal — 식사 상황 X.

#### #27 — HistoryScreen paradigm 영역 = 기획 외부

기획안 §4.2 + screen-flow §4 = 일자별 list paradigm
실 구현 `HistoryScreen.kt` = 월 캘린더 그리드 paradigm

#### #32 — Exercise paradigm 영역 충돌

기획안 §4.3 = 카테고리 4 (유산소/근력/유연성/기타) → 루틴 → 상세 가이드 (영상/텍스트)
실 구현 = 강도 chip 3 + AI 추천 카드 + Timer 영역 — 다른 paradigm.

#### #38 — 영양 정보 (protein/carbs/fat) 영역 미저장

`RecommendationRepositoryImpl.kt` line 96/109/122:
```kotlin
MealRecommendationEntity(
    calories = payload.breakfast.calories,
    protein = null, carbs = null, fat = null,  // ★ 모두 null
    ...
)
```

→ data-model `protein_g DECIMAL(6,2)` NOT NULL 영역 위반.

### Gold-Plating · YAGNI 위반 (P2)

- **#19** AiStyle 3 (CONSERVATIVE/BALANCED/DIVERSE) — 기획 0 회 등장
- **#28** Exercise Timer 영역 (Idle/Running/Paused/Complete) — 기획 외 추가
- **#40** `REQUEST_MONTHLY_INSIGHT` 영역 정의만 + ReportViewModel 영역 호출 X (dead constant)

### 미구현 영역 (P3 · TODO user-prep)

- **#6+#18** AlarmManager/WorkManager 알림 영역 미구현 (3 토글 모두 state만)
- **#11** MealRecommendationViewModel Edge Function 미연결 + stub hardcoded (exercise + tip 빈 영역)
- **#12** TicketShop 결제 영역 = `ticket_shop_user_prep_pending` 영역
- **#13** TicketShopViewModel STUB_BALANCE = 3 hardcoded
- **#24** ReportViewModel monthly generate 호출 영역 X
- **#25** ReportViewModel.generate() UI 트리거 영역 부재
- **#31** InsightCard cost chip (-3 한입) 영역 부재
- **#33+#34** MealDetail/Reaction UseCase 미연결 + stub hardcoded
- **#39** creditAdReward Edge Function 미연동 (로컬만)

### i18n 영역 손실 (P4)

- **#14** errorMessage type 불일치 (BillingUiState String / 다른 ViewModel @StringRes Int)
- **#17** SettingsScreen line 191 hardcoded "보유: ${...}한입"
- **#23+#30+#35** ReportViewModel + ReportContent + MealDetail/Reaction 한국어 hardcoded

### 보조 영역 (P5)

- **#9** 칼로리 type 불일치 (UI Int / DB Decimal)
- **#10** HomeViewModel.onRequestRecommendation dead code
- **#16** dietGoal default "건강유지" enum 외
- **#20** 잔액 영역 paradigm 충돌 (Settings observeBalance / TicketShop hardcoded)
- **#26** toNutritionUi hardcoded ratio (50%/25%/25%)
- **#36** DailyCondition.mealEnvironment nullable paradigm 충돌

---

## 정합 영역 (PASS · 36+ 영역)

### Auth paradigm 영역 ★ (auth-rules.md 정합)

- `AuthRepositoryImpl.signOut()` = "익명 세션 폐기 + 신규 부트스트랩" paradigm ✓
- `AuthRepositoryImpl.restoreSession()` = stored userId 복원 + bootstrap fallback ✓
- `AnonymousAuthBootstrap.bootstrapAsync()` = signupApi.signUpAnonymous() ✓
- `currentUserId` StateFlow ✓

### AI Disclaimer 영역 ★ (ai-food-data-legal.md 정합)

- strings.xml `ai_disclaimer_inline` + `ai_disclaimer_body` + `ai_disclaimer_food_db_accuracy` + `meal_ai_badge_label` ✓
- `meal_source_ai` + `meal_source_verified` ✓
- `AiDisclaimerInline` + `AiDisclaimerDetailCard` 컴포넌트 통합 (Onboarding + Home + MealRecommendation + Exercise + History + AIDetail) ✓

### 차별화 wording 영역 (billing.md 정합 부분)

- splash_tagline = "기록하지 마, 물어봐" ✓
- home_condition_eyebrow = "⏱ 약 30초" ✓
- condition_progress_badge = "⏱ 약 30초" ✓
- 한입 패키지 (5/15/30/50 + ₩1,100~8,500) ✓
- 광고 보상 = 1회/일 제한 영역 ✓
- ticketRepo.consume("full_recommendation") = 1 한입 ✓ + ("weekly_report") = 3 한입 ✓

### Splash AND-gate 영역 (chat C 정정 c2dd287 영역)

- `SplashRoute` line 50-57 = `dwellElapsed && destination resolved` AND-gate ✓
- §3.2 Doherty 정합 사유 주석 영역 ✓

### Settings 영역 (chat A 정정 3b5d38f + cycle 1 553c40b 영역)

- 7 section (Profile + Diet NavCard + Exercise NavCard + Notification + AI NavCard + Theme + 한입 NavCard + DataInfo + Logout) ✓
- 한입 티켓 NavCard 영역 = TicketShop 진입 path ✓ (cycle 1)
- `ticketRepo.observeBalance(id)` 실측 Flow ✓ (Settings 영역 — TicketShop hardcoded 영역과 paradigm 충돌 = #20)

### BillingManager 영역 (cycle 1 graceful · billing.md 정합)

- BillingClient + INAPP consumable + suspendCancellableCoroutine ✓
- startConnection / queryProducts / launchPurchase / consume / onPurchasesUpdated ✓
- BillingViewModel cycle 1 graceful 영역 (`startConnection failed - billing service unavailable` + "결제 서비스 연결 실패") ✓

### Edge Function 영역 (api-spec.md 정합)

- `EdgeFunctionDataSource` 5 함수 (`consume-tickets` / `generate-recommendations` / `generate-weekly-report` / `verify-purchase` / `sync-offline-data`) ✓
- `TicketRepositoryImpl.consume` = `DomainError.InsufficientTickets` 매핑 ✓ (line 62)

### DomainError 영역 (code-principles §3 정합)

- 7 sealed (NotAuthenticated/InvalidCredentials/InsufficientTickets/NetworkUnavailable/RemoteError/StorageError/Unexpected) ✓
- typed Result 패턴 ✓

### Boundary Mapping 영역 (workflow-core 정합)

- DomainModel (16 data class + 3 enum) 분리 ✓
- DTO ↔ DomainModel 변환 = `DomainMappers.kt` + `DtoMappers.kt` 영역 ✓
- DomainModel ↔ UiState 변환 = ViewModel 영역만 (HomeViewModel + MealRecommendationViewModel + ExerciseViewModel + ReportViewModel) ✓

### Report 5 영역 paradigm (cycle 11a 정합 부분)

- `ReportContent` = 5 영역 (TitleArea + TabsRow + NutritionCard + TrendCard + InsightCard) ✓
- `ReportTab` enum (Weekly/Monthly) ✓
- `NutritionDonut` + `GoalBar` + `FatigueBars` + `SparklesGlyph` ✓

### 접근성 영역 (ux-laws C-2 Fitts 정합)

- 48dp 최소 영역 (모든 Button + IconButton + ChipRow) ✓
- semantics contentDescription (MealRecommendation `meal-${type}` + MealDetail `meal-detail-close`) ✓
- selectable + Role.RadioButton (AIDetail) ✓
- TalkBack 영역 정합 영역 (StringRes 다수 영역)

### History 영역 (진단 아닌 관찰)

- `history_subtitle` = "진단 아닌 관찰 — 변화 추세 확인" ✓
- adherence 4 level (0/0.4/0.7/1.0 alpha) + LegendSheetContent ✓
- `history_legend_note` = "※ AI 추정치·참고용. 전문가 상담을 대체하지 않아요." ✓

### runtime 영역 (matrix-results.csv GT 26 row)

- PASS = 14 row (Cognitive Load + Doherty + Goal-Gradient + Mental Model + Serial Position + Common Region + Proximity + Choice Overload + Postel + Chunking + Hidden Costs + Forced Continuity + ...)
- FAIL = 1 row (settings F12 — cycle 1 마감 영역 ★ · 553c40b 후 정정)
- N/A = 1 row (ticket_shop · cycle 1 마감 영역 ★)
- 14 screenshot (light + dark)
- runtime 누락 6 영역 (#7 영역) — condition_input + exercise + meal_detail + meal_reaction + ai_detail + diet_detail

---

## Cleanup Assessment

본 cycle 영역 = audit (read-only) + P0 정정 (P0-1 client + P0-2 + P0-3) 영역.

### 발견된 후보

| 위치 | 설명 | 판정 |
|---|---|---|
| `DietDetailScreen.kt` line 98-119 (`CalorieCard`) | 엄격 칼로리 영역 — billing.md 위반 | **P0-2 즉시 제거** |
| `SettingsViewModel.updateCalorieGoal()` | CalorieCard handler | **P0-2 즉시 제거** |
| `DietConfigState.calorieGoal` | state field | **P0-2 즉시 제거** |
| strings.xml `settings_diet_calorie_*` (3 string) | 칼로리 wording | **P0-2 즉시 제거** |
| `ExerciseViewModel.kt` line 105-115 (`onComplete` kcal 계산) | 분당 6 kcal placeholder | **P0-3 즉시 제거** |
| `ExerciseTimerState.Complete.estimatedKcal` | 칼로리 field | **P0-3 즉시 제거** |
| `ExerciseScreen.TimerCompleteBody` kcal Text | 칼로리 표시 | **P0-3 즉시 제거** |
| strings.xml `exercise_timer_kcal_format` | 칼로리 wording | **P0-3 즉시 제거** |
| `HomeViewModel.onRequestRecommendation` line 42-66 | dead code (#10) | **TODO(deferred · P5 영역)** |
| `EdgeFunctionDataSource.REQUEST_MONTHLY_INSIGHT` | dead constant (#40) | **TODO(deferred · P3 영역)** |

### 점검 명령

```bash
grep -n "calorieGoal\|CalorieCard\|settings_diet_calorie" app/src/main/java app/src/main/res/values/strings.xml
grep -n "estimatedKcal\|exercise_timer_kcal_format" app/src/main/java app/src/main/res/values/strings.xml
grep -n "onRequestRecommendation\|REQUEST_MONTHLY_INSIGHT" app/src/main/java
```

### 판정 요약

- 즉시 제거 (P0-2 + P0-3): 8 영역
- deferred (P3~P5 TODO): 12 영역 (별 cycle)
- task-level STOP: 0 영역

---

## Key Findings

1. **차별화 영역 본심 위반 3건 (P0)** ★★ — 식사 환경 paradigm 미연동 + 엄격 칼로리 잔존 (Diet + Exercise) — billing.md 명시 영역 위반
2. **paradigm 충돌 5건 (P1)** — 식사 환경 4 layer + ConditionInput 5질문 + History calendar + Exercise gold-plating + 영양 정보 null
3. **gold-plating 3건 (P2)** — AiStyle + Exercise Timer + REQUEST_MONTHLY_INSIGHT
4. **TODO user-prep 12건 (P3)** — 미구현 영역 다수 (알림 + Edge Function + Stub + monthly + cost chip + cross-domain + creditAdReward)
5. **i18n 영역 5건 (P4)** + 보조 영역 7건 (P5)

**정합 영역 36+ ✓** — Auth paradigm + AI Disclaimer + 차별화 wording + Splash AND-gate + Settings + BillingManager + Edge Function + DomainError + Boundary Mapping + Report 5 영역 + 접근성 + History tone + runtime 26 row.

---

**Sources**:
- [docs/plan/기획안_보강.md](computer:///Users/yundonghyeon/AndroidStudioProjects/GentlyTable/docs/plan/기획안_보강.md)
- [docs/design/billing.md](computer:///Users/yundonghyeon/AndroidStudioProjects/GentlyTable/docs/design/billing.md)
- [docs/design/ai-food-data-legal.md](computer:///Users/yundonghyeon/AndroidStudioProjects/GentlyTable/docs/design/ai-food-data-legal.md)
- [.ai/reports/MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001/matrix-results.csv](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.ai/reports/MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001/matrix-results.csv)
