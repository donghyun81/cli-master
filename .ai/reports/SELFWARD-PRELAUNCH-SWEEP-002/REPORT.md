# SELFWARD-PRELAUNCH-SWEEP-002 — REPORT

> **cycle 본질** = 「본문은 갈아끼웠는데 간판을 안 바꿨다」의 회수. `auth-rules.md` 는 2026-08-05 `MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001` 로 email-first 전환 + 4-repo byte-identical 전파까지 끝났는데(**sha `a8c59b48` · 본 cycle 무변**), 그 rule 을 가리키는 pointer·표·각주·템플릿이 전부 「익명 부트스트랩」이라는 옛 설명을 달고 있었다.
> **집행문** = `cc-paste-SELFWARD-PRELAUNCH-SWEEP-002.md`(부모 root) · **근거 SoT** = `MEASURE-CROSSREPO-DOC-STALE-20260809.md`(부모 root).
> **성격** = docs-only · production **0 LOC** · prod 무접촉 · flavor 무기동 · 빌드 0 · 보호 5 sha 무접촉.
> **마감** = 2026-08-09 KST · sha 표기 = `shasum -a256 | cut -c1-8`.

---

## §0. 선행 의무 (§0.1) — SWEEP-001 착지 확인

집행 **전** 실측. Selfward HEAD 2 행:

```
2d673d5 docs(report): SELFWARD-PRELAUNCH-SWEEP-001 REPORT — 세는 자·행별 근거·대조군·게이트 전문
138f629 docs(registry): SELFWARD-PRELAUNCH-SWEEP-001 — 출시 전 열린 행 전수 재판정(29) + 폐지·소멸분 sweep 5
```

⟹ **착지 확인 · 동시 실행 아님** ⟹ 집행 진입. (본 cycle 의 전파가 SW 에도 쓰기를 내므로 §0.1 이 요구한 순서 게이트 = 통과.)

---

## §1. 정정 문면의 원천 — 읽은 좌표 (발명 0)

★새 설명을 **발명하지 않았다**. 아래 좌표를 열어 그 어휘로 이름표를 맞췄다.

| 인용 좌표 (`docs/rules/auth-rules.md`) | 읽은 내용 (요지) |
|---|---|
| `:1` | 제목 = 「Auth Rules — **email-first 가입 (이메일 OTP)** + JSON Backup paradigm」 |
| `:4` | 2026-08-05 default 전환 고지 · 활성 default = §1b · 구 §1 = **동결 3 계보 + FND `AnonymousAuthBootstrap` 존치 표면**으로 재스코프 · 근거 계보 = `DECISION-SELFWARD-EMAIL-FIRST-SIGNUP-20260804`(익명 폐지 확정) → `FND-OTP-GATEWAY-001`/`-002` → `SELFWARD-P2PRIME-EMAIL-FIRST-001` |
| `:16`~`:19` | §1 스코프 라벨 = 「동결 계보 존치 · ★활성 default 아님」 · **활성 자식(SW) 신규 배선 금지** · FND 클래스 미삭제 사유(4-repo composite · 표면 존치 ≠ 활성 배선) |
| `:28` | §1b 제목 = 「email-first 가입 paradigm (= ★**활성 default** · Selfward)」 |
| `:32` | ★**호출 형태 원천** — 가입 = 발송 + 검증 2 단 · `signInWith(OTP) { createUser = true }` → `verifyEmailOtp(OtpType.Email.EMAIL, …)` = Supabase 1급 경로 · **미가입 이메일이면 발송 호출이 곧 가입** · 신규 가입과 기존 사용자 재로그인이 같은 진입점 |
| `:33` | seam 2 층 = `AuthSessionGateway` op **5** + `EmailOtpAuthenticator` op **6** |
| `:35` | 세션 부재 = 실패 착지 · **신규 익명 fallback 0** |
| `:38` | 소비자 경계 = 활성 자식(Selfward) 단독 · 동결 3 = §1 계보 유지(**전환 대상 X**) |
| `:88`~`:91` (§6) | 「익명 user → 정식 계정 마이그레이션 패턴」 = **전제 사망** 명시 (→ §6 넘김 항 근거) |

★**표지 어휘도 위 본문 것을 그대로 썼다** — 「활성 default 아님」 · 「동결 3 계보 + FND 존치 표면 한정」 · 「전환 대상 X」 = `auth-rules.md` 자신의 표현.

---

## §2. 좌표별 처분 (구 문면 verbatim · 정정 문면 · 인용처 · 표지 실재)

### A. 4-repo 전파분 (master 에서 고치고 전파 · master commit `91ea579`)

#### A1 · `docs/rules/rule-routing-index.md:92`

