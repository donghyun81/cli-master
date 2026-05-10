# 공통 앱 구현 SSOT (DRAFT) — `app-foundation` 신설 시 cp 대상

> **현재 상태**: `app-foundation` repo 미신설 = 본 file 은 master 안 임시 보관.
> **MASTER-T01 진입 시**: 본 file → `app-foundation/docs/release-readiness/COMMON-SETUP-SSOT.md` 로 cp + foundation 측 영구 SoT.
> **단일 목적**: Gently 무관 모든 앱이 공유할 **앱 구현 코드 SoT**.
> **cli 운영 SoT 와 분리**: cli infra = `claude-cli-master`. 본 SSOT = 코드/scaffold/외부 의존.

---

## 1. 책임 범위

| 영역 | foundation 보유 | 자식 repo 보유 |
|---|---|---|
| KMP/CMP scaffold (`shared/`, `composeApp/`, `iosApp/`) | ✓ template | cp 후 도메인 코드 추가 |
| `gradle/libs.versions.toml` 공통 의존 | ✓ SoT | propagation cp |
| Koin DI baseline 모듈 (`core/di/`) | ✓ template | 도메인 module 만 추가 |
| Supabase 클라이언트 wrapper + auth + RLS + EdgeFn | ✓ | 도메인 schema · table 만 추가 |
| Play Billing v6 + StoreKit 2 wrapper + 영수증 검증 | ✓ | SKU 만 정의 |
| Crashlytics + Sentry + custom event template | ✓ | 도메인 event 만 추가 |
| Feature flag client (Supabase 또는 GrowthBook) | ✓ | flag key 만 추가 |
| Analytics (GA4 또는 Amplitude) wrapper | ✓ | funnel 만 추가 |
| Compose UI core (theme / typography / spacing / 공통 컴포넌트) | ✓ | 도메인 화면만 추가 |
| Material3 + dark mode + a11y baseline | ✓ | 도메인 색만 override |
| Notification scheduler wrapper (AlarmManager + WorkManager + UNUserNotificationCenter) | ✓ | 알림 도메인만 추가 |
| In-app review 호출 wrapper | ✓ | 호출 시점만 |
| 도메인 코드 (호흡 / 일상 / 식단) | ✗ | ✓ 자식 repo |

---

## 2. P0 task (출시 전 필수 · foundation 신설 진행)

**critical path**: `FND-T01 → T02 → T03 → T04 → T05 → T08 → T11` (T06/T07/T09/T10/T12 병렬 가능)

| ID | 항목 | P | 상태 | 의존 | 마감 sha · 본심 |
|---|---|---|---|---|---|
| FND-T01 | repo 신설 + module 구조 (`shared/{domain,data,feature-state}/` + `composeApp/` + `iosApp/` + `core/{di,supabase,billing,observability,analytics,feature-flag,notification}/`) | P0 | ☐ | MASTER-T01 | (왜) 모든 자식 의존 baseline · (예) 다음 앱 (FocusBites 등) 도 fork 가능 |
| FND-T02 | `gradle/libs.versions.toml` SSOT — Kotlin 2.0.21 / Compose BoM 2024.09 / Koin 4 / Ktor / Supabase Kotlin 2.x / Play Billing 6 / Crashlytics 18 / Sentry 7 / kotlinx-serialization | P0 | ☐ | T01 | (왜) 자식 의존 일관 · (예) GB/GD/GT bom 다르면 dependency hell |
| FND-T03 | Supabase wrapper (`core/supabase/`) — SupabaseClient + Auth + RLS helper + EdgeFn client + storage | P0 | ☐ | T02 | (왜) GB/GD 기존 + GT 신설 모두 wrapper 통일 · (예) RLS deny → DomainError 자동 변환 |
| FND-T04 | billing wrapper (`core/billing/`) — Android (Play Billing v6) + iOS (StoreKit 2) 통합 인터페이스 + 영수증 server 검증 (Edge Fn) + 환불 처리 | P0 | ☐ | T02, T03 | (왜) 자식 SKU 만 등록하면 됨 · (예) `gentlybreath_pro_monthly` 추가만 |
| FND-T05 | observability (`core/observability/`) — Crashlytics + Sentry + structured Logger + 사용자 식별 + breadcrumb | P0 | ☐ | T02 | (왜) crash-free KPI 측정 의존 · (예) ANR + native crash + custom error 동시 추적 |
| FND-T06 | analytics wrapper (`core/analytics/`) — GA4 또는 Amplitude (택 1 결정 영역) + funnel + cohort + custom event | P0 | ☐ | T02 | (왜) D7 / 완료율 KPI 의존 · (예) `session_started`/`completed` 자동 |
| FND-T07 | feature flag wrapper (`core/feature-flag/`) — Supabase ff 또는 GrowthBook | P0 | ☐ | T02 | (왜) 출시 후 점진 rollout / kill-switch · (예) `breath_haptic_enabled` flag |
| FND-T08 | Compose UI core (`composeApp/ui/`) — theme + typography + spacing + Material3 + dark mode + a11y baseline + 공통 컴포넌트 (Button / Card / TopBar / BottomBar / Dialog / Snackbar) | P0 | ☐ | T01 | (왜) 자식 도메인 화면 통일 · (예) GD home 카드 = `BaseCard` 재사용 |
| FND-T09 | DI baseline (`core/di/`) — Koin module skeleton (appModule + coreModule + featureModule 표준) | P0 | ☐ | T02 | (왜) 자식 module 추가 표준 · (예) ViewModel 자동 inject |
| FND-T10 | Notification scheduler (`core/notification/`) — Android (AlarmManager + WorkManager + Notification API 33+) + iOS (UNUserNotificationCenter) | P0 | ☐ | T01 | (왜) GB 호흡 reminder · GD 일지 reminder · GT 식사 reminder 공통 · (예) `scheduleDaily(hour, minute)` |
| FND-T11 | network layer (`core/network/`) — Ktor client + interceptor + retry + offline cache | P1 | ☐ | T02 | (왜) Supabase 외 외부 API 호출 일반화 · (예) GT 영양 DB 공공 API |
| FND-T12 | `docs/how-to-fork.md` + `docs/propagation.md` + 자식 fork 자동화 script | P1 | ☐ | T01~T10 | (왜) 자식 신설 절차 SoT · (예) 30 분 안 새 앱 baseline 확보 |

