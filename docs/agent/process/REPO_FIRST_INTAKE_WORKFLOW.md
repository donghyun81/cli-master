# Repo-First Intake Workflow

> 공통 프로세스 레이어: Claude Code가 프롬프트를 받은 직후 어떤 순서로 해석하고 근거를 고정해야 하는지 정의한다.
> SoT: `CLAUDE.md`, `.claude/rules/workflow.md`, `.claude/rules/evidence-and-reporting.md`

---

## 목적

운영 레이어의 기본 AI 프레이밍은 "자동 완성형 AI"가 아니라
"repo-first 해석 보조형 AI"다.

즉, 프롬프트를 받으면 바로 구현에 들어가는 대신 아래를 먼저 고정한다:

1. 지금 처리하는 작업의 성격이 무엇인가
2. 요구사항 출처와 권위 경계가 충족되었는가
3. 부족한 정보가 repo 안에서 해결 가능한가
4. 어떤 문서를 어떤 순서로 읽어야 하는가
5. 어떤 read-only 판단이 선행되어야 하는가
6. implementer 진입이 허용되는가

이 문서는 공통 철학과 reading order를 설명한다.
실제 강제 규칙은 각 런타임 SoT가 담당한다.

---

## 공통 원칙 vs 도구별 구현

### 공통 원칙

- repo-first
- no external web
- evidence-first
- stop-gated
- report contract 준수
- requirement chain 준수
- 구현 직행 금지: 해석과 근거 고정이 먼저

### Claude Code 구현

| 영역 | Claude Code |
|---|---|
| 최상위 SoT | `CLAUDE.md` |
| 실행 경계 | `.claude/settings.json` + hooks |
| 세부 규칙 | `.claude/rules/**` |
| 역할/에이전트 | `.claude/agents/**` |
| 스킬 진입점 | `.claude/skills/**` |
| 실행 보강 | hooks 중심 |

---

## Intake Normalization Contract

프롬프트 수신 직후 아래 항목을 반드시 판정한다.

| 필드 | 내용 |
|---|---|
| Work Type | 구현 / 조사 / 문서 / 검증 / 리뷰 / 운영 레이어 변경 |
| Reading Mode | 구현형 / UI-UX형 / API-서버형 / 빌드-릴리즈형 / 정책-계획 점검형 / CLI 운영 레이어형 / task 재개-후속형 |
| Requirement Source | 현재 프롬프트, `.ai/tasks/<taskId>.md`, `docs/project/**` 요구사항 체인 충족 여부 |
| Authority Boundary | `docs/project/**` vs `docs/claude-project/**` vs `CLAUDE.md`/`.claude/**` |
| Info Gap | `RESOLVABLE_IN_REPO` / `UNKNOWN` / `BLOCKED` |
| STOP Risk | Money/Auth/DBMig/비가역 변경/범위 확장/예상 밖 시스템 상태 |
| Read-Only Fan-Out | 선행 분석이 필요한 전문가 또는 subagent |
| Implementer Entry | `Allowed / Blocked / N/A` |

---

## 정보 공백 3분류

| 분류 | 의미 | 처리 |
|---|---|---|
| `RESOLVABLE_IN_REPO` | 아직 안 읽었거나, 검색 범위를 좁히면 repo 안에서 확인 가능한 공백 | 읽기 순서를 확장하고 계속 수집 |
| `UNKNOWN` | repo 안 근거가 없거나 현재 단계에서 확인 불가 | 추정하지 않고 `UNKNOWN`으로 기록 |
| `BLOCKED` | 권한, 로컬 환경, 누락 도구, 승인 부족 때문에 확인 불가 | 필요한 조건을 함께 남기고 중단 |

`STOP` 은 정보 공백 분류가 아니라 위험 게이트다.
위험이 감지되면 정보 공백 상태와 별개로 즉시 중단 판단을 우선한다.

---

## Task-Aware Reading Order

★**① 그 태스크의 `## 배경`(없으면 발주 `§0`) — 무엇을 읽을지보다 「무엇을 위해 읽는지」가 먼저다.** 아래 표의 어느 행이든 이 행이 **선행**한다. 목적을 모른 채 권위 순서만 따라 읽으면 **비는 곳을 추론으로 메우게** 된다 (= 판정 = `docs/rules/workflow-core.md` Intake 「배경 재진술」 · 형식 = `docs/rules/reporting.md §3`).

> **왜 이 행이 생겼나** (= `docs/rules/code-principles.md §0` 원칙 5 「판단 근거를 남긴다」): 2026-08-29 실측 — **본 file 170 행에 `배경` · `왜` · `맥락` 이 각각 0** 이었다. 읽기 순서 SoT 가 **무엇을 읽을지만 말하고 그 목적은 말하지 않았다** (= `MASTER-TASK-PURPOSE-CONTRACT-001`).

아래 표는 "무엇을 읽어야 하는가"보다 "어떤 권위 순서로 읽어야 하는가"를 고정한다.
summary layer는 가속용이며 authoritative source를 대체하지 않는다.

