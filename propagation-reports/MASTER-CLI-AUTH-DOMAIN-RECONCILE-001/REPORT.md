# MASTER-CLI-AUTH-DOMAIN-RECONCILE-001 — Propagation REPORT

- **마감일 (KST)**: 2026-06-22
- **Mode**: M5 (cli-infra-ops) · production 0 LOC · doc(rule) 2 file
- **본질**: GD Auth 도메인 활성화 (W3) + `auth-rules.md` §5 export↔restore/import 분기 명확화 (W8)
- **master content commit**: `0c82899`
- **진입 baseline (master HEAD)**: `efa2be2`

---

## 변경 (2 file · 둘 다 비보호 cli infra)

### W3 — `.claude/rules/deferred-domains.md`
- §2 매트릭스 Auth 행 GD 셀 `UNKNOWN` → **`ACTIVE` ⁴** (Data / Backend / Perf 행 무접촉 · Billing 행 무접촉).
- footnote ⁴ 신설: Supabase Auth 익명 부트스트랩 (foundation `AnonymousAuthBootstrap` + `signInAnonymously` · per-token `SecureTokenStore`) · `GentlyDayApplication.onCreate()` `restoreSession()` 단일 진입점 + `SplashViewModel` 15s timeout observe.
- §6 C2 변경 이력 entry append (2026-06-22).

### W8 — `.claude/rules/auth-rules.md`
- §5 JSON backup paradigm → 두 경로 분리:
  - **§5.1 export 경로 (live)** — 3 앱 export 진입점 + `formatVersion` 발행 + top-level keys exact match + SAF `CreateDocument`.
  - **§5.2 restore/import 경로 (forward-looking)** — `exportedFromRepo` guard + `BackupError.FormatMismatch` + userId 재매핑 + SAF `OpenDocument` (현 미구현).
- ★ §1 (30초 UX 익명 부트스트랩) · §6 (OAuth Phase 2) 무접촉.

---

## W3 라이브 anon bootstrap 실측 (A7 filename + content dual grep · PASS)

| 단계 | 위치 |
|---|---|
| Application 진입점 | `GentlyDay/composeApp/src/androidMain/.../GentlyDayApplication.kt:85` `authRepository.restoreSession()` (onCreate · startKoin 후) |
| DI 등록 | `GentlyDay/composeApp/src/androidMain/.../data/di/AuthModule.kt:34` `single { AnonymousAuthBootstrap(...) }` + `SupabaseAuthRepository` |
| Repository | `app-foundation/core/supabase/.../SupabaseAuthRepository.kt:26` `bootstrap.bootstrapAsync()` |
| Bootstrap | `app-foundation/core/supabase/.../AnonymousAuthBootstrap.kt:73` `sessionGateway.signInAnonymously()` |
| Splash observe | `GentlyDay/composeApp/src/commonMain/.../splash/SplashViewModel.kt:169` `SPLASH_BOOTSTRAP_TIMEOUT_MS = 15_000L` |
| Token store | foundation `SecureTokenStore` (androidMain = `AndroidSecureTokenStore` / EncryptedSharedPreferences) |

- legacy `com.example.gentlyday.auth.AnonymousAuthBootstrap` = dead `app/` 모듈 (build.gradle.kts 부재 · `composeApp` 흡수 마감). live 경로 = foundation `com.gently.foundation.supabase.auth`.

## W8 export/import 실측 (A5 disk verification · PASS)

- **export = live (3앱)**: GB `DataExportUseCase` (`domain/export`) · GD `DataExportRepository` (`data/export`) · GT `BuildDataExportUseCase` (`domain/dataexport`, `FORMAT_VERSION = 1`) — 각각 ViewModel + DI + test 동반.
- **restore/import = forward-looking (0 match)**: `BackupError.FormatMismatch` / `exportedFromRepo` / `DataImport`·`restoreBackup`·`remapUserId` = 6-repo + foundation 전수 0 match.

---

## propagate + verify

- `bash scripts/propagate.sh .claude/rules/deferred-domains.md .claude/rules/auth-rules.md --targets all` → **ok=10 / fail=0** (5 자식 × 2 file).
- 6-repo byte-identical blob: `deferred-domains.md` = `26fce91cff37` · `auth-rules.md` = `1ab0fd98964c`.
- `bash scripts/verify-sync.sh` → **PASS 160 / DRIFT 0 / MISS 5**.
  - MISS 5 = `docs/ops/production-cli-access-tokens.md` (master-only 운영 runbook · `supabase-handling.md §3.1` 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X).
- 보호 5 file sha-256 **drift 0** (edit-set ∩ 보호 = ∅ · 2 file 둘 다 비보호):
  - `ui-spec.schema.json` `8502c014…` / `pencil-uiux-workflow.md` `b09b8d50…` / `pencil-sot-policy.md` `2bfc81c5…` / `uiux-sot-refresh.md` `4d0b5279…` / `design-sot-policy.md` `92a5e998…` — before == after.

---

## commits

| repo | commit | 종류 |
|---|---|---|
| claude-cli-master | `0c82899` | content (2 file) |
| GentlyBreath | `e16f143` | propagation (path-limited) |
| GentlyDay | `8e611f1` | propagation (path-limited) |
| GentlyTable | `1f2e5b0` | propagation (path-limited) |
| app-foundation | `8694155` | propagation (path-limited) |
| gently-product-docs | `91eea8a` | propagation (path-limited) |
| claude-cli-master | (audit) | §15 + propagation-status + 본 REPORT |

---

## STOP 조건 status (무발동)

- Money/Auth **런타임** 무접촉 — 본 cycle = auth-rules / deferred-domains **doc-only** (런타임 코드 0 LOC).
- 보호 5 file sha drift 0 · byte-identical 유지.
- production code 0 LOC · §1 30초UX / §6 OAuth 무접촉 · Data/Backend/Perf row 무접촉.
- GD anon bootstrap 라이브 실측 PASS (미확인 시 STOP+Coin 조건 = 해소).

## 사고

- 없음. (verify-sync git-lock daemon 미활성 advisory = 비차단 · follow-up `launchctl load com.coin.git-lock-cleaner.plist`.)

## 후속 (scope 외)

- GD/GT import/restore 경로 실 구현 = 별 trail (§5.2 forward-looking spec).
- git-lock daemon launchctl load.
- §15 hot 15 > 10 → cold 재이전 advisory (별 cycle · master-only).

---

고려했으나 hot 제외 영역: GD import/restore 실 구현 (§5.2 forward-looking 유지 · 별 trail) · GB EncryptedSessionStore vs GD per-token SecureTokenStore 토큰 저장 분기 정합 advisory (동족 구현 정합 — 단 본 cycle = 단일 master rule doc 편집이라 cross-repo 동족 구현 cycle 아님 · A8 §4.4 N/A).
