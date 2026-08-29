# REPORT — MASTER-ENGINEERING-BASELINE-002

> 발주 = `cc-paste-MASTER-ENGINEERING-BASELINE-002.md` (cowork 210차-h · 2026-08-29)
> 판 종별 = master cycle · 패턴 1 · 문서 층 · production code 0 · 보호 5 sha 0 · 자식 3 repo 0
> 소관 = cli · push = 0 (Coin)
> ★본 REPORT 의 절 구성 = 본 판이 방금 신설한 [`reporting.md §15.1`](../../../docs/rules/reporting.md) 12 축의 **자기 준수**. 말미 `§정정 append` = §15.2 자기 준수.

---

## 0. 판정

**PASS** — 게이트 **14/14** · STOP S1~S7 **발동 0** · T1~T8 **8/8 착지** · 001 착지분 무손상(G10 `1 1 1 1 1` · G14 `16`).
편차 4 + 자수 2 + 이의 2 + 회부 6 은 아래 §4 · §5 · §8 에 자로 재현해 붙였다.

---

## 1. BASELINE 진입 재측 (2026-08-29 KST · 발주 인용 아님)

| 축 | 발주 §0 인용 | 진입 실측 | 판정 |
|---|---|---|---|
| repo | HEAD `48e75de` · ahead 3 · porcelain 0 | **동일** | 일치 |
| §15 hot 3 ID | HYGIENE / SECRET / BASELINE-001 | **동일** | 일치 |
| 게이트 「전」 14 항 | §6.1 「전」 열 | **14/14 재현** | 일치 (§9-1 답) |

★**S7 미발동** — 발주와 실물이 갈린 축 **0**. 단 발주 **본문**의 좌표 1건이 실물과 갈렸다(= §4 편차 1 · 게이트 축 아님).

---

## 2. 착지 (T1~T8 · `path` | `line` | `anchor` · 편집 후 재측값)

| T | path | line | anchor |
|---|---|---|---|
| T1 | `docs/rules/verification-and-review.md` | 40 | `### 0.5 순서·정렬의 자` (§0.4 뒤 · `## /verify 규칙`=51 앞 · n<m) |
| T2 | `docs/rules/cycle-discipline.md` | 166 | `- ★**ⓖ 발주는 집행 시작 시점에 동결된다** (K-153).` (§32 ⓕ 뒤) |
| T3 | `docs/rules/cycle-discipline.md` | 65 | `- ★**④ context 압축 후 재개 시, …** (K-148).` (§12 ③ 뒤) |
| T4 | `.claude/skills/disk-verification/SKILL.md` | 66 / 95 | 표 `| ⑦ |` 행 / `**⑦ 세부**:` (K-150·K-151·K-147) |
| T5 | `.claude/skills/disk-verification/SKILL.md` | 89 | `**★게이트 작성 규약 2**` (⑥ 세부 말미 · K-152-ⓐ·ⓑ) |
| T6 | `docs/rules/reporting.md` | 337 | `## §15 REPORT.md 형식` (§14 뒤 = 말미 · §11 `:296` 무접촉) |
| T7 | `.auto-memory/protected-file-hashes.md` | 44 · 129 | advisory 2 행 정정 (★보호 sha 표 `:13`~`:17` **무접촉**) |
| T8 | `CLAUDE.md` | 296 · 302 | 상한 규약 blockquote 「★방향」 1줄 / 신 entry (맨 아래) · demote 1 (맨 위) |
| T8 | `.auto-memory/master-cycle-history-COLD.md` | 190 | demote 행 verbatim append (표 말미) |

**T5 위치 판정** — 발주 §6.1 G5 가 「값은 같으나 **위치는 §1-T5 계약이 정한다**」라 명시 ⟹ ⑥ 세부에 착지. 단 기존 `**★발주 자기 정합 3 자**` 목록에 직접 끼우면 그 「3」이 거짓이 되므로, **별 sub-block 으로 분리**해 「3 자」를 참으로 유지했다.

---