- **구 문면(verbatim · 존치)** — `Supabase 익명 부트스트랩 + 토큰 저장 + JSON backup`
- **정정 문면** — `email-first 가입 (이메일 OTP) + 토큰 저장 + JSON backup`
- **인용처** — `auth-rules.md:1`(제목 어휘) · `:4`(전환 고지)
- **표지 실재** — ⚠ `supersede: 구 설명 「…」 = 활성 default 아님` + 전환 cycle ID + 결정 문서 + 「구 익명 부트스트랩 = 같은 rule §1 동결 3 계보 + FND 존치 표면 한정」 + `SELFWARD-PRELAUNCH-SWEEP-002`
- **왜 최우선인가** — 라우팅 표다. cli 가 auth 작업에서 **어느 rule 을 열지 고르는 자리**라 여기가 낡으면 진입부터 갈린다.

#### A2 · `docs/rules/sot-code-name-map.md:32` · `:83` — ★집행문 대비 **처분 형태 편차 1** (아래 §5 기록)

- **구 문면(verbatim · 존치)** — `:32` = `익명 인증 자동 (`AnonymousAuthBootstrap`), UI 화면 없음` / `:83` = `익명 인증 자동 (`AnonymousAuthBootstrap`)`
- **집행문 판정** = 「★★정면으로 반대다 — 현행은 가입 UI 가 있다」 ⟹ 무효 표지.
- ★**실측 결과 = 그 판정을 그대로 쓸 수 없다.** 두 행이 놓인 절을 열어보면 —
  - `sot-code-name-map.md:28` = `## 2. GB (GentlyBreath) 매핑` ⟹ **`:32` 은 GB 행**
  - `sot-code-name-map.md:78` = `## 4. GT (GentlyTable) 매핑` ⟹ **`:83` 은 GT 행**
  - 같은 file `:4` = `**scope**: GB / GD / GT 3 자식 repo`
  - GB·GT = **동결 계승 원천**이고 `auth-rules.md:38` 이 「동결 3 = §1 계보 유지(**전환 대상 X**)」를 명시 ⟹ **두 행의 서술은 그 repo 들에 대해 지금도 참**이다.
- ⟹ **처분 = 「구 문면 무효」가 아니라 「스코프 표지」.** (무효로 적었으면 §4-9 가 금한 **없는 결함 2 건**을 새로 만들었다.)
- **정정 문면(표지)** — ⚠ `스코프 표지: 본 행 = 동결 3 중 GB(/GT) 계보 한정 · 활성 default 아님` + `auth-rules.md §1 스코프 라벨` 인용 + **활성 자식 실측 좌표 병기**
- **UI 이름 = 실측 (발명 0)** — `Selfward/composeApp/src/commonMain/kotlin/com/gently/selfward/shared/auth/SignInScreen.kt` (동반 실재 = `SignInUiState.kt` · `SignInViewModel.kt` · test 2) ⟹ 「활성 자식 Selfward = **email-first 가입 UI 실재**」로 적었다.
- **인용처** — `auth-rules.md:16`~`:19`(§1 스코프 라벨) · `:38`(동결 3 전환 대상 X)
- **부수 관측(넘김)** — 이 file 에는 **Selfward 절 자체가 없다**(§2 GB / §3 GD / §4 GT 뿐). 절 신설 = 범위 확장이라 하지 않았다 → §6 넘김.

#### A3 · `docs/rules/supabase-handling.md:8` · `:208`

- **구 문면(verbatim · 존치)**
  - `:8` = `` `auth-rules.md` §1 — GoTrue REST 익명 부트스트랩 ``
  - `:208` = `` GoTrue REST 익명 부트스트랩 | `auth-rules.md` §1 | `POST /auth/v1/signup` body `{}` = 클라이언트 SDK 영역 (admin API 영역 외) ``
- **정정 문면**
  - `:8` = `` `auth-rules.md` §1b — email-first 가입 (이메일 OTP) ``
  - `:208` = `` email-first 가입 (이메일 OTP) | `auth-rules.md` §1b | `signInWith(OTP) { createUser = true }` → `verifyEmailOtp(OtpType.Email.EMAIL, …)` = 클라이언트 SDK 영역 (admin API 영역 외) ``
- **인용처** — ★호출 형태 전량 = `auth-rules.md:32` **verbatim 인용** (형태를 지어내지 않았다).
- **보존 판단** — 3 열의 「= 클라이언트 SDK 영역 (admin API 영역 외)」 분류는 email-first 에서도 그대로 성립(§1b 도 클라이언트 SDK 1급 경로)이라 **유지**했다.
- **표지 실재** — 양 좌표 모두 ⚠ supersede + 구 문면 verbatim(표 셀은 `\|` escape) + 「§1 = 동결 3 계보 + FND 존치 표면 한정」.

#### A4 · `docs/rules/deferred-domains.md:46` · `:50` · `:52`

