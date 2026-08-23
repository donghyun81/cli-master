# MASTER-AIDOC-RELEASE-REALIGN-001 — 거짓말하는 문면 3본을 끄고, release 산출물 규약을 등재했다

> cycle = `MASTER-AIDOC-RELEASE-REALIGN-001` · master cycle (M5 · cli-infra-ops) · 진입 cwd = 부모 mount root → 작업 repo = `claude-cli-master` · 2026-08-23 KST
> 진입 HEAD = `8ace5a3` · branch = main · 진입 dirty(tracked) = **0** · ahead = **0**
> 자 = `sha8` = `shasum -a 256 <file> | cut -c1-8` · `grep` = **ugrep 7.5.0**(GNU 아님) · push **0** · 동결 3 쓰기 **0**
> 짝 = `SELFWARD-RELEASE-GATE-001` — **착지 후 진입**(REPORT 15:49). §D2 ②의 수는 그 §B 실측을 썼다.

---

## 0. 한 줄

**은퇴는 집행됐고, 판정은 뒤집히지 않았다 — 다만 발주 전제는 깨졌다.** §2 census 가 낸 현행층 참조는 「라우팅 표 하나」가 아니라 **8 file 12 hit** 였다. 전부 포인터이고 이 문서를 읽는 코드는 **0** 이라 은퇴가 여전히 옳았지만, 그 사실은 STOP 후 Coin 판정을 받고 진행했다. 그 과정에서 **이 판이 고치려던 병(손으로 적은 계수)을 3곳 더** 찾아 함께 고쳤다.

---

## 1. ①§A 대조표 (§0-D 인용 ↔ 실측 · 갈리면 실측이 정본)

| id | §0-D 인용 | 실측 | 판정 |
|---|---|---|---|
| d1 | HEAD `8ace5a3` · dirty(tracked) 0 · ahead 0 | 동일 | ✅ |
| d2 | 5본 sha8/행수 (`be929efd`/139 · `173c539b`/18 · `f0957ae9`/138 · `6b838eb3`/7 · `75b20064`/316) | **5/5 일치** | ✅ |
| d3 | 5본 전부 4-repo byte-identical | verify-sync 161 PASS 안에 포함 | ✅ |
| d4 | 문서 전체가 동결 3 구조 · `^## ` §1~§8 · `GB\|GD\|GT` 23 · `Selfward\|SW-` 4 · 표 행 73 | `^## `=**8** · 23 · 4 · 73 · §2 GB / §3 GD / §4 GT / §5 「GB+GD+GT 합산」 · Selfward 섹션 **0** | ✅ |
| d5 | 자기 경고문 2종 verbatim | `sed -n '9,15p'` 안에 2종 실재 | ✅ |
| d6 | 「그 외 44 rule」 ↔ 실측 43 | 일치 (44 ↔ 43) | ✅ |
| d6짝 | 「잔존 6」 ↔ 실측 6 | 일치 | ✅ (G5 진입 시 참) |
| d7 | `.github` = 전파 분모 안 · `propagate.sh:99` = `verify-sync.sh:128` | 두 find 동일 실측 | ✅ |
| d8 | `:app:` 1 hit · `GB\|GD\|GT` 행 7 | `:app:` **1** · 행 **7**(`:48 :60 :71 :81 :83 :84 :94`) | ✅ 수 일치 · ⚠ **성질 갈림 → §3** |
| d9 | 표 9행 · `REPORT\.md` 1 · `REVIEW\.md` 5 · 실물 **184** | 9 · 1 · 5 · **185** | ⚠ **+1** |
| **d10** | COLD 선례 **7본** | ★**8본** | ❌ **§0-D 오기** |

### 갈린 2건

**d10 = §0-D 자기모순.** 「7본」이라 적고 **괄호 안에 8개를 나열**했다(`abbreviation-policy`·`anchor-list`·`cross-repo-parallel-exec`·`cycle-discipline`·`master-cycle-history`·`mode-bundle`·`rule-routing-index`·`text-degeneration-prevention`). 실측 `ls -1 .auto-memory | grep -c COLD` = **8**. 선례 실재라는 §C1 의 논거는 그대로 성립(오히려 1 더 많다).

