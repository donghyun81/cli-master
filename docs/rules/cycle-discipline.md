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
- ★**밴드 산정 자 — 밴드는 자기가 시킨 것을 세야 한다** (= 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-003` · ㉡ #200-⑸). 위 「실측 대응은 초과가 아니다」가 **사후 면책**이라면, 본 항은 **사전 계상**이다. 면책만 있으면 밴드는 **매번 틀리고 매번 용서받는다** — 그건 밴드가 아니라 **장식**이다.
  - **실증** = 판 B(`MASTER-DOC-MANIFEST-SWEEP-002`) 문서 축 실측 **`+115`** vs 계약 **`+45~+85`** ⟹ 초과 **`+30`**. ★**초과분의 정체 = 그 발주 §9 가 요구한 답변표 + 실측표**다. **발주가 시킨 산출을 발주의 밴드가 안 세었다.**
  - ★**처방** ⑴ **§9 답변 · 실측표 · 재현표의 예상 행수를 별 항으로 계상**한다 (= 본문 축과 **합산하지 않고 따로** 적는다 · 3층 분리와 같은 이유). ⑵ **실측 후 REPORT 가 밴드를 정정**한다. ⑶ ★**정정했다는 사실 자체를 적는다** — **정정 없는 초과는 편차이고, 정정한 초과는 산출**이다. 둘을 구별하지 않으면 「초과」 계수가 **밴드 결함과 옳은 판단을 한 칸에 섞는다**.
  - ⑷ ★**밴드를 게이트 항으로 잰다** (= 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-004` · ㉡ #200-⑸ · **게이트화이지 신설 아님** — 위 「밴드 산정 자」와 처방 ⑴~⑶ 은 **이미 있었다**). 발주 §6 게이트 블록에 **밴드 G** 를 두고 「**전 = 0 / 후 = 층별 실측**」으로 계약한다. ⟹ **진단이 「규칙 부재」가 아니라 「자 부재」일 때 처방은 신설이 아니라 게이트화**다.
    - **실증 (= 3 판 연속 · 규칙이 있는 채로)**: `MASTER-DOC-MANIFEST-SWEEP-002` 문서 축 실측 **`+115`** vs 계약 **`+45~+85`** · `MASTER-DOC-MANIFEST-SWEEP-003` 이 ★**이 절을 신설하면서 이 절을 어겼다**(= §9 산출 축을 **재지 않고 `+318`** 기재 · `wc -l` 실측 **`+366`** · 오차 **+48**). ★**규칙만 있고 자가 없으면 규칙은 장식이 된다** — 면책 조항이 아니라 **게이트 항**이 밴드를 살린다.
  - **밴드 산정 자** — 자 = 층별 `git show --numstat <sha> -- <path>` 합(순증) × 계약 밴드 구간 대조 · 별 항(§9 산출)은 **자기 밴드로 따로** 잰다. ★**층을 합쳐 재면 어느 층이 틀렸는지 영영 모른다**(= 위 3층 분리 의무의 계측 판).

### 31) paste 발행 전 scope × 제외 교차 검사 (= 상충은 문면끼리만 나지 않는다)

- **발행 전 교차 검사 의무**: paste 저작 **마지막 step** 에서 ① **scope/변경 표 전 항** × **제외·STOP 좌표** = 교집합 0 인가 ② **scope 표 전 항** × **ChangeBudget 밴드 · 수치 조건 · xverify 기준** = **동시 충족 가능**한가 — **둘 다** 대조하고 **결과를 paste 본문에 기록**한다.
- **★①만 돌리면 안 잡힌다**: 상충은 **문면 ↔ 문면** 뿐 아니라 **문면 ↔ 밴드/수치** 사이에서도 난다. 실측 = 어느 paste 가 ①을 실제로 돌려 **"충돌 0"** 을 선언하고도, 같은 문서 안에서 **「순감 −120~−40」 밴드 ↔ 「구 문면 삭제 0 = verbatim 보존」(+140)** 이 **구조적 동시 충족 불가**인 채 발행됐다. **①의 통과가 ②의 알리바이가 되지 않는다.**
- **기록 형식 (권장)**: `§N.N 교차 검사 — scope <a>종 × 제외 <b>종 = 충돌 <c> · 경계 항목 = <목록>`. **경계 항목 칸이 핵심**이다 — "충돌 0" 만 남으면 **무엇을 봤는지** 알 수 없고, 검사를 안 한 것과 구분되지 않는다.
- **충돌은 발행 전에 해소한다.** 못 하면 **어느 쪽이 우선인지 paste 에 명시**한다 — **집행자에게 떠넘기지 않는다**(판정을 미루면 실행 시점에 되돌리기가 더 비싸다).
- **★집행자 측 대칭 의무**: 그럼에도 상충을 발견하면 **자동 봉합 금지** — 상충 사실 + 어느 쪽을 왜 우선했는지를 **paste-back 에 보고**한다 (= `reporting.md` §13 negative space 와 같은 층). **조용히 봉합하면 저작 측이 자기 결함을 영영 모른다.**
- 실측 근거 = **3회 연속** (전부 같은 저작자 · **3회 다 cli 개인 판단이 막았다**): ① 요건(*"구 판 = GD 스냅샷 명시"* · 문서 **상단** 배너) ↔ xverify 기준(*"GD 어휘 = 이력 블록에만"* · 문서 **말미**) ② `§3-S10` 대상 `L99` ↔ `§2.3 D3` 「티켓」 zone 보호 ③ ChangeBudget 순감 밴드 ↔ inline 치환 보존. **막아준 게 규칙이 아니라 개인 판단이라 다음 세션이 못 잡는다** — 본 §이 그 판단을 규칙으로 승격시킨다.
- ★**⑥ STOP × 계약의 착지 경로** (= 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-003` · ㉣ **K-168** 신설). 위 ①은 **scope 좌표 × STOP 좌표의 직접 교집합**을 본다. 본 항은 **그 한 걸음 downstream** 을 본다 — ★**계약이 「닿는 곳」은 계약이 「적힌 곳」보다 넓다.**
  - **실증** = 판 B(`MASTER-DOC-MANIFEST-SWEEP-002`)의 scope(= 이력 등재)와 S1(= COLD 표 불가침)은 ★**직접 겹치지 않았다** — ①을 돌리면 **교집합 0** 이 나오고 실제로 그렇게 발행됐다. 겹친 것은 **경로**다: 「`CLAUDE.md §15` 등재」 → **hot 상한 3 만석** → **demote 동반** → **COLD 표 접촉** → **S1 발동**. ⟹ 판 B 는 **자기 STOP 에 막혀 자기 의무를 못 지켰고**, 「만든 부채 1」로 적고 닫았다. ★**①은 그것을 구조적으로 못 본다.**
  - ★**처방** = 각 T 에 대해 「이 계약이 **닿게 되는 file · 절**」을 **1 단계 더** 적고, 그 집합을 STOP 좌표와 대조한다. 겹치면 둘 중 하나다 — ⑴ ★**STOP 을 좁힌다**(= **내용만 잠그고 경로는 연다**) ⑵ **T 를 회부로 내린다**. **그대로 발행하면 집행자가 반드시 막힌다.**
  - ★**「STOP 을 좁힌다」의 실물** = 본 판 S1 = 「COLD **기존 165 데이터행의 내용** 변경 = STOP · **말미 append 는 계약**」. 판 B S1(= 「COLD 표 불가침」)과 **보호 대상은 같고 경로만 다르다** — 구 문면 보존이라는 목적은 그대로 지키면서 등재 의무의 착지를 **허용**한다. ⟹ ★**STOP 은 「무엇을 지키나」로 쓰지 「어디를 못 만지나」로 쓰지 않는다** (= 후자는 목적을 넘어 경로까지 잠근다).
  - **기록 형식** = ①의 형식에 **닿는 곳** 칸을 더한다: `T<n> | 계약 | 닿게 되는 것(1 단계 더) | STOP 충돌`. ★**빈칸 금지** — 「닿는 곳 없음」도 값이다(= 안 봤다와 구별 불가).

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

### 33) 지시·판단의 원장 추적 (= 부재를 부재로 남기지 않는다)

- ★**ⓐ Coin 문면은 원장에 채번되고 「집행을 재는 자」를 갖는다.** Coin 의 **방향 · 결정 · 선택안**이 나오면 ⑴ 원장에 **채번**(`#NN`) ⑵ 같은 행에 **집행 여부를 재는 자 1 개** 병기 ⑶ ★자를 못 만들면 「**자 부재**」라고 **적는다**. ★**부재를 부재로 남기지 않는 것이 본 항의 전부**다 — 지금은 지시가 어느 판에서 빠지면 **조용히 사라지고**, 사라진 자리가 **다음 판의 분모에서도 빠진다**.
  - **실측** (2026-08-30 · 단위 = 행) = 자 `grep -cE 'Coin (확정|확인|선언)' <설계 SoT>` = **10** · 그 중 같은 행에 자(`자 =` / `grep` / `awk`)를 가진 것 = **0**. ★**양성 대조** = 같은 문서 `자 =` **6** · `grep ` **17** ⟹ **자는 생존해 있고 교집합만 0** 이다 (= 자를 쓸 줄 몰라서가 아니라 **지시에는 안 붙였다**).
  - ★**이 명제는 자에 따라 움직인다**: 자를 넓히면(`grep -c 'Coin 확정\|확인\|선언'` = **20 행** · `Coin` 이 첫 어에만 걸리는 BRE 교대) 교집합이 **1** 이 된다. ⟹ **자를 문면에 박아 두고 그 자로만 재현한다** (= [`verification-and-review.md`](./verification-and-review.md) §0.6 명제 ↔ 게이트 대응).
- ★**ⓑ REPORT 의 「판단」은 원장으로 승격한다.** REPORT 본문에서 내린 **판단 · 선택**(= 발주가 안 물었는데 집행자가 정한 것)은 **원장 번호를 받거나** 「**원장 불요 + 근거**」를 적는다. **REPORT 안에서만 사는 판단 금지** — REPORT 는 한 번 읽히고 **원장은 다음 판의 분모**가 된다.
- ★**ⓒ 낱말 분리 — 「원장 회부」 ≠ 「Coin 이관」.** 「**원장 회부**」 = 원장 채번(추적 대상으로 올림) · 「**Coin 이관**」 = push · 배포 · 승인 등 **소관 이동**(= §5 git 역할 경계). 실측 = 한 낱말이 두 뜻으로 쓰여 계수가 **9 → 실제 1** 로 부풀었다(단위 = hit). **한 낱말이 두 축을 겸하면 그 축은 둘 다 못 잰다.**
- **보고 형식** = [`reporting.md`](./reporting.md) §15.1 축 **13**(판단·선택 → 원장) + 축 **9**(회부). 본 §이 **규율 본문 SoT** 이고 그쪽은 **REPORT 서식**만 소유한다 (= 재복제 0).

---

## 변경 정책 + demote 이력

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md). 2026-07-10 · MASTER-CLI-CONTEXT-DIET-2-001 T1 · 본 file diet (49.4K → hot 실행 규약 · 원문 전문 = COLD verbatim snapshot · 정보 소실 0).
> 2026-08-30 · MASTER-MEASURE-DISCIPLINE-001 · **§33 신설** (= 지시·판단의 원장 추적 · ⓐ Coin 문면 채번 + 「집행을 재는 자」 병기 + ★**자를 못 만들면 「자 부재」라 적는다**[부재를 부재로 남기지 않는다] · ⓑ REPORT 의 판단 = 원장 승격 또는 「원장 불요 + 근거」 · ⓒ 낱말 분리 「원장 회부」 ≠ 「Coin 이관」[한 낱말이 두 축을 겸하면 둘 다 못 잰다 · 계수 9 → 실제 1] · 보고 형식 = `reporting.md` §15.1 축 13 + 축 9 pointer). 근거(실측 2026-08-30 · 단위 = 행) = 설계 SoT 의 `grep -cE 'Coin (확정|확인|선언)'` **10** 중 같은 행에 자 보유 **0** · 양성 대조 `자 =` **6** · `grep ` **17** ⟹ 자 생존 · **교집합만 0**. ★자를 넓히면(BRE 교대 **20 행**) 교집합이 **1** 이 되어 **명제가 자에 따라 움직인다** — 그래서 자를 문면에 박았다. §1~§32 **무접촉**. ★**본 entry 는 `rule-footer-common.md` 「이력 절 등재 의무」의 첫 이행**이다 — 직전 절 신설(§32 · `1c30a84` `MASTER-ENGINEERING-BASELINE-001`)은 footer entry **미동반**이었다(= 그 의무가 관례였음을 보이는 실측).
> 2026-07-26 · MASTER-CLI-MEASUREMENT-DISCIPLINE-001 · **§31 신설** (= paste 발행 전 **scope × 제외 교차 검사** ①문면×문면 + ②**문면×밴드/수치** 양쪽 의무 + 경계 항목 기록 + 발행 전 해소·못 하면 우선순위 명시 + ★**집행자 측 대칭 의무**[상충 발견 시 자동 봉합 금지 · paste-back 보고]) + **§17 범위 축 pointer 1행**(= BASELINE 4-step 은 **전수 트리 위에서만** 유효 · 본문 SoT = `code-principles.md` §2 「부재는 전수 트리에서만」). 근거 = **3회 연속 상충**(요건↔xverify 기준 · `§3-S10 L99`↔`§2.3 D3` zone · 순감 밴드↔inline 치환 보존) · **3회 다 규칙이 아니라 cli 개인 판단이 막았다** · ②축 실증 = 어느 paste 가 ①을 돌려 "충돌 0" 선언 후에도 밴드 상충이 남았다. §1~§30 **무접촉**.
> 2026-07-26 · MASTER-CLI-RULES-SETTLE-001 · **§30 신설** (= A-6 + A-6′ · ChangeBudget **3층 분리**[실코드 / 주석·KDoc / test] + **분류 기준을 밴드가 직접 말한다**[주석·KDoc·빈 줄 포함 여부 명시 · 정의 없는 밴드는 스스로를 위반한다] + ★**재작성 file 은 라인 밴드에서 빼고 "재작성 N file + 사유"로 별도 보고**[`numstat` 은 **재작성을 재지 변경을 재지 않는다**] + 실측 대응은 초과 아님). 근거 = **5회 연속 초과**(S0 test +181 · S2 KDoc +92 · HARDEN quote-repair · OUTPUT-BUDGET EF+176/test+205 · SETTLE test +248) · **초과분은 매번 paste 자신이 요구한 문서·test** · SETTLE +248 = ViewModel test 2 file 통째 재작성 churn 이며 그 재작성은 **옳은 판단**이었다(상태기계 변경). §1~§29 **무접촉**.
> 2026-07-15 · MASTER-GIT-ROLE-COMMIT-V3-001 · §5 = agent commit 한시 허가 (v2) → **git 역할 경계 정책 (v3)** 재작성 — commit + git log 위생 = cli 소관 default(전 카테고리·영구) · push + 고위험 git(reset/clean/rebase/filter-branch/amend/force/reflog) = Coin 소관. v2 카테고리 나열 · `[agent-commit: yes]` 묵시 신호 폐지. 4개 층(§5 · `safety-and-secrets.md` deny 표 · `COMMIT_CONVENTION.md` §2 · `settings.json` deny) 문언 모순 일괄 정합.

---

## 명시 cycle 이력

> ★**본 절 신설 = 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-003`** (= `rule-footer-common.md` 「이력 절 등재 의무」의 절 이름 정합). **위 `## 변경 정책 + demote 이력` 4 entry 는 흡수하지 않는다** — **구 문면 그대로 병존**(= 삭제 0 · 이관 0). 이유 ⑴ 그 절은 **「변경 정책 pointer + diet demote 이력」** 이라는 **다른 축**을 겸하고 있어 옮기면 그 축이 사라진다 ⑵ ★**소급 이관은 「그 판이 그때 적었다」를 사후에 위조한다** — 이력은 **적힌 자리가 곧 그 판의 행위**다. ⟹ **본 절은 신설 시점(= 본 판)부터 앞으로만 쌓는다.**
> **소급 경계** = **본 판부터**. 그 앞(= §30·§31·§33 신설 등)은 위 병존 절에 **이미 적혀 있고**, 미기재분(= §32 신설 `1c30a84`)은 **회부**(= 별 판 · `MASTER-MEASURE-DISCIPLINE-001` 이 이미 그 미동반을 실측으로 남겼다).

- 2026-08-30 · `MASTER-DOC-MANIFEST-SWEEP-003` · **§31 교차 검사 ⑥ 축 신설** (= ㉣ **K-168** · **STOP × 계약의 착지 경로** · ★**계약이 「닿는 곳」은 계약이 「적힌 곳」보다 넓다** · 기존 ①은 scope × STOP **직접 교집합**만 본다 · 실증 = 판 B `MASTER-DOC-MANIFEST-SWEEP-002` 의 scope[이력 등재] ↔ S1[COLD 표 불가침]이 **직접으로는 안 겹쳐 ①이 「교집합 0」을 냈고** 그대로 발행됐으나, 경로 「§15 등재 → hot 만석 → demote 동반 → COLD 표 → S1」에서 막혀 **자기 의무를 못 지키고 「만든 부채 1」로 닫았다** · 처방 = 각 T 의 **1 단계 downstream** 을 적고 STOP 좌표와 대조 → 겹치면 **STOP 을 좁히거나**[내용만 잠그고 경로는 연다] **T 를 회부** · ★**STOP 은 「무엇을 지키나」로 쓰지 「어디를 못 만지나」로 쓰지 않는다** · 기록 형식에 **닿는 곳 칸** 추가 · 빈칸 금지) + **§30 밴드 산정 자 신설** (= ㉡ #200-⑸ · 기존 「실측 대응은 초과가 아니다」가 **사후 면책**이라면 본 항은 **사전 계상** · ★**면책만 있으면 밴드는 매번 틀리고 매번 용서받는다 = 장식** · 실증 = 판 B 문서 축 `+115` vs 계약 `+45~+85` ⟹ 초과 `+30` 이고 **그 초과분이 곧 그 발주 §9 가 요구한 답변·실측표** = **발주가 시킨 산출을 발주의 밴드가 안 세었다** · 처방 = §9 산출 **별 항 계상**[본문과 합산 X] + REPORT 가 밴드 **정정** + ★**정정 사실 자체를 적는다**[정정 없는 초과 = 편차 · 정정한 초과 = 산출]) + **본 절 신설**(= 위 병존 규약). 자 = 본 판 게이트 G5(`0 8` → `1 13`) · G6(`0 7` → `1 11`) · G7 첫 칸 `2 → 3` (= **실측값** · 초안은 G6 를 `2 11` 로 **예측해 적었다가 실측 `1 11` 로 정정** — ★**예측값을 실측 자리에 적는 것이 이 트랙이 고치는 병이다**). §1~§29 · §32 · §33 **무접촉**.
- 2026-08-30 · `MASTER-DOC-MANIFEST-SWEEP-004` · **### 30) 처방 ⑷ 「밴드를 게이트 항으로」 부착** (= ㉡ #200-⑸ · **게이트화이지 신설 아님** — 직전 판이 신설한 「밴드 산정 자」 + 처방 ⑴~⑶ 이 이미 있었다). 내용 = 발주 §6 에 **밴드 G**(전 = 0 / 후 = 층별 실측)를 두는 의무. 근거(실측) = ★**직전 판이 이 절을 신설하면서 이 절을 어겼다** — §9 산출 축을 재지 않고 `+318` 기재 · `wc -l` 실측 `+366`(오차 **+48**) · 그 전 판은 `+115` vs 계약 `+45~+85` ⟹ **규칙이 있는데 3 판 연속 안 지켜졌다** = 진단은 **규칙 부재가 아니라 자 부재**. ★**본 판은 자기 적용을 미루지 않았다** — 발주 §1-T4 는 「명문화만 · 게이트화는 다음 판」으로 경계를 그었으나, 그 유예 자체가 이 절이 고치려는 패턴(= 규칙만 두고 자를 안 돎)의 재현이라 **본 판 REPORT 가 층별 밴드를 실측·정정해 자기 적용**했다(= 발주 §9-⑤ 가 연 재량 · 그 사실을 REPORT ⑽ 에 적는다). §1~§29 · §31~§33 **무접촉**.
