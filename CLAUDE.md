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
- **현 단계 = 5-repo 동일 mode / 미래 = 자식별 발산 허용 default** (L1-6 정합 default). 현 5-repo 측 default mode = production-graduated default (= `mode-system.md` Cycle 4 신설 시점 default · 본 cycle 측 implicit default 영역 default) · 미래 자식별 mode 발산 = 본인 명시 결정 + migration cycle default.

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

## 5. STOP 조건 단일 SoT (= 본 cycle 통합 default · 2026-05-22 신설 default · `MASTER-CLI-CYCLE-1-STOP-CANONICAL-INTEGRATION-001`)

본 § = 5-repo 측 STOP 조건 단일 SoT default. 나머지 4 군데 (= `safety-and-secrets.md §비가역 변경 STOP 정책` + `cycle-discipline.md §21.4` + `cycle-discipline.md §22.4` + `cross-repo-parallel-exec.md §5`) = 본 § pointer 영역 default · 본문 무접촉 default. `cowork-project-instructions.md §D-1` = cowork sandbox 영역 default · 본 cycle scope X default · 본인 manual paste replace default.

### STOP 영역 (= 9 항 default · 즉시 중단 + 자동 수정/되돌리기 금지)

| # | 영역 | trigger | mitigation |
|---|---|---|---|
| 1 | DB migration / Money / Auth 영향 경로 | DB schema 변경 + auth/billing 변경 + secret 접촉 default | 비가역 영역 default · 사용자 본심 회수 의무 default |
| 2 | Scope expansion | 요구사항 범위 초과 + 다른 영역 묶임 default | cycle scope 명확화 의무 default |
| 3 | 비가역 변경 징후 | 파일 삭제 + 스키마 변경 + 기존 파일 대규모 override default | mitigation cycle 신설 default |
| 4 | 예상 외 시스템 상태 | sandbox 진입 시 baseline mismatch default | 사용자 회수 default |
| 5 | 보호 5 file sha drift | byte-identical 의무 영역 default · `protected-file-hashes.md` baseline 정합 default | 즉시 mitigation cycle default · 리뷰 블로커 default |
| 6 | 자식 cli infra drift | master 측 단방향 propagation 위반 default | master 측 정정 cycle 신설 default |
| 7 | Cross-repo HIGH RISK 도메인 진입 | 5-repo 측 동시 영향 영역 default (= DB migration / Money / Auth / production push) | 사용자 본심 회수 default |
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

## 14a. 보호 파일 sha baseline (2026-05-31 · MASTER-CLI-PENCIL-UIUX-HEADLESS-RESTRUCTURE-001 마감 · git-sha1)

5종 보호 파일 git-sha1 (= `git hash-object` · post-cycle baseline · 본 cycle 안 `.claude/rules/pencil-uiux-workflow.md` 단일 변경):

| 보호 파일 | git-sha1 | 본 cycle 변동 |
|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `5b84cd9e4bc361652d6d0e561d8846eed3400d00` | 불변 |
| `.claude/rules/pencil-uiux-workflow.md` | `9d47624aafe31c0390467499eaec09a3da8c7579` | **갱신** (이전 `2ee16ae4...` · §2.5 경로 위계 신설 + §9 headless 승격 + stale 2.1.114 pin 2 줄 정정) |
| `docs/design/pencil-sot-policy.md` | `b27fbe16edb688218d7e57dd9a66d0f2a31ef300` | 불변 |
| `.claude/rules/uiux-sot-refresh.md` | `d3a0b57390bd0414cc89283a571dd6ecb8cb1562` | 불변 |
| `docs/design/design-sot-policy.md` | `e580b6d7ca9a88aef67c03f4bb39360993ab996f` | 불변 |

> **algorithm 분기 주의** (`protected-file-hashes.md §CONVENTION` 정합): 본 §14a = **git-sha1 (40 char)** · `.auto-memory/protected-file-hashes.md` manifest + `.ai/baseline-snapshot/latest.json` = **sha-256 (64 char)**. pencil-uiux-workflow.md 측 sha-256 = `e6a4a2a1457b25e0f9fb150daa4aabbd5cc062ec89ce42838199f6672675b236` (= manifest 측 baseline). 두 algorithm 직접 비교 금지.

