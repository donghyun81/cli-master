# Auth Rules — email-first 가입 (이메일 OTP) + JSON Backup paradigm

> **단일 목적**: 활성 자식 repo (Selfward) 의 인증 / 토큰 / identity / JSON backup / OAuth 정책 SoT (= 동결 3[GB/GD/GT] 계보 서술 = §1 존치 라벨 영역).
> ★**2026-08-05 default 전환** (`MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001`): 활성 default = **§1b email-first 가입 (OTP 필수 · 익명 0)**. 구 §1 익명 부트스트랩 = **동결 3 계보 + FND `AnonymousAuthBootstrap` 존치 표면** 의 이력 paradigm 으로 재스코프 (= 문면 삭제 0). 근거 계보 = `DECISION-SELFWARD-EMAIL-FIRST-SIGNUP-20260804` (익명 폐지 확정) → `FND-OTP-GATEWAY-001` / `-002` (FND 표면 착지) → `SELFWARD-P2PRIME-EMAIL-FIRST-001` (SW 재배선 완결).
> **MASTER-AUTH-DOMAIN-ACTIVATE-001 신설** (GT-AUTH-PIVOT-001 commit `ae5e04d` 명시된 패러다임 코드화).
> **연관 파일**:
> - `deferred-domains.md` §1 STOP trigger + §2 도메인 활성화 매트릭스 (Auth = ACTIVE)
> - `safety-and-secrets.md` 시크릿 / PII 처리 + EncryptedSharedPreferences 정책
> - `routing-and-delegation.md` `auth-security-privacy` agent 매핑 (active)
> - `workflow-core.md` §implement Testability Seams (`UserIdentityProvider` 인터페이스 주입)
> - `cycle-discipline.md` §15 패턴 3 (도메인 활성화 절차)
> SOT: `CLAUDE.md`

---

## §1 익명 부트스트랩 paradigm (= 동결 계보 존치 · ★활성 default 아님)

> ★**스코프 라벨** (2026-08-05 `MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001` · 구 라벨 = 「default · 30 초 UX 정합」): 본 §1 = **동결 3 (GB/GD/GT) 계보 + FND `AnonymousAuthBootstrap` 존치 표면** 한정. 활성 자식 (Selfward) 측 **신규 배선 금지** — 활성 default = **§1b**.
> FND 측 클래스를 삭제하지 않는 이유 = 4-repo composite 라 동결 3 이 그 표면을 공유하기 때문 (= SW 는 호출 절단 완료 · 표면 존치 ≠ 활성 배선).

- GoTrue REST `POST /auth/v1/signup` body `{}` (Supabase 익명 user 자동 생성)
- 응답 `{ access_token, refresh_token, user.id }` → `SecureTokenStore` 저장
- `Application.onCreate()` 또는 Splash 진입 시 `AnonymousAuthBootstrap.bootstrapAsync()` 호출
- 기존 userId 있으면 session 복원 시도 → 실패 시 stored userId 그대로 return

---

## §1b email-first 가입 paradigm (= ★활성 default · Selfward)

> 근거 cycle 3: `DECISION-SELFWARD-EMAIL-FIRST-SIGNUP-20260804` (익명 폐지 확정) · `FND-OTP-GATEWAY-001` / `-002` (FND 표면 신설 · 수신 주소 변경 = 002) · `SELFWARD-P2PRIME-EMAIL-FIRST-001` (SW 재배선 완결).

