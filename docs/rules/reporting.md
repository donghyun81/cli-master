# Reporting — Unified SoT (산출물 경로 + 형식 + 근거 기준 + Subagent Return Contract)

> **단일 목적**: 산출물 경로 규약 + stdout 출력 순서 + Task 문서 (`.ai/tasks/<taskId>.md`) 형식 + EVIDENCE.md / PLAN.md (10-section 정규 스키마) / VERIFY.md / REVIEW.md (12-section 정규 스키마) / 근거 기록 기준 / Subagent Return Contract / 제외 경로 통합 SoT.
> **신설**: MASTER-CLI-CLEANUP-7CYCLE-001 (2026-05-21) · 직전 2 file (`report-paths.md` + `report-formats.md`) 본문 통합 default.
> **연관 파일**:
> - `cycle-discipline.md` §11 — 보고서 lightweight 옵션 (4 파일 vs 7 파일)
> - `verification-and-review.md` — /verify 와 /review 세부 규칙
> - `legacy-cleanup-governance.md` — Cleanup Assessment 섹션 의무
> - `workflow-core.md` — 단계 흐름 (intake / collect / plan / implement / verify / review)
> SOT: `CLAUDE.md`

---

## §1 산출물 경로 규약

모든 산출물의 형식, 경로, 기록 기준을 정의한다.

> **연관 영역 — working file lifecycle**: 본 §1 산출물 외 cycle 진행 시 working file (= `cycle-prompt-*.md` + `cc-paste-*.md` + `*-addendum-*.md` + `.bak` + `.ai/prompts/*.md` 등) 측 lifecycle + archive paradigm 단일 SoT = [`working-file-lifecycle.md`](./working-file-lifecycle.md) (= frontmatter 3 키 + 5 위치 archive + INDEX.md 5-column 형식 + REVIEW.md·REPORT.md PASS 또는 mtime **7일** fallback trigger · ★일수 SoT = `scripts/working-file-archiver.sh` `MTIME_THRESHOLD_DAYS` 상수 정본 · 본 문면 = 인용).

| 파일 | 경로 | 특성 |
|---|---|---|
| Task 문서 | `.ai/tasks/<taskId>.md` | 불변 (원문 요구사항 + 메타) |
| Task 인덱스 | `.ai/tasks/INDEX.md` | 항상 최신 유지 |
| MODE | `.ai/reports/<taskId>/MODE.md` | 첫 단계에서 생성 |
| EVIDENCE | `.ai/reports/<taskId>/EVIDENCE.md` | 수집 근거 전체 |
| PLAN | `.ai/reports/<taskId>/PLAN.md` | ChangeBudget + 작업 계획 |
| VERIFY | `.ai/reports/<taskId>/VERIFY.md` | 검증 명령 + 결과 |
| REVIEW | `.ai/reports/<taskId>/REVIEW.md` | 최종 판정 |
| REPORT | `.ai/reports/<taskId>/REPORT.md` | cc-paste cycle 의 집행 보고 (실물 = 현행 주력 산출물) |
| COMPOUND | `.ai/reports/<taskId>/COMPOUND.md` | 종합 검증 결과 (구 compound-lint = deprecated) |
| TODO | `.ai/reports/<taskId>/TODO.md` | 후속 작업 목록 |

### §1.1 release 꼬리 (= release cycle 한정 · 2026-08-23 `MASTER-AIDOC-RELEASE-REALIGN-001` 신설)

> **소급 의무 아님**: 본 규약은 신설 이후 release cycle 에 적용된다. 기존 REPORT 는 대상이 아니며 소급 위반으로 판정하지 않는다 (= 위 REPORT 행도 **현행 실물의 기술**이지 신 생성 의무가 아니다).

```
★release cycle 한정 · REPORT 말미 5줄 (그 외 cycle = N/A 1줄로 갈음)
① 대상 변형 = <flavor>/<buildType> 실명
② minify 통과 = exit <code> · 소요 <시간> · 자 = <명령>
③ 출시 대상 화면 DESIGN-DEBT OPEN row = <n> (자 = <명령>)
④ 롤백 지점 = <commit 또는 tag> · 복구 경로 = <1줄>
⑤ prod DDL / Money path 접촉 = 유/무 (유 = STOP #1 경유 여부)
```

②의 기준 실측 (= `SELFWARD-RELEASE-GATE-001` §2 · 2026-08-23): `./gradlew :composeApp:assembleProductionRelease --no-daemon` = **exit 0 · 75s wall**(warm = 41 executed / 354 up-to-date · R8 태스크 executed 확인). ★`bundleProductionRelease` 변형 = **미측정**(그래프만 `--dry-run` 확인) · cold 캐시 소요 = **미측정**. 수를 채울 수 없으면 `<미측정>` 으로 둔다 — 추정값 기재 금지.

③은 전체 OPEN 수가 아니라 **출시 대상 화면에 걸린 OPEN row** 를 센다. render-artifact 류(preview PNG 재렌더 등 = SoT 아님)와 구조 부채를 분리 계수한다. 판정 기준 = 활성 자식 `DESIGN-DEBT.md` 머리 규정(= 「출시 대상 화면의 OPEN row = release 게이트 hard FAIL」). 「출시 대상 화면」 명단 확정 = Coin 몫.

---

## §2 stdout 출력 순서

항상 다음 순서를 따른다:

```
[EVIDENCE] 수집 근거 요약
[DIFF]     변경 내역 (파일:라인)
[LOG]      검증 명령과 exit code
```

---

## §3 Task 문서 (`.ai/tasks/<taskId>.md`) 형식

