---
정리위치: archive/
정리trigger: 본 task REVIEW.md PASS 또는 mtime 7일 경과
정리주체: cowork 자율 (또는 사용자 직접)
---

# EVIDENCE — MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001

## Requirements Source

- 사용자 원문 (chat 진입 prompt) · cycle ID `MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001`
- 검사 기준: `.claude/rules/ux-laws.md` (sha 0f63f399…) §1 권장 22 + §3 비권장 5 + Dark Patterns 5 + §5 매트릭스 + §5.1 N/A 7
- baseline: parent EVIDENCE `MULTI-REPO-UIUX-AUDIT-AGAINST-UX-LAWS-001` (sha 76e43e68…) + chat A R3-HANDOFF + chat D TODO 2

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | runtime audit (read-only) — 운영 레이어 task |
| Reading Mode | UI/UX형 + cli 운영 레이어형 |
| Requirement Source | chat 진입 prompt + ux-laws.md SoT |
| Info Gap | RESOLVABLE_IN_REPO (대부분) · GD 메인 분기 = BLOCKED (Anon auth 초기화 실패) |
| STOP Risk | 결제 영역 = 진입 직전 정지 의무 (GT 한입 티켓 / GB 휴식 티켓) |
| Read-Only Fan-Out | ux-auditor (단독) — 본 cycle 의무 |
| Implementer Entry | Blocked (read-only audit) |

## Pre-EVIDENCE Contract

- Read evidence: ux-laws.md / sot-code-name-map.md / 3-repo Navigation 진입 파일 (AppNavigation·GentlyDayNavGraph·RootNavGraph·MainScaffold)
- Remaining gaps: GD main 분기 5 화면 (Sleep/Habits/Reports/Settings/Ticket) = anon auth 실패로 진입 불가 · 본 cycle 한정 BLOCKED
- Chosen path: 진입 가능한 28+ 화면 모두 light + dark capture · §5 매트릭스 row 적용 · §3 비권장 5 + Dark Patterns 5 detection
- Hold / Stop reasons: 결제 다이얼로그 진입 직전 정지 · 자식 repo 코드 변경 X
- Implement entry conditions: N/A (audit-only)

## Collect Results

### 환경 baseline

| 항목 | 값 |
|---|---|
| 진입 emulator | emulator-5554 = AVD `Pixel_9_Pro` (사용자 의도 `Medium_Phone_API_36.1` 명시 + "신규 boot X" → 현 emulator 그대로) |
| Locale | en-US (root denied — `setprop` 시 "su not found"로 ko-KR 적용 실패 · UI 문구 자체는 한국어 strings.xml 사용 → 검증 영향 X) |
| Theme | light + dark 모두 capture (Settings 내 토글) |
| 패키지 | `com.example.gentlybreath` / `com.example.gentlyday` / `com.example.gentlytable` |
| APK build exit | 3 repo 모두 0 (parallel build) |
| APK install exit | 3 repo 모두 0 |
| Cold launch (TotalTime) | GB 714ms · GD 669ms · GT 916ms (모두 splash dwell 의도 — < 400ms 즉시 응답 영역 X) |

### Capture 산출 (총 46)

| repo | 화면 (state) | 수 |
|---|---|---|
| GentlyBreath | splash · onboarding 5 step · profile_setup · home L+D · breath L+D · journal L+D · reports L+D · settings L+D · ticket_purchase · notification_detail | 19 |
| GentlyDay | splash · onboarding 5 step · home (잠깐) · auth (실패 화면) | 10 |
| GentlyTable | splash · onboarding 4 step · home L+D · history L+D · meal_recommendation L+D · reports L+D · settings L+D · settings_scrolled · ticket_shop (= settings 동) | 17 |

저장 경로: `screenshots/Gently{Breath,Day,Table}/<NN>_<screen>_<theme>.png` + `ui-dumps/Gently{Breath,Day,Table}/<NN>_<screen>_<theme>.xml`.

### 핵심 텍스트 인용 (uiautomator dump grep 결과)

