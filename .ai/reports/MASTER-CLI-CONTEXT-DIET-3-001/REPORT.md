# MASTER-CLI-CONTEXT-DIET-3-001 — REPORT

> **Mode** M5 (cli 운영 레이어) · **production/EF/DB/Money 0 LOC** · **보호 5 sha 무변동** · 사고 1 (자기검출·무손상)
> 마감 2026-07-29 KST · paste = `cc-paste-MASTER-CLI-CONTEXT-DIET-3-001.md` · 선행 = `MASTER-CLI-JUDGMENT-SHIFT-001` 착지 확인

---

## §0 BASELINE 재측정 (= 진입 gate)

paste 발행 시점(`d04858b7715b`) → 진입 시점 `b476f6f4c7dd` = **JS 5 commit forward-progress** (`merge-base --is-ancestor` ANCESTOR 확인 · 예상된 정상 drift). FND `456a188`→`c2626e0` · PDOCS `01c3483`→`442a9b8` · SW `94e8ccd`→`63d70d5` = 전부 JS propagate 착지분 (ancestor 4/4).

보호 5 git-sha1 = paste §0 기대치 **정확 일치**: `8b46bb4952be` · `68c6c213b18e` · `ce9c0d3e5453` · `7e70e365bb30` · `0d265e0bbc6f`. **마감 시점 재측정 = 동일** (= 무접촉 확증).

SW dirty **33** (paste 인용 32) = 전량 `??` untracked (`.ai/reports/` 4 + `archive/` 26 + `cc-paste-*`/`cc-handoff-*` 3) → 본 cycle 대상(`.claude/**`·`docs/**`·`CLAUDE.md`) 과 **교집합 ∅** → STOP §6-D **미발동**.

**§0 표 정정 1**: paste §0 은 §15 이력을 "11 rows"로 인용했으나 진입 실측 = **12 rows**(JS entry 추가분). 산술만 조정(잔여 demote 8 → 10) · 판정 불변.

---

## §1 상주 컨텍스트 실측 (= 본 cycle 목표 지표)

산출 명령 = `stat -f%z` per file · 환경 = macOS darwin 25.5.0 / zsh / `.claude/rules/*.md` glob n=6(후)·5(전) — *(A-5′ 자기적용)*

| file | 전 | 후 | Δ |
|---|---:|---:|---:|
| `CLAUDE.md` | 81,521 | **25,179** | −56,342 |
| `.claude/rules/anchor-list.md` | 14,680 | 13,455 | −1,225 |
| `.claude/rules/cross-repo-parallel-exec.md` | 15,345 | 10,397 | −4,948 |
| `.claude/rules/safety-and-secrets.md` | 10,869 | 11,379 | +510 |
| `.claude/rules/rule-routing-table.md` | 4,253 | 4,377 | +124 |
| `.claude/rules/rule-footer-common.md` | 922 | 922 | 0 |
| `.claude/rules/stop-canonical.md` **(신설)** | — | 4,749 | +4,749 |
| 부모root `CLAUDE.md` | 14,859 | 15,480 | +621 |
| **합계** | **142,449** | **85,938** | **−56,511 (−39.7%)** |

*(후 = 본 cycle §15 entry 392B 포함 마감값)*

master repo 한정(부모root 제외) = **127,590 → 70,458B (−44.8%)** · §15 이력 단독 = **57,663 → 2,506B**(= 압축 3 entry + 헤더/규약/cold note).

**★목표 대비 정직한 보고**: paste §1 목표 = "~138KB → **~60KB 대**". 실측 = **70.5KB**(master 한정) → **약 10KB 미달**. 남은 덩어리 = ① `CLAUDE.md` 잔여 25,179B(= §0/§1/§2/§6~§14a **운영 본문** · 이력 아님) ② `stop-canonical` 4,749B(= 신설분이나 자식 3 의 inline 표 2 × ~2.9KB 를 상쇄 → 4-repo 총계로는 감소) ③ `anchor-list` 13,455B(= A1~A10 GSM 3-tuple 본문). 추가 감축은 **운영 본문 자체를 줄이는 판단**이라 본 cycle scope(= 구조 다이어트 · 정보 소실 0) 밖 → 후속 의제로 보고.

