# MASTER-STALE-TRACKING-001 — REPORT

> Mode M5 (cli 운영 레이어형) · 2026-08-17 KST · 제품 코드 **0 LOC** · 보호 5 sha **변동 0** · 자동 주입 file 수 **증가 0**.
> 진입 = 부모 mount root cwd (§3.2 paradigm) · 영역 1/2/3 sub-agent spawn **0** · `claude -p` **0**.

---

## §1. BASELINE 재측정 (진입 · paste §0.1 대조군은 인용 안 함)

| repo | paste 기대 | **실측(진입)** | dirty(선재) | 판정 |
|---|---|---|---|---|
| `claude-cli-master` | `791778d` | `791778d` | 1 | 일치 |
| `Selfward` | (재측정) | `3b8d4bf` | **7** (paste 대조군 2) | 재측정판 채택 |
| `app-foundation` | `e792c40` | `e792c40` | 3 | 일치 |
| `toward-product-docs` | `34b6ecd` | `34b6ecd` | 4 | 일치 |
| 동결 3 | `a67a5a3`·`912e80a`·`6612e4d` | 동일 | 104/74/70 | 일치 · **쓰기 0** |

★**세션 중 SW dirty 가 7 → 17 로 증가** = **다른 cli session 이 Selfward 에서 동시 작업 중**(제품 코드 13 M + untracked 4). 전 자식 commit 을 **path-limited** 로 집행해 흡수 0 (§5 검증). 그 세션의 편집 대상에 본 대장 1행의 좌표(`story/handler.ts`)가 포함되어 있었다 — §4 에 그 결과.

## §2. §0.3 선례 5 직접 재확인 (cowork 인용 ↔ disk 실측)

| 선례 | cowork 인용 | 실측 | 판정 |
|---|---|---|---|
| `legacy-cleanup-governance.md` | `87409f0a` · 201행 · 「적용 범위」 표가 문서형·조사형·ops-layer 제외 | **일치** (`87409f0a` · 201행) | ✓ |
| `MEASURE-CROSSREPO-DOC-STALE-20260809.md` | `e72f946b` · 127행 · 1회성 감사 | **위치 정정** — 4-active repo 안 **부재** · 실물 = **부모 mount root** (`./MEASURE-CROSSREPO-DOC-STALE-20260809.md` · 127행) | 위치만 갈림 · 내용 일치 |
| `DESIGN-DEBT.md` | routing-table §141 참조 · deferred lane 대장 | **Selfward 단독 실재** · 725행 · 6칸 표 | ✓ (§3 에 형태 대조) |
| `rule-routing-index.md` amend loop | 「자동 신설 X · 사용자 confirm 후 master cycle」 + 정량 trigger 3 cycle | **일치** (§C · 실측 행 = 색인 `:148` → 현 `:149`) | ✓ |
| `rule-routing-index.md` 등재 규약 | §A 1행 + routing-table 동기 · 본문 복제 금지 | **일치** (§D-1 · 실측 `:154` → 현 `:155`) | ✓ |
| `cycle-discipline §2` L1-1 | OPS 신설 금지 + L1-1 예외 | **일치** — 아래 verbatim | ✓ |

### `cycle-discipline.md §2` verbatim (= `docs/rules/cycle-discipline.md` · sha8 `e5f54715` · 161행)

```
### 2) OPS 신설 금지 원칙

- 새 룰 박기 전 **도메인 매칭 검증 1회 필수** — 기존 룰 도메인에 안 속하면 신설하지 않는다 (운영 메모로만 유지).
- 본 작업 무관 OPS hygiene task 신설 금지 — 사고가 본 작업을 직접 블로킹할 때만 처리 (lazy mode).
- **예외 (L1-1)**: 사용자 본심 외화 영역 = 신 rule 허용 (본인 명시 결정 + paste umbrella §3 contract 측 본심 인용 의무).
```

