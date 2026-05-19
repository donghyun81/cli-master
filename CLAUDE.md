# Gently Master — Claude Code 운영 SoT (Single Source of Truth)

> **용어 사전 (terminology · 2026-05-04 · `MASTER-CLI-TERMINOLOGY-DEFINE-001`)** —
> 본 지침 / 메모리 / 규약 / 자식 repo 안 'CLI / cli' 표현 정의:
>
> - **CLI / Claude Code CLI** = Anthropic 의 코딩 agent CLI 도구 (`claude` 명령). 본 패키지의 운영 CLI 는 Claude Code 단일.
> - **cli infra** = Claude Code 가 읽는 `.claude/` 디렉터리 전체 (rules / agents / hooks / commands / skills / settings).
> - **CLI 환경 / 세션 / 측** = Claude Code 실행 환경 / 세션 / 주체 (Cowork / Coin 측과 대비되는 자동 처리 주체).
> - **`*-CLI-NNN` task ID** (예: `GB-CLI-001`, `SW-CLI-DOCOPS-001`) = cli infra 도메인 task.
> - **Cowork ↔ CLI 동기화** = Cowork chat (Coin 측) ↔ Claude Code (자동 처리) 사이 baseline / handoff 정합.
>
> **구분**: 일반 macOS 터미널 / shell script / bash 명령은 'shell' 또는 'bash' 로 표기 (cli 와 구분 의무).
> **신규 cli 표현 추가 시**: 본 정의 그대로 적용 (별도 cycle 불필요).
> **그 외 일반 어휘** (SoT/SSOT 등): `.claude/rules/terminology.md` 참조.

---

> **이 repo 는 cli infra + 보호 파일의 단일 source-of-truth.**
> 자식 repo (GentlyBreath / GentlyDay / GentlyTable / 향후 추가) 는 본 repo 에서 단방향 propagation 을 받는다.
> 시간대: Asia/Seoul (KST) · 운영 CLI: Claude Code 단일.

---

## 0. master repo 의 책임 (3 개)

> **이 repo = generic cli infra master · 도메인 코드 hub 아님.**
> 현재 Gently 패키지 (3 자식 repo: GB/GD/GT) 한정으로 운영되나, `scripts/` + `.claude/` cli infra + `docs/agent/`·`docs/schemas/`·`docs/templates/` 는 도메인 무관 = 다른 앱 패키지 (예: SteadyWell · 향후 신규) 로 확장 가능.
> 자칭 = `claude-cli-master` (`.auto-memory/decision-log.md` / `.auto-memory/protected-file-hashes.md` / `.auto-memory/child-claude-md-header.template.md` 일치). 폴더 이름 = 본 의도 명시.

1. **cli infra SoT 보유** — `.claude/` (agents/commands/hooks/rules/skills/settings) + `docs/schemas/` + `docs/design/pencil-sot-policy.md` 의 정합 source.
2. **propagation 도구 제공** — `scripts/propagate.sh` / `scripts/verify-sync.sh` / `scripts/activate-agent.sh` / `scripts/report-gen.sh` (C3 에서 신설).
3. **propagation 결과 보고** — `propagation-reports/<cycle-id>/REPORT.md` 누적.

자식 repo 는 위 3 개에 의존만 함. 자식 repo 가 cli infra 직접 수정 금지 (단방향 정합 강제).

---

## 1. 자식 repo 등록 (placeholder · 변경 가능)

| 자식 repo | 도메인 | 패키지 | 절대 경로 (placeholder) |
|---|---|---|---|
| GentlyBreath (GB) | 호흡 | `com.example.gentlybreath` | `<PARENT>/GentlyBreath` |
| GentlyDay (GD) | 일상 | `com.example.gentlyday` | `<PARENT>/GentlyDay` |
| GentlyTable (GT) | 식단 | `com.example.gentlytable` | `<PARENT>/GentlyTable` |

`<PARENT>` 는 환경별 변수 (예: `~/AndroidStudioProjects` · `$ANDROID_PROJECTS_ROOT`). `scripts/propagate.sh` 가 자동 해결.

신규 자식 repo 추가는 본 표에 행 추가 + 첫 propagation cycle 진입.

---

## 2. 정합 강제 3 등급 (`cycle-discipline.md` §3 명시됨)

| 등급 | 대상 | 강제 수준 | drift 발생 시 |
|---|---|---|---|
| **보호 파일 (강제)** | 5 종 — `docs/schemas/ui-spec.schema.json` · `.claude/rules/pencil-uiux-workflow.md` · `docs/design/pencil-sot-policy.md` · `.claude/rules/uiux-sot-refresh.md` · `docs/design/design-sot-policy.md` | master ↔ 자식 byte-identical 의무 | 즉시 mitigation cycle (리뷰 블로커) |
| **cli infra (권장)** | 53 + α — `.claude/` 전체 + `.claude/settings.json` 등 | 권장 byte-identical | lazy 가능 · 다음 cycle 영향 시 mitigation |
| **repo-specific (자유)** | 도메인 코드 / 화면 / `app/` / `<repo>/CLAUDE.md` 본문 도메인 섹션 / `settings.local.json` | 정합 강제 X | 자연 발생 |

---

## 3. propagation 표준 흐름 (단방향 master → 자식)

```
1. master 에서 cli infra 또는 보호 파일 변경 + commit
2. bash scripts/propagate.sh <relative-path> [--targets GB,GD,GT]   # C3 에서 신설
3. 각 자식 repo 에서 staged commit (master commit body 인용)
4. bash scripts/verify-sync.sh   # cross-verify · sha 비교
5. propagation-reports/<cycle-id>/REPORT.md 자동 생성 (report-gen.sh)
6. master 에 audit commit (propagation-status.md 갱신)
```

자식 repo 에서 cli infra 변경 시도 → STOP + master 신설 cycle 권장.

---

## 4. 절대 금지 (3-repo 공통)