각주 3 개가 익명 부트스트랩을 **현행 패러다임**으로 서술하고 있었다. 각주가 가리키는 대상이 서로 달라 **표지도 갈랐다**(같은 문구 3벌 X):

| 좌표 | 각주 | 대상 | 표지 |
|---|---|---|---|
| `:46` | ¹ | **master + GT** (매트릭스 `:40` 기준) | ⚠ supersede: 「익명 부트스트랩」 = 현행 패러다임 아님 · **master 측 활성 default = §1b** · GT = 동결 계승 원천이라 §1 계보 유지 |
| `:50` | ³ | **GB** | ⚠ 스코프 표지: GB = 동결 계승 원천 · §1 계보 유지(전환 대상 X) · 활성 default 은 §1b 이며 본 각주는 그 default 이 아니다 |
| `:52` | ⁴ | **GD** | 동상(GD) |

- **인용처** — `auth-rules.md:4` · `:38`.
- ★**`:100`·`:101` 무접촉** (= `## 6. C2 변경 이력` 절 · 이력은 낡는 게 정상) — G7 census 에서 그대로 잔존 확인.

#### A5 · `docs/templates/release-checklist.template.md:48`

- **구 문면(verbatim · 존치)** — `익명 부트스트랩 패러다임 명시`
- **정정 문면** — `` email-first 가입 (이메일 OTP · `auth-rules.md` §1b) 패러다임 명시 ``
- **인용처** — `auth-rules.md:1` · `:28`.
- **왜 위험했나** — ⑴ **템플릿**이라 복사될 때마다 오염이 새 문서로 번지고 ⑵ 그 항목이 하필 **App Review Information**(Play 심사 제출 서류)이라 그대로 쓰면 심사에 옛 설명을 낸다.
- **의도적 미기재** — 「심사용 test account 는 OTP 수신 가능한 주소여야 한다」는 **auth-rules 본문에 없는 파생 의무**라 템플릿 본문에 넣지 않았다(§4-5 발명 0). 관측으로만 §6 에 남긴다.

#### A6 · `docs/agent/architecture/SERVER_DATA_OWNERSHIP.md:33` — ★**규약 우선 · 조항 재작성 X** (편차 2 · §5)

- **구 문면(verbatim · 존치 · 1 char 무접촉)** — `> **근거**: 「서버에 올려도 연동 없이는 꺼낼 수 없다」 — 익명 uid 가 기기 단독이면 서버 저장의 값이 0 이다. **연동(열쇠) + 서버 저장(데이터)은 선후가 아니라 한 덩어리**다.`
- **집행문 지시** = 「★근거를 다시 세울 수 없으면 「근거 소멸」로 적고 STOP·보고」.
- ★**근거는 다시 세워졌다 · 단 조항은 고치지 않았다.** 이유 =
  - 같은 file `:5` 머리말 = 「본 문서 조항의 **변경은 새 ADR 로** 한다 — 이 file 을 직접 고쳐 덮지 않는다(§9)」
  - `§9 변경 정책`(`:221`~) = 「조항을 바꾸려면 **바꾸는 근거가 실측이어야 한다**」
  - ⟹ 본 cycle 은 **표지(annotation)만** 얹고 조항 본문은 무접촉. 재작성 = ADR 소관으로 넘긴다.
- **얹은 표지 3 문단**(`:35`~`:37`) 요지 —
  1. 전제 「익명 uid 가 기기 단독」 = **활성 자식(Selfward)에서 소멸**(2026-08-05 전환 · 구 §1 = 동결 3 계보 존치).
  2. ★**결론(연동 + 서버 저장 = 한 덩어리)은 유지**되나 근거의 형태가 바뀐다 — email-first 는 「미가입 이메일이면 **발송 호출이 곧 가입**」(`auth-rules.md §1b`)이라 **열쇠(계정)가 진입 시점에 이미 성립** ⟹ 「열쇠 부재로 서버 저장의 값이 0 이 되는」 상황 자체가 발생하지 않는다. 덧붙여 「세션 부재 = 실패 착지 · 신규 익명 fallback **0**」(같은 §1b)이라 **기기 단독 uid 로 되돌아갈 경로도 없다**.
  3. ★본 고지 = **표지 한정** · 조항 재작성은 머리말 + §9 소관.
- **인용처** — `auth-rules.md:32` · `:35`.

### B. repo-local (전파분 아님 · 각 repo 직접 commit)

#### B1 · `gently-product-docs/docs/PRODUCT-STRATEGY-SOT.md:150` (commit `9074bec`)