**판정 = 신설 허용 · STOP 미발동.** 근거: ⑴ 첫 bullet 은 「기존 룰 도메인에 **안 속하면** 신설하지 않는다」이므로, §3 의 「겹침 0」 결론은 그 자체로는 **신설을 막는 쪽**으로 작동한다 — 즉 공백 확정이 신설 정당성이 되지 못한다. ⑵ 그 유일한 escape 가 L1-1 이고, 요건 2개(**본인 명시 결정** = Coin 직접 지시 2026-08-17 · **paste umbrella §3 contract 측 본심 인용**)를 paste 가 충족한다. ⑶ `rule-routing-index.md §C` Mode 5 deviation 열이 같은 분기를 명문화한다 — 「신 rule 도메인 매칭 실패 = `cycle-discipline §2`(OPS 신설 금지) **또는 L1-1 예외 본심 회수**」.

## §3. §9 「나를 의심하는 절차」 5항 — 전량 집행

### ⑴ ★★핵심 — `legacy-cleanup-governance` 와 상보인가, 겹치는가 (201행 전문 정독)

**결론 = 겹침 0 · 「공백 확정」 참 · 신 rule 유지(확장 아님).**

값 층 자 (파일 전문 대상 · 어휘별 hit):

| 어휘 | hit |
|---|---|
| `주석` / `KDoc` / `docstring` / `문면` / `stale` / `낡` | **각 0** |
| `Drift` | **1** — `:15` 「\| 문서형 task (DocSync, **Drift Audit**) \| **적용 안 함** (선택적) \|」 |

cowork 가 지목한 4 절 전수 확인: `:52` Deferred Cleanup = TODO.md 에 **코드 제거 보류** 기록 형식 · `:104` 제거 우선 대상 = Composable/View/mapper/adapter/style mapping/navigation branch/feature flag = **전량 코드 심볼** · `:116` 제거 금지·STOP 대상 = auth/payment/DB/manifest/reflection/DI = **전량 코드 경로** · `:141` EVIDENCE 기록 규약 = **Cleanup Assessment(제거 후보 표)**. ⟹ 문면 drift 를 다루는 절 **0**.

★그 rule 이 문서 drift 에 닿는 **유일한 접점이 「우리는 그것을 다루지 않는다」는 명시적 제외**(`:15`)다. 확장하려면 그 「적용 범위」 표를 다시 써야 하는데, 그것은 paste §0.2 #4 계약(**본문 무변 · 자매 pointer 1줄만**)과 정면 충돌한다. ⟹ **자매 신설이 정본 경로.**

### ⑵ ★`DESIGN-DEBT.md` 실물 형태 대조 → **DESIGN-DEBT 쪽을 따랐다**

실측 = `Selfward/DESIGN-DEBT.md` **725행** · 6칸 = `화면 | 변경(visible state) | 등재 cycle/date | 분류 | 해소 task | status`. 해소 관용 = **행 삭제 0 · `status` 를 `OPEN`→`RESOLVED` 로 전이**(rows 8~34 전량 잔존 실측).

paste §3-A⑷ 의 7칸 안(`발견일 | 좌표 | 낡은 문면 | 실측 정본 | cycle | 처분 | 위험`)과 갈리는 지점 = ⓐ 발견일·cycle 분리 ⓑ **`status` 칸 부재**(「처분」이 처분 종류와 진행 상태를 겸함). ⓑ 는 §3-A⑹ 의 「해소는 **상태 칸** 갱신」과 직접 충돌한다. ⟹ **DESIGN-DEBT 6칸으로 수렴**하되 7 정보항 전량 보존:

| 계약 항 | 채택 칸 |
|---|---|
| 좌표(file:앵커) | 좌표 |
| 낡은 문면 요지 + 실측 정본 | 낡은 문면 → 실측 정본 |
| 발견일 + 발견 cycle | 등재 cycle/date |
| 위험 | 위험 |
| 처분 | 해소 경로 |
| — (신설) | **status** |

### ⑶ ★`MEASURE-CROSSREPO-DOC-STALE` §7·§8 정독 → cowork §1⓶ 서술 = **정확 (단 1줄 보정)**

