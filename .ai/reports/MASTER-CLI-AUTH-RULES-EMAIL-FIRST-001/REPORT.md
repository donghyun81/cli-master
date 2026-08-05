# REPORT · `MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001`

> **본질** = `docs/rules/auth-rules.md` (4-repo byte-identical) 의 default 서술을 활성 자식(SW) 실체에 정합 — 「익명 부트스트랩 = default」 → **email-first 가입 (OTP 필수 · 익명 0)**. **문면 삭제 0** (= 삭제가 아니라 스코프 라벨 + 신설 § 로 현행 default 를 세우는 형태).
> **Mode** = M5 (cli 운영 레이어 · docs-only) · **마감** = 2026-08-05 KST · **판정** = **PASS** (처분 9/9 · 전파 3/3 · 신규 drift 0 · 사고 0)
> **회부** = `R-BN` 집행 · **근거 계보** = `DECISION-SELFWARD-EMAIL-FIRST-SIGNUP-20260804` (익명 폐지 확정) → `FND-OTP-GATEWAY-001`/`-002` (FND 표면 착지) → `SELFWARD-P2PRIME-EMAIL-FIRST-001` (SW 재배선 완결)
> **paste** = `cc-paste-MASTER-CLI-AUTH-RULES-EMAIL-FIRST-001.md`

---

## §1. baseline ↔ 착지 (4-repo)

| repo | 진입 HEAD | 착지 HEAD | ahead | auth-rules sha-256(16) 진입 → 착지 |
|---|---|---|---|---|
| claude-cli-master | `47d6ea5` | **`49eadde`** | 26 | `6c54ac3cc9ebe174` → **`a8c59b48066ddb47`** |
| app-foundation (FND) | `20a1bef` | **`35d70a9`** | 9 | 동일 → 동일 |
| gently-product-docs (PDOCS) | `56d9830` | **`3b67040`** | 8 | 동일 → 동일 |
| Selfward (SW) | `a8b71bf` | **`58a05bc`** | 5 | 동일 → 동일 |

- **⑵ 신 sha 4-repo 재일치 = PASS** — `a8c59b48066ddb47` × 4 실측 일치.
- **footer 무변 = PASS** — `rule-footer-common.md` = `4bd453f93aa08f9c` × 4-repo, 진입값과 **동일** (= paste §0 예측 「편집 불요」 적중 · 무접촉 검증 항).
- ★**algorithm 주의**: 본 표 = **sha-256(16)** (= paste §0 과 동일 축). `git hash-object` (git-sha1) 과 직접 비교 금지 — 같은 파일의 git-sha1 = `c80fffd2129b7d7c`.

## §2. 진행도 인수 (= 본 세션 진입 시점 실측)

본 cycle 은 **선행 세션이 §4 step 2 까지 착지**한 상태에서 인수됐다. 진입 실측 = **dirty 2** (paste §0 예측 = dirty 1).

| 항목 | 실측 | 판정 |
|---|---|---|
| `.ai/reports/MASTER-CLI-SLOT-SPEC-.../REPORT.md` | `M` (기존 잔존) | paste §0 예측대로 · **본 cycle 무접촉** |
| `docs/rules/auth-rules.md` | `M` (30+/8−) | **본 cycle 자신의 선행 진행분** — 오염 아님 |

★**STOP #1(§0 어긋남) 미발화 근거**: paste §0 의 `6c54ac3cc9ebe174` 는 **편집 전 baseline** 이고, master HEAD blob 실측 = `6c54ac3cc9ebe174` **일치** · 자식 3 working 판도 **동일 일치**. 즉 master working 판만 어긋난 것이고 그 어긋남의 정체 = **본 cycle 이 만든 미commit 편집**. 「dirty 1 외 오염」이 아니므로 forward-progress 로 판정하고 진행 (= 사용자 지시 「진행도 확인하고 이어서 진행」 정합).

## §3. 처분 9/9 — paste §3 좌표 1:1