```markdown
## Meta
| 항목 | 값 |
|---|---|
| TaskId | <PREFIX>-<DOMAIN>-NNN |
| Created (KST) | YYYY-MM-DD HH:MM |
| Status | COLLECT / PLAN / IMPLEMENT / VERIFY / REVIEW / DONE / STOP / BLOCKED |
| Risk | Low / Medium / High |
| DBMig | Yes / No |
| MoneyAuth | Yes / No |

## 배경 (= 왜 이 태스크가 있나 · ★「무엇을」 앞에 온다)
- ⓐ 없으면 무엇이 깨지나: [현상 — **실측으로**. 추정이면 「추정」이라 적는다]
- ⓑ 무엇을 위해 하나: [상위 목표의 **좌표** — `문서 §절` / 원장 `#NN` / KR 태그]
- ⓒ 이 태스크가 **아닌** 것: [1~3 줄]

## 원문 요구사항
[사용자 원문 그대로]

## 분해된 문제 진술
[requirements-analyst 결과]

## 성공 조건
[measurable success criteria]

## Measurable Exit Criteria
_자연어 성공 조건과 1:1 대응. 실행 가능한 검증 명령이나 grep 패턴으로 기술._
- [ ] `<검증 명령 또는 grep 패턴>` — <기대 결과>

## 비기능 요구사항
[non-functional requirements]

## 불확실성 (UNKNOWN)
[근거 없는 항목 + 확인 위치]
```

> **★`## 배경` 이 맨 앞인 이유** (= 2026-08-29 `MASTER-TASK-PURPOSE-CONTRACT-001` 신설): 집행자가 받는 것이 「무엇을 하라」뿐이면 **「무엇을 위한 것인지」는 문서 밖에 흩어져** 있고, 집행자는 **비는 곳을 추론으로 메운다** — 그것이 할루시다. 배경이 뒤에 오면 읽는 사람은 이미 「무엇을」로 판을 짠 뒤라 배경을 **확인용으로만** 쓴다.
>
> - **ⓑ 는 문장이 아니라 좌표다** — 문장은 재진술할 때 **복붙**되고, 좌표는 **round-trip 으로 검증된다**(실재하는가 + 그 절이 **실제로 그 목적을 말하는가**).
> - **ⓒ 가 있는 이유** — **범위 오해가 할루시의 주 경로**다. 「아닌 것」이 없으면 집행자가 인접 영역까지 자기 판으로 읽는다.
> - **빈 칸 = Task 문서 미완** (= [`code-principles.md §0`](./code-principles.md) 원칙 3 「각 발주의 요건 칸으로 명시」 정합 · 빈칸은 「안 봤다」와 구별 불가).
> - **재진술 의무와 한 벌** — 이 절은 읽히려고 있는 것이지 채워지려고 있는 게 아니다. 집행 측 대응 의무(= 자기 말 1 문단 재진술) = [`workflow-core.md`](./workflow-core.md) Intake 「배경 재진술」 · 발주 측 대응 칸 = [`disk-verification/SKILL.md`](../../.claude/skills/disk-verification/SKILL.md) §4 ⑥ 세부 **6**.
> - **「분해된 문제 진술」·「성공 조건」과의 경계** — 그 둘은 **무엇을**(분해 · 완료 판정)이고 배경은 **무엇을 위해**다. 실측(= 신설 시점 실물 Task 문서 5 본 전수) = **ⓑ 0/5 · ⓒ 0/5** · ⓐ 는 1 본에서 **「분해된 문제 진술」 첫 항에 끼어 있었다**(= 자리가 없어 옆 절이 떠맡은 형태). ⟹ ⓐ 가 이미 분해 절에 있으면 **배경이 현상을 갖고 분해 절은 분해만 갖는다**(두 번 쓰지 않는다).

---

## §4 EVIDENCE.md 형식

```markdown
## Requirements Source
- 원문 요구사항 (또는 .ai/tasks/<taskId>.md 참조)
- Requirement chain 충족 여부
- Authority boundary

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | ... |
| Reading Mode | ... |
| Requirement Source | ... |
| Info Gap | RESOLVABLE_IN_REPO / UNKNOWN / BLOCKED |
| STOP Risk | ... |
| Read-Only Fan-Out | ... |
| Implementer Entry | Allowed / Blocked / N/A |

## Pre-EVIDENCE Contract
- Read evidence: ...
- Remaining gaps: ...
- Chosen path: ...
- Hold / Stop reasons: ...
- Implement entry conditions: ...

## Collect Results
### 매칭 파일/패턴
- file:line — 내용 요약

### 0 Matches (부재 증거)
- 검색했으나 없는 항목 목록

## Key Findings
[수집 결과 요약]

## Cleanup Assessment
_code-level task에서 필수. 제품 코드 미변경 ops-layer task는 `N/A (ops-layer task)` 명시._
_이 섹션이 없으면 stop-gate가 차단한다. 조사형·문서형 task는 적용 안 함(선택)._

### 발견된 후보
| 위치 | 설명 | 판정 |
|---|---|---|
| file:line | 설명 | 제거 예정 / TODO(deferred) / task-level STOP |

### 점검 명령
`rg -n "심볼명" --include="*.kt" .` — N matches

### 판정 요약
- 즉시 제거: 0건
- deferred: 0건
- task-level STOP: 0건
```

---

## §5 PLAN.md 형식 (10-section 정규 스키마)

