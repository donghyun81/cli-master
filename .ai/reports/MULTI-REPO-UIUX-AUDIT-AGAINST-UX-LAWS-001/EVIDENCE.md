# UI/UX Audit against ux-laws.md — Phase 1 EVIDENCE
# Cycle: MULTI-REPO-UIUX-AUDIT-AGAINST-UX-LAWS-001
# 일자: 2026-05-05
# baseline: ux-laws.md sha 80aa29153316b90e... (306 줄 · §5 10 task 유형 + §3 비권장 5 + Dark Patterns 5)
# 본 EVIDENCE 의 범위: Phase 1 (메타데이터 + §5 row 자동 매핑 + §3/Dark 1 차 검출 + N/A 분류)
# 한계: 깊이 검증 (A/F/I 권장 법칙 contextual review · D-1 정직 진행 흐름 검증 · Dark Patterns 깊이 흐름 검증) = Phase 2

---

## 1. cli infra 정합 검증 결과

| 파일 | 4-repo sha (앞 12자) | 정합 |
|---|---|---|
| ux-laws.md | 80aa29153316 | OK (4-repo byte-identical) |
| code-principles.md | 51b414f15c93 | OK |
| report-formats.md | 184dc55b4de6 | OK |
| ui-ux-analysis.md | e5b1af74c141 | OK |
| pencil-uiux-workflow.md | 7621013e7f2d | OK |
| design-to-code-sync.md | 603bc9945076 | OK |
| design-sot-policy.md | — | 4-repo 모두 부재 (baseline 일치 · 본 cycle audit baseline = design-to-code-sync.md 로 대체) |

**결과**: cli infra drift 0건. Phase 1 진입 baseline OK.

---

## 2. 자식 repo SoT inventory (자동 추출)

스크립트: `.ai/reports/MULTI-REPO-UIUX-AUDIT-AGAINST-UX-LAWS-001/scripts/audit_sot_inventory.py`

### 2.1 GB (GentlyBreath · 16 화면)

| 화면 | .pen | spec | capturedAt | lifecycle | components | §5 row | N/A |
|---|---|---|---|---|---|---|---|
| auth-screen | N | Y | 2026-04-22 | frozen | 2 | Auth-only (N/A) | Auth-only |
| breathing-screen | Y | Y | 2026-04-28 | active | 0 | 신규 화면 (UI) | - |
| darkmode-screen | Y | Y | 2026-04-27 | active | 0 | 신규 화면 (UI) | - |
| design-tokens-screen | Y | Y | 2026-04-22 | active | 0 | 신규 화면 (UI) | - |
| diary-screen | Y | Y | 2026-04-28 | active | 0 | Form (입력) | - |
| home-screen | Y | Y | 2026-04-28 | active | 0 | Navigation / list | - |
| onboarding-2-screen | Y | Y | 2026-04-28 | active | 0 | multi-step Form / Onboarding | - |
| onboarding-ai-screen | Y | Y | 2026-04-28 | active | 0 | multi-step Form / Onboarding | - |
| onboarding-emotion-screen | Y | Y | 2026-04-28 | active | 0 | multi-step Form / Onboarding | - |
| onboarding-wrapper-screen | Y | Y | 2026-04-28 | active | 0 | multi-step Form / Onboarding | - |
| paywall-screen | N | Y | 2026-04-22 | frozen | 2 | 결제/가입 | - |
| report-screen | Y | Y | 2026-04-28 | active | 0 | list / 카탈로그 | - |
| settings-screen | N | Y | 2026-04-22 | frozen | 2 | Form / Navigation | - |
| splash-landing-screen | Y | Y | 2026-04-28 | active | 0 | 신규 화면 (UI) | - |
| ticket-shop-screen | N | Y | 2026-04-22 | frozen | 2 | 결제/가입 | - |
| upgrade-account-screen | N | Y | 2026-04-21 | frozen | 2 | 결제/가입 | - |

**관측**: 결제/가입 4 종 (paywall · ticket-shop · upgrade-account · billing 관련) 모두 .pen 부재 + frozen lifecycle + componentCount 2. Phase 2 Dark Patterns 깊이 검증 의무 영역.

### 2.2 GD (GentlyDay · 13 화면)