**d9 = 184 → 185.** 짝 cycle 이 15:49 에 `SELFWARD-RELEASE-GATE-001/REPORT.md` 를 만들었다. cowork 측정(14:4x)과 cli 측정(15:5x) 사이의 실제 증가분이지 오기가 아니다. **이 수 자체가 §D2 등재의 근거를 강화한다** — 스키마에 없는 산출물이 측정 중에도 늘고 있었다.

---

## 2. ②§2 참조 census 전수 (§C1 **선행** · 쓰기 0)

**양성 대조군 = 살아 있다**: `verification-and-review` = **104**(md 전수) / **37**(현행층). ⟹ 자가 죽어서 0 이 나온 게 아니다(§7-2 STOP 아님).

### 2.1 현행층 = 8 file 12 hit (★발주 전제 「라우팅 표 하나뿐」 = 파기)

| # | file:line | 성격 | 살아 있는 경로 | 처분 |
|---|---|---|---|---|
| 1 | `.claude/hooks/pre-screen-edit-pen-check.sh` ×5 (`:20 :24 :59` 주석 · `:109 :119` **stderr 출력문**) | 포인터 | ★예 (`*Screen.kt` 편집마다 발화) | 정정 |
| 2 | `.claude/rules/rule-routing-table.md:11` | L3 (Reading Mode 2) | ★예 (자동 주입층) | 정정 |
| 3 | `.claude/agents/active/ui-implementer.md:26` | consult | 예 (active agent) | 정정 |
| 4 | `docs/rules/domain-roles.md:43` | 역할 매트릭스 consult | 예 | 정정 |
| 5 | `docs/rules/rule-routing-index.md:119` | 색인 행 | 예 | 정정 |
| 6 | `docs/rules/terminology.md:41` | 어휘 표 7행 | 예 | 정정 |
| 7 | `docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md:72` | 열거 + **계수 (24)** | 예 | 정정 |
| 8 | `docs/agent/audits/TESTING-BACKFILL-AUDIT.md:81` | 「그 매핑은 stale」이라 **적은** 감사 | 점-측정 · 전파 제외 경로 | **무접촉** |

### 2.2 판정이 뒤집히지 않은 이유 (= 참조의 **성질**)

- **이 문서를 읽는 코드 = 0.** `cat`/`source`/`grep`/`awk`/`sed` 대상으로 이 경로가 등장하는 곳이 **없다**(실측). 훅의 5 hit 도 주석 3 + 안내 문자열 2 뿐.
- **보호 manifest 비등재.** `protected-file-hashes.md` 의 hit 1 건은 2026-05-10 cycle **이력 줄**(`:109`)이고, 보호 5 행(`:13~17`)은 `ui-spec.schema.json`·`uiux-sot-refresh`·`design-sot-policy`·`pencil-uiux-workflow`·`pencil-sot-policy`. ⟹ **STOP #5 아님.**
- 즉 **소비자 0인데 안내판 8개**였고, 그 중 둘(훅·라우팅 표)이 상시 살아 있는 경로에서 「가서 읽어라」라고 말하고 있었다 — 대상 문서는 스스로 「현행 보장 X」라고 적힌 채로. 이건 은퇴에 **반대**하는 근거가 아니라 **찬성**하는 근거다.
- ⟹ §12-1 대로 **STOP 후 보고 → Coin 판정 = 「예정대로 은퇴 + 참조 7 file 정정」** 으로 진행.

### 2.3 이력·박제층 = 31 file (세기만 · 무접촉)

`.ai/reports/` **21** · `propagation-reports/` **5** · `.auto-memory/` **5**(`decision-log` 1 · `incident-log` 1 · `master-cycle-history-COLD` 6 · `protected-file-hashes` 1 · `rule-routing-index-COLD` 2).

---

## 3. ③§C 3본 diff 요약 (commit `8230193` · 9 path · +35 / −24)

### C1 · 은퇴 + COLD 이관

