# REPORT — MASTER-ENGINEERING-BASELINE-001

> **판** = master cycle · 패턴 1(`cycle-discipline.md §15`) · **문서 층** · production code 0 · 빌드 0 · 스키마 0 · 보호 5 sha 0 · 자식 3 repo 0.
> **발주** = `cc-paste-MASTER-ENGINEERING-BASELINE-001.md` (cowork 210차-e · 2026-08-29).
> **소관** = cli. **push = 0 (Coin 소관).**
> **판 경계 1줄** = 「원칙이 집행되는 두 자리 = master 규약 문면」. 자식 propagation 을 뺀 것은 **크기 때문이 아니라** `cycle-discipline.md §15` 패턴 1 이 master 착지 → propagate → verify-sync 를 **별 step** 으로 정했기 때문이다.

---

## 0. 판정

**PASS** — 대상 문서 10본 착지 + 확인만 1본(T12) 무접촉 증명. 게이트 20 항 중 **19 항 기대값 충족** · **1 항(G19 둘째 칸) = 발주 게이트 자체의 결함으로 인한 편차**(아래 §4-이의 1). STOP S1~S7 **미발동**.

---

## 1. BASELINE (진입 실측 · 2026-08-29 KST)

| 축 | 발주 문면 | 진입 실측 | 판정 |
|---|---|---|---|
| HEAD | `88d4141` | `88d414184284964f9a5a4d98332a9cfd79a841a4` | 일치 |
| ahead / porcelain | 0 / 0 | 0 / 0 | 일치 |
| 대상 10본 + 1본 행/sha8 | §2 표 | **13/13 전량 일치** | 일치 (S7 미발동) |
| 게이트 「전」 값 20 항 | §8.1 | **20/20 재현** | 일치 |

★**발주 §10-① 의 요구(「집행 전 §8 을 그대로 돌려 「전」 값을 재현하라」) 이행**: 게이트 블록을 발주서에서 `awk` 로 추출해 **repo 밖**(`~/AndroidStudioProjects/gate-MASTER-ENGINEERING-BASELINE-001.sh`)에 두고, 추출분이 원문 `:287~:310` 과 **byte 동일**함을 `diff` 로 확인한 뒤 verbatim 실행했다. **20 항 전량 재현 · 불일치 0.**

---

## 2. 착지 (T1~T13)

