# Release Checklist — `<RepoName>`

> **template 출처**: master `docs/templates/release-checklist.template.md`.
> **활성 조건**: 자식 repo 의 P4 deployment cycle 진입 시 cp 의무 (master P0 `MASTER-T03` 마감 baseline).
> **STOP 의무**: Play Console / App Store Connect 빌드 전 본 체크리스트 9 섹션 모두 ✓ 필수. 미충족 시 빌드 STOP + 본 row mitigation cycle (`cycle-discipline.md` §5).
> **placeholder 치환 의무 (cp 직후 7 항목)**:
> - `<RepoName>` → 자식 repo 명 (예: `GentlyBreath` / `GentlyDay` / `GentlyTable`)
> - `<domain-permissions>` → §4 의 도메인 특수 권한
> - `<apk-budget>` → §5 의 APK 크기 도메인 별 budget (예: 25 MB / 30 MB / 35 MB)
> - `<memory-budget>` → §5 의 메모리 peak 도메인 별 budget (예: 150 MB / 200 MB / 250 MB)
> - `<domain-latency>` → §5 의 도메인 별 latency budget (예: 일지 저장 ≤ 500 ms / 영양 Edge Function ≤ 1초)
> - `<domain-kpi>` → §6 의 도메인 KPI baseline (예: 호흡 완료율 / 일지 작성률 / 영양 처방 수령률)
> - `<domain-special-disclosure>` → §1 의 도메인 특수 disclosure (예: 광고 X / 정부 ID X / health data 처리 / 사진 업로드 / AI 처방 + 의료 X 책임 한계)

---

## 1. Play Console (Android · 공통 8 항목 + 도메인 disclosure)

| # | 항목 | 상태 | 비고 |
|---|---|---|---|
| 1 | 앱 이름 ko + en | ☐ | 30 자 이하 |
| 2 | 짧은 설명 ko + en | ☐ | 80 자 이하 |
| 3 | 자세한 설명 ko + en | ☐ | 4000 자 이하 |
| 4 | 스크린샷 5~8 (phone + tablet) | ☐ | <예: 호흡 / 명상 · 일상 / health · 사진 / 영양 / 처방> |
| 5 | Feature graphic (1024 × 500) | ☐ | — |
| 6 | IARC 등급 신청 | ☐ | 설문 응답 + 등급 확정 |
| 7 | 데이터 안전 폼 | ☐ | 수집 / 공유 / 보안 모두 명시 |
| 8 | 가격대 / 가용 지역 / 카테고리 / 베타 closed track | ☐ | <예: 무료 + IAP 한입 티켓 · KR + JP + US> |
| 9 | 비공개 테스트: 12명 × 14일 연속 opt-in (신규 개인 계정 · 2023-11-13+) | ☐ | production 신청 前 필수 · 앱별 각각 · 중단 시 카운터 리셋 · answer/14151465 |
| 10 | Google Payments 판매자 프로필 수립 + 개발자 계정 연결 | ☐ | 유료 IAP(티켓 SKU) 판매 前 전제 · 세금/판매자 정보 · answer/3092739 |

**도메인 특수 disclosure**: `<domain-special-disclosure>`
<예: 광고 X · 정부 ID 미수집 (GentlyBreath) / health data 처리 (GentlyDay) / 사진 업로드 + AI 처방 + 의료 X 책임 한계 (GentlyTable)>

---

## 2. App Store Connect (iOS · Phase 2 lazy · 활성화 trigger 시)

> 본 §2 = iOS 빌드 진입 cycle 의 별 trail (현 시점 Android 우선). iOS 진입 시 본 row 활성화 + 도메인별 갱신 의무.