## 3. 게이트 14 (전 → 후 · 시점 · 판정 · 자 = 발주 §6 블록 verbatim · `bash` 추출 실행)

| G | 시점 | 전 | 후 | 판정 |
|---|---|---|---|---|
| G1 | 무관 | `0 (공백) 42` | `1 40 51` (n<m ✓) | PASS |
| G2 | 무관 | `0` | `1` | PASS |
| G3 | 무관 | `0` | `1` | PASS |
| G4 | 무관 | `0 0` | `1 1` | PASS |
| G5 | 무관 | `0 0` | `1 1` | PASS |
| G6 | 무관 | `0 0` | `1 3` (≥2 ✓) | PASS |
| G7 | 무관 | `0 0 1 0 0 0 0 0` | `1 1 1 1 1 2 1 1` (8 전량 ≥1) | PASS |
| G8 | 무관 | `0 151 250 204 243` | `1 250 250 243 243` (2·3 동일 · 4·5 동일) | PASS |
| G9 | **cycle 마감** | `3 3 0 0` | `3 2 1 0` (표행 3 · 잔존 2 · 내려감 1 · **유실 0**) | PASS |
| G10 | 무관 | `1 1 1 1 1` | `1 1 1 1 1` 불변 | PASS (S4 미발동) |
| G11 | 무관 | `916ff468` | `916ff468` 동일 | PASS (S3 미발동) |
| G12 | 무관 | 5 sha | `8502c014 31c0da56 92a5e998 202d3f4f 2bfc81c5` 전량 동일 | PASS (S2 미발동) |
| G13 | **cycle 마감** | `0` | `0` | PASS (S1 미발동) |
| G14 | 무관 | `16` | `16` | PASS |

★**G7 K-152 = `2`** — SKILL.md(ⓐ·ⓑ) + reporting.md §15.2(ⓒ) 2 file. 게이트는 `≥1` 을 재므로 정상.
★**「전」 값 14/14 재현** = 발주 §9-1 이 요구한 첫 보고. **불일치 0** ⟹ 발주의 「전」 열은 실제로 잰 값이었다.

---

## 4. 편차 · 이의 (방어 아님 — 자로 재현해 붙인다)

### ★자수 1 — 진입 첫 명령에 금지된 `2>` 를 썼다

발주 §금지 = 「명령에 `2>` 를 치지 않는다(`2>&1` · `2>/dev/null` 전부)」. **진입 BASE 측정 명령 1 회에 `2>/dev/null` 을 붙였다**(`git rev-list … 2>/dev/null || echo no-origin`). 발견 = 발주 §11 정독 직후 자가 검출. **이후 전 명령 0 회** · 존재 확인은 `ls` 단독으로 수행. 결과 오염 없음(그 명령의 산출 = ahead 3 = 이후 재측과 일치). **위반은 위반이므로 적는다.**

### ★자수 2 — 게이트를 손으로 재타이핑해 zsh 로 돌려 오판했다 (= G9)

T8 착지 직후 G9 만 확인하려고 게이트 1행을 **손으로 옮겨 기본 shell(zsh)** 에서 돌렸더니 `3 0 1 1` 이 나왔다 — 넷째 칸 `1` = **S5(손실 0 위반)** 신호였다.
**원인 = 자** — zsh 는 unquoted `$BASE15` 를 **단어 분할하지 않는다**(bash 와 다름). ⟹ `for id in $BASE15` 가 3 회가 아니라 **문자열 전체 1 회**로 돌아, HOT 에도 COLD 에도 없는 이름을 찾은 것.
발주 지시대로 **awk 추출 + `bash` 실행**하니 `3 2 1 0`. ★**발주가 「추출해 verbatim 실행」을 못박은 이유의 실증**이며, K-139(정정은 자까지)의 사례다 — 문면이 아니라 **실행 shell** 이 틀렸다.

### 편차 1 — 발주 §1-T1 의 K-131 좌표가 실물과 갈렸다 (S7 · 실물이 정본)

