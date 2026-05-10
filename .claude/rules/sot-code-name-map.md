# SoT ↔ Code 화면명 매핑 SoT (3-repo)

> **단일 목적**: Pencil SoT 화면명 ↔ Compose 코드 화면명 차이 영역 통합 매핑.
> **scope**: GB / GD / GT 3 자식 repo (master = SoT 만 보유 / 코드 X).
> **연관 파일**: `design-to-code-sync.md` (Phase 분류) · `pencil-sot-policy.md` (Pencil SoT 정책) · `uiux-sot-refresh.md` (refresh trigger).
> **baseline**: 2026-05-05 (cycle MULTI-REPO-SOT-CODE-NAME-MAP-001 신설) · chat A 의존 row 2 = TODO placeholder.
> SOT: `CLAUDE.md`

---

## 1. 매핑 카테고리 (5 종)

| 카테고리 | 정의 | 처리 |
|---|---|---|
| **1:1 직매핑** | SoT 1 ↔ 코드 1 (명명 동일) | 그대로 |
| **1:1 명명 차이** | SoT 1 ↔ 코드 1 (명명 단순 차이) | 매핑 명시만 (rename 강제 X) |
| **N:1 통합** | SoT N ↔ 코드 1 (의도된 통합) | OK (코드 측 단일 화면이 다층 SoT 흡수) |
| **SoT only** | SoT 존재 / 코드 미구현 또는 디자인 SoT 만 | 디자인 SoT 유지 (예: design-tokens · darkmode), 또는 코드 미구현 TODO |
| **코드 only** | 코드 존재 / SoT 미존재 | SoT 신설 검토 후보 또는 deprecated 코드 검토 |

---

## 2. GB (GentlyBreath) 매핑

| SoT 화면명 (ui-spec) | 코드 화면명 (`*Screen*.kt`) | 카테고리 | 라우트 | 비고 |
|---|---|---|---|---|
| auth-screen | (UI 미구현) | SoT only | — | 익명 인증 자동 (`AnonymousAuthBootstrap`), UI 화면 없음 |
| breathing-screen | BreathScreen.kt | 1:1 명명 차이 | `Destinations.BREATH` | "breathing" ↔ "Breath" |
| darkmode-screen | (없음) | SoT only | — | 디자인 SoT (테마 토글), 코드 = SettingsScreen 안 토글 컴포넌트 |
| design-tokens-screen | (없음) | SoT only | — | 디자인 시스템 SoT (코드 X) |
| diary-screen | JournalScreens.kt | 1:1 명명 차이 | `Destinations.JOURNAL` | "diary" ↔ "Journal" |
| home-screen | HomeScreen.kt | 1:1 직매핑 | `Destinations.HOME` | — |
| onboarding-2-screen | OnboardingScreen.kt | N:1 통합 | `Destinations.ONBOARDING` | 4 SoT → 1 코드 |
| onboarding-ai-screen | OnboardingScreen.kt | N:1 통합 | (위 동) | (위 동) |
| onboarding-emotion-screen | OnboardingScreen.kt | N:1 통합 | (위 동) | (위 동) |
| onboarding-wrapper-screen | OnboardingScreen.kt | N:1 통합 | (위 동) | (위 동) |
| **paywall-screen** | **TODO (chat A 마감 baseline 인용)** | TODO | — | chat A 마감 후 1 회 갱신 |
| report-screen | ReportsScreen.kt | 1:1 명명 차이 | `Destinations.REPORTS` | "report" ↔ "Reports" |
| settings-screen | SettingsScreen.kt | 1:1 직매핑 | `Destinations.SETTINGS` | — |
| splash-landing-screen | SplashScreen.kt | 1:1 명명 차이 | `Destinations.SPLASH` | "splash-landing" ↔ "Splash" |
| ticket-shop-screen | TicketShopScreen.kt | 1:1 직매핑 | `Destinations.TICKET_SHOP` | — |
| upgrade-account-screen | (UI 미구현) | SoT only | — | 코드 미구현, 추후 신설 검토 |
| (SoT 미존재) | ProfileSetupScreen.kt | 코드 only | `Destinations.PROFILE_SETUP` | 프로필 초기 설정 — SoT 신설 후보 (auth-screen 분리 또는 별 SoT) |
| (SoT 미존재) | TicketPurchaseScreen.kt | 코드 only | `Destinations.TICKET_PURCHASE` | ticket-shop-screen 의 변형 — SoT 분리 검토 |

---

## 3. GD (GentlyDay) 매핑

| SoT 화면명 (ui-spec) | 코드 화면명 | 카테고리 | 라우트 | 비고 |
|---|---|---|---|---|
| auth-screen | (UI 미구현) | SoT only | — | GB 와 동일 패턴 (`AnonymousAuthBootstrap` 자동) |
| design-tokens-screen | (없음) | SoT only | — | 디자인 시스템 SoT |
| habit-tracking-screen | RoutineScreen.kt | 1:1 (라우트 명 잔재) | `Routes.Habits` | route 명 = "habits" 잔재 / 화면 본문은 routine. SoT 정정 또는 deprecated 검토 |
| home-screen | HomeScreen.kt | 1:1 직매핑 | `Routes.Home` | — |
| morning-routine-progress-screen | RoutineScreen.kt | N:1 통합 | `Routes.Habits` | 3 routine SoT → 1 코드 (RoutineType.MORNING) |
| night-routine-empty-screen | RoutineScreen.kt | N:1 통합 | (위 동) | RoutineType.NIGHT empty state |
| night-routine-progress-screen | RoutineScreen.kt | N:1 통합 | (위 동) | RoutineType.NIGHT progress state |
| onboarding-screen | OnboardingScreen.kt | 1:1 직매핑 | `Routes.Onboarding` | — |
| report-screen | ReportScreen.kt | 1:1 직매핑 | `Routes.Reports` | — |
| routine-item-add-screen | RoutineScreen.kt 일부 | N:1 통합 | `Routes.Habits` | RoutineScreen 안 Generate / 추가 항목 (별 라우트 X) |
| settings-screen | SettingsScreen.kt | 1:1 직매핑 | `Routes.Settings` | — |
| sleep-screen | SleepScreen.kt | 1:1 직매핑 | `Routes.Sleep` | — |
| splash-screen | SplashScreen.kt | 1:1 직매핑 | `Routes.Splash` | — |
| **(SoT 미존재 / chat A 의존)** | **TicketScreen.kt** | TODO | `Routes.Ticket` | **chat A 마감 baseline 인용 의무 (GD ticketshop 결정 a/b/c)** |