| # | 항목 | 상태 | 비고 |
|---|---|---|---|
| 1 | App Name (en + ko) | ☐ | 30 자 이하 |
| 2 | Subtitle (en + ko) | ☐ | 30 자 이하 |
| 3 | Description (en + ko) | ☐ | 4000 자 이하 |
| 4 | 스크린샷 (6.7" + 6.5" + 5.5" iPhone + iPad) | ☐ | 사이즈 별 의무 |
| 5 | App Privacy 폼 (iOS 14.5+) | ☐ | Data Types + Usage 명시 |
| 6 | App Review Information (test account + notes) | ☐ | email-first 가입 (이메일 OTP · `auth-rules.md` §1b) 패러다임 명시 — ⚠ **supersede: 구 문면 「익명 부트스트랩 패러다임 명시」 = 활성 default 아님** (2026-08-05 `MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001` · 구 §1 = 동결 3(GB/GD/GT) 계보 한정 · 구 서술 = 이력 보존 · SELFWARD-PRELAUNCH-SWEEP-002) |
| 7 | 가격 / 가용 지역 / 카테고리 | ☐ | Play Console 정합 |
| 8 | TestFlight 베타 | ☐ | external + internal 트랙 |

---

## 3. 컴플라이언스 (공통 5 항목 · 의무)

| # | 항목 | 상태 | 비고 |
|---|---|---|---|
| 1 | Privacy Policy URL 공개 + 호스팅 검증 | ☐ | §9 의 호스팅 URL 정합 |
| 2 | Terms of Service URL 공개 + 호스팅 검증 | ☐ | §9 의 호스팅 URL 정합 |
| 3 | GDPR (휴대권 + 삭제권) flow | ☐ | EU 사용자 데이터 export / 삭제 UI |
| 4 | KISA 개인정보 처리방침 (KR 의무) | ☐ | 항목 별 수집 목적 + 보유 기간 |
| 5 | 데이터 안전 폼 정합 (Play Console + iOS Privacy 동일) | ☐ | 양 플랫폼 일치 의무 |

---

## 4. 권한 (POST_NOTIFICATIONS 공통 + 도메인 placeholder)

| # | 항목 | 상태 | 비고 |
|---|---|---|---|
| 1 | POST_NOTIFICATIONS 권한 + 거부 flow + UX | ☐ | Android 13+ 의무 |
| 2 | `<domain-permissions>` | ☐ | <예: USE_EXACT_ALARM + WAKE_LOCK + VIBRATE (GB) / Health Connect + ACTIVITY_RECOGNITION (GD) / CAMERA + READ_MEDIA_IMAGES (GT)> |
| 3 | 권한 거부 시 graceful degradation | ☐ | 핵심 flow X + 부가 기능 안내 |
| 4 | 권한 사유 (rationale) 다국어 | ☐ | strings.xml ko + en |

---

## 5. 성능 budget (도메인 placeholder + cold start universal)

| # | 항목 | 목표 | 측정 |
|---|---|---|---|
| 1 | APK 크기 | `<apk-budget>` | <예: 25 MB (GB) / 30 MB (GD) / 35 MB (GT)> · `./gradlew :app:bundleRelease` 후 측정 |
| 2 | cold start | ≤ 1500 ms | universal · `adb shell am start -W` 측정 |
| 3 | 메모리 peak | `<memory-budget>` | <예: 150 MB (GB) / 200 MB (GD) / 250 MB (GT)> · Android Studio Profiler |
| 4 | `<domain-latency>` | (도메인별) | <예: 배터리 ≤ 0.5% (GB) / 일지 저장 ≤ 500 ms (GD) / 사진 업로드 1MB ≤ 3초 + 영양 Edge Function ≤ 1초 (GT)> |

---

## 6. KPI baseline (출시 후 8 주 평가)

| # | KPI | baseline | 측정 도구 |
|---|---|---|---|
| 1 | D7 retention | <예: ≥ 25%> | Firebase Analytics |
| 2 | paid conversion | <예: ≥ 2%> | Play Console + Edge Function 검증 |
| 3 | `<domain-kpi>` | (도메인별) | <예: 호흡 완료율 ≥ 60% (GB) / 일지 작성률 ≥ 40% (GD) / 영양 처방 수령률 ≥ 30% (GT)> |
| 4 | 크래시 free rate | ≥ 99.5% | Firebase Crashlytics |

---

## 7. kill-switch 게이트 (출시 후 8 주 평가)

| # | 평가 항목 | trigger | 조치 |
|---|---|---|---|
| 1 | D7 retention < 15% | KPI miss | 기능 우선순위 재평가 + 다음 cycle 진입 |
| 2 | 크래시 free < 99% | 안정성 miss | hotfix cycle 즉시 진입 |
| 3 | paid conversion < 1% | 수익 miss | Mock-first paradigm 재검증 + UX flow 재평가 |
| 4 | 8 주 평가 PASS | 모두 baseline 충족 | Phase 2 (OAuth / RevenueCat / 도메인 확장) 진입 |

---

## 8. ASO (App Store Optimization)

| # | 항목 | 상태 | 비고 |
|---|---|---|---|
| 1 | 키워드 (ko + en) 30 자 | ☐ | Play Console + iOS App Store Connect 각각 |
| 2 | 카피 (앱 이름 + 짧은 설명 + 자세한 설명) | ☐ | A/B 후보 ≥ 2 |
| 3 | 스크린샷 카피 / overlay (5~8) | ☐ | 핵심 가치 1줄 + 화면 캡쳐 |
| 4 | Feature graphic + promo video (선택) | ☐ | promo video = lazy |

---

## 9. Privacy 호스팅

| # | 항목 | 상태 | 비고 |
|---|---|---|---|
| 1 | Privacy Policy URL | ☐ | <예: https://example.com/<RepoName>/privacy> · HTTPS only |
| 2 | Terms of Service URL | ☐ | <예: https://example.com/<RepoName>/terms> · HTTPS only |
| 3 | 호스팅 platform (정적 / Notion / 자체) | ☐ | <예: GitHub Pages / Notion / Supabase Storage> |
| 4 | 다국어 (ko + en) 모두 호스팅 | ☐ | URL path 별 `/ko/privacy` · `/en/privacy` 의무 |
| 5 | Play Console + iOS App Store Connect 의 Privacy URL 정합 | ☐ | 양 플랫폼 동일 URL 의무 |

---

## 본 template 의 변경 정책

- master `docs/templates/release-checklist.template.md` = 단일 SoT.
- 자식 repo 의 P4 deployment cycle 진입 시 cp 후 도메인 placeholder 7 항목 치환 + 실측 갱신 의무.
- 본 template 변경 = master cycle 신설 + 자식 P4 진입 시 cp 발화 (lazy propagation · 자식 P4 cycle 의무).
- 9 섹션 row 추가 / 삭제 시 master cycle 신설 의무 (자식 cp 정합 영향).
