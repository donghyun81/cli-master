# Cycle Discipline Rules

> **단일 목적**: master ↔ 자식 repo 의 cycle 운영 표준 — per-cycle **실행 규약만 hot 잔존**. incident 서사 / Phase lifecycle 서사 / 절차 이력 / 도입 근거 = [`.auto-memory/cycle-discipline-COLD.md`](../../.auto-memory/cycle-discipline-COLD.md) (= pre-DIET2 원문 전문 verbatim snapshot · 비규범 감사 전용 · master-only · MASTER-CLI-CONTEXT-DIET-2-001 T1).
> **연관 파일**: `workflow-core.md`(단계 흐름) · `rule-routing-table.md`(행동→규칙 의무 로드) · `safety-and-secrets.md`(금지 명령) · `verification-and-review.md`(/verify·/review)
> SOT: `CLAUDE.md`

---

### 1) 거시 목표

본 repo 의 본 작업 = **Pencil → Compose 파이프라인** (= 디자인 `.pen` → dual SoT sha 동기 → Compose 구현 → 배포). 모든 cycle 은 위 단계의 한 부분을 직접 진척시킨다. 그 외 = OPS 정비.

### 2) OPS 신설 금지 원칙

- 새 룰 박기 전 **도메인 매칭 검증 1회 필수** — 기존 룰 도메인에 안 속하면 신설하지 않는다 (운영 메모로만 유지).
- 본 작업 무관 OPS hygiene task 신설 금지 — 사고가 본 작업을 직접 블로킹할 때만 처리 (lazy mode).
- **예외 (L1-1)**: 사용자 본심 외화 영역 = 신 rule 허용 (본인 명시 결정 + paste umbrella §3 contract 측 본심 인용 의무).

### 3) byte-identical 강제 범위

- **보호 파일 5종 (강제)**: `docs/schemas/ui-spec.schema.json` · `docs/rules/pencil-uiux-workflow.md` · `docs/design/pencil-sot-policy.md` · `docs/rules/uiux-sot-refresh.md` · `docs/design/design-sot-policy.md` — drift = 즉시 mitigation (리뷰 블로커).
- **cli infra 권장 byte-identical**: `.claude/` 전체 + `scripts/` propagation 도구 + `docs/agent/architecture/*` + `docs/templates/*` — drift = lazy mitigation default.

### 4) repo 규약

task ID prefix = source repo (`GB-*` → GB source · `GD-*` → GD · `GT-*` → GT · `C<n>-*`/`MASTER-*` → master). 보호 파일은 어느 source 든 byte-identical 결과 강제.

### 5) git 역할 경계 정책 (v3 · commit=cli 소관 · push+고위험 git=Coin)

- **commit = cli 소관 default (전 카테고리 · 영구)**: cycle 산출물의 add/commit + 커밋 메시지(§6/§7 표준 · `COMMIT_CONVENTION.md` 준수 주체 = cli) + git log 위생 = cli 가 cycle 마감 step 에서 수행. (v2 의 자동 허용 카테고리 나열 · `[agent-commit: yes]` 묵시 신호 = 폐지 — 전면 default 라 불요.)
- **품질 게이트(기계) 유지**: `app/src/` 변경 커밋 = 빌드 PASS 선행. §9 자기검증 · stage 정합(`pre-commit-stage-check.sh`) · §10 보호 파일 sha 의무 = 불변.
- **STOP#1/M3 도메인(DB migration · auth/billing · secret) 산출물 커밋도 cli 소관**: cycle 자체가 승인된 paste 하에서만 진행되므로 그 산출물 commit 도 cli 가 수행 (v2 의 "Coin direct 강제" 행 폐지). **단 paste 없는 자율 cycle 개시 금지 = 기존 규칙 그대로** (commit 권한 ≠ cycle 개시 권한).
- **Coin 소관 = push + 고위험 git 연산 (승인+실행)**: `git push`(원격 반영) · 이력 조작/파괴 = `git reset` · `git clean` · `git rebase` · `git filter-branch`(이상 `settings.json` deny 차단) + `git commit --amend` · `reflog expire` · 브랜치 강제 삭제 · `--force` 계열(deny 패턴 불가분 = **문서 금지 · cli 실행 절대 X · 필요 시 STOP + Coin 회수**).
- 우선순위: 본 §5 v3 우선 · `safety-and-secrets.md` deny 표 = 응급 백스탑(push + 파괴 연산 한정). (v2→v3 정정 = 2026-07-15 Coin 본심 · `settings.json` `Bash(git:*)` allow 실측 + 실운영 정합 · v2/v3 도입 근거 서사 = COLD)

