# Cross-Repo Parallel Execution — Detail (behavior-triggered 본문)

> **단일 목적**: L0 kernel [`cross-repo-parallel-exec.md`](../../.claude/rules/cross-repo-parallel-exec.md) 에서 demote 된 cross-repo 실행 paradigm **본문** — 영역 1/1.5/2/3 paradigm + dispatch checklist + 경계 + 자식별 cwd 분리 + sub-agent token cost + cross-repo 정합 처리. cross-repo **행동 진입 시** 로드 (= `rule-routing-index.md §B` Reading Mode 6 cli-ops cross-repo).
> **신설**: MASTER-CLI-CONTEXT-OPT-PHASE3-L0-CHILD-DEDUP-001 (2026-06-01 · H4 · kernel↔detail 분리 · 삭제 0 verbatim demote · 본문 = 직전 `cross-repo-parallel-exec.md` §2.1~§2.3 + §3~§4 verbatim).
> **kernel 잔류 (= L0 항상-on)**: subscription/billing guard(§2.4 · A6 · `claude -p` 회피) + 단방향 propagation(A4) + 영역 1/1.5/2/3 1-줄 요약.
> SOT: `CLAUDE.md`

---

### 2.1 영역 1 — 단일 cli session 측 sub-agent 병렬 호출 paradigm

단일 cli session 측 main agent context 단일 + Task tool 측 sub-agent 호출 paradigm. sub-agent context 분리 default · 자식별 cwd 영역 명시 default.

**진입 조건**:
- cli session 측 cwd = 부모 mount root (= `/Users/yundonghyeon/AndroidStudioProjects`) 또는 자식 repo 중 1
- main agent 측 cross-repo 영역 본질 측정 결과 = 영역 1 paradigm 정합 default
- 자식별 sub-agent fan-out 측 main agent context 부담 ≤ 적절 (= sub-agent 결과 통합 가능 영역)

**호출 paradigm**:
```
main agent (cli session 측 cwd = 부모 mount root)
  ↓
Task tool sub-agent fan-out (= 자식별 병렬 또는 순차)
  ↓
sub-agent A (cwd = ~/AndroidStudioProjects/GentlyBreath)
sub-agent B (cwd = ~/AndroidStudioProjects/GentlyDay)
sub-agent C (cwd = ~/AndroidStudioProjects/GentlyTable)
  ↓
main agent 측 결과 통합 + cross-repo 정합 결정
```

**적용 case 예**:
- "GB + GD + GT 측 동일 paradigm 신설 영역 cycle" (= 동족 자식 측 sha 정합 측정 + 동일 patch 적용)
- "4-repo 측 보호 file sha drift 검증" (= 자식별 sha 측정 + master 측 baseline 비교)
- "3 자식 측 동일 도메인 영역 측 source 측정" (= 동족 자식 측 source code 비교 + 정합 측정)
- "cli infra rule SoT 본문 cross-repo cross-verify" (= 4-repo byte-identical 영역 측 drift 발견)

**Subagent Return Contract 정합 의무** (= `reporting.md` §9 정합):
- 단일 sub-agent return ≤ 4,000 token 요약
- Verdict + Top Findings + Counter-example + Recommended Next Step + Pointers 5 섹션 의무
- raw output 그대로 return 금지 (= main agent context 압박 회피)

### 2.1.5 영역 1.5 — git worktree 격리 paradigm (= within-repo 병렬 · 본문 canonical)

