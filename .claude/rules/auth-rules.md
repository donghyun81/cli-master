# Auth Rules — Supabase 익명 부트스트랩 + JSON Backup paradigm

> **단일 목적**: 자식 repo (GT/GD/GB) 의 인증 / 토큰 / identity / JSON backup / OAuth 정책 SoT.
> **MASTER-AUTH-DOMAIN-ACTIVATE-001 신설** (GT-AUTH-PIVOT-001 commit `ae5e04d` 명시된 패러다임 코드화).
> **연관 파일**:
> - `deferred-domains.md` §1 STOP trigger + §2 도메인 활성화 매트릭스 (Auth = ACTIVE)
> - `safety-and-secrets.md` 시크릿 / PII 처리 + EncryptedSharedPreferences 정책
> - `routing-and-delegation.md` `auth-security-privacy` agent 매핑 (active)
> - `workflow-core.md` §implement Testability Seams (`UserIdentityProvider` 인터페이스 주입)
> - `cycle-discipline.md` §15 패턴 3 (도메인 활성화 절차)
> SOT: `CLAUDE.md`

---

## §1 익명 부트스트랩 paradigm (default · 30 초 UX 정합)

- GoTrue REST `POST /auth/v1/signup` body `{}` (Supabase 익명 user 자동 생성)
- 응답 `{ access_token, refresh_token, user.id }` → `SecureTokenStore` 저장
- `Application.onCreate()` 또는 Splash 진입 시 `AnonymousAuthBootstrap.bootstrapAsync()` 호출
- 기존 userId 있으면 session 복원 시도 → 실패 시 stored userId 그대로 return

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

- `signOut()` = "익명 세션 폐기 + 신규 부트스트랩" 으로 재정의 (Email/Password 시대의 logout 의미 X)
- `restoreSession()` = `bootstrapAsync()` 통합
- `currentUserId: Flow<String?>` (impl StateFlow 강화 가능)

---

## §5 JSON backup paradigm

- `formatVersion` + `exportedFromRepo` guard 의무 (mismatch = `BackupError.FormatMismatch`)
- top-level keys exact match 강제 (오타 = REVIEW FAIL)
- entity `userId` 재매핑 의무 (import 시 현재 익명 userId 로)
- SAF (`ActivityResultContracts.CreateDocument` / `OpenDocument`) 사용 의무 (외부 storage 권한 회피)

---

## §6 OAuth Phase 2 (별 trail)

- Google / Kakao OAuth = 익명 user → 정식 계정 마이그레이션 패턴
- 본 §1 익명 부트스트랩 마감 후 별 cycle 으로 도입 (lazy · 자연 trigger 의 사용자 요청 시)
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

- master 측 단방향 propagation 영역 (cli infra 권장 byte-identical · 보호 파일 4종 외)
- 변경 시 master cycle 신설 + 6-repo propagation 의무
- 자식 repo 직접 수정 금지

---

## §10 명시된 cycle 이력

- 2026-05-02 · MASTER-AUTH-DOMAIN-ACTIVATE-001 · 본 rule 신설 + auth-security-privacy [DEFERRED]→ACTIVE
- 2026-05-02 · GT-AUTH-PIVOT-001 (자식 cycle) · 본 paradigm 첫 채택