- **구 문면(verbatim · 존치)** — `익명 자동 시작(로그인 화면 없음·auth-rules §1)`
- **정정 문면** — `email-first 가입(이메일 OTP · auth-rules §1b)`
- **형식** — ★그 file 의 **house style 그대로**(`~~구 문면~~ 신 문면<sub>(구 판 「…」 verbatim 보존 · 사유 · 대체 좌표)</sub>`) — 같은 줄의 `~~단건 광고~~ … <sub>(구 판 「단건 광고」 verbatim 보존 …)</sub>` 선례와 동형.
- **인용처** — `auth-rules.md:1` · `:4` · `:28`.

#### B2 · `…PRODUCT-STRATEGY-SOT.md:196` (같은 commit)

- **구 문면(verbatim · 존치)** — `단일 온보딩(익명 자동 시작 · auth-rules §1)`
- **정정 문면** — `단일 온보딩(email-first 가입[이메일 OTP] · auth-rules §1b)` + `<sub>` 표지
- ★**같은 셀 안의 2026-07-26 축출분 `<sub>` 인용**(구 판 스텝 흐름 = 「스플래시 → (자동 익명 부트스트랩·auth-rules §1) → …」) = **이력 인용이라 무접촉**.

#### B3 · `app-foundation/core/supabase/README.md:37` — ★**두 겹** (commit `b474e95`)

- **구 문면(verbatim · 존치)** — `` `.claude/rules/auth-rules.md` §1 익명 부트스트랩 paradigm + §2 identity 변동성 경계 + §3 토큰 저장 의무 + §4 AuthRepository 패턴. ``
- **정정 ⑴ 경로** — `.claude/rules/` → `docs/rules/`. **실측 근거** = FND 안 `.claude/rules/auth-rules.md` **부재** · `docs/rules/auth-rules.md` **실재**.
- **정정 ⑵ 내용** — `§1 익명 부트스트랩` → `§1b email-first 가입(이메일 OTP)` · 구 §1 = 동결 3 계보 + FND 존치 표면 한정(본 모듈의 `AnonymousAuthBootstrap.kt` 존치 = 바로 그 표면 · 활성 배선 아님).
- **인용처** — `auth-rules.md:4` · `:16`~`:19`.

#### B4 · `app-foundation/core/CLAUDE.md:14` — ★**모듈 귀속 오류 동반 발견** (같은 commit)

- **구 문면(verbatim · 존치)** — `익명 부트스트랩 + UserIdentityProvider 인터페이스 (`auth-rules.md` §1~§4 정합)`
- **정정 문면(행)** — `` `AuthRepository` / `AuthError` / `UserIdentityProvider` 인터페이스 (`auth-rules.md` §2~§4 정합) ``
- **형식** — ★그 file 의 **house supersede 블록**(`core/billing` 행 선례 `:19`~`:24`) 과 동형으로 신설.
- ★**정정 근거 2 · ⑵ 가 집행문에 없던 발견** —
  - **⑴ 내용**: 활성 default = §1b (`auth-rules.md:4`).
  - **⑵ 모듈 귀속**: 익명 부트스트랩 표면은 `core/auth` 가 **아니라 `core/supabase`** 에 있다.
    - 실측 = `core/supabase/src/commonMain/kotlin/com/gently/foundation/supabase/auth/{AnonymousAuthBootstrap, AuthSessionGateway, EmailOtpAuthenticator, SupabaseAuthSessionGateway}.kt`
    - `core/auth` 실측 전수 = `AuthRepository.kt` / `AuthError.kt` / `UserIdentityProvider.kt` **3 종 단독**
    - ⟹ 구 행은 **없는 것을 이 모듈에 귀속**시키고 있었다. 같은 행의 결함이라 함께 회수(범위 확장 아님).
  - email-first seam 2 층(gateway op 5 + authenticator op 6 · `auth-rules.md:33`)도 `core/supabase` 소재 ⟹ 위 `core/supabase` 행이 이미 그 표면을 포괄. **모듈 이동 0 · 코드 0 LOC.**

---

## §3. 전파 (§3 규약)

★**명령 형식은 발명하지 않았다** — repo 규약(`scripts/propagate.sh:5` usage 블록 + `scripts/repo-config.sh:29` `TARGET_REPOS` 기본값 = `app-foundation gently-product-docs Selfward`)을 열어 그 형식을 그대로 썼다. 기본 대상이 전파 자식 3 과 일치해 `--targets` 미지정.

```
bash scripts/propagate.sh docs/rules/rule-routing-index.md docs/rules/sot-code-name-map.md \
  docs/rules/supabase-handling.md docs/rules/deferred-domains.md \
  docs/templates/release-checklist.template.md docs/agent/architecture/SERVER_DATA_OWNERSHIP.md
```