| 좌표 | 처분 계약 | 착지 | 판정 |
|---|---|---|---|
| `:1` | 제목 email-first 개제 | `# Auth Rules — email-first 가입 (이메일 OTP) + JSON Backup paradigm` | ✅ |
| `:3` (단일 목적) | — (계약 밖 · §FREEDOM 동반 정정) | 「자식 repo (GT/GD/GB)」 → 「활성 자식 repo (Selfward)」 + 동결 계보 = §1 라벨 영역 명시 | ✅ **F1** |
| `:15`→`:16` | §1 default 라벨 회수 + 배너 1~2줄 | heading = 「(= 동결 계보 존치 · ★활성 default 아님)」 + 배너 2줄 (`:18-19` · DECISION 인용 · SW 신규 배선 금지 · FND 표면 존치 이유) | ✅ |
| 신설 | §1b email-first (active default) | `:28-38` 신설 · 7 bullet | ✅ |
| `:42`→`:60-61` | signOut 재정의 | 활성 = 「세션 파기 → SignIn 착지」 · 구 문면 = **동결 계보 한정 라벨로 보존**(삭제 0) | ✅ |
| `:64`→`:83` | restore userId 어휘 이관 | 「현재 익명 userId」 → 「**현재 로그인 userId**」 (명제 유지) | ✅ |
| `:71-72`→`:90-91` | §6 OAuth 전제 이관 | 「email-first 계정에 OAuth identity link」 + 구 문면 = **전제 사망** 라벨 보존 | ✅ |
| `:79`→`:97-102` | §7 STOP **존치** | diff hunk **부재** 실측 (= 무접촉 증명) | ✅ |
| `:97-99`→`:117-119` | §9 변경 정책 **무변** | diff hunk **부재** 실측 | ✅ |
| `:103~`→`:127-128` | §10 entry 1 append | entry 1 + **§7 STOP 해제 문서 계보** 박제 (= `FND-OTP-GATEWAY-001` paste) | ✅ |

**diff hunk 실측** = `@@ -1 / -3 / -15 / -23,0 / -42 / -64 / -71 / -106,0` — 구 `:73~:106` 구간(= §7 + §8 + §9)에 hunk **0**. ⟹ 존치 계약 2 건이 **추론이 아니라 실측**으로 증명됨.

## §4. §1b 사실 주장 — FND disk 실측 대조 (anchor A5)

★rule SoT 는 4-repo 로 전파되므로 **문면의 사실 주장을 disk 로 확증**한 뒤 commit 했다.

| §1b 주장 | disk 실측 좌표 | 판정 |
|---|---|---|
| `signInWith(OTP){createUser=true}` | `SupabaseAuthSessionGateway.kt:53` `this.createUser = true` | ✅ |
| `verifyEmailOtp(OtpType.Email.EMAIL, …)` | 동 `:70` `type = OtpType.Email.EMAIL` | ✅ |
| gateway **email-first op 5** | `AuthSessionGateway.kt` = `requestEmailOtp:28` · `verifyEmailOtp:36` · `signOutCurrentSession:49` · `requestEmailChange:65` · `verifyEmailChange:76` | ✅ |
| `EmailOtpAuthenticator` **op 6** | `:51 requestCodeAsync` · `:62 verifyCodeAsync` · `:91 restoreSessionAsync` · `:118 discardSessionAsync` · `:138 requestEmailChangeAsync` · `:153 verifyEmailChangeAsync` (public suspend 6 · private helper 2 제외) | ✅ |
| AAB 와 **Mutex 비공유** | `EmailOtpAuthenticator.kt:44` + `AnonymousAuthBootstrap.kt:33` = **각각 `private val sessionMutex = Mutex()`** (별 인스턴스) | ✅ |
| `SignOutScope.LOCAL` + `clearSession` 사후 불변식 | 동 gateway `:99 signOut(SignOutScope.LOCAL)` → `:103 clearSession()` (throw 경로) · 근거 주석 `:88-89` | ✅ |
| uid 불변 가드 (부재 ≠ 다름) | `EmailOtpAuthenticator.kt:146-151` (다름 = 실패 표면화 · **부재 = 응답 uid 채택**) | ✅ |
| SW 익명 호출 절단 | `AnonymousAuthBootstrap` grep = **주석 3 건 단독** (`SelfwardAppContainer.kt:52` · `AuthModule.kt:31,36`) · **live 바인딩 0** | ✅ |
| SW email-first 배선 | `SplashViewModel.kt` · `SignInViewModel.kt` · `AuthModule.kt` | ✅ |