### 6) commit subject 표준

`<type>(<scope>): <task-id> <summary>` — type = feat|fix|docs|chore|refactor|audit|test|perf|style · task-id 단일 (다른 task ID 절대 포함 금지) · summary ≤ 50자 동사 시작.

### 7) commit body 표준 — 6 섹션 필수

`[Goal]` 거시 목적 1줄 · `[Diff]` 변경 파일+핵심 라인 수 · `[Sha]` 보호 파일 새 sha 8자 (없으면 "(불변)") · `[EC]` 핵심 Exit Criteria · `[Next]` 다음 trigger (없으면 "(없음)") · `[Refs]` parent hash + 연관 task ID. 빈 섹션도 라벨 유지 (future grep 안정성).

### 8) future context 회복 패턴

새 cycle 진입 = **SessionStart hook 주입값 (branch · open_tasks · last_review · protected_baseline · cc_version) 인용 우선** · 추가 `git log` / `git show` = 필요 시 cli 판단 (= T5 재정독 개정 · 원문 명령 목록 = COLD). memory 파일과 git log 충돌 시 **git log 우선** (immutable · point-of-truth).

### 9) 자기 검증 — 모든 commit 직후 1회 의무

`git log -1 --format=%s` + `git log -1 --format=%b` 를 expected message 와 1행씩 대조. 불일치 = drift = 해당 commit immutable 보존 + 다음 commit 부터 경로 점검.

### 10) 보호 파일 변경 시 추가 의무

보호 5종 sha 변경 commit = body `[Sha]` 새 sha 8자 명시 + cross-verify 결과 `[EC]` 명시 + commit 후 `.auto-memory/protected-file-hashes.md` baseline 갱신 (+ master `CLAUDE.md` §14a git-sha1 정합).

### 11) 보고서 lightweight 옵션

cleanup / docs / propagation / discipline 류 task = 4 파일 (PLAN / VERIFY / REVIEW / TODO). MODE / EVIDENCE / COMPOUND = audit / evidence-heavy task 한정.

### 12) 세션 운영 P0 (= context/cache 보존 · MASTER-CLI-CONTEXT-DIET-2-001 T8)

- ① 세션 중 `/model` · `/effort` 전환 금지 — cycle intake 시 확정 (= model/effort = prompt cache 키 포함 · 중도 전환 = 캐시 전량 무효). 전환 필요 = 신 세션 진입.
- ② cycle 경계 = `/clear` · 방향 전환/잘못된 갈래 복구 = `/rewind` (= 누적 context 오염·비대 차단).
- ③ Claude Code 업그레이드 직후 = old session resume 금지 — 신 세션 + Mode 7 (task 재개-후속형) 재진입.
- ★**④ context 압축 후 재개 시, 요건의 분모는 요약본이 아니라 원문이다** (K-148). 요약은 **진행을 위한 것이지 판정을 위한 것이 아니다.**
  - 재개 직후 **「무엇을 요구받았나」를 원문(transcript · 발주서 · 원장)에서 다시 뽑고**, 요약본에만 있는 항은 **원문 좌표를 붙여 복원**한다.
  - **요약이 「전문 인용됨」으로 접은 블록은 분모에서 빠진 것과 같다** — 그 블록을 편 뒤에 요건 수를 센다.
  - **실측** = 압축 후 재검증에서 요약이 접은 진입 프롬프트 1본을 펴자 **누수 9**가 나왔다 (집행 문서에 규율 6 개가 **0 건**인 상태 포함).