발주 T1 본문 = 「같은 판이 심은 **§0.1** 「파일 무접촉 ≠ 계약 무접촉」(K-131)」.
실측 = `verification-and-review.md §0.1` = **「범위의 자」(K-140·K-141)** · K-131 실 좌표 = **`.claude/skills/disk-verification/SKILL.md:87` §4 ⑥ 세부**(전수 grep = 본문 1 + thin pointer 인용 1).
⟹ 발주 문면을 그대로 옮기면 **거짓 좌표가 착지**한다(= K-136 이 금지하는 바로 그것). **참 좌표로 착지**시켰다.

### 편차 2 — SKILL.md §4 표제 계수 `①~⑥`→`①~⑦` (발주 열거 밖 · `-1/+1`)

⑦행을 넣으면 표제가 즉시 거짓이 된다. **선례 = 001(`1c30a84`)** 이 같은 자리에서 `①~⑤`→`①~⑥` 을 「T8 계수 정정 선례 동형」으로 집행 ⟹ **K-140(선례가 정본)** 적용. 유효한 기록 삭제 아님(계수 정정).

### 편차 3 — ChangeBudget 밴드 **하한 미달** (`+70` vs `+85~+140`)

계약(게이트 G1~G9)은 전량 충족인데 행수가 하한에 **15 행 못 미친다**. 원인 = 발주 추정이 후했다(T1 ~14→실 9 · T2 ~7→5 · T3 ~6→4 · T5 ~4→5 · T6 ~24→**34**). ★**밴드 미달을 채우려 문면을 늘리지 않았다** — 밴드는 계약이 아니라 추정이고, 늘리면 그게 곧 군더더기다.

### 편차 4 — 신 §15 entry 초안이 400B 상한을 넘어 재작성

초안 **508B** → 434B → **399B**(= 001 entry 399B 와 동급). 상한은 헌법 §15 규약이므로 **재작성이 정답**(원문 손실 없음 = 초안은 미commit).

### ★이의 1 — §15.2 는 기존 §8.2 와 문면끼리 충돌한다 (자동 봉합하지 않았다)

- 기존 `reporting.md §8.2` = 「**REPORT 는 자기 commit sha 를 담지 않는다**」 · 근거 = 「자기 sha 인용은 **backfill 을 구조적으로 강제**한다」.
- 발주 T6 = 「§8.2 와 **양립한다**(선기입이 아니라 **후기입**)」.
- ★**양립 주장은 §8.2 문면과 정확히 맞지 않는다** — §8.2 가 금지한 이유가 **backfill 강제**인데, `§정정 append` 는 **바로 그 backfill 을 의무화**한다. 「선기입 vs 후기입」 축은 §8.2 본문에 없다.

**처리** = `cycle-discipline.md §31` 「집행자 측 대칭 의무: 자동 봉합 금지 · 어느 쪽을 왜 우선했는지 보고」 적용.
⑴ **§8.2 무접촉**(발주 scope 밖 · 문면 정정은 별 판) ⑵ §15.2 안에 **경계 조항** 명시 — §8.2 의 대상 = **REPORT 본문**(본문은 자기 sha 없이 완결) · `§정정 append` = **append-only 꼬리로 격리된 유일 예외**(본문 재편집 아님) ⑶ **잔여 긴장 = 별 판 회부**(아래 §8).

### ★이의 2 — T7 은 「삭제 0」의 **예외가 아니다** (§9-2 답의 핵심 · 아래 §5-② 전개)

발주는 T7 을 「본 판 유일한 **실삭제성** 정정」으로 잡았다. **실측 결과 그 예외 설정 자체가 불필요**했다 — 같은 file 의 선례가 「구 값 병기」를 이미 쓰고 있어, **삭제 0 을 유지한 채** stale 을 없앨 수 있다.

---

## 5. §9 「나를 의심하는 절차」 5 항 답

### ① 「전」 값 전량이 재현되는가 — **재현 14/14**