| T | 파일 | 한 일 | 상태 |
|---|---|---|---|
| T1 | `docs/rules/code-principles.md` | **§0 신설** — §0.1 원칙 5(「최소 변경」 완료 조건 아님 명문) · §0.2 **SRP 재정의**(「하나의 변경 이유」에 **생존주기** 포함 · 파일 크기는 자가 아님 · K-145) · §0.3 집행 형태 3열 표 + **K-132**. §1~§6 **무접촉** | 착지 |
| T2 | `docs/rules/cycle-discipline.md` | **§32 판 개설 규율** 신설 — ⓐ 병 정의는 트랙이 갖는다(K-145) ⓑ 부채는 목표 축·전사 ⓒ 개설 전 실물 census·**판 취소 가능**(K-144) ⓓ 관측 목록 분모 금지(K-134) ⓔ 감사 분모 = 절 전수(K-146) ⓕ 착지마다 목표 대조표 | 착지 |
| T3 | `docs/rules/verification-and-review.md` | **§0 자(尺) 규율** 신설 — §0.1 범위(K-141·K-140) · §0.2 좌표(K-136·K-138) · §0.3 계수(K-133 + **git diff 3 함정** K-137) · §0.4 정정(K-139 + **자 대조표 의무**) | 착지 |
| T4 | `.claude/skills/disk-verification/SKILL.md` | **§4 의무 ⑥ 행 + ⑥ 세부** 신설 — 필수 요건 5칸(의존성 **3축**·K-135 / 예측 red **실행** / 문서·주석 / 부채 **원장 번호** / 회귀 그물) + 판 경계 1줄 + **자기 정합 3 자**(K-142·K-143·K-131). 표제 계수 `①~⑤`→`①~⑥` 정정 | 착지 |
| T5 | `docs/rules/paste-authoring-disk-verification.md` | **Migration 이력 1행만** · **본문 복제 0** (thin pointer 유지 · 19→20행) | 착지 |
| T6 | `docs/agent/architecture/KOIN_DI_BASELINE.md` | §4 정정(`viewModelOf` / `koinViewModel`) + **구 `factory` 예시 = 주석으로 존치**(삭제 0) + 오독 방지 경고 1블록 + **§4a 소유·수명 규약**(ⓐ~ⓔ) + §7 pointer | 착지 |
| T7 | `docs/guides/app-implementation-guide.md` | **§1.6 상태의 소유와 수명** 신설(= hoist 상한 = 화면 · 본문 SoT = §4a pointer · 중복 0) + §3.1 **소유자 지정 step** + §1 표제 계수 정정 | 착지 |
| T8 | `docs/rules/code-style-guide.md` | **§C C-4 구현부 주석 = 판단 근거** 신설(① 선택지 ② 버린 이유 ③ 다음 사람) + 표제 `하드 규칙 3`→`4` | 착지 |
| T9 | `docs/rules/working-file-lifecycle.md` | **§9 변경·수정·폐기의 유지보수** 신설(ⓐ 불변식 퇴역 시 대체 자 ⓑ 「실물 없이 섰다」 ⓒ 소비처 census ⓓ 판 취소 = 한 판 ⓔ 이름 둘인 기계 ⓕ 발주↔원장 대조) | 착지 |
| T10 | `docs/rules/stale-artifact-tracking.md` | §3 **「발주·회부 대조」 행** + **K-149**(부재 분모에 `archive/` 포함 · 자기 검출 실측 동반) | 착지 |
| T11 | `CLAUDE.md` §15 + `.auto-memory/master-cycle-history-COLD.md` | 신 entry **399B**(≤400 PASS) + **최고령 1 COLD verbatim demote** · hot 데이터행 **3 유지** | 착지 (★대상 정정 — §4 이의 1) |
| T12 | `.claude/rules/stop-canonical.md` | **변경 0** — sha `916ff468` 무변동으로 「신설 0 이 옳다」를 증명 | 확인 완 |
| T13 | ktlint #72 | **본 판 밖** · `build.gradle.kts` 무접촉 · 문면 재검토로 회부(#132) | 회부 |

---

## 3. 게이트 20 (전 → 후 · 자 = §8 블록 verbatim)

| G | 전 (실측 재현) | 후 (실측) | 기대 | 판정 |
|---|---|---|---|---|
| G1 §0 순서 | `(공백) 13` | `13 53` | §0 < §1 | PASS |
| G2 최소변경금지 | `0` | `1` | ≥1 | PASS |
| G3 SRP생존주기 | `0` | `4` | ≥1 | PASS |
| G4 구문면존치 | `1 1` | `1 1` | 불변 | PASS (§1 무접촉 · S4 미발동) |
| G5 §32 | `0` | `1` | 1 | PASS |
| G6 자규율 | `0` | `1` | 1 | PASS |
| G7 K착지 (16) | `0`×16 | `2 3 1 1 1 1 1 1 1 1 1 2 2 1 2 1` | 전부 ≥1 | PASS |
| G8 5칸 | `0 0` | `1 1` | `1 1` | PASS |
| G9 thin유지 | `19 0` | `20 1` | `20 1` · ≤21 | PASS |
| G10 KOIN | `1 1 0` | `0 4 1` | `0 ≥2 ≥1` | PASS |
| G11 수명어휘 | `0 0 0` | `1 1 1` | 전부 ≥1 | PASS |
| G12 §1.6 | `0` | `1` | 1 | PASS |
| G13 C-4 | `0 0` | `1 1` | `1 1` | PASS |
| G14 §9폐기 | `0` | `1` | 1 | PASS |
| G15 §3표행 | `4 2` | `5 4` | `5 ≥3` | PASS |
| G16 전수트리자 | `1 3` | `1 3` | 불변(자기 검증) | PASS |
| G17 STOP무접촉 | `916ff468` | `916ff468` | 동일 | PASS (T12 계약 · S3 미발동) |
| G18 보호5 | `8502c014 31c0da56 92a5e998 202d3f4f 2bfc81c5` | **동일** | 전량 동일 | PASS (S2 미발동) |
| G19 §15상한 | `3 0` | `3 0` | `3 1` | ★**첫 칸 PASS · 둘째 칸 편차** → §4 이의 1 |
| G20 자식무접촉 | `0` | `0` (commit 후) | commit 후 0 | PASS (S1 미발동) |