- **가입 = 발송 + 검증 2 단** — `signInWith(OTP) { createUser = true }` → `verifyEmailOtp(OtpType.Email.EMAIL, …)` = Supabase 1급 경로 (별도 password 층 X). 미가입 이메일이면 **발송 호출이 곧 가입** · 신규 가입과 기존 사용자 재로그인이 같은 진입점.
- **seam 2 층 의무** — `AuthSessionGateway` 측 email-first op **5** (`requestEmailOtp` · `verifyEmailOtp` · `signOutCurrentSession` · `requestEmailChange` · `verifyEmailChange`) + `EmailOtpAuthenticator` op **6** (발송 · 검증 · 복원 · 폐기 · 주소변경 요청 · 주소변경 확정). domain 계층 SDK 직접 호출 금지 = §2 정합.
- ★**익명 부트스트랩과 동시 배선 금지** — `EmailOtpAuthenticator` 와 `AnonymousAuthBootstrap` 은 **서로 다른 `Mutex`** 를 쓴다 (각자 `private`) ⟹ 한 앱이 둘을 함께 배선하면 refresh token rotation 직렬화가 성립하지 않는다 (구 token 재사용 = token family 폐기 위험). email-first 소비자는 익명 부트스트랩을 **배선하지 않는 것이 전제**.
- **세션 부재 = 실패 착지** — 복원 실패 시 신규 익명 fallback **0** (= 로그인 화면 착지 신호 · §1 과 갈리는 지점). 일시 실패 (network / 429 / 5xx) = stored userId 로 success (오프라인 재실행 진행) · 영구 실패 (폐기·무효 refresh token = 4xx) 도 **저장소 보존** (소거는 폐기 op 단독 · store 선제 clear 금지).
- **signOut 사후 불변식** — `signOut(SignOutScope.LOCAL)` (= `GLOBAL` 금지 · 사용자의 다른 기기 session 무접촉) 선행 → SDK 가 던진 경우 `clearSession()` 직접 호출로 **활성 session = null 보장** → 그 다음 저장소 clear. 순서 역전 금지 (저장소만 비우면 session mirror 가 SDK 의 살아 있는 session 을 되쓴다). ★정직 기록 = 그 fallback 에서 **서버 측 session 은 살아 있을 수 있다** — 보장 범위는 "이 기기에서 로그아웃이 유지된다" 까지.
- **수신 주소 변경 = uid 불변 가드 의무** — 응답 uid ≠ 저장 uid 면 **실패로 표면화** (조용히 덮으면 이 기기의 local identity 가 남의 계정으로 갈아끼워진다) · 검사가 persist 보다 **앞서** 그 경우 저장소 무접촉. 저장 uid **부재** 는 다름과 구분 (= 응답 uid 채택).
- **소비자 경계** — 활성 자식 (Selfward) 단독. 동결 3 = §1 계보 유지 (전환 대상 X).

---

## §2 identity 변동성 경계 (인터페이스 단일 진입점)

- `interface UserIdentityProvider { fun currentUserId(): String? }` 의무
- domain 계층에서 인증 SDK 직접 호출 금지 (`workflow-core.md` §implement 정합)
- impl 만 `SecureTokenStore.getUserId()` 단일 진입점

---

## §3 토큰 저장 의무

- `EncryptedSharedPreferences` 사용 의무 (plaintext SharedPreferences 금지)
- `accessToken` / `refreshToken` / `userId` 3 항목 추가
- HTTP 금지 (HTTPS only)

---

## §4 AuthRepository 패턴

- `signOut()` = **세션 파기 → SignIn 화면 착지** (활성 default · §1b `discardSessionAsync` 계약 · 신규 부트스트랩 **0**)
  - 구 문면 = `signOut()` 를 "익명 세션 폐기 + 신규 부트스트랩" 으로 재정의 (Email/Password 시대의 logout 의미 X) — **동결 계보 한정** (= §1 라벨). 활성 default 에서 이 재정의를 쓰면 로그아웃한 사용자가 조용히 새 익명 계정으로 되살아난다.
- `restoreSession()` = 활성 default 측 `restoreSessionAsync()` (= 실패 시 로그인 착지 · §1b) · 동결 계보 측 = `bootstrapAsync()` 통합
- `currentUserId: Flow<String?>` (impl StateFlow 강화 가능)

---

## §5 JSON backup paradigm

> **export ↔ restore/import 분기 명확화** (= 2026-06-22 실측 정합 · MASTER-CLI-AUTH-DOMAIN-RECONCILE-001): 본 §5 = 두 경로 분리. **export 경로 = 3 앱 live (§5.1)** · **restore/import 경로 = 미구현 forward-looking spec (§5.2)** (= disk 실측 0 match). 두 경로 혼동 금지 — import 가 live 인 듯 서술 X.

### §5.1 export 경로 (= live · 3 앱 구현됨)