---

## 4. GT (GentlyTable) 매핑

| SoT 화면명 (ui-spec) | 코드 화면명 | 카테고리 | 라우트 | 비고 |
|---|---|---|---|---|
| ai-disclaimer-screen | AIDetailScreen.kt | 1:1 명명 차이 | `RootRoutes.SETTINGS_AI` | settings/sub/ · `AiDisclaimerDetailCard` 컴포넌트 포함 |
| auth-screen | (UI 미구현) | SoT only | — | 익명 인증 자동 (`AnonymousAuthBootstrap`) |
| condition-input-screen | ConditionInputScreen.kt | 1:1 직매핑 | `RootRoutes.CONDITION_INPUT` | — |
| daily-prescription-screen | DailyPrescriptionScreen.kt | 1:1 직매핑 | (Phase 3 vertical slice) | GT-PHASE-3-SOT-001 신설 · RESULT = PrescriptionResultContent.kt |
| darkmode-screen | (없음) | SoT only | — | 디자인 SoT (테마 토글) |
| design-tokens-screen | (없음) | SoT only | — | 디자인 시스템 SoT |
| exercise-screen | ExerciseScreen.kt | 1:1 직매핑 | `RootRoutes.EXERCISE` | — |
| history-screen | HistoryScreen.kt | 1:1 직매핑 | `MainTab.History.route` | — |
| home-screen | HomeScreen.kt | 1:1 직매핑 | `MainTab.Home.route` | — |
| meal-detail-screen | MealDetailScreen.kt | 1:1 직매핑 | (sub) | — |
| meal-reaction-screen | MealReactionScreen.kt | 1:1 직매핑 | (sub) | — |
| meal-recommend-screen | MealRecommendationScreen.kt | 1:1 명명 차이 | `MainTab.MealRecommendation.route` | "recommend" ↔ "Recommendation" |
| onboarding-screen | OnboardingScreen.kt | 1:1 직매핑 | `RootRoutes.ONBOARDING` | — |
| report-screen | ReportScreen.kt | 1:1 직매핑 | `MainTab.Report.route` | — |
| settings-screen | SettingsScreen.kt | 1:1 직매핑 | `MainTab.Settings.route` | — |
| ticketshop-screen | TicketShopScreen.kt | 1:1 직매핑 | `RootRoutes.TICKET_SHOP` | — |
| (SoT 미존재) | DietDetailScreen.kt | 코드 only | `RootRoutes.SETTINGS_DIET` | settings/sub/ · SoT 신설 후보 (diet-detail-screen 또는 settings-diet-screen) |

---

## 5. 패턴 집계 (3-repo 합산)

| 카테고리 | GB | GD | GT | 합 |
|---|---|---|---|---|
| 1:1 직매핑 | 4 | 6 | 12 | 22 |
| 1:1 명명 차이 | 4 | 0 | 2 | 6 |
| N:1 통합 | 4 | 5 | 0 | 9 |
| SoT only | 3 | 2 | 3 | 8 |
| 코드 only | 2 | 0 | 1 | 3 |
| TODO (chat A 의존) | 1 | 1 | 0 | 2 |

---

## 6. STOP 조건

1. 코드 측 본질 변경 (rename / 통합 / 분리) = STOP. 본 SoT 는 매핑만 기록, 변경 명령 X.
2. SoT 측 신설 / 통합 / 폐기 결정 = Coin 명시 승인 의무.
3. chat A 의존 row 2 (GB paywall · GD TicketScreen) = chat A 마감 후 1 회 갱신만 허용. 본 cycle 내 갱신 X.

---

## 7. 갱신 trigger

- 보호 5 또는 cli infra 6 drift 발생 시 본 매핑 재검증 (직접 영향 X 면 lazy).
- 자식 repo 안 신규 *Screen*.kt 추가 / 삭제 / rename = 본 매핑 row 갱신 의무.
- 자식 repo 안 신규 ui-spec.json 추가 / 삭제 / rename = 본 매핑 row 갱신 의무.
- 갱신 시 master 작성 + 3 자식 repo cp propagation (cli infra 표준 byte-identical 의무).

---

## 8. 미해결 영역 (다음 cycle 후보)

- GB ProfileSetupScreen / TicketPurchaseScreen → SoT 신설 vs 기존 SoT 통합 결정.
- GD habit-tracking-screen → RoutineScreen 통합 인정 (SoT 폐기) vs SoT 분리 (별 화면 신설) 결정.
- GD routine-item-add-screen → RoutineScreen 일부 인정 (현 매핑) vs 별 라우트 분리 결정.
- GT DietDetailScreen → 새 SoT 신설 (diet-detail-screen) 검토.
- 자동화 hook 신설 (`design-to-code-sync` 와 통합) → 별 cycle.