`.auto-memory/protected-file-hashes.md` 와의 정합 의무 (`cycle-discipline.md` §10 정합).

---

## 15. master cycle 진행 이력 (placeholder · 매 cycle 시 갱신)

| cycle ID | 마감일 | 변경 요약 | 영향 자식 repo |
|---|---|---|---|
| MASTER-CLI-AGENT-BODY-AUDIT-001 | 2026-06-03 | agent 본문 정비 — dangling ref 5건 live canonical 치환 + 구식 헤더 2 file 신식 템플릿 정합 (Mode M5 cli-infra-ops · 보호 5 sha 변동 0 · production 0 touch · `MASTER-CLI-AGENT-ROLE-MATRIX-001`(305) 명시 후속). **scope** = `.claude/agents/` 6 file only(active/code-simplifier·ui-implementer·change-planner·requirements-analyst·layer-checker + deferred/server-implementer). **(a) dangling 5건**(치환 전 successor disk 5-repo 재확정 · 추측 0): `workflow.md`(소멸)→`workflow-core.md` ×4(code-simplifier·ui-implementer ×2·server-implementer · SoftBudget@185 실존) · `evidence-and-reporting.md`(소멸)→`reporting.md` ×1(change-planner · PLAN 10-section@§5 실존) · `domain-policy.md`(5-repo 전체 부재·미신설)→**괄호 ref 제거**(requirements-analyst:49 · 문장 "앱 불변 원칙 위반 가능성 발견 → STOP" 보존 · live SoT 실측 = rule canonical 부재 · `domain-roles.md`:25 escalation→intake-router·:39 "rule 미신설" · 추측 치환 회피). **(b) 신식 템플릿** = code-simplifier+layer-checker → `domain-roles` §"역할 파일 필수 섹션" 8-section 재배치 · 의미/내용 100% 보존(원 본문 0 누락 · Think like=기존 stance distillation·0 new obligation) · frontmatter 불변. **무접촉(오탐 확정)**: `.ai/tasks/INDEX.md` ref · `docs/CLAUDE.md` · `COMPOUND.md`(reporting 산출물 canonical) · deferred 8 스텁 확장 0 · 보호 5종 · routing-and-delegation/domain-roles. **검증**: `.claude/agents/` dead ref 0/0/0(grep workflow.md·evidence-and-reporting.md·domain-policy.md) · successor workflow-core ×4+reporting ×1 · pencil-uiux-workflow.md ref 2 intact · 6 file 진입 sha §0 exact match · 보호 5 sha-256 drift 0 ✓ · production 0 ✓ · verify-sync 161 PASS/0 DRIFT(agent 6 file 본인 0 miss) · path-limited commit(.claude/agents/ · 자식 pre-existing dirty 비혼입). **⚠ 동시 session reconcile(STOP #4 surface · §15-303 패턴)**: 진입 master `e4db3ce` → 작업 중 동시 `MASTER-CLI-TESTING-BACKFILL-AUDIT-001` session commit `7358f13`(CLAUDE.md§15+docs/agent/audits/ · `.claude/agents/` 0 touch=disjoint) → 본 cycle parent=`7358f13` forward reconcile. verify-sync MISS 4 = 그 session 의 `docs/agent/audits/TESTING-BACKFILL-AUDIT.md`(master-only·entry 307 declare·본 cycle 무관). | **5-repo 적용** (`.claude/agents/` 6 file byte-identical · code-simplifier `064e8cb0` · ui-implementer `48074a09` · change-planner `6862f134` · requirements-analyst `0acc6045` · layer-checker `1aee6f84` · server-implementer `53c2e427` · master `be2bd45`+audit · GB `4f0cdb1` · GD `a526354` · GT `8004021` · FND `1f132a3` · CLAUDE.md §15+propagation-status = master-only) |
| MASTER-CLI-AGENT-FRONTMATTER-OPTIMIZE-001 | 2026-06-03 | agent frontmatter 공식 subagent 스펙 정합 — P1 deferred 8 보강 + P2 model:haiku 2 + P3 description 영어 2 (Mode M5 cli-infra-ops · 보호 5 sha 변동 0 · production 0 touch · `MASTER-CLI-AGENT-BODY-AUDIT-001`(309) 명시 후속). **scope** = `.claude/agents/` 11 file only. **P1**(deferred 8 · `+name`=file명·`domain-roles` 매트릭스 정합 + `+tools: Read`·최소 권한·로드돼도 read-only 무해): backend-api-architect·data-schema-guardian·domain-policy-analyst·observability-ops-analyst·performance-reliability-engineer·release-risk-manager·server-implementer·sync-offline-state-specialist · description/body **byte-불변**(git numstat 2/0 each = 0 deletion · 스텁 0 확장). **P2**(model:haiku): layer-checker + docs-drift-auditor (기계적 검사형 · 나머지 = inherit). **실측 근거**: `claude --version`=2.1.156(실측) + 공식 subagent 스펙 §3(`model: sonnet\|opus\|haiku\|inherit` valid field · 본 cycle 정합 대상) + 2.x 안정 documented field + in-repo precedent 0(첫 도입) → **APPLY**(불확실 X · 추측 X). **P3**(description 영어·"Call …" 트리거): code-simplifier(`Call after implementation …`) + layer-checker(`Call to verify layer boundaries …`) · 의미 등가(언어 전환만 · role/capability 보존). docs-drift-auditor description = 기 영어(P2만). **무접촉**: deferred 스텁 본문 · active 14 · 보호 5종 · production · `.github`/`tests`/`hooks` · routing-and-delegation/domain-roles/settings. **검증**: deferred 8 numstat 2/0(body 0 Δ) · name=file명 11 정합 · model:haiku 2 file line5 · 진입 11 sha §0 exact match · 보호 5 sha-256 drift 0 ✓ · production 0 ✓ · verify-sync 161 PASS/0 DRIFT(11 file 본인 0 miss · MISS 4 = 동시 TESTING session master-only doc `docs/agent/audits/TESTING-BACKFILL-AUDIT.md` · disjoint · 본 cycle 무관) · path-limited commit. §0 baseline 5/5 HEAD exact match(master be12a95 진입 · drift 0). | **5-repo 적용** (`.claude/agents/` 11 file byte-identical · master `cb83c27`+audit · GB `f6d6b73` · GD `27a211c` · GT `47b9732` · FND `034ec44` · CLAUDE.md §15+propagation-status = master-only) |
| MASTER-CLI-WORKFLOW-ADOPTION-POLICY-002 | 2026-06-04 | BILLING-GUARD-001 shape 교정 + Workflow 도구 채택 정책 완성 (Mode M5 cli-infra-ops · 보호 5 sha 변동 0 · production 0 touch · 실 워크플로 실행 0 = 문서만). **본질**: BILLING-GUARD-001(`6c5751a`) 산출은 disk PASS 이나 shape 가 본심·contract 와 불일치 2건 — (i) 옵션 B 별 rule 신설 결정인데 본문이 `cross-repo-parallel-exec.md §2.4.1` 에 정착 (ii) 001 §2 금지였던 L0 kernel 재팽창(101→117줄 · H4 역행). 본 cycle = 교정 + 완성. **(신설)** `.claude/rules/workflow-policy.md`(L1) — §2.4.1 본문(gate ① pool 귀속 + 2026-06-15 billing split 후 /usage 재확인 의무 + 토큰 예산 advisory 한계 10k→79.6k + 200k hard cap 4-step) 전부 이관(유실 0 · 항목별 매핑 검증) + 채택 정책 전반 완성(§1 본질=조건부 허용 · §2 gate ②③[버전 2.1.156·Pro default OFF·ultracode≠trigger 보장·예산 200k] · §3 허용 영역[rule-adherence/cross-repo fan-out/audit-triage] · §4 회피 영역[일상 코딩/도메인 IMPL]·토큰 통제·contract 내 보호5/STOP9 보존·skill 배포 · §5 A6 경계). **(환원)** `cross-repo-parallel-exec.md §2.4.1` = 14줄 본문 → 1줄 kernel pointer(interactive pool 귀속·영역3 아님·A6 + workflow-policy.md 가리킴) · kernel 117→107줄(H4 de-bloat · -10 · 잔여 +6 = pointer 3줄 + §8 history 001+002 append-only). **(배선)** `rule-routing-index.md` §A L1 표 +1행(19→20) + §0/§A헤더(45→46) + §D #5(46+1=47) + §B Mode5(정책-계획) workflow-policy consult + §F 이력. **검증**: 보호 5 sha drift 0 ✓ · production 0 ✓ · plugin-policy 본문 무변경 · 25 agent 무접촉 · verify-sync DRIFT 0(3 file PASS byte-identical) · path-limited 자식 commit(scope-외 pre-existing dirty 보존 · cross-session). §0 baseline 5/5 HEAD exact match(master `9378b8d` 진입 · 자식 dirty 증가분 = 타 session working-file cleanup = §7.1 보존). master scope-외 dirty(`incident-log.md`) = §7.1 보존(무접촉). | **5-repo 적용** (`workflow-policy.md`(신설) + `cross-repo-parallel-exec.md` + `rule-routing-index.md` byte-identical · master `007432e`+audit · FND `b261248` · GB `367e7e3` · GD `7f51938` · GT `ab8899f` · CLAUDE.md §15+propagation-status = master-only · verify-sync DRIFT 0 / MISS 4 = TESTING-BACKFILL-AUDIT.md master-only 선례) |
| MASTER-CLI-WORKFLOW-SUBAGENT-BILLING-GUARD-001 | 2026-06-04 | cross-repo subscription kernel `cross-repo-parallel-exec.md §2.4.1` 신설 — `Workflow` 도구 dynamic subagent billing pool guard + 토큰 예산 통제 (Mode M5 cli-infra-ops · 보호 5 sha 변동 0 · production 0 touch · cowork 본심 외화 = L1-1 예외 정합). **본질**: cowork gate ① PASS 외화 = /usage "Subagents: workflow-subagent" 항목이 **interactive plan pool 귀속** 실측(2026-06-04 · 별 Agent SDK credit pool 표기 0 · §2.4 영역 3 `claude -p` 와 구분) → 조건부 허용 본문화. **추가 2건**: (a) 2026-06-15 Anthropic billing split 발효 후 /usage 1회 재확인 의무(금일 실측 = split 이전 baseline · split 후 pool 귀속 변동 시 갱신 cycle). (b) 토큰 예산 advisory 한계(10k 지시 → workflow subagent 79.6k 실소비) → 200k hard cap 4-step(예산 prompt + `/workflows` 감시 + 수동 stop(`TaskStop`) + 소규모 슬라이스 선행). `anchor-list.md` A6(subscription pool integrity) 정합 · 영역 3 회피 불변 · §8 cycle 이력 +1. **검증**: PRE-change 5-repo rule sha in-sync(`c7733961`) clobber-safe ✓ · propagate ok=4/fail=0 · 자식 path-limited commit ×4(scope-외 pre-existing dirty 보존 = 0 NEW · post-dirty GB 8/GD 6/GT 2/FND 0 = 진입 동일) · verify-sync DRIFT 0(본 file PASS 161 byte-identical · MISS 4 = `docs/agent/audits/TESTING-BACKFILL-AUDIT.md` master-only · 본 cycle 무관 · §15-309 선례) · 보호 5 sha drift 0 ✓ · production 0 touch ✓. master scope-외 dirty(`incident-log.md`) = §7.1 baseline 보존(무접촉). | **5-repo 적용** (`cross-repo-parallel-exec.md` byte-identical `6188f56df75a` · master `6c5751a`+audit · FND `1ff903d` · GB `82ccb91` · GD `503f4d5` · GT `f277b5d` · CLAUDE.md §15+propagation-status = master-only) |
| MASTER-CLI-GSM-CONTEXT-HEALTH-ABSORB-001 | 2026-06-04 | context-health 측정 자동화를 기존 GSM Stop hook 으로 흡수 (Mode M5 cli-infra-ops · 보호 5 sha 변동 0 · production 0 touch · **신 hook 신설 X · settings.json 무접촉**). **본질**: context-health 지표 측정을 신 hook/배선 없이 `measure-gsm-cycle.sh` 확장으로 흡수(= 단일 SoT · idempotent guard 패턴 재사용 · 기존 cycle-health(DORA) 로직 무파괴). **(확장)** measure-gsm-cycle.sh +context-health 블록: char 4 지표(parent_root/master/L0_kernel/child = codepoint `python3`) + `stale_pointer`(상대경로 .md file-link 존재 grep) = **자동** · `conflicting_sot`/`buried_ratio` = **수기 advisory**(판정 자동화 난이도 ↑ → row `manual` 표기 · over-claim 금지 = char≠token proxy band 라벨 surface 보존) + **분기 guard**(quarter bucket 경과 · idempotent 같은 분기 중복 X · 매 Stop X = cycle-health 와 별 cadence) + `GSM_CONTEXT_HEALTH_FORCE=1`(new-cycle 게이팅 무관 수동 분기 실행 · 분기 guard 유지) · advisory(non-blocking · exit 0 보존). **(SoT)** context-health-metrics.md §3.1 분기 auto trajectory(append-only · EOF 누적 = cycle-health-log.md 동일 패턴 · marker `<!-- ch-auto YYYY-MM-DD -->`) + seed row 1(2026Q2 · parent 8000/master 52652/L0 25730/child 19260/stale 0) + §4 cadence 자동/수기 경계 + §6 이력 · master-only(propagation X). **검증(disk)**: `bash -n` PASS · self-test advisory/silent/append/재append(분기 guard 차단=idempotent · 실 data row 1) PASS · DORA 무파괴(advisory surface + cycle-health-log append X disk 확인) · hook sha-256 `6a30ad4295cd` 5/5 byte-identical · verify-sync PASS 162/DRIFT 0/MISS 4(= `docs/agent/audits/TESTING-BACKFILL-AUDIT.md` master-only · 본 cycle 무관 · §15-309 선례) · 보호 5 sha drift 0 ✓ · production 0 ✓ · settings.json 무변경(Stop 배선 line 204 재사용) · §0 baseline 5/5 HEAD exact match(master ca4868e 진입). master scope-외 dirty(`incident-log.md`) = §7.1 보존(무접촉). **side-finding(scope 외)**: 자동 측정이 master 52.7K(Phase4 baseline 25.4K 대비) · §15 hot ~22 entry 노출 = §15 cold 재이전 trigger(≥~10 entry) 도래 → 별 context-opt cycle 후보(본 cycle 무접촉). | **5-repo 적용** (`measure-gsm-cycle.sh` byte-identical sha-256 `6a30ad4295cd` · master `846ccf7`+audit · FND `a6d2b40` · GB `ea916c2` · GD `a2a11a9` · GT `ee9d17b` · context-health-metrics.md + CLAUDE.md §15 + propagation-status = master-only) |
| MASTER-CLI-CONTEXT-OPT-CYCLE-HISTORY-COLD-002 | 2026-06-04 | §15 cycle history cold 재이전 **2회차** (Mode M5 cli-infra-ops · 보호 5 sha 변동 0 · production 0 touch · `MASTER-CLI-CONTEXT-OPT-PHASE1-CYCLE-HISTORY-COLD-001`(전례) 동종 절차 재실행 · 신 절차 발명 0). **trigger**: H3 자동 측정(`measure-gsm-cycle.sh` context-health) 첫 작동이 master `CLAUDE.md` **54,767 char**(Phase 4 baseline 25,392 의 2.2배 회귀) · §15 hot 24 entry 노출 = lost-in-the-middle 환각 risk 재발. **변경(master-only)**: §15 hot 24 → **최근 5 + 본 cycle entry**(AGENT-BODY-AUDIT / AGENT-FRONTMATTER-OPTIMIZE / WORKFLOW-ADOPTION-POLICY-002 / WORKFLOW-SUBAGENT-BILLING-GUARD / GSM-CONTEXT-HEALTH-ABSORB + COLD-002) · 이전분 19 entry(= `MASTER-CLI-CONTEXT-OPT-PHASE1-CYCLE-HISTORY-COLD-001` ~ `MASTER-CLI-GSM-CONTEXT-HEALTH-ABSORB-001` · Phase 1 후 누적 · cold 미포함분) = `master-cycle-history-COLD.md` §1 GIT-HYGIENE(entry 65) 뒤 **verbatim 100% append**(삭제/요약/병합 0 · diff 0) → cold 65 → **84 entry**(C1-MASTER-BOOTSTRAP-001 ~ GSM-CONTEXT-HEALTH) + cold 헤더 count 65→84 갱신. hot 290-294 의 Phase1-dupe 5(RULE-ARCH-PHASE4~GIT-HYGIENE · cold 기존재)는 **재append 0**(= 중복 차단). **자식 4(byte-identical `dca26b93`)**: §15 hot count bash 재측정 = **6 entry**(Phase 1 baseline · 5 own-recent + CONTEXT-OPT-PHASE1) **무성장** → trim 불요(§2 조건 미충족) · master cold superset 보장 ✓ 6/6 ∈ cold. **검증(disk)**: cold 84 = 65 + 19 · dupe 0 · 이전 19 verbatim diff 0 · 총수 보존(hot-only 19 → cold) · master `CLAUDE.md` 비-§15(1-285 + §16+) byte 불변 ✓ · 보호 5 sha drift 0 ✓ · production 0 ✓ · char 54,767 → **25,681**(2.2배 → ≈1.01배 baseline 복귀). **STOP 회피**: entry 수정/요약/병합 0(verbatim) · §15 외 section 0 touch · 보호 5종 무접촉 · 타 section 압축 0. §0 baseline 5/5 HEAD exact match. master scope-외 dirty(`incident-log.md`) = §7.1 보존(무접촉). | **master-only** (`CLAUDE.md §15` trim + `master-cycle-history-COLD.md` +19 verbatim · 자식 `CLAUDE.md` 무접촉 = §15 hot 6 무성장 · CLAUDE.md = propagation X / verify-sync scope 외 · parent `496f7aa` · 단일 path-limited commit) |
| MASTER-CLI-REVIEW-S7-SSOT-RECONCILE-001 | 2026-06-04 | review §7(TDD Evidence & Testability Seams) 테스트 전략 확장 판정 기준 canonical 환원 — SSOT 역전 1건 해소 (Mode M5 cli-infra-ops · 보호 5 sha 변동 0 · production 0 touch). **본질**: review 12-section row 7 의 테스트 전략 확장 기준(변경분 ROI-coverage·여러 경우 완전성·피라미드/test size·enforce=warn)이 canonical(`verification-and-review.md`) 아닌 `review-task/SKILL.md` 측에만 존재 = SSOT 역전 (`rule-routing-index.md §G` "체크리스트 판정 기준 SoT = verification-and-review.md" 위반). **(환원)** `verification-and-review.md` 12-section row 7 = 기존 본문(FakeXxx/StateFlow/심) 보존 + 테스트 전략 확장 무손실 append(ROI-coverage(고위험 Auth/Billing/Data/Backend)·여러 경우 완전성(happy+경계+에러+empty/null/동시성)·피라미드/test size · SoT `TESTING_STRATEGY.md` §5·§6·§3 · enforce=warn · follow-up TODO 권장 · blocking gate 신설 X · 의미 약화 0 · 비블로커 column 불변). **(후퇴)** `review-task/SKILL.md` row 7 = 확장 본문 → canonical pointer(`verification-and-review.md` 12-section row 7) + 역할 고유분(필수 REVIEW.md section) 보존 (§G row 5 reviewer.md 동형). **검증(disk)**: §5(ROI)·§6(여러경우)·§3(test size) 3 헤딩 grep 실존 PASS · canonical pre-change TESTING_STRATEGY/ROI-coverage citation 0건 실측 · grow-only(행 무삭제) · 보호 5 sha-256 MATCH(drift 0) · production 0 · verify-sync PASS 162/DRIFT 0/MISS 4(= `docs/agent/audits/TESTING-BACKFILL-AUDIT.md` master-only · 본 cycle 무관 · §15-309 선례) · path-limited commit(자식 pre-existing dirty[cc-paste 삭제+supabase temp] 비혼입 · §7.1 보존). **무접촉**: `rule-routing-index.md`(§C "review §7 게이트" pointer = 환원 후 정확 · §8 scope 봉인) · `TESTING_STRATEGY.md`(인용만) · settings.json · 보호 5종. §0 baseline 5/5 HEAD exact match(master 71d8c14 진입). master scope-외 dirty(`incident-log.md`) = §7.1 보존(무접촉). | **5-repo 적용** (`verification-and-review.md`+`review-task/SKILL.md` byte-identical · verification-and-review `fd066a78ca1b` · SKILL `f3bd87ffadd1` · master `1d612a9`+audit · FND `e646585` · GB `83d877b` · GD `05585f8` · GT `7c7d760` · CLAUDE.md §15+propagation-status = master-only · verify-sync DRIFT 0) |
| PRELAUNCH-PA-ANALYTICS | 2026-06-05 | P-A(product analytics) 원천 수집 완료 — 5×3 이벤트 seam 정착 (PRELAUNCH-EXEC chat 완료 cycle 기록 · 본 §15 doc-only append · production/cli infra 로직 무접촉). **scope** = FND `core/analytics` seam + 3 자식(GB/GD/GT) view 이벤트 계측. **본질**: 화면별 5 이벤트 × 3 자식 = 15 정착 · view-이벤트 = 화면 진입 contract · `MealLogged` = defer 본심(현 시점 계측 보류) · GT = read-only 앱 실측. **검증**: 전 cycle cowork disk cross-verify PASS. | **5-repo 적용** (FND `d0ae108`(core/analytics seam)+`af9ae7c`(MealRecommendView) · GB `ca3c0f7` · GD `52bb902` · GT `12714b4` · master = 본 §15 entry append only) |
| 5REPO-GRADLEW-REPAIR-001 | 2026-06-05 | gradlew/gradlew.bat 런처 수리 — canonical Gradle 8.13 정착 (PRELAUNCH-EXEC chat 완료 cycle 기록 · 본 §15 doc-only append). **본질**: 자식 initial commit 이래 잔존 launcher 결함 → canonical 8.13 byte-identical 복구(`gradlew` sha `bec00de0` / `gradlew.bat` sha `2209f919`) · CI gate 의존 해소. master = launcher 삭제(gradle build 아님 · `./gradlew` 기대 금지 · STOP #3 비가역 변경 본심 승인). | **5-repo 적용** (FND `0c26a7d` · GB `5002108` · GD `7fd494b` · GT `17684f1` · master `cf49b74` = launcher 삭제) |

> **§15 cold 재배치** (= `MASTER-CLI-CONTEXT-OPT-PHASE1-CYCLE-HISTORY-COLD-001` 2026-06-01 + `MASTER-CLI-CONTEXT-OPT-CYCLE-HISTORY-COLD-002` 2026-06-04 2회차): 위 표 = 최근 5 entry + 본 cycle entry 만 hot 유지 default. master cycle **84 entry 전체 이력** (= `C1-MASTER-BOOTSTRAP-001` ~ `MASTER-CLI-GSM-CONTEXT-HEALTH-ABSORB-001`) = verbatim 보존 → [`.auto-memory/master-cycle-history-COLD.md`](.auto-memory/master-cycle-history-COLD.md) (= 삭제 0 · 감사 추적 영구 보존 · lifecycle = 매 5 cycle 또는 분기 review). 신규 master cycle = 본 표 append (§16 절차) + 누적 시 cold 재이전.

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