- **신설** `.auto-memory/sot-code-name-map-COLD.md` (`6746870e` · 149행) — 헤더 10줄(이관 cycle ID · 이관 일자 · 원 경로 + 진입 sha8 · 은퇴 사유 1줄 · 비규범 · hot 복귀 trigger) + **본문 verbatim**. master only(`.auto-memory/` = 전파 find scope 밖 실측).
- **삭제** `docs/rules/sot-code-name-map.md` (`git rm`).
- **정정 7 file** = 위 §2.1 의 1~7.

★**이력 소실 0 = byte 수준 증명.** 3종 자(표 행 73 / 대표 문자열 1 / `^## ` 8) 전부 일치는 물론, 헤더 제외 본문 `diff` = **완전 일치(0)**.

### C2 · 계수 정정 — ★**같은 병을 3곳 더 찾았다**

발주서는 `rule-routing-table.md` 1곳만 지목했다. 은퇴가 분모를 줄이는 곳을 전수로 훑으니 4곳이었다:

| file:line | 구 값 | 신 값 | 성격 |
|---|---|---|---|
| `.claude/rules/rule-routing-table.md:6` | 그 외 **44** rule | **42** (+ 실측 자 병기) | 발주 지목분 |
| `docs/rules/rule-routing-index.md:3` | 42 + 6 = **48** | 41 + 6 = **47** (+ 실측 자 병기) | ★신규 발견 |
| `docs/rules/rule-routing-index.md:19` | **48** rule | **47** | ★신규 발견 |
| `docs/rules/rule-routing-index.md:33` | **49** rule 배치 | **48** | ★신규 발견 |
| `docs/rules/rule-routing-index.md:112` | UI·UX + design **(4)** | **(3)** | ★신규 발견 |
| `docs/rules/rule-routing-index.md:159` | 43 + 6 = **49** | 42 + 6 = **48** | ★신규 발견 |
| `docs/rules/rule-routing-index.md:167` | **42** rule byte-identical | **41** | ★신규 발견 |
| `CLI-MASTER-SCOPE-SEPARATION-CHARTER.md:72` | 제품-도메인 **(24)** | **(23)** | ★신규 발견 |
| `CLI-MASTER-SCOPE-SEPARATION-CHARTER.md:87` | 제품-도메인 rules**(24)** | **(23)** | ★신규 발견 |

**보존 판정 2건**: `rule-routing-index.md:160` = 「★[구 판 보존] 구 명령·구 기대」라고 **자기가 이력임을 선언**한 줄 → 무접촉. `:161` = 폐기된 제안(`layer:` frontmatter)의 서술이고 색인 자신 포함 여부가 모호 → **무접촉 + 본 REPORT 등재**(§7).

### C3 · release 체크리스트 (행 단위 판정 근거)

| 행 | 내용 | 판정 | 근거 |
|---|---|---|---|
| `:81` | `:app:bundleRelease` → **`:composeApp:bundleProductionRelease`** · 「25 MB (GB)/…」 → `<앱별 예산 · 미측정>` · 「APK 크기」 → **「출하물 크기」**(+ `(= AAB)`) | **정정** | 템플릿 본문 · d8 |
| `:71` | 권한 예시 (GB/GD/GT 실명) → `<도메인별 권한 · 미정의>` + 실측 자 병기 | **정정** | 템플릿 본문 |
| `:83` | 메모리 예시 → `<앱별 예산 · 미측정>` | **정정** | 템플릿 본문 |
| `:84` | 지연 예시 → `<도메인별 지연 예산 · 미정의>` | **정정** | 템플릿 본문 |
| `:94` | KPI 예시 → `<도메인별 KPI · 미정의>` | **정정** | 템플릿 본문 |
| `:48` | auth supersede 서술 안 「구 §1 = 동결 3(GB/GD/GT) 계보 한정」 | **보존** | ★**이력 서술**(supersede 주석 자체가 이력 표지) |
| `:60` | 「**GD**PR (휴대권 + 삭제권) flow」 | **보존** | ★**오탐** — `GD` 가 "GDPR" 안에서 매칭 |

⟹ **d8 의 「7」 = 정정 5 + 이력 1 + 오탐 1.** 발주서가 7 을 전부 동결 3 참조로 본 것은 과대계상이다.