- 명령어 차단: `settings.json` deny list 참조 (`curl` `wget` `sudo` `git push` `git reset` `git clean` `*tmp*` `rm -rf /...`)
- 경로: `/tmp` · `$TMPDIR` 계열
- 데이터: 시크릿 / 토큰 / 키 / PII 값을 파일에 기록 (변수명 / 주입 경로만 허용)
- 네트워크: 웹 조회 / 다운로드 (레포 내 근거만 사용)
- **자식 repo 의 cli infra 직접 수정** (단방향 정합 위반)

---

## 5. STOP 조건 (즉시 중단 + 자동 수정/되돌리기 금지)

1. DB migration 또는 Money / Auth 영향 경로 발견
2. 요구사항 범위가 계획보다 확장됨 (scope expansion)
3. 비가역 변경 징후 (파일 삭제, 스키마 변경, override)
4. 예상 외 시스템 상태 발견
5. **자식 repo cli infra drift 감지** (master 와 sha 불일치)

`BLOCKED` 종료는 권한 / 환경 이슈에만 사용.

---

## 6. 표준 워크플로

```
prompt receive → intake normalization → /collect → /plan → implement → /verify → /review → DONE 또는 replan
```

Plan Mode (Shift+Tab 두 번) 에서 intake normalization + pre-EVIDENCE 계약 먼저 고정 후 구현 모드 전환.

세부 단계 정의: `.claude/rules/workflow-core.md` + `cycle-discipline.md` + `pencil-automation.md`.

---

## 7. 진입 커맨드 라우팅

