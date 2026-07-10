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

- **3 앱 = 도메인별 독립 사용자 + 공유 인프라 default** (L1-3 정합 default). GB (= 마음 가꾸기) + GD (= 배움) + GT (= 몸 돌봄) 측 사용자 base 분리 default · "한 사용자가 3 앱 묶어서 산다" 가설 무효 default. 공유 = cli infra + app-foundation default. 미공유 = 사용자 base default.
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
| GentlyBreath (GB) | 마음 가꾸기 | `com.example.gentlybreath` | `<PARENT>/GentlyBreath` |
| GentlyDay (GD · 앱 GentlyLearn) | 배움 | `com.example.gentlyday` | `<PARENT>/GentlyDay` |
| GentlyTable (GT) | 몸 돌봄 | `com.example.gentlytable` | `<PARENT>/GentlyTable` |

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
| MASTER-SUPABASE-PROD-APPLY-RECIPE-001 | 2026-06-19 | prod DDL/RLS/EF 적용 경로를 `.claude/rules/supabase-handling.md` 에 "staging 자율 → Coin 명시 승인 → cli prod push" 8-step recipe 로 박제 — 매 세션 재발명 + 토큰 캡처 누락 시 "prod 도달 불가 STOP"(daily_tips GT) 근본 해소 (Mode M5 cli-infra-ops · production 0 LOC · doc(rule) recipe 박제 · **본 row = `HYGIENE-BUNDLE-001` 발견#3 소급 추가** — cycle 자체는 `f31b07b`/`c9c5ff3` 마감 · 전용 §15 row 부재 gap 해소). **scope = `supabase-handling.md`(비보호 · +40/-7)**: ① §3.1 확장 = 8-step recipe(`db push` prod 금지 → Management API `/database/query` `read_only=false` 단일 경로 · prod DB pw slot 부재 · prod 토큰 inline 캡처·env 미적재·즉시 unset · PHASE A read-only 측정 게이트 · schema_migrations INSERT + 수렴 verify) ② §10.5 정정 = staging 토큰(`supabase-g{b,d,t}-token` env 상시 inject) vs prod 토큰(`supabase-g{b,d,t}-prod-token` 별 slot·inline 캡처·env 미적재) 2-tier 구분 ③ §5 STOP = prod write 승인/토큰/PHASE A 게이트 정정 ④ §9 history. **검증 선례**: `GT-USERS-FK-RESTORE-001`(Management API · parity 14/14 · prod history 12→13) / `GB·GD-PROD-APPLY-001`(EF prod deploy · GD prod DB pw slot 부재 실측). **검증**: `supabase-handling.md`(비보호) sha-256 `c71ba17`(이전 `a084874d`) · 보호 5 sha drift 0(edit-set ∩ 보호 = ∅) · secret grep 0 · production 0 LOC · verify-sync **159 PASS** · DRIFT 1(`docs/backend` RLS GT committed 분기) + MISS 5(`docs/ops` master-only) = 본 cycle 무관 pre-existing 분리·자율 해소 X. **후속(scope 외)**: `docs/ops` runbook db-push 정정(§3.1 불변식 3 모순) · GT RLS 분기 reconcile · git-lock daemon load. | **6-repo 적용** (master content `f31b07b` + audit `c9c5ff3` + 5 자식 propagate byte-identical 1 file: FND `d61a4c4`/GB `7a32f69`/GD `9185a90`/GT `811e8a4`/PDOCS `265dec1` · `supabase-handling.md` sha `c71ba17` 6-repo byte-identical · 본 §15 row = master-only 소급 추가(propagate X · CLAUDE.md = master-only history) · REPORT = propagation-reports/MASTER-SUPABASE-PROD-APPLY-RECIPE-001/REPORT.md) |
| MASTER-CLI-RLS-GUIDE-DAILY-TIPS-ROW-RECONCILE-001 | 2026-06-19 | `docs/backend/RLS_AND_PLAY_INTEGRITY_GUIDE.md` daily_tips row(line 206) 정합 — GT 직접 편집(committed drift)을 master SoT 로 흡수 후 단방향 propagation 으로 6-repo 수렴 (Mode M5 cli-infra-ops · production 0 LOC · A4 단방향 정합). **본질**: GT 가 자기 copy 의 daily_tips 비고에 추가했던 ` · EF generate-daily-tip persist (GT-AI-FEEDBACK-HISTORY-PERSIST-001 · read=\`gt_daily_tips_select\`)` 주석을 master line 206 에 byte-exact 채택 → master(new) sha-256 `6c47d056` == GT 현행 → propagate 시 GT = no-op 수렴, 나머지 5(master+FND/GB/GD/PDOCS)가 GT 로 수렴. **보호 여부**: 본 file = cli infra 권장 byte-identical (protected-5 아님 — 보호 5 = ui-spec.schema.json + pencil-uiux-workflow + pencil-sot-policy + uiux-sot-refresh + design-sot-policy · `protected-file-hashes.md` 의 RLS guide 행 = "C6 흡수 6 file" list = 권장 영역 · STOP 미발동). **검증**: 단일 line 206 diff(1 ins/1 del) · master==GT byte-exact sha `6c47d056` · propagate ok=5/0 · verify-sync **160 PASS / 0 DRIFT**(MISS 5 = `docs/ops/production-cli-access-tokens.md` master-only 운영 runbook = supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X) · 6-repo target sha `6c47d056` 전수 일치 · production 0 LOC · 자식 path-limited commit(WIP 무혼입 — GB 29/GD 4/GT 13 dirty 무접촉) · index.lock 0. **사고**: app-foundation propagate.sh `git add` silent no-op(`|| true` swallow · porcelain ` M` unstaged) → commit step path-limited `git add` 자체 회수(WORKTREE-PARADIGM §15 후속 "propagate.sh add silent-fail surface" 실증). **후속(scope 외)**: 직전 `MASTER-SUPABASE-PROD-APPLY-RECIPE-001` §15 row 부재(pre-existing gap · Coin 판단) · git-lock daemon launchctl load · §15 hot 11>10 cold 재이전 advisory. | **6-repo 적용** (master content `56429d8` + 5 자식 중 4 propagate byte-identical 1 file: FND `4364017`/GB `3d3a9db`/GD `b6f78a9`/PDOCS `751002f` · GT = HEAD `811e8a4` 이미 `6c47d056` committed = no-op 수렴(신 commit 0) · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-RLS-GUIDE-DAILY-TIPS-ROW-RECONCILE-001/REPORT.md) |
| MASTER-CLI-COLTYPE-CONVENTION-001 | 2026-06-20 | `COMMON_ARCHITECTURE.md` §4 끝에 "### 4.1 다중 값 컬럼 타입 표현 규약 (앱-중립 · persistence 한정)" subsection add-only 삽입 + 6-repo byte-identical propagation (Mode M5 cli-infra-ops · production 0 LOC · 문서 한정 · Coin §3 逐字 contract). **본질**: 생태계 운영 중 표현 규약(문자열 리스트=`TEXT[]` / 중첩·객체=`JSONB` / 단일 스칼라=scalar / 신 다중값=`TEXT[]` 기본·중첩 필요 시 `JSONB` 승격)을 앱-중립 SoT(§4 server-authoritative 근거 문단 뒤·§5 구분선 앞)에 명문화. 도메인 의미(verbatim recognition·enum 라벨)는 본 절 밖(각 앱 design SoT·product 원칙) 명시 = persistence 표현 한정. **scope**: master 원본 1 + 5 자식 propagate = `COMMON_ARCHITECTURE.md` 단일 (보호 5종 아님 = cli infra 권장 byte-identical · `protected-file-hashes.md` 갱신 불요 · STOP #5 무관). **검증**: add-only diff +11 ins/0 del(기존 줄 0 변경 · §4 근거 문단·§5 Propagation Discipline·전 절 무접촉) · master content sha-256 `09d1f173`→`6177dda1` · propagate ok=5/0 · verify-sync **160 PASS / 0 DRIFT**(MISS 5 = `docs/ops/production-cli-access-tokens.md` master-only 운영 runbook = supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X) · 6-repo `COMMON_ARCHITECTURE` sha `6177dda1` 전수 일치(unique sha 1값) · production/DDL/migration 0 LOC · 자식 path-limited commit(WIP 무혼입 — GB/GD/GT `supabase/.temp`·`.ai/reports` dirty 무접촉) · index.lock 0. **사고**: 없음(verify-sync git-lock daemon 미활성 advisory = 비차단 · follow-up launchctl load · PENCIL-SCHEMA/DATA-SOT-ARCH §15 패턴 정합). **후속(scope 외)**: 별 cycle T-A⑵ = GT `food_restrictions`/`food_preferences` plain TEXT outlier → `TEXT[]` 정리 · git-lock daemon launchctl load · §15 hot 12>10 cold 재이전 advisory. | **6-repo 적용** (master content `bf2487d` + 5 자식 propagate byte-identical 1 file: FND `cab7e4e`/GB `d6d1a30`/GD `b113a2f`/GT `7aea253`/PDOCS `61dfe25` · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-COLTYPE-CONVENTION-001/REPORT.md) |
| MASTER-CLI-CROSSREPO-RECONCILE-AUTONOMY-PARADIGM-001 | 2026-06-22 | cross-repo 운영 paradigm 2 신설 (Mode M5 cli-infra-ops · production 0 LOC · doctrine-only · Coin 본심 = req1+req2 한 쌍 · 정합 강도 advisory). **req1 동족 구현 정합 advisory 층**: 같은 맥락(동일 개념/feature/contract)을 2+ repo 에 구현한 결과를 paste-back 회수 시점에 3-bucket(공통화 권장/분리 유지/보류·본심) 비교·권장하는 **사후 surface** · auto-converge 금지 · 도메인 구현 정합 doctrine 부재(§4.2 source 행·§4.3 lazy 항이 명시한 자식 자율 위 빈자리) 채움. **req2 cli HOW 자율 확대(범위 한정)**: cli session 도메인 구현 HOW §FREEDOM 전면 자율 명시(방식/명령/편집 순서/알고리즘) + paste source HOW-leak 측정 · 단 자율 = **도메인 HOW 한정**(STOP9 #1 Money/Auth/DB·보호5·cli-infra byte-identical A4 미확대) · 전제 = req1 advisory 안전망(사후 비교가 divergence catch). **scope 4 rule file**: `cross-repo-parallel-exec-detail.md`(§4 intro 3층 구분[정확성 cross-verify §4.1 ≠ 구현 정합 §4.4 ≠ cli-infra byte-identical §4.2/A4] + §4.4 동족 구현 정합 advisory 신설 · §4.2/§4.3 도메인 자율 본문 무접촉 +27/-0) + `cross-repo-parallel-exec.md`(kernel §2 영역 bullet 에 1-bullet pointer · 본문 canonical = detail §4.4 단일) + `anchor-list.md`(A8 동족 구현 정합 advisory step + A10 cli HOW §FREEDOM 자율 폭·paste source HOW-leak GSM-M·자율=도메인 HOW 한정 경계 · **신 hot anchor 0** = hot 10 baseline 유지 P0 6+P1 4) + `reporting.md`(§14 동족 구현 정합 surface 규약 신설 + dispatch checklist detail §2.2.1 step 5 정합 · 형식만 소유). **HARD 경계 보존 3종**: ① detail §4.2/§4.3 도메인 자율 default 본문 무접촉(diff +만·삭제 0) ② 보호 5 sha drift 0(edit-set ∩ 보호 = ∅ · git-sha1 §14a 5/5 baseline 정합) ③ req2 자율 = 도메인 HOW 한정(STOP/Money/Auth/DB/보호5/A4 미확대 · A10 M 명시). **검증**: propagate ok=20/0 · verify-sync **160 PASS / 0 DRIFT**(MISS 5 = `docs/ops/production-cli-access-tokens.md` master-only 운영 runbook = supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X) · 6-repo shasum -a 256 byte-identical(detail `5666f7f5` · kernel `8bec1d88` · anchor `b7a67325` · reporting `351f9d74`) · production/도메인 0 LOC · 자식 path-limited commit(WIP 무혼입) · index.lock 0. **사고**: 없음(git-lock daemon 미활성 advisory = 비차단 · follow-up launchctl load). **후속(scope 외)**: A body/B body cowork 영역 갱신(§B-5 enforcement 반영 = WHAT/HOW 경계) = cowork follow-up(본 cli cycle scope X) · git-lock daemon launchctl load · §15 hot 13>10 cold 재이전 advisory. | **6-repo 적용** (master content `a6f27f4` + 5 자식 propagate byte-identical 4 file: GB `bd4a3bf`/GD `8f448c7`/GT `f50e978`/FND `5b02672`/PDOCS `fd678b3` · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-CROSSREPO-RECONCILE-AUTONOMY-PARADIGM-001/REPORT.md) |
| MASTER-CLI-AUTH-DOMAIN-RECONCILE-001 | 2026-06-22 | GD Auth 도메인 활성화(W3) + `auth-rules.md` §5 export↔restore/import 분기 명확화(W8) (Mode M5 cli-infra-ops · production 0 LOC · doc(rule) 2 file · GD 라이브 anon bootstrap 실측 기반). **W3 (`deferred-domains.md`)**: §2 매트릭스 Auth 행 GD `UNKNOWN`→**`ACTIVE`⁴** + footnote ⁴ 신설(foundation `AnonymousAuthBootstrap` + `signInAnonymously` · per-token `SecureTokenStore` · `GentlyDayApplication.onCreate` `restoreSession()` 단일 진입점 + `SplashViewModel` 15s timeout observe) + §6 이력 entry. **라이브 실측 PASS**(A7 filename+content dual grep): `GentlyDayApplication.kt:85` `restoreSession()` → `AuthModule.kt:34` foundation `AnonymousAuthBootstrap` DI → `SupabaseAuthRepository.kt:26` `bootstrapAsync()` → `AnonymousAuthBootstrap.kt:73` `signInAnonymously()` · `SplashViewModel.kt:169` `SPLASH_BOOTSTRAP_TIMEOUT_MS = 15_000L` · legacy `com.example.gentlyday.auth` = dead `app/` 모듈(build.gradle.kts 부재). GB(MASTER-GB-AUTH-ACTIVATE-001) 선례 정합 · GB³/GT¹ footnote 정합 · auth-security-privacy agent 의무 = vacuous(이미 globally active) · **Data/Backend/Perf row 무접촉**. **W8 (`auth-rules.md` §5)**: §5 JSON backup → §5.1 export 경로(live · 3앱 실측 GB `DataExportUseCase`/GD `DataExportRepository`/GT `BuildDataExportUseCase` · `formatVersion` 발행 · `CreateDocument`) + §5.2 restore/import 경로(forward-looking · 미구현 실측 0 match: `BackupError.FormatMismatch`/`exportedFromRepo`/userId 재매핑/`OpenDocument`) 분리. **★§1 30초UX / §6 OAuth Phase2 무접촉**. **검증**: propagate ok=10/0 · verify-sync **160 PASS / 0 DRIFT**(MISS 5 = `docs/ops/production-cli-access-tokens.md` master-only 운영 runbook = supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X) · 6-repo byte-identical(deferred-domains blob `26fce91` · auth-rules blob `1ab0fd9`) · 보호 5 file sha-256 drift 0(edit-set ∩ 보호 = ∅ · 2 file 둘 다 비보호) · production/도메인 0 LOC · 자식 path-limited commit(WIP 무혼입). **STOP 무발동**: Money/Auth **런타임** 무접촉(doc-only) · 보호 sha 무변동 · byte-id 유지. **사고**: 없음(git-lock daemon 미활성 advisory = 비차단 · follow-up launchctl load). **후속(scope 외)**: GD/GT import/restore 실 구현 = 별 trail(§5.2 forward-looking) · git-lock daemon launchctl load · §15 hot 15>10 cold 재이전 advisory. | **6-repo 적용** (master content `0c82899` + 5 자식 propagate byte-identical 2 file: GB `e16f143`/GD `8e611f1`/GT `1f2e5b0`/FND `8694155`/PDOCS `91eea8a` · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-AUTH-DOMAIN-RECONCILE-001/REPORT.md) |
| MASTER-CLI-S15-HOT-DEMOTE-004 | 2026-06-22 | §15 hot 15행 → cold 8회차 재이전 (Mode M5 cli-infra-ops · production 무접촉 · GSM-S15-HOT advisory 발화 hot 15>10 · 선례 `MASTER-CLI-S15-HOT-DEMOTE-003`(7회차) 동형 · master-only). **본질**: hot 15 entry 가운데 오래된 10 (`MASTER-CLI-COMPOUND-LINT-DEPRECATE-001`~`MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001`) 을 `.auto-memory/master-cycle-history-COLD.md` 로 verbatim append (LOSS NONE · §15 제거 10행 = cold 신규 10 entry exact-string 대칭 · git diff removed==added sha `4467778d` 일치) → cold 111→121 · 잔존 hot = 최근 5 (`MASTER-SUPABASE-PROD-APPLY-RECIPE-001`~`MASTER-CLI-AUTH-DOMAIN-RECONCILE-001`) + 본 entry = 6. 표 split 빈 줄 0 (Phase A 진입 시 이미 valid 15행 연속). **동반**: COLD title(line 1) + §1 heading(line 11) + verbatim note(line 13) = 111→121 + lineage `S15-HOT-DEMOTE-004 +10` reconcile · 본 §15 아래 cold 재배치 note(count 111→121 · range 끝 `…PROTECTED-STALE-PATH-FIX-001`→`…DESIGN-SOT-ENFORCEMENT-CRITERIA-001`) · `context-health-metrics.md` §2 갱신 (hot entry 8회차 desc + cold pointer 111→121 + master char 재측정). **검증**: hot 15→6 (`measure-gsm-cycle.sh` awk 실측 · GSM-S15-HOT advisory 재실행 무발화 6 ≤ 10) · 무손실 대칭 10 = 10 exact-string (`sha 4467778d`) · 보호 5 sha drift 0 (edit-set ∩ 보호 = ∅ · 편집 3 file = CLAUDE.md + COLD + context-health = 모두 비보호) · production/도메인 0 LOC · 자식 5 repo 무접촉. **후속(scope 외)**: 다음 hot > 10 도달 시 9회차 재이전 (= advisory · `measure-gsm-cycle.sh` Stop hook 자동 surface). | **master-only** (master 본 commit · §15 / cold / context-health-metrics = master-only · 자식 5 repo 무접촉 · propagation 불요) |
| MASTER-CLI-PENCIL-MULTIREPO-HEADLESS-001 | 2026-06-24 | Pencil `.pen` 처리 SSOT 에 멀티-repo(6-repo umbrella) caveat 명시 (Mode M5 cli-infra-ops · production 0 LOC · doc(rule/skill) add-only · Coin '재발 안 생기도록 pencil 처리 SSOT 명시' 본심 · HOME-PEN-2.13 혼선 근본 mitigation). **본질**: desktop-stdio MCP = single active workspace(관측상 GT-anchored) → 자기 active-workspace 아닌 repo(GB/GD)의 `.pen` 을 MCP(`get_editor_state`/`batch_design` 등)로 측정·편집 시 GT file 반환·편집(오염 risk) → 멀티-repo `.pen` = headless(평문-JSON 또는 `pencil interactive -i/-o`)만 · cross-verify = disk shasum/평문-JSON(`get_editor_state` 금지). ★cross-version 마이그 실증 교정: 버전업(2.11→2.13) ≠ `save()` 재직렬화 — CLI(관측 0.2.6) 입력 `.pen` 을 target schema 검증 → legacy construct 잔존 시 load 실패 → `save()` 0 byte 출력(실파일 파괴 risk · GB home.pen `alignItems:stretch`×1 + inline note×2 실측) → 버전업 = delta-aware 변환만 + 마이그 전 target-invalid token pre-scan 의무(content/layout-affecting 시 STOP+Coin). **scope = 비보호 2 file(add-only)**: `pencil-mcp-tools-reference.md`(§0.2 신설 = rule 1 MCP single workspace + rule 3 cross-verify disk + rule 4 버전업≠save() · +13/-0) + `pencil-cli/SKILL.md`(§7.3 신설 = rule 2 멀티-repo headless 필수 + rule 4 + rule 5 pre-scan · §7.1 분기표 2-row · +15/-0). SSOT 5-rule split = mcp 1·3·4 / skill 2·4·5(rule 4 양쪽 = 양 entry-point 경고 의도 · 본문 복제 X · 상호 pointer). **보호 무접촉**: `pencil-uiux-workflow.md` §2.5(보호 5 중) = headless 기본 이미 선언 = 본 cycle 이 멀티-repo caveat 보강 · 직접 편집 0(edit-set ∩ 보호 = ∅). **검증**: add-only(numstat del=0 둘 다) · 보호 5 file sha drift 0(`git diff --name-only` 5/5 = 0 changed) · degeneration warn-only(exit 0 · 도메인 어휘 headless/desktop/호출) · propagate ok=10/0 · verify-sync **160 PASS / 0 DRIFT**(MISS 5 = `docs/ops/production-cli-access-tokens.md` master-only 운영 runbook = supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X) · 6-repo byte-identical(mcp sha-256 `241c76b7` · skill `be9cc5c5`) · production/도메인 0 LOC · 자식 path-limited commit(WIP 무혼입 — GB/GD/GT `supabase/.temp`·`.ai/reports`·incident-log dirty 무접촉 · 각 commit name-only = 2 file exact). **사고**: 자식 5 repo `.git/index.lock`(0-byte no-PID · Jun 23 stale · propagate.sh `git add` silent no-op 후 ` M` unstaged 정합) → `scripts/git-safe.sh`(sanctioned wrapper · dead-PID/no-PID >5s 정리) 경유 정리 후 path-limited commit(live git proc 0 확인 후 · STOP #4 미발동 = 0-byte no-PID 확정 stale). **후속(scope 외)**: git-lock daemon launchctl load(verify-sync advisory 재발화) · `pencil-cli` SKILL §7.2 "12+1 도구 surface" stale count(현 9종 · 별 cycle) · §15 hot 7 ≤ 10(cold 재이전 불요). | **6-repo 적용** (master content `50975f3` + 5 자식 propagate byte-identical 2 file: GB `aa43144`/GD `124155f`/GT `2f8a1c7`/FND `d2e1de1`/PDOCS `eb6b30a` · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-PENCIL-MULTIREPO-HEADLESS-001/REPORT.md) |
| MASTER-CLI-PENCIL-SCHEMA-DELTA-AUGMENT-001 | 2026-06-24 | `pencil-pen-format-schema.md` §1.1a 2.11→2.13 structural delta 목록 8→10 보강 (Mode M5 cli-infra-ops · production 0 LOC · doc(rule) 1 file · 비보호 · HOME-PEN-2.13-MIGRATE `save()` 0-byte 함정 재발 차단 · cowork contract `cc-paste-MASTER-CLI-PENCIL-SCHEMA-DELTA-AUGMENT-001`). **본질**: GB home.pen CLI `save()` 0-byte 사고 = §1.1a 8건 에 **없는** 실측 2건이 원인 → 표 augment(추가만). **scope = `pencil-pen-format-schema.md`(비보호 · +6/-1 = 추가만 · 1 del = 헤더 "8 건"→"10 건")**: ① §1.1a 표 row 9 = Layout `alignItems` enum `stretch` 제거 → `[start\|center\|end]` (cross-axis 채움 = 2.13 별 idiom) ② row 10 = inline `note` property 제거 → `Note` entity[`type:"note"` §2.6] / `*.ui-spec.json` companion ③ 측정 출처/content-affecting 각주 신설 (= delta-aware + visual parity 마이그 의무 · mechanical 치환 ❌ · 정확 idiom = live 2.13 schema 확인 · `pencil-mcp-tools-reference.md §0.2` rule 4 + `pencil-cli` skill §7.3 pre-scan 정합) ④ §9 cycle entry. **무접촉**: 기존 8 row · version `"2.13"` label · body §2~§5 (2.11-shape PENDING) · (minor) union-count 13 · 형제 Pencil rule 4종 = 전면 rewrite = MASTER-CLI-PENCIL-SCHEMA-UPDATE-001 별 cycle 불변. **실측 출처**: HOME-PEN-2.13-MIGRATE(2026-06-23) GB home.pen(2.11) `alignItems:"stretch"`×1 + inline `note`×2 · GT 11 .pen(2.13) `stretch` 0 · CLI validator reject 양건 · 본 cycle live `get_editor_state(include_schema:true)` 시도 = "no open file"(편집기 미열림) → prior cowork disk 실측 근거 채택(paste-back 명시 · row 는 정확 idiom 미단정 = 마이그 시 live 확인 의무로 hedge). **검증**: additions-only(numstat 6/1 · 1 del = 헤더 count) · 기존 8 row 삭제 0 · 보호 5 file git-sha1 drift 0(edit-set ∩ 보호 = ∅ · 비보호 file) · production/도메인 0 LOC · propagate ok=5/0 · verify-sync **160 PASS / 0 DRIFT**(MISS 5 = `docs/ops/production-cli-access-tokens.md` master-only 운영 runbook = supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X) · `pencil-pen-format-schema.md` sha-256 `46edcac0` 6-repo byte-identical(unique sha 1값) · 자식 path-limited commit(WIP 무혼입 — GB 43/GD 18/GT 25 dirty 무접촉). **사고**: 없음(직전 `MASTER-CLI-PENCIL-MULTIREPO-HEADLESS-001` audit `9460563` 이 측정 window 중 동시 commit → 본 §15 entry 초기 위치/카운트(hot 7) 오기 → 본 reconcile 로 정정(MULTIREPO 뒤 재배치 + hot 8) · git-lock daemon 미활성 advisory = 비차단 · follow-up launchctl load). **후속(scope 외)**: body §2~§5 2.11→2.13 전면 rewrite + 형제 Pencil rule 4종 정합 = MASTER-CLI-PENCIL-SCHEMA-UPDATE-001 별 cycle · git-lock daemon launchctl load · §15 hot 8 (≤10 · cold 재이전 불요). | **6-repo 적용** (master content `7e214c7` + 5 자식 propagate byte-identical 1 file: GB `60e4f48`/GD `ea3e219`/GT `3455353`/FND `69d830f`/PDOCS `b2cd60c` · `pencil-pen-format-schema.md` sha-256 `46edcac0` 6-repo byte-identical · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-PENCIL-SCHEMA-DELTA-AUGMENT-001/REPORT.md) |
| MASTER-CLI-PENCIL-PRESCAN-EXHAUSTIVE-001 | 2026-06-24 | Pencil 버전업 pre-scan 전수화 + post-check assert 신설 (Mode M5 cli-infra-ops · production 0 LOC · doc(skill/rule) 2 file · 비보호 · ONBOARDING-2.13 GB onboarding.pen `thickness`×7 미flatten = inconsistent 2.13 재발 근본 차단 · cowork contract `cc-paste-MASTER-CLI-PENCIL-PRESCAN-EXHAUSTIVE-001`). **본질**: GB onboarding.pen = version `"2.13"`인데 nested stroke 7개(§1.1a #5 stroke-flatten) 미적용 = inconsistent 2.13. 원인 = pre-scan을 rule 5 **예시 토큰(stretch/note/line/icon_font)에 한정** → §1.1a delta 미열거분(특히 #5) 누락 + 마이그 후 **post-check 부재** + `json.load` 통과를 2.13-valid로 오인(syntax만). **scope = 비보호 2 file(add-only 위주)**: ① `pencil-cli` skill §7.3 (= 본문 canonical · +13/-4) — rule 5 = target-invalid 점검을 **§1.1a delta 1~10 전수**로 강화(예시 한정 금지 · mechanical[#1~#8] delta-aware 적용 / content-affecting[#9 `alignItems:stretch` · #10 inline `note`] STOP+Coin) + rule 6 신설 = 마이그 후 version `"2.13"` 선언·dual-sha resync·commit 전 **모든 2.11-form construct grep=0 assert**(최소 set `thickness`[#5]/`icon_font`·`iconFontName`·`iconFontFamily`[#2]/`"type":"line"`[#1]/`alignItems:"stretch"`[#9]/inline `"note":`[#10] · ≠0=미완 → mechanical 보강 후 재check / content-affecting STOP+Coin · ★`json.load` 통과 = syntax-valid ≠ 2.13-schema-valid 명시 · #3 script·#6 shader = 2.13-신규 post-check N/A · #4·#7·#8 = form-shape delta manual) + 헤더 SSOT 6-rule(소관 2·4·5·6) + footer canonical rule 2/4/5/6 + §7.1 cross-version row post-check 반영 ② `pencil-mcp-tools-reference.md` §0.2 (= pointer only · +3/-2) — rule 4 말미 post-check pointer 1줄(본문 canonical = skill §7.3 rule 6) + footer 5-rule→6-rule + pre-scan "§1.1a delta 1~10 전수" 명시. **무접촉**: 기존 rule 1~5 의미(5 강화 + 6 신설) · §1.1a 본문(`pencil-pen-format-schema.md` · 참조만 무편집) · 형제 Pencil rule 잔여 · 도구 surface 9종. **검증**: numstat add 위주(skill +13/-4 · mcp +3/-2 · 편집 중 typo 1건 즉정정) · 보호 5 file sha-256 drift 0(edit-set ∩ 보호 = ∅ · 8502c01/4d0b527/92a5e99/b09b8d5/2bfc81c5 baseline 정합) · production/도메인 0 LOC · degeneration warn-only(exit 0 · `delta`/`form` = §1.1a 열거 domain-essential) · propagate ok=10/0 · verify-sync **160 PASS / 0 DRIFT**(MISS 5 = `docs/ops/production-cli-access-tokens.md` master-only 운영 runbook = supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X) · pencil-cli SKILL.md sha-256 `1f190de5` + pencil-mcp-tools-reference.md `28c971b0` 6-repo byte-identical(unique sha 각 1값) · 자식 path-limited commit(WIP 무혼입 · index.lock 0). **사고**: 없음(편집 중 `멀티-repo` typo 1건 즉시 정정 · git-lock daemon 미활성 advisory = 비차단 · follow-up launchctl load). **후속(scope 외)**: body §2~§5 2.11→2.13 rewrite = MASTER-CLI-PENCIL-SCHEMA-UPDATE-001 별 cycle · git-lock daemon launchctl load · §15 hot 9 (≤10 · cold 재이전 불요). | **6-repo 적용** (master content `f01a90b` + 5 자식 propagate byte-identical 2 file: GB `961afff`/GD `b07d16e`/GT `ac1dcb8`/FND `8804982`/PDOCS `01b8b99` · skill sha-256 `1f190de5` · mcp sha-256 `28c971b0` 6-repo byte-identical · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-PENCIL-PRESCAN-EXHAUSTIVE-001/REPORT.md) |
| 3APP-DOMAIN-REDEFINE-GD-GT-001 | 2026-06-27 | 3 앱 도메인 라벨 재정의 (Mode M5 cli-infra-ops · production 0 LOC · doc relabel only · GD·GT 재정의 + GB 호흡 정렬 · Coin 명시 지시). **본질**: GB 호흡→마음 가꾸기 · GD 일상→하루 리듬·루틴 설계 · GT 식단→몸 돌봄 라벨 재정의 (코드 / 도메인 source 무접촉 · 라벨 surface 정합만). **scope = 2 file relabel-only**: ① `claude-cli-master/CLAUDE.md` §0.1 baseline 문장(line 32 · GB/GD/GT 라벨) + §1 자식 repo 등록 표(line 48-50 · 도메인 열 3 row) ② 부모 mount root `../CLAUDE.md` §2 6-repo 역할 표(line 21-23 · 역할 열 + `도메인 =` 값 · GT = 몸 돌봄(식단·움직임·컨디션)). **무변동**: 패키지명 · task ID prefix · 절대 경로 · 코드 · 타 5 repo · gently-product-docs 제품 SoT 본문 (= 별 영역 · 본 cycle scope X). **검증**: relabel only(의미 구조 무변경) · 보호 5 file sha drift 0(edit-set ∩ 보호 = ∅ · CLAUDE.md = 비보호) · production / 도메인 0 LOC · propagate X(= CLAUDE.md master-only history + 부모 root git repo X · `propagate.sh` CLAUDE.md 금지) · 타 repo 무접촉 · §15 hot 10(≤10 · cold 재이전 불요). | **master-only** (claude-cli-master/CLAUDE.md = master-only history · 부모 mount root CLAUDE.md = git repo X · propagation 불요 · 자식 5 repo 무접촉) |
| MASTER-CLI-SOT-NAME-MAP-ACCOMPANIMENT-001 | 2026-07-03 | `sot-code-name-map.md` line 79 GT 화면명 stale-fix — 처방(Prescription)→동행(Accompaniment) client rename(`96f3fe4`) 실코드 parity 정정 + 6-repo 단방향 propagation (Mode M5 cli-infra-ops · production 0 LOC · doc(rule) 1 file · 비보호 · behavior 무변경 doc-only). **본질**: GT 코드가 이미 `Prescription*→Accompaniment*` rename 완료(disk 실측: GT source `Prescription` .kt = 0 · `feature/accompaniment/DailyAccompanimentScreen.kt`+`AccompanimentResultContent.kt` 존재)인데 map line 79 = `daily-prescription-screen \| DailyPrescriptionScreen.kt … PrescriptionResultContent.kt` = 실코드 미반영(stale). 신 design 이름 `daily-accompaniment-screen` = 조율 cc-paste `GT-PEN-ACCOMPANIMENT-PARITY-001`(GT design SoT rename · 순서 무관 독립 repo) 와 1:1 매핑 pattern 일치(`daily-accompaniment-screen ↔ DailyAccompanimentScreen.kt`). **scope = `sot-code-name-map.md`(비보호 · line 79 3 토큰 · 1 ins/1 del)**: daily-prescription-screen→daily-accompaniment-screen · DailyPrescriptionScreen.kt→DailyAccompanimentScreen.kt · PrescriptionResultContent.kt→AccompanimentResultContent.kt. **무접촉**: 카테고리(1:1 직매핑)·라우트((Phase 3 vertical slice)) 셀 · line 79 외 map row(다른 row stale 여부 = 별 판단) · wire literal(route `"prescription"` / `ai_prescription_history` table / `prescription-history-stats` EF / JSON `prescriptionHistory` = code 심볼명만 대상 · 무접촉) · production code. **검증**: line 79 3 토큰 diff(1 ins/1 del · line 79 외 diff 0) · 보호 5 file sha drift 0(edit-set ∩ 보호 = ∅ · sot-code-name-map = cli infra 권장 byte-identical) · production 0 LOC · propagate ok=5/0 · verify-sync **160 PASS / 0 DRIFT**(MISS 5 = `docs/ops/production-cli-access-tokens.md` master-only 운영 runbook = supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X) · `sot-code-name-map.md` sha-256 `fc0a5104`→`3aa71c62` 6-repo byte-identical(unique sha 1값) · 자식 path-limited commit(WIP 무혼입 — GB 118/GD 35/GT 48 dirty 무접촉). **★cross-session**: GT 5 staged 파일(`daily-accompaniment.pen`/`.ui-spec.json` · `home.ui-spec.json` · `light.ui-spec.json` · `screen-flow.md`) = 동시 `GT-PEN-ACCOMPANIMENT-PARITY-001` session WIP → path-limited `git commit -- <map>` 로 무흡수 보존(GT commit name-only = map 단일 실측 · 신 design 이름 일치 corroborate). **STOP#4 gate**: 진입 재측정 line 79 원문 + 6-repo sha `fc0a5104` 정확 일치(paste §0 `Accompaniment=68` vs 실측 430 occ = corroboration-only 차이 · 정정 근거 `Prescription` .kt 0 + 신명 파일 존재 = 불변). **사고**: 없음(git-lock daemon 미활성 advisory = 비차단 · follow-up launchctl load). **후속(scope 외)**: GT design SoT rename = 별 cc-paste `GT-PEN-ACCOMPANIMENT-PARITY-001`(독립 repo · 순서 무관) · 다른 map row stale 여부 = 별 판단 · git-lock daemon launchctl load · §15 hot 11>10 cold 재이전 advisory. | **6-repo 적용** (master content `e1d257d` + 5 자식 propagate byte-identical 1 file: GB `74e665c`/GD `30fb092`/GT `bd44ecf`/FND `848f793`/PDOCS `62f1305` · `sot-code-name-map.md` sha-256 `3aa71c62` 6-repo byte-identical · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-SOT-NAME-MAP-ACCOMPANIMENT-001/REPORT.md) |
| CLAUDEMD-GD-LEARNING-L3-001 | 2026-07-07 | 6-repo 진입점 CLAUDE.md GD 도메인 라벨 "하루 리듬·루틴 설계" → **배움** relabel + 앱명 **GentlyLearn** 병기 (GD 배움 pivot cascade L3 · Mode M5 cli-infra-ops · production 0 LOC · doc relabel only · 선례 = `3APP-DOMAIN-REDEFINE-GD-GT-001` 동형 · 상위 canonical = 비전 `533a9c2` · Coin 확정 2026-07-07). **본질**: GD 앱 pivot(일상·루틴 설계 → 배움)의 진입점 라벨 정합 — repo명 `GentlyDay` + 패키지 `com.example.gentlyday` + `GD-*` task ID prefix 전량 존치, 도메인 라벨 문자열만 교체하고 앱 식별명 GentlyLearn 을 표 1열에 병기. 신 canonical 문자열 = SHORT `배움`(master-tier + 자식 4 CLAUDE.md) / LONG `배움(습득 과정)`(부모 root · 전략 canonical `배움 · 습득 과정` 문체 정합 · GT `몸 돌봄(식단·움직임·컨디션)` 병렬 패턴). **scope (master 세션 = 2 file)**: ① `claude-cli-master/CLAUDE.md` §0.1 baseline 문장(L32 = `GD (= 배움)`) + §1 자식 등록 표(L49 = 도메인 열 `배움` + col1 `GentlyDay (GD · 앱 GentlyLearn)`) + 본 §15 entry ② 부모 mount root `../CLAUDE.md` §2 역할 표(L22 = col1 앱명 병기 + 역할 열 `자식 repo · 배움(습득 과정)` + 본질 열 `도메인 = 배움(습득 과정)`). **자식 4 (별 영역 2 세션 · propagate X)**: FND/GB/GD/GT 각자 `CLAUDE.md` L33 문장 + L50 표 row surgical 편집(master landed 문자열 mirror · 4-way byte-identical 유지) — `propagate.sh` 미사용(CLAUDE.md = dedup 판 · propagate = 파괴 · `feedback_claudemd_not_byteidentical_surgical_edit` 정합). **무변동**: 패키지명 · `GD-*` task ID · repo명/경로/terminal 예시 · §15 기존 이력(L294/L299/L300 = 역사 인용) · 보호 5 file(edit-set ∩ 보호 = ∅ · CLAUDE.md = 비보호) · PDOCS CLAUDE.md(GD 접점 0 실측) · 타 rule/skill/agent file · 코드/도메인 source. **검증**: master 2 file relabel only(의미 구조 무변경) · 대상 외 diff 0 · `하루 리듬`/`루틴 설계` 잔존 = 이력 entry(L299/L300)만 · 보호 5 sha drift 0 · production/도메인 0 LOC · 부모 root sha256 `2b5cde8b90bb…`→`6920a2214084…`(git repo X · git hash-object 아님) · propagate X. **후속(scope 외)**: 자식 4 세션 paste-back 회수 시 cowork cross-verify(4-way sha256 일치) · `하루 리듬` L1 §3.3 표 등 잔존 = 별 판단(본 cycle scope X) · §15 hot 12>10 cold 재이전 advisory. | **6-repo relabel (propagate X)** — master `CLAUDE.md`(L32+L49+§15 = 본 commit) + 부모 mount root `../CLAUDE.md`(git repo X · sha256 `6920a2214084…`) · 자식 4 = 별 영역 2 세션 surgical 편집(byte-identical mirror · 각 세션 별 commit + paste-back) · propagation-reports 없음(propagate 미사용 relabel cycle) |
| MASTER-CLI-CONTEXT-DIET-2-001 | 2026-07-10 | 규칙 코어 다이어트 T1~T8 — cycle당 규칙 정독 char 대폭 감축 · **정보 소실 0** · 안전 조항(STOP·보호·propagation) 불변 (Mode M5 cli-infra-ops · production 0 LOC · Coin 본심 2026-07-10 "불필요 누수 전량 제거 + 권장 전량 반영" · 선행 = CONTEXT-OPT Phase 0~4 + AUTO-DEMOTE-CONTEXT-DIET-001 동형 확장 · cc-paste-MASTER-CONTEXT-DIET2-001). **T1** `cycle-discipline.md` 49,353→12,728 char = per-cycle 실행 규약만 hot (incident 서사/Phase lifecycle/절차 이력 = `.auto-memory/cycle-discipline-COLD.md` **전문 verbatim snapshot** · §21 cross-repo 등 live 조항 보존 · §1~§29 번호 안정 유지) **T2** `rule-routing-table.md` 신설 3,368 char (= §B 독립 실사용 판 · **intake 시 이 표만 정독** · index 전문 = 색인 갱신 cycle 한정) + index §B/§F → table/COLD pointer (36,325→27,213 · §A 46→48 rule 정합 · §B/§F 원문 = `rule-routing-index-COLD.md`) **T3** PLAN 10-sec/REVIEW 12-sec 스키마 = `docs/templates/{plan-10,review-12}-section.template.md` verbatim 분리 (Risk≥Medium 시만 Read · reporting 19,752→14,986) + "N/A 섹션 = 말미 1줄 집계 허용" + 측정 기록 = 판정+수치/sha 12자+원문 pointer (raw verbatim 박제 폐기 · Negative Space·Subagent ≤4k·PromptFit 불변) **T4** abbreviation-policy 의무 로드(L2) 제외 (enforcement SoT = `check-abbreviation.sh` enforce hook · 헤더 1줄 · 실효 −16.5K) **T5** L0 재정독 개정 = **세션 최초 1회 Read → 이후 cycle = SessionStart hook 주입값 + 경량 실측(HEAD·보호 manifest 대조) 갈음 · drift 시만 재Read** (table/index §0 + anchor A1/A2 S 동기 + cycle-discipline §8/§14a hook 인용 우선 · **STOP #5 로직 불변**) **T6** `rule-footer-common.md` 신설 788 char + 20 file 공통 "변경 정책" → 1줄 pointer (파일 고유 이력 존치 · 소실 0) **T7** billing split(2026-06-15) 서술 5곳(anchor A6 · kernel §2.4 · detail §2.2 · workflow-policy · plugin-policy) **"공식 근거 UNVERIFIED (2026-07-10 공식 문서 전수 조회 미발견 · 현행 공식 = 전 표면 구독 합산)" 병기** — 행동 규정(`claude -p` 0 · sub-agent ≤3) 불변 **T8** 세션 운영 P0 3줄 = cycle-discipline §12 신설 (① 세션 중 `/model`·`/effort` 전환 금지 = intake 시 확정·캐시 키 ② cycle 경계 `/clear`·방향 전환 `/rewind` ③ CC 업그레이드 직후 old session resume 금지 = 신 세션+Mode 7). **검증**: verbatim diff 4/4 DIFF0-PASS + 표본 grep 15/15 (계약 ≥10 상회) · 보호 5 sha drift 0 (edit-set ∩ 보호 = ∅ · manifest 갱신 불요 · 8502c014/b09b8d50/2bfc81c5/4d0b5279/92a5e998 실측 일치) · production/도메인 0 LOC · rule 의미 변경 0 (= 배치/로드 시점만) · **Mode 1 가정 정독 합계 235,005→145,199 (세션 최초 · −38%) / 107,180 (세션 2+ cycle · −54%)** · propagate ok=150/0 (30 file × 5) · verify-sync **164 PASS / 0 DRIFT** (MISS 5 = `docs/ops/production-cli-access-tokens.md` master-only runbook = supabase-handling §3.1 의도적 제외 · pre-existing · exit 1 = MISS 한정 비차단 · 자율 해소 X) · 자식 path-limited commit 30 file exact (name-only 실측 · WIP 무혼입 · 잔여 staged 0). **§0 gate**: 자식 3 (GB/GD/GT) paste 발행 후 전진 = 도메인 commit 만 · 대상 rule 무접촉 → forward-progress (STOP#5 미발동). **사고**: 없음 (git-lock daemon 미활성 advisory = 비차단 · 자식 commit 시 zsh 미분할로 수동 `git add` fatal — propagate.sh 선행 stage 가 정확히 30 file 커버 = name-only 실측 무결). **후속(scope 외)**: session-start hook 에 HEAD·보호 sha additionalContext 주입 보강 (T5 실효 강화 · hooks = scope 외) · parent root `CLAUDE.md` §4 billing split 동일 병기 (git repo X · 별 절차) · verify-sync MISS-exclude list (docs/ops) 별 cycle · CLAUDE.md §9 §B 표기 = 1-hop 경유 유효 (별 판단) · §15 hot 13>10 cold 재이전 advisory. | **6-repo 적용** (master content `cf063a8` + 5 자식 propagate byte-identical 30 file: FND `8300b1e`/GB `81e7d8f`/GD `6d6341d`/GT `68dab90`/PDOCS `e2493f1` · COLD 2 + `context-health-metrics.md` = master-only · §15/propagation-status/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-CONTEXT-DIET-2-001/REPORT.md) |

> **§15 cold 재배치** (= `MASTER-CLI-CONTEXT-OPT-PHASE1-CYCLE-HISTORY-COLD-001` 2026-06-01 + `MASTER-CLI-CONTEXT-OPT-CYCLE-HISTORY-COLD-002` 2026-06-04 2회차 + `MASTER-S15-PRELAUNCH-EXEC2-B-001` 2026-06-05 3회차 + `MASTER-S15-PRELAUNCH-EXEC3-001` 2026-06-05 4회차 + `MASTER-S15-PRELAUNCH-EXEC3-002` 2026-06-05 5회차 + `MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001` 2026-06-10 6회차 + `MASTER-CLI-S15-HOT-DEMOTE-003` 2026-06-11 7회차 + `MASTER-CLI-S15-HOT-DEMOTE-004` 2026-06-22 8회차): 위 표 = 최근 5 entry + 본 cycle entry 만 hot 유지 default. master cycle **121 entry 전체 이력** (= `C1-MASTER-BOOTSTRAP-001` ~ `MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001`) = verbatim 보존 → [`.auto-memory/master-cycle-history-COLD.md`](.auto-memory/master-cycle-history-COLD.md) (= 삭제 0 · 감사 추적 영구 보존 · lifecycle = 매 5 cycle 또는 분기 review). 신규 master cycle = 본 표 append (§16 절차) + hot > 10 도달 시 cold 재이전 (= `measure-gsm-cycle.sh` Stop hook 자동 advisory surface · 판정·이전 = 수동).

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