★**부수 발견**: `:81` 은 원래 「**APK** 크기」인데 자는 `bundle`(= **AAB** 산출)이었다 — 이름과 자가 어긋난 행이었다. 「출하물 크기 … (= AAB)」로 함께 바로잡았다.

---

## 4. ④§D 2본 diff 요약 (commit `b9bc2c0` · 3 path · +80 / −7)

### D1 · `release-risk-manager` deferred → active (`c5e875a7` · 62행)

`git mv` 후 전면 재저작. 형제(`reviewer.md`) 골격 4절 준수 = `## Mission` / `## Use when` / `## Think like` / `## Key questions`(+ Decision authority · Must escalate · Expected outputs · cycle 이력). frontmatter `[DEFERRED]` 제거 · **`tools: Read` 유지(권한 확대 0)**.

Key questions 4항 = ⓐ 롤백 지점 실행 가능성(스토어 롤백 제약 포함) · ⓑ minify/R8 전용 실패 계급(리플렉션·직렬화·keep) · ⓒ 출시 대상 화면 design debt · ⓓ prod DDL/Money/Auth = STOP #1.

★**발주서 §D1-3ⓒ 의 오지목을 따르지 않았다.** 「`DESIGN-DEBT` §14 backstop」이라 했으나 `DESIGN-DEBT.md` 에 **§14 는 부재**다(실측: `§14` hit 는 전부 `design-to-code-sync §14` = 다른 문서의 절). 실 backstop 규정은 `DESIGN-DEBT.md:4` 「출시 대상 화면의 OPEN row = release 게이트 hard FAIL」 → **그쪽을 인용**했다. 없는 절을 인용하면 이 판이 고치려는 병을 agent 정의가 새로 앓는다.

### D2 · `reporting.md` (`85a858d5` · 316 → 334행)

1. §1 산출물 표 **REVIEW 행 뒤 1행 추가** — `| REPORT | .ai/reports/<taskId>/REPORT.md | cc-paste cycle 의 집행 보고 (실물 = 현행 주력 산출물) |`. 기존 9행 **무접촉**(9 → 10).
2. **§1.1 release 꼬리 신설** — ①~⑤ **정확히 5줄**(+ 헤더 1). ★**소급 의무 아님을 명문화**(§9-4 대응).
3. `verification-and-review.md` **무접촉** (sha8 `3f39d60a` 진입값 그대로 · 14-section 부활 0).

**②의 수 = 짝 §B 실측**(지어내지 않음): `./gradlew :composeApp:assembleProductionRelease --no-daemon` = **exit 0 · 75s wall**(warm = 41 executed / 354 up-to-date · R8 태스크 executed 확인). **`bundleProductionRelease` 실행 green/red = 미측정**(짝은 `--dry-run` 그래프만) · **cold 소요 = 미측정** — 둘 다 문면에 명시.

---

## 5. ⑤§8 게이트 13종 (각 값 · G3/G4 대조군 명시)

| id | 명제 | 실측 | 판정 |
|---|---|---|---|
| **G1** | 이력 소실 0 | 표 행 **73**=73 · 대표 문자열 **1**=1 · `^## ` **8**=8 · ★**본문 diff = 0**(byte 일치) | ✅ |
| **G2** | 현행층에서 사라짐 | `ls docs/rules/sot-code-name-map.md` → exit **1** (No such file) | ✅ |
| **G3** | 현행층 참조 0 | 발주 문면 그대로 = **1**(감사 1건) · 점-측정 audit 제외 = **0** · ★**양성 대조군 = 37**(≥1) | ⚠ **조건부** — 아래 |
| **G4** | 계수가 집행 후에도 참 | 라우팅 표 「그 외 **42** rule」 ↔ `ls -1 docs/rules/*.md \| wc -l` = **42** | ✅ **일치** |
| **G5** | 짝 값도 참 | 「잔존 **6**」 ↔ `ls -1 .claude/rules/*.md \| wc -l` = **6** | ✅ |
| **G6** | 실행 가능 명령 | `grep -c ':app:'` = **0** (집행 전 **1** = 음성 대조군 성립) | ✅ |
| **G7** | 발명 0 | `MB (GB)\|MB (GD)\|MB (GT)` = **0** · placeholder 5행 실재 | ✅ |
| **G8** | agent 이전 | active 존재 ✓ · deferred 부재 ✓ · `DEFERRED` hit **0** | ✅ 3/3 |
| **G9** | REPORT 등재 | `\| REPORT \|` = **1** · §1 표 데이터행 = **10** | ✅ |
| **G10** | 꼬리 5줄 | 꼬리 블록 ①~⑤ **각 1** · ⑥ **0** · 블록 = 헤더1+5 | ⚠ **자 재정의** — 아래 |
| **G11** | 14-section 무접촉 | `verification-and-review.md` sha8 **3f39d60a** = 진입값 | ✅ |
| **G12** | 4-repo byte-identical | verify-sync **PASS 161** · ★**본 판 대상 중 ✗ = 0** (DRIFT 2 / MISS 10 = 전량 본 판 무관 · §6) | ✅ (본 판 한정) |
| **G13** | production code 무접촉 | 4-repo `diff --stat -- '*.kt' '*.gradle.kts' 'supabase'` = **빈 출력** | ✅ |