결과 = `ok=18 fail=0` (6 file × 자식 3). 이어 `bash scripts/verify-sync.sh` = **PASS 161 · DRIFT 0 · MISS 6**.
★MISS 6 = **본 cycle 유래 아님** — 직전 판(2026-08-05)과 **동수**이고 master-only file(`docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` · `docs/ops/production-cli-access-tokens.md` 등)이다.

★전파가 Selfward 에도 쓰기를 냈다 = §1.2 「SW 쓰기 0」의 **명시 예외**(§3) · §0.1 선행 게이트로 충돌 차단.

### commit (repo별 분리 · ahead/push 합 미기재)

| repo | commit | 내용 |
|---|---|---|
| claude-cli-master | `91ea579` | A 6 file + `CLAUDE.md §15` entry 1 + COLD demote 1 |
| claude-cli-master | `458f754` | verify-sync `propagation-status.md` audit |
| gently-product-docs | `9074bec` | B1·B2 (repo-local) |
| gently-product-docs | `c2f3bcf` | 전파 6 |
| app-foundation | `b474e95` | B3·B4 (repo-local) |
| app-foundation | `dac68bc` | 전파 6 |
| Selfward | `5636a18` | 전파 6 |

---

## §4. 게이트 (산술 빼고 행으로 센다)

### G1 · 4 repo `-uno` 행 출력

**진입** (§0 표와 동일) —
```
claude-cli-master     M .ai/reports/MASTER-CLI-SLOT-SPEC-AND-COMMIT-FENCE-001/REPORT.md
gently-product-docs  (0행)
app-foundation       (0행)
Selfward              M archive/INDEX.md
```
**마감** — 진입과 동일(= 본 cycle 변경분 전량 commit 착지 · 잔존 2 행 = 진입 시점 pre-existing baseline dirty · 본 cycle 무접촉).

### G2 · 변경 file 목록 — §1.1 의 9 + REPORT 이내

| # | file | 계층 |
|---|---|---|
| 1 | `docs/rules/rule-routing-index.md` | A · 전파 |
| 2 | `docs/rules/sot-code-name-map.md` | A · 전파 |
| 3 | `docs/rules/supabase-handling.md` | A · 전파 |
| 4 | `docs/rules/deferred-domains.md` | A · 전파 |
| 5 | `docs/templates/release-checklist.template.md` | A · 전파 |
| 6 | `docs/agent/architecture/SERVER_DATA_OWNERSHIP.md` | A · 전파 |
| 7 | `gently-product-docs/docs/PRODUCT-STRATEGY-SOT.md` | B · repo-local |
| 8 | `app-foundation/core/supabase/README.md` | B · repo-local |
| 9 | `app-foundation/core/CLAUDE.md` | B · repo-local |
| 10 | `claude-cli-master/.ai/reports/SELFWARD-PRELAUNCH-SWEEP-002/REPORT.md` | C · REPORT |
| ★11 | `claude-cli-master/CLAUDE.md` | **편차 3** — §15 entry 의무 (§5) |
| ★12 | `claude-cli-master/.auto-memory/master-cycle-history-COLD.md` | **편차 3** — demote 의무 (§5) |
| ★13 | `claude-cli-master/.auto-memory/propagation-status.md` | **편차 3** — `verify-sync.sh` 자동 갱신 (§5) |

⟹ **9 + REPORT = 정확히 일치 · 그 밖 3 행 = 규약 의무분**(§5 에 좌표 인용 + 사유 기록). 그 외 **0행**.

### G3 · 구 문면 존치 = 문자열 포함관계 (삭제 0 의 셈 없는 증명)

14 개 구 문면 전량을 **신 file 안에서 exact-string** 으로 다시 찾았다 — `CONTAINS-OK 14 / ★MISSING★ 0`.
(대상 = A1 1 · A2 2 · A3 2 · A4 3 · A5 1 · A6 1 · B1 1 · B2 1 · B3 1 · B4 1)

### G4 · 4-repo byte-identical — A 6 file × 4 repo sha 행

```
file                                                 master    FND       PDOCS     SW        판정
docs/rules/rule-routing-index.md                     2a7b646c  2a7b646c  2a7b646c  2a7b646c  IDENTICAL
docs/rules/sot-code-name-map.md                      3ac803cd  3ac803cd  3ac803cd  3ac803cd  IDENTICAL
docs/rules/supabase-handling.md                      9896df30  9896df30  9896df30  9896df30  IDENTICAL
docs/rules/deferred-domains.md                       05f6f4eb  05f6f4eb  05f6f4eb  05f6f4eb  IDENTICAL
docs/templates/release-checklist.template.md         f0957ae9  f0957ae9  f0957ae9  f0957ae9  IDENTICAL
docs/agent/architecture/SERVER_DATA_OWNERSHIP.md     5633e55a  5633e55a  5633e55a  5633e55a  IDENTICAL
```