**상한 규약 첫 발효 검증**: hot 3 rows(376 / 327 / **392**B) 전량 ≤400B · 초안 506B 가 규약을 자기 위반 → **규약대로 재압축 후 통과**(= 규약이 첫 적용에서 실제로 작동함을 확인).

---

## §2 작업군별 결과 (A~L)

### B — STOP 9항 → `stop-canonical.md` (Coin 본심 ③) · commit `563c3f0`

**전수 트리 판정**: 9항 표 실 복제처 = **정확히 3곳** (master + FND + SW `CLAUDE.md §5`). PDOCS 는 §5 자체 부재(thin 판 60줄).

- `.claude/rules/stop-canonical.md` 신설 → **자동 주입층 5 → 6** · 복제 **3 → 1**
- **content-parity PASS(HARD)**: 9항 표 sha `dd6bb4913a9338e0a122` = 전환 전 master §5 표와 **byte-identical** (4/4 대조) · Mode 오결정 sub-case + `BLOCKED` 경계 = verbatim · 부모root §6 특화항(동결 3 쓰기 STOP) = canonical 흡수
- pointer 재배선 8: master §5(+9항 **전량** 제목 발췌) · FND/SW §5 · PDOCS §4 · 부모root §6 · `safety-and-secrets` · `cross-repo-parallel-exec` · `anchor-list §5` · `cycle-discipline §21.4` · `gsm-measurement §7` · `rule-routing-{table,index}`
- **자식 배너 정합**: "master §5 STOP(9항) 발췌 **먼저 정독**" 의무가 소멸(= 자동 주입이라 읽지 않아도 in-context) → 배너 문면 정정
- **stale 정정 1**: 구 master §5 가 pointer 처로 열거한 `cycle-discipline §22.4` = **디스크 부재 실측**(§22 = 요약판 축소 · STOP subsection = COLD 수납) → 목록 제외
- **paste 지목 밖 정정 1**: paste 는 §4 deny 2항 발산을 **FND 만** 지목했으나 실측상 **SW 도 동일 drift** → 양쪽 복구 (`git rebase` · `git filter-branch` · `settings.json` deny 실측 정합)
- **부수 이득**: PDOCS 는 구 판에 STOP § 자체가 없었다 → propagation 으로 **STOP 가시성 신규 확보**

### A — §15 hot 상한 3 규약 (10회차 demote) · commit `9ba9dd3`

상시 로드 헌법의 **~70%(57,663 / 81,521B)** 를 cycle 이력이 차지하던 상태 해소.

- hot **12 → 2**(+ 본 entry = 3) · 각 **≤400B** (376B / 327B)
- 12 rows **전량 verbatim** → COLD append (**137 → 149 entry**) · block sha `18b282c2bfda9a43`
- **손실 0 검증**: 12/12 exact-string COLD 실재 · **압축 생존 2 행의 원문도 COLD 에 실재**(= 재작성 ≠ 소실)
- **상한 규약 명문화 2곳**: §15 헤더 + `cycle-discipline.md §15` 마감 step — *"entry 신설 시 3 초과분 = 즉시 COLD demote (advisory 대기 / 별 demote cycle 신설 금지)"*. **그 lazy 가 이력을 헌법의 70%로 키웠다** = 규약의 근거.

### C — 자동 주입층 rule 이력 → COLD · commit `8ae26ee`

자동 주입 rule 은 매 세션 상주한다 → 그 안의 cycle 이력은 상주할 이유가 없다(= 감사 시점 열람물).

