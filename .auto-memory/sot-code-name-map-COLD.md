# sot-code-name-map — COLD storage (은퇴 직전 원문 전문 verbatim)

> **신설**: MASTER-AIDOC-RELEASE-REALIGN-001 (2026-08-23 · 은퇴 직전 HEAD `8ace5a3`).
> **원 경로**: `docs/rules/sot-code-name-map.md` (= 진입 sha8 `be929efd` · 139행 · 4-repo byte-identical) — 본 cycle `git rm`.
> **은퇴 사유**: 분모가 동결 3(GB/GD/GT) 전량이고 활성 자식(Selfward) 섹션이 0이라, 읽히면 죽은 repo 의 stale 표를 준다 — 없는 것보다 나쁘다.
> **비규범 (감사·추적 전용)**: live 규정과 충돌 시 hot rule 이 우선. master-only (= `.auto-memory/` · propagation X).
> **hot 복귀 trigger**: Selfward 판 화면 census 선행 후 매핑 재수립 판단 시 (= 본 cycle scope 밖 · 별 판).

---

# SoT ↔ Code 화면명 매핑 SoT (4-repo · master + app-foundation + toward-product-docs + Selfward · 자식 도메인 코드 = Selfward 측만 · 구 GB/GD/GT = 2026-07-17 T6 동결)

> **단일 목적**: Pencil SoT 화면명 ↔ Compose 코드 화면명 차이 영역 통합 매핑.
> **scope**: GB / GD / GT 3 자식 repo (master = SoT 만 보유 / 코드 X).
> **연관 파일**: `design-to-code-sync.md` (Phase 분류) · `pencil-sot-policy.md` (Pencil SoT 정책) · `uiux-sot-refresh.md` (refresh trigger).
> **baseline**: 2026-05-05 (cycle MULTI-REPO-SOT-CODE-NAME-MAP-001 신설).
> SOT: `CLAUDE.md`