**19 PASS / 1 편차.**

---

## 4. 편차 · 이의 (방어 아님 · 자로 재현해 붙인다)

### ★이의 1 — 발주 §3-T11 이 **최고령을 오지목**했다 (G19 둘째 칸 편차의 원인)

- **발주 문면**: 「최고령 1행(현 `MASTER-SECRET-PATTERN-STACK-001`)」 + 게이트 G19 둘째 칸 = `grep -c 'MASTER-SECRET-PATTERN-STACK-001' COLD`.
- **실측(선례가 정본 · K-140)**: 직전 §15 demote cycle `c570d1e` 의 diff —
  - hot 에서 제거 = **맨 위 행** `MASTER-STALE-TRACKING-001`(2026-08-17 = 최고령)
  - hot 에 추가 = **맨 아래** `MASTER-SECRET-PATTERN-STACK-001`(= 최신)
  - COLD 에 append = 제거한 그 행. `1 file changed, 1 insertion(+)`.
  ⟹ hot 표는 **위 = 최고령 · 아래 = 최신**. 세 행의 §15 entry 도입 commit 조상 순서(`791fed7` → `74424f2` → `c570d1e`)가 같은 결론을 준다.
- ⟹ `MASTER-SECRET-PATTERN-STACK-001` 은 **최신**이다. 발주대로 그것을 내렸다면 hot 은 **최신을 버리고 6일 더 오래된 행을 남겨** 헌법 §15 「본 표 = **최근 3 entry 만**」을 정면으로 깼을 것이다.
- **집행** = 실물 정본(S7) 채택 → 실제 demote = **`MASTER-AIDOC-RELEASE-REALIGN-001`**.
- **G19 둘째 칸이 `0` 인 이유** = 게이트가 **계약(「내린 행이 COLD 에 verbatim 있나」)이 아니라 file 명을 하드코딩**했기 때문. 발주 §8.1 legend 는 이 칸 0 을 「verbatim 손실 = S6 STOP」으로 읽지만 **그 판정은 무효**다 — 계약 축으로 다시 잰 결과:

```
diff <(awk 'NR==300' CLAUDE.md) <(awk 'NR==189' .auto-memory/master-cycle-history-COLD.md)
→ 출력 0 (exact-string 동일) = S6 「손실 0 = HARD」 충족
```
  ★**이 편차 자체가 본 판이 심은 K-131(「게이트는 계약 축으로 쓴다 — 파일 무접촉 ≠ 계약 무접촉」)의 실증**이다. 게이트가 file 명을 얼리면 계약을 못 지킨다.
- **계약 축 대체 자(권장)**: `grep -c 'MASTER-AIDOC-RELEASE-REALIGN-001' .auto-memory/master-cycle-history-COLD.md` = **1** · 일반형 = 「직전 hot 최상단 행 == COLD 최하단 행」 exact-string 비교.

### 편차 2 — 계수 정정 3건 (발주 열거 밖 · `-1/+1` · 삭제 0)