- `cross-repo-parallel-exec §8`(9 entry · 5,326B) → `.auto-memory/cross-repo-parallel-exec-COLD.md` 신설 · 15,370 → 10,397B
- `anchor-list §7`(4 entry · 1,623B) → `anchor-list-COLD.md §4` append · 14,785 → 13,455B
- pointer 표기 = `claude-cli-master/.auto-memory/…` **평문**(= 상대 링크 X · `.auto-memory` 는 master-only 라 자식 판에서 상대 경로가 깨진다 · `anchor-list §1` 기존 관례 정합)

### D — skills 통합/분할 ①~⑧ · commit `347fe1c`

- **①** `paste-source-authoring` + `disk-verification` **통합** (= 구 skill **§12 가 스스로 명시한 후보** 집행). 두 skill 은 **서로를 순환 참조**했다(`disk-verification §3` ↔ `paste-source-authoring §8`) — 같은 원칙의 cowork 측/cli 측 두 적용면. **34,733 → 21,730B**(본문 8,121 + references 13,609) · 본문 전량 보존. §12 가 통합 조건으로 붙인 *"책임 분리 단일 SoT 유지"* = 통합본 **§2** 로 보존. live 참조 4곳 재배선.
- **②** `initiatives-sync` 17,350→13,073 · `runtime-crash-mitigation` 16,793→12,854 (§paste 구조·§commit body·§인접표·§이력 → `references/` verbatim)
- **③** `pencil-cli` 17,144→10,659 (§7.3 멀티-repo caveat 백과 + §12 이력 → `references/`)
- **④** skill STOP 표의 canonical 재복제 제거 → `stop-canonical` pointer. **실측**: 재복제는 통합 2 skill(3항) + `runtime-crash`(4항)에 집중 · 나머지 5 skill = **0건**
- **⑤** 시크릿 정규식 **4중 복제** → `scripts/agent/secret-scan.sh` 단일화. ★**이미 발산이 있었다**: `AIza[0-9A-Za-z\-_]{35}` vs `AIza[0-9A-Za-z_-]{35}`. exit 관례를 **뒤집었다**(0=PASS·1=FAIL — 구 판은 호출부마다 "무매치(exit 1)=PASS"를 주석으로 설명해야 했다) · 매치 시 **값 미출력 · `file:line` 만**. 검증 **4분기**(PASS/FAIL 음성대조/usage/경로부재). 배치 = `scripts/agent/`(= 전파 scan set 안 · top-level `scripts/` 는 master-only 라 자식에서 깨진다)
- **⑥** `pencil-pen-save` description — 구 판은 *"11-step new doc workflow"* 를 **현행 기능으로 광고**했으나 진입 도구 `open_document` 는 Pencil v1.1.62 에서 제거됐고 body 는 이미 "역사 기록(폐기)" 표기 중 → headless(pencil-cli) 우선으로 정정
- **⑦** `uiux-sot-refresh` "Required Read Order 11" → 판단 위임형. 그 목록은 **FULL 기준**이라 DOC-ONLY 한 건에도 11개를 다 열게 했고 `CLAUDE.md` 는 어차피 자동 주입이었다 → 필수 2 + 분류별 추가 열람 표
- **⑧** `paths:` frontmatter **무효 실측 확정** → 제거 5 + description 흡수. **근거**: master 에 `INITIATIVES.md`/`pencil-sot/`/`*.pen`/`cc-paste-*` **전량 부재**인데 해당 5 skill 이 전부 세션 listing 에 노출 = gating 하지 않는다

skills 총량 144,645 → 134,359B (+ `references/` 30,126B = trigger 시점 lazy).

### E — agents · commit `ee430f7`

★**측정 사실 먼저**: agent **body 는 상주 컨텍스트가 아니다** — 세션 주입분은 frontmatter `description` 뿐이고 body 는 호출 시점 로드. **따라서 E 의 상주 감축은 description 에서만 나온다: 5,011 → 4,593B(−418B).** body 작업은 호출당 컨텍스트 + drift 표면 축소가 목적.

