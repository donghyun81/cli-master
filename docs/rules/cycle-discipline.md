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

### 13) Claude Code 환경 정합 (latest-chase · 요약 — 서사/복귀 명령 원문 = COLD)

- **버전 정책 = 최신 추격 (latest-chase · pin 폐기)**: npm scope `@anthropic-ai/claude-code` 의무 · `DISABLE_AUTOUPDATER=1` + `DISABLE_UPDATES=1` 이중 차단 유지 (해제 금지 · `~/.zshrc` + `~/.claude/settings.json` env 양쪽) · 능동 갱신 = 사용자 직접 `npm install -g @anthropic-ai/claude-code@latest` (주 1회 권장).
- **매 cycle 진입 self-test 3 항목 (모두 PASS 의무)**: ① `claude --version` ② `claude mcp list` 안 `pencil ✓ Connected` ③ ToolSearch pencil **9종 named-set 전수** (= batch_design / batch_get / export_nodes / get_editor_state / get_guidelines / get_screenshot / get_variables / set_variables / snapshot_layout · 단순 ≥N 카운트 X). 기록 = **판정 + 핵심 수치 + 원문 pointer** (raw verbatim 박제 X · T3 · `reporting.md` §8).
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

### 16) cli 수정 우선순위 결정 트리

cli infra 수정 필요? — YES: 자식 안 사고 발견 = 패턴 1 · local override 만 = 패턴 2 · 도메인 활성화 trigger = 패턴 3 / NO: 자식 본 작업 cycle 진행. (원문 diagram = COLD)

### 17) BASELINE 실측 표준 (filename + content 동시 grep 의무)

1. filename find 1차 → 2. **container 내부 content grep 2차 의무** (= filename 부재 시점 즉시 STOP/UNKNOWN 분류 금지 · symbol/object/function content keyword grep) → 3. lifecycle/deprecated 키워드 grep (ui-spec.json / SoT 실측 시 의무) → 4. filename + content **둘 다 부재 시점에만** STOP/UNKNOWN 분류 가능. (근거 사고 원문 = COLD)

### 18) cli infra 분기 정기 review cadence (요약 — scope 표 = COLD)

매 quarter 첫 월요일 KST (1/6·4/6·7/6·10/6 부근) — rules outdated + hooks self-test + settings 정합 + 보호 baseline + incident 추세 + `context-health-metrics.md` 재측정. 산출 = lightweight 4 file. 자동 발화 X (사용자 인지 단일).

### 19) Hooks self-improving loop (요약 — 상세 = COLD)

`stop-reflect.sh` (Stop hook · stop-gate 와 분리) = REVIEW/EVIDENCE 안 paradigm 누적 패턴 grep (한 file 3+ 회 임계) → silent stderr 후보 제안 · exit 0 non-blocking · 채택 = 사용자 자율 (자동 file 신설 X).

### 20) DocSync 단계 본문

cycle 마감 시 갱신 대상 3 영역: ① task 산출물 (`.ai/reports/<taskId>/*.md`) ② 운영 레이어 (`docs/agent/**`) ③ **자식 출시 docs** (= `docs/release-readiness/INITIATIVES.md` + `docs/CLAUDE.md` 또는 자식 root `CLAUDE.md` + `docs/setup/*`). 본 cycle 영향 영역 발견 시 갱신 의무 · 무영향 = 0 갱신 (빈 commit 금지) · 진입 = `docs-change-communicator` agent. 사용자 manual 갱신 영역 폐기 (= 자동/반자동 우선).

### 21) Cross-repo cycle 영역 (= 6-repo)