| 화면 | .pen | spec | capturedAt | lifecycle | components | §5 row | N/A |
|---|---|---|---|---|---|---|---|
| auth-screen | Y | Y | 2026-05-04 | deprecated | 1 | Auth-only (N/A) | Auth-only |
| design-tokens-screen | N | Y | 2026-05-01 | removed | 0 | 신규 화면 (UI) | (removed) |
| habit-tracking-screen | Y | Y | 2026-05-01 | active | 1 | list / 카탈로그 | - |
| home-screen | Y | Y | 2026-05-01 | active | 1 | Navigation / list | - |
| morning-routine-progress-screen | Y | Y | 2026-05-01 | deprecated | 0 | 신규 화면 (UI) | - |
| night-routine-empty-screen | Y | Y | 2026-05-01 | deprecated | 0 | 신규 화면 (UI) | - |
| night-routine-progress-screen | Y | Y | 2026-05-01 | deprecated | 0 | 신규 화면 (UI) | - |
| onboarding-screen | Y | Y | 2026-05-02 | active | 1 | multi-step Form / Onboarding | - |
| report-screen | Y | Y | 2026-05-04 | active | 2 | list / 카탈로그 | - |
| routine-item-add-screen | Y | Y | 2026-05-01 | deprecated | 0 | Form (입력) | - |
| settings-screen | Y | Y | 2026-05-01 | active | 1 | Form / Navigation | - |
| sleep-screen | Y | Y | 2026-05-04 | active | 2 | 신규 화면 (UI) | - |
| splash-screen | Y | Y | 2026-05-01 | active | 1 | 신규 화면 (UI) | - |

**관측**: GD 의 deprecated 5 + removed 1 = lifecycle 흐름이 가장 활발 (최근 routine 영역 재구조화 흔적). active 7 만 audit 1차 대상.

### 2.3 GT (GentlyTable · 15 화면)

| 화면 | .pen | spec | capturedAt | lifecycle | components | §5 row | N/A |
|---|---|---|---|---|---|---|---|
| ai-disclaimer-screen | Y | Y | 2026-04-28 | active | 0 | 신규 화면 (UI) | - |
| auth-screen | N | Y | 2026-04-22 | frozen | 0 | Auth-only (N/A) | Auth-only |
| condition-input-screen | Y | Y | 2026-04-28 | active | 0 | Form (입력) | - |
| darkmode-screen | N | Y | 2026-04-22 | active | 0 | 신규 화면 (UI) | - |
| design-tokens-screen | N | Y | 2026-04-22 | active | 0 | 신규 화면 (UI) | - |
| exercise-screen | Y | Y | 2026-04-30 | active | 0 | 신규 화면 (UI) | - |
| history-screen | Y | Y | 2026-04-29 | active | 0 | list / 카탈로그 | - |
| home-screen | Y | Y | 2026-04-29 | active | 0 | Navigation / list | - |
| meal-detail-screen | Y | Y | 2026-05-01 | active | 0 | 신규 화면 (UI) | - |
| meal-reaction-screen | Y | Y | 2026-05-01 | active | 0 | Form (입력) | - |
| meal-recommend-screen | Y | Y | 2026-04-29 | active | 0 | list / 카탈로그 | - |
| onboarding-screen | Y | Y | 2026-04-30 | active | 0 | multi-step Form / Onboarding | - |
| report-screen | Y | Y | 2026-05-01 | active | 5 | list / 카탈로그 | - |
| settings-screen | N | Y | 2026-04-22 | frozen | 0 | Form / Navigation | - |
| ticketshop-screen | N | Y | 2026-04-22 | frozen | 0 | 결제/가입 | - |

**관측**: 4 화면 (auth/darkmode/design-tokens/settings/ticketshop = 5) .pen 부재 + frozen. ticketshop = Phase 2 Dark Patterns 의무.

### 2.4 SoT 메타 통계 합계

| repo | 화면 | .pen 존재 | frozen | active | deprecated | removed | 결제/가입 | Form |
|---|---|---|---|---|---|---|---|---|
| GB | 16 | 11 | 5 | 11 | 0 | 0 | 3 | 1 |
| GD | 13 | 12 | 0 | 7 | 5 | 1 | 0 | 1 |
| GT | 15 | 10 | 5 | 10 | 0 | 0 | 1 | 2 |

---

## 3. Compose 코드 inventory (자동 추출)

### 3.1 GB

| 화면 | Screen.kt | ViewModel.kt |
|---|---|---|
| Splash | presentation/splash/SplashScreen.kt | - |
| Onboarding | presentation/onboarding/OnboardingScreen.kt | OnboardingViewModel.kt |
| Home | presentation/home/HomeScreen.kt | HomeViewModel.kt |
| Breath | presentation/breath/BreathScreen.kt | BreathViewModel.kt |
| Emotion (Journal) | presentation/emotion/JournalScreens.kt | EmotionCheckin/Journal VM |
| Reports | presentation/reports/ReportsScreen.kt | ReportsViewModel.kt |
| Profile/Settings | presentation/profile/{ProfileSetupScreen, SettingsScreen}.kt | ProfileViewModel.kt |
| Ticket | presentation/ticket/{TicketPurchaseScreen, TicketShopScreen}.kt | TicketViewModel.kt |
| Meditation | (Screen 부재 · VM 만 존재) | MeditationViewModel.kt |