> **스키마 본문 = [`docs/templates/plan-10-section.template.md`](../../docs/templates/plan-10-section.template.md)** (= verbatim 이전 · MASTER-CLI-CONTEXT-DIET-2-001 T3). **Risk ≥ Medium 시만 템플릿 Read** — Low Risk = GATESv2 + ChangeBudget + VerificationPlan + 작업 목록 경량 (템플릿 Read 불요 · `workflow-core.md` §implement Risk 표 정합).
> 10-section = GATESv2 / ①ChangeBudget ②DependencyDecision ③ArchitectureImpact ④ModelBoundaryPlan ⑤ErrorPolicy ⑥UIStateFlowPlan ⑦TestabilitySeams ⑧VerificationPlan ⑨RollbackStrategy ⑩ExternalPrep·DeferredItems + Plan + Notes.
> **N/A 처리 (T3 개정)**: 해당 없는 섹션 = 개별 "N/A" 나열 대신 **말미 1줄 집계 허용** (예: `N/A: §3·§4·§5·§6·§7·§10`) — 섹션 판단 의무 자체는 불변 (= 스키마 약화 아님 · 표기만 압축).

---

## §6 VERIFY.md 형식

```markdown
## Verify Commands
| 명령 | Exit Code | 결과 |
|---|---|---|
| `<command>` | 0 | PASS |

## Verification Summary
[결과 요약]

## UNKNOWN (검증 불가 항목)
[사유 + 위치]

## LOG
```
[LOG] YYYY-MM-DD HH:MM KST
CMD: <실행 명령>
EXIT: 0
STDOUT: [핵심 출력]
```
```

> **명령 흔적 필수**: 백틱 래핑 명령(테이블) 또는 `CMD:` 패턴(LOG) 이 1개 이상 있어야 한다.
> UNKNOWN 사유만 있는 VERIFY.md 는 미통과 — reviewer 판정 FAIL (구 compound-lint 3b 검사 = deprecated · 도구 부재).

---

## §7 REVIEW.md 형식 (12-section 정규 스키마)

> **스키마 본문 = [`docs/templates/review-12-section.template.md`](../../docs/templates/review-12-section.template.md)** (= verbatim 이전 · T3). **Risk ≥ Medium 시만 템플릿 Read** — Low Risk = §1 Requirements + §2 Regression + §11 Secrets 3-section (+ UI 레이어 변경 시 §5 Model Separation + §14 Design SoT Sync 추가 · `verification-and-review.md` 정합).
> 섹션 = ①Requirements ②Regression ③SOLID ④Layer Boundaries ⑤Model Separation ⑥Dependency ⑦TDD·Testability ⑧Error·Result ⑨External Prep ⑩DocSync ⑪Secrets ⑫Rollback ⑬Cleanup ⑭Design SoT Sync + Findings + Verdict + Remaining Risks + **PromptFit (불변 의무)**.
> **N/A 처리 (T3 개정)**: N/A 섹션 = 말미 1줄 집계 허용 (판단 의무 불변 · 표기 압축). 판정 기준/블로커 SoT = `verification-and-review.md` (형식 vs 기준 분리 불변).

---

## §8 근거 기록 기준

| 신뢰도 | 표기 | 조건 |
|---|---|---|
| CONFIRMED | `[CONFIRMED]` | 파일:라인 등 직접 증거 있음 |
| INFERRED | `[INFERRED]` | 간접 근거로 추론 (근거 명시) |
| UNKNOWN | `[UNKNOWN]` | 레포 내 근거 없음 (확인 위치 명시) |
| RESOLVABLE_IN_REPO | `[RESOLVABLE_IN_REPO]` | 아직 안 읽었거나 검색 범위를 좁히면 repo 안에서 확인 가능 |
| BLOCKED | `[BLOCKED]` | 권한/환경/누락 도구/승인 부족 때문에 진행 불가 |

> **측정/self-test 기록 형식 (T3 · MASTER-CLI-CONTEXT-DIET-2-001)**: raw output verbatim 박제 회피 — **판정 + 핵심 수치/sha 12자리 + 원문 파일 pointer** 로 기록한다 (예: `PASS · sha 3aa71c62d9e4 · 원문 = .ai/reports/<id>/logs/verify-sync.txt`). 긴 로그 = 파일로 남기고 pointer 만 (= `cycle-discipline.md` §13 self-test 기록 정합 · §9.1 path pointer 원칙 동형).

### §8.1 수치 인용 = 산출 명령 + **환경** 동반 의무 (= 2026-07-26 · MASTER-CLI-RULES-SETTLE-001)

- **수치를 인용하면 그 수치를 만든 명령을 함께 적는다.** 명령 없는 수치는 **재현 불가 = 근거 아님**(= §8 `[CONFIRMED]` 요건 미달 · `[INFERRED]` 이하로 강등).
- **★산출 명령만으로는 부족하다 — 환경을 함께 진다.** 같은 명령이 다른 값을 내는 축:
  **① shell**(zsh ↔ bash · glob 확장/정렬 상이) · **② locale**(`LC_COLLATE` · `*` 정렬 순서 → concat 순서 → 해시) · **③ 해시 도구**(`shasum -a 256` / `git hash-object` / `md5` · git-sha1 은 **blob header 포함** = 순수 내용 해시와 **영구 불일치**) · **④ glob 대상 범위**(`*.md` 가 무엇을 포함하는지 · file 수 `n` 동반 의무).
- **★aggregate 해시는 정체성이 아니라 drift 검출기다.** 재현해야 할 대상은 **특정 hex 가 아니라**
  **"한 실행 안에서 N-repo 값이 동일하다"** 는 **불변식**이다.
  - ⟹ **값이 안 맞으면 먼저 환경 차이를 의심한다** (내용 drift 로 단정하지 않는다 = `code-principles.md` §2 표면 속성 분류 금지 정합).
  - ⟹ **어떤 산식을 쓰든 한 명령 · 한 환경으로 N repo 를 재고 같으면 통과.** 산식을 바꿀 거면 **바꾼 사실과 새 산식을 박제**한다(조용한 교체 금지).