발주 §6 은 `-1/+1` 을 **T6 하나**로 예정했으나 실제 **3건**이 발생했다. 전부 **표제 계수가 자기 본문과 갈리는 것을 막는 정정**이며, 발주 스스로 T8 에서 같은 연산(`하드 규칙 3`→`4`)을 **지시**하고 있다 = 선례 동형:

| 파일 | 구 | 신 | 사유 |
|---|---|---|---|
| `disk-verification/SKILL.md` | `## §4 의무 ①~⑤` | `①~⑥` | ⑥ 행 신설로 표제가 자기 표를 miscount |
| `app-implementation-guide.md` | `## 1. … 핵심 5 원칙 (Google 공식 기반)` | `핵심 원칙 (= Google 공식 5 + 우리 1 · §1.6)` | §1.6 신설로 miscount. **인용처 census = 전수 트리 0**(자기 참조 1건뿐) 확인 후 정정 · Google 귀속은 보존 |
| `code-style-guide.md` | `채택 — 하드 규칙 3` | `4` | **발주 T8 명시 지시** |

+ `app-implementation-guide.md` §3.1 step 번호 2행(`5.`/`6.` → `6.`/`7.`) = **문면 동일 · 선두 숫자만**. 정정하지 않았다면 그 자리에 새 stale 문면이 생겨 T10 이 방금 신설한 §3 등재 의무를 즉시 발동시켰을 것이다.

### 편차 3 — G1 첫 칸 `12` 예상 → 실측 `13`

발주 §8.1 이 `12 13+` 로 적었으나 실측 `13 53`. **관계식(§0 < §1)은 충족** — `---` 뒤 한 줄 차이로, 명제 P1·눈검증 1 에 영향 0.

### ★T6 판단 (발주 §10-② 가 cli 에 위임한 축)

**정정을 수행했다** (「§4a 신설만으로 충분」을 택하지 않았다). 근거 = §4 는 KMP VM 주입의 **유일한 예시 코드**라, §4a 를 아래에 붙여도 **위에서부터 읽는 사람은 `factory` 를 현행 권장으로 읽는다**(눈검증 2 실패). 한 일:
1. `viewModelOf(::HomeViewModel)` + 호출부 `koinViewModel()` 을 **현행 예시로 승격**
2. 구 `factory { HomeViewModel(get(), get()) }` = **삭제하지 않고 주석 1행으로 강등** + 「구 예시(= 소유자도 scope 도 없는 형태 · 본 cycle 정정 대상 · 이력 존치 · 삭제 0)」 표기 → **원문 문자열은 `KOIN_DI_BASELINE.md:53` 에 그대로 실재**
3. 「`factory` 는 왜 안 되나」 경고 블록 1개 추가(= 수명·소유자 미지정이 문제라는 것을 명시)

⟹ G10 첫 칸 `1→0` 은 **삭제가 아니라 주석 제외 census** 의 결과다(발주 §8.1 이 예고한 그대로).

---

## 5. §10 「나를 의심하는 절차」 5 항 답변