**SoT-코드 정합 갭 (1 차 관측)**: SoT 화면명 ↔ 코드 화면명 차이 — `breathing-screen` ↔ `BreathScreen.kt` · `diary-screen` ↔ `JournalScreens.kt` · `paywall-screen`/`upgrade-account-screen` ↔ 코드 부재 (TicketShopScreen 으로 통합 추정). `MeditationViewModel.kt` ↔ SoT 부재. Phase 2 정합 대응 cycle 후보.

### 3.2 GD

| 화면 | Screen.kt | ViewModel.kt |
|---|---|---|
| Splash | presentation/splash/SplashScreen.kt | SplashViewModel.kt |
| Onboarding | presentation/onboarding/OnboardingScreen.kt | OnboardingViewModel.kt |
| Home | presentation/home/HomeScreen.kt | HomeViewModel.kt |
| Routine | presentation/routine/RoutineScreen.kt | RoutineViewModel.kt |
| Sleep | presentation/sleep/SleepScreen.kt | SleepViewModel.kt |
| Report | presentation/report/ReportScreen.kt | ReportViewModel.kt |
| Settings | presentation/settings/SettingsScreen.kt | SettingsViewModel.kt |
| Ticket | presentation/ticket/TicketScreen.kt | TicketViewModel.kt |

**SoT-코드 정합 갭**: SoT 의 `morning-routine-progress` / `night-routine-*` 3 종 (deprecated) ↔ 단일 `RoutineScreen.kt` 로 통합. SoT 의 `habit-tracking-screen` (active) ↔ 코드 부재 (Routine 안 통합 추정). Phase 2 검증.

### 3.3 GT

| 화면 | Screen.kt | ViewModel.kt |
|---|---|---|
| Splash | presentation/splash/SplashScreen.kt | SplashViewModel.kt |
| Onboarding | presentation/onboarding/OnboardingScreen.kt | OnboardingViewModel.kt |
| Home | presentation/home/HomeScreen.kt | HomeViewModel.kt |
| Condition | presentation/condition/ConditionInputScreen.kt | ConditionInputViewModel.kt |
| Meal Recommend | presentation/meal/MealRecommendationScreen.kt | MealRecommendationViewModel.kt |
| Meal Detail | presentation/mealdetail/MealDetailScreen.kt | MealDetailViewModel.kt |
| Meal Reaction | presentation/mealreaction/MealReactionScreen.kt | MealReactionViewModel.kt |
| History | presentation/history/HistoryScreen.kt | HistoryViewModel.kt |
| Exercise | presentation/exercise/ExerciseScreen.kt | ExerciseViewModel.kt |
| Report | presentation/report/ReportScreen.kt | ReportViewModel.kt |
| Settings | presentation/settings/{SettingsScreen, sub/AIDetailScreen, sub/DietDetailScreen}.kt | SettingsViewModel.kt |
| TicketShop | presentation/ticketshop/TicketShopScreen.kt | TicketShopViewModel.kt + BillingViewModel.kt |

**SoT-코드 정합 갭**: SoT `ai-disclaimer-screen` ↔ 코드 가능성 = Settings/sub/AIDetailScreen.kt 영역 추정. SoT `darkmode-screen` ↔ Settings 안 hidden? Phase 2 검증.

---

## 4. §3 비권장 5 + Dark Patterns 5 1 차 검출

### 4.1 §3.1 Cognitive Bias (희소성 / 압박 wording)

- 검색 키워드: 한정 / 곧 마감 / 마지막 / 단 X명 / 지금만 / 한정 수량 / 급함 / 희소
- 결과: **위반 0건**.
- 단일 hit (`GD strings.xml:159 "마지막 동기화"`) = "last sync" 의미 (functional · 압박 무관). PASS.

### 4.2 §3.2 Doherty 의도적 지연

- 검색 키워드: `delay(` / `Thread.sleep(` (Screen.kt + ViewModel.kt 한정)
- 결과:
  - `GB SplashScreen.kt:51` → `delay(SplashDwellMs)` (1200ms) — splash dwell. **borderline** (관용 UX 패턴 vs 인위 지연).
  - `GT SplashScreen.kt:66` → `delay(SplashDwellMillis)` — splash dwell. **borderline** 동일.
  - `GB BreathViewModel.kt:147` → `delay(phase.durationSeconds * 1000L)` — 호흡 phase 의 의도된 timing. **PASS** (functional).
  - `GB BreathViewModel.kt:158` → `delay(1000L)` (1초 timer tick) — 남은 시간 카운트. **PASS** (functional countdown).