### 13) Claude Code 환경 정합 (latest-chase · 요약 — 서사/복귀 명령 원문 = COLD)

- **버전 정책 = 최신 추격 (latest-chase · pin 폐기)**: npm scope `@anthropic-ai/claude-code` 의무 · `DISABLE_AUTOUPDATER=1` + `DISABLE_UPDATES=1` 이중 차단 유지 (해제 금지 · `~/.zshrc` + `~/.claude/settings.json` env 양쪽) · 능동 갱신 = 사용자 직접 `npm install -g @anthropic-ai/claude-code@latest` (주 1회 권장).
- **매 cycle 진입 self-test 3 항목 (모두 PASS 의무)**: ① `claude --version` ② `claude mcp list` 안 `pencil ✓ Connected` ③ ToolSearch pencil **9종 named-set 전수** (= batch_design / batch_get / export_html / export_nodes / get_editor_state / get_guidelines / get_screenshot / get_variables / snapshot_layout · 단순 ≥N 카운트 X). 기록 = **판정 + 핵심 수치 + 원문 pointer** (raw verbatim 박제 X · T3 · `reporting.md` §8).
- **1+ FAIL = 즉시 STOP** + known-working 복귀 (= `.auto-memory/incident-log.md` `CLAUDE-CODE-LATEST-CHASE-001` trail 마지막 PASS entry 기준 · 복귀 명령 sequence + native installer 재검토 trigger 4조건 원문 = COLD).

### 14) Phase C — Pencil → Compose 5-type 분류 (pointer)

5-type 분류 본문 = `design-to-code-sync.md` §3 (도구 무관) + `pencil-uiux-workflow.md` §3 (보호 · Pencil 바인딩). **운영 hard 의무 3 유지**: ① commit-then-verify (= .pen + ui-spec.json + Compose 단일 commit 후 verify · 역순 금지) ② boundary mapping = **ViewModel 만** (UiState 가 DomainModel 직접 import = REVIEW §4 FAIL) ③ 외부 의존 미준비 = `TODO(user-prep)` stub (UI 불변 상태 침해 금지). Phase A~F lifecycle 서사 + sub-cycle 표 + 진입/마감 신호 원문 = COLD.

### 14a) Cowork prep ↔ CLI baseline 동기화 (요약 — 사고 서사 = COLD)

Cowork prep 통합 prompt 작성 전 **6 실측 의무** — **hook 주입값 인용 우선 · 부재 항목만 명령 실측** (T5): ① 대상 repo `git log --oneline -5` ② decision-log tail ③ 보호 파일 sha 변동 추적 ④ 사용자 메시지 PASS/피드백 분류 ⑤ 기획 문서 실측 (새 화면/도메인/기능 시 기획안 grep 의무) ⑥ 3-자식 git log (별 cycle 추적). 근거 사고 trail (COWORK-PREP-BASELINE-MISMATCH-001~007) 원문 = COLD.

### 15) cli 수정 패턴 3 종

| 패턴 | 조건 | 처리 |
|---|---|---|
| **패턴 1** 공통 cli 변경 | 자식 repo 안 사고/개선 발견 (도메인 무관 정책) | 자식 측 직접 수정 STOP → master 신 cycle → 변경+commit → propagate → verify-sync → 자식 영향 검증 |
| **패턴 2** local-only | `.claude/settings.local.json` / `.ai/` / 자식 `app/` 코드 | master 무관 · 자식 자유 변경 · propagation X |
| **패턴 3** 도메인 활성화 | UNKNOWN → ACTIVE trigger (`deferred-domains.md` §5) | STOP → master 신설 (`<domain>-rules.md` + `activate-agent.sh` + deferred-domains/routing 표 갱신) → propagate → 자식 구현 cycle |