> ⚠ **STALENESS / VOLATILITY 경고** (= 2026-05-31 측정 · `MASTER-CLI-SOT-CODE-NAME-MAP-VOLATILE-FLAG-001`):
> - **3 자식 코드 row 대거 stale** (= GB 6 / GD 3 / GT 9 stale) + **실재 화면 누락** (= GB 5 / GD 6 / GT 4) + ui-spec SoT 디렉터리 희소 (= GB 4 / GT 4).
> - 본 doc = **volatile artifact** (= 화면 evolution 마다 4-repo 수기 byte-identical 갱신 의무 · disk 자동 도출 가능 영역을 수기 유지 · `rule-architecture` 원칙 4 변동성 risk · 원칙 1 양 최소·SSOT risk).
> - **전면 재매핑 + 구조결정 (= 자동도출 hook vs byte-identical 강등 vs 자식별 분리) = `ENTRY-PROMPT-rule-architecture-establishment.md` 프로그램 이관** (= GAP-2 행동→규칙 라우팅 색인 + §5-A L3 도메인층 + 원칙 1/4). **그 전까지 본 §2~§4 표 = 참고용 (= 현행 보장 X)**.

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
| auth-screen | (UI 미구현) | SoT only | — | 익명 인증 자동 (`AnonymousAuthBootstrap`), UI 화면 없음 — ⚠ **스코프 표지: 본 행 = 동결 3 중 GB 계보 한정 · 활성 default 아님** (`auth-rules.md` §1 스코프 라벨 · 2026-08-05 `MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001`) · 활성 자식 Selfward = **email-first 가입 UI 실재** (실측 `composeApp/src/commonMain/kotlin/com/gently/selfward/shared/auth/SignInScreen.kt`) · 현행 = `auth-rules.md` §1b (구 서술 = GB 실측 이력 · 삭제 0 · SELFWARD-PRELAUNCH-SWEEP-002) |
| breathing-screen | BreathScreen.kt | 1:1 명명 차이 | `Destinations.BREATH` | "breathing" ↔ "Breath" |
| darkmode-screen | (없음) | SoT only | — | 디자인 SoT (테마 토글), 코드 = SettingsScreen 안 토글 컴포넌트 |
| design-tokens-screen | (없음) | SoT only | — | 디자인 시스템 SoT (코드 X) |
| diary-screen | JournalScreens.kt | 1:1 명명 차이 | `Destinations.JOURNAL` | "diary" ↔ "Journal" |
| home-screen | HomeScreen.kt | 1:1 직매핑 | `Destinations.HOME` | — |
| onboarding-2-screen | OnboardingScreen.kt | N:1 통합 | `Destinations.ONBOARDING` | 4 SoT → 1 코드 |
| onboarding-ai-screen | OnboardingScreen.kt | N:1 통합 | (위 동) | (위 동) |
| onboarding-emotion-screen | OnboardingScreen.kt | N:1 통합 | (위 동) | (위 동) |
| onboarding-wrapper-screen | OnboardingScreen.kt | N:1 통합 | (위 동) | (위 동) |
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
| daily-journal (detail) | JournalDetailScreen.kt | 1:1 명명 차이 | `Destination.JournalDetail` | 2026-07-12 등재 · daily-journal.pen GDde1 artboard · shared/daily |
| daily-journal (shelf) | JournalShelfScreen.kt | 1:1 명명 차이 | `Destination.Shelf` | 2026-07-12 등재 · daily-journal.pen GDsh1 artboard · shared/daily · route 명 = "Shelf" |
| design-tokens-screen | (없음) | SoT only | — | 디자인 시스템 SoT |
| habit-tracking-screen | RoutineScreen.kt | 1:1 (라우트 명 잔재) | `Routes.Habits` | route 명 = "habits" 잔재 / 화면 본문은 routine. SoT 정정 또는 deprecated 검토 |
| home-screen | HomeScreen.kt | 1:1 직매핑 | `Routes.Home` | — |
| morning-routine-progress-screen | RoutineScreen.kt | N:1 통합 | `Routes.Habits` | 3 routine SoT → 1 코드 (RoutineType.MORNING) |
| night-routine-empty-screen | RoutineScreen.kt | N:1 통합 | (위 동) | RoutineType.NIGHT empty state |
| night-routine-progress-screen | RoutineScreen.kt | N:1 통합 | (위 동) | RoutineType.NIGHT progress state |
| onboarding-screen | OnboardingScreen.kt | 1:1 직매핑 | `Routes.Onboarding` | — |
| reply (compose) | ReplyComposeSheet.kt | 1:1 명명 차이 | (시트 · 라우트 X) | 2026-07-12 등재 · reply.pen GDrc1 · shared/reply · JournalShelf/Detail 화면에서 modal overlay (App.kt `composeOrigin`) |
| reply (detail) | ReplyDetailScreen.kt | 1:1 명명 차이 | `Destination.ReplyDetail` | 2026-07-12 등재 · reply.pen GDrd1 · shared/reply · 뒤로 대상 dynamic (App.kt `replyDetailBackTarget`) |
| reply (shelf) | ReplyShelfScreen.kt | 1:1 명명 차이 | `Destination.ReplyShelf` | 2026-07-12 등재 · reply.pen GDrs1 · shared/reply |
| report-screen | ReportScreen.kt | 1:1 직매핑 | `Routes.Reports` | — |
| return-notes | ReturnNotesScreen.kt | 1:1 직매핑 | `Destination.ReturnNotes` | 2026-07-12 등재 · shared/settings · return-notes.pen GDrn1 · Settings 진입 (back=Settings) · "돌아온 날의 기록" |
| routine-item-add-screen | RoutineScreen.kt 일부 | N:1 통합 | `Routes.Habits` | RoutineScreen 안 Generate / 추가 항목 (별 라우트 X) |
| settings-screen | SettingsScreen.kt | 1:1 직매핑 | `Routes.Settings` | — |
| sleep-screen | SleepScreen.kt | 1:1 직매핑 | `Routes.Sleep` | — |
| splash-screen | SplashScreen.kt | 1:1 직매핑 | `Routes.Splash` | — |

---

## 4. GT (GentlyTable) 매핑