1. **이 발주의 「0」들이 재현되는가** → ★**20/20 재현 · 불일치 0.** 게이트를 발주에서 `awk` 추출 → `diff` 로 원문 동일 확인 → repo 밖에서 verbatim 실행. 대상 13 file 의 행수/sha8 도 **13/13 일치**. 발주 수치를 인용하지 않고 전부 재측했다.
2. **T6 정정이 정말 필요한가** → **필요하다. 수행했다.** 위 §4-T6 판단 참조(§4a 만으로는 눈검증 2 가 깨진다).
3. **§0 을 맨 앞에 두는 것이 이 repo 관례와 맞는가** → ★**맞다. 선례가 정본(K-140).** `docs/rules/` 안 **첫 절이 §0 인 file 4본**(`gsm-measurement.md` · `pencil-mcp-tools-reference.md` · `rule-routing-index.md` · `ux-laws.md`) + `docs/guides/app-implementation-guide.md:10` + master `CLAUDE.md:24`. 게다가 그 §0 들은 전부 **「본질 / 적용 정책 / 계층 본질」= 뒤를 지배하는 상위 층**이라 본 판의 용법과 동일하다. ⟹ 위치 변경 **불요**.
4. **밴드 `+95~+150` 은 추정** → 본문 축 실측 **+164 / -7**(아래 §6). 초과 14 행은 **발주가 요구한 문면**(T6 경고 블록 + §4a·§1.6 pointer 정합)이라 §6 규정상 **초과가 아니다**. 행 단위 내역 = §6.
5. **「규약을 심으면 다음 판이 나아진다」는 미검증** → **동의. 미검증으로 남긴다.** 검증자는 본 판이 아니라 **A-1 접수**다 — 「A-1 게이트에 그 축 1개」 요구는 **A-1 발주 저작 측(cowork) 몫**이며 본 판의 산출물이 아니다. 본 판이 할 수 있는 것은 **자를 심어 둔 것**까지다. ★단 본 판 안에서 **부분 자기 검증 1건**은 성립했다: 본 REPORT 는 방금 신설한 `verification-and-review.md §0.4` 「자 대조표 의무」를 **스스로 준수**한다(§9).

---

## 6. ChangeBudget (`cycle-discipline.md §30` · 밴드가 스스로를 정의한다)

- **분류 기준**: 아래는 **문서 본문 행**만 센다. 주석·KDoc 축 = **0**(문서 file) · test 축 = **0** · **재작성 file = 0**(전량 삽입 / 1행 정정).
- **본문 축 실측 = `+164 / -7`** (밴드 `+95~+150` 대비 **+14 초과**)

| commit | file | +/- |
|---|---|---|
| 1 | 7 file (규율 층) | `+115 / -1` |
| 2 | 3 file (소유·수명) | `+49 / -6` |
| 3 | `CLAUDE.md` `+1/-1` · COLD `+1/-0` | `±1 / +1` |

- **초과 14 행의 내역** (= §6 「초과분이 본 발주가 요구한 문면이면 초과가 아니다」):
  - T6 `factory` 오독 방지 경고 블록 **+2**(§10-② 가 요구한 「현행 권장으로 읽히지 않게」의 실행체)
  - T6 §4a 「판정 축 2」 꼬리 + §4 주석 보강 **+3**
  - T1 §0.2 「SRP 의 자가 아닌 것」 확장 + §0.3 본문 SoT 3-pointer **+4**(K-145 핵심 요구)
  - T3 §0.3 git diff 3 함정을 **3개 항으로 전개** **+3**(발주가 「3 함정」을 명시)
  - T7 §1.6 위반 신호 + §3.1 step **+2**
- **삭제 7행** = 전량 **in-place 정정**(구 문면 보존): `factory` 예시 1(주석 존치) · 주석 헤더 1 · 표제 계수 3 · step 번호 2. ★**구 문면 삭제 = 0** ⟹ **S4 미발동** · 명제 P8 성립.

---

## 7. STOP · 회귀 그물

| STOP | 내용 | 결과 |
|---|---|---|
| S1 | 자식 3 repo diff 등장 | **미발동** — 10 file 전량 master-local (G20 · `--name-only` 대조) |
| S2 | 보호 5 sha 변동 | **미발동** — G18 5 sha 전량 동일 |
| S3 | `stop-canonical.md` sha 변동 | **미발동** — `916ff468` 무변동 (T12 = 변경 0 계약 이행) |
| S4 | 구 문면 삭제 | **미발동** — 삭제 7행 전량 in-place 정정 · 원문 존치 (§6) |
| S5 | `build.gradle.kts` / production code 접촉 | **미발동** — 0 |
| S6 | hot ≠ 3 또는 demote 대상 COLD verbatim 부재 | **미발동** — hot 데이터행 **3** · demote 행 exact-string 대조 **PASS** |
| S7 | 발주 ↔ 실물 갈림 | **발동 후 처리** — §15 최고령 지목 오류 1건: **실물 정본** 채택 + 본 REPORT §4 이의 1 로 보고 (자동 봉합 X) |