⟹ paste §3 의 「gateway 5 + `EmailOtpAuthenticator` op 6」 = **정확**. 단 gateway **전체** op 은 7 (= 위 5 + `signInAnonymously:11` + `refreshSession:17`) — 문면이 「email-first op 5」로 한정 표기하므로 오독 여지 없음.

## §5. §15 상한 규약 집행 (= `cycle-discipline.md:88` 4 게이트)

| 게이트 | 계약 | 실측 | 판정 |
|---|---|---|---|
| ① | 신 entry ≤400B | **399B** (기존 최대 = CONTEXT-DIET-3 393B) | ✅ |
| ② | 3 초과분 **즉시** COLD demote | demote 1 = `MASTER-CLI-CONTEXT-DIET-3-001` · 본 마감 step 안 집행 (advisory 대기 0) | ✅ |
| ③ | COLD title / §1 heading / lineage count 동기 | title `149 → 150` · §1 heading `149 → 150` + lineage 항 `+ AUTH-RULES-EMAIL-FIRST +1` 신설 · 「위 149 합산 밖」 → 「위 150 합산 밖」 | ✅ |
| ④ | 제거 행 COLD **verbatim 실재** (exact-string) | `grep -cFx` = **hot 0 / cold 1** | ✅ |
| — | hot 상한 3 | 착지 3 (330B · 327B · 399B) | ✅ |

★**F2 — 본 demote = 「재수록」이 아니라 distinct entry +1**: 직전 회차(SLOT-SPEC · 11회차)는 **압축판 재수록 2**(= 원문이 이미 COLD 앞자리에 실재)였으나, 본 회차의 demote 대상 `MASTER-CLI-CONTEXT-DIET-3-001` 은 demote 직전 COLD 전수 grep = **0 hit** ⟹ **최초 수록**이다. 그래서 lineage 를 `149 → 150` 으로 **증가**시켰다(재수록이면 합산 밖 유지가 맞다). 두 성격이 표에 섞이므로 COLD §1 에 **12회차 성격 note** 를 신설해 구분을 박았다 — 「`CONTEXT-DIET-3 +12 재배치`」 항은 그 cycle 이 **밀어낸 12 entry**, 신설 「`+1`」 은 그 cycle **자신의 entry** 로, 서로 다른 대상이다.

## §6. propagation 6단 (= 부모 root `CLAUDE.md §5` verbatim)

| 단 | 명령 / 산출 | 실측 | 판정 |
|---|---|---|---|
| 1 | master 변경 + commit | `49eadde` (3 file) | ✅ |
| 2 | `propagate.sh docs/rules/auth-rules.md --targets FND,gently-product-docs,Selfward` | **ok=3 fail=0** · 자식 3 = `a8c59b48066d` · `.gitignore` 신규 patch 0 | ✅ |
| 3 | 자식 staged commit (master body 인용) | FND `35d70a9` · PDOCS `3b67040` · SW `58a05bc` — **각 1 file** | ✅ |
| 4 | `verify-sync.sh` | **161 PASS / DRIFT 0 / MISS 6** | ✅ |
| 5 | `propagation-reports/<cycle-id>/REPORT.md` 자동 생성 | REPORT + DIFF + VERIFY 3 file | ✅ |
| 6 | master audit commit | 본 REPORT + `propagation-status.md` + propagation-reports 3 | ✅ |

**신규 drift 0 = 실측 (추정 아님)**: 직전 cycle REPORT V13 기록값 = **`161 PASS / DRIFT 0 / MISS 6`** — 본 cycle 착지값과 **완전 동일**. `propagation-status.md` diff = **timestamp 1줄 단독** (`2026-08-03T14:44:50` → `2026-08-05T16:01:38`).