| 작업 유형 | 시작 커맨드 | 언제 사용 |
|---|---|---|
| 제품 코드 구현 / 수정 | `/fulfill-requirement <한 줄>` | 새 기능 / 버그 / 리팩터 / UI 변경 (자식 repo 안에서) |
| 문서 거버넌스 | `/fulfill-doc-governance` | docs/** 정책 / 참조 경로 감사 |
| 운영 레이어 변경 | 커맨드 없이 직접 프롬프트 | hook / rule / agent / skill / command 자체 추가 / 수정 (master 에서) |
| 빠른 검증 일괄 | `/verify-all <taskId>` | architecture + test + compound-lint |
| 리뷰 단독 | `/review-task <taskId>` | REVIEW.md 만 재생성 |
| 레이어 위반 점검 | `/check-layer` | shared/domain ↔ app 경계 |
| 계획만 먼저 | `/plan-first` | EVIDENCE → PLAN 까지만 |
| 조사형 | `/survey <주제>` | UNKNOWN 정리 / 외부 의존 파악 |
| 멈춘 task 재개 | `/resume-task <taskId>` | STOP / BLOCKED 재개 |
| UI/UX SoT refresh | `/uiux-refresh <FULL\|PARTIAL\|DOC-ONLY>` | `.ai/uiux-sot/latest/` 갱신 |
| **propagation cycle** | `/cycle-report propagate <file>` | C3 에서 신설 — master 변경 후 자식 propagation 자동 |

### 라우팅 판정 우선순위

1. **master cli infra 변경?** → master 에서 직접 프롬프트 + propagation 의무
2. **자식 repo 의 cli infra drift 감지?** → STOP + master 정정 cycle
3. **운영 레이어 변경 (자식 repo 의 `.ai/`)?** → 자식 repo 에서 직접 프롬프트
4. **docs 거버넌스 핵심?** → `/fulfill-doc-governance`
5. **그 외 제품 코드?** → `/fulfill-requirement`
6. **검증 / 리뷰 단독?** → `/verify-all` 또는 `/review-task`
7. **조사만?** → `/survey`
8. **재개?** → `/resume-task`
9. **UI/UX baseline?** → `/uiux-refresh`

---

## 8. Repo-First Intake (3-repo 공통)

Claude Code 는 자동 완성형 AI 가 아니라 **repo-first 해석 보조형 AI**.
프롬프트 수신 직후 아래 고정:

- 작업 유형 + reading mode
- 요구사항 출처 충족 여부
- 정보 공백 분류: `RESOLVABLE_IN_REPO` / `UNKNOWN` / `BLOCKED`
- STOP 위험
- 필수 reading order
- 필요한 read-only 전문가
- implementer 진입 가능 여부

| 단계 | 규칙 |
|---|---|
| intake normalization | pre-EVIDENCE 계약을 먼저 고정. implementer direct entry 금지. |
| /collect | 제품 변경 금지. 검색 / 수집만. 0 matches 도 기록. build / .gradle / generated 제외. |
| /plan | ChangeBudget 표 필수. 경미한 불일치 → PLAN 갱신. 리스크 상승 → STOP. |
| implement | 최소 변경 원칙. SoftBudget: `.claude/rules/workflow-core.md` + `cycle-discipline.md` + `pencil-automation.md` 참조. |
| /verify | 0 command 금지. 불가 시 UNKNOWN(사유) + STOP. exit code 기록. |
| /review | 근거 기반 판정. 근거 없으면 UNKNOWN. |

verify / review 없이 완료 금지.

모든 implement task 는 REVIEW 에서 PromptFit 평가 (루브릭: `<repo>/docs/agent/solutions/PROMPTFIT_RUBRIC.md`) + `.ai/promptfit/INDEX.md` 갱신.

---

## 9. Context Hygiene

- **공통 불변**: 매 진입 시 `CLAUDE.md` + `.claude/settings.json` 만 먼저 읽음.
- **역할별**: reading mode 에 맞는 `.claude/rules/**` / `.claude/agents/**` / `.claude/skills/**` 만 추가 열기.
- **task-local**: `.ai/tasks/<taskId>.md` + 현재 `.ai/reports/<taskId>/` + touched files 마지막 레이어.
- **bulk read 금지**: `.claude/**` 전체 일괄 읽지 않음.

---

## 10. 구현 / 설계 기본값 (3-repo 공통 · 변경 불가)

- 직접 구현 우선 (새 추상화 추가 전 직접 구현 단순성 평가)
- 신규 의존성 승인: `libs.versions.toml` 신규 항목 = PLAN `## 2. DependencyDecision` 8 항목 필수
- TDD 우선: 새 UseCase / Coordinator 는 `FakeXxx` 기반 테스트 먼저 또는 함께
- 외부 준비 연기: 외부 콘솔 / 인프라 미준비 = `TODO(user-prep)` 또는 stub
- 모델 분리: DTO · Entity · DomainModel · UiState 레이어 간 혼용 금지
- 명시적 오류 처리: typed 도메인 오류 또는 Result 우선
- 테스트 심 주입: clock · dispatcher · identity · logger · uuid 인터페이스 주입
- 불변 UI 상태: UiState 불변 + ViewModel → UI 단방향
- DI baseline: 3-repo 모두 `Koin`. 위치는 `app/` (또는 향후 `shared/app` glue)

세부: `.claude/rules/workflow-core.md` + `cycle-discipline.md` + `pencil-automation.md` + `.claude/rules/ui-ux-analysis.md`.
아키텍처 공통 SoT: 각 자식 repo 의 `docs/agent/architecture/` (각 자식 repo 가 SteadyWell propagation 받음).

---

## 11. 산출물 규약

| 산출물 | 경로 |
|---|---|
| Task 문서 | `<repo>/.ai/tasks/<taskId>.md` (자식 repo 안) |
| Task 인덱스 | `<repo>/.ai/tasks/INDEX.md` |
| 단계별 보고서 | `<repo>/.ai/reports/<taskId>/{MODE,EVIDENCE,PLAN,VERIFY,REVIEW,COMPOUND,TODO}.md` |
| **propagation 보고서** | `claude-cli-master/propagation-reports/<cycle-id>/REPORT.md` |
| **C# (master cycle) 보고서** | `claude-cli-master/.ai/reports/<cycle-id>/REPORT.md` |
| 운영 레이어 문서 | `<repo>/docs/agent/solutions/`, `<repo>/docs/agent/architecture/`, `<repo>/docs/agent/process/` |

stdout 출력 순서: `[EVIDENCE] → [DIFF] → [LOG]`

PLAN / VERIFY / REVIEW / PromptFit 정규 스키마: `.claude/rules/report-formats.md` + `report-paths.md`.

### Task ID 형식

`<PREFIX>-<DOMAIN>-NNN`

- master cycle: `C<n>-<DOMAIN>-NNN` (예: `C1-MASTER-BOOTSTRAP-001`)
- 자식 repo cycle: `<REPO>-<DOMAIN>-NNN` (예: `GB-UI-001`, `GD-CLI-005`, `GT-PHASE-F-002`)
- DOMAIN: UI · AUTH · DATA · API · SERVER · PERF · CONFIG · RELEASE · INFRA · DOCS · CLI · MASTER · PROPAGATE 등

---

## 12. UNKNOWN 규칙

레포 내 근거 없이 단정하지 않음. 근거 불충분 항목 = `UNKNOWN` 표기 + 확인 위치 명시.

---

## 13. propagation status (실측 baseline)

현 master HEAD sha + 3 자식 repo 동기 상태는 `.auto-memory/propagation-status.md` 에서 동적 파악.

`scripts/verify-sync.sh` 가 매 cycle 자동 갱신 (C3 에서 신설).

---

## 14. UI/UX 규칙 하이라이트

- `.claude/rules/pencil-uiux-workflow.md` (보호) — UI/UX 변경 = Pencil SoT → Compose 순서 강제 + `.ai/uiux-sot/latest/` 필수 (GT-strong patterns 채택)
- `docs/design/pencil-sot-policy.md` (보호) — Pencil SoT 정책 §1.1 디자인 도구 바인딩 / [CURRENT] / [TARGET] / [LOCKED] 라벨 / §3 Phase R 예외 / §8 고위험 STOP / §9 마이그레이션 escape
- `.claude/rules/uiux-sot-refresh.md` (보호) — refresh trigger FULL / PARTIAL / DOC-ONLY 분류

신규 Pencil 측 cli infra (MASTER-CLI-PENCIL-OPTIMIZATION-001 · 2026-05-19):
- `.claude/rules/pencil-cli-headless.md` — `@pencil.dev/cli` headless 진입점 + batch tasks.json + Save As 모달 회피 + CI/CD 통합 paradigm
- `.claude/rules/pencil-mcp-tools-reference.md` — 12 official + 1 package-verified (`open_document`) 도구 단일 SoT
- `.claude/rules/design-prompting-paradigm.md` — Effective Prompting 4 원칙 + verification 4-step + §FREEDOM

---

## 14a. 보호 파일 sha baseline (2026-05-19 · MASTER-CLI-PENCIL-OPTIMIZATION-001 마감)

5종 보호 파일 sha (post-cycle baseline · 본 cycle 안 `.claude/rules/pencil-uiux-workflow.md` 단일 변경):

| 보호 파일 | sha | 본 cycle 변동 |
|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `5b84cd9e4bc361652d6d0e561d8846eed3400d00` | 불변 |
| `.claude/rules/pencil-uiux-workflow.md` | `20c72ae66b513bdc991a377f73688c23d1154bcc` | **갱신** (이전 `3a703b30...`) |
| `docs/design/pencil-sot-policy.md` | `b27fbe16edb688218d7e57dd9a66d0f2a31ef300` | 불변 |
| `.claude/rules/uiux-sot-refresh.md` | `d3a0b57390bd0414cc89283a571dd6ecb8cb1562` | 불변 |
| `docs/design/design-sot-policy.md` | `e580b6d7ca9a88aef67c03f4bb39360993ab996f` | 불변 |

`.auto-memory/protected-file-hashes.md` 와의 정합 의무 (`cycle-discipline.md` §10 정합).

---

## 15. master cycle 진행 이력 (placeholder · 매 cycle 시 갱신)

| cycle ID | 마감일 | 변경 요약 | 영향 자식 repo |
|---|---|---|---|
| C1-MASTER-BOOTSTRAP-001 | 2026-05-02 | master repo 신설 + 53 cli infra cp + 5 divergent 정정 채택 | (propagation 미실시 · C4 예정) |
| C2-RULES-RESTRUCTURE-001 | 2026-05-02 | rules 5 분할 (workflow→3 / evidence→2) + DEFERRED pointer 4 통합 + agents/active·deferred 폴더 routing 갱신 | (propagation 미실시 · C4 예정) |
| C2.5-COMMON-PRINCIPLES-AND-DESIGN-TOOL-DECOUPLE-001 | 2026-05-02 | SOLID + 코드 리뷰 체크리스트 추가 (code-principles.md 신설) + 도구 무관 vs Pencil 전용 4 항목 분리 (design-to-code-sync.md / design-sot-policy.md 신설 + ui-spec.schema v0.3 generic 화) | 5 보호 파일 sha 갱신 (C4 propagation + 자식 ui-spec.json 마이그레이션 의무) |
| C3-AUTOMATION-SCRIPTS-001 | 2026-05-02 | 자동화 script 4종 + slash 1종 + Q2/Q4/Q5 보완 | (propagation 미실시 · C4 예정) |
| C5-EXTRA-COMMON-ABSORB-AND-RENAME-001 | 2026-05-02 | 24 추가 공통 파일 흡수 (architecture 13 + process 4 + solutions 1 + scripts 1 + root 5) + master rename gently-master → claude-cli-master + scripts find/CORE_CLI 확장 | 자식 repo 와 sha 일치 (24 신규 추가 = 이미 동일) · C4 propagation 시 새 cli infra 만 cp |
| C11-LOCK-WIDE-COVERAGE-001 | 2026-05-02 | C10 한계 RCA: daemon/hook/wrapper 모두 .git/index.lock 만 처리 → GT commit 시 .git/HEAD.lock 사고 발견. git lock 종류 다양 (index/HEAD/packed-refs/config/refs/**/*.lock). 4 layer 모두 광역 검사 추가 (동일 PID 검증 patterns) | Coin daemon 재 install 1회 후 모든 lock 종류 자동 |
| C4-PROPAGATE-TO-CHILDREN-001 | 2026-05-02 | master → 3 자식 단방향 propagation: 327 파일 cp + 44 ui-spec.json 마이그레이션 (lastSyncedPencilStateHash → lastSyncedDesignToolStateHash alias + designTool 신설) + 3 자식 CLAUDE.md Nested 추가 + verify-sync.sh exit 0 (PASS 109 / drift 0 / miss 0) | **3 자식 모두 적용** · master ↔ 자식 정합 100% |
| C4-VERIFY-001 | 2026-05-02 | C4 propagation 사후 광역 점검: sha 정합 PASS 109/0/0 ✓ · C11 hook drift 6 (sandbox cp 즉시 정정) · deprecated rules pointer 4-way 24 잔존 + 자식 flat agents 75 중복 + sandbox testfile 3 잔존 = 102 파일 (Coin 손 작업 1 paste rm + 4 commit) · orphan 검사 false positive 0 | sandbox 부분 마감 · Coin 손 작업 후 baseline = master rules 13 / 자식 rules 13 / 자식 flat agents 0 |
| C14+C13+C15-INFRA-MITIGATION-001 | 2026-05-02 | 묶음 cycle: (C14) `.gitignore` patches 자동 보장 — `scripts/ensure-child-gitignore-patches.sh` 신설 + propagate.sh 자동 호출 + 자식 3 marker block patch · (C13) verify-sync.sh launchd daemon 자동 진단 + log mtime stuck 경고 + --skip-daemon-check flag · (C15) propagate.sh `--prune` dry-run + `--apply` flag 신설 (whitelist `.claude/` 만 · 자식 도메인 영역 보호) · 사전 검증 사고 2건 사전 차단 (.gitignore 비호환 + prune 311 false positive) | sandbox 마감 · Coin 손 작업 1 paste = master 4 commit + 자식 3 × 1 commit · 자식 본 작업 진입 baseline 확보 |
| C10-LAUNCHD-DAEMON-001 | 2026-05-02 | C9 한계 RCA (Cowork 자체 file ops 가 git op 호출 시 hook/wrapper 모두 발화 X · sandbox 권한 lock rm 절대 불가) → macOS launchd 백그라운드 데몬 추가 (5초마다 PID 검증 + stale rm · 환경 무관) + install-git-lock-daemon.sh 1회 install patterns | Coin install 1회 후 99.99% 자동 mitigation |
| C9-GIT-LOCK-PID-VERIFY-001 | 2026-05-02 | C8 한계 RCA (hook = Claude Code Bash 만 발화 / mtime 마진 너무 김) → PID 기반 검증 추가 (lock 안 PID 죽음 = 즉시 rm · 정상 op 100% 보호) + scripts/git-safe.sh wrapper 신설 (Coin alias 권장 = IDE/터미널/Cowork 자동) + mtime 마진 단축 (5s/30s) | C4 propagation + Coin alias 추가 = 99.9% 자동 |
| C8-GIT-LOCK-AUTOMITIGATION-001 | 2026-05-02 | sandbox/agent crash 후 잔존 .git/index.lock 자동 정리 (pre-tool-use.sh git 명령 감지 시 stale > 30s rm + session-start.sh 진입 시 stale > 5분 rm) + C3 dead code 정정 (Claude Code 버전 검증 exit 0 뒤 포함되어 작동 X) | C4 propagation 시 자식 자동 적용 (모든 repo git lock 사고 매번 mitigation) |
| C7-UX-LAWS-INTEGRATION-001 | 2026-05-02 | Laws of UX 30 법칙 → 권장 17 + 신중 12 + 비권장 1 (Cognitive Bias) 분류 추가 · ux-laws.md 신설 + ux-auditor/reviewer agent 자동 reading + code-principles §H + app-implementation-guide §4.5 + Dark Patterns 5종 회피 추가 | C4 propagation 시 자식 의무 적용 |
| C6-COMMON-DOCS-AND-TEMPLATES-001 | 2026-05-02 | Part A 6 추가 흡수 (.ai/promptfit/PLAYBOOK + .ai/uiux-sot/refresh 3 + .github/pull_request_template + RLS guide) + Part C-2 9 신설 (app-implementation-guide.md + 7 도메인 template + Nested CLAUDE.md header template) + scripts find 확장 | 6 흡수 = 자식 sha 일치 / 9 신설 = C4 propagation 시 자식에 처음 cp + 자식 CLAUDE.md 상단 5~10 줄 Nested 패턴 추가 |
| MASTER-AUTH-DOMAIN-ACTIVATE-001 | 2026-05-03 | Auth 도메인 master + GT 활성화 (UNKNOWN → ACTIVE) · `auth-rules.md` SoT 신설 (10 섹션 · GT-AUTH-PIVOT-001 명시된 패러다임 코드화) · `auth-security-privacy` agent deferred/ → active/ mv · `deferred-domains.md` §2 매트릭스 + §6 history 갱신 · `routing-and-delegation.md` [DEFERRED] 제거 · path rebind decision (claude-cli-master → gently-master · 별 trail open) | 3 자식 모두 byte-identical propagation (verify-sync 104/0/0). GT Auth ACTIVE / GD GB UNKNOWN 유지 (자체 활성화 별 cycle) |
| MASTER-PROTECTED-BASELINE-RESYNC-001 | 2026-05-03 | 보호 파일 5종 baseline sha 갱신 + ui-spec.schema.json enum 에 "0.3" 추가 (description 무수정) + 4-repo propagation MATCH 재확인. 자식 ui-spec.json 마이그레이션은 별 cycle. | 4-repo schema cp (1 파일 × 3 자식) |
| GLOBAL-NO-ABBREV-POLICY-001 | 2026-05-10 | CLI infra SoT 신설 — no-abbreviation 정책 3 파일 (no-abbreviation-policy.md · allowed-acronyms.md · forbidden-abbreviations.md) + PreToolUse hook (check-abbreviation.sh) + settings.json 갱신 (Edit|Write hook 등록). `NO_ABBREV_ENFORCE=warn` 기본. verify-sync PASS 24/0/0 · hook self-test 3 fixture PASS. | **4-repo 적용** (master 77ca613 · GB 628245f · GD 3a5b4ca · GT f4501d5) |
| GLOBAL-NO-ABBREV-POLICY-002 | 2026-05-10 | Sub A: GT DailyPrescriptionScreen.kt ctx→mealContextEntry (4 occurrences) · Sub B: check-abbreviation.sh import line skip + generated path skip (false positive 제거 — `import androidx.compose.ui.res.stringResource` .res. 오탐 제거) · Sub C: NO_ABBREV_ENFORCE default warn→enforce + no-abbreviation-policy.md §3 제외 표 + §5.1 mode default 갱신. 7 fixture PASS (import skip · path skip · enforce block · enforce pass). | **4-repo 적용** (master 7a25854 · GB 2c83a4e · GD 8ad3e7d · GT 8647a4d) · GT Sub A commit 7e322f1 |
| MASTER-BILLING-DOMAIN-ACTIVATE-001 | 2026-05-10 | Billing 도메인 4-repo 활성화 (UNKNOWN×4 → ACTIVE×4) · `billing-rules.md` SoT 신설 (10 섹션 · GT CLAUDE.md §6 Mock-first paradigm + Edge Function 영수증 검증 의무 + 한입 티켓 = Google Play Billing 소비형 인앱 상품 코드화) · `billing-payments-guardian` agent deferred/ → active/ 이전 · `deferred-domains.md` 매트릭스 + §6 이력 + `routing-and-delegation.md` [DEFERRED] 제거 갱신 · STEP-1 drift mitigation (master sot-code-name-map.md ← GT GT-PHASE-3-SOT-001 흡수 · daily-prescription-screen row + aggregate 11→12/21→22) 묶음 처리. propagate 336/0 · verify-sync 112/0/0 (exit 0). | **4-repo 적용** |
| CLI-VERSION-UNPIN-PROPAGATION-001 | 2026-05-12 | cli infra `cycle-discipline.md` §13 본문 갱신 (pin 폐기 → 최신 추격 정책 전환 · npm scope + DISABLE_AUTOUPDATER + DISABLE_UPDATES 이중 차단 유지 + 주 1회 능동 갱신 default + 매 cycle self-test 3 항목 + FAIL 복귀 절차 · 현 known-working 2.1.121) + 4-repo byte-identical propagation (`4cd01b4...` → `0e4a7d0...`) + 별 trail 2 종 갱신 (close `CLAUDE-CODE-VERSION-PIN-2.1.114-001` · open `CLAUDE-CODE-LATEST-CHASE-001`). #51736 회귀 본질 fix = changelog v2.1.122 "ToolSearch missing post-startup MCP tools in nonblocking mode" 인용 박음. 보호 파일 5종 sha 변동 0 · Proto 3-repo 무접촉. | **4-repo 적용** |
| PROTO-CLI-VERSION-UNPIN-PROPAGATION-001 | 2026-05-12 | 직전 cycle CLI-VERSION-UNPIN-PROPAGATION-001 (Gently 4-repo) 의 Proto 3-repo 확장 propagation. cli-master `.claude/rules/cycle-discipline.md` → ProtoGentlyBreath + ProtoGentlyDay + ProtoGentlyTable 단방향 cp + 3 child commits (PB `9805361c` parent `7ded7008` / PD `f266338c` parent `419d5a8b` / PT `3d96668f` parent `a8ec3c1c`) + 7-repo cross-verify (모두 sha `732017a7...`) + Proto 3-repo `.auto-memory/protected-file-hashes.md` Recent updates entry append. STOP 조건 충족: Gently 4-repo 무접촉 · 보호 파일 5종 sha 변동 0 · Proto 3-repo 의 다른 unrelated 변경 commit 포함 0. 산출물 4종 = .ai/reports/PROTO-CLI-VERSION-UNPIN-PROPAGATION-001/{PLAN,EVIDENCE,VERIFY,REVIEW}.md. anchor stale 패턴 mitigation (직전 master cycle 안 Proto 3-repo 잔존 영역 마감). | **7-repo 적용** (master + GB + GD + GT + PB + PD + PT 모두 byte-identical sha `732017a7...`) |
| MASTER-COWORK-HANDOFF-BASELINE-AUTOVERIFY-HOOK-001 | 2026-05-12 | Cowork ↔ CLI baseline mismatch (COWORK-PREP-BASELINE-MISMATCH-001~007 누적 7회차) mitigation cycle — SessionStart hook `.claude/hooks/baseline-snapshot.sh` 신설 (7-repo HEAD + cycle-discipline.md sha + 보호 5종 sha + settings.json sha JSON 캡처 · macOS bash 3.x 호환 · printf-based · drift detection inline non-blocking) + settings.json SessionStart 배열 등록 (기존 `session-start.sh` 와 묶음 · 새 sha `6919ac4a`). 산출 `.ai/baseline-snapshot/<timestamp>.json` + `latest.json` copy. 7-repo capture scope · 4-repo propagation scope (cli-master + Gently 3 · Proto 3 무접촉). self-test PASS (JSON 6823 byte · 7-repo cycle-discipline sha `732017a7...` byte-identical · drift 0). 보호 파일 5종 sha 변동 0. Risk = Low (ops-layer · 제품 코드 미변경). | **4-repo 적용** (master + GB + GD + GT) |
| MASTER-DEGENERATION-PREVENTION-POLICY-001 | 2026-05-12 | text degeneration 본질 mitigation cycle. 신규 SoT `.claude/rules/text-degeneration-prevention.md` 신설 (3 metric · M1 한 문장 동일 token 3+ / M2 한 문단 5+ / M3 file z-score · paraphrase 의무 + mental scan 3 step + session reset trigger) + 신규 hook `.claude/hooks/post-edit-degeneration-check.sh` (Python3 + bash · 화이트리스트 union allowed-acronyms 자동 · TARGET_EXTS .md/.txt · warn default + enforce mode · positional argument fallback) + settings.json PostToolUse Edit\|Write matcher 등록 (post-policy-watch.sh 와 묶음) + self-test 7 fixture PASS (C6 policy file enforce → exit 0 · 박음 cluster positive case 5 violation 감지). 5-repo propagation 의무. | **5-repo 적용** (master + GB + GD + GT + app-foundation) |
| CLI-INFRA-SUPABASE-HANDLING-001 | 2026-05-16 | Supabase 도메인 (Edge Function / migration / RLS / Vault / psql / DB push 등) 요청 진입 시 CLI 자동 처리 영역 + Dashboard 한정 영역 분기 + STOP gate SoT 신설. `.claude/rules/supabase-handling.md` 9 섹션 (§1 적용 범위 / §2 CLI 자동 9 sub / §3 권장 검토 4 sub / §4 Dashboard 한정 4 sub / §5 STOP / §6 키워드 trigger / §7 인접 SoT 정합 / §8 변경 정책 / §9 cycle 이력) + `.claude/agents/active/intake-router.md` Decision authority 뒤 Supabase keyword routing 1 섹션 append (§6 키워드 감지 시 §2/§3/§4/§5 분기). safety-and-secrets curl/wget deny 정합 어긋남 (admin API curl 강제 불가) = `supabase` CLI 또는 SDK 우선 명시. 4-repo propagation (master + GB + GD + GT · app-foundation §9 scope 외). verify-sync 121/0/0 PASS. | **4-repo 적용** (master + GB + GD + GT) |
| MASTER-CLI-SUPABASE-COMPREHENSIVE-001 | 2026-05-18 | Supabase MCP server 3 instance 등록 (supabase-gb/gd/gt · 자식별 project_ref 분리 · HTTP transport + Bearer Authorization + read_only=true) + macOS Keychain wrap script paradigm 신설 (`~/bin/claude-wrap.sh` · `security find-generic-password` 측 token 추출 + fail-fast paradigm + `exec command claude` 측 alias resolution 차단) + 5-repo byte-identical propagation (master + app-foundation + GB + GD + GT) + supabase CLI 통합 paradigm (`~/.zshrc` 측 supabase-gb/gd/gt 3 alias append + setopt INTERACTIVE_COMMENTS) + supabase-handling.md §10 신설 (7 sub-section · MCP server 호출 + supabase CLI 분기 + read-only baseline + Keychain reference + 자식별 paradigm + `cli_...` token 폐기) + safety-and-secrets.md §macOS Keychain 측 secret 보관 paradigm 신설 + 기존 `cli_yundonghyeon@<host>_<timestamp>` 자동 token 폐기 paradigm (= 사용자 manual revoke). read-only baseline (= phased 1차 · write 확장 = `MASTER-CLI-MCP-SUPABASE-WRITE-ACTIVATE-001` 별 cycle 분리). | **5-repo 적용** (master + app-foundation + GB + GD + GT byte-identical) |
| MASTER-CLI-PENCIL-OPTIMIZATION-001 | 2026-05-19 | pencil.dev 공식 doc (2026-04-03) 흡수: 12 official MCP tool 단일 reference SoT (`pencil-mcp-tools-reference.md`) + 1 package-verified (`open_document`) 분리 명시 (Part A / Part B 구조) + Pencil CLI headless mode 진입점 SoT (`pencil-cli-headless.md` · @pencil.dev/cli npm + interactive shell + batch tasks.json + Save As 모달 회피 + CI/CD 통합) + Effective Prompting paradigm SoT (`design-prompting-paradigm.md` · Be Specific + Provide Context + Reference Design Systems + Iterative 4-step + Verification 4-step + §FREEDOM) + Variables ↔ Compose Theme.kt sync paradigm (`design-to-code-sync.md` §9 신설) + P9→P10 screenshot/export 검증 추가 + `pencil-uiux-workflow.md` §1 정정 (12 official + 1 pkg + 신규 5 도구 명시) + §9 신설 (Pencil CLI binding) + `pencil-automation.md` §13 신설 (headless 분기 표) + ui-implementer / ux-auditor agent 2 file 측 Pencil paradigm 섹션 append. 보호 파일 1 sha 갱신 (pencil-uiux-workflow.md `3a703b30...` → `20c72ae6...`) · 나머지 4 보호 파일 sha 불변. 5-repo byte-identical propagation. 0 production code touch. | **5-repo 적용** (master + app-foundation + GB + GD + GT byte-identical) |
| MASTER-CLI-PENCIL-OPTIMIZATION-002 | 2026-05-19 | H25 마감 미 포함 영역 (= anchor `cowork-handoff-H26-PENCIL-IMPL-ENTRY.md` §C 8 영역) 흡수 + paradigm SoT 단일 정착 cycle. pencil.dev 12 page 추가 fetch (= the-pen-format + components + slots + pen-files + design-as-code + pencil-interface + code-on-canvas + design-libraries + import-and-export + keyboard-shortcuts + authentication + troubleshooting) 마감 + 신 4 SoT 신설: `pencil-pen-format-schema.md` (= .pen format `"2.10"` TypeScript schema + 13 Entity type 단일 reference) + `pencil-component-paradigm.md` (= `reusable: true` Component + `type: "ref"` Instance + `descendants` nested customization slash-prefixed key + Slot container `slot: [...]` array paradigm 통합) + `pencil-theme-multi-axis.md` (= `themes` field multi-axis paradigm + mode/spacing/device 3 axis baseline + Compose 측 CompositionLocal multi-axis mapping) + `pencil-visual-primitives.md` (= Fill 4 종 (color/gradient/image/mesh_gradient) + Stroke + Effect 3 종 (blur/background_blur/shadow inner/outer) + BlendMode 17 + Flexbox Layout + icon_font 6 family 통합). 정정 강화 2 file: `design-to-code-sync.md` §9.5~§9.7 multi-axis paradigm 추가 (= mode + spacing + device axis cross-product Compose mapping) + `pencil-mcp-tools-reference.md` §1.1.1~§1.1.3 batch_design 13 Entity type 정합 + Component/Instance/Slot 호출 + Variable substitution 강화 / §1.2.1~§1.2.3 batch_get 13 Entity type 정합 검색 + Nested component search + Component instance audit 강화. 보호 파일 5 sha 변동 0. 5-repo byte-identical propagation. 0 production code touch. | **5-repo 적용** (master + app-foundation + GB + GD + GT byte-identical) |
| MASTER-CLI-DOCS-AUTOSYNC-PARADIGM-001 | 2026-05-19 | DocSync paradigm SoT 강화 + 자식 출시 docs 영역 명시 영구 정착 cycle. paste source baseline = H24 finding (= 3-repo 측 `LAUNCH-STATUS.md` + `docs/CLAUDE.md` + `docs/setup/*` 영역 7~8 일 stale 누적 default · 사용자 manual 갱신 영역 default). (A) `workflow-core.md` §단계 흐름 안 DocSync bullet 신설 (= 갱신 대상 영역 = `.ai/reports/<taskId>/*.md` + `docs/agent/` + 자식 출시 docs 영역 = `docs/release-readiness/LAUNCH-STATUS.md` + `docs/CLAUDE.md` 또는 자식 root + `docs/setup/*` 명시) + (B) `cycle-discipline.md` §20 신설 (= DocSync 단계 본문 SoT 단일 · 4 sub-section: 20.1 갱신 대상 / 20.2 갱신 의무 / 20.3 정합 의무 / 20.4 cycle 이력) + (C) `docs-change-communicator.md` Key questions 6~8 append (= 자식 출시 docs 영역 questions: 출시 task 표 / 자식 헌법 / setup 가이드). 5-repo byte-identical propagation. 보호 파일 5 sha 변동 0. 0 production code touch. 자식 출시 docs 본문 갱신 = 본 paradigm 정착 후 다음 cycle 마감 시 자동 / 반자동 진입 default. | **5-repo 적용** (master + app-foundation + GB + GD + GT byte-identical) |
| MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001 | 2026-05-19 | 부모 mount 측 cli session 진입 paradigm + cross-repo sub-agent fan-out paradigm 동시 정착 cycle. paste source baseline = H27-β cowork chat 사용자 본심 정합 (= "양쪽 모두 가능한데 요청사항에 따라서 claude code cli 가 판단해서 일을 처리"). (A) 부모 mount root `CLAUDE.md` 신설 (= `/Users/yundonghyeon/AndroidStudioProjects/CLAUDE.md` · 5-repo umbrella SoT · git repo X · cli session 측 부모 mount 진입 baseline + 자식 단독 vs 부모 mount 진입 paradigm 분기 + 5-repo 역할 표 + cross-repo paradigm pointer + propagation 단방향 paradigm + STOP 조건 5 영역) + (B) `.claude/rules/cross-repo-parallel-exec.md` SoT 신설 (= 영역 1 단일 cli session 측 sub-agent 병렬 호출 + 영역 2 다중 cli session 운영 + paradigm 선택 본심 cli session 자율 판단 default + 자식별 cwd 분리 + cross-repo 정합 처리 + STOP 조건 + paradigm 호출 trigger 영역) + (C) `.claude/agents/active/cross-repo-orchestrator.md` sub-agent 신설 (= §FREEDOM 영역 자율 결정 = 신설 default · tools Read/Glob/Grep/Task · Planner 경계 · intake-router 측 단일 repo routing paradigm 측 cross-repo 확장) + (D) `routing-and-delegation.md` §실행 방식 규칙 안 Cross-repo sub-section append + (E) `cycle-discipline.md` §21 신설 (= cross-repo cycle 영역 운영 표준 SoT · 7 sub-section). §FREEDOM 영역 결정: cross-repo-orchestrator 신설 default + routing append default + cycle-discipline §21 append default + `baseline-snapshot.sh` REPOS 배열 추가 = **skip default** (= file 자체 5-repo 모두 MISSING · Finding 4 mitigation 별 cycle 분리). 5-repo byte-identical propagation. 보호 파일 5 sha 변동 0. 0 production code touch. | **5-repo 적용** (master + app-foundation + GB + GD + GT byte-identical) |
| MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001 | 2026-05-19 | `cross-repo-parallel-exec.md` SoT 정정 강화 + 부모 mount root `CLAUDE.md` §4 정정 강화 cycle. paste source baseline = H27-δ cowork chat 측 측정 + 조사 + paste source 발행 마감 영역. 직전 cycle (= `MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001`) 신설 본문 강화 default. (A) `.claude/rules/cross-repo-parallel-exec.md` §2.4 Subscription-aware paradigm sub-section 신설 (= 2026-06-15 Anthropic billing split 영역 본문 + interactive pool vs Agent SDK credit pool 분기 + `claude -p` 사용 회피 paradigm 명시 + 권장 paradigm 영역 1/2/3 분기 본문) + (B) 동 file §2.2 영역 2 paradigm 본문 강화 (= 권장 paradigm default 명시 강화 + 사용자 본인 측 의무 영역 표 + 자식 cli infra 자동 정합 영역 + subscription pool 정합 영역 + trade-off 영역 본문 추가) + (C) 동 file §3.4 Sub-agent token cost warning sub-section 신설 (= 3-agent team token ~7× default + Agent SDK 측 token × 1.3~1.5× default + 실 사례 49-subagent typescript-checks $8k~$15k + 23-subagent code-quality project $47k (3 days) + 권장 paradigm sub-agent parallelism cap + chain unattended 회피 + `--include-hook-events` flag 측정 + subscription pool 정합 측정) + (D) 부모 mount root `CLAUDE.md` §4 cross-repo paradigm pointer 영역 본문 정정 강화 (= 영역 1/2/3 분기 표 + subscription-aware paradigm 본문 + 사용자 본심 영역 + 영역 2 진입 paradigm 본문) + (E) 5-repo byte-identical propagation default. §FREEDOM 영역 결정: 신 sub-section 위치 = §2.4 + §3.4 (= cli session 자율 결정 default) + 본문 LOC 자율 default. 5-repo byte-identical propagation. 보호 파일 5 sha 변동 0. 0 production code touch. | **5-repo 적용** (master + app-foundation + GB + GD + GT byte-identical) |
| MASTER-CLI-PENCIL-FLOW-ENFORCE-001 | 2026-05-19 | H27 cycle 측 발견 pencil 플로우 사고 5 영역 mitigation cycle. paste source baseline = H27-ζ 마감 시점 disk 실측 default. (A) `.claude/hooks/pre-screen-edit-pen-check.sh` PreToolUse hook 신설 (= `*Screen.kt` / `*Screens.kt` Edit/Write 진입 시점 `docs/design/pencil-sot/<screen>/<screen>.pen` 존재 검증 + 매핑 paradigm = basename strip Screen[s] + camelCase → kebab-case + warn mode default · `PEN_CHECK_ENFORCE=enforce` 승격 별 cycle 분리 · check-abbreviation.sh precedent 정합) + (B) `.claude/settings.json` PreToolUse Edit\|Write matcher 측 신 hook 추가 (= 다중 hook 영역 default · check-abbreviation.sh + 신 hook 동시 영역) + (C) `scripts/pencil-pending-sweep.sh` PENDING 영역 sweep paradigm 신설 (= `lastSyncedDesignToolStateHash = "PENDING_..."` 또는 64-zero placeholder grep · 매뉴얼 호출 default · cron 자동화 별 cycle 분리 · `.auto-memory/pencil-pending-status.md` trail 누적 보존) + (D) `.claude/agents/active/ui-implementer.md` Key questions 0 항 (= Pencil SoT entry gate · `.pen` 선행 의무 본문) + Must escalate when `.pen` 부재 발견 시 STOP 본문 추가 (= Type 2 신설 또는 Phase R 역공학 진입 안내) + (E) `.claude/agents/active/intake-router.md` Auth keyword routing sub-section 신설 (= `auth-rules.md` §1~§8 본문 분기 + login / signup / 인증 / 토큰 / OAuth / 익명 / EncryptedSharedPreferences / GoTrue / auth.admin 등 키워드 trigger + auth-security-privacy agent 호출 분기). hook self-test 7 fixture PASS · sweep self-test PASS (= 6 PENDING + trail header bootstrap 정정 후 ✓). 5-repo byte-identical propagation 20/0 PASS · 본 cycle 5 file × 5-repo cross-verify 25/25 ✓. 보호 파일 5 sha 변동 0 (= drift 0 의무 정합 ✓). 0 production code touch × 4 자식 ✓. self-incident 1 (= trail file header bootstrap 영역 측 `>>` redirect 측 file 신설 측정 동시 default · outer level 측 file 존재 check + header write 분리 paradigm 정정 마감). | **5-repo 적용** (master + app-foundation + GB + GD + GT byte-identical) |

