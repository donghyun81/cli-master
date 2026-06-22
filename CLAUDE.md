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

### 0.1 baseline 3 줄 (= 2026-05-22 신설 default · `MASTER-CLI-CYCLE-0-OPS-EXCEPTION-BASELINE-3LINE-001`)

- **3 앱 = 도메인별 독립 사용자 + 공유 인프라 default** (L1-3 정합 default). GB (= 호흡) + GD (= 일상) + GT (= 식단) 측 사용자 base 분리 default · "한 사용자가 3 앱 묶어서 산다" 가설 무효 default. 공유 = cli infra + app-foundation default. 미공유 = 사용자 base default.
- **1 인 운영 + AI reviewer = 의식적 선택 default** (L1-5 정합 default). 인간 reviewer 부재 = 의도된 architecture default · cli session 측 reviewer 역할 default (= `routing-and-delegation.md` reviewer 영역 default · `verification-and-review.md §독립 reviewer` 영역 default).
- **현 단계 = 6-repo 동일 mode / 미래 = 자식별 발산 허용 default** (L1-6 정합 default). 현 6-repo 측 default mode = production-graduated default (= `mode-system.md` Cycle 4 신설 시점 default · 본 cycle 측 implicit default 영역 default) · 미래 자식별 mode 발산 = 본인 명시 결정 + migration cycle default.

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
2. bash scripts/propagate.sh <relative-path> [--targets FND,GB,GD,GT|all]   # C3 에서 신설
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

## 5. STOP 조건 단일 SoT (= 본 cycle 통합 default · 2026-05-22 신설 default · `MASTER-CLI-CYCLE-1-STOP-CANONICAL-INTEGRATION-001`)

본 § = 6-repo 측 STOP 조건 단일 SoT default. 나머지 4 군데 (= `safety-and-secrets.md §비가역 변경 STOP 정책` + `cycle-discipline.md §21.4` + `cycle-discipline.md §22.4` + `cross-repo-parallel-exec.md §5`) = 본 § pointer 영역 default · 본문 무접촉 default. `cowork-project-instructions.md §D-1` = cowork sandbox 영역 default · 본 cycle scope X default · 본인 manual paste replace default.

### STOP 영역 (= 9 항 default · 즉시 중단 + 자동 수정/되돌리기 금지)

| # | 영역 | trigger | mitigation |
|---|---|---|---|
| 1 | DB migration / Money / Auth 영향 경로 | DB schema 변경 + auth/billing 변경 + secret 접촉 default | 비가역 영역 default · 사용자 본심 회수 의무 default |
| 2 | Scope expansion | 요구사항 범위 초과 + 다른 영역 묶임 default | cycle scope 명확화 의무 default |
| 3 | 비가역 변경 징후 | 파일 삭제 + 스키마 변경 + 기존 파일 대규모 override default | mitigation cycle 신설 default |
| 4 | 예상 외 시스템 상태 | sandbox 진입 시 baseline mismatch default | 사용자 회수 default |
| 5 | 보호 5 file sha drift | byte-identical 의무 영역 default · `protected-file-hashes.md` baseline 정합 default | 즉시 mitigation cycle default · 리뷰 블로커 default |
| 6 | 자식 cli infra drift | master 측 단방향 propagation 위반 default | master 측 정정 cycle 신설 default |
| 7 | Cross-repo HIGH RISK 도메인 진입 | 6-repo 측 동시 영향 영역 default (= DB migration / Money / Auth / production push) | 사용자 본심 회수 default |
| 8 | git mv + sed stage 누락 | rename + content 변경 동시 영역 측 unstaged 잔존 default | post-rename `git add -u` 의무 default |
| 9 | 사용자 본심 분기 의제 본질 | 본인 결정 본질 영역 default · **Mode 잘못 결정 sub-case 흡수 default** (L1-7 정합 default) | AskUserQuestion 회수 default |

### Mode 잘못 결정 sub-case (= L1-7 정합 default · STOP 조건 9 sub-case 흡수 default)

Mode 잘못 결정 = STOP 조건 9 (= 사용자 본심 분기 의제 default) 측 sub-case 흡수 default. `verification-and-review.md §에러 유형별 복구 경로` 측 "REVIEW FAIL (블로커) → change-planner/system-architect 재계획" 정합 default. 신 recovery 절차 신설 X default.

`BLOCKED` 종료는 권한 / 환경 이슈에만 사용 default.

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
| 빠른 검증 일괄 | `/verify-all <taskId>` | architecture + test + 산출물·시크릿 grep |
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
- **just-in-time 로드 (= eager 회피 · `rule-routing-index.md §B` 정합)**: 역할별 로드 집합 = [`rule-routing-index.md`](.claude/rules/rule-routing-index.md) §B Reading Mode → 의무 로드 표(L0 항상 + 해당 L1/L2/L3 subset 만). 큰 paradigm 본문(예: cross-repo 실행 = `cross-repo-parallel-exec-detail.md`)은 항상 로드 X · 해당 **행동 trigger 시점**에만 연다. L0 = kernel(safety + anchor + cross-repo kernel + 헌법 §5)만 항상.
- **task-local**: `.ai/tasks/<taskId>.md` + 현재 `.ai/reports/<taskId>/` + touched files 마지막 레이어.
- **bulk read 금지**: `.claude/**` 전체 일괄 읽지 않음.

---

## 10. 구현 / 설계 기본값 (3-repo 공통 · 변경 불가)

- 직접 구현 우선 (새 추상화 추가 전 직접 구현 단순성 평가)
- 신규 의존성 승인: `libs.versions.toml` 신규 항목 = PLAN `## 2. DependencyDecision` 8 항목 필수 (8항 canonical = `docs/agent/architecture/DEPENDENCY_DECISION_CHECKLIST.md` · UI 라이브러리 억제 canonical = `.claude/rules/ui-ux-analysis.md §UI 라이브러리 억제 기본값`)
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

PLAN / VERIFY / REVIEW / PromptFit 정규 스키마: `.claude/rules/reporting.md` §5~§7 + §1 경로 규약 (= 직전 report-formats.md + report-paths.md 본문 통합 default · MASTER-CLI-CLEANUP-7CYCLE-001 M1 마감).

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

## 14a. 보호 파일 sha baseline (2026-06-18 · MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001 마감 · git-sha1)

5종 보호 파일 git-sha1 (= `git hash-object` · post-cycle baseline · 본 cycle 변경 = design SoT 2 file 한정 — `uiux-sot-refresh.md`("즉시 의무 vs Deferred" 분기 subsection + 게이트 [Design SoT Sync] 재배선) + `design-sot-policy.md`(§3 code-first deferred 예외) · 나머지 3(ui-spec.schema.json + pencil 2종) 무변동):