- Phase 2 의무: splash dwell 의 정합 사유 명시 의무 (인지 가능 logo 표시 시간 vs 인위 지연).
- **2026-05-05 후속 처리** (cycle MULTI-REPO-UX-BORDERLINE-CONTEXTUAL-REVIEW-001): 마감.
  - GB SplashScreen.kt — §3.2 명백 위반 (session 외부 인자 / splash 내부 동시 작업 X) **인정** + 사유 주석 추가 (Material 권장 800~1500ms 하한 마진 명시) + 별 trail. commit `f4d6067`.
  - GT SplashScreen.kt — §3.2 부분 위반 (`dwellElapsed && destination resolved` AND-gate = §3.2 권장형 부합) + 사유 주석 추가. commit `c2dd287`.

### 4.3 §3.3 Goal-Gradient (인위적 진척)

- 검색 키워드: `LinearProgressIndicator(progress = [숫자]f` (하드코딩 진행도)
- 결과: **위반 0건**. PASS.

### 4.4 §3.4 Peak-End (부정 위장)

- 검색 키워드: 축하 / 성공! / 완료! / congratul
- 결과:
  - `GD strings.xml:43 "준비 완료!"` (onboarding_ready) — 정상 onboarding 마감 wording. **borderline** (실패 처리 영역 안 사용 시 위반).
- Phase 2 의무: onboarding_ready 사용 위치 (실패 영역 사용 여부) 검증.
- **2026-05-05 후속 처리** (cycle MULTI-REPO-UX-BORDERLINE-CONTEXTUAL-REVIEW-001): 마감.
  - GD `OnboardingScreen.kt:198~206 FinalStep` — 호출 path 검증 결과 errorRes (3종 source: error_login_required / error_samsung_failed / error_onboarding_failed) 가 not-null 시에도 "준비 완료!" 헤더 항상 노출 = **§3.4 명백 위반** 확인.
  - 정정: 신규 string `onboarding_retry` "다시 시도해 주세요" 추가 + FinalStep 안 `headerRes = if (errorRes != null) onboarding_retry else onboarding_ready` swap. commit `a0bfc85`.

### 4.5 §3.5 Parkinson 카운트다운

- 검색 키워드: CountDownTimer / 남은 시간 / 시간 제한 / countdown
- 결과:
  - `GB strings.xml:125 "남은 시간"` (breath_remaining_time) — 호흡 운동 남은 시간 (functional · 압박 무관). PASS.
- 위반 0건.

### 4.6 Dark Patterns 5 1 차 검출 (결제 / 가입 task)

| 패턴 | 1차 결과 | 증거 |
|---|---|---|
| Roach Motel (탈퇴 어려움) | **PASS (1차 anti-pattern 발견)** | GB SettingsScreen.kt:313 `settings_delete_account` · GD SettingsScreen.kt:371 `settings_account_delete` · GB strings.xml:189 `ticket_shop_footer "언제든 해지 가능"` · GB TicketShopScreen.kt:131 "Google Play 에서 해지 가능" |
| Confirmshaming (거부 wording 부정) | **PASS (1차)** | 거부 옵션 wording = 중립. GD `onboarding_later "나중에"` · GB `onboarding_skip "건너뛰기"` · GT `condition_fatigue_2 "괜찮아요"` (죄책감 wording 부재) |
| Disguised Ads | **PASS** | GT `settings_label_watch_ad "광고 보고 티켓 받기"` — 광고 명시 label (위장 X) |
| Forced Continuity (무료→유료 자동) | **borderline** | GB strings.xml:188 `ticket_shop_start_trial "무료 체험 시작"` + 189 `"언제든 해지 가능 · 7일 무료 체험"`. wording 우호 측. **Phase 2 의무**: 자동 결제 명시 disclosure (BillingManager / Google Play) 흐름 검증. |
| Hidden Costs | **PASS (1차)** | GT `priceLabel = R.string.ticket_pkg_*_price` (명시 stringRes) · GB TicketShopScreen.kt:112 `price = "4,900원"/"49,000원"` (visible). 추가 비용 숨김 흔적 부재. |

**관측**: GT TicketShopScreen.kt:10-127 영역 안 `BillingManager 에 SUBS 지원 추가 → onSubscribe(plan) 연결` 미완 TODO 가시. GB TicketShopScreen.kt:102 `price = "0원"` (free trial plan?) — 실 결제 흐름 깊이 검증 = Phase 2.