### ★G3 = 조건부 PASS (고치지 않고 보고 · §10)

잔존 1건 = `docs/agent/audits/TESTING-BACKFILL-AUDIT.md:81`. **정정하지 않았다**. 사유 셋: ⓐ 성격이 **점-측정 감사 기록**(작성 시점의 관측을 박제한 문장) ⓑ 그 경로는 `propagate.sh:105` + `verify-sync.sh:139` 에서 **전파·검증 분모 밖으로 명시 제외**된 master-only 영역 ⓒ 무엇보다 그 문장은 「그 매핑표가 stale 하다」고 **적은** 쪽이라 은퇴와 모순되지 않는다. §C1-3 의 「이력·박제층 무접촉」 적용. **판정은 Coin 몫으로 남긴다.**

### ★G10 = 자 재정의 (고치지 않고 보고 · §10)

발주 문면대로 whole-file 로 재면 **집행 전부터 불가능**했다 — `reporting.md` 진입 실측이 이미 ①=3 ②=3 ③=3 ④=3 ⑤=2 **⑥=2** 다(다른 절이 원문자를 쓴다). 「①~⑤ 각 1 · ⑥ 0」은 whole-file 명제로는 성립할 수 없다. 게이트의 **의도**(= 꼬리가 정확히 5줄이고 6번째가 없다)를 보존해 **꼬리 블록 한정**으로 측정했다. 문면을 고치지 않고 이 재정의를 보고한다.

---

## 6. ⑥§E propagate / verify-sync 판독 (★삭제 전파 처분 포함)

### 6.1 propagate — `--all` 대신 명시 경로 10 (동시 세션 오염 회피)

`propagate.sh --targets FND,toward-product-docs,Selfward <10 path>` → **ok=30 fail=0** (3 자식 × 10).

### 6.2 ★삭제 전파 = 절반만 된다 (읽고 답한 뒤 실측으로 확인)

**일반 cp 흐름은 삭제를 전파하지 않는다.** `--prune` 이라는 별 모드가 `:52`(플래그) → `:144`(`if [ "$PRUNE_MODE" = 1 ]`) … `:261 exit 0` 으로 cp 흐름 **전에 분기해 빠져나간다**. 그런데 그 whitelist 가 `:150` **`PRUNE_BASE_PATHS=(.claude)`** 뿐이고 `:148` 이 「docs/ … = 자율 영역 = prune 안 함」이라 못 박는다.

**dry-run 실측이 그 독해를 그대로 확인했다**:

```
--- Selfward ---  orphan: .claude/agents/deferred/release-risk-manager.md   요약: orphan=1
```

⟹ `.claude/` 고아는 잡고 **`docs/rules/sot-code-name-map.md` 는 못 본다**. 처분:

| 삭제 대상 | 처분 | 근거 |
|---|---|---|
| `.claude/agents/deferred/release-risk-manager.md` | `propagate.sh --prune --apply` (총 orphan 3 / 실제 rm 3) | whitelist 안 |
| `docs/rules/sot-code-name-map.md` | ★**자식 3에서 각각 `git rm`** (수동) | whitelist 밖 |