| Reading Mode | Required Authority-First Order | Optional Accelerators |
|---|---|---|
| 구현형 | 현재 프롬프트 → `.ai/tasks/<taskId>.md`/기존 보고서 → `docs/project/MASTER_PLAN.md` → `docs/project/BUSINESS_POLICY.md` → `docs/project/TECH_ARCH_POLICY.md` → `docs/project/IMPLEMENTATION_GUIDE.md` → 관련 소스 | `docs/claude-project/01_REQUIREMENTS_SCOPE.md`, `docs/claude-project/02_ARCHITECTURE_MODULES.md` |
| UI-UX형 | 현재 프롬프트 → `.ai/tasks/<taskId>.md` → `docs/project/MASTER_PLAN.md` → `docs/project/BUSINESS_POLICY.md` → `docs/project/IMPLEMENTATION_GUIDE.md` → 관련 UI 소스 | `docs/claude-project/04_UI_UX_REFERENCES.md` |
| API-서버형 | 현재 프롬프트 → `.ai/tasks/<taskId>.md` → `docs/project/MASTER_PLAN.md` → `docs/project/BUSINESS_POLICY.md` → `docs/project/TECH_ARCH_POLICY.md` → 관련 shared/server 계약 및 소스 | `docs/claude-project/03_API_DATA_CONTRACTS.md`, `docs/claude-project/08_EXCLUSIONS_SECURITY.md` |
| 빌드-릴리즈형 | 현재 프롬프트 → `.ai/tasks/<taskId>.md` → `docs/project/APPENDIX_OPS_AND_REFERENCES.md` → `docs/project/IMPLEMENTATION_GUIDE.md` → build scripts / Gradle / CI 실물 | `docs/claude-project/05_BUILD_RELEASE_OPS.md`, `docs/claude-project/06_QA_TEST_VERIFICATION.md` |
| 정책-계획 점검형 | 현재 프롬프트 → 관련 `.ai/tasks/<taskId>.md` → `docs/project/README.md` → `docs/project/MASTER_PLAN.md` → `docs/project/BUSINESS_POLICY.md` → `docs/project/TECH_ARCH_POLICY.md` → `docs/project/IMPLEMENTATION_GUIDE.md` | `docs/claude-project/README.md`, `docs/claude-project/MASTER_PLAN.md` |
| CLI 운영 레이어형 | 현재 프롬프트 → `.ai/tasks/<taskId>.md` → `CLAUDE.md` → `.claude/settings.json` → 관련 `.claude/rules/**` / `.claude/agents/**` / `.claude/skills/**` → `docs/agent/process/**` | `docs/agent/cli/**`, `docs/claude-project/10_CLI_AI_POLICY_SETTINGS.md`, `docs/claude-project/11_CLI_AI_EXECUTION_RULES.md` |
| task 재개-후속형 | 현재 프롬프트 → 기존 `.ai/tasks/<taskId>.md` → 기존 `.ai/reports/<taskId>/{EVIDENCE,PLAN,VERIFY,REVIEW,TODO}.md` → `.ai/tasks/INDEX.md` → 관련 변경 파일 / `git diff` → 필요한 authoritative SoT | `docs/agent/cli/AI_CLI_SETTINGS_SNAPSHOT.md` |

---

## Context Hygiene Layers

- **Layer 1: common invariants** — 현재 프롬프트 + runtime top-level SoT + settings/hook 경계
- **Layer 2: role-specific context** — reading mode와 실제로 선택된 역할에 맞는 rule/agent/skill 본문만 추가
- **Layer 3: task-local context** — `.ai/tasks/<taskId>.md`, 현재 보고서, touched files, verify logs
- CLI 운영 레이어형 / 드리프트 감사가 아니면 `.claude/**` 전체 본문을 한 번에 일괄 읽지 않는다.
- bulk read가 필요한 경우에도 먼저 inventory / summary / grep hit로 shortlist하고, 선택된 본문만 연다.

## Read-Only Fan-Out Rule

기본 라우팅은 아래 순서를 따른다:

`intake-router -> requirements-analyst -> relevant read-only agents fan-out -> change-planner -> implementer -> verifier -> reviewer`

규칙:

- implementer는 pre-EVIDENCE 계약이 채워지기 전 진입할 수 없다
- read-only fan-out은 필요한 전문가만 호출한다
- trivial task여도 read-only 판단이 `N/A`인지 명시해야 한다
- 문서 거버넌스나 CLI ops task에서도 requirements-analyst를 생략하지 않는다

---

## Pre-EVIDENCE Contract

`EVIDENCE.md` 는 사후 보고서가 아니라 implement 진입 전 계약을 먼저 담아야 한다.

구현 또는 문서 수정 전에 아래가 모두 기록되어야 한다:

1. 읽은 근거와 authority boundary
2. 선택한 reading order
3. 남은 공백과 3분류 결과
4. 선택한 경로와 보류/중단 사유
5. 필요한 read-only fan-out
6. implement 진입 조건 충족 여부

권장 최소 형태:

```md
## Intake Normalization
- Work Type:
- Reading Mode:
- Requirement Source:
- Authority Boundary:
- Info Gap:
- STOP Risk:
- Read-Only Fan-Out:
- Implementer Entry:

## Pre-EVIDENCE Contract
- Read evidence:
- Remaining gaps:
- Chosen path:
- Hold / Stop reasons:
- Implement entry conditions:
```

---

## Implementer Entry Gate

아래 중 하나라도 미완이면 implementer 진입 금지:

- Work Type / Reading Mode 미판정
- Requirement Source 충족 여부 미판정
- `RESOLVABLE_IN_REPO` 공백을 아직 수집하지 않음
- STOP risk 미판정
- 필요한 read-only fan-out 미실행
- EVIDENCE pre-contract 미기록

docs-only / review-only / verify-only task 는 `Implementer Entry: N/A` 로 잠그고
write scope 없이 끝낼 수 있다.