> **신설**: `MASTER-CLI-WORKTREE-PARADIGM-001` (2026-06-11 · Coin 본심 D1~D8 확정). 본 §2.1.5 = 영역 1.5 **유일 본문 canonical** default (= kernel `cross-repo-parallel-exec.md` §2 = 1-bullet 요약 + pointer · 부모 mount root `CLAUDE.md` §3.3/§4 + `automation-policy.md` §2 #12 = pointer 행 · L1-4 단일 SoT 정합).

git worktree = 한 repo 측 추가 working tree 를 별 디렉터리 × 별 branch 로 동시 checkout 하는 git 표준 기능 default. 영역 1 (= sub-agent fan-out) + 영역 2 (= 다중 cli session) = **repo 사이** 병렬 영역 · 영역 1.5 = **같은 repo 안** 동시 workstream 격리 영역 default (= 직교 · 영역 2 대체 X).

**적용 범위** (= D1 · 2 영역 채택 + 1 보류):

| # | 적용 영역 | 본질 |
|---|---|---|
| ① | **within-repo 병렬** | 같은 repo 안 동시 2+ workstream (= 독립 cycle × N) 측 worktree × branch 격리 default (= 단일 working tree 측 동시 변경 충돌 차단) — ★**2026-07-26 D-2 승격: "가능" → 같은 repo 병렬 시 「의무」** (= file 겹침 0 이어도 `git index` 공유 = 격리 없이 진행 금지 · §2.1.6) |
| ② | **master propagation 격리** | propagation cycle 진행 중 별도 master cycle 측 worktree 격리 default (= main checkout = propagation 전용 보존) |
| ③ | 영역 1 sub-agent 격리 | **보류 default** (= 현 영역 1 = read-only 측정 용도 · worktree 격리 실수요 0 실측 · 재평가 = 실수요 발생 시점 별 cycle) |

**운영 계약** (= D6 결과 계약 · 방법 세부 = §FREEDOM 영역):

- **배치 위치**: worktree dir = repo working tree **외부 경로 의무** (= repo 내부 생성 금지 · propagation / .gitignore 오염 차단). 규약 = `~/AndroidStudioProjects/.worktrees/<repo>--<cycle-id>/` (= 부모 mount root 측 git-외 영역 · .gitignore 처리 불요 default).
- **branch 규약**: worktree branch = `wt/<cycle-id>` default · worktree 측 commit = 자기 branch 한정 의무 (= main 직접 commit 유출 금지).
- **보호 5 file**: 변경 = main checkout 한정 의무 (= worktree 내 보호 file 편집 금지 · A2 정합).
- **propagation 실행**: `propagate.sh` + `verify-sync.sh` 실행 = main checkout 한정 default (= worktree 측 실행 금지 · 단방향 propagation source = main 단일 · A4 정합).
- **영역 2 직교**: worktree 는 영역 2 (= cross-repo 다중 cli session) 를 **대체하지 않음** (= polyrepo = repo 사이 이미 디렉터리 분리 default · worktree 가치 = 같은 repo 안 한정).
- **Transport / Inspection 분리**: worktree 생성·제거·검출 = Transport (= 기계 · `automation-policy.md` §2 #12 정합) · 무엇을 격리할지 + merge 판단 = Inspection (= 사람 영역 default).

**명령 sequence 규약** (= §FREEDOM 확정):

```bash
# 생성 (= 신 branch 동시 생성)
git -C <repo> worktree add ~/AndroidStudioProjects/.worktrees/<repo>--<cycle-id> -b wt/<cycle-id>
# 검출 (= cycle 진입 / 마감 시점 측정)
git -C <repo> worktree list --porcelain
# self-clean (= D8 순서 의무: merge 완료 → worktree 제거 → branch 정리)
git -C <repo> merge --no-ff wt/<cycle-id>      # main checkout 측
git -C <repo> worktree remove ~/AndroidStudioProjects/.worktrees/<repo>--<cycle-id>
git -C <repo> branch -d wt/<cycle-id>
```

**merge 소유** (= D8):

- worktree branch 합류 (= merge) = **해당 workstream cycle 마감 step 포함 의무** (= merge + verify + self-clean 후 paste-back · 별도 통합 task 상시 분리 X).
- conflict 검출 시 = **자동 해소 금지** (= 보고 → 사람 판단 · STOP #4 해석 default). 대형 conflict = STOP 후 별도 cycle 분기 default.
- **병렬 분기 전제** (= 분기 결정 시점 의무): 파일 겹침 측정 = cowork paste 발행 단계 의무 (= Inspection · 사람 영역) — 같은 file 접촉 workstream = 병렬 금지 · 순차 의무.
  > ⚠ **★본 행의 판정 기준은 틀렸다 — §2.1.6 으로 정정** (2026-07-26 · `MASTER-CLI-RULES-SETTLE-001` · 구 문면 = 이력 보존 · 삭제 0). **file 겹침은 필요조건이지 충분조건이 아니다.** 공유 자원은 file 이 아니라 **`git index`** 이며, index 는 **repo 당 하나**다. 위 기준만 지킨 3 cycle 병렬(= file 겹침 **0**)이 **커밋 오염**을 냈다. 같은 repo 안 2+ workstream = **격리 의무**(§2.1.6).

**guard 3** (= D3+D7 · 신 STOP 항 신설 X = 기존 STOP 9항 해석 적용):

| # | guard | 본질 |
|---|---|---|
| ① | self-clean 의무 | cycle 마감 시 merge 완료 → worktree 제거 → branch 정리 순 의무 (= D8 정합 · orphan 잔존 차단) |
| ② | orphan / 미커밋 WIP | orphan worktree 검출 또는 worktree 내 미커밋 WIP 존재 + prune 징후 = 기존 STOP #3 (비가역) · #4 (예상 외 상태) 발동 default |
| ③ | prune 자동 실행 회피 | `git worktree prune` 자동 실행 금지 default (= 검출 → 보고 → 사람 판단) |

**subscription 경계** (= D4 · A6 정합):

- worktree = 단순 git checkout (= 추가 AI 호출 0) default — **interactive pool 정합 ✓ · 영역 3 (= Agent SDK credit pool) 무관**.
- worktree 격리 자체 = sub-agent 수 증가 영역 X — 기존 sub-agent 병렬 cap ≤ 3 (= §3.4) 불변 의무 (= 모순 금지).

### 2.1.6 ★병렬 판정 기준 **정정** — 공유 자원은 file 이 아니라 `git index` 다 (= 2026-07-26 · MASTER-CLI-RULES-SETTLE-001)

> **본 §2.1.6 = 위 "병렬 분기 전제"(`같은 file 접촉 workstream = 병렬 금지`) 의 판정 기준 정정 본문.** 구 문면 = 무삭제 보존(이력) · **현재형 판정 기준 = 본 §**. **추가가 아니라 정정**이다 — 조용히 덧붙이면 다음 사람이 **또 file 겹침만 본다.**

**사고 실측 (= 현행 규칙이 사고를 허용했다)**: 2026-07-26 Selfward 에서 **3 cycle 이 동시 진행**됐다 — `RULES-AS-TESTS`(= `composeApp/rules`) · `DOCS-ENTRY-REALIGN`(= `docs/CLAUDE.md`) · `OUTPUT-BUDGET`(= `supabase/functions`). **file 겹침 = 0**. **현행 규칙을 전부 지켰다.** 그런데 **커밋이 오염됐다**(= 남의 workstream 파일이 내 커밋에 9건 혼입).

| # | 정착 | 내용 |
|---|---|---|
| **D-1** | **판정 기준 정정** | **file 겹침 = 필요조건 · 충분조건 아님.** `git index` 는 **repo 당 하나**이고 `add`→`commit` 은 **원자적이 아니다** — file 이 안 겹쳐도 **index 는 겹친다.** ⟹ **같은 repo 안 2+ workstream = index 공유 = 격리 의무** (파일 목록 비교로 병렬 가부를 판정하지 않는다) |
| **D-2** | **worktree = 의무로 승격** | 영역 1.5 (= §2.1.5) 를 *"가능"* → **"같은 repo 병렬 시 의무"** 로 승격. 같은 repo 안 동시 2+ workstream 은 **worktree × branch 격리 없이 진행 금지** (= 본문 canonical = §2.1.5 · kernel `cross-repo-parallel-exec.md §2` 1-bullet 동기화) |
| **D-3** | **pathspec = 보조 · 반쪽** | `git commit -- <pathspec>` = index 우회 **보조** 수단(= 다른 workstream 의 staged 변경을 쓸어담지 않음). ★**단 HEAD 에 없는 신 file 에는 안 먹는다** — untracked 신 file 은 pathspec commit 이 **포착하지 못한다**(= 격리를 대체하지 못하는 **반쪽** · D-2 의 보완재일 뿐) |
| **D-4** | **디렉터리 pathspec 금지** | pathspec 은 **file 단위 명시만 유효** · **디렉터리 단위 금지**. 실측: 오염 9건 중 **1건이 본 cycle scope 디렉터리 안**에 있었다 — 디렉터리로 끊으면 **남의 파일이 내 scope 경계 안에 들어와 있어도 통과**한다 |
| **D-5** | **복구 절차 = 절대 sha** | 복구/되돌리기 절차는 **절대 sha 로 적는다.** `HEAD~N` 은 **문서가 쓰인 순간부터 부패한다** — 실측: 그 사이 커밋 하나가 올라와 `HEAD~1` 이 **남의 커밋**을 가리켰다 (= 상대 참조로 적은 복구 절차가 **2차 사고**를 만든다) |
| **D-6** | **커밋 file 집합 대조** | paste-back 회수 시점 = `git show --name-only <sha>` vs paste `§2` scope **대조 의무**. cli 의 *"내 diff 는 깨끗하다"* 는 **diff 에 대해 참이고 커밋에 대해 거짓**일 수 있다 (본문 = [`disk-verification` skill](../../.claude/skills/disk-verification/SKILL.md) §5 gotcha) |
| **D-7** | ★**자식 commit 직전 `-uno` 게이트** | **전파 cycle 이 자식 repo 에 commit 하기 직전**, 그 자식에서 `git --no-optional-locks status --porcelain -uno` 를 **다시 잰다**. 비어 있지 않으면 = **다른 workstream 이 live** ⟹ **STOP**(자식 commit 보류 · 파일만 남기고 보고). 근거 = 진입 시점 측정으로는 못 잡는다는 실측: `MASTER-CLI-RULES-TOKEN-SLOT-WRITER-001` 에서 Selfward `-uno` 가 **진입 0 → 착지 1 → 마감 4** 로 **cycle 도중에** 나타났다(= 그 사이 `SELFWARD-T1-4-AI-WAIT-COPY-001` 세션이 편집 중). 이번엔 삼키지 않았다(`014660e` = 정확히 3 file) — 다만 `add`↔`commit` 마진이 **sub-second** 였을 뿐이다. ★**본 D-7 은 새 기전이 아니라 D-2(worktree 의무)를 발화시키는 신호**다 — 게이트가 걸리면 정답은 「조심해서 commit」이 아니라 **worktree 격리 또는 자식 commit 지연**이다. ★`D-3` 의 pathspec 으로는 못 닫는다(= **HEAD 에 없는 신 file 에 안 먹는다** · 병렬 cycle 은 대개 신 file 을 만든다). |

**★worktree 는 이미 검증됐다 (= 대조 실측)**: 격리 **없음** = 오염 **1회**(위 3 cycle) · 격리 **있음** = 오염 **0회** — worktree 안에서 돌던 중 **다른 세션이 `toward-product-docs` 에 커밋**(16:34)했음에도 **오염 0 · 커밋 집합 정확히 24+1 · self-clean orphan 0**.

### 2.2 영역 2 — 다중 cli session 운영 paradigm (= 권장 paradigm default · 2026-05-19 본문 강화)

> **본 영역 = 사용자 본심 정합 권장 paradigm default** (= `MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001` 안 본문 강화 · 실 IMPL / 자식 cli infra 정합 영역 default · subscription pool 정합 default · §2.4 Subscription-aware paradigm 정합).

terminal × cli 측 독립 session × 독립 context paradigm. session 측 자식별 cwd 분리 default · cross-repo 정합 처리 책임 = 사용자 본인 영역 default.

**진입 조건**:
- 실 IMPL 영역 (= 자식 도메인 source / cli infra propagation cycle / 자식별 무거운 IMPL 영역 default)
- 단일 자식 측 무거운 IMPL 영역 (= main agent context 측 단일 자식 본질 측 집중 의무)
- 자식별 IMPL 측 다른 자식 무접촉 영역 default (= cross-repo 정합 영역 X 또는 사후 정합)
- cli session 측 context 측 분리 의무 (= session 측 자식 도메인 단일 집중 default)
- subscription pool 정합 영역 (= interactive pool 단일 default · §2.4 정합)

**호출 paradigm**:
```
terminal A → cli session A (cwd = ~/AndroidStudioProjects/GentlyBreath) → GB 도메인 IMPL
terminal B → cli session B (cwd = ~/AndroidStudioProjects/GentlyDay) → GD 도메인 IMPL
terminal C → cli session C (cwd = ~/AndroidStudioProjects/GentlyTable) → GT 도메인 IMPL
  ↓
사용자 본인 측 cross-repo 정합 의무 (= session × session 측 직접 cross-verify 영역)
```

**사용자 본인 측 의무 영역** (= 본 paradigm 측 trade-off 영역 default):

| 의무 항목 | 본질 |
|---|---|
| terminal × N 운영 | 자식별 1 terminal default (= 자식 3 → terminal × 3 default) |
| 자식 cwd 진입 | `cd ~/AndroidStudioProjects/<자식> && claude` × N 진입 default |
| paste source × N 운반 | cowork chat → cli session × N 측 paste 운반 default |
| paste-back × N 운반 | cli session × N → cowork chat 측 paste-back 운반 default |
| cross-repo 정합 의무 | session × session 측 직접 cross-verify default (= 자동화 영역 X · 사용자 본인 영역 default) |

**자식 cli infra 자동 정합 영역** (= 본 paradigm 측 benefit 영역 default):

- 자식 `.claude/settings.json` 정합 ✓ (= 자식 측 cli infra 본문 자동 적용)
- 자식 `.claude/hooks/*` 발화 ✓ (= SessionStart + PreToolUse + PostToolUse + Stop 모두 자동 발화)
- 자식 `.claude/rules/*` 정합 ✓ (= 자식 측 cli infra rule 본문 자동 적용)
- 자식 `.claude/agents/*` 정합 ✓ (= 자식 측 active/deferred agent 자동 인식)

**subscription pool 정합 영역** (= `2026-06-15 Anthropic billing split` 정합 · §2.4 정합 · ⚠ billing split 서술 = 공식 근거 UNVERIFIED — 2026-07-10 공식 문서 전수 조회 미발견 · 현행 공식 = 전 표면 구독 합산 · 행동 규정 불변 = kernel §2.4 주석 정합 · T7):

- 본 paradigm 측 모든 cli session = **interactive pool 정합 default** ✓ (= `claude` 단순 interactive 진입 default)
- 2026-06-15 이후 billing split 영역 **무 영향 default** (= Agent SDK credit pool 분리 영역 미해당)
- `claude -p` sub-process spawn paradigm = **회피 default** (= §2.4 정합 · 요금 폭탄 risk default)

**trade-off 영역** (= 본 paradigm 측 사용자 본인 측 부담 영역 default):

- 사용자 본인 측 의무 영역 default (= terminal × N 운영 + paste × N 운반 영역)
- cross-repo 정합 자동화 X default (= cowork chat 측 보조 측정 영역 default · 자동 cross-verify 영역 X)
- weekly limit × N 영역 default (= 사용자 본인 측 cli session 활용 영역 default · subscription pool 분배)

**적용 case 예**:
- "GB + GD + GT 측 동일 Auth bootstrap 신설 의뢰" (= 동족 자식 측 실 IMPL · 영역 2 권장 default)
- "GB 측 Phase 2 Auth 도메인 무거운 IMPL cycle" (= GD/GT 무접촉 · 영역 2 단일 자식 진입)
- "GT 측 daily-prescription 측 INITIATIVES 갱신 cycle" (= 다른 자식 무접촉 · 영역 2 단일 자식 진입)
- "자식별 도메인 specific cycle 측 동시 운영" (= 사용자 본인 측 multi-tasking 영역 · 영역 2 다중 cli session 운영)

#### 2.2.1 dispatch 체크리스트 (= cowork-role 측 영역 2 운영 step 본문)

본 sub-section = 영역 2 측 cowork-role(= cowork chat 기획 측) 이 동족 자식 다중 변경 cycle 을 실제로 어떻게 분배하는지 step-by-step 단일 명문화 영역. 운영 증거 = cc-paste-GB-T07 + GD-T11 + GT-T02 등 자식별 entry-prompt 발행 패턴. 본 절 신설 전까지 = 패턴 실재 · rule 본문 미명문화.

| step | 주체 | 본문 |
|---|---|---|
| 1 | cowork-role | repo별 지시 prompt `cc-paste-<REPO>-<TASK>.md` × N authoring (= 자식별 delta 차별화 · 동일 prompt × N 복제 회피 · §2.2.2 + `paste-authoring-disk-verification.md` 정합) |
| 2 | cowork-role | 본인 측 방향 설명 1 줄 (= gatekeeper step 유지 · 어느 자식이 무엇을 받는지 본심 명시) |
| 3 | 본인 | 한 줄 트리거로 repo별 cli session 진입 (= clipboard 수동 운반 단계 제거 · §2.2 진입 표 측 `cd ~/AndroidStudioProjects/<자식> && claude` 정합) |
| 4 | 자식 cli session × N | 각 repo 가 자기 fresh context 안에서 자기 cc-paste 단일 실행 (= 단일 session 전담 아님 · 자식별 독립 context · autocompact thrashing 회피) |
| 5 | cowork-role | paste-back × N 회수 + session × session 직접 cross-verify + 마무리 + 다음 task 선정 복귀 (= `automation-policy.md §5` disk 직접 read 의무 정합) |

#### 2.2.2 dispatch ≠ sub-agent fan-out (= B-5 경계 명시)

본 dispatch 분배 = **영역 2 다중 cli session** 분산 default · **영역 1 sub-agent fan-out 아님**. 즉 단일 cli session 측 Task tool spawn 으로 자식 N 을 부르는 영역 X. 자식별 = 사용자 본인 측 독립 terminal × 독립 session × 독립 subscription interactive pool 진입.

sub-agent(= 영역 1) 영역 = 가벼운 cross-repo 측정 (= sha 측정 / source grep / cross-verify) ≤ 3 한정 default (= §3.4 Sub-agent token cost warning 정합 · 실 IMPL 또는 자식별 무거운 분배 영역 측 sub-agent spawn 회피). dispatch 측 무거운 IMPL 분배 = 영역 2 단일 진입점 default.

### 2.3 paradigm 선택 본심 (= cli session 자율 판단 default)

본 paradigm 분기 측 선택 = **cli session 자율 결정 default**. 요청사항 본질 측정 후 paradigm 선택 default.

| 요청사항 본질 | 권장 paradigm | 근거 |
|---|---|---|
| 가벼운 cross-repo 정합 영역 (= sha 측정 / source grep / cross-verify) | **영역 1** (sub-agent fan-out) | main agent context 측 통합 가능 영역 default |
| 동족 자식 측 동일 paradigm 신설 (= GB + GD + GT 측 동일 patch) | **영역 1** (sub-agent fan-out) | 단일 cli session 측 효율 default |
| cli infra propagation cycle (= master → 4 자식 byte-identical) | **영역 1 또는 단일 cli session** | propagate.sh 측 단일 호출 paradigm default |
| 단일 자식 측 무거운 IMPL (= 다른 자식 무접촉) | **영역 2** (다중 cli session) | context 측 분리 의무 default |
| 자식별 도메인 specific cycle 동시 운영 (= 사용자 multi-tasking) | **영역 2** (다중 cli session) | session 측 독립 context default |
| cross-repo + 단일 자식 무거운 IMPL 혼합 영역 | **자율 결정** (= 사용자 본심 측정 의무) | 본심 분기 의제 본질 발견 시 = AskUserQuestion 영역 |


---

## 3. 자식별 cwd 분리 paradigm (= 영역 1 적용 시 default)

영역 1 (= 단일 cli session 측 sub-agent 병렬) 적용 시점 자식별 cwd 분리 의무. main agent 측 cwd 측 default 보존 + sub-agent 측 자식 repo 측 cwd 진입 paradigm 명시 default.

### 3.1 Task tool 호출 paradigm

```python
# main agent (cwd = 부모 mount root)
Agent(
  description="GB 측 cli infra rule sha 측정",
  subagent_type="general-purpose",
  prompt="""
  Working directory = /Users/yundonghyeon/AndroidStudioProjects/GentlyBreath
  
  본 자식 repo 측 docs/rules/cycle-discipline.md sha 측정 의무 (`git hash-object`).
  결과 = sha + file 측 last commit 측 정합 측정.
  
  Return format: Verdict + Top Findings (sha + commit) + Pointers + Recommended Next Step.
  Return 본문 ≤ 2,000 token.
  """
)
```

### 3.2 sub-agent 측 인지 paradigm

sub-agent 측 자식 측 cli infra (= `../<repo>/CLAUDE.md` + `.claude/`) 인지 paradigm 정합 의무:
- sub-agent 측 자식 측 reading order 정합 default (= 부모 mount root CLAUDE.md §3.1 정합)
- sub-agent 측 자식 측 cli infra rule (= 자식 측 `.claude/rules/`) 측 byte-identical 영역 인지 (= cli infra SoT = master 측 단일 default)
- sub-agent 측 자식 측 보호 file 인지 (= 5 file × 4-repo byte-identical default)

### 3.3 sub-agent return 영역 통합 paradigm

main agent 측 sub-agent 결과 통합 paradigm (= `reporting.md` §9 Subagent Return Contract 정합):

1. **Verdict 측 비교** = 자식별 PASS / FAIL / PARTIAL / UNKNOWN 영역 통합 측정
2. **Top Findings 측 동족 영역 측정** = 동족 자식 측 paradigm 정합 측정 default (= sha 정합 / source code 정합 / lifecycle 영역 정합)
3. **Counter-example 측 영역** = main agent 측 cross-repo 정합 결정 측 보강 영역 default
4. **Pointers 측 lazy loading** = main agent 측 필요 시점 측 추가 read default (= just-in-time)

### 3.4 Sub-agent token cost warning (= 7× standard default · `MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001` 신설)

> **본 sub-section = 영역 1 sub-agent fan-out paradigm 측 실제 token 비용 영향 영역 본문 default**. main agent 측 sub-agent fan-out 결정 시점 본 warning 영역 측정 의무 default.

**sub-agent token 비용 본질**:

| paradigm | token 비용 비율 (vs standard single-agent) | 본질 |
|---|---|---|
| single-agent (= standard cli session 단일) | 1× (= baseline) | main agent context 단일 default |
| 3-agent team (= main + sub × 2) | **~7× default** | sub-agent context × N 분리 + main agent 측 통합 token 영역 누적 default |
| Agent SDK 측 호출 (= 영역 3 영역) | Claude Code terminal × **1.3~1.5× default** | prompt caching 영역 차이 default (= Agent SDK 측 캐싱 영역 X 또는 부분 default) |

**실 사례 인용** (= 본 paradigm 측 awareness 영역 default):

- **49-subagent typescript-checks 측정 사례**: **$8,000 ~ $15,000 USD default** (= sub-agent fan-out paradigm 측 large-scale 적용 영역 default · 사용자 본인 측 측정 사례 인용 영역)
- **23-subagent code-quality project 측정 사례**: **$47,000 USD default (3 days 측정)** (= sub-agent chain 측 unattended 영역 적용 사례 default · 사용자 본인 측 risk awareness 영역 default)
- 측정 source: 2026-05-19 KST 측 공개 측정 사례 영역 default

**권장 paradigm 정합** (= 본 §3.4 정합 default):

| 권장 항목 | 본질 | 정합 영역 |
|---|---|---|
| **sub-agent parallelism cap default** | main agent 측 동시 sub-agent fan-out 개수 한도 default (= 권장 ≤ 3 sub-agent default · cli session 자율 결정 영역) | `CLAUDE.md` 측 명시 영역 default |
| **sub-agent chain unattended 영역 회피 default** | sub-agent → sub-agent 측 chain 측 unattended 영역 default 회피 (= main agent 측 매 sub-agent return 측정 의무) | 영역 1 paradigm 정합 default |
| **`--include-hook-events` flag 측정 default** | sub-agent 호출 측 hook event 측 token 측정 의무 (= billing 측 정합 영역 default) | cli session 측 자율 측정 default |
| **subscription pool 정합 측정** | 영역 1 (= sub-agent fan-out) 측 interactive pool 정합 default (= §2.4 정합) · Agent SDK 영역 회피 default | §2.4 Subscription-aware paradigm 정합 default |

**main agent 측 sub-agent fan-out 결정 paradigm**:

- 요청 본질 측 token cost 측정 의무 default (= sub-agent N 측 ~N× ~7× 측정 영역 default)
- 가벼운 측정 영역 (= sha 측정 / source grep) = sub-agent 1~3 default (= 권장 ≤ 3 sub-agent)
- 무거운 영역 (= 자식별 IMPL / context-heavy 영역) = 영역 2 (= 다중 cli session) paradigm 정합 default · sub-agent fan-out 회피 default

## 4. cross-repo 정합 처리 paradigm (= 영역 1 적용 시 default)

> **3층 구분 (혼동 금지)**: cross-repo 정합은 세 층이 직교한다 — ① **정확성 cross-verify**(§4.1 · sub-agent verdict 통합 = disk PASS 대조 · A1) ≠ ② **동족 구현 정합**(§4.4 · 같은 맥락 2+ repo 구현 결과의 advisory 비교 · 사후 surface) ≠ ③ **cli-infra byte-identical**(§4.2 sha + 보호 file · A4 강제 수렴). ②는 ①의 정확성 판정도 ③의 강제 수렴도 아니며, 도메인 자율(§4.2 source 행 · §4.3 lazy 항) 위에 얹는 advisory 층이다(= 그 본문 불변).

### 4.1 main agent 측 sub-agent 결과 통합

자식별 sub-agent 결과 통합 시점 main agent 측 의무:
- 자식별 Verdict 비교 측 동족 영역 측정 (= 동족 자식 측 동일 영역 정합 measure)
- cross-repo 정합 결정 영역 측정 (= drift 발견 시점 mitigation cycle 진입 검토)
- 산출물 측 자식별 sub-agent return body 인용 default (= EVIDENCE.md 측 항목별 명시)

### 4.2 sub-agent 결과 비교 paradigm

동족 자식 측 paradigm 정합 측정 default. 영역:

| 비교 영역 | measure method | 정합 default |
|---|---|---|
| cli infra rule SoT 측 sha | `git hash-object` × 자식별 | 4-repo byte-identical 의무 (= master + 자식 3 측 동일 sha) |
| 보호 5 file 측 sha | `git hash-object` × 자식별 | 4-repo byte-identical 의무 (= `.auto-memory/protected-file-hashes.md` baseline 정합) |
| 자식 도메인 source code | `grep -rn` + 동족 자식 측 비교 | 자식별 도메인 specific 영역 default (= drift 영역 X · 자식 자율 default) |
| ui-spec.json 측 lifecycle | `grep -E "lifecycle\|deprecated"` | 자식별 lifecycle 영역 default (= 도메인 specific 영역 default) |

### 4.3 drift 발견 시점 mitigation

drift 발견 시점 main agent 측 mitigation:
- cli infra rule SoT 측 drift 발견 시 = master 측 정합 cycle 진입 (= `cycle-discipline.md` §15 패턴 1 정합 · 단방향 propagation cycle 진입)
- 보호 5 file sha drift 발견 시 = 즉시 STOP + 사용자 회수 (= `cycle-discipline.md` §10 + master CLAUDE.md §5 정합)
- 자식 도메인 source drift 발견 시 = lazy default (= 자식 자율 영역 default · cross-repo 정합 의무 X)

### 4.4 동족 구현 정합 advisory (= 사후 surface · 강제 X · 도메인 자율 위 advisory 층)

> **본 §4.4 = §4.2/§4.3 도메인 자율 default 위에 얹는 사후 advisory 층** (= 그 본문 덮어쓰기 X · 불변). §4.1 정확성 cross-verify(= disk PASS 대조)도, §4.2 cli-infra byte-identical 강제(= A4)도 아니다 — 같은 맥락을 2+ repo 에 구현한 결과를 비교·권장하는 **advisory** 단일. 도메인 구현 정합 doctrine 부재(= §4.2 source 행 · §4.3 lazy 항이 명시한 자식 자율 위의 빈자리) 채움.

**trigger**: 같은 맥락(= 동일 개념 / feature / contract)을 **2+ repo** 에 구현·변경한 cycle 의 **paste-back 회수 시점**. 매 cross-repo cycle 아님 (= 같은 맥락일 때만 발동). dispatch 운영(§2.2.1) 측 step 5(= paste-back × N 회수 + cross-verify) 시점에 정합.

**주체**: cowork chat (= N 개 paste-back + N repo disk 전체를 보는 유일 지점). 같은-맥락 부분 disk 측정 = Transport(= 자동화 OK) · 수렴 결정 = Inspection(= 본심 또는 cli 영역 · `automation-policy.md §1.1` 정합).

**행동**: 같은-맥락 부분 disk 측정(= diff / grep · 필요 시 영역 1 sub-agent ≤ 3 fan-out · §3.4) → **3-bucket 분류**:

| bucket | 본질 | 산출 |
|---|---|---|
| **공통화 권장** | 같은 맥락인데 갈라짐 · 더 나은 1 안 수렴 권장 | 권장 1 안 + 근거 + `file:line` |
| **분리 유지** | 도메인 specific 정당 · 자식 자율 보존 (= §4.2/§4.3 정합) | 보존 판정 + 근거 |
| **보류 / 본심** | 우열 불명 | 본심 회수 |

**산출**: 정합 표 1 개 (= bucket + 근거 + `file:line` pointer · 형식·발행 위치 = `reporting.md §14`). **advisory** — 수렴 *실행*은 후속 cycle(= 본심 또는 cli HOW)로 분리. **auto-rewrite / auto-converge 금지**.

**경계 (불변)**:
- 도메인 자율 default(= §4.2 source 행 · §4.3 lazy 항)는 **불변** — 본 층은 그 위 사후 surface(= 강제 X).
- **강제 byte-identical 수렴 = cli-infra 전용**(= A4 · §4.2 sha 행) 불변 — 도메인 source 를 byte-identical 수렴 대상으로 끌어들이지 않는다.
- 영역 1 fan-out 적용 시 **≤ 3 sub-agent + interactive pool**(= A6 · §3.4) 불변.

본 §4.4 신설 = `MASTER-CLI-CROSSREPO-RECONCILE-AUTONOMY-PARADIGM-001` (2026-06-22 · req1 동족 구현 정합 advisory 층 · req2 cli HOW 자율 확대와 한 쌍 = 사후 비교가 divergence catch).

## 5. 삭제 전파 절차 (= master 에서 지운 것이 자식에서도 지워졌는지)

> **신설** = `MASTER-PROPAGATION-HYGIENE-001` (2026-08-23). 계기 = `MASTER-AIDOC-RELEASE-REALIGN-001` 이 `docs/rules/sot-code-name-map.md` 를 은퇴시킬 때, **그 삭제가 자식에 착지했는지 물어볼 자가 없다**는 것이 드러났다. 집행 전 census 실측 = `docs/rules` + `.claude/rules` 전량에서 `git rm` hit **1** (= `legacy-cleanup-governance.md:33` · 그것도 「지울지 말지」의 STOP 판정이지 「어떻게 전파하는지」가 아니다) · `prune --apply` **0** · `삭제 전파` **0**.
> **왜 신 rule 파일이 아니라 절인가**: `docs/rules/*.md` 계수(**42**)는 `rule-routing-table.md` 가 인용하는 분모이고 직전 판이 방금 재계수한 값이다. 신설은 언제나 누군가의 분모를 낡게 만든다 (= `cycle-discipline.md` §2 「OPS 신설 금지 원칙」 · 그 §2 의 신설 escape 는 「사용자 본심 외화」 한정인데 본 절은 거기 해당하지 않는다).
> **왜 이 파일인가**: §4 가 「cross-repo 정합 처리」(= sha 비교 · drift mitigation)를 다루고, **삭제는 sha 가 없을 때의 정합**이다 — 같은 축의 빈자리. (후보 3본 대조: `legacy-cleanup-governance.md` = 코드 심볼 제거 governance 축이라 「문서형 task → 적용 안 함」을 스스로 명시 · `cycle-discipline.md` = 전 절이 요약 pointer 로 축소된 다이어트 판이라 본문 4명제를 얹으면 그 방향과 충돌.)
> **좌표 규율**: 아래 인용은 `파일:행` **+ 앵커 문자열**을 함께 적는다. 행은 움직인다 (= `stale-artifact-tracking.md:50` 「좌표 = `file` + 앵커 문자열 · ★행 번호 금지 (= 행은 움직인다)」와 같은 이유 — 실제로 본 절을 쓰는 cycle 이 같은 script 를 편집해 좌표를 21행 밀었다). 행 수치 = **2026-08-23 실측**이고, 갈리면 앵커로 다시 찾는다.

### 5.1 명제 1 — `verify-sync.sh` 는 삭제의 착지를 증명하지 못한다

`scripts/verify-sync.sh:128` (앵커 `done < <(find .claude docs scripts/agent …`) 이 분모(`CHECK_FILES`)를 **master 에서** 만든다. 이어 `scripts/verify-sync.sh:196~198` (앵커 `MASTER_SHA=$(shasum -a 256 "$MASTER_DIR/$f"` → `if [ -z "$MASTER_SHA" ]` → `continue`) 이 master 측 sha 가 비면 그 행을 **건너뛴다**.

⟹ **master 에 없는 파일은 분모에 들지 않는다.** 자식에만 남은 잔존물은 MISS 도 DRIFT 도 아니고 **아무것도 아니다** — 자는 「없다」고 말하는 게 아니라 **묻지 않는다**. `verify-sync` 가 대답하는 질문은 「master 것이 자식에 있고 같은가」 하나다.

★**반증 경로** (= 이것이 신념이 아니라 명제인 이유): 「자식-단독 잔존이 판독에 뜨는 실행」 **1건**이면 반증된다. 본 절 신설 cycle 이 그 실험을 실제로 돌렸다 — `docs/stale-sweeps/*` 2본을 분모에서 뺀 뒤 **Selfward 디스크에는 그 2본이 그대로 남은 상태로** `verify-sync` 를 재실행했고, 판독은 그 2본을 **한 줄도 언급하지 않았다** (집행 전 판독에서는 같은 2본이 DRIFT 로 떴다). **분모가 무엇을 볼 수 있는지를 결정한다.**

### 5.2 명제 2 — 삭제 전파는 2단이다 (영역마다 경로가 다르다)

| 영역 | 경로 | 근거 (`파일:행` + 앵커) |
|---|---|---|
| `.claude/**` | `bash scripts/propagate.sh --prune --apply` (= 자동 `rm` + 자식 `git add`) | whitelist = `scripts/propagate.sh:180` 앵커 `PRUNE_BASE_PATHS=(.claude)` · 실행부 = `scripts/propagate.sh:246~252` 앵커 `# master 부재 여부` → `rm -f "$REPO_DIR/$f"` · `--apply` 미지정 = dry-run (`orphan:` list 만) |
| `docs/**` · `.ai/**` · `scripts/agent/**` · `app/**` | ★**자식별 수동 `git rm`** | `scripts/propagate.sh:172` 앵커 「자식의 도메인 영역 (docs/, .ai/, scripts/agent/, app/) = 자율 영역 = prune 안 함」 — **의도된 미포함**이지 누락이 아니다 |

★**whitelist 확장으로 해결하지 마라.** `PRUNE_BASE_PATHS` 를 넓히는 것 = master 가 자식 도메인 자율 영역을 일괄 `rm` 할 권한을 갖는 것이고, §4.2 「자식 도메인 source = 자식별 도메인 specific · drift 영역 X」 + §4.3 「자식 도메인 source drift = lazy default」와 정면 충돌한다. 확장은 Coin 명시 회수 사항 (= `scripts/propagate.sh:173` 앵커 「cli infra 외 영역 추가 = Coin 명시 의무」).

### 5.3 명제 3 — 삭제 판의 착지 게이트 = 자식 N개 각각의 `test -f` 부재

명제 1 때문에 `verify-sync` exit 0 은 **삭제 착지의 증거가 아니다**. 삭제를 포함한 cycle 은 게이트를 따로 세운다 (= 자식 수만큼 직접 측정 · 도구 판독 인용 금지):

```bash
for r in app-foundation toward-product-docs Selfward; do
  [ -f "../$r/<지운 path>" ] && echo "RESIDUAL $r" || echo "OK(absent) $r"
done
```

선례 = `MASTER-AIDOC-RELEASE-REALIGN-001` (2026-08-23 · 착지 `3a62ad6`) — `docs/rules/sot-code-name-map.md` 은퇴를 **4-repo 전량 `test -f` 부재 실측**으로 닫았다 (본 절 작성 시점 재측정: master · FND · TPD · SW 전량 부재 ✓).

### 5.4 명제 4 — 이력은 지우지 않는다 (`.auto-memory/<name>-COLD.md` verbatim 이관)

문서를 은퇴시킬 때 본문은 `.auto-memory/<name>-COLD.md` 로 **verbatim** 옮긴다 (= 삭제 0 · 소급 정정 금지 정합). **master 한정**이다 — `.auto-memory` 는 전파 분모 밖이라(= `scripts/verify-sync.sh:128` 의 find 진입 root 6종 = `.claude` `docs` `scripts/agent` `.ai/promptfit` `.ai/uiux-sot/refresh` `.github` · `.auto-memory` 부재) 자식 판에는 COLD 가 **없는 것이 정상**이다.

실측 선례 = `.auto-memory/*-COLD.md` **9본** (`ls -1 .auto-memory/*COLD*.md | wc -l` · 2026-08-23) — `abbreviation-policy` · `anchor-list` · `cross-repo-parallel-exec` · `cycle-discipline` · `master-cycle-history` · `mode-bundle` · `rule-routing-index` · `sot-code-name-map` · `text-degeneration-prevention`. 마지막에서 두 번째가 직전 판이 낸 것이다.

### 5.5 경계 — 제외(exclude)는 삭제가 아니다

find 제외 절에 1줄 넣는 것은 **분모에서 빼는 것**이지 자식 디스크에서 지우는 것이 아니다. 둘을 섞으면 「조용해졌으니 정리됐다」는 오독이 생긴다. 제외 후에도 자식 잔존물은 그대로 있고, 명제 1 때문에 **자는 그것을 영원히 언급하지 않는다** — 잔존을 없애야 한다면 명제 2·3 을 따로 밟는다.

★**file 단위 제외의 대가** (= 2026-08-23 실측 기반 결정): `docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md` 는 **dir 이 아니라 file 단위**로 제외했다 — 같은 dir 의 형제 `external-dep-abstraction.md` 가 FND/TPD/SW 전량에 실재하는 **살아 있는 전파**여서, dir 제외는 그 3본을 분모에서 함께 죽인다. 대가는 명시한다: **그 dir 에 master-only 문서가 또 생기면 그 1본이 다시 MISS 로 뜬다.** 그때의 처분 = 제외 행 1줄 추가이고, 「형제가 전파 중인지」를 먼저 `test -f` 로 재는 것이 순서다 (= 살아 있는 전파를 죽이는 것보다 MISS 1건이 싸다).


---

## 6. 명시 cycle 이력

> 판정 = **실질 개정 있음** (= 2026-08-30 `MASTER-RULE-HISTORY-SECTION-001` 소급 판정 · 축 = `rule-footer-common.md` 「실질 개정 ↔ 기계 치환」 · 판정표 29 행 = 그 판 REPORT). 소급 범위 = **판정 근거 한정**(= 무한 소급 금지 · 전 계보 열거 아님) · **기계 치환 commit 미등재**(= 축 자기 적용).

- 2026-05-19 · `MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001` · 본 rule 신설 (= 196 행 · `e1cef8c` · cross-repo 실행 paradigm 본문).
- 2026-08-30 · `MASTER-RULE-HISTORY-SECTION-001` · **본 절 신설** (= 위 판정의 착지 · `rule-footer-common.md:10` 등재 의무 소급 이행 · 본문 절 무접촉).