**MISS 6 = 기존 master-only 2 file × 자식 3** (`docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` + `docs/ops/production-cli-access-tokens.md`) — 본 cycle 무관 · **의도된 master-only** (= STALE-SWEEP 에서 CHARTER 오전파를 복구한 결과).

### D-7 게이트 자기 적용 (= 직전 cycle 이 신설한 게이트)

자식 commit **직전** 3 repo 재측정 = 전부 `M docs/rules/auth-rules.md` **단독** · 타 workstream live **0** ⟹ **PASS · commit 진행**. (진입 baseline 시점 `-uno` = 3 repo 모두 **빈 문자열**이었고, 게이트 시점에도 본 cycle 전파분 외 증가 0.)
D-6 커밋 file 집합 대조 = 자식 3 × `docs/rules/auth-rules.md` 1 · master × 3 file — **paste §2 scope 와 1:1**.
D-3/D-4 정합 = 자식 commit 전량 **file 단위 pathspec**(`-- docs/rules/auth-rules.md`) · 디렉터리 pathspec 0.

## §7. ⑶ 익명 어휘 잔존 census — **무라벨 0**

`docs/rules/auth-rules.md` 전량 grep = **10 line**. 전량 분류:

| line | 성격 | 라벨 |
|---|---|---|
| `:4` | 전환 배너 (활성 = 「익명 0」 · 구 §1 재스코프 선언) | 라벨 **자체** |
| `:16` | §1 heading | 「= 동결 계보 존치 · ★활성 default 아님」 |
| `:21` | §1 본문 bullet (GoTrue 익명 user 생성) | ★**section-scoped** — 라벨은 `:16` heading + `:18-19` 배너가 담당 (line 자체에는 라벨 없음) |
| `:30` | 근거 cycle 인용 (「익명 폐지 확정」) | 이력 인용 |
| `:34` | §1b 동시 배선 **금지** | 금지 명제 (활성 맥락) |
| `:35` | 익명 fallback **0** | 금지 명제 |
| `:61` | 구 signOut 문면 | 「**동결 계보 한정** (= §1 라벨)」 |
| `:91` | 구 OAuth 문면 | 「**전제 사망** · 동결 계보(§1) 측으로만 유효」 |
| `:127` | §10 cycle 이력 | 이력 |
| `:128` | §7 STOP 해제 계보 | 이력 |

⟹ **무라벨 의도 잔존 = 0** (paste §5 「라벨과 함께만 남긴다」 충족). ★정직 기록 = `:21` 은 **line-level 라벨이 아니라 section-level 라벨**로 덮인다. §1 전체가 라벨 heading + 배너 2줄 아래에 있으므로 발췌 인용만 아니면 오독 여지 없으나, **bullet 단독 발췌 시에는 라벨이 따라오지 않는다** — 그 한계를 숨기지 않고 적어 둔다.

## §8. ★§2 표를 넘어선 실측 — 전량 열거 (정당해도 열거)

- **F1** — `:3` 「단일 목적」 줄 편집 = paste §3 좌표 표에 **부재**. 「자식 repo (GT/GD/GB)」가 그대로면 제목만 email-first 인 채 본문 첫 줄이 동결 3 을 SoT 대상으로 선언해 **자기모순**이 된다 ⟹ §FREEDOM(자구) 범위로 판단해 동반 정정. **scope 확장 아님** (= 같은 file · 같은 명제 축).
- **F2** — §5 참조 (demote 성격 = 재수록 ≠ distinct · lineage 증가 판단).
- **F3** — **타 rule 파일 「익명」 서술 census = 편집 0 · 좌표 보고만** (paste §2 마지막 항 정합). 실측 좌표:
  - `docs/rules/sot-code-name-map.md:32,83` — 「익명 인증 자동 (`AnonymousAuthBootstrap`), UI 화면 없음」 (auth-screen 행 × 2)
  - `docs/rules/deferred-domains.md:46,50,52,100,101` — GT¹/GB³/GD⁴ footnote + cycle 이력 (= **동결 3 계보 서술** ⟹ 본 전환과 무모순 · 정정 불요 가능성 높음)
  - `docs/rules/rule-routing-index.md:92` — 색인 1줄 「Supabase 익명 부트스트랩 + 토큰 저장 + JSON backup」 (= **auth-rules 제목의 구 판** ⟹ ★**stale · 별 cycle 회부 1순위**)
  - `docs/rules/supabase-handling.md:8,208` — 「`auth-rules.md` §1 — GoTrue REST 익명 부트스트랩」 (= §1 이 존치되므로 **참조 유효** · 단 §1b 미언급)
  ⟹ **본 cycle 편집 0**. 회부 판단은 Coin 몫.