- **기록 형식 (권장)**: `<값> · 산식=<명령> · 환경=<shell + LC_COLLATE + 해시도구> · n=<대상 file 수>`
  예: `b368fcdbffcdb0e5 · 산식=cat docs/rules/*.md | shasum -a 256 · 환경=bash 3.2.57 · LC_COLLATE=C.UTF-8 · n=44`
- 실측 근거 (= **3회 반복**): 동일 4-repo aggregate 가 보고 주체마다 다른 hex 로 나왔고, 매번 **내용 drift 가 아니라 환경 차이**였다. 직전 cycle 에서 6 변형 전부 불일치 보고 → **값이 틀린 게 아니라 환경이 달랐다.**
- ★**적용 범위 — 이 규율의 대상은 REPORT 만이 아니다** (= 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-004` · ㉡ #220 · **범위 확장이지 신설 아님** = 위 첫 bullet 이 이미 규율 본체다). **발주서(paste) · paste-back · 원장 · 브리핑 전 채널**에 같이 적용된다. ★**문면을 인용해 지시하면 stale 을 한 칸 밀어 재생산한다** — 인용은 값을 옮기지만 **자를 옮기지 않는다**. 위반 실증 2 (= 둘 다 **발주서 채널** · 저작 = cowork):
  - ⑴ `MASTER-DOC-MANIFEST-SWEEP-003` 발주 §1-T1 이 §15 cold 재배치 **회차**를 「**10 → 11**」로 지시했다. 그 「10」은 **문면 인용**(재측 0)이고 진입 실측은 **18**이었다 — cli 가 불이행하고 **18** 로 착지시킨 것이 옳다. ★**그 18 도 틀렸다**(본 판 실측 = **26**) — 인용의 대가는 한 번으로 끝나지 않는다.
  - ⑵ 같은 발주 §6 머리에 「`|` **0** = **발행 후 자로 확인함**」이라 적혀 있었고 실측은 **1** 이었다. ★**값이 틀린 것보다 나쁘다 — 검증했다는 사실 자체가 거짓**이었다.
- ★**「확인했다 · 검증했다 · 재현했다」는 문장은 그 검증의 명령과 출력이 같은 절에 없으면 쓰지 않는다.** (= 위 ⑵ 의 직접 처방 · 주장은 자를 대체하지 않는다).
  - **집행 경계**: **발주서 · paste-back · REPORT** = 게이트로 재는 면(= 자 실행 가능). **원장 · 브리핑** = 같은 규율을 지되 **자기 점검**(= cowork 자기 규율 영역 · master 규약이 집행하지 않는다 = `anchor-list.md` A10 책임 경계 정합).

### §8.2 ★REPORT 는 자기 commit sha 를 담지 않는다 (= 2026-08-15 · MASTER-BRAND-TOWARD-INFRA-001)

REPORT 가 자기 자신을 담은 commit 의 sha 를 인용하면, 그 값은 **commit 이 존재한 뒤에만 알 수 있다** — 즉 **backfill(사후 재편집 + 재commit)을 구조적으로 강제**한다. 종단 산출물은 **자기 sha 없이 완결되는 서식**으로 저작한다 (인용 대상 = **선행** commit sha · 자기 commit 은 `[R]` 링크 + cycle-id 로 지시). 근거 = `PDOCS-BRAND-TOWARD-001` 사고.

---

## §9 Subagent Return Contract

상위 agent (intake-router / change-planner / verifier / reviewer) 가 하위 subagent 를 호출해
그 결과를 자신의 컨텍스트로 다시 흡수할 때는 아래 계약을 따른다. 하위 agent 가 긴 raw output
을 그대로 돌려주면 상위 agent 의 context window 가 금방 고갈되고, 장기 실행 task 일수록 이
비용이 누적된다.

### §9.1 크기 상한

- 단일 subagent return 은 **≤ 4,000 token 요약** 을 목표로 한다 (Claude Code subagent output window 실측 기준 — 2k는 정보 손실, 8k는 상위 agent context 압박).
- 4k 를 초과할 것으로 예상되면 subagent 는 **full detail 을 파일(path pointer)** 로 남기고
  return 에는 path 와 핵심 hook 만 포함한다.
- 긴 코드/로그 인용은 path pointer 가 기본이다 (`file:line-range` 또는
  `.ai/reports/<taskId>/<name>.md`). 원문 복붙은 금지.

### §9.2 필수 return 섹션

subagent 가 상위 agent 에게 돌려주는 최소 요약은 아래 5 개 섹션을 포함한다:

1. **Verdict** — PASS / FAIL / PARTIAL / UNKNOWN / N/A 중 하나.
2. **Top Findings** — 최대 5 개 bullet. 각 bullet 은 1 문장 + file:line 또는 path pointer.
3. **Counter-example 시도** — "이 결론이 깨질 수 있는 조건은 무엇인가" 를 1 줄로 서술.
   PASS 선언 시 특히 필수.
4. **Recommended Next Step** — 상위 agent 가 즉시 수행할 수 있는 구체 지시 1 개.
   "검토 필요" 수준은 금지. 예: "change-planner 재호출" / "VERIFY 명령 추가 실행" /
   "해당 없음 (DONE)".
5. **Pointers** — 더 읽을 파일 경로 목록. 상위 agent 가 필요할 때만 open 하도록 lazy loading
   을 유도한다.
6. **Trace Pointer** (선택) — `.ai/traces/<taskId>.jsonl` 경로. 상위 agent 가 도구 호출 이력을 확인할 때 사용.

### §9.3 escape 경로 (하한 미달 / 상한 초과)

- **정보 부족**: 판정에 필요한 근거가 없으면 `Verdict: UNKNOWN` + `Recommended Next Step`
   에 "보강 필요: <무엇>" 기록. 추측으로 PASS/FAIL 을 쓰지 않는다.
- **4k 초과**: subagent 가 자체적으로 detail 을 `.ai/reports/<taskId>/<sub>.md` 에 분리
   저장하고 return 은 4k 이하 요약 + 해당 파일 pointer. 상위 agent 는 필요할 때만 그 파일을
   연다.
- **Generator 가 Evaluator 를 겸하지 않기**: implementer 가 return 으로 "문제 없음" 을
   선언해도 상위 agent 는 별도 Evaluator (verifier/reviewer) 의 독립 return 을 받을 때까지
   PASS 로 간주하지 않는다.

### §9.4 상위 agent 흡수 규칙

- return 의 **Verdict 와 Top Findings 만** 상위 context 에 즉시 올린다.
- Pointers 는 필요할 때만 열어 context 에 올린다 (just-in-time).
- counter-example 섹션이 비어 있으면 Evaluator return 으로 간주하지 않는다.
- 4k 요약을 신뢰할 수 없다고 판단되면 동일 subagent 를 재호출하지 말고 다른 관점의
  Evaluator 를 호출한다 (self-cite 루프 방지).

관련: `docs/rules/routing-and-delegation.md` "Planner / Generator / Evaluator 경계",
`.claude/agents/active/reviewer.md` "Skeptic Evaluator Tuning".

---

## §10 제외 경로 (collect 시)

다음 경로는 collect에서 제외한다:
- `build/`, `**/build/`
- `.gradle/`, `**/.gradle/`
- `generated/`, `**/generated/`
- `.git/`
- `app/build/`
- `captures/`

---

## §11 본 SoT 의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md) (= 4-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).

---

## §12 명시 cycle 이력

- (직전) C2-RULES-RESTRUCTURE-001 (2026-05-02) · `evidence-and-reporting.md` (438 line) → `report-paths.md` (line 1~70) + `report-formats.md` (line 71~end) 분리 신설
- 2026-05-21 · MASTER-CLI-CLEANUP-7CYCLE-001 · 본 file 신설 (= `report-paths.md` + `report-formats.md` 2 file 본문 통합 default · 본질 변경 X · 단일 SoT 정합 default) + 2 file 삭제 + 9 file 인용 갱신 + 5-repo byte-identical propagation
- 2026-05-22 · MASTER-CLI-CYCLE-2A-ANCHOR-LIST-HOT-INSTALL-001 · §13 Negative Space Line append default (= anchor list paradigm 정합 default)
- 2026-06-18 · MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001 · **§7 REVIEW 스키마 `### 14. Design SoT Sync` 절 신설** (= UI visible-state(FULL) 변경 포함 task 한정 · 변경 화면 `.pen` + `.ui-spec.json` 선행/동반 refresh · 누락 시 `DESIGN-DEBT.md` deferred lane 등재 · 출시 후 net-new visual 선행 의무 = 3 항) + §7 Risk 기반 경량화 blockquote 정합. 자 = `git show --numstat 9e28613` → **7 추가 / 1 삭제 · 헤더 +1**. **소급 등재** (= 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-002`).
- 2026-07-10 · MASTER-CLI-CONTEXT-DIET-2-001 · **§5 PLAN 10-section + §7 REVIEW 12-section 스키마 본문 → template pointer 후퇴** (= 본문 verbatim 이전처 = `docs/templates/{plan-10-section,review-12-section}.template.md` · **Risk ≥ Medium 시만 템플릿 Read** · N/A = 말미 1줄 집계 허용[**판단 의무 불변** · 표기만 압축]) + §8 「측정/self-test 기록 형식」 신설 (= raw output verbatim 박제 회피 → 판정 + 핵심 수치/sha 12자리 + 원문 file pointer). 자 = `git show --numstat cf063a8` → **9 추가 / 208 삭제 · 헤더 −32** (= `## GATESv2` ~ `## PromptFit` 스키마 헤딩 전량 제거). **소급 등재** (= 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-002`). ★**본 건이 「절 신설·개정」 판정의 경계 사례다** — 헤더 **증가**가 0 이라 `^+#+ ` 만 보는 자에는 **안 걸린다**. 절을 **지운 것도 개정**이므로 등재 자는 **양방향**(`^[+-]#+ `)이어야 한다 (= `verification-and-review.md` §0.6 정합).
- 2026-07-26 · MASTER-CLI-RULES-SETTLE-001 · **§8.1 신설** (= A-5 + A-5′ · 수치 인용 = **산출 명령 + 환경** 동반 의무 · 환경 4축 = shell / `LC_COLLATE` / 해시 도구 / glob 대상 범위 `n` · **★aggregate 해시 = 정체성 아닌 drift 검출기** = 재현 대상은 특정 hex 가 아니라 **"한 실행 안에서 N-repo 동일"** 불변식 · 값 불일치 = **먼저 환경 차이 의심**(내용 drift 단정 금지 · `code-principles.md` §2 정합) · 산식 교체 시 **바꾼 사실 + 새 산식 박제** 의무 · 기록 형식 권장 1줄). 근거 = 동일 4-repo aggregate 가 보고 주체마다 다른 hex → **매번 내용 drift 아닌 환경 차이**(3회 반복 · 직전 cycle 6 변형 전부 불일치). §8 기존 표 + §1~§7 · §9~§14 **무접촉**. 4-repo byte-identical propagation.
- 2026-06-22 · MASTER-CLI-CROSSREPO-RECONCILE-AUTONOMY-PARADIGM-001 · §14 동족 구현 정합 surface 규약 append (= cross-repo cycle 한정 · 같은 맥락 2+ repo 구현 paste-back 회수 시점 3-bucket 정합 표 형식 + dispatch checklist `cross-repo-parallel-exec-detail.md §2.2.1` step 5 정합 · advisory · auto-converge 금지 · 본문 canonical = detail §4.4 · 본 §은 형식만 소유). 6-repo byte-identical propagation.
- 2026-08-15 · MASTER-BRAND-TOWARD-INFRA-001 · **§8.2 신설** (= 「REPORT 는 자기 commit sha 를 담지 않는다」 · 자기 sha 인용은 backfill 을 구조적으로 강제한다 · 종단 산출물 = 자기 sha 없이 완결되는 서식 · 인용 대상 = **선행** commit sha · 근거 = `PDOCS-BRAND-TOWARD-001` 사고) + cli infra 문서 브랜드 문면 Gently → Toward 동반. **소급 등재** (= 2026-08-29 `MASTER-DOC-MANIFEST-SWEEP-001` · 등재 누락분 · 자 = 절 헤더 자칭 cycle ID **6** ↔ 본 §12 대조).
- 2026-08-23 · MASTER-AIDOC-RELEASE-REALIGN-001 · **§1.1 신설** (= release 꼬리 · release cycle 한정 REPORT 말미 5줄[대상 변형 / minify exit+소요 / 출시 화면 DESIGN-DEBT OPEN row / 롤백 지점 / prod DDL·Money 접촉] · 그 외 cycle = N/A 1줄 갈음 · 소급 의무 아님) + §1 표 REPORT 행 「현행 주력 산출물」 등재. **소급 등재** (= 2026-08-29 `MASTER-DOC-MANIFEST-SWEEP-001` · 자 = 위와 동일).
- 2026-08-29 · MASTER-ENGINEERING-BASELINE-002 · **§15 신설** (= REPORT.md 형식 · §15.1 절 구성 12 축[실물 census 박제 · 발명 0] + §15.2 `§정정 append` 절 의무 · 근거 = §1 표가 REPORT 를 「현행 주력 산출물」로 규정하는데 **형식 절이 없었다** · 소급 의무 아님 = §1.1 선례 동형). **소급 등재** (= 2026-08-29 `MASTER-DOC-MANIFEST-SWEEP-001` · 자 = 위와 동일).
- 2026-08-29 · MASTER-TASK-PURPOSE-CONTRACT-001 · **§3 Task 문서 `## 배경` 절 신설** (= 「무엇을 위한 것인가」가 「무엇을」 **앞에** 온다 · ⓑ 는 문장 아닌 **좌표**[round-trip 검증 가능] · ⓒ 「아닌 것」 부재 = 범위 오해 = 할루시 주 경로 · 빈칸 = Task 문서 미완) + §15.2 대상 정정 (= 「자기 commit sha」 → 「**본체** commit sha」 · K-156 · 자기 sha 는 어렵기 전에 **불가능**). **소급 등재** (= 2026-08-29 `MASTER-DOC-MANIFEST-SWEEP-001` · ★발주 census **밖**이었다 — 자칭이 절 헤더가 아니라 **본문 blockquote** 라 헤더 자에 안 걸렸다 · 자 = `git log --follow --format='%h|%ad|%s' -- docs/rules/reporting.md` ↔ 본 §12 대조).
- 2026-08-29 · MASTER-DOC-MANIFEST-SWEEP-001 · 규약·원장 file 의 **자기 서술**을 실물에 맞추고 ★**값 옆에 자를 병기** (= 7 축: manifest advisory 2 · 본 §12 소급 등재 4 + 본 entry · COLD lineage 자칭 4 · `CLAUDE.md §15` 표 orphan 복구 · `CLAUDE.md §16-2` 보호 종수 · `rule-footer-common.md` 자칭 범위). 본 §12 등재 = 같은 판이 `rule-footer-common.md` 에 신설한 **「이력 절 등재 의무」의 첫 이행**. 4-repo propagation = 별 판(#130).
- 2026-08-30 · MASTER-MEASURE-DISCIPLINE-001 · **§15.1 축 12 → 13** (= 축 **13 「판단·선택 → 원장」** 신설[발주가 안 물었는데 집행자가 정한 것 = 원장 번호 또는 「원장 불요 + 근거」] + 축 **9 「회부」**에 낱말 구분 1구[「원장 회부」 ≠ 「Coin 이관」] + intro 「12 축」→「13 축」 정합). 규율 본문 SoT = [`cycle-discipline.md`](./cycle-discipline.md) **33)** (= 본 §은 **REPORT 서식만** 소유 · 재복제 0). 근거 = 어느 REPORT 의 판단 7 항 중 원장 참조 **1**(단위 = 항) — 나머지는 **REPORT 안에서만 살고 다음 판의 분모에서 빠졌다**. ★신설 행은 헤더와 **칸 수 동일**(= `verification-and-review.md` §0.3 행별 칸 수 자 자기 적용 · 게이트 실측 불일치 **0**). §15.2 · §1~§14 **무접촉**. ★위 `MASTER-ENGINEERING-BASELINE-002` entry 의 「12 축」 = **당시 사실**이므로 무접촉(이력은 append-only · 소급 정정 아님).
- 2026-08-30 · MASTER-DOC-MANIFEST-SWEEP-004 · **§8.1 적용 범위 확장**(= **신설 아님** · 규율 본체는 2026-07-26 부터 있었고 없던 것은 **「어느 채널에」**다 — 대상 = 발주서 · paste-back · 원장 · 브리핑 **전 채널** + 「확인했다·검증했다」 문장의 **명령 동반 의무** + 집행 경계[게이트로 재는 면 = 발주서·paste-back·REPORT / 원장·브리핑 = 자기 점검 = `anchor-list.md` A10 책임 경계]) + **§15.1 축 13 → 14**(= 축 **14 「commit 계수 자기 대조」** 신설[목록 행 수 ↔ `rev-list --count` 를 **같은 절에서** 대조] + intro 「13 축」→「14 축」 정합). 근거(실측) = ⑴ 위반 2 건이 **둘 다 발주서 채널**에서 났다(회차 문면 인용 · 「발행 후 자로 확인함」이 거짓) ⑵ SWEEP-003 이 commit **4 본** 보고 ↔ 실측 **5 본**(누락 `1d4d533`)인데 `ahead +5` 는 맞게 적혀 있었다 = **두 수가 같은 절에 있었는데 대조가 없었다**. ★신설 행 = 헤더와 **칸 수 동일**(4 pipes · `verification-and-review.md` §0.3 행별 칸 수 자 자기 적용 · 선재 6-pipe 1 행[축 3 `\|`]은 본 판 소관 X). §8.2 · §15.2 · §1~§14 **무접촉**.

---

## §13 Negative Space Line (= 2026-05-22 신설 default · `MASTER-CLI-CYCLE-2A-ANCHOR-LIST-HOT-INSTALL-001`)

매 cycle 보고 끝 1 줄 "고려했으나 hot 제외 영역: <영역 default>" 의무 default. 본 line = anchor list 진화 signal default (= 사용자 본심 정합 default). 비어 있는 영역 = "(없음)" 명시 default. 발행 영역 = REVIEW.md 본문 끝 + paste-back 본문 끝 default. 본문 단일 SoT = [`anchor-list.md §4`](../../.claude/rules/anchor-list.md) (= 10 anchor hot default · P0 6 + P1 4 default).

---

## §14 동족 구현 정합 surface (= cross-repo cycle 한정 · 2026-06-22 신설 default · `MASTER-CLI-CROSSREPO-RECONCILE-AUTONOMY-PARADIGM-001`)

같은 맥락(= 동일 개념 / feature / contract)을 **2+ repo** 에 구현·변경한 cross-repo cycle 의 **paste-back 회수 시점** 보고에 동족 구현 정합 표 1 개를 surface 한다. 매 cycle 아님 (= 같은 맥락일 때만). 본문 doctrine 단일 canonical = [`cross-repo-parallel-exec-detail.md §4.4`](./cross-repo-parallel-exec-detail.md) (= trigger / 주체 / 행동 / 경계 본문 · 본 §은 **보고 형식만** 소유 · 본문 복제 X).

**trigger 시점**: dispatch checklist(= [`cross-repo-parallel-exec-detail.md §2.2.1`](./cross-repo-parallel-exec-detail.md)) step 5(= cowork-role 측 paste-back × N 회수 + session × session 직접 cross-verify) 시점에 정합.

**주체**: cowork chat (= N 개 paste-back + N repo disk 전체를 보는 유일 지점 · Inspection = 수렴 결정은 본심 · `automation-policy.md §5` 정합).

**형식 — 정합 표 1 개** (= 3-bucket):

| 화면 / 개념 | bucket | 근거 | pointer |
|---|---|---|---|
| `<같은-맥락 항목>` | 공통화 권장 / 분리 유지 / 보류·본심 | `<수렴 권장 1 안 또는 자율 보존 근거>` | `<repo>/<file>:line` × N |

- **advisory** — 표 surface 만 의무 · 수렴 *실행*은 후속 cycle(= 본심 또는 cli HOW)로 분리. **auto-rewrite / auto-converge 금지** (= `cross-repo-parallel-exec-detail.md §4.4` 경계 정합 · 도메인 자율 default 불변).
- **발행 영역**: paste-back 본문 inline default (= 불필요 산출물 박제 회피 · 별 file 박제는 cli 자율). 같은 맥락 2+ repo 구현 cycle 무 = 본 § N/A (= 표 생략).
- **A8 정합**: 같은 맥락 2+ repo 구현 후 미surface 건수 `= 0` 측정 (= `anchor-list.md` A8 GSM-M).

---

## §15 REPORT.md 형식 (= cc-paste cycle 집행 보고 · 2026-08-29 신설 · `MASTER-ENGINEERING-BASELINE-002`)

> **신설 근거(실측)**: §1 표가 REPORT 를 「**현행 주력 산출물**」로 규정하는데 **형식 절이 없었다** (= §3 Task · §4 EVIDENCE · §5 PLAN · §6 VERIFY · §7 REVIEW 는 있다). 그 공백에서 §15.2 의 사고가 났다.
> **소급 의무 아님** (= §1.1 선례 동형): 신설 이후 cycle 에 적용한다. 기존 REPORT 는 소급 위반으로 판정하지 않는다.

### §15.1 절 구성 (= 실물 census 로 뽑은 현 관례 박제 · 발명 0)

절 **번호·기호는 자유** (= 실물 2 본이 `## 0.~11.` 와 `## ①~⑦` 로 갈린다 · 통일 강제 X). **아래 14 축이 있는가**가 판정선이다. 해당 없는 축 = **「N/A + 근거」 1줄** (= 빈칸은 「안 봤다」와 구별 불가 · `cycle-discipline.md` §32-ⓑ 정합).

| # | 축 | 내용 |
|---|---|---|
| 1 | **판정** | PASS / FAIL / 부분 + 1줄 요약 |
| 2 | **BASELINE 진입 재측** | 발주 인용값이 아니라 **집행 시점 실측** (= 갈리면 실물이 정본) |
| 3 | **착지** | 대상별 좌표 `path` \| `line` \| `anchor` (= `verification-and-review.md` §0.2 K-136) |
| 4 | **게이트 전/후** | 항별 **전 → 후 + 시점 + 판정** · 자 = 발주 게이트 블록 verbatim |
| 5 | **편차 · 이의** | 방어 아님 — **자로 재현해서** 붙인다 |
| 6 | **「나를 의심하는 절차」 답** | 발주가 물은 항 **전량** |
| 7 | **ChangeBudget** | 행 단위 + 밴드 대조 (= `cycle-discipline.md` §30) |
| 8 | **STOP · 회귀 그물** | trigger 별 발동 여부 (0 도 값) |
| 9 | **회부** | 남기는 부채 + **원장 번호** (= K-132 · 0 이면 「0」 + 근거) · ★**「원장 회부」와 「Coin 이관」을 구분해 적는다** (= `cycle-discipline.md` 33)-ⓒ · 한 낱말이 두 축을 겸하면 둘 다 못 잰다) |
| 10 | **commit · ahead** | commit sha × N + `--name-only` + 최종 ahead |
| 11 | **자 대조표** | 「자의 이름 ↔ 자를 낸 명령」 (= `verification-and-review.md` §0.4 의무) |
| 12 | **negative space** | 「고려했으나 hot 제외 영역」 1줄 (= §13) |
| 13 | **판단·선택 → 원장** | 발주가 안 물었는데 **집행자가 정한 것** = **원장 번호** 또는 「원장 불요 + 근거」 (= `cycle-discipline.md` 33)-ⓑ · REPORT 안에서만 사는 판단 금지) |
| 14 | ★**commit 계수 자기 대조** | paste-back 의 **commit 목록 행 수** ↔ `git rev-list --count <진입>..HEAD` 를 **같은 절에서** 대조한다. 불일치 = **목록이 누락된 것**(= 실측 `MASTER-DOC-MANIFEST-SWEEP-003` 보고 **4 본** ↔ 실측 **5 본** · 누락 `1d4d533`). ★**두 수가 같은 절에 있었는데 대조가 없어서 안 잡혔다** — 나란히 두는 것과 대조하는 것은 다르다 |