- **21.1 영역 분리**: cli infra 6-repo byte-identical 영역 = §15 패턴 1 · 자식 도메인 specific = §15 패턴 2 (본 § 영역 X) · cross-repo 정합 검증 = 패턴 1 + 영역 1 sub-agent fan-out.
- **21.2 paradigm 분기** 단일 SoT = `cross-repo-parallel-exec.md` (= 영역 1 sub-agent fan-out / 영역 2 다중 cli session · 선택 = cli session 자율).
- **21.3 운영 표준 7 step**: ① master 변경+commit → ② `bash scripts/propagate.sh <path> [--targets all]` → ③ 자식별 staged commit (master commit body 인용) → ④ `bash scripts/verify-sync.sh` exit 0 → ⑤ `propagation-reports/<cycle-id>/REPORT.md` 생성 → ⑥ master audit commit (`.auto-memory/propagation-status.md` 갱신) → ⑦ master `CLAUDE.md` §15 entry append.
- **21.4 STOP** = master [`CLAUDE.md §5`](../../CLAUDE.md) (9항 canonical · pointer).
- **21.5 산출물** = master `.ai/reports/<cycle-id>/` {PLAN,EVIDENCE,VERIFY,REVIEW,TODO} (= lightweight 가능 · §11 정합).
- **21.6 정합** = `cross-repo-parallel-exec.md` + `cross-repo-orchestrator.md` + `routing-and-delegation.md` §실행 방식 + 부모 mount root `CLAUDE.md` §3.

### 22) git mv + sed 측 stage 정합 (요약 — 사고 본질/step 표 = COLD)

rename + content 변경 동시 cycle = **post-rename `git add -u` 의무** → `git diff --cached --name-only` stage 전수 확인 + `git status` unstaged 0 확인 → commit 진입. 확장/이동 cycle 마감 = 구명·구경로 dual grep sweep 보고 의무 (A7 정합). hook = `pre-commit-stage-check.sh` (warn · non-blocking). STOP = master `CLAUDE.md` §5 #8.

### 23) ~ 29) paradigm thin pointers (본문 복제 0)

- **23** Recommended option disk verification = [`disk-verification` skill](../../.claude/skills/disk-verification/SKILL.md) (경유 `recommended-option-disk-verification.md` · §17 실측 표준 흡수)
- **24** Runtime crash mitigation = [`runtime-crash-mitigation` skill](../../.claude/skills/runtime-crash-mitigation/SKILL.md) (9-step · staging 한정)
- **25** INITIATIVES + INDEX + task file auto-sync = [`initiatives-sync` skill](../../.claude/skills/initiatives-sync/SKILL.md) (5 의무 영역 = skill §3 · ④ KR gate + ⑤ always-fresh)
- **26** Paste source authoring disk 실측 = [`paste-source-authoring` skill](../../.claude/skills/paste-source-authoring/SKILL.md)
- **27** Anchor list = [`anchor-list.md`](../../.claude/rules/anchor-list.md) (10 anchor hot · negative space line = `reporting.md` §13)
- **28** Automation policy = [`automation-policy.md`](./automation-policy.md) (Transport 자동화 OK / Inspection 자동화 X)
- **29** Mode 시스템 = [`mode-system.md`](./mode-system.md) (M1/M3/M5 bundle + picker + recovery)

---

## 변경 정책 + demote 이력

> 변경 정책 = [`rule-footer-common.md`](../../.claude/rules/rule-footer-common.md). 2026-07-10 · MASTER-CLI-CONTEXT-DIET-2-001 T1 · 본 file diet (49.4K → hot 실행 규약 · 원문 전문 = COLD verbatim snapshot · 정보 소실 0).
> 2026-07-15 · MASTER-GIT-ROLE-COMMIT-V3-001 · §5 = agent commit 한시 허가 (v2) → **git 역할 경계 정책 (v3)** 재작성 — commit + git log 위생 = cli 소관 default(전 카테고리·영구) · push + 고위험 git(reset/clean/rebase/filter-branch/amend/force/reflog) = Coin 소관. v2 카테고리 나열 · `[agent-commit: yes]` 묵시 신호 폐지. 4개 층(§5 · `safety-and-secrets.md` deny 표 · `COMMIT_CONVENTION.md` §2 · `settings.json` deny) 문언 모순 일괄 정합.