| 보호 파일 | git-sha1 | 본 cycle 변동 |
|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `8b46bb4952be03a7631b66096ba2b47e27a1c72a` | 무변동 (= COMPOUND-LINT-DEPRECATE-001 baseline 유지) |
| `.claude/rules/pencil-uiux-workflow.md` | `aba157e0a6fdfd180dfab68167270bdfb542e94f` | 무변동 (= PENCIL-PHASE-B-PROTECTED-001 baseline 유지) |
| `docs/design/pencil-sot-policy.md` | `ce9c0d3e54534eb6eab3c7133cbb71a0e17ca6de` | 무변동 (= PENCIL-PHASE-B-PROTECTED-001 baseline 유지) |
| `.claude/rules/uiux-sot-refresh.md` | `0aeac86d9d86532c893503dda8c09cbfc4cfc228` | **갱신** (이전 `d2c62265...` · "Refresh Trigger Classification" 직후 "즉시 의무 vs Deferred (design-debt) 분기" subsection 신설 + 게이트 line REVIEW §1 FAIL→[Design SoT Sync] WARN 재배선) |
| `docs/design/design-sot-policy.md` | `0d265e0bbc6f0f848f1b34dc510a9d6d7d9f0bd9` | **갱신** (이전 `69649a36...` · §3 "원칙" code-first 역방향 항→Deferred (design-debt) lane 한정 허용 3-bullet · Phase R 예외 무접촉) |

> **algorithm 분기 주의** (`protected-file-hashes.md §CONVENTION` 정합): 본 §14a = **git-sha1 (40 char)** · `.auto-memory/protected-file-hashes.md` manifest + `.ai/baseline-snapshot/latest.json` = **sha-256 (64 char)**. pencil-uiux-workflow.md 측 sha-256 = `b09b8d5091a748e80a062e766ef51352a6f26a3afdffccc15d51ade4d643364e` (= manifest 측 baseline). 두 algorithm 직접 비교 금지.

`.auto-memory/protected-file-hashes.md` 와의 정합 의무 (`cycle-discipline.md` §10 정합).

---

## 15. master cycle 진행 이력 (placeholder · 매 cycle 시 갱신)

