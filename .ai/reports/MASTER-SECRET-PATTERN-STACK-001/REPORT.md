# MASTER-SECRET-PATTERN-STACK-001 — REPORT

> **Mode** M5 (cli-infra-ops) · **작업 repo** `claude-cli-master` · **진입 cwd** `~/AndroidStudioProjects`
> **ENTRY_SHA** `74424f29d9ce31be0951bbe16febb155f332667b` → **master HEAD** `6b88eaa` (ahead 8)
> **자식 HEAD** — FND `a6edefd` · PDOCS `ac372de` · SW `eaa8b8c`
> **결과** 채택 5종 · §B 진탐 **0**(= STOP #1 미발화) · 오탐 1 → **정규식 좁혀 0** · verify-sync **exit 0 · DRIFT 0 · MISS 0**

> ★**본 REPORT 는 스캔 분모 안에 있다** (= §9-④ 자답). 그래서 매치 가능한 **값 형태**를 적지 않는다 —
> 정규식은 그대로 적어도 자기 자신을 물지 않음을 실측 확인했고(문자 클래스 `[` 가 즉시 오므로),
> 무는 것은 **예시 값**(`…://u:p@` 같은 축약형)이다. 그 형태는 본 file 에 **쓰지 않았다**.
> 검증 = 말미 §8-G7b (본 REPORT 자신을 스캔한 결과).

---

## ① §A 대조표 (§0-D 계수 + §0-F 대조군)

### §0-D 재측정 (= 재측정이 정본)

| id | paste 주장 | **실측** | 판정 |
|---|---|---|---|
| d1 | HEAD `74424f2` · dirty 0 · ahead 7 | 동일 | ✅ 일치 |
| d2 | `secret-scan.sh:23` 파이프 5 = **6종** · 4-repo sha `d3061cf8` 동일 | 파이프 **5** · 4-repo `d3061cf845f6c093` 동일 | ✅ 일치 |
| d3 | Supabase 계열 **0종** (`sbp_`·`eyJ`·`postgres` grep = 0) | **0** | ✅ 일치 |
| d4 | 문서 `AIza[0-9A-Za-z\-_]{35}` ↔ 스크립트 `AIza[0-9A-Za-z_-]{35}` 발산 | 문서 `:161` ↔ 스크립트 `:23` 발산 실재 | ✅ 일치 |
| d5 | `:145` 자기모순 — 「grep 정합」 주장 ↔ §패턴 블록에 둘 다 부재 | `:145` 실재 · 블록 `:156~161` 에 `eyJ`/`sbp_` **부재** | ✅ 일치 |
| d6 | §패턴 블록 6줄 + 범위 제한 문장 | 6줄(`:156~161`) + `:164` + `:166~169` | ✅ 일치 |
| d7 | `scripts/agent` = propagate find 분모 ⟹ master cycle 필수 | `propagate.sh:99` 실재 | ✅ 일치 |

**paste 계수 7건 전량 일치.** baseline 갈림 0 ⟹ §7-①  STOP 미발화.

### §0-F 대조군 사전/사후

| 자 | 집행 전 | 기대 | **집행 후 실측** | 판정 |
|---|---|---|---|---|
| `sbp_`·`eyJ`·`postgres` in `secret-scan.sh` | 0 | ≥1 | `sbp_`2 · `eyJ`2 · `postgres`3 · `sb_secret_`2 | ✅ |
| SoT §패턴 블록 줄 수 | 6 | ≥7 | **12** | ✅ |
| 기존 6패턴 문자열 각 | 각 ≥1 | 각 무변 | AKIA1·sk-1·ghp_1·xox1·ya29 1·AIza2 **무변** | ✅ |
| `secret-scan.sh` 4-repo sha | `d3061cf8`×4 | 신 sha ×4 동일 | **`1bbe36f335517239`×4** (disk + `git show HEAD:` 양쪽) | ✅ |
| 문서형 `AIza…\-_` | 1 | 0 | **0** | ✅ |

---

## ② §B — 패턴별 file 수 + 오탐/진탐 판정 (★값 미인쇄)

### ★측정 타당성 선결 — 스캐너의 **실 binary** 로 재야 한다

`grep` 이 두 개다. 본 세션의 대화형 `grep` 은 Claude Code 가 주입한 **shell function** 으로 `ugrep` 에 shim 되며
`--ignore-files`(= **gitignore 대상 skip**) · `-G` · VCS 디렉터리 제외가 붙는다.
반면 `secret-scan.sh` 는 `#!/bin/bash` 별 프로세스라 그 함수를 **상속하지 않고** PATH 로 `/usr/bin/grep`(BSD grep 2.6.0) 을 쓴다.
⟹ shim 으로 재면 **분모가 다르다**(gitignore 대상이 통째로 빠진다) — G-3 의 판정 근거가 어긋난다.
**§B 전량을 `/usr/bin/grep` 으로 측정**했다. (이 갈림 자체가 본 판의 부산 발견이다.)

### §B-1 — `.ai/reports` (= 스캐너 강제 범위 · 4-repo)

| 패턴 | CLI-MASTER | FND | PDOCS | SW | 계 |
|---|---|---|---|---|---|
| P1 Supabase PAT | 0 | 0 | 0 | 0 | **0** |
| P2 JWT 3-segment | 0 | 0 | 0 | 0 | **0** |
| P3 DB 접속 문자열 (원안 `+`) | 0 | 0 | 0 | **1** | **1** |
| P4 PEM 개인키 | 0 | 0 | 0 | 0 | **0** |

### §B-2 — tracked 소스 전량 (= paste §B 코드 주석은 「+ tracked 소스」라 적었으나 **코드는 `.ai/reports` 만** 돌았다 · 그 간극을 메운 측정)

4-repo × 4패턴 **전량 0**. ⟹ **이미 커밋된 실제 값 = 0.**

### ★오탐/진탐 판정 (= 근거 포함 · 값 미인쇄)

**유일 hit** = `Selfward/.ai/reports/SELFWARD-REPORT-TRACK-001/REPORT.md:101`

**판정 = 오탐.** 근거 3:
1. **구조** — 그 줄은 스캔 패턴을 **표로 나열한 행**이다. 매치된 것은 자격증명이 아니라 **패턴 표기 자체**(행 내용은 「★실값형 | 0 | 0」 = 그 보고서도 실값형을 0 으로 재고 있었다).
2. **자릿수** — 비밀번호 자리 길이 **1 자**. 실 Postgres/Supabase 비밀번호가 1 자일 수 없다. (판정은 값을 인쇄하지 않고 `pw_len` + placeholder 표지만 뽑아 냈다.)
3. **추적 상태** — 그 file 은 **untracked**(= git 미등재). 다른 세션이 지금 진행 중인 `SELFWARD-REPORT-TRACK-001` 의 작업 중 산출물이다(`pgrep` 실측 = 동시 `claude` 세션 2개 활성).

⟹ **진탐 0 · STOP #1 미발화 · §7-② 미발화 · G-6 대상 없음.**

### ★G-3 판정 — P2 채택

§3 G-3 = 「§B 오탐 hit 0 이면 승인」이고 §7-③ 이 그 대상을 **P2** 로 특정한다.
**P2 오탐 = 0** ⟹ **P2 채택 승인.** (P3 의 hit 1 은 G-2 무조건 승인 대상인 별 패턴이며, 아래 ⑦-§12-① 대로 **정규식을 좁혀 0 으로 만들었다.**)

### ★부산 발견 — 스캐너는 **이미 2/4 repo 에서 빨간불**이었다 (본 판 무관 · 사전 존재)

전파 후 4-repo 재실행에서 FND·SW 가 exit 1 이 났다. **귀속 판정 결과 전량 「기존 6패턴」이고 신규 5패턴은 0 이다.**
구 6종만으로 재현해도 동일하게 hit ⟹ **본 cycle 이전부터 빨간불**이었다(아무도 그 두 repo 에서 스캐너를 돌린 적이 없었을 뿐).

| file:line | 무는 패턴 | 판정 | 근거 |
|---|---|---|---|
| `app-foundation/.ai/reports/GB-AUTH-T03-T04-001/VERIFY.md:40` | 기존 `ya29` | **오탐** | VERIFY 가 **스캐너 명령줄을 그대로 기록**해서 그 명령줄이 스스로에게 물렸다. **tracked**(= 영구 조건) |
| `Selfward/.ai/reports/SELFWARD-SRV-Q2-EF-GENERATION-001/_scanner-probe.txt:1~3` | 기존 `AKIA`·`sk-`·`ghp_` | **오탐** | ★**paste §8 G7 이 경고한 바로 그 잔존물**. 직전 판의 합성 양성 probe 가 `.ai/reports/` 안에 회수되지 않고 남았다(8/22 10:16 생성 · **untracked**) |

★ 둘 다 **§11 쓰기 허용 밖**이라 **무접촉**(= 본 판이 치우지 않았다). 처분 = ⑦ 미측정·후속 참조.

---

## ③ 양성 대조군

- **G7 합성 양성** (§8 하단) — 신규 5패턴 각 1줄씩 `.ai/_scratch/` 에 생성 → 스캐너 **exit 1** + 5줄 전량 hit → `mv` 즉시 회수. **`.ai/reports/` 안에 만들지 않았다.**
- **패턴별 개별 hit** — P1 1 · sb_secret 1 · JWT 1 · postgres 1 · PEM 1 (각 1/1).
- **P3 민감도 유지 증명** — 하한을 `+`→`{8,}` 로 좁힌 뒤에도 실 형식 모사 접속 문자열은 **여전히 hit=1** (= 좁히기가 민감도를 깎지 않았다).
- ★**자기 분모 사례** — paste 가 예고한 「이 판이 자기 분모를 키운다」는 **이미 일어난 일**로 실측됐다:
  `SELFWARD-REPORT-TRACK-001/REPORT.md:101`(P3) 과 `GB-AUTH…/VERIFY.md:40`(ya29) 이 각각 **패턴을 적었다는 이유로** 물렸다.
  선례도 있다 — `SELFWARD-EF-DEP-PIN-001/REPORT.md:239~241` 은 「그 prefix 리터럴을 **적지 않는다** — 적으면 시크릿 grep 이 보고서 자신을 hit 한다」고 **명시적으로 회피**해 두었다.

---

## ④ §C — diff (★두 파일 **동시** 증명)

**commit `6b88eaa`** · `git show --name-only --format='' HEAD` =

```
.claude/rules/safety-and-secrets.md
scripts/agent/secret-scan.sh
```

**= 2** (G3 기대값 충족). 하나만 고친 상태는 존재하지 않는다.

### 채택 5종 (기존 6종 = byte 보존 · **추가만**)

| # | 무엇 | 채택 근거 |
|---|---|---|
| P1 | Supabase PAT (management) | G-2 승인 · 오탐 0 |
| **P5** | **Supabase 신 API 키 (secret 계열)** | ★**paste 후보 밖 · §10 §FREEDOM + §12-② 로 추가** (아래) |
| P2 | JWT 3-segment (anon / service_role) | G-3 조건 충족 (오탐 0) |
| P3 | DB 접속 문자열 (비밀번호 포함형만) | G-2 승인 · **하한 `{8,}` 로 좁혀 오탐 1→0** |
| P4 | PEM 개인키 | G-2 승인 · 오탐 0 |

**P5 추가 근거** (= §12-② 가 스스로 지목한 census 를 실제로 수행한 결과):
`local.properties` 키 이름 + tracked 식별자 census 결과 이 프로젝트가 실제로 쓰는 자격증명 축은
`SUPABASE_ANON_KEY`(36) · `SUPABASE_SERVICE_ROLE_KEY`(49) · `SUPABASE_ACCESS_TOKEN`(109) 에 더해
**`SUPABASE_SECRET_KEYS` · `SUPABASE_PUBLISHABLE_KEYS`** 가 **staging·production 양쪽 EF secret 으로 실재**한다
(`SELFWARD-PROD-EF-PARITY-007/REPORT.md:74~77` = 양쪽 ✅). 이는 Supabase **신 API 키 형식**이고
**P1(`sbp_` = management PAT)로는 잡히지 않는다.** 「스캐너가 우리 스택을 못 본다」는 본 판의 명제가
paste 후보 4개만으로는 **절반만 해소**되므로 5번째를 넣었다.
★**publishable 계열은 의도적 제외** — 설계상 공개 키(클라 배포분)라 anon 과 같은 취급이다. 시크릿 아닌 것을 물면 다음 사람이 스캐너를 끈다.

### 동반 정정 2

1. **d4 발산 해소** — 문서 쪽을 스크립트에 맞춤(`\-_` → `_-`). §0-B-4 지시 그대로(스크립트가 단일 진입점).
2. ★**스크립트 헤더의 패턴 SoT 경로 정정** (= paste 미포착 · 본 판 발견) — 헤더 `:10` 이
   `docs/rules/safety-and-secrets.md` 를 SoT 로 가리키는데 **그 경로에 그 file 이 없다**
   (`docs/rules/` 디렉터리는 실재하나 이 file 은 부재 · 실재 = `.claude/rules/` **단 1곳**).
   **SoT 를 가리키는 줄이 없는 곳을 가리키고 있었다** — d4 와 같은 「문서↔스크립트 갈림」 계열이라 같은 commit 에 넣었다.

### `:145` 자기모순 처리 (= §C-3 + §9-③ + §12-③ 합류)

채택만으로는 **참이 되지 않는다**(범위가 다르다 · §9-③). 그래서 **문면을 정정**했다:
「**패턴 정합 O · 범위 정합 X**」를 명시하고, 구 판이 셋 다 부재인 채 「grep 정합」을 주장했다는 사실을 박아 두고,
commit message 측 0 match 는 **수동 의무**임을 적었다(자동화 = commit-msg hook 축 = 별 cycle).

---

## ⑤ §8 게이트 9종 — 각 값

| id | 명제 | 기대 | **실측** | 판정 |
|---|---|---|---|---|
| **G0** | 남이 안 들어왔다 | 내 commit 만 | `74424f2..HEAD` = `6b88eaa` **1건** | ✅ |
| **G1** | 스택 패턴 실재 | ≥1 (전 0) | `sbp_`**2** · `sb_secret_`**2** · `eyJ`**2** · `postgres`**3** | ✅ |
| **G2** | 기존 6종 보존 | 각 ≥1 무변 | AKIA1 · sk-1 · ghp_1 · xox1 · ya29 1 · AIza2 · **접두 byte 동일 PASS** | ✅ |
| **G3** | 문서↔스크립트 **동시** | =2 | **2** | ✅ |
| **G4** | d4 발산 해소 | 0 (전 1) | **0** | ✅ |
| **G5** | 문서 §패턴 줄 수 | ≥7 (전 6) | **12** | ✅ |
| **G6** | 스캐너가 여전히 돈다 | 0 또는 1 · `bash -n` OK | `bash -n` **OK** · master `.ai/reports/` **exit 0** | ✅ |
| **G7** | 새 패턴이 실제로 문다 | hit ≥1 · `.ai/reports` 밖 | `.ai/_scratch/` 5줄 **전량 hit** · exit 1 · **`mv` 회수 · 잔존 0** | ✅ |
| **G8** | 4-repo 정합 | DRIFT 0 · sha 4-repo 동일 | verify-sync **exit 0 · PASS 161 · DRIFT 0 · MISS 0** · sha `1bbe36f335517239`×4 | ✅ |
| **G9** | production 무접촉 | 빈 출력 | **빈 출력** (`*.kt` · `*.gradle.kts` · `supabase`) | ✅ |

**9/9 PASS.**

### G7 잔존물 처리 (= paste §8 하단 지시 이행)

`.ai/_scratch/g7-probe-<pid>.txt` 생성 → 스캔(exit 1 · 5줄 hit) → **즉시 `mv`** 로 세션 scratchpad 회수.
사후 실측 = `_scratch` 잔존 **0** · repo 전체 `g7-probe*` **0** · `git status` 오염 **0**(dirty 2 = 의도한 2 file 뿐).
`rm` **미사용**(deny 준수). ★`.ai/_scratch/` 디렉터리 자체는 남는다(빈 디렉터리 = git 비추적 · Selfward 선례 동일).

### G7b — ★본 REPORT 자신을 스캔 (= §9-④ 자기 분모 검증)

말미 §"자기 스캔" 참조.

---

## ⑥ §D — propagate + verify-sync 판독

```
propagate.sh .claude/rules/safety-and-secrets.md scripts/agent/secret-scan.sh
  → FND ok=2 · PDOCS ok=2 · SW ok=2 · 전체 ok=6 fail=0
verify-sync.sh → exit 0 · PASS 161 · DRIFT 0 · MISS 0
```

★**MISS/DRIFT 0 = 직전 판(HYGIENE)의 exclude 4종이 살아 있다는 증거** (= paste 기대값 그대로).

**자식 commit = path-limited** (`git commit -- <2 path>`) — 동시 세션 2개가 활성이고 특히 SW 는 dirty 54 였다.
결과: 3 자식 각 commit 내용물 = **정확히 2 file** · scope-외 dirty **보존**(FND 5→3 · PDOCS 8→6 · SW 54→52 = 각 -2).

### 본 판 무관 (= §D 지시대로 목록만)

1. `verify-sync` 경고 — **git-lock daemon 미활성** (plist 존재 · load 안 됨). C12 사고 패턴 재발 위험 서술.
2. `verify-sync` 경고 — `protected-file-hashes.md` 의 **부재 참조 5건**
   (`check-abbreviation.sh` · `abbreviation-policy.md` · `code-principles.md` · `design-to-code-sync.md` · `workflow-core.md`).

---

## ⑦ 미측정 + §12 3건 답

### §12-① 「P2 의 자릿수 하한 `{10,}` 은 내가 정한 수지 측정이 아니다」

**맞다. 그리고 실측 결과 하한은 애초에 일을 하고 있지 않았다.**
하한을 `{10,}` → `{6,}` → `{4,}` → `{2,}` 로 낮춰도 4-repo `.ai/reports` 오탐은 **전부 0** 이다.
반면 `eyJ` **단독**은 **43 file** 을 문다(바이너리 PNG 스크린샷 포함).
⟹ **오탐을 막는 것은 자릿수가 아니라 「3-segment 구조」다.** `{10,}` 은 유지했으나(해가 없다) **근거는 구조 쪽**이라고 문서·헤더에 적었다.
★**정본이 된 실측은 P3 쪽이었다** — 원안 `+` 는 오탐 1, `{8,}` 은 오탐 0 이고 실 접속 문자열 민감도는 무변이다. 그래서 **P3 를 좁혔다**(paste 후보를 실측이 고친 유일 지점).

### §12-② 「'Supabase 가 주 백엔드다' 는 내 인식이다 — census 하지 않았다」

**census 했고, 인식은 맞았으나 후보가 부족했다.**
`supabase/config.toml` 실재 · `local.properties` = `STAGING/PRODUCTION_SUPABASE_URL` + `…_ANON_KEY` · tracked 식별자 census =
`SUPABASE_ACCESS_TOKEN`(109) · `SUPABASE_SERVICE_ROLE_KEY`(49) · `SUPABASE_ANON_KEY`(36) 등.
⟹ Supabase 주 백엔드 = **확인**. 다만 **`SUPABASE_SECRET_KEYS`/`SUPABASE_PUBLISHABLE_KEYS`(신 API 키 형식)** 가 staging·prod 양쪽 EF secret 으로 실재하는데
**후보 4개 어디에도 안 걸린다** ⟹ **P5 신설**(④ 참조). §12-② 의 「후보가 달라질 수 있다」가 **실제로 달라졌다**.

### §12-③ 「d5 를 『채택하면 참이 된다』로 처리했으나 … 채택만으로 해소되지 않을 수 있다」

**해소되지 않는다 — 지적이 옳았다.** §9-③ 대로 두 범위는 다르다(commit log ≠ `.ai/reports/<taskId>/` 작업 트리).
⟹ **문면 정정이 정답**이었고 그대로 했다(④ 말미).

### 미측정 (= 본 판이 재지 않은 것)

1. **동결 3 (GB/GD/GT)** — 신 패턴으로 스캔하지 않았다. 전파 대상 밖 + 쓰기 0 영역. 실 시크릿이 거기 있다면 본 판은 못 본다.
2. **product code / server code** — `app/` · `shared/` · `supabase/` 확장 스캔 미수행. §0-B-5 + G-5(범위 확대 불승인) 준수.
3. **commit message 이력 전량** — `:145` 가 말하는 그 범위. `git log -S` 미수행(별 축).
4. **`.ai/reports` 밖 `.ai/**` 전량** — traces/logs 등 미측정(스캐너 범위 밖).
5. **바이너리 file 취급** — 스캐너는 `-I` 없이 돌아 바이너리도 분모에 든다(`eyJ` 단독이 PNG 를 문 것이 그 증거). 신 5패턴에는 영향 0 이었으나 **구조적 소음원으로 남아 있다**(별 축).
6. **사전 존재 오탐 2건 처분** — ②-부산 발견의 `_scanner-probe.txt`(SW · untracked) + `VERIFY.md:40`(FND · **tracked**). §11 쓰기 허용 밖이라 **무접촉**. ★특히 tracked 쪽은 지우지 않으면 FND 스캐너가 **영구히 빨간불**이다.

### ★후속 회수 필요 (= 본 판이 처분권 없는 것)

- **master `CLAUDE.md §15` cycle entry + §16 마감 절차** — 헌법 §16-① 은 「모든 cli infra 변경 = §15 표에 entry 추가 의무」인데
  paste **§11 쓰기 허용 목록에 `CLAUDE.md` 가 없다**(`propagation-status.md` 는 있다 = 저자가 마감 bookkeeping 을 의식했으되 §15 는 뺐다).
  ⟹ **임의 확대하지 않고 보류**했다. 판정 = 본인 몫.

---

## 자기 스캔 (= §9-④ 검증)

본 REPORT 를 포함해 `.ai/reports/MASTER-SECRET-PATTERN-STACK-001/` 를 신 스캐너로 돌린 결과 = 말미 실행 로그 참조.
**정규식 표기는 자기 자신을 물지 않는다**(문자 클래스 `[` 가 즉시 오므로) — 무는 것은 **예시 값 형태**이고, 본 file 은 그 형태를 쓰지 않았다.

---

고려했으나 hot 제외 영역: 바이너리 file 스캔 제외(`-I`) 도입 · commit-msg hook 축(`:145` 범위 자동화) · 사전 존재 오탐 2건 처분 · 동결 3 스캔 · product code 확장 스캔