- §7 처분 제안 = 「`SWEEP-001` 에 넣지 않는다 ⟹ **별 paste = `SWEEP-002`(cross-repo)**」 + 우선순위 4 묶음. **「상설화」 제안은 없다** — 제안된 것은 **또 하나의 1회성 회차**다.
- §8 미상 3 = 광고 축 / 나머지 문서 stale / `.claude/commands/**`·`docs/agent/**` — 전부 **측정 범위 공백**이지 기제 제안이 아니다.
- ⟹ cowork §1⓶(「1회성 산출물이라 그 뒤에 새로 낡은 것은 다시 무주공산」) = **참**. 본 cycle 은 그 제안의 집행이 아니라 **그 형태의 상설화**다.
- **보정 1줄**: §7 이 제안한 `SWEEP-002` 는 **실제로 집행됐다** (= `archive/2026-08/cc-paste-MASTER-DOCS-STALE-SWEEP-002.md` 실재). 그 문서 frontmatter 의 `정리trigger: SWEEP-002 paste-back 마감` 도 충족. ⟹ 「제안이 방치됐다」가 아니라 「**집행됐고, 그래도 다음 낡음을 받을 그릇이 없었다**」가 정확한 서술이다.

### ⑷ ★sweep trigger 가 상시 red 인가 — 시뮬

| trigger | 현 상태 | 판정 |
|---|---|---|
| ⓐ OPEN 10행 | SW 대장 OPEN **3** · master 대장 OPEN **1** | 미발동 |
| ⓑ 분기 1회 | 직전 = 없음(신설) | 다음 분기 |
| ⓒ 동일 좌표 3 cycle 재발 | `SELECTED_LOG_CAP` 축이 **1 cycle 에 2 좌표** 관측 | 관측 시작 |

★단 **한 번의 전수 감사가 13 좌표를 낳은 실적**이 있다(`MEASURE-CROSSREPO-DOC-STALE` §1 A 4 + §2 B 6 + §3 C 2 + §4 D 1). 그 급의 census 를 한 번 더 돌리면 ⓐ 는 **즉시 넘는다**.

**그럼에도 「trigger 가 아니게 된다」는 결론은 기각한다** — cowork 의 우려는 blocking gate 를 전제한다. 본 trigger 의 결과는 「**sweep cycle 1회 개설**」이라는 **일정 신호**이고, 등재 자체는 §3 이 「등재하면 진행 허용」으로 못 박아 cycle 을 멈추지 않는다. 부채가 많으면 sweep 을 여는 것이 정확히 의도한 동작이다. ⟹ **값 유지**. 대신 cowork 가 지목한 진짜 위험(「100행이 되면 아무도 안 읽는다」)에 대응해 rule §5 에 **읽기 자 = OPEN 우선** 1줄을 넣었다 — 자매 `DESIGN-DEBT.md` 가 **725행에서도 기능하는 이유**가 그 관용이다(RESOLVED 는 아래로 눕고 OPEN 만 읽는다).

### ⑸ ★hook 유혹 기각이 충분한가 — **본 cycle 이 반증 자료를 스스로 생산했다**

「자동 등재」의 가장 가까운 실물 후보 = `scripts/verify-sync.sh` 의 **「상태문서 부재 참조」 경고**. 본 cycle 실행분에서 그것이 **6건**을 뱉었고, 전수 열어 층을 가르니 **6 중 5 가 이력 절**이었다(`## 신설 cli infra (C2.5)` 2건 · `## GLOBAL-NO-ABBREV-POLICY-002 갱신 cli infra (2026-05-10)` 1건 · `~~...~~ (소멸)` 취소선 2건). 살아 있는 것은 **1건**.

⟹ 경로 문자열 자는 **층을 못 본다**. 자동 등재였다면 이력 5건이 대장에 박히고, rule §1 마지막 행(= 이력은 낡는 게 맞다)이 **첫 cycle 에 깨졌을 것**이다. 이것이 `MASTER-CLI-JUDGMENT-SHIFT-001`(hook 17→14 · 판단 위임) 방향과 충돌하지 않는 이유의 **실증**이고, rule §7 에 그대로 적었다. hook 신설 = 별 cycle · Coin 회부(불변).

## §4. 대장 등재 결과 + census-독립 그물 (paste §7⑺)

시드 4 좌표를 **전부 직접 열어** 재현했다. 결과 = **재현 3 · 기각 1 · 신규 발견 1**.