#### GentlyBreath
- `04_onboarding_step4_light.xml`: "나만의 마음 여정을 시작하세요 / 지금 시작하면 첫 5회 무료 / 시작하기"
- `05_onboarding_step5_light.xml`: "프로필 설정 / 이름 / 감정 선호도 (최대 3개) / 평온·집중·수면·스트레스·불안 / 알림 허용 / 완료"
- `07_main_home_light.xml`: BottomNav 4 tab (홈·호흡·일기·리포트) · "지금의 감정은? · 평온·집중·우울·불안·분노·중립·행복" (7 청크 ≤ 7) · "오늘의 호흡 / 박스 호흡 / 4초 들이·4초 멈춤·4초 내쉬·4초 멈춤"
- `08_breath_light.xml`: 5 program (4-4-4-4 균형 호흡 · 4-7-8 호흡 · 박스 호흡 · 복식 호흡 · 에너지 호흡)
- `11_settings_light.xml`: "현재 플랜: 무료 / 휴식 티켓 관리 / 필요할 때 휴식 티켓 충전 / 호흡 리마인더 / 알림 상세 / 라이트/다크 모드: 시스템 기본 / 데이터 내보내기·가져오기·계정 삭제"
- `12_ticket_purchase_light.xml` = `11_settings_light.xml` 와 동일 (감지: row "휴식 티켓 관리" `clickable=false` → 진입 실패. 화면 자체가 settings 그대로 잔존)

#### GentlyDay
- `03_onboarding_step3b_light.xml`: "단계 3/5 · Samsung Health 권한 허용 · 갤럭시 워치로 수면을 자동 추적하세요 / Samsung Health 앱과 연동하면 자동으로 수면 데이터가 수집됩니다 / 나중에" (정직한 진행 · 거부 옵션 중립 wording)
- `09_auth_light.xml`: "단계 5/5 · 로그인이 필요합니다 · 다시 시도해 주세요 · 홈으로 이동" → 익명 부트스트랩 실패 → main BLOCKED

#### GentlyTable
- `06_onboarding_step4_light.xml`: "4 / 4 · 알림을 받으시겠어요 / 하루 한 번, 원하는 시간에 알려드릴게요 / AI가 생성한 영양 정보이며, 실제 값과 다를 수 있습니다 / 이전 / 완료"
- `07_main_home_light.xml`: BottomNav 5 tab (홈·추천·기록·리포트·설정) · "오늘의 추천 / 5단계 · 맞춤 식단/운동 추천 / 오늘 컨디션 입력하기 · 약 30초"
- `09_meal_recommendation_light.xml`: 3 식단 (오트밀+바나나+견과류 / 현미밥·닭가슴살·채소 샐러드 / 두부 스테이크·구운 야채) · "⚠️ AI가 생성한 영양 정보입니다 · 식품 데이터베이스는 AI 보정을 거치며…"
- `11b_settings_scrolled_light.xml`: "한입 티켓 / 보유: 0한입 / 한입 티켓 충전 / 결제 서비스 연결 실패 / 데이터 · 정보 / 내 데이터 내보내기 / 백업에서 데이터 가져오기 / 개인정보 처리방침 / 버전 정보 v1.0.2"
- `12_ticket_shop_light.xml` = `11b_settings_scrolled_light.xml` 동 (TICKET_SHOP 진입 path: row `clickable=false` → 진입 실패. 결제 서비스 init 실패 disabled state)

## Key Findings (13건)

| ID | repo | 위치 | 분류 | 판정 |
|---|---|---|---|---|
| F1 | GB | splash | Doherty `splash dwell` | 의도 — 외부 init wait. <400ms 영역 X. INFERRED PASS |
| F2 | GB | onboarding step4 "지금 시작하면 첫 5회 무료" | Cognitive Bias §3.1 (Loss-Aversion 후보) | borderline — incentive framing · 카운트다운 X · 거부 wording 중립 X. ACCEPTABLE (dark pattern X) |
| F3 | GB | settings row "휴식 티켓 관리" `clickable=false` | Jakob's Law §B-3 + Fitts §C-2 (affordance) | FAIL (regression risk) — TICKET_PURCHASE entry path 단절 |
| F4 | GB | BottomNav 4 tab + emotion 7 청크 | Choice Overload §B-1 + Working Memory §A-2 | PASS (≤ 7) |
| F5 | GD | splash 669ms | Doherty `splash dwell` | F1 동 |
| F6 | GD | onboard step3 "Samsung Health 권한 허용 · 나중에" | Confirmshaming dark pattern 검증 | PASS — 거부 옵션 중립 ("나중에"). Confirmshaming X |
| F7 | GD | step5 "로그인이 필요합니다 · 다시 시도해 주세요" | Peak-End §G-3 (negative end moment) | borderline — 정직한 error UX (위장 X · §3.4 PASS) · 그러나 진입 차단 자체가 entry path break |
| F8 | GD | main 분기 (Sleep·Habits·Reports·Settings·Ticket) BLOCKED | F7 동 cascade | UNKNOWN (audit 진입 불가) |
| F9 | GT | splash 916ms | Doherty `splash dwell` | F1 동 |
| F10 | GT | onboard step4 + meal_recommendation AI disclaimer | Postel §I-2 + 투명성 (FTC 정합) | PASS — AI 생성 정보 명시 |
| F11 | GT | BottomNav 5 tab (홈·추천·기록·리포트·설정) | Choice Overload §B-1 + Mental Model §B-3 (Material BottomNav 표준) | PASS (≤ 5) |
| F12 | GT | settings row "한입 티켓 충전" `clickable=false` + "결제 서비스 연결 실패" | Hidden Costs dark pattern 검증 + Jakob's affordance | Hidden Costs PASS (정직한 disclosure) · 그러나 affordance FAIL (entry path 단절 — F3 동 패턴) |
| F13 | GT | meal_recommendation 3 식단 ≤ 7 | Choice Overload §B-1 + Chunking §A-4 | PASS |

