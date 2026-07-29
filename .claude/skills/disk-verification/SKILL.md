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

## §4 의무 ①~⑤

| # | 의무 | 위반 시 |
|---|---|---|
| ① | 후보 발행 시 **disk 측 이미 구현 여부** 측정 | 표면 추측 = 위반 |
| ② | Recommended option 발행 **직전 재측정** (= 직전 cycle 측정값 재사용 금지 · baseline drift) | stale 발견 = 발행 차단 + 재측정 |
| ③ | **부분 구현** 발견 시 **scope 재정의** (= 신 본질만 명시 · 표면 stale 후보 명시 X) | cli 자율 또는 본심 회수 |
| ④ | **완전 stale** 발견 시 **후보 제거 또는 대체** | 본심 회수 또는 cli 자율 스킵 |
| ⑤ | **paste source authoring 자기 정합** — 발행하는 paste 자체가 본 paradigm 사례여야 한다 (= `§0` baseline · `§3` 인용 entry 실재 측정 · 가정 X) | paste-back 본문에 위반 명시 |

**⑤ 세부** (= cowork authoring 3 의무):

1. `§1`+`§1.3` **측정 결과 인용** — scope file × N 의 `grep`/`find`/`git ls-files`/`Read` 실측 결과 본문 인용 (가정 X)
2. `§3` contract SoT **byte-identical quote** — precedent rule + 인용 entry × N · `line N~M` 형식 · 본문 변형 X
3. `§2` scope **file path 전량 disk 측정** — 부재 발견 시 scope 재정의 의무 (= ③/④ 정합)

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