### G5 · `**/src/**` · `supabase/**`(SQL·EF) diff 행 = **0행** (4 repo 전수)

### G6 · `docs/rules/auth-rules.md` sha (전 · 후) — ★**무변**

```
진입: a8c59b48 (master) / a8c59b48 (FND) / a8c59b48 (PDOCS) / a8c59b48 (SW)
마감: a8c59b48 (master) / a8c59b48 (FND) / a8c59b48 (PDOCS) / a8c59b48 (SW)
```

### G7 · 「익명」 잔존 census — ★개수 아님 · **전부 박제 또는 이력인가**를 눈으로 읽음

| file | 잔존 행 | 성격 판정 |
|---|---|---|
| `rule-routing-index.md` | `:92` | 내가 얹은 supersede 표지 **안의 구 문면 박제** ✓ |
| `sot-code-name-map.md` | `:32` `:83` | 구 문면 박제 + 스코프 표지 ✓ |
| `supabase-handling.md` | `:8` `:208` | 구 문면 박제(표지 안) ✓ |
| `deferred-domains.md` | `:46` `:50` `:52` | 구 각주 verbatim + 표지 ✓ / `:100` `:101` = **`## 6. C2 변경 이력` 절** = 이력 ✓(무접촉) |
| `release-checklist.template.md` | `:48` | 구 문면 박제(표지 안) ✓ |
| `SERVER_DATA_OWNERSHIP.md` | `:33` = 원 조항 verbatim(무접촉) / `:35` `:36` = 내 표지 안 인용 | 박제 ✓ |
| `PRODUCT-STRATEGY-SOT.md` | `:150` `:196` = 취소선 + `<sub>` 박제 ✓ / `:234` `:240` `:242` = **이력 절** ✓ / `:35` = **소셜 정의**(「익명·무수치·무응답 유통」 = auth 무관 · 정상) ✓ / `:167` = **공유 pool 성격 = 실제로 완전 익명**(§1.3 무접촉) ✓ / ★`:153` = 「**익명 1 user**」 = **현재형 잔존 · 본 cycle 좌표 밖** | §6 넘김 |
| `core/supabase/README.md` | `:38` `:40` | 구 판 verbatim + 표지 ✓ |
| `core/CLAUDE.md` | `:20` `:22` `:23` | supersede 블록 안 구 서술 + 정정 근거 ✓ |

⟹ **본 cycle 이 손댄 좌표의 잔존은 전부 「박제 또는 이력」** · 예외 1 = `PRODUCT-STRATEGY-SOT.md:153`(좌표 밖 · 넘김 · §6-①).

### G8 · 신규 file 행 출력

★**자를 함께 적는다** — `git ls-files --others` (untracked 나열)는 **본 cycle 유래 아닌 진입 시점 잔존**(`Selfward/.ai/_scratch/**` dex 다수 · 타 cycle REPORT 등)을 함께 세어 분모가 오염된다. ⟹ 「본 cycle 이 신규 생성한 file」의 자 = **commit 범위 diff**:

```
git diff --name-only --diff-filter=A f18b1bd..HEAD          # master (진입 HEAD = f18b1bd)
git diff --name-only --diff-filter=A HEAD~2..HEAD           # PDOCS · FND
git diff --name-only --diff-filter=A HEAD~1..HEAD           # SW
→ claude-cli-master/.ai/reports/SELFWARD-PRELAUNCH-SWEEP-002/REPORT.md
  (PDOCS / FND / SW = 0행)
```
⟹ **REPORT 계열 단독** · 자식 3 = 신규 생성 0(전파는 전량 기존 file 갱신).

---

## §5. 집행문 ↔ repo 규약 편차 (§4-11 「규약이 이긴다 — 좌표 인용 + 편차 기록 후 진행」)

| # | 편차 | 집행문 | 규약 좌표 | 처리 |
|---|---|---|---|---|
| **1** | A2 처분 **형태** | §2-A2 = 「정면으로 반대다」 ⟹ **무효** 표지 | `sot-code-name-map.md:4`(scope = GB/GD/GT) + `:28`/`:78`(GB/GT 절) + `auth-rules.md:38`(동결 3 = 전환 대상 X) + 집행문 §4-9(정상 확인분을 고치면 없는 결함을 만든다) | **무효 → 스코프 표지**로 전환. 구 문면 verbatim 존치는 동일. 활성 자식 실측 좌표 병기로 「현행으로 오독될 위험」은 함께 제거 |
| **2** | A6 처분 **깊이** | §2-A6 = 근거 재수립 또는 「근거 소멸」 | `SERVER_DATA_OWNERSHIP.md:5`(조항 변경 = **새 ADR** · 직접 고쳐 덮지 않는다) + `§9:221`(조항 변경 근거 = 실측) | **표지만** 얹고 조항 본문 무접촉. 결론 유지 + 근거 형태 전환을 표지에 기록 · **재작성은 ADR 로 넘김** |
| **3** | G2 **분모** | §5-G2 = 「§1.1 의 9 + REPORT 이내 · 그 밖 0행」 | master `CLAUDE.md §16.1`(모든 cli infra 변경 = §15 entry 의무) + `§16.4`/`§3 step 6`(verify-sync + propagation-status 갱신) + `cycle-discipline.md §15`(entry ≤400B · **3 초과분 즉시 COLD demote** · advisory 대기 금지) | 규약 우선 ⟹ +3 file (`CLAUDE.md` · `master-cycle-history-COLD.md` · `propagation-status.md`). 전부 **cycle 부기(bookkeeping)** 이며 내용 sweep 아님 — 집행문 §1.2 의 `.auto-memory/**` 무접촉은 「이력을 stale 이라고 고치지 마라」는 취지라 충돌하지 않는다고 판단 |