### 6.3 ★`verify-sync.sh` 는 이 잔존을 **묻지 못한다** (발주서 §E 의 기대는 틀렸다)

발주서는 「`verify-sync.sh` 가 자식에 남은 파일을 DRIFT/MISS 로 물어야 정상」이라 했다. **아니다.** `:128` 의 `find` 는 **master 에서** 목록을 만들고 `:174~177` 은 master sha 가 비면 `continue` 한다. master 에서 지운 파일은 애초에 목록에 없으므로 자식 잔존본은 **영원히 보이지 않는다**. verify-sync 는 「자식에 **없음**(MISS)」을 잡지 「자식에**만** 있음」을 잡지 않는다. ⟹ 삭제 전파를 verify-sync 로 사후 검증하려는 설계는 성립하지 않는다.

### 6.4 ★`propagate.sh:149` 의 `--include` = 유령 플래그

`:149` 주석은 「cli infra 외 영역 추가 = `--include <path>` flag 사용 (Coin 명시 의무)」라 적었으나 **파서(`:42~73`)에 그 플래그가 없다**. `--all`/`--targets`/`--prune`/`--apply`/`--help` 뿐이고 `--include` 는 `:64` `-*)` 에 걸려 `unknown flag` **exit 2**. ⟹ **이 판이 고치려는 병(실행 불가 명령을 적은 문면)이 집행 도구 안에도 있다.** 본 판 scope 밖이라 고치지 않고 등재한다(§7).

### 6.5 verify-sync 판독 — DRIFT 2 / MISS 10 = **전량 본 판 무관**

```
PASS: 161 · DRIFT: 2 · MISS: 10
```

| file | 상태 | 진입 시점(HEAD~1)에도 그랬는가 |
|---|---|---|
| `docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` | MISS ×3 | ✅ 진입 시 자식 3 전부 **부재** |
| `docs/ops/production-cli-access-tokens.md` | MISS ×3 | ✅ 진입 시 자식 3 전부 부재 |
| `docs/stale-sweeps/README.md` | MISS ×2 + SW DRIFT | ✅ 진입 시 동일 |
| `docs/stale-sweeps/SWEEP-20260817.md` | MISS ×2 + SW DRIFT | ✅ 진입 시 동일 |

**본 판 대상 file 중 ✗ = 0.** §7-4 대로 **흡수하지 않았다**(남의 판).

★**그 중 charter 는 내가 한 번 건드렸다가 되돌렸다.** 명시 경로 propagate 에 포함시켰더니 자식 3에 **신규 파일로 들어갔다**(진입 상태 = 부재). 내용 정정(24→23)은 master file 의 일이지 **자식 도입 여부는 전파 scope 결정**이라 §8 G12 「그 외는 진입 상태 보존」에 따라 **자식분을 `git rm` 으로 되돌렸다**(master 판은 유지). ⟹ charter 의 MISS×3 은 진입 상태 그대로 보존됐다.

### 6.6 자식 commit (path-limited · master sha 인용)

| repo | 진입 HEAD | 본 cycle commit | 대상 |
|---|---|---|---|
| app-foundation | `329fd8b` | `b710f25` | 11 path (수정 9 + 삭제 2) |
| toward-product-docs | `d80f955` | `3c64088` | 동일 |
| Selfward | `0ef812f` | `eaddc95` | 동일 |

`git add -A` **미사용** · 경로 명시 · pre-existing scope-외 dirty(FND untracked 3 · PDOCS `incident-log-cowork.md` 등 · SW `incident-log.md` 외 다수) **전량 보존**.

**자식 측 계수 정합 실측** — 3 자식 전부 `docs/rules/*.md` = **42** · `.claude/rules/*.md` = **6** ⟹ 라우팅 표의 주장이 **4-repo 전역에서 참**.

---

## 7. ⑦미측정 / UNKNOWN + Coin 회부

### 7.1 미측정 · UNKNOWN