- `intake-router` 9,501→7,598: 구 판은 `supabase-handling §2~§6` + `auth-rules §1~§8` **분기 전문을 복제**(본문 ~40%) → "키워드 감지 → 해당 rule 정독" 3행 표(billing 행 보강)
- "0 matches 도 기록" **복제 7** → `workflow-core §Evidence` pointer 통일. `layer-checker` 의 `|| echo "0 matches"` = 실행 명령 출력이라 대상 아님(무접촉)
- **description 집행 세부 → body 이관(삭제 아님)**: ★`reviewer` 의 *"ux-laws §6 §B + Dark Patterns · §B 누락 = REVIEW FAIL"* 과 `ux-auditor` 의 *"§5 매트릭스 22 법칙 + §3 dark patterns 5종 STOP"* 은 **description 에만 존재**했다(body grep hit **0**) — **그냥 지웠으면 의무가 소멸**했다. `test-strategist` 는 body 에 이미 실재(L11/18/28/29) → description 만 축약
- **cross-repo-orchestrator deferred 강등 = 보류(§5 자율 판단)**: 이득 = description 339B · 비용 = 참조 **7곳** 재배선(= 새 drift 표면 · STOP #2 경계). kernel 영역 1(fan-out)이 살아 있는 한 그 기제를 deferred 로 두면 부정합. deferred 의 뜻은 *"전제가 아직 없다"*(server/·DB)인데 이 agent 의 전제(4-active)는 **이미 있다** = 강등 사유 불성립. `.ai/` hit 13 = 전부 **신설 cycle 문서**(호출 흔적 아님)

### F/G/H · commit `18ea3c1`

- **F: commands 8 → 4** (실측 근거 · 추측 제거 0). 8개 **전부 stub**(body = "본문 단일 SoT = skill" · 고유 내용 0).
  - **제거 4**(`check-layer`/`plan-first`/`resume-task`/`survey`): 동명 skill 이 세션 listing 을 점유 → command description **도달 0** = 완전 사문화. **제거 직후 harness 재발행 listing 에 4개 전부 skill 로 노출 = 손실 0 실행 확증**
  - **보존 3**(`cycle-report`/`review-task`/`verify-all`): skill 이 `disable-model-invocation: true` 라 model listing 에서 빠지고 **command 가 그 자리를 채운다** → 제거 시 entry 소실
  - **보존 1**(`uiux-refresh`): skill 명(`uiux-sot-refresh`)과 달라 **유일한 alias 진입점**
- **G: `allow` 54 제거** (deny 19 + additionalDirectories 10 유지). `defaultMode=bypassPermissions` 하에서 allow 는 사문화 · deny 는 어느 쪽이든 우선. **부수 효과 = 정책 모순 2항 소멸**(`"Bash"` 광역 + `"Bash(rm:*)"` ↔ `safety-and-secrets` "rm 비가역 삭제 금지"). 4,760 → 3,565B. `pre-tool-use.sh` 무조건-allow JSON 제거(= bypassPermissions 와 판정 중복) · 실 기능(stale git lock PID 정리 + 위험 git warn) 유지
- **H: `.mcp.json`** — `supabase-gb/gd/gt` 3 제거 + `supabase-selfward` 등록. staging ref `pdaqmzmgotwodyokdkhn`(= SW `supabase/config.toml:15` 실측 일치 · `:5` 주석 "staging project") · `read_only=true` · env `${SUPABASE_ACCESS_TOKEN_SELFWARD}`(= wrap inject 실측 일치). **prod ref(`dyvib…`) 등록 0 = STOP §6-B 준수** · 평문 토큰 0(변수명만). `safety-and-secrets` slot 명세 동반 정합(동결 3 = Keychain 잔존 · 등록 해제 · 미소비 · 재조회 = Coin 회수)

### I/J/K/L · commit `94a7332`

- **I: `claude-wrap.sh` 이원화 해소.** 실사용 SoT = `~/bin/claude-wrap.sh`(근거 = `~/.zshrc:17` alias · 부모root 판은 **PATH 밖 · 어떤 alias 도 미참조 = 실행되지 않는 사본**). 부모root 사본 = SoT 본문 재동기 + 14줄 *"본 file = 사본 · SoT = ~/bin/…"* 헤더. **직전 상태 = 2026-05-19 구판**(slot 3 · miss = `exit 1` fail-fast)으로 갈라져 있었다 = 잘못된 형상 참조 위험. 본문 정합 `SoT L2- == copy L15-`(sha `1fa960cd68cafacf`) · `bash -n` 2/2 OK. **토큰 값 출력 0 재확인**(STALE-SWEEP 사고 기전 `${v:-UNSET}` 패턴 hit 0)
- **J: 부모root §2.1 FND 행** — 모듈 열거 **5건이 디스크 부재**(`shared/data`·`shared/feature-state`·`core/feature-flag`·`core/network`·`core/notification`). 실재 = **gradle 모듈 9**(`core:*` 8 + `shared:domain` 1 · `settings.gradle.kts` 실측). 열거를 되풀이하지 않고 `app-foundation/CLAUDE.md §0.2` 단일 SoT 로 넘김(= **두 번째 열거처가 곧 drift 원** · B 의 STOP 표와 같은 교훈)
- **K: `PACKAGE-OVERVIEW.md` 재저작 — 역사 층 / 현행 층 분리.** STALE-SWEEP 에서 일괄 스윕이 *"2026-06-06 에 5→6-repo 확장"* 이라는 **참인 기록**까지 덮어써 wholesale revert 됐던 파일. **재발 차단이 본질**이므로 문서 상단에 **편집 규칙**(역사 층 = 갱신 대상 아님)을 명문화하고 확장 이력을 **§0.2 표로 외화**. 현행 층 → 4-active + 3 동결 · 역사 층 → 보존(`5-repo`/`6-repo` 표기 각 **5 hit 잔존** · `MASTER-T02` 구 원장 verbatim) · §6 갱신 trigger 에 *"repo 형상 변경 = §0.2 이력 append · 구 서술 덮어쓰기 금지"* 추가
- **L: `claude doctor` 산출 = 부모root/master 전수 탐색 hit 0 → skip**(Coin 미제공)

---

## §3 propagation + 검증

- `propagate.sh` **명시 file list 39**(`--prune` **미사용** · `--all` 미사용 = run-* recipe 가드) → **ok=117 fail=0**(39 × 3)
- **삭제 5**(commands 4 + `paste-source-authoring/SKILL.md`) = 자식별 **surgical `git rm`**(= prune 경유 X)
- `verify-sync.sh` = **PASS 160 / DRIFT 2 / MISS 6** → **신규 drift 0**
  - DRIFT 2 = `release-checklist.template.md`(FND/PDOCS · **P4-lazy 의도적 미전파** · SW=✓)
  - MISS 6 = `CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` + `production-cli-access-tokens.md` **master-only × 3**
  - 둘 다 T6/T7/S3/SETTLE/JS post-state 와 **동일 = 전량 pre-existing** · **본 cycle 39 file 중 ✗ 0건**
- **보호 5 sha drift 0**(진입값 = 마감값 정확 일치 · edit-set ∩ 보호 5 = ∅ → manifest resync 불요)
- **production 확장자 변경 0건**(4-repo 전부)
- **동결 3(GB/GD/GT) 파일·커밋 0**(HEAD `a67a5a3`/`912e80a`/`6612e4d` 불변)
- **D-6 커밋 집합 대조**: 자식 3 각 **45 file**(= 전파 39 + 삭제 5 + `CLAUDE.md` 1) · **scope 밖 0** · ★**SW untracked WIP 33 무흡수**(진입 baseline 불변)

| repo | commit | files |
|---|---|---|
| master (content ×6) | `563c3f0` `9ba9dd3` `8ae26ee` `18ea3c1` `94a7332` `347fe1c` | — |
| app-foundation | `cd57483` | 45 |
| gently-product-docs | `d6f9fea` | 45 |
| Selfward | `9c7d893` | 45 |

---

## §4 사고

**1건 · 자기검출 · 무손상**: 1차 `propagate.sh` 호출에서 `$FILES` 변수를 인자로 넘겨 **zsh 미분할**로 39 경로가 **단일 인자**가 됐다 → `.mcp.json: master 부재` + `ok=0 fail=3`. **파일 복사 0 · 자식 변경 0** 확인 후 **literal 인자**로 재실행 → `ok=117 fail=0`.

★**이것은 §15 에 3회 기록된 재발 사고**(`COMPOSITION-RULES-S3-001` · `RULES-SETTLE-001` · `MEASUREMENT-DISCIPLINE-001` 이 "변수 없이 literal 인자" 로 회피). 본 cycle 은 **자식 commit 에서는 회피했으나 `propagate.sh` 호출에서 재발** — 회피 지식이 "commit" 에만 붙어 있었고 "변수로 경로 리스트를 넘기는 모든 자리" 로 일반화되지 않았다. **후속 의제로 보고**(= rule 정착 여부는 Coin 판단).

---

## §5 §6 STOP 준수

| # | 조건 | 결과 |
|---|---|---|
| A | 보호 5 접촉 0 · 자식 CLAUDE.md = propagate.sh 미경유 | ✓ (수동 surgical 단일 경로) |
| B | secret 값 echo/printf 0 · .mcp = ref 문자열만 · **prod ref 등록 = STOP** | ✓ (prod hit 0 · 평문 토큰 0 · secret-scan 도 값 미출력 설계) |
| C | 정보 소실 징후 → STOP | ✓ (전 이동분 verbatim 실재 assert 통과) |
| D | SW dirty ∩ 대상 ≠ ∅ → 보류 | ✓ (교집합 ∅ · 무흡수 확인) |
| E | docs/rules 44 광역 재편 = scope expansion → 보고만 | ✓ (무접촉) |

---

## §6 보고만 (= 발견 · scope 밖 · 자율 진입 X)

1. **★`Bash(*tmp*)` deny 광역 패턴이 세션 지정 scratchpad 를 차단한다** (paste G "재검토 보고" 대상). 실측: 본 세션의 scratchpad 는 `/private/tmp/claude-501/…` 인데 경로에 `tmp` 가 있어 **그 경로를 언급한 Bash 호출이 2회 denied**. 회피로 `~/.cache/` 를 썼다. 패턴 자체는 **유지**(deny 19 무변경) — 변경은 Coin 판단.
2. **`nightly-baseline-report.sh` = `claude -p` 사용 여부 · launchd 활성** = 본 cycle 미측정(무접촉 대상) · A6 정합 의제로 잔존.
3. **목표 미달 ~10KB** (§1) — 추가 감축은 운영 본문 축소 판단 영역.
4. **zsh 변수 미분할 회피 지식의 일반화** (§4).
5. `docs/rules` 44 구조 개편 = 무접촉(STOP §6-E 준수).

---

## §7 Negative Space Line

고려했으나 hot 제외 영역: `cross-repo-orchestrator` deferred 강등(= 참조 7곳 비용 > 339B 이득 · 사유 불성립) · `docs/rules` 44 광역 재편(= STOP §6-E) · `Bash(*tmp*)` deny 완화(= 보고만) · 동결 3(= 쓰기 0) · `PACKAGE-OVERVIEW.md` 자식 전파(= master-only 실측) · `paste-authoring-disk-verification.md` 본문 복제(= thin 유지 · 직전 cycle 판정 존중) · 보호 5 / production / EF / DB / Money = 0.