### §15.2 ★`§정정 append` 절 의무 (K-152-ⓒ)

**REPORT 를 commit 한 뒤에야 확정되는 값**(= **본체 commit sha** · 마감 porcelain · 마감 스캔 결과 · 최종 ahead)은 **REPORT 말미의 `§정정 append` 절에 사후 기입**한다.

- ★**K-156 — 대상은 「본체 commit sha」이지 「자기 sha」가 아니다.** 본체 = **본 REPORT 가 기록하는 대상 file 을 담은 commit**이고, **`§정정 append` 자신을 담은 commit** 이 아니다. 후자는 어렵기 전에 **불가능**하다 — git 의 sha 는 **자기 내용의 해시**라 어떤 commit 도 자기 sha 를 담을 수 없고, 담으려 commit 을 하나 더 붙이면 **그 sha 가 또 미기록**된다(무한 후퇴). **실측** = 이 조항을 지키려 commit 4 본을 쓴 판에서, backfill commit 의 sha 는 tree 전수 **0 hit** 이고 본체 sha 는 **1 hit** 이었다 ⟹ **집행 실패가 아니라 조항 결함**이었다 (= 2026-08-29 `MASTER-TASK-PURPOSE-CONTRACT-001` 정정 · 구 문면은 「자기 commit sha」).
- ★**꼬리 commit 의 존재는 `최종 ahead` 가 드러낸다** — ahead 를 **상대식**(`진입 N + 본 판 M` · M 은 `§정정 append` commit **포함**)으로 적으면(= §15.1 4 축 · `disk-verification/SKILL.md` **K-152-ⓑ** 정합) REPORT 만 읽는 독자도 **나열된 sha 수보다 ahead 가 1 크다**는 데서 꼬리 commit 을 안다. 별도 플래그 절 **불요**(= 실측으로 이미 성립하던 관례를 명문화한 것).
- ★**판정선 = paste-back 이 유실돼도 REPORT 만으로 마감 좌표가 복원된다.**
- ★**§8.2 와의 경계** — §8.2 「REPORT 는 자기 commit sha 를 담지 않는다」의 대상은 **REPORT 본문**이다 (= 본문은 **자기 sha 없이 완결**되는 서식 · 인용 대상 = 선행 commit). `§정정 append` 는 그 **유일한 예외 표면**이며 **append-only 꼬리**로 격리한다 — 본문 재편집이 아니므로 §8.2 가 막으려던 「본문 backfill 강제」는 발생하지 않는다. **두 절의 잔여 긴장 정리 = 별 판** (= 문면 정정은 별 판 · `verification-and-review.md` §0.1 K-140).
- **실측 = 연속 2 회 실패.** 두 REPORT 모두 자기 마감 commit sha **0 hit** · 마감 스캔 결과 **0 hit** — 그 값들이 **채팅에만** 살았고, 원장 담당이 REPORT 만 읽고 기장했다가 **실제로 놓쳤다**.