| cycle ID | 마감일 | 변경 요약 | 영향 자식 repo |
|---|---|---|---|
| MASTER-CLI-COMPOUND-LINT-DEPRECATE-001 | 2026-06-10 | 존재한 적 없는 도구 compound-lint.sh 인용 전량 일괄 deprecate — 검증 의무 보존·수단만 실존 도구 재배선 (Mode M5 cli-infra-ops · production 무접촉 · DEAD-REF-SWEEP ② HOLD 의 Coin 본심 회수 = 일괄 deprecate 확정 + 보호 잔여 2건 동반). **2-stage**: Stage A = 비보호 운영 live 25 file(rules 5 + skills 4 + commands 2 + agents 5 + hooks 1 + docs/agent 4 + docs/backend RLS guide + CLAUDE.md §7 행 + .github PR template + .ai/uiux-sot/refresh/VERIFY.md) · Stage B = 보호 5 file 7줄(compound-lint 5줄 = design-sot-policy 3 + pencil-sot-policy 1 + ui-spec.schema.json 1(JSON parse PASS) + :22 lineage Package Boundary 폐기 연장(PROTECTED-STALE-PATH-FIX :27 정합) + :9 design-sot-refresh→uiux-sot-refresh 명칭 오기 정정 = F4 동족). **처분(전수 117줄 -i 기준)**: 재배선 61 · 제거 17(RLS guide 8블록 16줄 + CHECKLIST Refs 1행) · 라벨-보존 4(drift-auditor 예시 · gsm hook 죽은-인용 예시 · PROPAGATION_PARAMETERS 2) · 역사 무접촉 35(.ai/reports + propagation-reports + COLD + §15/§F 이력행). 대체 수단 = 시크릿 패턴 grep(safety-and-secrets §시크릿 스캔 패턴) + ls 산출물 검사 + `git diff --name-only` 실측(8c 대체) + layer-checker/check-layer(I2) + ktlint warn-gate(Lint 표) + /verify-all 3단 재구성. **2층 hash resync**: manifest sha-256 5/5 + §14a git-sha1 5/5 (algorithm 교차 X · 보호 5 전수 변동). **검증**: 잔존 grep = deprecate 라벨분+역사 이력행 외 0 · 실행형(`bash …/compound-lint.sh`) live 0 · gsm 스캐너 rules backtick 0 · ui-spec JSON 구조 무결 · verify-sync = REPORT 참조 · production 0 LOC. **81/107 reconcile**: 107 = DEAD-REF-SWEEP 시점 master 전체 → 이후 cycle 산출물·§15 역사 줄 +8 = 115 실측(-i 117) · 81 = cowork 운영-live 한정 집계. **후속(scope 외)**: PROPAGATION_PARAMETERS repo-config identity 인터페이스 광역 stale(REPO_NAME 등 변수 미export 실측) · pencil-uiux-workflow:11 `pencil-sot-binding.md` 명칭 잔존 · layer-checker scripts/agent/repo-config.sh 경로 stale · O7 "5-repo" 어휘 sweep · COMPOUND.md artifact 존치 재평가. | **6-repo 적용** (master 본 commit + 5 자식 propagate byte-identical 29 file: FND/GB/GD/GT/PDOCS · manifest/§14a/§15/propagation-status = master-only · REPORT = propagation-reports/MASTER-CLI-COMPOUND-LINT-DEPRECATE-001/REPORT.md) |
| MASTER-CLI-REPO-COUNT-VOCAB-SWEEP-001 | 2026-06-10 | v17.1(PDOCS 6번째 repo 합류) 이후 stale "5-repo" 어휘를 live 규범 본문에서만 현행화 + 비보호 소형 잔여 3 (Mode M5 cli-infra-ops · production 무접촉 · audit P2 O7 · blanket sed 금지 = 건별 행-단언 치환표 180 적용 · P2-RENAME 동결 보존 전례 정합). **집계 기준** = literal "5-repo" -i · 행 단위 · live 영역(rules/agents/skills/hooks/commands + scripts/*.sh + CLAUDE.md live + 부모 root) 진입 219행. **처분**: live 정정 157(자식 수=5 vs repo 수=6 의미 단위 — "master + 4 자식"→"master + 5 자식" · 열거 +gently-product-docs disk 실측 후) · 역사 박제 46(각 rule 이력행·§15·§F·갱신/결함 역사 — 그 시점 사실) · STOP③ 실태-정합 보존 8(instructions-loaded hook 7 + pencil-pending-sweep 1 = REPOS 하드코딩 5 · 거짓 라벨 회피) · 키워드 병기 4("6-repo" 추가 + "5-repo" 보존) · 모호 보존 4(rri §E·code-style §E cycle 자기서술 + text-degen 실측 baseline + domain-roles reconcile) · **보호 내 발견 0**(표면화 대상 무·보호 체인 미발동). **소형 3**: ① design-to-code-sync :12/:87 design-sot-refresh→uiux-sot-refresh(의미 병기) ② layer-checker scripts/agent/→scripts/ ×4 ③ 동족 check-layer/SKILL ×4 (+동반: propagate.sh usage FND 병기 · CLAUDE.md §3 --targets 현행화 · arch-link/supabase 열거 PDOCS 실측 추가). **검증**: 보호 5 sha drift 0 · live 현재형 잔존 0(잔존 62 = 보존 4분류 전수) · propagate ok=225/0 → run-master 자식 5 재seeding **즉발 자체 회수**(git rm+amend · run-* = repo-specific L1-3 · DEAD-REF ⑤ 전례 · propagate.sh 명시-cp 가드 부재 표면화) → 실효 44 file × 5 · verify-sync **160/0/0** · 자식 신규 dirty 0 · 부모 root CLAUDE.md §7 정합 직접 갱신(신 sha-256 `64ebf82c`) · production 0 LOC. **후속(scope 외)**: docs/** 잔존 15행 · instructions-loaded+pencil-sweep 6-repo 계측 확장 · 구세대 "3-repo"/"4 자식" 어휘(working-file-lifecycle 5 위치 포함) · propagate.sh run-* 가드 · G3=별 cycle 6 · B body=Coin paste. | **6-repo 적용** (master `558af38` + 5 자식 propagate byte-identical 44 cli-infra file: FND `a69a0af` / GB `d50c519` / GD `9e4aff6` / GT `7f188ff` / PDOCS `c937f4f` · scripts 4 + CLAUDE.md = master-only · 부모 root = git-외 직접 · REPORT = propagation-reports/MASTER-CLI-REPO-COUNT-VOCAB-SWEEP-001/REPORT.md) |
| MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001 | 2026-06-10 | Pencil v1.1.62 4종 제거 stale sweep **Phase B** — 보호 2 file 본문의 제거-도구 참조 현행화 + sha 3-layer resync (Mode M5 cli-infra-ops · production 무접촉 · TOOLSET-REMOVAL Phase A 0e1f7e3 defer분 = Coin 큐 확정 06-10 집행). **scope** = 보호 2(`pencil-uiux-workflow.md` :11/:20/:22/:45/:56/:68/:93 + `pencil-sot-policy.md` :40/:77 · 내용 기준 재탐색 = 원 좌표 전수 현행 일치) + 동반 비보호 `cycle-discipline.md`:227(잔존 실측 후 계약 허용분 · :164 = §13 게이트 정합 서술 = 무접촉). **본질**: ① 도구수 12+1→9(= tools-reference §0.1 pointer · 목록 중복 0) ② OPTIMIZATION-001 추가 5종 lineage = 현존 2(get_guidelines/export_nodes)+제거 3 명시 ③ Type 1/2/3 open_document step→현 메커니즘(Type 1 = `open -a Pencil <abspath>` active-doc · Type 2/3 = headless `pencil interactive -o` 신설+시각 진입) ④ STOP moot 항(open_document path-arg) 2곳→제거 4종 부활/9종 변동 검출 STOP ⑤ §2 표 캔버스 열기 행→headless PRIMARY+시각 alternative ⑥ audit backlog ⑥: `pencil-sot-binding.md` 죽은 명칭→실 file `pencil-sot-policy.md`(의미 alias 병기 보존). **§2.5/§9 headless-primary 본질 무접촉**. **sha 3-layer**: manifest sha-256(`2ec100bf…`→`b09b8d50…` · `ae20a79c…`→`2bfc81c5…`) + §14a git-sha1(`22570f97…`→`aba157e0…` · `acf88d95…`→`ce9c0d3e…`) + baseline-snapshot 재생성(직전 2-cycle stale `e6a4a2a1…`/`96de2f5d…` 정합 + PDOCS block 첫 포함) · 나머지 보호 3 변동 0. **검증**: §13 self-test 3/3(CC 2.1.170 + pencil Connected + ToolSearch 9종 전수 + 제거 4종 부재) · propagate ok=15/0 · verify-sync **160/0/0** · 제거 4종 잔존 = 제거-라벨 서술만 · 기존 dirty 무접촉(GB 2 · GD/GT 각 1) + 신규 dirty 0 · production 0 LOC. **후속(scope 외)**: §15 hot 11 entry > 10 = cold 재이전 advisory(별 판단). | **6-repo 적용** (master `57af6de` + 5 자식 propagate byte-identical 3 file: FND `1c3ce90` / GB `9170dd8` / GD `68cbe3e` / GT `41683b0` / PDOCS `b963ac8` × pencil-uiux-workflow + pencil-sot-policy + cycle-discipline · manifest/§14a/§15/incident-log/snapshot = master-only · REPORT = propagation-reports/MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001/REPORT.md) |
| MASTER-CLI-CC-VERSION-UPDATE-NATIVE-EVAL-001 | 2026-06-11 | Claude Code 버전 latest-chase 확인(npm @latest = **2.1.170** · 진입 시점 이미 latest = `npm install -g @latest` no-op) + native installer 전환 평가 박제 (Mode M5 cli-infra-ops · production 무접촉). **scope** = `cycle-discipline.md §13`(native installer 재검토 trigger 블록 신설 · 기존 §13 본문 무변경 · 6-repo propagation) + master-only `incident-log.md`(LATEST-CHASE PASS + NATIVE-MIGRATION-EVAL 2 trail) + `CLAUDE.md §15`. **본질**: ① npm 통제형 수동 갱신 확인 + self-test **3/3 PASS**(CC 2.1.170 + `pencil ✓ Connected` + ToolSearch 9종 named-set 전수 · 게이트 = PENCIL-SELFTEST-GATE-RECALIBRATE baseline · 구 ≥13 폐기) → LATEST-CHASE trail PASS entry(직전 PASS 2.1.139 · 회귀 X). ② native 전환 평가 = **전환 X** (auto-update 통제 미실효 #60956 OPEN 2026-06-11 live-verify + symlink 강제 재생성 #41602/#3010/#28625 미해결 + 설치 후 pin 부재) → §13 재검토 trigger 4조건 박제. setup-guide npm 참조 = 정책 정합(무변경). **self-re-anchor**: paste baseline `424644…` → 진입 `157a2c5` → 실행 중 `fc51d04` re-drift(PENCIL-PHASE-B 완결 cycle · 본 scope 와 orthogonal) · §13 줄번호(insert @203) + 보호 sha 라이브 재유도 · self-test 게이트 ≥13→9 정정. **검증**: self-test 3/3 + 보호 5 sha drift 0(edit-set ∩ 보호 = ∅ · fc51d04 재baseline 5/5 manifest 일치) + propagate ok=5/0 + verify-sync 무회귀(PHASE-B 160/0/0 baseline 유지) + production/도메인 0 LOC + 기존 child dirty 무접촉(GB 2·GD/GT 각 1) = propagation-reports/MASTER-CLI-CC-VERSION-UPDATE-NATIVE-EVAL-001/REPORT.md 확정. **후속(scope 외)**: trigger 충족 시 native 전환 별 cycle · npm 하드 EOL 모니터 · §15 hot >10 cold 재이전 advisory. | **6-repo 적용** (master 본 commit + 5 자식 propagate `cycle-discipline.md` byte-identical: FND/GB/GD/GT/PDOCS · incident-log/§15 = master-only · REPORT = propagation-reports/MASTER-CLI-CC-VERSION-UPDATE-NATIVE-EVAL-001/REPORT.md) |
| MASTER-CLI-INFRA-SMALL-BATCH-001 | 2026-06-11 | OPS 위생 소형 3건 일괄 — 오늘 audit/sweep 표면화 기계적 잔여 (Mode M5 cli-infra-ops · 도메인 키워드 0 · production 무접촉 · audit backlog ②③⑪). **① hook 6-repo 계측 확장**: `instructions-loaded-baseline-verify.sh`(REPOS 5→6 +gently-product-docs + 7 wording행 "5-repo"→"6-repo": :7/:44/:45/:46/:56/:81/:129) + `pencil-pending-sweep.sh`(REPOS 5→6 + :34 wording · PDOCS = pencil-sot dir 부재 → graceful skip) — REPO-COUNT-VOCAB-SWEEP-001 STOP③에서 "실태-정합 보존"했던 8행(=instructions 7 + pending 1)이 REPOS 확장으로 거짓이 되어 동반 현행화(baseline-snapshot.sh 6-repo 전례 = DEAD-REF-SWEEP ① 동형). **② propagate run-* cp 가드**: `propagate.sh` C16 신설 — `--prune` EXCLUDE만 있고 순방향 cp(--all find 자동 포착 + 명시 인자)엔 가드 부재 → `.claude/skills/run-*` 포함 시 skip+WARN(FILES 해결 직후 case-glob · runtime-crash-mitigation 하이픈 경계 비매칭 = DIFFERENTIATION-SCOPE-001 동형). 실증 = PROPAGATE-RUN-SKILL-RESEED-001(incident · run-master 자식 5 재seeding). **③ GT pre-push gate 정합**: 의도 근거 실측 = PRELAUNCH-CI-GATE-001(COLD:93) "GB/GD/GT 3앱 pre-push hook(core.hooksPath) 이중 발화" + GT install.sh 주석("per-clone local 설정 · 새 clone 마다 1회 실행") + GT 게이트 생성 commit `4e910c7` + hook file 실존 = **제외 의도 0 · unset = install.sh 미실행 gap** → GB/GD 동형 `git config --local core.hooksPath scripts/githooks`(repo-local · 비커밋 · 전파 X · GT 단독). **검증**: bash -n 3/3 + instructions-loaded live = 6-repo HEAD 블록(PDOCS=1db90fc 포함) + 보호 drift 0 + 가드 self-test(run-master 단독 WARN+exit2 비변경) + propagate ok 5(instructions)+4(pending) + verify-sync **160/0/0** + pencil-pending-sweep 4-child byte-identical `6875f63e`(verify-sync 미추적 수동) + GT 3-child hooksPath 동형 + 보호 5 sha drift 0(edit-set ∩ 보호 = ∅) + 기존 dirty 무접촉(GB 2·GD/GT 각 1) + 신규 dirty 0 + production 0 LOC. **후속(scope 외)**: §15 hot 13 > 10 = cold 재이전 overdue(CC-VERSION entry 후속 flag 정합 · 별 판단). | **혼합 scope** (master `513f964` + instructions-loaded → 5 자식 byte-identical `67d47ac6`: FND `f5c8b96`/GB `ecb8105`/GD `5e61110`/GT `3af52a0`/PDOCS `ab846b0` · pencil-pending-sweep → 4 자식 `6875f63e`(FND/GB/GD/GT · PDOCS 미보유) · propagate.sh = master-only · GT core.hooksPath = GT-local 비커밋 · §15/incident = master-only · REPORT = propagation-reports/MASTER-CLI-INFRA-SMALL-BATCH-001/REPORT.md) |
| MASTER-CLI-S15-HOT-DEMOTE-003 | 2026-06-11 | §15 hot 13행 → cold 7회차 재이전 (Mode M5 cli-infra-ops · production 무접촉 · GSM-S15-HOT advisory 3 cycle 연속 발화 + audit-P2 O2 후속 · COLD-002 + AUTO-DEMOTE-CONTEXT-DIET 전례 동형). **본질**: §15 hot 13 entry 중 오래된 8 (`MASTER-CLI-P2-MECHANISM-001`~`MASTER-CLI-PROTECTED-STALE-PATH-FIX-001`) = `.auto-memory/master-cycle-history-COLD.md` verbatim append (LOSS NONE · 이전 8행 = cold 신규 8 entry exact-string 대칭 검증) → cold 103→111 · hot 잔존 = 최근 5 (`MASTER-CLI-COMPOUND-LINT-DEPRECATE-001`~`MASTER-CLI-INFRA-SMALL-BATCH-001`) + 본 entry = 6. **동반**: §15 table-split 빈 줄 1 제거 (valid 표 복귀) · cold §1 heading stale 94→111 reconcile (= 직전 AUTO-DEMOTE +9 누락분 동반 정정) · `context-health-metrics.md` §2 갱신 (hot entry desc + cold pointer 103→111 + master char 재측정). **검증**: hot 13→6 (`measure-gsm-cycle.sh` awk 실측) · GSM-S15-HOT advisory 재실행 무발화 (6 ≤ 10) · 무손실 대칭 8 = 8 exact-string · 보호 5 sha drift 0 (edit-set ∩ 보호 = ∅) · production/도메인 0 LOC · 자식 5 repo 무접촉. **후속(scope 외)**: 다음 hot > 10 도달 시 8회차 재이전 (= advisory). | **master-only** (master 본 commit · §15 / cold / context-health-metrics = master-only · 자식 5 repo 무접촉 · propagation 불요) |
| MASTER-CLI-WORKTREE-PARADIGM-001 | 2026-06-11 | git worktree paradigm = **영역 1.5** 신설 (Mode M5 cli-infra-ops · production 무접촉 · Coin 본심 D1~D8 확정 · scope = worktree 만 — loop/goal/verifier 도입 0). **본문 canonical** = `cross-repo-parallel-exec-detail.md §2.1.5` 단일 (D2·L1-4): ① D1 적용 = within-repo 병렬(같은 repo 동시 2+ workstream worktree×branch 격리) + master propagation 격리(propagation 중 별도 master cycle · main = propagation 전용 보존) · 영역 1 sub-agent 격리 = **보류**(read-only 용도 실수요 0) ② D6 운영 계약 = worktree dir repo 외부(`~/AndroidStudioProjects/.worktrees/<repo>--<cycle-id>` · git-외 · .gitignore 불요) + `wt/<cycle-id>` branch 한정 commit + 보호 5 = main checkout 한정 + propagate/verify-sync 실행 = main 한정 + 영역 2 대체 X + Transport(생성·정리)/Inspection(격리 대상·merge 판단) 분리 ③ D3+D7 guard 3(신 STOP 신설 X) = self-clean 의무(merge→worktree 제거→branch 정리 순) + orphan/미커밋 WIP prune 징후 = 기존 STOP #3·#4 발동 + `git worktree prune` 자동 실행 금지 ④ D8 merge 소유 = workstream cycle 마감 step 포함(merge+verify+self-clean 후 paste-back) · conflict 자동 해소 금지(보고→사람) · 파일 겹침 측정 = cowork paste 발행 단계 의무 ⑤ D4 = interactive pool 정합(영역 3 무관) + sub-agent cap ≤3 불변. **동반**: kernel `cross-repo-parallel-exec.md` §2 1-bullet 요약 + §8 이력 · 부모 root `CLAUDE.md` §3.3 행 + §4 영역 1.5 행(3→4 분기 count 동기 · git-외 직접 · 신 sha `fdec28c5`) · `automation-policy.md` §2 #12 Transport 행(11→12 영역). 후보 처분 = automation-policy 채택 / mode-system·anchor-list 미채택(L0 kernel 항상-on 노출 + anchor 본질 무변동 · 양 최소화). **검증**: worktree 사전 refs grep 0(충돌 0) + propagate ok=15/0 + verify-sync **160/0/0** + 보호 5 sha drift 0(edit-set ∩ 보호 = ∅) + production 0 LOC + 기존 child dirty 무접촉(GB 2·GD/GT 각 1) · PDOCS transient index.lock 1건 = 측정 후 재 stage·commit 회수(자동 rm 0). **후속(scope 외)**: 영역 1.5 첫 실사용 실측 검증 · D1-③ 재평가 · native EnterWorktree 연계 평가 · propagate.sh add silent-fail surface. | **6-repo 적용** (master `1658c6f` + 5 자식 propagate byte-identical 3 file: FND `1f90383`/GB `c057524`/GD `749e54d`/GT `77bc8fe`/PDOCS `a044e8e` · 부모 root CLAUDE.md = git-외 직접 · §15/산출물 = master-only · REPORT = propagation-reports/MASTER-CLI-WORKTREE-PARADIGM-001/REPORT.md) |
| MASTER-CLI-PENCIL-SCHEMA-UPDATE-001 | 2026-06-15 | `.pen` format version label `"2.11"`→`"2.13"` + §1.1a structural-delta 유예 배너 (Mode M5 cli-infra-ops · production 0 LOC · Option 1 "최소 정직" · Coin 본심). **STEP 0 live 측정**: Pencil MCP `get_editor_state(include_schema:true)` · active editor `report-screen.pen` · `Document version "2.13"` 실측 → disk 5종 v2.13 auto-migration 정합. **판정 = structural** (minor bump 아님 · 2026-05-31 RECOLOR 2.10→2.11 선례 대비): 8 delta(−line · −icon_font · +icon · +script · typed variables · stroke flatten · shader fill · TextContent · Group). **scope = label + §1.1a 배너만** (목적 line + §1.1 Document version field + §1.1 표 + §7 STOP trigger 2.11→2.13 + §9 entry) · body(§2 13 union + §2.2~§2.8 + §4 + §5) = **2.11-shape 유지 PENDING** (`Line`·`icon_font` 잔존). body 전면 rewrite + 형제 Pencil rule 4종(`pencil-visual-primitives.md`/`pencil-mcp-tools-reference.md`/`pencil-component-paradigm.md`/`pencil-theme-multi-axis.md`) 정합 = **별 follow-up cycle(002) defer**. **검증**: verify-sync **160/0/0** PASS · 6-repo byte-identical sha-256 `01b79fd7` · 보호 5 sha drift 0(edit-set ∩ 보호 = ∅ · `ui-spec.schema.json` `.pen` ref 0 = structural에도 무접촉) · `.kt` 0 LOC · 자식 신규 dirty 0(전 commit path-limited). **사고**: 6/13 크래시 stale index.lock × 2(master 16:00 + FND 14:13 · 0-byte ~34h) commit 차단 → Coin 수동 rm 후 재개 · 근본원인 = `com.coin.git-lock-cleaner` daemon 미활성(follow-up: launchctl load). | **6-repo 적용** (master `3c2ac9b` + 5 자식 propagate byte-identical 1 file: GB `1c9353b`/GD `7fc0337`/GT `1e8d211`/FND `af3869f`/PDOCS `3534130` · §15/propagation-status/REPORT = master-only · REPORT = propagation-reports/MASTER-CLI-PENCIL-SCHEMA-UPDATE-001/REPORT.md) |
| MASTER-CLI-DATA-SOT-ARCH-LANDING-001 | 2026-06-15 | `LOCK-DATA-SOT-SERVER-AUTHORITATIVE-001`(Coin 확정 2026-06-15) 데이터 SoT 결정을 6-repo 공통 헌법 `COMMON_ARCHITECTURE.md` 에 **1 절(§4)** 명문화 (Mode M5 cli-infra-ops · production 0 LOC · 문서 한정 · Coin 본심 = 앱-중립 계약만). **결정**: 사용자 데이터 source of truth = 서버(Supabase Postgres) · Room = offline-first 캐시 + 서버 hydration 층(Room 단독 SoT 금지) · 집계(곡선·통계·리포트) = 서버 Edge Function · durability(재설치·기기 변경 생존 · 업로드 전용 sync = 미충족). **scope = 1 절 삽입 + 재번호만** — 현 §3(앱-고유 vs 앱-중립) 직후 신규 `## 4. 사용자 데이터 source of truth`(L69–82 · +15 · 91→106) 삽입 → §4 Propagation Discipline→§5 · §5 관련 문서→§6 재번호. **프레이밍 = persistence 아키텍처 원칙**(도메인 정책 X · `SSOT_PRINCIPLES`·`MODEL_SEPARATION` 동족 → 데이터층 침투 가드 §1 L16·§3 L65 무저촉) · 앱별 현 상태/gap = LOCK + 각 repo 데이터층 문서 추적(절 본문 미기재 · 앱 이름 0). **재번호 안전**: 6-repo `COMMON_ARCHITECTURE §4/§5` 인용 grep = 0(유일 sectioned = `rule-routing-index:203 §1` 무변경 · app-implementation-guide:81 무번호 · COLD-history L42 line-ref = 불변) ⇒ 무파손. **검증**: propagate ok=5/0 · verify-sync **160/0/0** byte-identical · 6-repo sha-256 `09d1f173`(pre-edit `d6b46a21`) · 보호 5 sha drift 0(COMMON_ARCHITECTURE 보호 미등재 재확인 PASS · edit-set ∩ 보호 = ∅ · manifest 갱신 불요) · `.kt`/EF/DDL/migration 0 LOC · 제품 SoT 본문 무변경(비전 §1-3 anti-reset = 근거 인용만 · cascade 0) · `LOCK-*` 인용만 · 직전 cycle 잔여 ahead forward-progress 무접촉 · 자식 path-limited(WIP 무혼입). **사고**: 없음(git-lock daemon 미활성 advisory = 직전 PENCIL-SCHEMA §15 기록 패턴 · non-blocking · follow-up launchctl load). **후속(scope 외)**: day-series EF 3앱(`cc-paste-CUMFLOW-BACKEND-DATA-001` v2) + GD hydration(서버→Room read-back) + client wiring = 별 cycle. | **6-repo 적용** (master content `b14b6f5` + 5 자식 propagate byte-identical 1 file: FND `792be92`/GB `2f7d4a5`/GD `847eb5c`/GT `58e1f18`/PDOCS `a843672` · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-DATA-SOT-ARCH-LANDING-001/REPORT.md) |
| MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001 | 2026-06-18 | design SoT(`.pen`/`.ui-spec`) "즉시 갱신 의무 vs deferred(design-debt) 허용" 기준 명확화 + enforce wiring (Mode M5 cli-infra-ops · production 0 LOC · clarify+enforce · 신설 아님 — 기준은 이미 `uiux-sot-refresh.md` FULL/PARTIAL/DOC-ONLY 에 존재). **4 결정(Coin 본심)**: (1) split=신규성 — net-new visual(신규 화면/route 구조/net-new 시각 상태)=즉시 의무 · reuse visual+PARTIAL=deferred 허용 (2) 미출시(user 0)=net-new 도 deferred 허용 · 출시 후 net-new=선행 의무 · release backstop (3) deferred 추적=per-repo `DESIGN-DEBT.md` 원장(ui-spec.schema.json 무접촉) (4) enforce=REVIEW row warn + release 게이트 hard FAIL. **scope 6 file**: 보호 2 (`uiux-sot-refresh.md` "즉시 의무 vs Deferred" 분기 subsection 신설 + 게이트 line REVIEW §1 FAIL→[Design SoT Sync] WARN 재배선 [Gap A 근본원인 = §1 Requirements Coverage 오매핑] · `design-sot-policy.md` §3 code-first 역방향 항→Deferred lane 한정 허용 3-bullet · Phase R 예외 무접촉) + cli-infra 4 (`design-to-code-sync.md` §10 Deferred Design Debt lane 신설[원장 format+등재/해소/backstop+scope 경계] + §4 P11 · `verification-and-review.md` §14 Design SoT Sync row[비블로커] + release backstop note + Low Risk note · `reporting.md §7` ###14 스키마 + Risk note · `rule-routing-index.md §C` row2(UI-UX) M/deviation + row4(빌드-릴리즈) M release backstop + §F). **cross-file token**: 신 REVIEW row "Design SoT Sync" = 3곳(verification-and-review §14 ↔ reporting §7 §14 ↔ rule-routing §C row2) 동일 토큰 정합. **2층 hash resync**: 보호 2 sha-256(uiux `e3b9891d`→`4d0b5279` · dsp `4c566615`→`92a5e998`) + §14a git-sha1(uiux `d2c62265`→`0aeac86d` · dsp `69649a36`→`0d265e0b` · ⚠ algorithm 교차 X) · 나머지 보호 3(ui-spec.schema.json#1 + pencil 2종#4#5) sha 변동 0. **검증**: propagate ok=30/0 · verify-sync **160 PASS / 0 DRIFT** byte-identical(MISS 5 = 본 cycle 무관 pre-existing `docs/ops/` 미추적 = 분류 후 보고 · 자율 해소 X) · production/`ui-spec.schema.json` 0 LOC · 자식 path-limited(WIP 무혼입 — GB 25/GD 6/GT 10 dirty 무접촉). **사고**: PDOCS stale index.lock(0-byte · 7h · git holder 0 · Spotlight read handle만) → reversible `mv` 회수 후 commit(rm deny 정합 · git-lock-cleaner daemon 미load 재발 advisory). **후속(scope 외)**: per-repo `DESIGN-DEBT.md` 실 entry seeding = `3APP-AI-TIER-AD-GATE-DESIGN-RETROFIT-001`(wave ③ ad-gate 5 화면 = net-new×미출시 → deferred 적법 + 등재 의무) · git-lock daemon launchctl load · docs/ops/ 미추적 Coin 검토. | **6-repo 적용** (master content `9e286138` + 5 자식 propagate byte-identical 6 file: FND `094b767`/GB `65e4efc`/GD `61cf600`/GT `c8a673e`/PDOCS `a851f31` · manifest/§14a/§15 = master-only audit commit · propagation-status.md = pre-existing dirt 분리 미commit · REPORT = .ai/reports/MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001/) |
| MASTER-SUPABASE-PROD-APPLY-RECIPE-001 | 2026-06-19 | prod DDL/RLS/EF 적용 경로를 `.claude/rules/supabase-handling.md` 에 "staging 자율 → Coin 명시 승인 → cli prod push" 8-step recipe 로 박제 — 매 세션 재발명 + 토큰 캡처 누락 시 "prod 도달 불가 STOP"(daily_tips GT) 근본 해소 (Mode M5 cli-infra-ops · production 0 LOC · doc(rule) recipe 박제 · **본 row = `HYGIENE-BUNDLE-001` 발견#3 소급 추가** — cycle 자체는 `f31b07b`/`c9c5ff3` 마감 · 전용 §15 row 부재 gap 해소). **scope = `supabase-handling.md`(비보호 · +40/-7)**: ① §3.1 확장 = 8-step recipe(`db push` prod 금지 → Management API `/database/query` `read_only=false` 단일 경로 · prod DB pw slot 부재 · prod 토큰 inline 캡처·env 미적재·즉시 unset · PHASE A read-only 측정 게이트 · schema_migrations INSERT + 수렴 verify) ② §10.5 정정 = staging 토큰(`supabase-g{b,d,t}-token` env 상시 inject) vs prod 토큰(`supabase-g{b,d,t}-prod-token` 별 slot·inline 캡처·env 미적재) 2-tier 구분 ③ §5 STOP = prod write 승인/토큰/PHASE A 게이트 정정 ④ §9 history. **검증 선례**: `GT-USERS-FK-RESTORE-001`(Management API · parity 14/14 · prod history 12→13) / `GB·GD-PROD-APPLY-001`(EF prod deploy · GD prod DB pw slot 부재 실측). **검증**: `supabase-handling.md`(비보호) sha-256 `c71ba17`(이전 `a084874d`) · 보호 5 sha drift 0(edit-set ∩ 보호 = ∅) · secret grep 0 · production 0 LOC · verify-sync **159 PASS** · DRIFT 1(`docs/backend` RLS GT committed 분기) + MISS 5(`docs/ops` master-only) = 본 cycle 무관 pre-existing 분리·자율 해소 X. **후속(scope 외)**: `docs/ops` runbook db-push 정정(§3.1 불변식 3 모순) · GT RLS 분기 reconcile · git-lock daemon load. | **6-repo 적용** (master content `f31b07b` + audit `c9c5ff3` + 5 자식 propagate byte-identical 1 file: FND `d61a4c4`/GB `7a32f69`/GD `9185a90`/GT `811e8a4`/PDOCS `265dec1` · `supabase-handling.md` sha `c71ba17` 6-repo byte-identical · 본 §15 row = master-only 소급 추가(propagate X · CLAUDE.md = master-only history) · REPORT = propagation-reports/MASTER-SUPABASE-PROD-APPLY-RECIPE-001/REPORT.md) |
| MASTER-CLI-RLS-GUIDE-DAILY-TIPS-ROW-RECONCILE-001 | 2026-06-19 | `docs/backend/RLS_AND_PLAY_INTEGRITY_GUIDE.md` daily_tips row(line 206) 정합 — GT 직접 편집(committed drift)을 master SoT 로 흡수 후 단방향 propagation 으로 6-repo 수렴 (Mode M5 cli-infra-ops · production 0 LOC · A4 단방향 정합). **본질**: GT 가 자기 copy 의 daily_tips 비고에 추가했던 ` · EF generate-daily-tip persist (GT-AI-FEEDBACK-HISTORY-PERSIST-001 · read=\`gt_daily_tips_select\`)` 주석을 master line 206 에 byte-exact 채택 → master(new) sha-256 `6c47d056` == GT 현행 → propagate 시 GT = no-op 수렴, 나머지 5(master+FND/GB/GD/PDOCS)가 GT 로 수렴. **보호 여부**: 본 file = cli infra 권장 byte-identical (protected-5 아님 — 보호 5 = ui-spec.schema.json + pencil-uiux-workflow + pencil-sot-policy + uiux-sot-refresh + design-sot-policy · `protected-file-hashes.md` 의 RLS guide 행 = "C6 흡수 6 file" list = 권장 영역 · STOP 미발동). **검증**: 단일 line 206 diff(1 ins/1 del) · master==GT byte-exact sha `6c47d056` · propagate ok=5/0 · verify-sync **160 PASS / 0 DRIFT**(MISS 5 = `docs/ops/production-cli-access-tokens.md` master-only 운영 runbook = supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X) · 6-repo target sha `6c47d056` 전수 일치 · production 0 LOC · 자식 path-limited commit(WIP 무혼입 — GB 29/GD 4/GT 13 dirty 무접촉) · index.lock 0. **사고**: app-foundation propagate.sh `git add` silent no-op(`|| true` swallow · porcelain ` M` unstaged) → commit step path-limited `git add` 자체 회수(WORKTREE-PARADIGM §15 후속 "propagate.sh add silent-fail surface" 실증). **후속(scope 외)**: 직전 `MASTER-SUPABASE-PROD-APPLY-RECIPE-001` §15 row 부재(pre-existing gap · Coin 판단) · git-lock daemon launchctl load · §15 hot 11>10 cold 재이전 advisory. | **6-repo 적용** (master content `56429d8` + 5 자식 중 4 propagate byte-identical 1 file: FND `4364017`/GB `3d3a9db`/GD `b6f78a9`/PDOCS `751002f` · GT = HEAD `811e8a4` 이미 `6c47d056` committed = no-op 수렴(신 commit 0) · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-RLS-GUIDE-DAILY-TIPS-ROW-RECONCILE-001/REPORT.md) |
| MASTER-CLI-COLTYPE-CONVENTION-001 | 2026-06-20 | `COMMON_ARCHITECTURE.md` §4 끝에 "### 4.1 다중 값 컬럼 타입 표현 규약 (앱-중립 · persistence 한정)" subsection add-only 삽입 + 6-repo byte-identical propagation (Mode M5 cli-infra-ops · production 0 LOC · 문서 한정 · Coin §3 逐字 contract). **본질**: 생태계 운영 중 표현 규약(문자열 리스트=`TEXT[]` / 중첩·객체=`JSONB` / 단일 스칼라=scalar / 신 다중값=`TEXT[]` 기본·중첩 필요 시 `JSONB` 승격)을 앱-중립 SoT(§4 server-authoritative 근거 문단 뒤·§5 구분선 앞)에 명문화. 도메인 의미(verbatim recognition·enum 라벨)는 본 절 밖(각 앱 design SoT·product 원칙) 명시 = persistence 표현 한정. **scope**: master 원본 1 + 5 자식 propagate = `COMMON_ARCHITECTURE.md` 단일 (보호 5종 아님 = cli infra 권장 byte-identical · `protected-file-hashes.md` 갱신 불요 · STOP #5 무관). **검증**: add-only diff +11 ins/0 del(기존 줄 0 변경 · §4 근거 문단·§5 Propagation Discipline·전 절 무접촉) · master content sha-256 `09d1f173`→`6177dda1` · propagate ok=5/0 · verify-sync **160 PASS / 0 DRIFT**(MISS 5 = `docs/ops/production-cli-access-tokens.md` master-only 운영 runbook = supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X) · 6-repo `COMMON_ARCHITECTURE` sha `6177dda1` 전수 일치(unique sha 1값) · production/DDL/migration 0 LOC · 자식 path-limited commit(WIP 무혼입 — GB/GD/GT `supabase/.temp`·`.ai/reports` dirty 무접촉) · index.lock 0. **사고**: 없음(verify-sync git-lock daemon 미활성 advisory = 비차단 · follow-up launchctl load · PENCIL-SCHEMA/DATA-SOT-ARCH §15 패턴 정합). **후속(scope 외)**: 별 cycle T-A⑵ = GT `food_restrictions`/`food_preferences` plain TEXT outlier → `TEXT[]` 정리 · git-lock daemon launchctl load · §15 hot 12>10 cold 재이전 advisory. | **6-repo 적용** (master content `bf2487d` + 5 자식 propagate byte-identical 1 file: FND `cab7e4e`/GB `d6d1a30`/GD `b113a2f`/GT `7aea253`/PDOCS `61dfe25` · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-COLTYPE-CONVENTION-001/REPORT.md) |
| MASTER-CLI-CROSSREPO-RECONCILE-AUTONOMY-PARADIGM-001 | 2026-06-22 | cross-repo 운영 paradigm 2 신설 (Mode M5 cli-infra-ops · production 0 LOC · doctrine-only · Coin 본심 = req1+req2 한 쌍 · 정합 강도 advisory). **req1 동족 구현 정합 advisory 층**: 같은 맥락(동일 개념/feature/contract)을 2+ repo 에 구현한 결과를 paste-back 회수 시점에 3-bucket(공통화 권장/분리 유지/보류·본심) 비교·권장하는 **사후 surface** · auto-converge 금지 · 도메인 구현 정합 doctrine 부재(§4.2 source 행·§4.3 lazy 항이 명시한 자식 자율 위 빈자리) 채움. **req2 cli HOW 자율 확대(범위 한정)**: cli session 도메인 구현 HOW §FREEDOM 전면 자율 명시(방식/명령/편집 순서/알고리즘) + paste source HOW-leak 측정 · 단 자율 = **도메인 HOW 한정**(STOP9 #1 Money/Auth/DB·보호5·cli-infra byte-identical A4 미확대) · 전제 = req1 advisory 안전망(사후 비교가 divergence catch). **scope 4 rule file**: `cross-repo-parallel-exec-detail.md`(§4 intro 3층 구분[정확성 cross-verify §4.1 ≠ 구현 정합 §4.4 ≠ cli-infra byte-identical §4.2/A4] + §4.4 동족 구현 정합 advisory 신설 · §4.2/§4.3 도메인 자율 본문 무접촉 +27/-0) + `cross-repo-parallel-exec.md`(kernel §2 영역 bullet 에 1-bullet pointer · 본문 canonical = detail §4.4 단일) + `anchor-list.md`(A8 동족 구현 정합 advisory step + A10 cli HOW §FREEDOM 자율 폭·paste source HOW-leak GSM-M·자율=도메인 HOW 한정 경계 · **신 hot anchor 0** = hot 10 baseline 유지 P0 6+P1 4) + `reporting.md`(§14 동족 구현 정합 surface 규약 신설 + dispatch checklist detail §2.2.1 step 5 정합 · 형식만 소유). **HARD 경계 보존 3종**: ① detail §4.2/§4.3 도메인 자율 default 본문 무접촉(diff +만·삭제 0) ② 보호 5 sha drift 0(edit-set ∩ 보호 = ∅ · git-sha1 §14a 5/5 baseline 정합) ③ req2 자율 = 도메인 HOW 한정(STOP/Money/Auth/DB/보호5/A4 미확대 · A10 M 명시). **검증**: propagate ok=20/0 · verify-sync **160 PASS / 0 DRIFT**(MISS 5 = `docs/ops/production-cli-access-tokens.md` master-only 운영 runbook = supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X) · 6-repo shasum -a 256 byte-identical(detail `5666f7f5` · kernel `8bec1d88` · anchor `b7a67325` · reporting `351f9d74`) · production/도메인 0 LOC · 자식 path-limited commit(WIP 무혼입) · index.lock 0. **사고**: 없음(git-lock daemon 미활성 advisory = 비차단 · follow-up launchctl load). **후속(scope 외)**: A body/B body cowork 영역 갱신(§B-5 enforcement 반영 = WHAT/HOW 경계) = cowork follow-up(본 cli cycle scope X) · git-lock daemon launchctl load · §15 hot 13>10 cold 재이전 advisory. | **6-repo 적용** (master content `a6f27f4` + 5 자식 propagate byte-identical 4 file: GB `bd4a3bf`/GD `8f448c7`/GT `f50e978`/FND `5b02672`/PDOCS `fd678b3` · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-CROSSREPO-RECONCILE-AUTONOMY-PARADIGM-001/REPORT.md) |

> **§15 cold 재배치** (= `MASTER-CLI-CONTEXT-OPT-PHASE1-CYCLE-HISTORY-COLD-001` 2026-06-01 + `MASTER-CLI-CONTEXT-OPT-CYCLE-HISTORY-COLD-002` 2026-06-04 2회차 + `MASTER-S15-PRELAUNCH-EXEC2-B-001` 2026-06-05 3회차 + `MASTER-S15-PRELAUNCH-EXEC3-001` 2026-06-05 4회차 + `MASTER-S15-PRELAUNCH-EXEC3-002` 2026-06-05 5회차 + `MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001` 2026-06-10 6회차 + `MASTER-CLI-S15-HOT-DEMOTE-003` 2026-06-11 7회차): 위 표 = 최근 5 entry + 본 cycle entry 만 hot 유지 default. master cycle **111 entry 전체 이력** (= `C1-MASTER-BOOTSTRAP-001` ~ `MASTER-CLI-PROTECTED-STALE-PATH-FIX-001`) = verbatim 보존 → [`.auto-memory/master-cycle-history-COLD.md`](.auto-memory/master-cycle-history-COLD.md) (= 삭제 0 · 감사 추적 영구 보존 · lifecycle = 매 5 cycle 또는 분기 review). 신규 master cycle = 본 표 append (§16 절차) + hot > 10 도달 시 cold 재이전 (= `measure-gsm-cycle.sh` Stop hook 자동 advisory surface · 판정·이전 = 수동).

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