### 편차 3 의 집행 실측 (`cycle-discipline.md §15` 4 조건)

- ① 신 entry ≤400B — **362B** ✓ (동거 2 entry = 326B · 398B)
- ② 3 초과분 즉시 demote — `MASTER-CLI-RULES-TOKEN-SLOT-WRITER-001`(2026-08-02) → COLD 표 말미 verbatim append ✓ (별 demote cycle 신설 X)
- ③ COLD title / §1 heading / lineage 동기 — `150 → 151` · `+ PRELAUNCH-SWEEP-002 +1` · **13 회차 note** 신설 ✓
- ④ 제거 행이 COLD 에 verbatim 실재 — **exact-string 대조 PASS** · hot 잔존 grep `0` ✓

---

## §6. 넘김 항 (본 cycle 밖 · 좌표만 넘긴다 · 쓰기 0)

| # | 좌표 | 문면 | 사유 |
|---|---|---|---|
| ★**1** | `Selfward/supabase/CLAUDE.md:33` | `**Auth = ACTIVE** (구 판 `UNKNOWN` 폐기): 익명 부트스트랩 가동 중 — …SplashViewModel.kt:23-24…` | **집행문 §C 지정 잔여** · SW repo 축(= `SWEEP-001` 계열) · `composeApp/CLAUDE.md:30`(SWEEP-001 B2)와 **같은 문장·같은 처분** ⟹ 다음 SW cycle 이 동형 처리. ★**자동 주입층**이라 매 세션 들어간다 = 우선순위 높음 |
| ★**2** | `Selfward/supabase/CLAUDE.md:39` | `` 인증 baseline: `../docs/rules/auth-rules.md` §1 (익명 부트스트랩). `` | 동상 · pointer 이름표 (경로는 이미 `docs/rules/` 로 정확) |
| 3 | `gently-product-docs/…SOT.md:153` | `… 재사용) · **익명 1 user**.` | 현재형 잔존 · **집행문 좌표 밖**(B1=:150 · B2=:196) · MEASURE §3 미열거 = 본 cycle 신규 발견 |
| 4 | `gently-product-docs/…SOT.md:150` 말미 | `(계정 업그레이드=Phase-2 선택·GB-T02/auth-rules §6)` | `auth-rules.md:91` 이 「익명 user → 정식 계정 마이그레이션 = **전제 사망**」을 이미 명시 ⟹ 「업그레이드」 프레이밍이 낡음. 좌표는 :150 이나 집행문이 인용한 fragment 밖 |
| 5 | `app-foundation/core/supabase/README.md:38`·`:40`·`:41` | `` `.claude/rules/{billing-rules,workflow-core,code-principles}.md` `` | **B3 와 같은 경로 stale** (실측 = 3 종 모두 `docs/rules/` 로 이전 · `.claude/rules/` 부재). 집행문 B3 = `:37` 단독이라 범위 확장 회피. ★`:39` `safety-and-secrets` = `.claude/rules/` **실재** = 정상(무접촉) |
| 6 | `docs/rules/sot-code-name-map.md` | **Selfward 절 부재** (§2 GB / §3 GD / §4 GT 뿐 · title `:1` 은 4-repo 를 말한다) | 활성 자식 화면 매핑이 통째로 없다. 절 신설 = 범위 확장 · 게다가 file `:9`~`:12` 가 스스로 「전면 재매핑 = `rule-architecture` 프로그램 이관 · 그 전까지 §2~§4 = 참고용」이라 그 프로그램 소관 |
| 7 | `docs/rules/deferred-domains.md:38`~`:44` | 도메인 매트릭스 열 = `master \| GB \| GD \| GT` (**Selfward 열 부재**) | T6 재편(4-active) 미반영. 집행문 §1.3 이 「GB/GD/GT 축 = 무접촉」을 못 박아 회피 |
| 8 | `docs/templates/release-checklist.template.md:48` 파생 | 심사용 test account = **OTP 수신 가능 주소** 필요 여부 | email-first 의 자연 귀결이나 `auth-rules.md` 본문에 없는 **파생 의무**라 템플릿에 넣지 않음(§4-5 발명 0). 명문화하려면 auth-rules 측 cycle |