---

## 5. §5.1 N/A 영역 분류 (현 ux-laws §5.1 부재 → 본 cycle 기준)

| repo | 화면 / task | N/A 사유 |
|---|---|---|
| GB | auth-screen | Auth-only (UI 표시 외 도메인 — §5 상세 적용 N/A) |
| GD | auth-screen (deprecated) | Auth-only + lifecycle deprecated |
| GD | design-tokens-screen (removed) | lifecycle removed (audit 대상 아님) |
| GT | auth-screen | Auth-only |

기타: `darkmode-screen` (GB/GT) 및 `design-tokens-screen` (3-repo) = 신규 화면 (UI) 분류이나 메타 SoT 성격 (개발자 ref) — Phase 2 추가 N/A 후보 검토 (Cowork 측 결정).

---

## 6. PASS 영역 (1 차 검출 위반 부재)

- §3.1 Cognitive Bias: 0건
- §3.3 Goal-Gradient: 0건
- §3.5 Parkinson: 0건
- Dark · Roach Motel: anti-pattern 명시 wording 발견 (3-repo)
- Dark · Confirmshaming: 거부 옵션 중립 wording
- Dark · Disguised Ads: 광고 명시 label (GT)
- Dark · Hidden Costs: 가격 visible

---

## 7. ux-laws.md 자체 갱신 검토 영역

- **§5.1 N/A 영역 신설 필요**: **Y**. 본 cycle 안 7 영역 (Auth-only / Backend-only / Doc-only / Dependency-decision / Build-CI-Tooling / Refactor / cli infra) 사실상 적용 중. ux-laws.md §5.1 명문화 = Phase 2 사용자 결정 후 cycle 분리 또는 본 cycle 안 갱신 (Coin §8.2 답변 = 본 cycle 안 가능).
- **lifecycle deprecated/removed 화면 audit 정책 부재**: GD 의 6 화면 (deprecated 5 + removed 1) audit scope 명시 필요. 본 cycle 안 active 만 깊이 검증 정책 적용 (Phase 2 의무).
- **결제/가입 task = Dark Patterns 5 + §3 비권장 5 동시 적용 의무 명시**: 현 ux-laws §5 매트릭스 안 결제/가입 row 의 "**dark pattern 5종 STOP 검증 의무**" wording 존재. 보존 OK.

---

## 8. Phase 2 진입 권장 우선순위

1. **(a · 최우선)** 결제/가입 task — Dark Patterns 5 깊이 검증
   - GB: paywall · ticket-shop · upgrade-account · TicketShopScreen.kt · TicketPurchaseScreen.kt · TicketViewModel.kt
   - GT: ticketshop · TicketShopScreen.kt · TicketShopViewModel.kt + BillingViewModel.kt
   - Forced Continuity 흐름 (무료 체험 → 자동 결제 disclosure) + BillingManager TODO 정합
2. **(b)** Form / Onboarding — D-1 정직 진행 + B-2 Hick 점진 + G-2 인라인 도움말
   - GB: 4 onboarding 화면 + diary
   - GD: onboarding-screen + routine-item-add (deprecated 제외)
   - GT: onboarding-screen + condition-input-screen + meal-reaction-screen
3. **(c)** 일반 화면 — A/F/I 권장 법칙 깊이 검증
   - 3-repo 신규 화면 (UI) row + list/카탈로그 row + Navigation row
4. **(d · 정합 cycle 후보)** SoT-코드 정합 갭 (§3.1-3.3 의 SoT 화면명 ↔ 코드 화면명 차이) 별 cycle 분리

---

## 9. self-verification

- **paraphrase 의무**: 본 EVIDENCE 의 모든 텍스트 안 금지 어휘군 (paraphrase 대상 6 형) 0회 (자동 grep 검증 통과).
- **모름/추측 명시**: Phase 1 = 메타데이터 추출 + grep 키워드 1차 검출. 권장 법칙 (A/F/I) 깊이 검증 + Dark Patterns 흐름 검증 + ux-laws §5.1 갱신 결정 = Phase 2 의무. **borderline** 표시 영역 (splash dwell / forced continuity / peak-end wording) = 1차 단정 X · Phase 2 contextual review 의무.
- **부분 성공 명시**: 본 EVIDENCE 1차 = 본 cycle 의 1 of 2 phase. 깊이 검증 / Cowork 영역 정정 / lazy sub 1 묶음 = Phase 2 + 본 cycle 마감 STEP.