| # | 좌표 | 재현 | 비고 |
|---|---|---|---|
| 1 | `story/handler.ts` 앵커 `재료 검증·상한(60)` | ✓ | 정본 = 같은 파일 `const SELECTED_LOG_CAP = 10` |
| 2 | `RepoFiles.kt` 앵커 `주석은 원소가 아니므로…` | ✓ | 정정 append **착지 확인**(같은 파일 `★[구 판 보존] …2026-08-17 실측으로`) → RESOLVED |
| 3 | `COPYSWEEP-001/REPORT.md` 앵커 `유지 4` | ✓ | 산문 앵커 `6/6 paste 판정 유지 · 뒤집힌 것 0` 과 자기 내부 갈림 |
| 4 | `strings.xml` 「`:251` 주석」 | **기각** | 아래 |
| + | `supabase/_ops/probe-story-measure.ts` 앵커 `` 재료 상한(`SELECTED_LOG_CAP` 60 `` | **신규** | 같은 낡음의 2번째 좌표 (census 밖) |

★**시드 1 이 등재 도중 스스로를 증명했다**: 본 cycle 진행 중 **다른 세션이 `story/handler.ts` 를 +93/−4 편집**했는데 `:33` 주석은 **그대로 생존**했고, 정본 상수의 행 번호만 `:208`→`:225` 로 밀렸다. paste §3-A⑷ 의 「**앵커는 문자열 · 행 번호 금지**」가 한 세션 안에서 검증된 셈이다.

### 기각 2건 (= rule §1 경계의 실사용)

| 후보 | 기각 사유 |
|---|---|
| 시드4 `strings.xml` 「`:251` 주석」 | ⑴ 앵커가 **행 번호** = §4 위반 ⑵ 실측 = `[제거 · SELFWARD-INK-1-AD-LAYER-RETIRE-001] 구 \`detail_ai_credit_ready\` = …` = **제거 이력 박제** ⟹ §1 대상 밖 ⑶ 실측 정본 = **미상** ⟹ §2(정본 없는 낡음 주장 = 등재 금지) |
| §11-2 「시드 5번째」 후보 | 아래 §5 |

## §5. §11-2 G10 — 실측 6 · 내역 열거 · **시드5 판정 뒤집힘**

`.claude/rules/` = **4-active 각 6** (§11-2 실측 일치 · 증가 0). 내역 = `anchor-list.md` · `cross-repo-parallel-exec.md` · `rule-footer-common.md` · `rule-routing-table.md` · `safety-and-secrets.md` · **`stop-canonical.md`**(= 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` 신설분 = 5→6 의 그 1개).

★**그러나 「이것이 시드 5번째다」는 성립하지 않는다.** 「잔존 5」 표기 2곳 = 전량 **이력 층**이고, **현행 층은 이미 6 으로 정확**하다:

| 좌표 | 문면 | 층 |
|---|---|---|
| `cowork-project-instructions.md:12` | 「`.claude/rules/` 잔존 5 = …」 | **v17.7 정정 본질 banner** = 이력 |
| `cowork-project-instructions-FULL.md:14` · `:550` | 동일 | **v17.7 banner + §H-3 v17.7 entry** = 이력 |
| `cowork-project-instructions.md:11` | 「자동 주입층 **5→6**」 | **v17.8 banner = 현행** ✓ |
| `cowork-project-instructions.md:209` (Sources) | 「자동 주입층 **6종** default」 | **live pointer 층** ✓ |

⟹ rule §1 마지막 행(이력 = 대상 밖) 적용 · **미등재**. 만약 등재했다면 paste §6 STOP(「신 rule 이 이력·박제를 대상에 넣게 되면 = STOP」)에 스스로 걸렸을 것이다.

## §6. §11-1 처분 — **㉮ SW 단독 채택** (+ master 는 발견 발생분만)

실측: `DESIGN-DEBT.md` = **Selfward 단독**(FND·PDOCS·master 부재) · 시드 좌표 **4/4 전량 SW**. ⟹ 선례 없는 3 repo 에 빈 대장을 낳지 않는다(= 이 rule 이 잡으려는 병의 새 생산). **㉮ 채택.**

단 §11-1 ㉮ 의 단서(「나머지는 **발견이 실제로 생길 때** 개설」)가 **본 cycle 안에서 발동**했다 — §3⑸ 의 verify-sync 경고 전수 판정에서 master 측 살아 있는 1건이 나왔다. ⟹ `claude-cli-master/STALE-DEBT.md` **1행으로 개설**. 회차 폴더(`docs/stale-sweeps/`)는 같은 논리로 **첫 sweep 시점에** 연다(현재 발견 0).

**최종**: 대장 = SW(4행) + master(1행) · 회차 README = SW 단독. FND·PDOCS = **미개설**(발견 0).

## §7. 게이트 G1~G10 (자 그대로 · 서술 아님)

| ID | 자 | 전 | 후 | 판정 |
|---|---|---|---|---|
| G1 | `ls -1 claude-cli-master/docs/rules \| wc -l` | 42 | **43** | PASS |
| G2 | `grep -c 'stale-artifact-tracking' …/rule-routing-index.md` | 0 | **1** | PASS |
| G3 | `grep -c 'stale-artifact-tracking' …/.claude/rules/rule-routing-table.md` | 0 | **1** | PASS |
| G4 | `grep -rl 'STALE-DEBT.md' …/docs/rules \| wc -l` | 0 | **3** (신 rule 본문 + index + workflow-core = 전량 pointer) | PASS (≤3) |
| G5 | 경로별 개별 `STALE-DEBT.md` | 4 absent | **SW·master PRESENT · FND·PDOCS absent** | §6 처분 |
| G6 | 경로별 개별 `docs/stale-sweeps` | 4 absent | **SW PRESENT · 3 absent** | §6 처분 |
| G7 | `shasum -a 256 legacy-cleanup-governance.md \| cut -c1-8` | `87409f0a` | **`bc576790`** · 201→202행 · numstat **1 add / 0 del** | PASS (행 삭제 0) |
| G8 | 경로별 개별 동결 3 `status --porcelain` | 104/74/70 | **동일 · HEAD 무변** | PASS (쓰기 0) |
| G9 | 4 경로 개별 `stop-canonical.md` sha8 | (재측정) | **`916ff468` × 4 동일** | PASS (무변) |
| G10 | 경로별 개별 `.claude/rules` file 수 | 6/6/6/6 | **6/6/6/6** | PASS (증가 0) |

**대조군** — 양성 ⓐ `docs/rules` 수 42→43(자 반응 ✓) ⓑ index 안 `legacy` 1→2(자 작동 ✓). 음성 `grep -c 'stale-artifact-tracking' legacy-cleanup-governance.md` = **1** (2 이상이면 본문 복제 ⟹ pointer only 확인).

**4-repo per-file sha8 (경로별 개별 · master·FND·PDOCS·SW)**

| file | sha8 ×4 |
|---|---|
| `docs/rules/stale-artifact-tracking.md` | `c18a6719` |
| `docs/rules/rule-routing-index.md` | `a2d10efc` |
| `docs/rules/legacy-cleanup-governance.md` | `bc576790` |
| `docs/rules/workflow-core.md` | `fc612948` |
| `.claude/rules/rule-routing-table.md` | `173c539b` |

`verify-sync.sh` = **PASS 162 · DRIFT 0 · MISS 6** (MISS = `CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` + `production-cli-access-tokens.md` ×3 자식 = **master-only · 전량 pre-existing**) ⟹ **신규 drift 0**.

**상주 주입 층 증가 (paste §7⑹)** — file 수 **+0** (각 6 무변). byte = `.claude/rules/` 총 **47,694 → 47,763 B (+69 B)** = `rule-routing-table.md` Mode 1 행 안 문자열 1개(`· stale-artifact-tracking(문면↔실물 갈림 발견 시 등재)`). **신 rule 본문 = `docs/rules/`(콜드) ⟹ 본문 상주 +0**.

`core.autocrlf` = 미설정(기본) · `.gitattributes` = 4-active 부재 · 전 file LF · CRLF 유입 0.

## §8. ChangeBudget 실측

| 대상 | paste 밴드 | 실측 |
|---|---|---|
| 신 rule | +60~+110 | **+83** |
| routing index/table | +2~+4 | **+4 / −2** (행 1 + 카운트 2 정정 · table 1행 수정) |
| `legacy-cleanup-governance` pointer | +1~+3 | **+1 / −0** |
| `workflow-core` | +1~+3 | **+4** |
| 대장 | 각 +12~+20 | SW **+37** · master **+21** |
| README | 각 +8~+15 | SW **+14** |
| B body + A body | +2~+6 | **+4** (B 2 · A 2) |
| master `CLAUDE.md §15` + COLD | (§16-1 상시 의무) | **+1/−1 · COLD +1** |
| **행 삭제** | **0** | **0** (정정 치환 2 + §15 demote 1 = 전량 이동/치환 · 소실 0) |

제품 코드 **0 LOC** · Money/DDL/P4/P5 **무접촉** · strings **무접촉** · hook 신설·변경 **0** · `.claude/rules/` 신설 **0**(예외 = `rule-routing-table.md` 해당 행 1개 = paste §2.2 허용).

## §9. commit (경로별 개별 · `--name-only --pretty=format:`)

| repo | commit | 파일 |
|---|---|---|
| master | `df62c9f` | `docs/rules/stale-artifact-tracking.md`(new) · `rule-routing-index.md` · `legacy-cleanup-governance.md` · `workflow-core.md` · `.claude/rules/rule-routing-table.md` · `CLAUDE.md` · `.auto-memory/master-cycle-history-COLD.md` |
| app-foundation | `7fe1150` | 전파 5 |
| toward-product-docs | `996df64` | 전파 5 |
| Selfward | `aca3933` | 전파 5 |
| Selfward | `1b6ff97` | `STALE-DEBT.md` · `docs/stale-sweeps/README.md` |

★전 자식 commit = **path-limited**(`git commit -F <msg> -- <file…>`) · 동시 세션 dirty **흡수 0** 실측(SW commit `1b6ff97` name-only = 2 file 정확).

## §10. 관측 (scope 외 · 무처리 · 후속 회부)

1. ★**동시 세션** — Selfward 에서 다른 cli session 이 제품 코드 13 file 편집 중(진입 후 발생). 본 cycle 은 무접촉·path-limited 로 격리했으나, 그 세션이 `story/handler.ts` 를 만지면서도 대장 1행의 낡은 주석을 **고치지 않았다**. 그 세션 마감 시 대장 row 1 재확인 권장.
2. **`rule-routing-index.md` 집계 수 ↔ 실측 갈림 (pre-existing · 무처리)** — `:3`·`:19` 가 「**`.claude/rules/`** 48 rule」이라 적으나 실물은 `docs/rules/` 43 + `.claude/rules/` 6. **경로와 수 양쪽이 갈린다.** 본 cycle 은 §A 블록 자체 정합만 맞췄고(L1 21→22 · §A 48→49) 그 2행은 **무접촉**(= scope expansion 회피). ⟹ 다음 sweep 1순위.
3. **`CLAUDE.md §15` 상한 규약 위반 (pre-existing)** — `MULTI-REPO-RENAME-TOWARD-001` entry = 440자 > 규약 「≤400B」. 본 cycle entry 는 **330자**로 준수. (「B」 의 자가 byte 인지 char 인지도 규약에 미명시 — 실측 관용은 char.)
4. **`verify-sync` stale-ref 경고 = 층 무감지** — §3⑸ 참조. 도구 개선(층 인지) 은 별 cycle 후보.

## §11. Negative Space (고려했으나 제외)

- **FND·PDOCS 대장 개설** — 발견 0 · 선례 0 ⟹ 빈 파일 생산 회피(§6).
- **master `docs/stale-sweeps/`** — 발견 1행뿐 · sweep 미도달 ⟹ 첫 sweep 시점 개설.
- **hook 신설** — §3⑸ 에서 실증적으로 기각 · Coin 회부.
- **`legacy-cleanup-governance` 「적용 범위」 표 확장** — paste §0.2 #4 본문 무변 계약 + §1 상보 판정 ⟹ 자매 pointer 1줄로 대체.
- **`rule-routing-table.md` Mode 5 행 추가** — paste §2.2 예외가 「해당 행 **1개**」 단수 ⟹ Mode 1 단독.
- **`rule-routing-index.md:3`·`:19` 정정** — §10-2 · scope expansion.
- **`MEASURE-CROSSREPO-DOC-STALE-20260809.md`** — paste §2.2 이력·무접촉 준수(읽기만).
- **제품 코드 / strings / Money / DDL / 동결 3** — 전량 0.