다음 master cycle 후보 (C3~C4):
- **C3-AUTOMATION-SCRIPTS-001** — propagate.sh + verify-sync.sh + activate-agent.sh + report-gen.sh + `/cycle-report` slash 신설
- **C4-PROPAGATE-TO-CHILDREN-001** — master → GB / GD / GT 단방향 propagation + cross-verify

---

## 16. 본 SoT 변경 의무 절차

1. master 의 모든 cli infra 변경은 본 CLAUDE.md §15 표에 cycle entry 추가 의무.
2. 보호 파일 4 종 sha 변경 시 `.auto-memory/protected-file-hashes.md` 새 baseline 추가.
3. propagation 즉시 실행 (lazy 금지) — `scripts/propagate.sh` 호출.
4. cross-verify 자동 실행 + 결과 `propagation-reports/<cycle-id>/REPORT.md` 자동 생성.
5. 모든 자식 repo 가 새 sha 일치 확인 후 cycle 마감.

---

`Sources:`
- [.claude/settings.json](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/settings.json)
- [.claude/rules/workflow-core.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/rules/workflow-core.md)
- [.claude/rules/cycle-discipline.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.claude/rules/cycle-discipline.md)
- [.auto-memory/protected-file-hashes.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.auto-memory/protected-file-hashes.md)