- 3 앱별 export 진입점 = GB `DataExportUseCase` (`domain/export`) · GD `DataExportRepository` (`data/export`) · GT `BuildDataExportUseCase` (`domain/dataexport`) — 모두 live (ViewModel + DI + test 동반).
- `formatVersion` 발행 의무 (= export bundle 측 포맷 버전 · 예: GT `FORMAT_VERSION = 1` · 구조 변경 시 증가).
- top-level keys exact match 강제 (= export bundle 구조 계약 · 오타 = REVIEW FAIL).
- SAF (`ActivityResultContracts.CreateDocument`) 사용 의무 (= 외부 storage 권한 회피 · export 저장 경로).

### §5.2 restore/import 경로 (= forward-looking · 미구현 spec)

> 본 §5.2 = 향후 import/restore cycle 진입 시점 구현 의무 spec. 현 시점 3 앱 + foundation 모두 미구현 (= `BackupError.FormatMismatch` / `exportedFromRepo` / userId 재매핑 / SAF `OpenDocument` 실측 0 match). 실 도입 = 별 trail.

- `formatVersion` + `exportedFromRepo` guard 의무 (mismatch = `BackupError.FormatMismatch` · 현 미구현 typed error).
- entity `userId` 재매핑 의무 (import 시 **현재 로그인 userId** 로 — restore 시점 기기의 identity 정합).
- SAF (`ActivityResultContracts.OpenDocument`) 사용 의무 (= 외부 storage 권한 회피 · import 읽기 경로).

---

## §6 OAuth Phase 2 (별 trail)

- Google / Kakao OAuth = **email-first 계정에 OAuth identity link** 패턴 (= 출시 후 별 cycle)
  - ★구 문면 「익명 user → 정식 계정 마이그레이션 패턴」 = **전제 사망** (2026-08-05 이관 · 활성 default 측 익명 user 부재). 그 마이그레이션 서술은 **동결 계보 (§1) 측으로만** 유효.
- 본 §1b email-first 착지 후 별 cycle 으로 도입 (lazy · 자연 trigger 의 사용자 요청 시)
- `signInWithOAuth(Google)` = Credentials Manager + OAuth client ID 외부 prep 의무

---

## §7 STOP trigger (즉시 STOP + 본 rule reading 의무)

- 로그인 방식 / 세션 / 토큰 저장 방식 변경
- OAuth 신설 (Phase 2 별 cycle 의무)
- Supabase RLS 정책 충돌 (외부 검증에서 발견 시)
- 시크릿 (API key / 토큰) 하드코딩 시도

---

## §8 절대 금지

- 시크릿 하드코딩 (`safety-and-secrets.md` 정합)
- PII 로그 출력
- HTTP (HTTPS only)
- plaintext 토큰 SharedPreferences
- mock 인증 결과 production 노출
- Supabase 서버 사이드 (RLS · edge function · vault) 직접 변경 (별 cycle 의무)

---

## §9 본 rule 의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md) (= 4-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).

---

## §10 명시된 cycle 이력

- 2026-05-02 · MASTER-AUTH-DOMAIN-ACTIVATE-001 · 본 rule 신설 + auth-security-privacy [DEFERRED]→ACTIVE
- 2026-05-02 · GT-AUTH-PIVOT-001 (자식 cycle) · 본 paradigm 첫 채택
- 2026-08-05 · MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001 · **default 전환** = 익명 부트스트랩 → email-first 가입. §1b 신설 (활성 default) · §1 = 동결 계보 존치 라벨로 재스코프 · §4 signOut 재정의 · §5.2 userId 어휘 이관 · §6 OAuth 전제 이관 · **§7 STOP 무변** · 문면 삭제 0.
  - ★**§7 STOP 해제 문서 계보** (= 본 전환도 §7 「로그인 방식 / 세션 / 토큰 저장 방식 변경」 STOP 을 통과했다): 확정 = `DECISION-SELFWARD-EMAIL-FIRST-SIGNUP-20260804` (익명 폐지) · **해제 문서 = `FND-OTP-GATEWAY-001` paste** (= 그 STOP 의 사용자 본심 회수 근거) · 착지 = `FND-OTP-GATEWAY-001`/`-002` (FND 표면) + `SELFWARD-P2PRIME-EMAIL-FIRST-001` (SW 재배선). ⟹ §7 STOP 은 이 전환으로 **약화되지 않는다** — 다음 변경도 같은 해제 절차 의무.