---

## 3. 외부 의존 baseline (`gradle/libs.versions.toml`)

| 영역 | 라이브러리 | 버전 | 현 GB/GD/GT 상태 |
|---|---|---|---|
| Kotlin | `kotlin` | 2.0.21 | ✓ 일치 |
| Compose | `composeBom` | 2024.09.00 | ✓ 일치 |
| Koin | `koin` | 4.0.0 | GB/GT ✓ · GD 미등록 |
| Ktor | `ktor` | (최신 stable) | ✓ 일치 |
| Supabase Kotlin | `io.github.jan-tennert.supabase` | 2.x | GB/GD ✓ · GT 미적용 |
| Play Billing | `com.android.billingclient:billing-ktx` | 6.x | 3-repo 모두 미적용 |
| Crashlytics | `com.google.firebase:firebase-crashlytics-ktx` | 18.x | 3-repo 모두 미적용 |
| Sentry | `io.sentry:sentry-android` | 7.x | 3-repo 모두 미적용 |
| GA4 / Amplitude | (택 1) | — | 3-repo 모두 미적용 |
| Feature flag | (Supabase ff 또는 GrowthBook) | — | 3-repo 모두 미적용 |
| WorkManager | `androidx.work:work-runtime-ktx` | 2.9.x | 미확인 |
| Coil | `io.coil-kt:coil-compose` | 2.x | GT 사진 의존 |

---

## 4. propagation 절차 (자식 앱 신설 / 갱신 시)

```
[신설]
1. foundation 의 latest tag 결정 (예: v0.1.0)
2. 자식 repo 신설 (예: GentlyXxx 또는 FocusBites) 또는 fork
3. shared/ + core/ + composeApp/ + iosApp/ + gradle/libs.versions.toml = cp (또는 submodule)
4. supabase/migrations/ = baseline 위에 도메인 schema append
5. 자식 repo CLAUDE.md 측 reading order 에 본 SSOT 인용 추가

[갱신 propagation]
1. foundation 측 변경 commit
2. propagate-foundation.sh 실행 (자식 4-repo 동시)
3. 자식 측 conflict 발생 시 별 cycle (cp 불가 = customization 발견)
4. verify-foundation-sync.sh 로 byte-identical 검증
```

---

## 5. kill-switch 게이트

| 게이트 | 트리거 | 행동 |
|---|---|---|
| FND-T01 (repo 신설) ⚠ 14 일 | 신설 cycle 미진입 | scope 재검토 — master `docs/templates/` 확장 회귀 검토 |
| 자식 fork 시 conflict ≥ 3 회 | propagation cycle conflict | 책임 경계 재정의 cycle |
| 의존 메이저 bump 후 자식 회귀 | CI red ≥ 7 일 | rollback + 의존 도입 보류 |

---

## 6. 갱신 trigger

| trigger | 행동 |
|---|---|
| 자식 cycle REVIEW PASS (foundation 의존 task) | 본 §2 의존 task 영향도 검증 |
| 의존 메이저 bump | §3 표 + 자식 propagation cycle |
| 자식 customization 누적 (3-repo 중 2 이상 동일 패턴) | 본 SSOT 흡수 검토 cycle |

---

## 7. 한계 / 모름

- propagation 메커니즘 (cp / submodule / Maven publish) = T01 진입 시 결정.
- iOS 빌드 활성화 시점 = 자식 도메인 수요와 함께 결정.
- GA4 vs Amplitude / Supabase ff vs GrowthBook = 별 결정 cycle.
- 본 file 의 영구 위치 = MASTER-T01 마감 시 `app-foundation/docs/release-readiness/COMMON-SETUP-SSOT.md` 로 이동.