**회귀 그물**: 앞 판 불변식 A(갈피 prune 분모) · B(VM 프레임) = **코드 0 이므로 무접촉 확인만** — 본 판 diff 에 해당 경로 0. `verify-sync` / propagation = **본 판 밖**(별 cycle · 부채 #130).

**눈검증 2** (= `KOIN_DI_BASELINE.md §4` 를 처음 읽는 사람이 `factory` 를 현행 권장으로 오독하지 않는가): **통과** — 현행 예시가 `viewModelOf` 이고, 구 예시는 **주석 + 「구 예시」 라벨**이며, 바로 아래 **「`factory` 는 현행 권장이 아니다」 경고 블록**이 이유까지 적는다.

---

## 8. 회부 (부채 3 · ★코드 주석 아님 · 원장 번호 부여 = cowork)

- **#130 — propagation 미이행.** 본 판 = master 신설/정정 only. cli infra 4-repo byte-identical(= `.claude/skills/disk-verification/SKILL.md` 포함) 은 **별 follow-up cycle**(`cycle-discipline.md §15` 패턴 1 · `code-style-guide.md §E` 선례). ★대상에 `.claude/` 1본이 있으므로 **A4 anchor 상 미이행 상태가 남는다** — 다음 판에서 `propagate.sh` + `verify-sync.sh` exit 0 필요.
- **#131 — `protected-file-hashes.md` advisory 목록 stale 2.** 실측(`grep -n`): 그 manifest `:44` 가 `code-principles.md` 를 **`.claude/rules/`·151 줄**로, `:129` 가 `app-implementation-guide.md` 를 **204 줄**로 적는다. 실물 = **`docs/rules/`**(경로 자체가 오기) · **210 줄**(본 판 전) / **229 줄**(본 판 전). ★**본 판이 양쪽을 더 키웠다** → 실측 후행값 **250 줄 / 243 줄**(자 = `wc -l`) — 경로 오기까지 있어 **다음 sweep 에서 반드시 정정** 필요. 보호 5 manifest 의 **sha 대조 대상 자체는 무접촉**이며(G18 전량 동일), 문제는 그 file 의 **advisory 부록**이다.
- **#132 — ktlint #72 문면 재검토.** 설계 §4-4 의 「신설 file 위반 0」 ratchet 이 단계 1 접수에서 **달성 불가 판명**(레포 관용과 동종인 위반이 신설 file 에서도 난다). ⟹ 회부 문면을 **「레포 관용 동종 = 면제 · 관용과 무관한 신규 위반만 차단」** 으로 재저작 후 별 판. 본 판 `build.gradle.kts` **무접촉**.

---

## 9. 자 대조표 (= 본 판이 방금 신설한 `verification-and-review.md §0.4` 의무의 자기 준수)

| 자의 이름 | 자를 낸 명령 |
|---|---|
| 게이트 20 항 | `awk` 로 발주 `:287~:310` 추출 → `diff` 원문 대조 → `bash ~/AndroidStudioProjects/gate-MASTER-ENGINEERING-BASELINE-001.sh` |
| 대상 13본 행/sha8 | `wc -l < <f>` · `shasum -a 256 <f> \| cut -c1-8` |
| hot 표 최고령 판정 | `git --no-optional-locks show c570d1e -- CLAUDE.md \| grep -E '^[-+]\| MASTER'` · `git log --oneline --reverse 791fed7~1..c570d1e` |
| S6 verbatim 대조 | `diff <(awk 'NR==300' CLAUDE.md) <(awk 'NR==189' .auto-memory/master-cycle-history-COLD.md)` |
| 신 entry byte | `awk '{print length($0)}' <row-file>` = **399** (≤400) |
| hot 데이터행 | `awk '/^## 15\./{f=1} f&&/^---$/{exit} f&&/^\| MASTER/' CLAUDE.md \| grep -c '^\| '` = **3** |
| §0 선례 census | 첫 `^## ` 절이 `## 0.` 인 `docs/rules/*.md` 열거 loop |
| 「핵심 5 원칙」 인용처 | `grep -rn '핵심 5 원칙' . --include='*.md'` (전수 트리 · archive 포함) |
| 설계 SoT 소재 | `find . -name '*DESIGN-SELFWARD-ARCH-REBUILD*'`(master **0**) + `find ~/AndroidStudioProjects -maxdepth 3 …`(**부모 root 1**) |
| ChangeBudget | `git --no-optional-locks diff --numstat` · commit 별 `git show --stat` |

**환경**: macOS(Darwin 25.5.0) · zsh · BSD `awk`/`grep`/`shasum` · cwd = `claude-cli-master` · git 조회 전량 `--no-optional-locks`.

---

## 10. 명제 (§5)

| # | 명제 | 판정 |
|---|---|---|
| P1 | 원칙 5 가 master 문면에 존재 · 「최소 변경만으로는 완료 아님」 명문 | **성립** (G2) |
| P2 | SRP 의 「하나의 변경 이유」에 생존주기 포함을 master 가 말한다 | **성립** (G3 = 4) |
| P3 | K-131~K-146 **16 전량** master 규약 문면 착지 | **성립** (G7 전부 ≥1) |
| P4 | arch 층이 VM 수명 = 화면 수명을 말하고 `factory` 교과서 예시가 현행 지침 자리에서 내려갔다(이력 존치) | **성립** (G10 `0 4 1` · G11 `1 1 1`) |
| P5 | 발주 필수 요건 5칸이 본문 SoT 에 · thin pointer 는 본문 0 유지 | **성립** (G8 `1 1` · G9 `20 1`) |
| P6 | 변경·수정·폐기 규약 존재 | **성립** (G14) |
| P7 | `stop-canonical.md` 무접촉 | **성립** (G17 `916ff468`) |
| P8 | 구 문면 삭제 0 | **성립** (§6 · 삭제 7행 전량 in-place 정정) |
| 눈검증 1 | `code-principles.md` 를 위에서부터 읽으면 §0 이 §1 보다 먼저 | **성립** (G1 `13 53`) |
| 눈검증 2 | `factory` 를 현행 권장으로 오독하지 않는다 | **성립** (§7) |

---

## 11. 고려했으나 hot 제외 영역 (negative space · `reporting.md §13`)

- **파일별 `§cycle 이력` entry 추가** — `cycle-discipline.md`(변경 정책+demote 이력) · `code-style-guide.md §F` · `stale-artifact-tracking.md §9` 3본은 file 자체 이력 절을 갖는다. **제외**: 발주 T1~T12 어디에도 없고, 정본 원장 = `CLAUDE.md §15`(T11) + 본 REPORT 이므로 **세 번째 열거처가 곧 drift 원**이 된다(= 본 판이 §9-ⓔ 로 방금 심은 「이름이 둘인 한 기계」 회피).
- **G19 게이트 자체의 정정** — 계약 축(K-131)으로 다시 쓰는 것이 옳으나 **게이트는 발주 자산**이라 집행 측이 고치지 않는다(자동 봉합 금지). §4 이의 1 로 **회부**만 한다.
- **`protected-file-hashes.md` advisory 2 항 직접 정정** — 본 판이 그 수를 더 키웠지만(#131) **보호 manifest 접촉 = STOP #5 인접 영역**이라 별 판으로 회부.
- **자식 3 repo propagation** — #130.

---

*release 꼬리 = **N/A** (본 판 = 문서 층 master cycle · release / production-push 아님 · `reporting.md §1.1`).*