`G8 = 0 151 250 204 243` ✓ · `G9 = 3 3 0 0` ✓ 포함 전 항 일치. **불일치 0** ⟹ 첫 보고할 편차 없음.
자 = 발주 §6 블록을 `awk` 추출 → **repo 밖 `bash` 프로세스 치환**으로 실행(파일 미기록 · `2>` 미사용).

### ② ★T7 이 「삭제 0」의 예외로 정당한가 — **정당하지만, 발주의 근거로는 아니다. 예외 자체가 불필요했다.**

발주 근거 = 「틀린 사실은 존치가 곧 stale」 ⟹ 구 값 **삭제**.
**선례를 재보니 이 file 은 stale advisory 를 두 갈래로 나눠 처리한다**(= K-140 선례가 정본):

| 갈래 | 선례 좌표 | 처리 방식 |
|---|---|---|
| **소멸**(file 이 없어짐) | `:76` `:77` `:88` | `~~취소선~~ (소멸)` + 「현재 부재」 + 폐기 사유 |
| **이동**(file 은 살아 있고 좌표만 변함) | `:126` (`RLS_AND_PLAY_INTEGRITY_GUIDE.md`) | **in-place 갱신 + 「구 경로 = …」 병기 + 귀속 cycle** |

본 건 = `code-principles.md` 가 **살아 있고** `.claude/rules/` → `docs/rules/` 로 **이동**했을 뿐 ⟹ **「이동」 갈래**.
⟹ **취소선도, 순삭도 아닌 「구 값 병기」** 로 착지: 실 좌표·실 행수를 참으로 만들되 **구 표기(`.claude/rules/` · 151 줄 · 204 줄)를 같은 행에 보존**.
**결과 = 삭제 0 과 stale 0 이 동시에 성립** ⟹ 발주 §7-② 가 「표면상 충돌」이라 부른 지점이 **실제로는 충돌이 아니었다**. 발주가 스스로에게 불필요한 예외를 허가한 셈이고, 그 예외를 **쓰지 않았다**.

### ③ T6 §15 를 `reporting.md` 말미(§14 뒤)에 두는 것이 옳은가 — **옳다(관례 일치)**

실측 = §11 이 「본 SoT 의 변경 정책」인데 그 **뒤에 실질 절 §12~§14 가 이미 온다** ⟹ 「변경 정책 = 말미」 관례가 이 file 에는 **없다**. 말미 append 가 이 file 의 실제 관례다. §11 `:296` **무접촉** 확인.

### ④ ★G9 의 `BASE15` 가 정말 「이름 하드코딩」을 피했는가 — **피했다. 축이 다르다. 단 더 나은 자가 있다.**

- **001 G19(결함형)** = 「`<특정 entry 이름>` 이 COLD 에 있나」 ⟹ **어느 항이 내려갈지를 게이트가 미리 결정**한다. 집행자가 **옳게** 다른 항을 내리면 FAIL.
- **본 판 G9** = `BASE15` 를 **진입 시점 집합**으로만 쓰고, 판정은 **집합 차**(`잔존 k` / `내려감 g` / `유실 l`)로 낸다 ⟹ **어느 항이 내려가는지 안 묻는다**. 실제로 넷째 칸 `0`(유실 0)이 계약이고, 그것이 S5 다.
- ⟹ **하드코딩된 것은 「분모」이지 「정답」이 아니다.** 분모는 진입 시점 관측이라 하드코딩이 **불가피**하고(비교 대상이 없으면 집합 차가 성립 안 함), 정답은 안 박혔다. **축이 다르다.**

★**더 나은 자 (권고 · 본 판 미적용)** — `BASE15` 조차 안 박으려면 **git 이 분모를 준다**:

```
BASE15="$(git --no-optional-locks show <진입sha>:CLAUDE.md | awk '/^## 15\./{f=1} f&&/^---$/{exit} f&&/^\| MASTER/' | cut -d'|' -f2 | tr -d ' ')"
```