**§15 hot 상한 규약** (= 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` 신설 · 마감 step 의무): master `CLAUDE.md §15` entry 신설 시 — ① 신 entry = **≤400B** 로 저작 ② **3 초과분 = 그 자리에서 즉시 COLD demote** (= `.auto-memory/master-cycle-history-COLD.md` 표 말미 verbatim append · advisory 대기 / 별 demote cycle 신설 **금지** — 그 lazy 가 이력을 헌법의 ~70% 로 키웠다) ③ demote 후 COLD title / §1 heading / lineage count 동기 ④ 제거 행이 COLD 에 **verbatim 실재** 확인 (= exact-string 대조 · 손실 0 = HARD). 상세 서술의 진짜 SoT = `.ai/reports/<cycle-id>/REPORT.md` · §15 = 색인 층.

### 16) cli 수정 우선순위 결정 트리

cli infra 수정 필요? — YES: 자식 안 사고 발견 = 패턴 1 · local override 만 = 패턴 2 · 도메인 활성화 trigger = 패턴 3 / NO: 자식 본 작업 cycle 진행. (원문 diagram = COLD)

### 17) BASELINE 실측 표준 (filename + content 동시 grep 의무)

1. filename find 1차 → 2. **container 내부 content grep 2차 의무** (= filename 부재 시점 즉시 STOP/UNKNOWN 분류 금지 · symbol/object/function content keyword grep) → 3. lifecycle/deprecated 키워드 grep (ui-spec.json / SoT 실측 시 의무) → 4. filename + content **둘 다 부재 시점에만** STOP/UNKNOWN 분류 가능. (근거 사고 원문 = COLD)

- **★범위 축 (= 위 4-step 의 전제)**: 본 절차는 **전수 트리 위에서 돌 때만** 유효하다 — **subset 위의 부재 판정 무효** · 「판정 보류」 표기 · **위임 범위 명시** · **받은 부재 보고 회수 시 재측정** 의 단일 SoT = [`code-principles.md` §2 「부재는 전수 트리에서만 판정한다」](./code-principles.md).

### 18) cli infra 분기 정기 review cadence (요약 — scope 표 = COLD)

매 quarter 첫 월요일 KST (1/6·4/6·7/6·10/6 부근) — rules outdated + hooks self-test + settings 정합 + 보호 baseline + incident 추세 + `context-health-metrics.md` 재측정. 산출 = lightweight 4 file. 자동 발화 X (사용자 인지 단일).

### 19) 반복 패턴 자기관측 loop (요약 — 상세 = COLD)

cycle 마감 시 REVIEW/EVIDENCE 안에서 **같은 paradigm 이 반복 등장**하는지(한 file 3+ 회가 관례 임계) 스스로 관측하고, 걸리면 rule candidate 로 제안한다 · 비차단 · 채택 = 사용자 자율 (자동 file 신설 X).

> **2026-07-29 `MASTER-CLI-JUDGMENT-SHIFT-001` supersede**: 구 판은 이 관측을 `stop-reflect.sh` (Stop hook) 의 **단어빈도 grep** 이 수행했다. 신호가 약하고(빈도 = 반복 paradigm 의 대리 지표일 뿐) 회고는 맥락 판단 영역이라 hook 을 제거하고 **cli session 판단으로 위임**했다. 임계·비차단·사용자 confirm 성격은 불변 (= `rule-routing-index.md §C` amend loop + `gsm-measurement.md §6` 정량 trigger 정합).

### 20) DocSync 단계 본문

cycle 마감 시 갱신 대상 3 영역: ① task 산출물 (`.ai/reports/<taskId>/*.md`) ② 운영 레이어 (`docs/agent/**`) ③ **자식 출시 docs** (= `docs/release-readiness/INITIATIVES.md` + `docs/CLAUDE.md` 또는 자식 root `CLAUDE.md` + `docs/setup/*`). 본 cycle 영향 영역 발견 시 갱신 의무 · 무영향 = 0 갱신 (빈 commit 금지) · 진입 = `docs-change-communicator` agent. 사용자 manual 갱신 영역 폐기 (= 자동/반자동 우선).

### 21) Cross-repo cycle 영역 (= 4-repo)

- **21.1 영역 분리**: cli infra 4-repo byte-identical 영역 = §15 패턴 1 · 자식 도메인 specific = §15 패턴 2 (본 § 영역 X) · cross-repo 정합 검증 = 패턴 1 + 영역 1 sub-agent fan-out.
- **21.2 paradigm 분기** 단일 SoT = `cross-repo-parallel-exec.md` (= 영역 1 sub-agent fan-out / 영역 2 다중 cli session · 선택 = cli session 자율).
- **21.3 운영 표준 7 step**: ① master 변경+commit → ② `bash scripts/propagate.sh <path> [--targets all]` → ③ 자식별 staged commit (master commit body 인용) → ④ `bash scripts/verify-sync.sh` exit 0 → ⑤ `propagation-reports/<cycle-id>/REPORT.md` 생성 → ⑥ master audit commit (`.auto-memory/propagation-status.md` 갱신) → ⑦ master `CLAUDE.md` §15 entry append.
- **21.4 STOP** = [`stop-canonical.md`](../../.claude/rules/stop-canonical.md) (9항 canonical · pointer · 2026-07-29 master `CLAUDE.md §5` 에서 이동).
- **21.5 산출물** = master `.ai/reports/<cycle-id>/` {PLAN,EVIDENCE,VERIFY,REVIEW,TODO} (= lightweight 가능 · §11 정합).
- **21.6 정합** = `cross-repo-parallel-exec.md` + `cross-repo-orchestrator.md` + `routing-and-delegation.md` §실행 방식 + 부모 mount root `CLAUDE.md` §3.

### 22) git mv + sed 측 stage 정합 (요약 — 사고 본질/step 표 = COLD)

rename + content 변경 동시 cycle = **post-rename `git add -u` 의무** → `git diff --cached --name-only` stage 전수 확인 + `git status` unstaged 0 확인 → commit 진입. 확장/이동 cycle 마감 = 구명·구경로 dual grep sweep 보고 의무 (A7 정합). hook = `pre-commit-stage-check.sh` (warn · non-blocking). STOP = master `CLAUDE.md` §5 #8.

### 23) ~ 29) paradigm thin pointers (본문 복제 0)

- **23** Recommended option disk verification = [`disk-verification` skill](../../.claude/skills/disk-verification/SKILL.md) (경유 `recommended-option-disk-verification.md` · §17 실측 표준 흡수)
- **24** Runtime crash mitigation = [`runtime-crash-mitigation` skill](../../.claude/skills/runtime-crash-mitigation/SKILL.md) (9-step · staging 한정)
- **25** INITIATIVES + INDEX + task file auto-sync = [`initiatives-sync` skill](../../.claude/skills/initiatives-sync/SKILL.md) (5 의무 영역 = skill §3 · ④ KR gate + ⑤ always-fresh)
- **26** Paste source authoring disk 실측 = [`disk-verification` skill](../../.claude/skills/disk-verification/SKILL.md) §2 책임 분리 + §4 의무 ⑤ (= 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` 로 구 `paste-source-authoring` skill 통합 · §23 과 같은 file 을 가리킨다)
- **27** Anchor list = [`anchor-list.md`](../../.claude/rules/anchor-list.md) (10 anchor hot · negative space line = `reporting.md` §13)
- **28** Automation policy = [`automation-policy.md`](./automation-policy.md) (Transport 자동화 OK / Inspection 자동화 X)
- **29** Mode 시스템 = [`mode-system.md`](./mode-system.md) (M1/M3/M5 bundle + picker + recovery)

### 30) ChangeBudget 층 분리 + 재작성 별도 보고 (= 밴드가 스스로를 정의한다)

- **3층 분리 의무**: ChangeBudget 밴드는 **① 실코드 / ② 주석·KDoc / ③ test** 를 **각각의 밴드**로 적는다. 한 숫자로 합치면 "문서를 쓰라"는 지시와 "라인을 줄이라"는 밴드가 **같은 cycle 안에서 서로 모순**된다.
- **분류 기준을 밴드가 직접 말한다**: 각 층이 **주석 · KDoc · 빈 줄을 포함하는지** 밴드 옆에 명시한다. **정의 없는 밴드는 스스로를 위반한다**(세는 법이 없으면 초과 판정도 없다).
- **★재작성 file 은 라인 밴드에서 뺀다**: 통째 재작성한 file 은 밴드에 넣지 말고 **"재작성 N file + 사유"** 로 **따로 보고**한다. `git show --numstat` 은 **재작성을 재지 변경을 재지 않는다**(전량 삭제 + 전량 추가로 계상).
- **실측 대응은 초과가 아니다**: paste 자신이 요구한 문서 · test · 실측 정정으로 발생한 증분은 **밴드 초과로 판정하지 않는다**(사유를 REPORT 에 명시). **밴드가 옳은 판단을 처벌하면 안 된다.**
- 실측 근거 = **5회 연속 초과** (S0 test `+181` · S2 KDoc `+92` · HARDEN quote-repair · OUTPUT-BUDGET EF `+176`/test `+205` · SETTLE test `+248`). **초과분은 매번 paste 자신이 요구한 문서·test 였다.** 특히 SETTLE 의 `+248` = 두 ViewModel test file **통째 재작성**이 만든 개명 churn 이고, 그 재작성은 **옳은 판단**이었다(상태기계가 바뀌었으므로).

### 31) paste 발행 전 scope × 제외 교차 검사 (= 상충은 문면끼리만 나지 않는다)

- **발행 전 교차 검사 의무**: paste 저작 **마지막 step** 에서 ① **scope/변경 표 전 항** × **제외·STOP 좌표** = 교집합 0 인가 ② **scope 표 전 항** × **ChangeBudget 밴드 · 수치 조건 · xverify 기준** = **동시 충족 가능**한가 — **둘 다** 대조하고 **결과를 paste 본문에 기록**한다.
- **★①만 돌리면 안 잡힌다**: 상충은 **문면 ↔ 문면** 뿐 아니라 **문면 ↔ 밴드/수치** 사이에서도 난다. 실측 = 어느 paste 가 ①을 실제로 돌려 **"충돌 0"** 을 선언하고도, 같은 문서 안에서 **「순감 −120~−40」 밴드 ↔ 「구 문면 삭제 0 = verbatim 보존」(+140)** 이 **구조적 동시 충족 불가**인 채 발행됐다. **①의 통과가 ②의 알리바이가 되지 않는다.**
- **기록 형식 (권장)**: `§N.N 교차 검사 — scope <a>종 × 제외 <b>종 = 충돌 <c> · 경계 항목 = <목록>`. **경계 항목 칸이 핵심**이다 — "충돌 0" 만 남으면 **무엇을 봤는지** 알 수 없고, 검사를 안 한 것과 구분되지 않는다.
- **충돌은 발행 전에 해소한다.** 못 하면 **어느 쪽이 우선인지 paste 에 명시**한다 — **집행자에게 떠넘기지 않는다**(판정을 미루면 실행 시점에 되돌리기가 더 비싸다).
- **★집행자 측 대칭 의무**: 그럼에도 상충을 발견하면 **자동 봉합 금지** — 상충 사실 + 어느 쪽을 왜 우선했는지를 **paste-back 에 보고**한다 (= `reporting.md` §13 negative space 와 같은 층). **조용히 봉합하면 저작 측이 자기 결함을 영영 모른다.**
- 실측 근거 = **3회 연속** (전부 같은 저작자 · **3회 다 cli 개인 판단이 막았다**): ① 요건(*"구 판 = GD 스냅샷 명시"* · 문서 **상단** 배너) ↔ xverify 기준(*"GD 어휘 = 이력 블록에만"* · 문서 **말미**) ② `§3-S10` 대상 `L99` ↔ `§2.3 D3` 「티켓」 zone 보호 ③ ChangeBudget 순감 밴드 ↔ inline 치환 보존. **막아준 게 규칙이 아니라 개인 판단이라 다음 세션이 못 잡는다** — 본 §이 그 판단을 규칙으로 승격시킨다.

### 32) 판 개설 규율 (= 병의 정의는 판이 갖지 않는다)

- **ⓐ 병의 정의는 트랙 / 설계 SoT 가 갖는다** (K-145). 판(cycle)은 그 정의를 **인용할 뿐 새로 쓰지 않는다**. 판마다 병을 다시 정의하면 **판이 통과해도 목표 축이 안 움직인다** — 각 판이 자기가 정의한 자기 병만 고치고 닫히기 때문이다. 판의 §0 은 **정의를 옮기는 자리**이지 만드는 자리가 아니다.
- **ⓑ 부채 census 는 목표 축으로 돌린다** (K-145). **목표 항 → 부채 축 → 단계**가 **전사(全射)** 여야 한다 — **목표에만 있고 부채에 없는 원칙은 집행 단위가 없어 영원히 안 움직인다.** 부채를 「발견된 순서」로만 쌓으면 목표 항 중 아무도 안 본 칸이 조용히 남는다. census 표의 **분모는 목표 항**이고, 빈칸은 「없음」이라 적는다(= 빈칸은 「안 봤다」와 구별 불가).
- **ⓒ 판을 열기 *전* 에 실물 census** (K-144). 계획 문면(설계 SoT · 회부 원장 · 감사 보고)이 실물과 갈리면 **실물이 정본**이고, 그 census 가 **발주 BASELINE 의 첫 줄**이 된다. **병이 없으면 발주를 쓰지 않고 회부를 정정한다.** ★**승인된 판도 취소할 수 있어야 한다** — 승인은 「병이 있다면 고쳐라」이지 **「병이 없어도 코드를 써라」가 아니다**. 취소 절차 = [`working-file-lifecycle.md`](./working-file-lifecycle.md) §9-ⓓ.
- **ⓓ 판정 분모가 「관측 목록」이면 비가역 유실이다** (K-134). 화면에 흘러온 목록 · 대화에 인용된 열거 · 직전 cycle 이 만든 표는 **관측**이지 **존재 전부**가 아니다. **삭제 · 정리 · prune 은 「삭제 경계」에서만** 일어난다 — 관측 목록을 분모로 지우면 **안 본 것이 조용히 사라지고 되돌릴 수 없다** (= [`code-principles.md`](./code-principles.md) §2 「부재는 전수 트리에서만」의 *삭제* 축).
- **ⓔ 감사의 분모 = 대상 문서의 절 전수** (K-146). 감사가 **어느 절을 안 봤는지를 감사 자신이 적는다.** 「전수 검토」라 적고 실제로는 눈에 띈 절만 본 감사는, 안 본 절을 **본 것으로 오도**한다 — 분모를 적었다는 사실이 그 분모가 옳다는 증거가 아니다.
- **ⓕ 착지마다 목표 항 대조표를 재실행한다.** 「판이 통과했다」와 「목표가 움직였다」는 **다른 명제**다. 마감 step 에서 목표 항 × 착지 여부 표를 다시 돌리고, 안 움직인 항은 **그 사실을 적는다**(0 도 값).
- ★**ⓖ 발주는 집행 시작 시점에 동결된다** (K-153). 집행자가 진입한 뒤에는 **발주 문면을 고치지 않는다** — 개선안이 떠올라도 **다음 판으로 간다**.
  - **정본 계약 = 집행자가 진입 시 읽은 판본.** 접수 검증도 **그 판본 기준**이다. 집행자가 못 받은 조항으로 접수를 재면 **접수 자체가 부정**이 된다.
  - ★**저작·개정 전 모드 판정 의무** — 「집행 전 / **집행 중 = 조회만·대기** / 착지 = 접수」. 「**내 문서니까 안전하다**」는 **소유 기준 판단**이고, 실제 기준은 「**그 문서가 지금 누구의 계약인가**」다.
  - **이미 넘어간 발주에 문면을 더했으면 되돌리지 말고 격리**한다 (취소선 + 「본 판 밖」 표기 + 머리 동결 고지 · **삭제 0**).
  - **실측** = 집행자가 T1~T4 를 착지 중(`porcelain 4`)인 것을 모르고 저작 측이 발주서에 3 항을 추가했다. 발견 경로 = **게이트 재실행 시 「전」 값이어야 할 자리가 「후」 값**으로 나왔다.

---

## 변경 정책 + demote 이력

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md). 2026-07-10 · MASTER-CLI-CONTEXT-DIET-2-001 T1 · 본 file diet (49.4K → hot 실행 규약 · 원문 전문 = COLD verbatim snapshot · 정보 소실 0).
> 2026-07-26 · MASTER-CLI-MEASUREMENT-DISCIPLINE-001 · **§31 신설** (= paste 발행 전 **scope × 제외 교차 검사** ①문면×문면 + ②**문면×밴드/수치** 양쪽 의무 + 경계 항목 기록 + 발행 전 해소·못 하면 우선순위 명시 + ★**집행자 측 대칭 의무**[상충 발견 시 자동 봉합 금지 · paste-back 보고]) + **§17 범위 축 pointer 1행**(= BASELINE 4-step 은 **전수 트리 위에서만** 유효 · 본문 SoT = `code-principles.md` §2 「부재는 전수 트리에서만」). 근거 = **3회 연속 상충**(요건↔xverify 기준 · `§3-S10 L99`↔`§2.3 D3` zone · 순감 밴드↔inline 치환 보존) · **3회 다 규칙이 아니라 cli 개인 판단이 막았다** · ②축 실증 = 어느 paste 가 ①을 돌려 "충돌 0" 선언 후에도 밴드 상충이 남았다. §1~§30 **무접촉**.
> 2026-07-26 · MASTER-CLI-RULES-SETTLE-001 · **§30 신설** (= A-6 + A-6′ · ChangeBudget **3층 분리**[실코드 / 주석·KDoc / test] + **분류 기준을 밴드가 직접 말한다**[주석·KDoc·빈 줄 포함 여부 명시 · 정의 없는 밴드는 스스로를 위반한다] + ★**재작성 file 은 라인 밴드에서 빼고 "재작성 N file + 사유"로 별도 보고**[`numstat` 은 **재작성을 재지 변경을 재지 않는다**] + 실측 대응은 초과 아님). 근거 = **5회 연속 초과**(S0 test +181 · S2 KDoc +92 · HARDEN quote-repair · OUTPUT-BUDGET EF+176/test+205 · SETTLE test +248) · **초과분은 매번 paste 자신이 요구한 문서·test** · SETTLE +248 = ViewModel test 2 file 통째 재작성 churn 이며 그 재작성은 **옳은 판단**이었다(상태기계 변경). §1~§29 **무접촉**.
> 2026-07-15 · MASTER-GIT-ROLE-COMMIT-V3-001 · §5 = agent commit 한시 허가 (v2) → **git 역할 경계 정책 (v3)** 재작성 — commit + git log 위생 = cli 소관 default(전 카테고리·영구) · push + 고위험 git(reset/clean/rebase/filter-branch/amend/force/reflog) = Coin 소관. v2 카테고리 나열 · `[agent-commit: yes]` 묵시 신호 폐지. 4개 층(§5 · `safety-and-secrets.md` deny 표 · `COMMIT_CONVENTION.md` §2 · `settings.json` deny) 문언 모순 일괄 정합.