1. **`bundleProductionRelease` 의 green/red = 미측정.** 짝은 `assemble` 만 실행했고 bundle 은 `--dry-run` 그래프만 떴다(짝 §8-5). §C3 이 체크리스트에 박은 명령은 **태스크 실재는 확인됐으나 실행 검증은 안 된** 명령이다. AAB 산출 + 번들 서명의 성립 여부는 별 판.
2. **cold 캐시 소요 = 미측정.** 75s 는 warm(41 executed / 354 up-to-date).
3. **`rule-routing-index.md:161` 의 「42 file」 = 판정 보류.** 폐기된 제안 서술이고 색인 자신 포함 여부가 모호해 무접촉. 재계수 시 41 일 수 있다.
4. **`docs/agent/audits/TESTING-BACKFILL-AUDIT.md:81`** = G3 잔존 1건(§5 사유). 처분 = Coin.
5. **`propagate.sh:149` `--include` 유령 플래그** (§6.4) = 본 판 scope 밖 등재.
6. **verify-sync 가 자식-단독-잔존을 구조적으로 못 본다** (§6.3) = 도구 공백 등재. 삭제 전파를 하는 cycle 은 **자식별 수동 확인 의무**가 있다.
7. **charter 의 상시 MISS×3** (§6.5) = 전파 find scope 안인데 자식 미보유. `docs/agent/audits/*` · `docs/release-readiness/*` 처럼 **명시 제외 등재**가 맞는지 = Coin 판정 대상.
8. **verify-sync 부수 경고** — `protected-file-hashes.md` 가 부재 파일 5종을 참조(`check-abbreviation.sh` · `abbreviation-policy.md` · `code-principles.md` · `design-to-code-sync.md` · `workflow-core.md`). 본 판 무관 · 미접촉.

### 7.2 §12 「나를 의심하는 절차」 3항 — 그대로 싣고 답한다

**§12-1 「은퇴가 정답」은 판정이지 측정이 아니다 — census 가 활발한 참조를 드러내면 뒤집힐 수 있다.**
→ **부분적으로 적중했다.** 참조는 발주 전제의 8배(8 file 12 hit)였고 둘은 상시 발화 경로였다. **STOP 하고 보고**했다. 다만 참조의 성질이 전부 포인터(소비자 0 · 보호 manifest 비등재)여서 판정은 유지됐고, **Coin 이 「예정대로 은퇴 + 참조 7 file 정정」으로 확정**했다.

**§12-2 `rule 후보 9`(memory)의 pending 등재를 은퇴가 소멸시킨다 — 맞는 처분인지 REPORT 에 명시하고 Coin 판정을 받아라.**
→ **Coin 판정 = 「소멸이 맞다 · REPORT 에 명시하고 닫음」.** 대상 문서가 사라지므로 그 문서를 겨냥한 pending 등재도 함께 소멸한다. **본 항으로 닫는다.** (재수립이 필요해지면 그건 Selfward 화면 census 선행의 별 판이고, 그 진입점은 COLD 파일 헤더의 「hot 복귀 trigger」에 박아 뒀다.)

**§12-3 `:composeApp:bundleProductionRelease` 는 cowork 이 이름을 조합한 것이다 — 짝이 실명을 확정한다.**
→ **조합한 이름이 맞았다.** 짝이 `--dry-run` 으로 태스크 그래프를 떠서 `:composeApp:` **91 태스크** + 고유 꼬리(`packageProductionReleaseBundle` · `signProductionReleaseBundle` · `buildProductionReleasePreBundle`)를 확인했다(짝 §2). ⟹ 실재하는 태스크명. **단 실행 검증은 assemble 쪽만** 됐다(§7.1-1).

### 7.3 §9 반증 5문항 (구현 **전** 답변)

**⑴ 은퇴시키면 무엇이 나빠지는가** — 셋이 빈다: ⓐ 훅이 `.pen` 부재 warn 을 낼 때 「명명 차이로 인한 오탐일 수 있다」고 안내할 근거처 ⓑ `ui-implementer` 의 Pencil entry gate 가 SoT명↔코드명 차이를 참조할 자리 ⓒ `terminology.md:41` 「화면명 매핑」 어휘 항목의 대상. **셋 다 지금도 GB/GD/GT 표만 주므로 활성 자식에겐 이미 무용** — 잃는 것은 실체가 아니라 자리다. 그래서 셋 다 **자리를 지우지 않고 문면을 살렸다**(훅·agent 는 「명명 차이를 먼저 의심하고 `docs/design/pencil-sot/` 를 직접 훑어라」로 · terminology 는 「현행 SoT 부재 + COLD 경로」로).

