# MASTER-DOC-MANIFEST-SWEEP-001 — REPORT

> 판 = master 문서층 **자기 서술 정합** · Mode M5 (cli-infra-ops) · production 0 LOC · 보호 5 본문 sha 0 · 자식 3 repo 0.
> 형식 = `docs/rules/reporting.md §15.1` 12 축 + 발주 §8.1 요건 ⑴~⑽. 발행 = 2026-08-29 KST.

---

## §0. 배경 재진술 (= 자기 말 · verbatim 복붙 0 · 발주 §8.1 ⑵)

이 판이 고치는 건 **버그가 아니라 분모**다. 규약·원장 file 들은 자기 머리에 「나는 무엇을 담는가」를 적어 두는데(manifest 는 advisory 항의 경로와 행수를, COLD 는 entry 수를, `CLAUDE.md` 는 보호 파일 종수를, footer canonical 은 자기 적용 범위를), 그 자칭이 실물과 갈려 있었다. 갈린 자칭은 **읽는 사람이 다음 판정을 세울 때 쓰는 밑수**가 되고, 그래서 이 트랙에서 「부재」·「완료」·「닫힘」 판정이 네 번 틀렸을 때 원인이 매번 코드가 아니라 **분모**였다. 갈림의 큰 줄기 하나는 특정 사건으로 좁혀진다 — `MASTER-CLI-CONTEXT-DIET-2-003` 이 rule 44종을 `docs/rules/` 로 옮겼는데 **그 file 들을 가리키던 문면들이 따라 이사하지 않았다**(7 축 중 #1·#2·#3·#7 이 그 잔해다). 그래서 이 판의 핵심은 값을 맞추는 데서 끝내지 않고 **값 옆에 그 값을 낸 자를 붙이는 것**이다. 값만 고치면 다음 회차에 같은 자리에서 같은 방식으로 다시 갈리고, 자가 붙어 있으면 다음 사람이 **재보는 순간 갈림이 드러난다** — 규율은 사고를 없애는 게 아니라 잡히게 만든다.

**§0-ⓑ 좌표 지목** (= 문장 아니라 좌표 · **실제로 열어 확인함**):

| 좌표 | 열어 확인한 내용 | 본 판과의 관계 |
|---|---|---|
| `docs/rules/code-principles.md` §0 원칙 1 | 「지금 안 터진다」는 완료 조건이 아니다 | 갈린 자칭은 **안 터진다** — 그래서 방치됐고, 그래서 분모가 됐다 |
| `docs/rules/reporting.md` §8.1 (`:224`) | 「수치를 인용하면 그 수치를 만든 명령을 함께 적는다 · 명령 없는 수치 = 재현 불가 = 근거 아님」 + 환경 4축 + aggregate = drift 검출기 | ★**형식 선례로만** 인용 — 아래 확인 결과 참조 |
| `CLAUDE.md` §16-1 (`:310`) | 「master 의 모든 cli infra 변경은 본 `CLAUDE.md §15` 표에 cycle entry 추가 의무」 | 대상이 **`CLAUDE.md §15` 표 단독**이다 ⟹ rule file 층에는 짝이 없다 = **T3 이 세우는 것** |

★**발주가 물은 판단의 검증** (= 「§8.1 이 원장·manifest 를 명시 대상으로 삼지 않는다」는 저작 측 판단이 맞는가): **맞다.** `reporting.md` 를 열어 §8 절의 대상 범위를 실측했다 — §8 헤더는 「**근거 기록 기준**」이고 §8.1 은 그 하위로, 본문이 드는 예·판정어(`[CONFIRMED]` / `[INFERRED]` 강등 · aggregate 불변식 · 기록 형식 권장 1줄)가 전부 **REPORT/EVIDENCE 서술 층**을 가리킨다. `.auto-memory/**` manifest 나 원장 file 을 대상으로 지명하는 구는 **없다**. ⟹ 본 판은 「§8.1 이 이것을 강제한다」고 적지 않았고, 실제 문면에도 그렇게 쓰지 않았다(= K-156 = 「양립한다」고 적기 전에 상대 문면에 그 축이 있는지 확인 · 없으면 그건 양립이 아니라 내 가정).

**이 판이 아닌 것 (1줄)**: COLD lineage 가 왜 갈렸는지 캐는 판이 아니다(N9 · S7) — 보호 5 본문도, §12 재정렬도, rule 44종 이력 backfill 도, 전파(#130)도 아니고, 오직 **자칭을 실측에 맞추고 그 옆에 자를 심는** 판이다.

---

## §0-B. BASELINE 진입 재측 (= 발주 인용값 아님 · 실측이 정본 · S8)

| 축 | 발주 인용 | **집행 시점 실측** | 판정 |
|---|---|---|---|
| HEAD | `e7f42d6` | `e7f42d6` | 일치 |
| ahead | 11 | 11 (`git rev-list --count origin/main..HEAD`) | 일치 |
| porcelain | 0 | 0 | 일치 |
| `.auto-memory/protected-file-hashes.md` | 139행 | 139행 | 일치 |
| `docs/rules/reporting.md` | 383행 | 383행 | 일치 |
| `.auto-memory/master-cycle-history-COLD.md` | 201행 / 데이터행 163 | 201행 / 163 | 일치 |
| `CLAUDE.md` | 323행 | 323행 | 일치 |
| `.claude/rules/rule-footer-common.md` | 8행 | 8행 | 일치 |
| 게이트 「전」 13 항 | §6.1 표 | **13/13 전량 재현** (§4 표) | 일치 |

⟹ **S8 미발동** (baseline 축). 단 **내용 축에서 발주와 실물이 갈린 곳 2 건**이 있었다 → §5 편차.

---

## §1. 판정

**PASS (부분 편차 2 · 전량 자로 재현해 보고).** T1~T7 **7/7 착지** · 게이트 13 항 중 **11 항 기대값 정합 · 2 항(G3 둘째·G8 둘째) 기대값 초과 = 원인 규명 완 · 자 자체를 문면에서 자기 제외판으로 교정**. 보호 5 sha 불변 · `stop-canonical.md` 불변 · 자식 3 diff 0 · production 0.

---

## §2. 착지 좌표 (`path` | `line` | `anchor` · K-136 round-trip 완)

| T | path | line | anchor |
|---|---|---|---|
| T1 | `.auto-memory/protected-file-hashes.md` | `:45` | `docs/rules/design-to-code-sync.md` (261 줄) … 구 표기 = `.claude/rules/` · 103 줄 |
| T1 | `.auto-memory/protected-file-hashes.md` | `:46` | `docs/design/design-sot-policy.md` (156 줄) … 구 표기 = 153 줄 |
| T2 | `docs/rules/reporting.md` | `:322`~`:326` | §12 말미 append 5 행 (BRAND-TOWARD / AIDOC-RELEASE / ENGINEERING-BASELINE-002 / **TASK-PURPOSE-CONTRACT-001** / 본 판) |
| T3 | `.claude/rules/rule-footer-common.md` | `:10` | `- **이력 절 등재 의무** — rule file 의 절을 신설·개정하는 cycle 은 …` (본문 불릿 **5번째**) |
| T4⑴ | `.auto-memory/master-cycle-history-COLD.md` | `:1` | `# Master Cycle History COLD storage (= **164 데이터행 / 162 고유 cycle ID** …)` |
| T4⑵ | `.auto-memory/master-cycle-history-COLD.md` | `:11` | `## §1. … (= **164 데이터행 / 162 고유 cycle ID** verbatim … ★아래 가산식은 당시 누적 이력 …)` |
| T4⑶ | `.auto-memory/master-cycle-history-COLD.md` | `:25` | `> 아래 표 = master CLAUDE.md §15 측 이력 전체 **verbatim 이전** (= 현행 164 / 162 …)` |
| T4⑷ | `CLAUDE.md` | `:304` | `> **§15 cold 재배치** … (= 현행 **164 데이터행 / 162 고유 cycle ID** … 구 표기 = 149 …)` |
| T5 | `CLAUDE.md` | 구 `:300` | **빈 행 1행 삭제** — 구분선 `\|---\|---\|---\|` 직후가 데이터행이 됐다 |
| T6 | `CLAUDE.md` | `:311` | `2. **보호 파일 5 종** sha 변경 시 … 구 표기 = 4 종 · 자 3 일치` |
| T7 | `.claude/rules/rule-footer-common.md` | `:3`~`:4` | `본 file = **rule file 공통** … 적용 범위 = docs/rules/** + .claude/rules/**` + 정정 1행 |
| §8 | `CLAUDE.md` | `:302` | 본 판 §15 entry (**400B** · 상한 ≤400B 충족) |
| §8 | `.auto-memory/master-cycle-history-COLD.md` | `:192` | demote 착지 = `MASTER-ENGINEERING-BASELINE-001` 행 **verbatim** |

---

## §3. T2 삽입 위치 판정 근거 (= K-154 · 발주가 1줄 요구)

**§12 를 마지막으로 만진 commit** = `d9fd3c1` (`MASTER-CLI-RULES-SETTLE-001` · 2026-07-26 · 자 = `git log -s --oneline -L 315,322:docs/rules/reporting.md`). 그 commit 은 신 entry 를 **말미가 아니라 말미 1행 위**(05-22 행과 06-22 행 사이)에 넣었다 — 즉 **위치는 어긋났으나 방향은 「아래쪽 = 최신」**이다. 직전 2 회차는 전부 **말미 append**(`f549d57` 2026-05-22 · `a6f27f4` 2026-06-22 · 각 diff 확인). 여기에 같은 repo 의 동종 표 규약이 **명문**으로 붙어 있다 — `CLAUDE.md:296`「**신 entry = 맨 아래**」(2026-08-29 `MASTER-ENGINEERING-BASELINE-002` · 자 = K-154 · 선례 `48e75de`). ⟹ **관례 = 말미 append** 로 판정하고 그대로 따랐다. `d9fd3c1` 의 1행 어긋남은 **정렬 이슈**이며 §12 재정렬은 본 판 밖(§0-ⓒ)이라 **무접촉**.

---

## §4. 게이트 전/후/시점/판정 (13 항 · 자 = 발주 §6 블록 **awk 추출 verbatim 실행** · 재타이핑 0)

추출 자 = `bash <(awk '/^## §6\./{s=1} s&&/^```bash/{c=1;next} c&&/^```/{exit} c' <발주서>)` — repo 밖 발주서에서 추출해 프로세스 치환으로 실행(파일 미생성).

| G | 시점 | 전 | 후 | 기대 | 판정 |
|---|---|---|---|---|---|
| G0 | 진입 | `claude-cli-master e7f42d6 4` | `claude-cli-master <최종 HEAD> 4` | cwd 증명 | **PASS** (cwd 정확 · 대상 4 실재) |
| G1 | 무관 | `4 2` | **`4 0`** | `4 0` | **PASS** |
| G2 | 무관 | `0 0 0` | **`1 1 1`** | `1 1 1` | **PASS** |
| G3 | 무관 | `0 15` | **`2 16`** | `≥1 15` | **부분** — 첫 칸 ✓(2 = `rule-footer-common.md` + `reporting.md §12`) · 둘째 칸 **16** = §5-편차① |
| G4 | 무관 | `2 1 1` | **`0 0 0`** | `0 0 0` | **PASS** (구 표기는 숫자만 병기 = `154`/`149` · `154 entry` 문자열 미사용) |
| G5 | 무관 | `163 161` | **`164 162`** | 변동 가능 · T4 기재값과 일치 | **PASS** — demote +1 반영 · T4 4곳 기재값 **164/162 전량 일치** |
| G6 | 무관 | `1` | **`0`** | `0` | **PASS** (표 복구) |
| G7 | 무관 | `1 0` | **`0 1`** | `0 1` | **PASS** |
| G8 | 무관 | `1 23` | **`2 24`** | `≥1 <n>` | **부분** — 첫 칸 ✓(2 = 신 범위 1행 + 구 표기 병기 1행 · **선택 근거 = §5-편차②**) · 둘째 칸 **24** = §5-편차① |
| G9 | 무관 | `26 1 1 1` | **`26 1 1 1`** | 불변 | **PASS** (S4 미발동) |
| G10 | 무관 | `8502c014 31c0da56 92a5e998 202d3f4f 2bfc81c5` | **전량 동일** | 동일 | **PASS** (S2 미발동) |
| G11 | 무관 | `916ff468` | **`916ff468`** | 동일 | **PASS** (S3 미발동) |
| G12 | **cycle 마감** | `0` | **`0`** (마감 재측 = §정정 append) | `0` | **PASS** (S1 미발동) |

★**눈검증 (P5)**: `CLAUDE.md §15` 렌더 — 구분선 직후가 데이터행이고 **3 entry 전량이 표 안**이다(자 = `awk` 구조 판정 = `DATA` · 표 데이터행 계수 = 3 = hot 상한 3 정합).

---

## §5. 편차 · 이의 (= 방어 0 · 전량 자로 재현)

### 편차① — G3 둘째 `15→16` · G8 둘째 `23→24` (= **자가 자기를 물었다**)

**현상**: 두 자 모두 「후 = 불변」이 기대였는데 각각 +1.
**원인(실측)**: 본 판이 **값 옆에 자를 병기**하면서, 그 자의 검색어를 문면에 적어 넣었다 — `rule-footer-common.md` 가 「명시 cycle 이력」(G3 자의 검색어)과 「rule-footer-common」(G8 자의 검색어)을 **자기 본문에 갖게 됐다**. ⟹ **canonical 이 자기 자의 분모에 들어왔다**(자 = `grep -rl … | grep 'rule-footer-common.md'` = 1 hit).
**판정**: **감소가 아니라 증가**다. §6.1 이 위험으로 지목한 것은 「감소 = 이력 절 훼손」이고, 여기서는 자가 살아 있음이 오히려 재확인됐다(양성대조 생존).
**조치(= K-139 「정정은 자까지 내려간다」)**: 값만 맞추지 않고 **문면에 적히는 자를 자기 제외판으로 고쳤다** — `… | grep -v 'rule-footer-common.md' | wc -l`. 재현: 자기 제외판 = **소비처 23 · 양성대조 15**(= 문면 기재값과 일치) · 자기 포함판(= 게이트 원본) = **24 / 16**. 두 값이 왜 다른지는 문면 안에 명시했다.
**남는 것**: 게이트 원문(G3·G8 둘째 칸)은 자기 제외를 안 하므로 다음 회차에도 24/16 을 낸다. 게이트 문안 갱신 = 본 판 밖(발주가 준 게이트는 verbatim 실행 대상) → **회부 N12**.

### 편차② — G8 첫 칸을 **2** 로 택했다 (= 발주가 「어느 쪽을 택했고 왜」를 REPORT 에 요구)

**선택**: `2`(= 신 범위 1행 + 구 표기 병기 1행). **버린 안**: 구 표기를 `` `.claude/rules/` ``(글롭 없이)로 적어 `1` 을 유지하는 안.
**근거**: ⑴ 구 문면의 **verbatim 은 `` `.claude/rules/**` ``** 였다 — 글롭을 떼면 병기가 원문이 아니게 된다(삭제 0 의 취지 훼손). ⑵ `1→1` 은 **집행 전후를 구별하지 못하는 값**이다. `1→2` 는 자가 **편집이 착지했음을 보여준다**. ⑶ 새 범위 문장에도 `.claude/rules/**` 가 **정당하게** 들어간다(실측 소비처 3 이 거기 있다) — 그 1 은 stale 이 아니라 사실이다.

### 이의① — ★**발주 §0-ⓓ 의 위양성 판정 ⑵ 는 틀렸다** (= §9-③ 이 물은 자리)

발주는 `pencil-mcp-tools-reference.md:68·:105` 의 「`MASTER-CLI-PENCIL-OPTIMIZATION-002` **강화**」를 **인용(위양성)** 으로 판정했다. **git log 로 재현하니 귀속이다.**
- 자 = `git log --oneline -S'1.1.1 .pen format 13 Entity type' --all -- docs/rules/pencil-mcp-tools-reference.md .claude/rules/pencil-mcp-tools-reference.md` → **`08104e9` 단독** = `MASTER-CLI-PENCIL-OPTIMIZATION-002`.
- 그 commit 의 해당 file numstat = **`67 0`**(= 67 삽입 · 0 삭제) · 추가 본문 첫 줄 = `#### 1.1.1 … (= MASTER-CLI-PENCIL-OPTIMIZATION-002 강화)` + `본 cycle 측 강화 본문` ⟹ **그 cycle 이 그 절을 만들었다**(주석 아님).
- 그런데 그 file 의 `## 12. 명시 cycle 이력` 에 `OPTIMIZATION-002` = **0 hit**.
⟹ **진성 미등재가 `reporting.md` 3 뿐이라는 §0-ⓓ 명제는 반증됐다** (최소 1 건 더 실재).
**본 판 영향**: **T2 분모는 안 바뀐다** — T2 는 `reporting.md §12` 내부 계약이고, 위 건은 **다른 file** 이다. 그리고 rule 44종 이력 backfill 은 §0-ⓒ 가 명시적으로 배제한 영역이다 ⟹ **고치지 않고 회부**(N11). 이 건은 오히려 **T3 을 강화한다** — 의무 문면이 없어서 절을 만든 cycle 이 스스로 등재하지 않는 일이 실제로 있었다는 증거다.
**나머지 3 건(⑴⑶⑷)은 발주 판정이 옳다** — §9-③ 참조.

### 이의② — ★**T2 분모가 3 이 아니라 4 였다** (= 발주 census 의 **자**가 놓친 1 건 · S8 경유)

- 발주의 census 자 = **절 헤더 자칭 cycle ID**. 재현: 헤더 자칭 ID = **6**(§1.1 · §8.1 · §8.2 · §13 · §14 · §15) · 등재 3 · **미등재 3** ⟹ **발주 census 정확히 재현됨**.
- 그런데 `git log --follow -- docs/rules/reporting.md` 로 다시 재니 **`MASTER-TASK-PURPOSE-CONTRACT-001`** 이 이 file 의 절을 만들고도 §12 에 없다: `edd90f2` numstat = **`13 0`** = §3 Task 형식에 **`## 배경` 절 신설**(자칭이 그 절 blockquote 안에 「2026-08-29 `MASTER-TASK-PURPOSE-CONTRACT-001` 신설」로 박혀 있다) + `1855f39` = §15.2 대상 정정.
- **놓친 이유** = 자칭이 **절 헤더가 아니라 본문 blockquote** 라 **헤더 자에 안 걸렸다**. 즉 발주의 판단이 아니라 **자의 사각**이다.
- **조치**: 발주 §5 **S8**(「발주와 실물이 갈리면 **실물이 정본**」)에 따라 **등재했다**(`:325`). 근거 보강 = 본 판 명제 **P2**(「§12 에 미등재 cycle ID 가 **0**」)는 3 만 넣어서는 성립하지 않는다. 비용 = **+1 행**(밴드 내부) · 되돌리기 = 그 1행 삭제로 끝난다.
- ★**여기서 멈춘 선**: 「그 file 을 건드린 모든 cycle」로 넓히면 미등재는 **11** 이 되고(브랜드 sweep · 경로 이동 등 포함) 그건 backfill 판이다. 본 판이 채택한 선은 **「절을 신설·개정한 cycle」**(= T3 이 세운 바로 그 문면)이며, 그 선에서 `reporting.md` 의 분모는 **4**(3 + TASK-PURPOSE)다.

---

## §6. §9 「나를 의심하는 절차」 전량 답 (6/6)

**① 「전」 값 13 항 전량 재현되는가.** → **13/13 재현.** `G1 4 2` ✓ · `G3 0 15` ✓ · `G4 2 1 1` ✓ · `G6 1` ✓ · `G9 26 1 1 1` ✓ · 나머지(`G0`/`G2 0 0 0`/`G5 163 161`/`G7 1 0`/`G8 1 23`/`G10`/`G11`/`G12 0`) 전량 일치. **S8 baseline 축 미발동.**

**② T3 이 옳은가 = 「등재 의무 문면이 없다」가 맞는가.** → **맞다. 다른 트리·다른 낱말로 재확인했다.**
- 낱말 9 종 × 트리 확대(`docs` + `.claude` + `CLAUDE.md` + `scripts`, `--include='*.md'`): `이력 절 등재 의무` / `이력 등재 의무` / `이력 절에` / `이력 append` / `cycle entry 추가` / `entry 추가 의무` / `이력 추가` / `cycle 이력.*의무` / `의무.*명시 cycle 이력` → **hit 는 `CLAUDE.md` 단독 2 종**(`cycle entry 추가` · `entry 추가 의무`)이고 둘 다 **§16-1 한 줄**이며 그 대상은 **`CLAUDE.md §15` 표**다.
- 인접 후보도 열어 확인: `cycle-discipline.md §15`(= cli 수정 패턴 3종 + **§15 hot 상한 규약**)는 **master `CLAUDE.md §15`** 의 400B·demote 만 규정하고 rule file 이력 절을 언급하지 않는다.
- **양성대조**(자 생존): 「명시 cycle 이력」 절 보유 file = 좁은 트리 **15** · 넓힌 트리 **29**(`docs/rules` 14 · `.claude/rules` 1 · `docs/agent` 2 · `.claude/skills` 5 · `.claude/agents` 1 · `.auto-memory` 5 · `CLAUDE.md` 1). ⟹ 자는 살아 있고 **의무 문면만 0** 이다.
⟹ **T3 = 신설이 맞다**(정정 아님). 발주가 지적한 대로 ㉡ #151 의 전제(「규약 file 이 자기 이력 규약을 안 지킨다」)는 부정확하고, **있던 것은 관례**다.

**③ 위양성 4 건 재현.** → **3/4 는 발주가 옳고, ⑵ 는 틀렸다**(= §5 이의①).
- ⑴ `cross-repo-parallel-exec.md:36` → **위양성 확정**. 그 file §8 이 「전문 9 entry = COLD verbatim」으로 demote 를 명시하고, `MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001` 은 `.auto-memory/cross-repo-parallel-exec-COLD.md:17` 에 **1 hit 등재**. 분모가 COLD 였다.
- ⑵ `pencil-mcp-tools-reference.md:68·:105` → ★**위양성 아님 = 진성 미등재**(자 = `git log -S` + numstat `67 0`). §5 이의① 참조.
- ⑶ `pencil-theme-multi-axis.md:54` → **위양성 확정**. `:54` 는 `OPTIMIZATION-001` 을 「**측 baseline**」으로 **인용**하고, 그 절(§2.1)을 실제로 만든 것은 `08104e9`(=`OPTIMIZATION-002`)이며 **그 ID 는 §9 이력 절에 「본 SoT 신설」로 등재돼 있다**.
- ⑷ `rule-routing-index.md:178·:197·:211` → **위양성 확정**. §F 이력 절이 **범위 표기**(`RULE-ARCH-PHASE1~4`)와 **축약명**(`GUIDANCE-ROUTING` 등)을 쓰고 전문은 COLD 로 이전 ⟹ 완전 ID 대조만 실패할 뿐 **등재는 돼 있다**(= 위반 아님 = N8).
⟹ **T2 분모에는 영향 없다**(⑵ 는 다른 file). 다만 §0-ⓓ 의 「진성 미등재 = 3 뿐」 명제는 **반증**됐다 → N11.

**④ T5 의 「삭제 0 예외」가 옳은가 = 빈 행이 의도적 구분자일 가능성.** → **의도적 구분자가 아니다. 두 자로 확정.**
- **선례 자(K-140)**: `MASTER-CLI-S15-HOT-DEMOTE-005`(`0d67c12`)의 `CLAUDE.md` diff 를 열었다 — 그 판은 §15 표 **한가운데의 빈 행**(T6-REALIGN 행과 T7-REALIGN 행 사이)을 **`-` 1행 삭제**로 제거하고 데이터행을 붙였다. **동형을 이미 그렇게 고쳤다.**
- **기원 자**: 현 `:300` 빈 행이 언제 생겼는지를 `git show <rev>:CLAUDE.md | awk`(구분선 다음 행 = BLANK/DATA)로 이분 탐색했다 → `563c3f0` **DATA** → `9ba9dd3` **BLANK**. ⟹ **`MASTER-CLI-CONTEXT-DIET-3-001` A(= 12 entry COLD demote · 10회차)가 남긴 잔해**다. 즉 **demote 가 맨 위 행들을 걷어내며 남긴 빈 줄**이지 구분자가 아니다.
- **양성대조**: `docs/rules/reporting.md` 의 표는 구분선 **다음 행이 데이터행**이다.
⟹ **표 헤더/구분선을 옮기는 쪽이 아니라 빈 행 삭제가 옳다.** 집행 = `:300` 1행 삭제 · **내용 0** · 결과 G6 `1→0`.

**⑤ T4 의 「entry」 단위 — 발주가 안 정했다.** → **둘 다 자와 함께 적었고, 더 나은 형태를 제안한다.**
- 4곳 전량에 **`164 데이터행 / 162 고유 cycle ID · 중복 2 · 자 = …`** 형식으로 병기했다(값 단독 금지).
- ★**제안 = 「entry = 데이터행」을 정의로 못박자.** 근거는 취향이 아니라 **그 file 자신의 문면**이다 — COLD `:23` 「재수록 2 의 성격」은 같은 cycle ID 가 표에 2회 등장하는 것을 **오류가 아니라 규약의 산물**(hot 압축판 + 원문 **양쪽 보존** · 압축판도 삭제 0)이라고 못박는다. ⟹ **중복 행은 의도된 보존물**이므로 「무엇을 담고 있나」의 답은 **행 수**이고, 고유 ID 수는 **정체성 계수(진단값)** 로 병기하는 게 맞다. 확정 = Coin 몫(1줄이면 끝난다) → **회부 N13**.

**⑥ 본 판이 drift 를 없애는가.** → **아니다.** 없애는 것은 T3 **1행**(= 앞으로 절을 만든 cycle 이 스스로 등재하게 하는 규칙)뿐이고, T1·T2·T4·T6·T7 은 **지금 값을 맞추는 것**이며 T5 는 구조 복구다. 본 판이 실제로 거는 것은 ★**「값 옆에 자」** — 다음 사람이 재보면 갈림이 **즉시** 드러난다. 실제로 이 판 안에서 그 효과가 두 번 났다: **편차①**(자를 문면에 적자마자 자기 포함 문제가 드러났다)과 **이의②**(자를 바꿔 재니 발주 census 의 사각이 드러났다). **규율은 사고를 없애지 못하고 잡히게 만든다.**

---

## §7. ChangeBudget (= `cycle-discipline.md §30` 3층 · 단위 **행**)

| 층 | 값 |
|---|---|
| 본문 축 | **+17 / −10 · net +7 행** (자 = `git --no-optional-locks diff --numstat`) |
| 밴드 | `+4 ~ +14` → **net +7 = 밴드 내부** ✓ (하한 미달 아님 · 상한 초과 아님) |
| 주석 축 | **0** |
| test 축 | **0** |
| 재작성 file | **0** (통째 재작성 없음) |
| production | **0 LOC** |

**file 별**: COLD `+4/−3` · manifest `+2/−2` · footer `+3/−1` · `CLAUDE.md` `+3/−4` · `reporting.md` `+5/−0`.

### ★순삭제 = 1 행 증명 (= 발주 §8.1 ⑸ · 단위 **행**)

삭제 행 **전수 10** 을 열거해 착지처를 대조했다(자 = `git diff --unified=0` 의 `-` 행 전수):

| # | 삭제 행 | 처분 | 착지 증명 |
|---|---|---|---|
| 1~2 | manifest `:45` `:46` | **정정 쌍** | 구 표기 병기 실재 = `구 표기 = \`.claude/rules/\` · 103 줄` 1 hit · `구 표기 = 153 줄` 1 hit |
| 3~5 | COLD `:1` `:11` `:25` | **정정 쌍** | `구 표기 = 154` **2 hit** · `구 표기 = 149` 1 hit · **가산식 verbatim 보존 1 hit**(항 합 89 + Phase 1 65 = **154** 로 자기 정합 유지) |
| 6 | footer `:3` | **정정 쌍** | `구 표기 = \`.claude/rules/**\` 단독` 1 hit |
| 7 | `CLAUDE.md` §15 cold 재배치 행 | **정정 쌍** | `구 표기 = 149` 1 hit |
| 8 | `CLAUDE.md` §16-2 행 | **정정 쌍** | `구 표기 = 4 종` 1 hit |
| 9 | `CLAUDE.md` `MASTER-ENGINEERING-BASELINE-001` 행 | **demote(이동)** | COLD `:192` **verbatim** — 자 = `git show e7f42d6:CLAUDE.md \| grep '^\| MASTER-ENGINEERING-BASELINE-001 \|'` 를 `grep -Fxc -f -` 로 대조 = **COLD 1 hit / CLAUDE.md 0 hit** · 원문 **399B** 무손실 |
| 10 | `CLAUDE.md` `:300` **빈 행** | ★**순삭제** | 내용 **0 byte** = 문면 손실 0 |

⟹ ★**착지처 없는 제거 = 정확히 1 행**(빈 행 · 내용 0) · **문면 손실 = 0** · 나머지 9 행은 전량 **정정 쌍 8 + verbatim 이동 1**. **S6 미발동.**

---

## §8. STOP · 회귀 그물 (trigger 별 · 0 도 값)

| # | trigger | 발동 | 근거 |
|---|---|---|---|
| S1 | 자식 3 repo 가 diff 에 등장 | **0** | G12 = `0` · porcelain 5 file 전량 master 내부 |
| S2 | 보호 5 **본문** sha 변동 | **0** | G10 5 값 전량 동일 (`8502c014 31c0da56 92a5e998 202d3f4f 2bfc81c5`) |
| S3 | `stop-canonical.md` sha 변동 | **0** | G11 `916ff468` 동일 |
| S4 | 선행 3판 착지 문면 삭제 | **0** | G9 `26 1 1 1` 불변 (K-131~157 26 · §8.2 1 · §15 1 · §14a 1) |
| S5 | production / `build.gradle.kts` / `scripts/*` 접촉 | **0** | 변경 5 file = 문서·원장 전량 |
| S6 | 순삭제 1행 초과 | **0** | §7 전수 대조 = 착지 없는 제거 1행 |
| S7 | COLD lineage **원인 규명 착수** | **0** | T4 는 **자를 심었을 뿐** 원인을 적지 않았다 — COLD `:11` 문면에도 「가산식으로 현행 실측은 재구성되지 않는다[**원인 규명 = 별 판**]」로 명시 · 가산식 **무접촉**(verbatim 1 hit) |
| S8 | 발주 ↔ 실물 갈림 | **발동 1** | 이의②(T2 분모 3→4) = 실물이 정본 · §5 기록 · §0-B 첫 줄 재측은 baseline 축 전량 일치 |

**회귀 그물**: G0~G12 13 항 + 눈검증 1(§15 렌더) + 선행 3판 무손상 재측(G9) = **전량 수행**.

---

## §9. 회부 (= 남기는 부채 · 원장 번호 · 「어느 판 · 언제」 명시 · K-132)

| 회부 | 내용 | 어느 판 | 언제 |
|---|---|---|---|
| **#130** | propagation (001+002+본 판 누적 · ★본 판이 `.claude/rules/rule-footer-common.md` 를 만졌으므로 **전파 대상이 늘었다**) | `MASTER-PROPAGATION-4ACTIVE-001` | 본 판 착지 후 |
| **N8** | `rule-routing-index.md §F` 이력 절이 범위 표기·축약명 사용 ⟹ 기계 대조 불가(위반 아님) | 별 판 | 낮음 — **T3 이 「완전 ID 표기」 구를 담지 않았다**(인용 제외 구만 담음) ⟹ 자연 흡수 안 됨 |
| **N9** | COLD 가산식(154) ↔ 실측(164) 미재구성 **원인** | 별 판 | 본 판 후 · 낮음 — **T4 가 자를 심어 뒀으므로 언제든 잰다** |
| ★**N10**(신설) | COLD `:3` 「hot 영역 = 최근 5」 · `:25` 말미 「hot §15 = 최근 5 + 본 cycle entry」 = **상한 3 규약(2026-07-29)과 갈린 현행 서술 2곳** · 같은 file 안 · T4 4 좌표 **밖** | 별 판(또는 다음 COLD 접촉 판) | 낮음 — 본 판 scope 는 T4 가 지명한 4 좌표뿐(§0-ⓒ 정합) |
| ★**N11**(신설) | `pencil-mcp-tools-reference.md` = `MASTER-CLI-PENCIL-OPTIMIZATION-002` 진성 미등재(§5 이의①) ⟹ **§0-ⓓ 「진성 = reporting.md 3 뿐」 반증** · 다른 file 도 재census 필요 | rule 이력 backfill 판 | T3 착지 후 — **이제 근거 문면이 있다** |
| ★**N12**(신설) | 게이트 G3·G8 **둘째 칸이 자기 포함**이라 canonical 이 자기 자를 물면 +1 (§5 편차①) | 게이트 문안 갱신 판 | 다음 게이트 저작 시 — 자기 제외 `grep -v` 를 게이트에도 |
| ★**N13**(신설) | 「entry」 단위 정의 확정(= 데이터행 vs 고유 ID · §6-⑤ 제안 = **데이터행**) | 1줄 결정 · Coin | 임의 |
| **#132 · #133 · #134·#140 외** | 발주 §2 표 그대로 | `KTLINT-RATCHET-002` / A-1 / D-4 | 발주 §2 시점 그대로 |

**신규 부채 = 4**(N10 · N11 · N12 · N13) — 전량 「어느 판 · 언제」 명시.

---

## §10. 자 대조표 (= 「자의 이름 ↔ 자를 낸 명령」 · `verification-and-review.md` §0.4 의무)

| 자 이름 | 명령 | 환경 |
|---|---|---|
| 게이트 13 항 | `bash <(awk '/^## §6\./{s=1} s&&/^```bash/{c=1;next} c&&/^```/{exit} c' <발주서>)` | bash · cwd = repo · 발주서 = repo 밖 · **재타이핑 0** |
| manifest advisory 분모 | `awk -F'\140' '/\([0-9]+ 줄/{…}'` (게이트 G1 내장 · **닫는 괄호 미요구**) | 분모 **4** |
| §12 헤더 자칭 ID | `grep -nE '^#{2,4} .*(MASTER\|C[0-9]\|…)-[0-9]{3}' docs/rules/reporting.md` | 6 헤더 |
| §12 등재 ID | `awk '/^## §12/{f=1;next} f&&/^## §1[3-9]/{exit} f' … \| grep -oE '[A-Z][A-Z0-9-]*-[0-9]{3}' \| sort -u` | 전 5 → 후 10 |
| reporting.md 실 변경 cycle | `git --no-optional-locks log --follow --format='%h\|%ad\|%s' --date=short -- docs/rules/reporting.md` | 18 commit |
| §12 정렬 관례 | `git --no-optional-locks log -s --oneline -L 315,322:docs/rules/reporting.md` | 4 commit |
| 절 귀속 vs 인용 | `git --no-optional-locks log --oneline -S'<절 제목 문자열>' --all -- <path>` + `--numstat` | K-133 대응 |
| §15 빈 행 기원 | `git show <rev>:CLAUDE.md \| awk '/^## 15\./{f=1} f&&/^\\|---/{getline nx; print (nx==""?1:0); exit}'` (이분 탐색) | `563c3f0` DATA → `9ba9dd3` BLANK |
| demote 무손실 | `git show e7f42d6:CLAUDE.md \| grep '^\| MASTER-ENGINEERING-BASELINE-001 \|'` → `grep -Fxc -f -` | COLD 1 / CLAUDE.md 0 |
| COLD 계수 | `grep -c '^\| [A-Z0-9]'` / `grep '^\| [A-Z0-9]' \| cut -d'\|' -f2 \| sed 's/ //g' \| sort -u \| wc -l` | 164 / 162 |
| 소비처(자기 제외) | `grep -rl 'rule-footer-common' docs/rules .claude/rules docs/agent docs/design \| grep -v 'rule-footer-common.md' \| wc -l` | **23** (자기 포함 = 24) |
| 양성대조(자기 제외) | `grep -rl '명시 cycle 이력' docs/rules .claude/rules CLAUDE.md \| grep -v 'rule-footer-common.md' \| wc -l` | **15** (자기 포함 = 16) |
| §15 entry 크기 | `printf '%s' "<행>" \| wc -c` | **400B** (상한 ≤400B · 기존 3행 = 각 399B) |
| ChangeBudget | `git --no-optional-locks diff --numstat` | +17/−10 |

---

## §11. commit · ahead

→ **`§정정 append`** (= `reporting.md §15.2` · 본체 commit sha 는 commit 이후에만 확정 · K-156 = 「자기 sha」 아니라 **본체 sha**).

---

## §12. Negative space (= `reporting.md §13` · `anchor-list.md §4`)

고려했으나 hot 제외 영역: **COLD `:3`·`:25` 말미의 「최근 5」 stale 2곳**(= T4 4 좌표 밖 · 같은 file 이라 묶고 싶은 유혹이 컸으나 **§0-ⓒ 「§12 재정렬을 하지 않는다」와 같은 성격의 경계**로 판단해 N10 회부) · **`rule-routing-index.md` 표기 관례**(N8 · T3 에 「완전 ID 표기」 구를 넣으면 자연 흡수됐겠지만, 발주가 명시한 필수 구는 **인용 제외** 하나뿐이라 규약을 임의 확대하지 않았다) · **게이트 G3·G8 자기 제외판으로의 문안 교체**(N12 · 게이트는 verbatim 실행 대상이라 본 판이 고칠 자리가 아니다).

---

## §정정 append (= 본체 commit 이후 사후 기입 · `reporting.md §15.2`)

<!-- 본체 commit sha · 마감 porcelain · 마감 스캔 · 최종 ahead = commit 직후 기입 -->