---

## §7. STOP 조건 대조 (§4 · 11 항)

| # | 조건 | 결과 |
|---|---|---|
| 1 | SWEEP-001 미착지 상태 집행 | **미해당** — 착지 실측 후 진입(§0) |
| 2 | 사용자 데이터 값 조회 / prod write / push | **0** (조회 0 · write 0 · `git push` 0) |
| 3 | 토큰·키·OTP **값** 접촉·기록 | **0** — 값은 한 번도 읽지 않았고 본 REPORT 에도 없다 |
| 4 | `docs/rules/**` 통째 Read | **미해당** — grep 좌표 → 국소 hunk(awk 범위 / Read offset+limit)만. 예외 = `auth-rules.md` `:1`~`:50` + `§6` = **인용 원천**이라 의도적 정독 |
| 5 | 이름·UI 문법·수치·명령 형식 발명 | **0** — UI 이름 = `SignInScreen.kt` 실측 · 호출 형태 = `auth-rules §1b` verbatim 인용 · 전파 명령 = `propagate.sh:5` usage 인용 |
| 6 | production 편집 / flavor 기동 / 빌드 | **0** (G5 = 0행) |
| 7 | `auth-rules.md` 본문 접촉 | **0** (G6 = sha 무변 `a8c59b48` × 4) |
| 8 | 행 삭제 / 구 문면 삭제 | **0** (G3 = CONTAINS-OK 14/14) |
| 9 | §1.3 목록 접촉 | **0** — `deferred-domains:100·101` · `SOT:167·234·240·242` · `master CLAUDE.md:302`(= `MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001` entry · demote 대상 아님 · 문면 무변) · `intake-router:52` · 3앱/GB/GD/GT 축 전량 |
| 10 | 무접촉 = 쓰기 0 · 읽기 허용 | 준수 — 동결 3(GB/GD/GT) 쓰기 **0** · Selfward 도메인 코드 읽기만(UI 이름 실측) |
| 11 | 집행문 ↔ 규약 충돌 | **3 건 발생 · 규약 우선 · §5 기록 후 진행** |

**STOP 발동 = 0.**

---

## §8. 미검증 (사유 = 측정치)

| # | 미검증 | 사유 |
|---|---|---|
| 1 | 정정 문면이 **실 사용자 흐름**과 일치하는가 | 본 cycle = docs-only · **flavor 무기동 · 빌드 0**(§4-6). 인용 원천을 `auth-rules.md` 현행 본문으로 한정했고, 그 rule 자체는 `SELFWARD-P2PRIME-EMAIL-FIRST-001` 이 SW 재배선 완결로 마감했다고 `:4`/`:30` 이 기재 — **그 기재를 신뢰했고 런타임으로 재확인하지 않았다** |
| 2 | `sot-code-name-map` GB/GT 행의 「(UI 미구현)」이 **지금도** 참인가 | 동결 3 = **쓰기 0 · 읽기 인용만**(§1.2 · STOP #10). GB/GT 코드 트리를 열어 화면 부재를 재실측하지 않았다 — 판정 근거는 `auth-rules.md:38`(동결 3 = 전환 대상 X)라는 **rule 층 사실**이지 코드 실측이 아니다 |
| 3 | MISS 6 의 개별 사유 | `verify-sync` 요약 수치(직전 판과 동수) + 2 건 파일명만 확인. 나머지 4 건은 열지 않았다 — 본 cycle scope 밖 |
| 4 | 넘김 항 5(`README:38`·`:40`·`:41`) 경로 정정의 **부작용** | 존재/부재만 실측(`.claude/rules/` X · `docs/rules/` O). 그 3 rule 의 § 번호가 그대로인지는 **안 쟀다** |

---

## §9. negative space (`anchor-list.md §4` · `reporting.md §13`)

**고려했으나 hot 제외 영역**: ⑴ `sot-code-name-map` 에 Selfward 절 신설(= 넘김 6 · `rule-architecture` 프로그램 소관) ⑵ `deferred-domains` 매트릭스에 Selfward 열 추가(= 넘김 7 · §1.3 이 GB/GD/GT 축 무접촉을 못 박음) ⑶ `README` 나머지 3 행 경로 일괄 정정(= 넘김 5 · 범위 확장 회피) ⑷ `SERVER_DATA_OWNERSHIP` 근거 조항 재작성(= 편차 2 · ADR 소관).