**⑵ `propagate.sh` 가 삭제를 전파하는가 — 읽은 행 번호** — §6.2 (`:52` · `:144` · `:150` · `:148` · `:218~222` · `:257`). **일반 cp = 안 한다 · `--prune` 은 `.claude/` 만.** 실측으로 확인 완료.

**⑶ 「43」을 박으면 언제 거짓이 되는가** — ★**이 판의 §C1 직후.** `git rm` 이 분모를 43 → 42 로 줄이므로 43 은 커밋되는 순간 이미 틀린다. 그래서 §C1 뒤에 재계수한 **42** 를 썼고, **실측 자를 병기**해 다음 사람이 손으로 믿지 않고 다시 셀 수 있게 했다.

**⑷ `REPORT.md` 등재가 기존 185본을 소급 위반으로 만드는가** — 문면을 **기술(記述)로 쓰면 안 된다.** 「cc-paste cycle 의 집행 보고(실물 = 현행 주력 산출물)」처럼 *있는 것을 적는* 형태면 스키마 현행화지 신 의무가 아니다. 「모든 cycle 은 REPORT.md 를 생성해야 한다」로 쓰면 그 순간 185본과 REPORT 없는 과거 cycle 전부가 소급 위반(STOP #2)이 된다. 필수 절 수·형식을 그 행에 매달지 않은 것도 같은 이유이며, **§1.1 에 「소급 의무 아님」을 명문화**했다.

**⑸ 꼬리 ②를 짝 없이 채울 방법** — 필요 없었다. **짝이 착지한 뒤 진입**했다(짝 REPORT 15:49). ②의 수 = 짝 §B 실측(exit 0 · 75s warm). 미측정분(bundle 실행 · cold)은 **`<미측정>` 으로 남기고 지어내지 않았다.**

---

## 8. 산출물 sha (최종)

| file | sha8 | 행 |
|---|---|---|
| `.auto-memory/sot-code-name-map-COLD.md` (신설 · master only) | `6746870e` | 149 |
| `docs/rules/reporting.md` | `85a858d5` | 334 |
| `.claude/rules/rule-routing-table.md` | `a318aa33` | 18 |
| `docs/templates/release-checklist.template.md` | `d994a364` | 138 |
| `.claude/agents/active/release-risk-manager.md` | `c5e875a7` | 62 |
| `docs/rules/verification-and-review.md` (**무접촉 증명**) | `3f39d60a` | — |

보호 5 sha 변동 **0** · production Kotlin/`supabase/`/`.github/workflows/` 접촉 **0** · 동결 3 쓰기 **0** · push **0**.

---

**고려했으나 hot 제외 영역**: Selfward 판 화면 매핑 신설(= G-7 불승인 · 화면 census 선행 별 판) · `.github/workflows/ci.yml` 신설(= G-8 불승인 · 전파 분모 안이라 Gradle 없는 PDOCS·master 까지 번짐 · ⓓ CI-VERIFY 몫) · `docs/agent/audits/TESTING-BACKFILL-AUDIT.md:81` 정정(= 점-측정 박제 · 전파 제외 경로 · Coin 회부) · `rule-routing-index.md:161` 「42 file」(= 폐기 제안 서술 · 분모 모호) · `propagate.sh:149` `--include` 유령 플래그 제거(= 집행 도구 수정 = 별 scope) · `verify-sync.sh` 에 자식-단독-잔존(EXTRA) 검출 추가(= 도구 신설 · 별 판) · charter 전파 scope 확정(= MISS×3 상시 · 명시 제외 등재 여부 = Coin) · `protected-file-hashes.md` 의 부재 파일 5종 참조 정정(= 본 판 무관 · verify-sync 부수 경고) · `docs/ops`·`docs/stale-sweeps` MISS/DRIFT(= 남의 판 · §7-4 흡수 금지).
