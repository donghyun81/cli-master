# 실테스트 Backfill Audit — 고위험 빈 곳 지도 + ROI 로드맵

> **수기 측정 산출물 · 자동 갱신 아님.** 측정 시점 = 2026-06-03 KST · 측정 cycle = `MASTER-CLI-TESTING-BACKFILL-AUDIT-001` (Mode M5 cli-infra-ops · read-only).
> **HEAD baseline** (측정 당시): master `e4db3ce` / app-foundation `5bc9d73` / GentlyBreath `32348bf` / GentlyDay `2b84f68` / GentlyTable `d93c69e`.
> **성격**: 4 repo(FND/GB/GD/GT)의 실테스트 현황을 disk 실측해 고위험(Auth/Billing/Data/Backend) 빈 곳을 지도화하고, ROI 순 backfill 로드맵을 외화한 점-측정(point-in-time) 문서. 실 테스트 작성은 본 문서가 입력이 되는 후속 cycle ×N 의 몫이다(여기서는 코드 0).
> **위치 근거**: master-only(자식 propagation 없음). `docs/agent/architecture/`는 5-repo byte-identical 영역이라 점-측정 audit 을 두면 자식 drift 로 오인된다 → 자식 부재 디렉터리 `docs/agent/audits/`에 격리(PACKAGE-OVERVIEW 가 `docs/release-readiness/`에 격리된 선례와 같은 결).
> **재측정 방법**: 본 문서 §1 의 measurement recipe 를 다시 실행. HEAD 가 전진했으면 배너 + 표를 갱신(하이브리드 refresh).
> **SoT 정합**: 우선순위 기준 = [`../architecture/TESTING_STRATEGY.md`](../architecture/TESTING_STRATEGY.md) §5(ROI) · §11(per-layer 케이스). 커버리지 = 신호이지 게이트가 아니다(같은 문서 §9).

---

## 1. 측정 범위 + 방법 (measurement recipe)

부모 mount root(`~/AndroidStudioProjects`)에서 4 repo 를 한 번에 훑었다. 모든 수치는 `build/` 제외 disk 실측이며, test source-set 판정은 경로의 `/src/<name>Test` / `/src/test` / `UnitTest` / `InstrumentedTest` 패턴으로 한다.

```bash
# (1) repo 별 prod.kt / testSrc.kt / *Test.kt
find <repo> -name '*.kt' -path '*/src/*' -not -path '*/build/*' | grep -iE '/src/[^/]*([Tt]est)'   # test source
find <repo> -name '*.kt' -path '*/src/*' -not -path '*/build/*' | grep -ivE '/src/[^/]*([Tt]est)'  # production
# (2) Repository impl ↔ <Name>Test.kt 매칭 (Data 빈 곳)
# (3) Edge Function 전수 = supabase/functions/<name>/index.ts · EF test = *.test.ts (0)
# (4) verify-purchase Bearer 도출 = grep 'GOOGLE_PLAY_BILLING_KEY|Bearer' index.ts
```

판정 어휘: ✓ = 대응 테스트 존재 · ✗ = 무테스트 · △ = 부분(헬퍼/스냅샷만 또는 일부 경로).

---

## 2. Baseline 재측정 (cowork 박제 cross-check)