진입 sha 하나만 있으면 분모가 **자동 도출**되어 발주가 ID 를 손으로 옮길 일이 없다(= 옮겨 적다 틀릴 여지 0).
**본 판에 적용하지 않은 이유** = 게이트 블록은 **발주 계약**이고, 집행자가 진입 후 계약 문면을 바꾸는 것은 **방금 본 판이 심은 K-153(발주 동결)** 위반이다. ⟹ **다음 판으로 회부**(§8). ★이 자기 억제 자체가 T2 의 첫 적용 사례다.

### ⑤ 본 판이 「규율을 심으면 다음 판이 나아진다」를 증명하는가 — **아니다. 본 판도 같은 일을 겪었다.**

집행 중 새 사고 **2 건 자가 검출**(자수 1 = 금지 `2>` · 자수 2 = zsh 자 오판) + 발주 결함 **2 건**(편차 1 좌표 오기 · 이의 1 문면 충돌).
⟹ **001 → 002 로 사고 수가 0 이 되지 않았다.** 규율은 사고를 **없애지 못하고 잡히게** 만든다 — 자수 2 는 심어둔 K-139(정정은 자까지) 덕에 「내 집행이 틀렸나」가 아니라 「자가 틀렸나」로 먼저 갔고, 그래서 3 분 만에 shell 차이로 좁혀졌다.
**본 판에서 이 축을 닫지 않는다**(닫는 척이 더 나쁘다). 검증자 = **A-1 접수**이며, 그때 「002 문면이 실제로 인용·집행됐는가」를 잰다.

---

## 6. ChangeBudget (행 단위 · `cycle-discipline.md §30` · 밴드가 스스로를 정의한다)

**분류** = 문서 본문 행만(주석·KDoc 축 = 0[문서 file] · test 축 = 0 · **재작성 file = 0**). REPORT.md(본 file) = 산출물이라 밴드 밖.

| T | file | +행 | −행 | 발주 추정 |
|---|---|---|---|---|
| T1 | `verification-and-review.md` | 9 | 0 | ~14 |
| T2 | `cycle-discipline.md` (§32 ⓖ) | 5 | 0 | ~7 |
| T3 | `cycle-discipline.md` (§12 ④) | 4 | 0 | ~6 |
| T4 | `disk-verification/SKILL.md` (⑦행+⑦세부) | 7 | 0 | ~10 |
| T4′ | `disk-verification/SKILL.md` (표제 계수) | 1 | 1 | (열거 밖 · 편차 2) |
| T5 | `disk-verification/SKILL.md` (게이트 규약 2) | 5 | 0 | ~4 |
| T6 | `reporting.md` §15 | 34 | 0 | ~24 |
| T7 | `protected-file-hashes.md` | 2 | 2 | ±0 (`-2/+2`) |
| T8 | `CLAUDE.md` §15 | 2 | 1 | +1 + entry ±0 |
| T8 | `master-cycle-history-COLD.md` | 1 | 0 | +1 |
| **계** | **7 file + CLAUDE.md** | **70** | **4** | 밴드 `+85~+140` |

★**밴드 하한 15 행 미달** (= 편차 3). **초과 아님 · 미달**이며, 채우려 늘리지 않았다.
★**삭제 4 행의 정체** — T7 `-2`(구 advisory 2 행 · **구 값은 같은 행에 병기 보존** ⟹ 정보 손실 0) + T4′ `-1`(표제 계수) + T8 `-1`(demote 행 · **COLD 에 verbatim 실재 확인**). ⟹ **유효 기록 삭제 = 0.**

---

## 7. STOP · 회귀 그물

