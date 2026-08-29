---
name: disk-verification
description: Use before quoting on-disk state as fact — emitting a Recommended option or next-cycle candidate, authoring a cc-paste-<TASK-ID>.md umbrella (cowork side), deciding cycle scope, or verifying a paste-back (cli side). Measure with grep/find/git ls-files/Read first; prevents stale candidates and surface-pattern guessing. Covers both sides of the cowork↔cli responsibility split.
allowed-tools: Bash, Read, Grep, Glob
---

# Disk 실측 의무 paradigm (= 후보 발행 · paste authoring · scope 결정 · paste-back verify 공통)

> **한 줄**: 디스크를 사실로 인용하기 전에 **먼저 잰다**. 표면 패턴 추측 · 직전 cycle 측정값 재사용 · "있을 것 같다" 는 전부 위반.
> **통합** (2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001`): 구 판은 `disk-verification`(cli 측) + `paste-source-authoring`(cowork 측) **2 skill 로 갈라져 서로를 순환 참조**했다 (`disk-verification §3`↔`paste-source-authoring §8`). 같은 원칙의 두 적용면일 뿐이라 본 file 로 통합 — 단 **책임 분리는 §2 에 단일 SoT 로 보존**(= 구 `paste-source-authoring §12` 가 통합 후보를 명시하며 붙인 조건 그대로).
> **사례 / 인접표 / 이력** = `references/` 분할 (= 판정에 매번 필요하지 않은 층 · 아래 §8).
> **신설 계보**: `MASTER-CLI-RECOMMENDED-OPTION-DISK-VERIFICATION-PARADIGM-001` (2026-05-21) + `MASTER-CLI-PASTE-AUTHORING-DISK-VERIFICATION-PARADIGM-001` (2026-05-22).

---

## §1 적용 시점 (= trigger · 매 cycle 강제 X)

| 시점 | 측 |
|---|---|
| 후속 cycle 후보 발행 | cowork / cli |
| Recommended option 발행 **직전** | cowork / cli |
| `cc-paste-<TASK-ID>.md` umbrella authoring (= `§0` baseline · `§1`·`§1.3` 측정 인용 · `§2` scope · `§3` contract SoT) | **cowork** ⭐ |
| cycle scope file 영역 결정 | cli |
| 신 rule / 신 entry 신설 (= 중복 신설 차단) | cli |
| paste-back verify (= `[EC]` 섹션) | cli |
| 단순 정독 · 도메인 source 측정 | **적용 X** (= §7 화이트리스트) |

## §2 책임 분리 (= 단일 SoT · `cowork-project-instructions §B-1`+`§B-2` 정합)

| 주체 | 책임 |
|---|---|
| **cowork chat** ⭐ | paste source umbrella authoring 측 **disk 실측 의무** — `§0` baseline 측정 · `§1`+`§1.3` 측정 결과 인용 · `§2` scope file path × N disk verify · `§3` contract SoT 인용 entry × N **byte-identical quote** |
| **cli session** | **paste-back verify 의무** (= `[EC]` 섹션에 측정 결과 정합 명시) · paste source 측 명시 영역이 disk 에 없으면 **자율 scope 재정의**(= §4 의무 ③/④) + 사용자 보고 권장 |
| 사용자 본인 | terminal 진입 + paste 운반 + cleanup 결정 (= 자율) |

핵심: **authoring 측 실측 의무 = cowork 단일** · **verify 측 = cli**. 한쪽이 다른 쪽 몫을 대신 지지 않는다.

## §3 측정 명령 (= 무엇으로 재나)

```bash
# filename 1차 + content 2차 = 동시 의무 (A7 · cycle-discipline.md §17)
#   filename 부재만으로 "없다" 고 분류하지 않는다 — container 안을 열어 본다.
find <path> -name "<file-pattern>" -type f
grep -rn "<symbol>\|<keyword>" --include="*.<ext>" <path>
git ls-files | grep "<pattern>"

# 신 rule / 신 entry 중복 신설 차단 (= 0 match 여야 신설)
grep -rl "<new-rule-keyword>" .claude/ docs/rules/

# 갱신 vs 신설 판정 (= 기존 영역에 이미 있나)
grep -ni "<paradigm-keyword>" docs/rules/<existing-rule>.md
```

> **부재 판정은 전수 트리에서만** (= `code-principles.md §2`): staged 사본 · 단일 repo cwd glob · 부분 grep 위의 "없다" 는 **무효** — 없는 게 아니라 안 본 것이다. 범위 밖이면 「부재」가 아니라 **「판정 보류」**.
> ★**자를 고르는 규율의 본문 SoT = [`verification-and-review.md` §0](../../../docs/rules/verification-and-review.md)** — §0.1 「도구가 잡는 범위 ≠ 판정 범위」 · §0.3 「자기 제외 · 행별 칸 수 · 단위 병기」 · §0.6 「명제의 자」. **여기서 재복제하지 않는다** (K-147 · §0.4 선례 동형).

## §4 의무 ①~⑦

| # | 의무 | 위반 시 |
|---|---|---|
| ① | 후보 발행 시 **disk 측 이미 구현 여부** 측정 | 표면 추측 = 위반 |
| ② | Recommended option 발행 **직전 재측정** (= 직전 cycle 측정값 재사용 금지 · baseline drift) | stale 발견 = 발행 차단 + 재측정 |
| ③ | **부분 구현** 발견 시 **scope 재정의** (= 신 본질만 명시 · 표면 stale 후보 명시 X) | cli 자율 또는 본심 회수 |
| ④ | **완전 stale** 발견 시 **후보 제거 또는 대체** | 본심 회수 또는 cli 자율 스킵 |
| ⑤ | **paste source authoring 자기 정합** — 발행하는 paste 자체가 본 paradigm 사례여야 한다 (= `§0` baseline · `§3` 인용 entry 실재 측정 · 가정 X) | paste-back 본문에 위반 명시 |
| ⑥ | **발주 필수 요건 6칸 자기 검사** (= 발행 전 · 1 칸 부재 = 발주 미완) | 발주서 반려(저작 층 게이트) |
| ⑦ | **발행 전 게이트 실행 + 발주 3종 세트** (= 「전」 값은 재는 것이지 적는 것이 아니다) | 미실행 발행 = 발주 미완 |

**⑤ 세부** (= cowork authoring 3 의무):

1. `§1`+`§1.3` **측정 결과 인용** — scope file × N 의 `grep`/`find`/`git ls-files`/`Read` 실측 결과 본문 인용 (가정 X)
2. `§3` contract SoT **byte-identical quote** — precedent rule + 인용 entry × N · `line N~M` 형식 · 본문 변형 X
3. `§2` scope **file path 전량 disk 측정** — 부재 발견 시 scope 재정의 의무 (= ③/④ 정합)

**⑥ 세부** (= 신 발주 필수 요건 6칸 · 발행 **전** 자기 검사 · 원칙 층 SoT = [`code-principles.md`](../../../docs/rules/code-principles.md) §0.3 · ★칸 수 = 2026-08-29 `MASTER-TASK-PURPOSE-CONTRACT-001` 이 **⑹ 배경·목적**을 신설해 한 칸 늘었다):

1. **의존성 영향** — ★**3축을 각각 적는다**: ⑴ **선언**(`libs.versions.toml` / `build.gradle.kts` 에 쓰였나) ⑵ **해상**(의존성 트리에 실제로 들어오나 · 전이 포함) ⑶ **컴파일 기준**(어느 버전으로 컴파일되나 · 충돌 해상 결과) + **승급 여부**(transitive → direct 승급이 필요한가). ★**K-135 — 「선언 0」은 「부재」가 아니다**: 전이 의존은 선언에 안 보인다. 부재를 주장하려면 **POM / `dependencies` 해상**으로 잰다(선언 grep 은 ⑴ 축만 잰다).
2. **테스트** — ★**예측 red 를 실제로 실행한다.** 「이 게이트는 지금 0 일 것이다」는 **적는 것이 아니라 재는 것**이다 — 발행 전에 돌려 red 를 **박제**하고 그 출력을 발주에 붙인다. **소스 명제 test 우선**(계수 게이트보다) · 무접촉 tree 의 red 는 대조군으로 그대로 박제한다.
3. **문서·주석** — 「무엇을 했나」가 아니라 **「왜」** 를 적고, **갱신 대상 매핑**(이 변경으로 거짓이 되는 문면 = `file` × 절)을 함께 적는다. 매핑 0 이면 「0」 + 근거.
4. **유지보수 부채** — ★**원장 회부 번호(`#NN` / `<PREFIX>-TNNN`) 동반.** 이 판이 **남기는 것**을 적는다 · **0 이면 「0」이라 적고 근거**. 번호 없는 「후속」 = 미완 (= `code-principles.md` §0.3 **K-132** · 주석은 대장이 아니다). ★**「남긴 부채」 옆에 「만든 부채」를 적는다** — 이 판이 **새로 만든 것**도 잰다: **진입 rev ↔ 마감 rev 에 같은 자를 돌려** 차이를 적는 **시점 대조**(분모는 손으로 옮기지 말고 `git show <진입sha>:<path>` 로 자동 도출 = 아래 **⑦ 세부 4** 정합). **0 이면 「0」 + 자.** ★**실측** = `App.kt` 의 「선언했으나 사용 0 인 `koinInject`」가 어느 판 착지에서 **0 → 22 한 걸음에** 늘었다(자 = 사용 축 census · 시점 대조 7 rev · 2026-08-30 · 단위 = 획득 건). 그 판 REPORT 에 「신규 부채」 **0 hit** — **재는 자가 없어서 아무도 안 쟀다.** 「남긴 것」만 묻는 칸은 **이 실패를 구조적으로 통과시킨다.**
5. **회귀 그물** — ⑴ **계약 축 STOP** ⑵ **앞 단계 불변식 재측**(직전 판이 세운 수가 아직 그 값인가) ⑶ **눈검증**(사람이 읽었을 때 오독하지 않는가 = 기계가 못 재는 축).
6. **배경·목적** — ★**「무엇을」 앞에 「무엇을 위해」를 적는다.** ⓐ **없으면 무엇이 깨지나**(현상 = **실측** · 추정은 「추정」이라 적는다) ⓑ **무엇을 위해 하나** = 상위 목표의 **좌표**(`문서 §절` / 원장 `#NN` / KR 태그 · ★**문장이 아니라 좌표** — 문장은 복붙되고 **좌표는 round-trip 으로 검증된다**) ⓒ ★**이 판이 아닌 것** 1~3 줄(= **범위 오해가 할루시의 주 경로**). ★**1 칸이라도 부재 = 발주 미완**(= ①~⑤ 와 **동급**). 태스크 층 대응물 = [`reporting.md §3`](../../../docs/rules/reporting.md) `## 배경` · 집행 측 대응 의무 = 아래 **⑦ 세부 3**(재진술 · K-155).

\+ **판 경계 1줄** — 이 판의 경계가 **왜 여기인가**. ★**「작아서」가 이유이면 판을 다시 잡는다**(= 범위 축소가 기본값이 아니다). ★**⑹ 과 다른 것이다**: **경계 = 「왜 여기서 자르나」 · 배경 = 「왜 이걸 하나」.** 실측 = 이 둘을 같은 것으로 읽어 **요건 칸이 이미 배경을 담고 있다고 착각**했고, 그 착각 위에서 **관련 6 층 중 5 층에 배경 절이 0** 이었다 (= 2026-08-29 전수 census).

**★발주 자기 정합 3 자** (= 발행 전 · 저작 층 게이트):

- ★**K-142 — 「대상 × 절」 교차표.** 발행 전에 **대상 × (계약 · 게이트 · STOP)** 을 표로 돌린다. **한 대상에 두 규정이 걸리면 어느 쪽이 이기는지를 발주가 스스로 적는다** — 집행자에게 판정을 떠넘기지 않는다(미루면 실행 시점의 되돌리기가 더 비싸다 · `cycle-discipline.md §31` 정합).
- ★**K-143 — 게이트 항마다 「이 수를 움직일 수 있는 다른 계약」 1열 · 빈칸 금지.** 없으면 **「없음」이라 적는다**(빈칸은 「안 봤다」와 구별 불가). ★**「중복 제거」 계약과 「출현 수」 게이트는 구조적으로 반대 방향**이다 — 한쪽을 지키면 다른 쪽이 깨진다. 이런 쌍은 **계수 대신 소스 명제 test 로 세우면 충돌이 사라진다**(「몇 번 나오나」 → 「무엇이 참인가」).
- ★**K-131 — 게이트는 계약 축으로 쓴다.** ★**「파일 무접촉 ≠ 계약 무접촉」** — 「열거 file 포함 0」류 게이트는 **파일을 얼릴 뿐 계약을 지키지 않는다**(다른 file 에서 같은 계약이 깨져도 통과한다). 게이트가 재는 대상은 **file 목록이 아니라 계약 명제**여야 한다.

**★게이트 작성 규약 2** (= ⑥ 세부 말미 · 발행 **전** · 위 3 자와 같은 층):

- ★**K-152-ⓐ 게이트는 자기 시점을 말한다.** 게이트 항마다 **「언제 재는가」**(`commit ① 직후` / `cycle 마감` / `무관`)를 명기한다. **시점을 안 적은 게이트는 집행 도중 반드시 한 번은 틀린다.** 실측 = 어느 판의 편차 2 가 **둘 다** 이 축이었다 (REPORT 를 commit 하는 순간 「대상 외 0」이 깨짐 · untracked 계수가 REPORT 저작 중 9→10→9).
- ★**K-152-ⓑ `ahead` 는 고정값으로 쓰지 않는다.** **상대식**(`진입값 + 본 판 commit 수`) 또는 `≥` 로 쓴다. 고정값은 **정정 commit 을 붙이는 순간 게이트가 스스로 FAIL** 하므로, 집행자가 **정정을 포기하거나 산출물을 불완전하게 남기도록 강제**한다.

**⑦ 세부**:

1. ★**K-150 — 게이트는 발행 전에 반드시 실행한다.** 발주서에서 게이트 블록을 **추출해 그대로 돌리고**, 나온 값을 「전」으로 적는다. **안 돌린 게이트는 계약이 아니라 희망이다.** 실측 = 어느 발주가 발행 직전 실행에서 **자기 게이트 결함 3 개**를 스스로 잡았다 (금지 명령 1 · cwd 오류 1 · 헤더 포함 여부 미명시 1).
2. ★**K-151 — 발주는 셋이 한 벌이다**: ⑴ 발주서 ⑵ **집행자가 그대로 붙일 수 있는 진입 프롬프트** ⑶ 발행 후 디스크 xverify (sha/행 · `path|line|anchor` round-trip · 게이트 추출 실행). **파일 경로만 넘기는 것은 발주가 아니라 자료 제출**이다. 저작 체크리스트에 **「진입 프롬프트 절 존재」**를 넣는다.
3. ★**K-155 — 발주는 「무엇을 하라」와 함께 「무엇을 위한 것인지」를 넘기고, 집행자에게 되짚게 한다.** ★★**「읽었나」는 검증 불가하고 「되짚었나」는 검증 가능하다** — 그래서 「배경을 읽어라」로 끝내지 않는다.
   - **저작 측** = ⑹ **배경·목적** 칸(위 ⑥ 세부 **6**). **집행 측** = **자기 말 1 문단 재진술** — ⑴ 이 판의 **목적** ⑵ **ⓑ 좌표 지목**(★그 좌표를 **실제로 열어** 확인한다) ⑶ **이 판이 아닌 것** 1 줄. 착지처 = 집행자의 **REPORT §0** 또는 pre-EVIDENCE.
   - ★**verbatim 복붙 금지** — 원문을 그대로 옮기면 **안 읽은 것과 구별되지 않는다**. 자기 말이 없으면 **미이행**.
   - ★**접수 측 자 2** (= **계수형이 아니라 대조형**): ⑴ 재진술이 지목한 **좌표 round-trip**(실재하는가 + 그 절이 **실제로 그 목적을 말하는가**) ⑵ ★**재진술에 원본에 없는 목적이 들어왔는가 = 할루시 검출점**. ★**게이트 계수로 세우지 않는다** — 세는 것이 아니라 **대조하는 것**이라 접수 xverify 의 **명제**로 선다(= 위 K-131 「게이트는 계약 축」 정합 · 계수로 세우면 「문단이 있다」만 재고 **무엇이 참인가**는 못 잰다).
4. ★**게이트 분모는 자동 도출한다.** 진입 시점 집합을 **손으로 옮기지 말고** `git show <진입sha>:<path>` 로 뽑는다 — **ID 전사 오류가 구조적으로 0** 이 된다. 손으로 옮긴 분모는 **그 자체가 K-136(전사) 사고 지점**이며, 분모가 틀리면 **게이트가 옳게 집행한 판을 FAIL 시킨다**(= K-154-⑵ 와 같은 병 · 게이트 결함이지 집행 결함이 아니다).
5. ★**K-147 — 착지처는 그 file 자신의 배치 규약을 읽고 정한다.** 「어느 문서에」는 **상위 목록(설계 문서 · 회부 표)이 정하지 않는다.** 대상 file 을 열어 **thin pointer 인가 / 본문 SoT 인가 / 보호 영역인가**를 확인하고 정한다. 실측 = 어느 발주가 **「본 file 본문 복제 0」을 자기 문면에 명시한 thin pointer** 를 본문 착지처로 잡고 있었다 (발행 직전 anchor 정독에서 자가 검출).

## §5 gotcha (= 반복 발현한 것만)

- **★"내 diff 는 깨끗하다" 는 diff 에 참이고 커밋에 거짓일 수 있다** (D-6 · 2026-07-26): paste-back 회수 시 **`git show --name-only <sha>`** vs paste `§2` scope 를 **집합 대조**한다(개수 일치로 불충분). 같은 repo 에서 다른 workstream 이 동시에 돌면 `git index` 를 공유하므로(repo 당 1개 · `add`→`commit` 비원자적) **남의 file 이 내 커밋에 실린다**. 실측: file 겹침 **0** 인 3 cycle 동시 진행에서 **커밋 오염 9건** — diff 기준 자기 점검은 **전부 통과했다**(대조 대상이 틀렸던 것).
  - scope 밖 file 발견 = **즉시 보고 · 자동 되돌리기 금지** (되돌림은 절대 sha · `cross-repo-parallel-exec-detail.md §2.1.6` D-5).
  - **디렉터리 단위 대조 금지 · file 단위 명시** — 오염 file 이 본 cycle scope 디렉터리 **안**에 있을 수 있다 (실측: 오염 9 중 1건).
- **★aggregate 해시는 정체성이 아니라 drift 검출기** (A-5′): 수치 인용은 **산출 명령 + 환경**(shell · `LC_COLLATE` · 해시 도구 · glob 대상 `n`)을 함께 적는다 (형식 = `reporting.md §8.1`). 재현 대상은 특정 hex 가 아니라 **"한 실행 안에서 N-repo 동일"** 이라는 **불변식**이다. 재현 실패 보고를 받으면 **먼저 환경 차이를 의심**한다(내용 drift 단정 금지 · 실측 3회 반복 전부 환경 차이).
- **표면 속성으로 분류하지 않는다** (A7 · `code-principles.md §2`): 도구가 없다고 경로가 없는 게 아니다.

## §6 STOP

**canonical 9 항 = `.claude/rules/stop-canonical.md`** (= 자동 주입 · 여기서 재복제하지 않는다). 본 skill **고유** trigger 만:

| trigger | mitigation |
|---|---|
| paste source 측 명시 영역이 **전부** disk 부재 | 즉시 STOP + 본심 회수 (= scope 본질 자체가 성립 X · cycle 재정의) |
| 본 paradigm 위반 **3 회 누적** | mitigation cycle 진입 (= enforce hook 신설 검토) |

그 외(보호 sha drift · HIGH RISK 도메인 · 본심 분기)는 canonical #5 / #1·#7 / #9 로 이미 덮인다 — 구 판은 이 3 을 skill 안에 재복제해 뒀다.

## §7 적용 X (= 화이트리스트)

도메인 source (`app/` · `composeApp/` · `core/` · `src/`) · 디자인 SoT (`docs/design/` · `pencil-uiux-workflow.md` 소관) · 빌드/CI/tooling. 본 paradigm 본질 = **후보 / 권장 / paste source / scope 결정** 영역.

## §8 references (= 판정에 매번 필요하지 않은 층)

- [`references/examples.md`](references/examples.md) — 예시 case 3 (완전 stale / 부분 구현 / authoring 위반) + 자기 정합 사례
- [`references/adjacent-and-history.md`](references/adjacent-and-history.md) — 인접 paradigm 정합 표 + 양 skill cycle 이력 verbatim + 후속 cycle 후보

## §9 본 skill 의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](../../rules/rule-footer-common.md) (= 4-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지).