## §3 비권장 5 + Dark Patterns 5 detection 종합

| 항목 | 검출 | 위치 |
|---|---|---|
| §3.1 Cognitive Bias 활용 | 1 borderline | GB step4 "첫 5회 무료" (incentive — manipulation X) |
| §3.2 Doherty 의도적 지연 | 0 | splash dwell = init wait (위장 X) |
| §3.3 Goal-Gradient 인위적 진척 | 0 | GD `단계 N/5` = 정직한 진행 |
| §3.4 Peak-End 부정 위장 | 0 | GD auth 실패 = 정직한 error UX |
| §3.5 Parkinson 카운트다운 | 0 | 시간 압박 표시 없음 |
| Dark — Roach Motel | 0 | 데이터 내보내기·계정 삭제 명시 (GB settings) · 탈퇴 가입과 동일 path inferred |
| Dark — Confirmshaming | 0 | "나중에" 중립 (F6) |
| Dark — Disguised Ads | 0 | 광고 영역 미발견 |
| Dark — Forced Continuity | 0 | 무료 trial → 자동 결제 wording 미발견 (모두 무료 plan) |
| Dark — Hidden Costs | 0 | "결제 서비스 연결 실패" 정직 disclosure (F12) |

종합: 비권장 위반 0건 · borderline 1건 (F2 ACCEPTABLE).

## SoT ↔ Runtime Cross-Verify (STEP D · `sot-code-name-map.md` 인용)

| repo | SoT 화면 | Runtime 진입 | 카테고리 | 결과 |
|---|---|---|---|---|
| GB | splash-landing → SplashScreen | `02_after_splash` | 1:1 명명 차이 | MATCH |
| GB | onboarding 4 SoT → OnboardingScreen | `03~05_onboarding_step1~5` | N:1 통합 | MATCH (5 step 코드 통합 — SoT 4 frame N:1 정합) |
| GB | home/breathing/diary/report/settings/ticket-shop | 7~12 화면 | 1:1 (직매핑/명명) | MATCH (5/5 SoT 매핑 화면 진입 검증) |
| GB | TicketPurchaseScreen | `12_ticket_purchase` row clickable=false → entry FAIL | 코드 only (TODO 후보) | DRIFT (F3) |
| GB | paywall-screen | chat A R3-HANDOFF TODO | TODO 인용 | 본 cycle 검증 X |
| GD | splash · onboarding · home | `02·03~07·08` | 1:1 | MATCH (진입 도달분 한정) |
| GD | sleep/habits(=Routine)/reports/settings | BLOCKED (F8) | N:1 통합 + 1:1 | UNKNOWN (audit 진입 불가) |
| GD | TicketScreen | chat A TODO | TODO 인용 | 본 cycle 검증 X |
| GT | splash · onboarding · home · meal_recommendation · history · reports · settings · ticket-shop · ai-disclaimer | `02~12` | 1:1 (대부분) | MATCH |
| GT | TicketShopScreen | `12_ticket_shop` row clickable=false → entry FAIL | 1:1 직매핑 | DRIFT (F12 — payment service init 실패 cascade) |
| GT | DietDetailScreen (코드 only) | settings 진입 후보 — 본 cycle 미진입 | 코드 only | 본 cycle 검증 X |

종합: 진입 가능한 모든 화면에서 SoT-runtime mapping MATCH. F3 / F12 = `clickable=false` affordance 단절 (drift 정정 후보 — 별 cycle).

## Cleanup Assessment

N/A (ops-layer task — 본 cycle 은 read-only audit · 자식 repo 코드 변경 X · cli infra 변경 X)