| # | trigger | 발동 | 근거 |
|---|---|---|---|
| S1 | 자식 3 repo 경로가 diff 에 등장 | **0** | G13 `0` |
| S2 | 보호 5 sha 변동 | **0** | G12 5 sha 전량 동일 · 추가로 `\| \`docs/` 시작 행 diff **0 행** 실측(= sha 표 `:13`~`:17` 물리적 무접촉) |
| S3 | `stop-canonical.md` sha 변동 | **0** | G11 `916ff468` 동일 |
| S4 | 001 착지 문면 삭제 | **0** | G10 `1 1 1 1 1` 불변 · G14 `16` |
| S5 | §15 hot ≠ 3 · demote 항 COLD verbatim 부재 | **0** | G9 `3 2 1 0` · `grep -Fxc` **exact-string 1** (아래 자 대조표) |
| S6 | production code · `build.gradle.kts` 접촉 | **0** | 착지 file 8 = 전량 문서/manifest |
| S7 | 발주 ↔ 실물 갈림 | **게이트 축 0** | 「전」 14/14 재현. 단 발주 **본문** 좌표 1건 갈림 = 편차 1(실물 정본으로 착지) |

**회귀 그물** = STOP 7 + 게이트 14 + G10·G14(001 착지분 무손상 재측) + 눈검증 1.
**눈검증** — 「`reporting.md §15` 를 처음 읽는 사람이 **『자기 sha 는 어디에 적나』**에 답을 얻는가」 ⟹ **얻는다**: §15.2 첫 문장이 대상 값 4 종(자기 commit sha · 마감 porcelain · 스캔 결과 · 최종 ahead)과 착지처(`§정정 append`)를 한 문장에 적고, 바로 아래 §8.2 경계 조항이 「본문에는 왜 안 적나」를 답한다.

---

## 8. 회부 (★원장 번호 부여 = cowork · 코드 주석 아님)

**유지 2** (발주 §10-⑷ 그대로):
- **#130** propagation 미이행 — 001 + 002 **양쪽 몫**. ★본 판이 `.claude/skills/disk-verification/SKILL.md` 를 또 만졌으므로 A4(단방향 propagation) 상 미이행 잔존이 **누적**됐다. 별 cycle.
- **#132** ktlint #72 문면 재저작 — 별 판.

**신규 4** (= 본 판이 실측으로 **발견**했으나 scope 밖이라 안 고친 것 · 발주 §10-⑷ 는 「신규 0」을 예상했다):
1. ★**manifest advisory stale 2 건 더** — T7 과 **동류**인데 발주가 안 잡았다. `protected-file-hashes.md:45` = `.claude/rules/design-to-code-sync.md` (103 줄) → 실물 **`docs/rules/` · 261 줄** · `:46` = `docs/design/design-sot-policy.md` (153 줄) → 실물 **156 줄**. **고치지 않았다** = scope expansion(A3) 회피 · ChangeBudget 은 T7 을 `-2/+2` 로 못박았다.
2. ★**`CLAUDE.md §15` 의 400B 상한이 이미 깨져 있다** — `MASTER-SECRET-PATTERN-STACK-001` entry = **745 B**(상한 400B · 실측). 본 판 entry 는 399B 로 맞췄으나 **선행 판이 남긴 위반은 그대로**다. 규약이 자기 표 안에서 안 지켜지고 있다.
3. **`reporting.md §12` 이력이 자체 drift** — §8.2(2026-08-15) · §1.1(2026-08-23) **2 건이 §12 미등재**. 본 §15 도 최근 선례(2 연속 미등재)를 따라 미등재로 뒀다. 「§ 신설은 §12 에 적는다」가 실효했는지 판정 필요.
4. ★**G9 분모 자동 도출** (= §5-④ 권고) — 게이트가 `BASE15` 를 손으로 들고 있을 필요가 없다. 진입 sha 에서 `git show <sha>:CLAUDE.md` 로 도출하면 발주가 ID 를 옮겨 적을 일이 없다. **본 판 미적용 = K-153(발주 동결) 준수.**

**negative space** = §11.

---

## 9. commit · ahead

| # | sha | 내용 | file |
|---|---|---|---|
| 1 | `d46f79c` | T1 · T2 · T3 (자·판개설·세션 규율) | `verification-and-review.md` · `cycle-discipline.md` |
| 2 | `0ac9d68` | T4 · T5 · T6 (발주 저작 + REPORT 형식) | `disk-verification/SKILL.md` · `reporting.md` |
| 3 | (아래 `§정정 append`) | T7 · T8 + 본 REPORT | `protected-file-hashes.md` · `CLAUDE.md` · `master-cycle-history-COLD.md` · 본 file |