| SoT 화면명 (ui-spec) | 코드 화면명 | 카테고리 | 라우트 | 비고 |
|---|---|---|---|---|
| ai-disclaimer-screen | AIDetailScreen.kt | 1:1 명명 차이 | `RootRoutes.SETTINGS_AI` | settings/sub/ · `AiDisclaimerDetailCard` 컴포넌트 포함 |
| auth-screen | (UI 미구현) | SoT only | — | 익명 인증 자동 (`AnonymousAuthBootstrap`) — ⚠ **스코프 표지: 본 행 = 동결 3 중 GT 계보 한정 · 활성 default 아님** (`auth-rules.md` §1 스코프 라벨 · 2026-08-05 `MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001`) · 활성 자식 Selfward = **email-first 가입 UI 실재** (실측 `composeApp/src/commonMain/kotlin/com/gently/selfward/shared/auth/SignInScreen.kt`) · 현행 = `auth-rules.md` §1b (구 서술 = GT 실측 이력 · 삭제 0 · SELFWARD-PRELAUNCH-SWEEP-002) |
| condition-input-screen | ConditionInputScreen.kt | 1:1 직매핑 | `RootRoutes.CONDITION_INPUT` | — |
| daily-accompaniment-screen | DailyAccompanimentScreen.kt | 1:1 직매핑 | (Phase 3 vertical slice) | GT-PHASE-3-SOT-001 신설 · RESULT = AccompanimentResultContent.kt |
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

## 5. 패턴 집계 (GB+GD+GT 자식 도메인 합산 · master + app-foundation 측 도메인 코드 X default)

| 카테고리 | GB | GD | GT | 합 |
|---|---|---|---|---|
| 1:1 직매핑 | 4 | 6 | 12 | 22 |
| 1:1 명명 차이 | 4 | 0 | 2 | 6 |
| N:1 통합 | 4 | 5 | 0 | 9 |
| SoT only | 3 | 2 | 3 | 8 |
| 코드 only | 2 | 0 | 1 | 3 |

---

## 6. STOP 조건

1. 코드 측 본질 변경 (rename / 통합 / 분리) = STOP. 본 SoT 는 매핑만 기록, 변경 명령 X.
2. SoT 측 신설 / 통합 / 폐기 결정 = Coin 명시 승인 의무.
3. 전면 재매핑 + 구조결정 (= 자동도출 vs byte-identical 강등 vs 자식별 분리) = 본 doc scope X → `rule-architecture` 프로그램 이관 (= 상단 STALENESS 배너 + §8 정합). 수기 부분 재매핑도 회피 (= 원칙 4 재위반 risk).

---

## 7. 갱신 trigger

- 보호 5 또는 cli infra 6 drift 발생 시 본 매핑 재검증 (직접 영향 X 면 lazy).
- 자식 repo 안 신규 *Screen*.kt 추가 / 삭제 / rename = 본 매핑 row 갱신 의무.
- 자식 repo 안 신규 ui-spec.json 추가 / 삭제 / rename = 본 매핑 row 갱신 의무.
- 갱신 시 master 작성 + 4-repo cp propagation (cli infra 표준 byte-identical 의무 · 자식 도메인 코드 매핑 본질 = Selfward 측만 default · foundation 측 화면 X default).

---

## 8. 미해결 영역 (다음 cycle 후보)

- GB ProfileSetupScreen / TicketPurchaseScreen → SoT 신설 vs 기존 SoT 통합 결정.
- GD habit-tracking-screen → RoutineScreen 통합 인정 (SoT 폐기) vs SoT 분리 (별 화면 신설) 결정.
- GD routine-item-add-screen → RoutineScreen 일부 인정 (현 매핑) vs 별 라우트 분리 결정.
- GD (2026-07-12 발견 · MASTER-CLI-SOTMAP-REGISTER-001) daily-journal.pen `GDdj1` (적기 바텀시트 [TARGET] · design-debt/L4 = 기존 `DailyJournalScreen.kt` (shared/daily · ModalBottomSheet) 의 design→code follow 대상) + reply.pen `GDrx1` (SourcesSheet · "참고한 기록" 소스 시트 · 전용 코드 화면 부재) = 신규 artboard 등재 보류분 (§2 T1 pending-4-외). 매핑 확정 = 별 판단.
- GT DietDetailScreen → 새 SoT 신설 (diet-detail-screen) 검토.
- 자동화 hook 신설 (`design-to-code-sync` 와 통합) → 별 cycle.
- **전면 재매핑 + 구조결정** (= 자동도출 hook vs byte-identical 강등 vs 자식별 분리) → `ENTRY-PROMPT-rule-architecture-establishment.md` 프로그램 이관 (= GAP-2 행동→규칙 라우팅 색인 + L3 도메인층 + 원칙 1/4 · 상단 STALENESS 배너 정합).