진입 시 인용된 박제 counts 를 재측정했고, **전 항목이 정확히 일치**했다(STOP #4 비발동).

| repo | production .kt | test-source .kt | `*Test.kt` | 차이(= Fake/Recording 보조) |
|---|---|---|---|---|
| app-foundation (FND) | 44 | 19 | 13 | 6 |
| GentlyBreath (GB) | 61 | 9 | 8 | 1 |
| GentlyDay (GD) | 70 | 12 | 8 | 4 |
| GentlyTable (GT) | 69 | 14 | 10 | 4 |

`*Test.kt` 와 test-source 전체의 차이는 `FakeXxx`/`RecordingXxx` 주입 헬퍼다(`TESTABILITY_SEAMS` 패턴). 즉 실 단언 파일은 표의 `*Test.kt` 열이 정확한 신호다.

---

## 3. repo × 계층 빈 곳 지도

### 3.1 종합 매트릭스

| 계층 | FND | GB | GD | GT |
|---|---|---|---|---|
| **Auth** | core/auth 3p/5t ✓ | Splash bootstrap ✓ | Splash ✓ | Splash ✓ |
| **Billing/Money** | core/billing **빈 모듈(0p)** | EF 3종(TS) **0 test** ⚠ | — | — |
| **Backend/EF** | — | EF 7 **0 test** | EF 3 **0 test** | EF 3 **0 test** |
| **Data — Supabase repo** | core/supabase 12p/7t ✓ | 2/2 ✓ | 2/2 ✓ | presc+hist ✓ / meal+nutr ✗ |
| **Data — Room/local** | (security token ✓) | Room 5파일·RoomMeditationRepo ✗ | Room 3파일·**Room repo 4 전부 ✗** | (Room 없음) |
| **UseCase** | — | 2 **0 test** | 2 **0 test** | 3 **0 test** |
| **Mapper/Dto** | rls mapper ✓ | 0 | 1 **0 test** | 4 **0 test** |
| **ViewModel(StateFlow)** | — | 5/8 △ | 6/9 △ | 6/8 △ |
| **Screen** | — | 0/9 | 0/11 | 1/9 |
| **도메인 정책/상태기계** | — | — | — | InsightRuleEngine ✓ |

### 3.2 FND core/shared 모듈 분해

| 모듈 | prod | test | 판정 |
|---|---|---|---|
| core/auth | 3 | 5 | ✓ 양호 (AuthError + FakeAuthRepository + FakeUserIdentityProvider 단언) |
| core/supabase | 12 | 7 | ✓ 양호 (RLS 매퍼 ×3 + EdgeFunctionInvoker + Postgrest fake) |
| core/security | 7 | 2 | △ SecureTokenStore fake/test (토큰 저장 = Auth 인접) |
| core/observability | 9 | 2 | △ |
| core/designsystem | 12 | 2 | △ (SpacingToken + GentlyButton 스냅샷) |
| core/di | 1 | 1 | ✓ FoundationKoinTest |
| core/billing | 0 | 0 | **빈 모듈** — Kotlin Money 표면 자체가 없음 |
| core/{analytics, build, feature-flag, network, notification} | 0 | 0 | placeholder(미구현) — 테스트 대상 아님 |
| shared/{domain, data, feature-state} | 0 | 0 | **foundation 측 빈 모듈** — 도메인 로직이 각 자식 composeApp 에 거주(아래 §4.5) |

---

## 4. 고위험 도메인 상세

### 4.1 Money/Billing — 최대 폭발 반경 · 전부 무테스트 ⚠

- **Kotlin Money 표면 = 0.** `core/billing` 은 빈 모듈이고, 자식에서 `Entitlement`/`BillingRepository`/`TicketShop`/`consumePurchase`/`purchaseToken` 심볼은 GT `Routes.kt`(라우트 상수 1건)를 빼면 잡히지 않는다. `sot-code-name-map.md` 가 적은 `TicketShopScreen.kt`/`TicketPurchaseScreen.kt` 는 disk 에 실재하지 않는다 — 해당 매핑 doc 의 STALENESS 배너와 정합하는 stale row(본 audit 의 baseline 인 paste §3 가 "Money 표면 = TypeScript EF"라고 적은 쪽이 정확).
- **실 Money 표면 = GB Edge Function 3종(TypeScript), 테스트 0:**

  | EF | LOC | 역할 | 상태 |
  |---|---|---|---|
  | `verify-purchase` | 209 | 영수증 검증 + ticket 적립 | 실 로직(JWT 게이트 · orderId 중복 체크 · purchaseState=0 검증 · server-side orderId cross-check · DB upsert) **그러나 Google Play 인증 Bearer 스텁** |
  | `verify-ad-reward` | 161 | 광고 보상 → quota/적립 | 무테스트 |
  | `check-quota` | 135 | 사용 quota 게이트 | 무테스트 |

- **Bearer 스텁 확정**(content grep): `verify-purchase` 는 `GOOGLE_PLAY_BILLING_KEY` env 를 OAuth 토큰 교환 없이 `Authorization: Bearer ${playBillingKey}` 로 직접 사용한다(line 75 → 129). `androidpublisher.googleapis.com` 는 service-account JSON → JWT 서명 → OAuth2 access_token 흐름을 요구하므로(`billing-rules.md` §3), 현재는 인증 한 축이 user-prep 스텁 상태다. 단 그 외 검증 로직은 실재하므로 **테스트 가치가 높은데 0 인** 209줄이다.
- **레버리지 지점**: GB `supabase/functions/_shared/auth.ts` 가 세 Money EF 의 공통 JWT 게이트다(+`admob.ts` = ad-reward 경로). 공통 모듈 1개 테스트가 세 EF 게이트를 동시에 덮는다.
- **billing-rules.md 가 명문화한, 지금 테스트 가능한 불변식**: 영수증 invalid → `ReceiptInvalid` 반환(entitlement 미부여) · consumable 미`consumePurchase` 금지 · offline 잔액 차감 금지(낙관적 차감 X) · orderId UNIQUE(중복 적립 차단). 이들은 Google Play 실연동 없이 mock 응답으로 검증 가능(`billing-rules.md` §1 Mock-first).

### 4.2 Backend/EF — 13종 전부 무테스트

EF 분포: GB 7 + GD 3 + GT 3 = 13(+ 각 repo `_shared`). `*.test.ts` = 0(전 repo). 큰/위험한 순:

| EF | repo | LOC | 위험 신호 |
|---|---|---|---|
| `sync-daily-logs` | GD | 358 | 오프라인 동기화 + 병합/충돌 경로(data 무결성) |
| `list-breath-sessions` | GB | 250 | 목록 직렬화 + RLS 경로 |
| `verify-purchase` | GB | 209 | Money(§4.1) |
| `generate-daily-suggestion` / `generate-meal-recommendation` / `generate-exercise-recommendation` | GD/GT | ~195 | Claude proxy + 파싱 경계 |
| 그 외(check-quota, verify-ad-reward, verify-integrity, claude-proxy, generate-breath-guidance, ai_insights, prescription-history-stats) | — | 100~190 | 게이트/프록시/집계 |

EF 는 TypeScript 라 Kotlin 테스트 도구(§12 매핑) 밖이다. backfill 전략 제안 = Deno 표준 `deno test` + `_shared` 클라이언트(supabase-client/claude-client) 를 fake 주입(`TESTABILITY_SEAMS` seam 원칙의 TS 판). 이는 별 트랙(Kotlin kover 와 분리된 신호)으로 둔다.

### 4.3 Data — Supabase 양호 · Room/local 이 빈 곳

Repository impl ↔ `<Name>Test.kt` 매칭 실측:

- **GB**: SupabaseBreathGuidance ✓ · SupabaseMeditationSessionsList ✓ · **RoomMeditationRepository ✗** · **InMemoryMeditationRepository ✗**. Room local 5파일(Database/Factory/Dao/Entity/RoomRepo) 무테스트.
- **GD**: SupabaseDailyLogs ✓ · SupabaseDailySuggestion ✓ · **RoomDailyLogsCache ✗ · RoomHabits ✗ · RoomJournal ✗ · RoomSleep ✗**(Room repo 4개 전부). Room local 3파일(AppDatabase/RoomDaos/RoomEntities). journal/habits/sleep 는 ViewModel 은 테스트되나 그 뒤의 Room repo 는 무테스트.
- **GT**: SupabasePrescription ✓ · SupabasePrescriptionHistoryStats ✓ · **SupabaseEfMeal ✗ · SupabaseEfNutrition ✗**. Room 계층 없음(데이터 = Supabase EF 경유).
- **Room migration 테스트 = 0**(전 repo). `TESTING_STRATEGY` §11.2 의 Fake DAO 주입 integration 이 Room 계층에 부재.

### 4.4 Auth — 상대적 양호 (backfill 우선순위 낮음)

foundation `core/auth`(3p/5t)가 익명 부트스트랩 + identity provider + 오류 타입을 덮고, 자식 3개 모두 `SplashViewModelTest`(익명 부트스트랩 진입)를 가진다. 토큰 저장은 `core/security` SecureTokenStore fake/test 가 인접 보강. 빈 경로 후보 = 토큰 만료 → 재부트스트랩 엣지(`TESTING_STRATEGY` §11.5 예시)와 `signOut`=익명 재발급 재정의(`auth-rules.md` §4)의 직접 단언. base 가 덮여 있어 ROI 후순위.

### 4.5 구조 메모 — shared 도메인 위치

foundation 의 `shared/domain`·`shared/data`·`shared/feature-state` 는 prod 0(빈 모듈)이다. `TESTING_STRATEGY` §2 피라미드가 unit/integration 의 거주지로 가리키는 `commonTest(shared/*)` 가 foundation 에는 비어 있고, 실제 도메인/데이터 로직은 각 자식 `composeApp/src/commonTest` 에 거주한다. 따라서 본 audit 의 ROI 단위도 자식 composeApp 모듈 기준으로 잡는다(foundation 은 core/* 만 대상).

---

## 5. ROI 순 backfill 로드맵

`TESTING_STRATEGY` §5 의 ROI 순서(고위험 Auth/Billing/Data/Backend + UseCase/정책/상태기계 + 실패·경계 + StateFlow ViewModel + mapper/parser 우선 / trivial getter·DTO·순수 렌더 후순위)와 §11 per-layer 케이스를 따른다. 각 R 항목 = 후속 cycle 1개의 단위이며, kover 가 측정 가능한 모듈/계층 경계에 정렬한다(PRELAUNCH CI test=warn 게이트 + 후속 kover 신호가 이 빈 곳을 상시 숫자화).

| 순위 | 항목 | 대상 | 인용 케이스 | Mode/STOP |
|---|---|---|---|---|
| **R1** | **Money EF 게이트** | GB `_shared/auth.ts`(JWT 게이트 · 3 EF 공통) + `verify-purchase`/`verify-ad-reward`/`check-quota` 불변식 | §5 고위험 Billing · §11.5 Billing 예시(`verify` invalid → ReceiptInvalid · `consume` offline 미차감) | **M3 / STOP #1** (§6) |
| **R2** | **Data 무결성 EF** | GD `sync-daily-logs`(병합/충돌) + 생성형 EF 파싱 경계 | §5 Backend 고위험 · §6 실패·경계 케이스 | M3 분기(Data) |
| **R3** | **Room 데이터 계층** | GD Room repo 4 + GB RoomMeditationRepository + GT meal/nutrition repo + Room migration | §5 Data · §11.2 Fake DAO integration | M1(+ migration 시 M3) |
| **R4** | **UseCase + Mapper** | 자식 UseCase 7개 직접 단언 + GT mapper 4 round-trip | §5 UseCase/mapper 고위험 · §11.1·§11.4 | M1 |
| **R5** | **ViewModel 완성** | 미테스트 StateFlow VM 8개(GB 3 + GD 3 + GT 2) | §5 StateFlow VM · §11.3 Turbine | M1 |
| **R6** | **Auth 엣지** | 토큰 만료→재부트스트랩 · signOut 재정의 직접 단언 | §5 실패·경계 · §11.5 Auth 예시 | **M3 / STOP #1** (§6) |

후순위(low/skip · §5): trivial getter · 순수 렌더 Screen Composable(상호작용 로직 없는 화면) · DTO 단순 필드 왕복 · 생성/프레임워크 코드.

각 R 은 단일 자식 또는 단일 모듈 scope 로 분할해 ×N 후속 cycle 로 집행한다(§8).

---

## 6. Money/Auth 접촉 항목 — M3 / STOP #1 분기 표기

본 audit 자체는 read-only 라 STOP #1 이 발동하지 않는다(코드 0). 그러나 R1·R6 backfill cycle 이 실제로 집행될 때는 다음 분기가 강제된다(`CLAUDE.md §5` STOP #1 · `mode-system.md` M3):

- **R1(Money)**: Billing 경로 변경 → **Mode M3(migration-safe)** 진입 + STOP #1(Money) → 사용자 본심 회수 의무. 단 `billing-rules.md` §1 Mock-first 에 따라 **mock 응답 기반 로직 단언**(JWT 게이트 · orderId 중복 · purchaseState · ReceiptInvalid 매핑)은 실 Google Play 연동 없이 가능 → 그 범위는 실제 결제 경로를 건드리지 않으므로 STOP #1 의 "비가역/실연동" 사유는 미해당. **실 verify 경로(Bearer→OAuth service-account 교환) 구현/변경**은 user-prep + M3 + STOP #1 전부 발동.
- **R6(Auth)**: 토큰/세션/부트스트랩 경로 변경 → **M3** + STOP #1(Auth). 단 FakeAuthRepository/FakeUserIdentityProvider 기반 단언(이미 foundation 에 존재)은 실 인증 SDK 미접촉이라 작성 자체는 저위험. Supabase RLS/서버 사이드 접촉은 별 cycle(`supabase-handling.md` §3) + STOP.

요지: **테스트 "작성"은 Fake/mock 경로면 저위험이나, 도메인이 Money/Auth 라는 사실 자체가 해당 backfill cycle 의 Mode 를 M3 로 올리고 STOP #1 회수 의무를 건다.** 실연동/비가역 경로에 닿는 순간이 진짜 STOP 지점이다.

---

## 7. 후속 cycle 분할 제안 (×N)

ROI 와 kover 측정 단위를 맞춰 다음과 같이 쪼갠다(각 1 cycle · 영역 2 다중 cli session 또는 단일 자식 진입 권장 · 무거운 IMPL 은 sub-agent fan-out 회피):

1. `*-TEST-BACKFILL-MONEY-EF-001` (GB · R1 · **M3**) — `_shared/auth.ts` + 3 Money EF · Deno test 하니스 신설 동반.
2. `*-TEST-BACKFILL-SYNC-EF-001` (GD · R2) — `sync-daily-logs` 병합/충돌 + 생성형 EF 파싱.
3. `GD-TEST-BACKFILL-ROOM-001` (GD · R3) — Room repo 4 + migration(AppDatabase).
4. `GB-TEST-BACKFILL-ROOM-001` (GB · R3) — RoomMeditationRepository + Meditation Dao/Entity.
5. `GT-TEST-BACKFILL-REPO-001` (GT · R3) — meal/nutrition Supabase repo.
6. `*-TEST-BACKFILL-USECASE-MAPPER-001` (자식별 · R4) — UseCase 직접 + GT mapper round-trip.
7. `*-TEST-BACKFILL-VM-001` (자식별 · R5) — 미테스트 StateFlow VM 8.
8. `*-TEST-BACKFILL-AUTH-EDGE-001` (R6 · **M3**) — 토큰 만료/재부트스트랩.

EF 트랙(1·2)은 Kotlin kover 와 분리된 별 신호다. Deno test 도입 여부 + CI 배선은 해당 cycle 의 §FREEDOM.

---

## 8. Refs

- [`../architecture/TESTING_STRATEGY.md`](../architecture/TESTING_STRATEGY.md) — §5 ROI 우선순위 · §9 커버리지=신호 · §11 per-layer 케이스(11.1 UseCase / 11.2 Repository / 11.3 ViewModel / 11.4 mapper / 11.5 Auth·Billing) · §12 프레임워크 매핑
- [`../architecture/TDD_WORKFLOW.md`](../architecture/TDD_WORKFLOW.md) · [`../architecture/TESTABILITY_SEAMS.md`](../architecture/TESTABILITY_SEAMS.md) — 언제/어떻게
- `.claude/rules/billing-rules.md`(§1 Mock-first · §2 EF 단일 진입점 · §5 entitlement 불변식) · `.claude/rules/auth-rules.md` · `.claude/rules/supabase-handling.md` · `.claude/rules/mode-system.md`(M3) · `CLAUDE.md §5`(STOP #1)
- 소비처: PRELAUNCH CI 게이트(test=warn) + 후속 kover 신호가 본 빈 곳을 상시 숫자화

---

## 9. 명시 cycle 이력

- 2026-06-03 · `MASTER-CLI-TESTING-BACKFILL-AUDIT-001` · 본 문서 신설(read-only audit · M5). 4 repo 실테스트 disk 실측 → repo×계층 빈 곳 지도 + ROI 순 backfill 로드맵(R1~R6) + Money/Auth M3·STOP #1 분기 표기. 박제 baseline(FND 13/GB 8/GD 8/GT 10 · prod 44/61/70/69) 재측정 일치(STOP #4 비발동). 코드 0 · 보호 5 sha 변동 0 · production 0 touch · master-only(propagation 없음).