**push = 0** (Coin 소관) · `git add` = **명시 경로만**(`-A` 미사용).
★**ahead 고정 게이트 없음**(K-152-ⓑ) ⟹ 정정 commit 을 붙여도 게이트가 깨지지 않는다. 최종 ahead = 아래 `§정정 append`.

---

## 10. 자 대조표 (= `verification-and-review.md §0.4` 의무의 자기 준수)

| 자 | 명령 |
|---|---|
| 게이트 14 (전/후) | `bash <(awk '/^```bash$/{f=1;next} f&&/^```$/{exit} f' <발주>)` — ★**repo 밖 프로세스 치환** · 파일 미기록 · `2>` 0 |
| 진입 BASE | `git --no-optional-locks log --oneline -1` · `git --no-optional-locks status --porcelain \| wc -l` |
| 행수 (T7) | `wc -l docs/rules/code-principles.md docs/guides/app-implementation-guide.md` |
| 보호 sha 표 무접촉 | `git --no-optional-locks diff -U0 <manifest> \| grep -c '^[+-]\| \`docs/'` → **0** |
| S5 verbatim 실재 | `ROW=$(git --no-optional-locks show 48e75de:CLAUDE.md \| grep '^\| MASTER-PROPAGATION-HYGIENE-001'); grep -Fxc "$ROW" <COLD>` → **1** (★`-F` 고정문자열 + `-x` 행 전체 일치) |
| entry 400B | `awk '<§15 창>' CLAUDE.md \| … printf '%s' "$l" \| wc -c` → **399** |
| 행 단위 ChangeBudget | `git --no-optional-locks diff --numstat 48e75de HEAD` + `git --no-optional-locks diff --numstat` |
| demote 방향 선례 | `git --no-optional-locks log -p -1 -- CLAUDE.md \| grep -E '^[+-]\| MASTER'` → **맨 위 제거 · 맨 아래 추가** |
| 선례(§12 blockquote 미추가) | `git --no-optional-locks show 1c30a84 -- docs/rules/cycle-discipline.md \| grep -cE '^\+> 2026-08-29'` → **0** |
| K-131 실 좌표 | `grep -rn 'K-131' docs/rules .claude/skills .claude/rules` |

★**환경** (= `reporting.md §8.1`): shell = **bash**(게이트 · zsh 아님 = 자수 2 의 교훈) · 해시 = `shasum -a 256` · cwd = `~/AndroidStudioProjects/claude-cli-master` · 계수는 **헤더 제외**(데이터행만 · `HOT | grep -c '^| '`).

---

## 11. 고려했으나 hot 제외 영역 (negative space · `reporting.md §13`)

`reporting.md §8.2` 본문 정정(= 이의 1 의 근본 해소 · 별 판) · manifest advisory 동류 stale 2(= 회부 1) · `§15` SECRET entry 745B 축소(= 회부 2) · G9 분모 자동화(= 회부 4) · 자식 3 propagation(= #130) · `.claude/rules/` ↔ `docs/rules/` 이전 잔재 전수 sweep.

---

## §정정 append (= 본 판이 방금 신설한 `reporting.md §15.2` 의 **자기 준수** · commit 후 확정값 후기입)

> ★**이 절의 존재 이유** — 아래 4 값은 **본 REPORT 를 담은 commit 이 존재한 뒤에만** 알 수 있다. 직전 2 판이 이 값들을 채팅에만 남겨 원장 담당이 놓쳤고, 그 사고가 §15.2 를 만들었다. **paste-back 이 유실돼도 이 절만으로 마감 좌표가 복원된다.**

| 값 | 확정치 |
|---|---|
| 본 REPORT commit sha (= commit 3) | `<후기입>` |
| 마감 porcelain | `<후기입>` |
| 시크릿 스캔 결과 | `<후기입>` |
| 최종 ahead | `<후기입>` |
| 마감 게이트 재실행 | `<후기입>` |