- **F4** — `verify-sync` **상태문서 부재 참조 6** 경고 = 본 cycle 무관 **기존 조건**. 6 파일 전량 **디스크 ABSENT** 실측 (`check-abbreviation.sh` · `abbreviation-policy.md` · `code-principles.md` · `design-to-code-sync.md` · `domain-roles.md` · `workflow-core.md`) — JUDGMENT-SHIFT(제거) + DIET-2(`docs/rules/` 이전) 의 잔존 참조가 `protected-file-hashes.md` / `propagation-status.md` 에 남은 것. 본 cycle scope 밖 = 좌표 보고만.
- **F5** — 자식 commit 1차 시도가 **인자 순서 오류**(`-- <pathspec> -F -`)로 실패했다. `-F` 와 `-` 가 pathspec 으로 먹혀 `error: pathspec '-F' did not match` × 3. **HEAD 3 전량 무변동 실측 후** 올바른 순서(`-F - -- <pathspec>`)로 재실행 — 부분 commit / 오염 **0**. 기록 이유 = 같은 실수의 재발 방지(= pathspec commit 은 옵션 뒤에 `--`).
- **F6** — 표 밖 신설 file = **4** (본 REPORT 1 + propagation-reports 3 · 후자는 `report-gen.sh` 자동 산출).

## §9. 잔여 / 회부

- **Coin 손 잔여 = 0** (본 cycle 범위). `git push` 미실행 (= 소관 밖 · master ahead 26 / FND 9 / PDOCS 8 / SW 5).
- **회부 후보** (= 본 cycle 편집 금지 · F3 실측): `rule-routing-index.md:92` 색인 stale (1순위) · `sot-code-name-map.md:32,83` · `supabase-handling.md:8,208` §1b 미언급. `deferred-domains.md` = 동결 계보 서술이라 정정 불요 판단.
- **기존 잔존 무변 증명**: `.ai/reports/MASTER-CLI-SLOT-SPEC-AND-COMMIT-FENCE-001/REPORT.md` = 진입 시점 `M` · 마감 시점 `M` **동일** · 본 cycle commit 3 건 어디에도 **미포함** (= §6 D-6 대조표).
- **보호 5 = 접촉 0** · **동결 3 (GB/GD/GT) = 파일·커밋 0** · **production LOC = 0** · **시크릿 값 접촉 0** (`security` 명령 미실행).

## §10. Negative Space (= 고려했으나 hot 제외)

- **`rule-routing-index.md:92` 색인 1줄 동반 정정** — 같은 「구 제목 잔존」 축이라 1줄이면 끝나지만 **paste §2 가 「auth-rules.md 단독」으로 못 박고 §2 마지막 항이 「타 rule 파일 = 편집 금지 · 좌표 보고만」을 명시** ⟹ 제외 (= scope 확장 STOP 회피). F3 에 좌표 박제.
- **§1 본문 bullet(`:21`)에 line-level 라벨 추가** — §7 census 의 유일한 section-scoped 항을 line-level 로 승격하면 발췌 오독까지 막히나, 배너 2줄 바로 아래 4 bullet 에 라벨을 반복하면 문면이 뚱뚱해진다 ⟹ 제외 + **한계를 §7 에 정직 기록**으로 대체.
- **`deferred-domains.md` Auth 행 footnote 현행화** — 동결 계보 서술로서 무모순이라 stale 이 아님 ⟹ 제외.
