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
| MASTER-CLI-RULE-ARCH-PHASE4-001 | 2026-05-31 | RULE-ARCH Phase 4 — 확인·강제·개선 워크플로우 연결 (최소 wiring · 추가만). 확인(consult): `workflow-core.md` intake(Reading Mode 판정 직후) + implement step 에 rule-routing-index §B 의무 로드 집합 consult 1줄씩 (bulk read 금지). 강제(enforce): `code-style-guide.md` §A enforcement = **warn** (advisory + 기존 check-abbreviation/post-edit-degeneration warn hook · 신 blocking gate 신설 X = 사용자 본심). 개선(amend): rule-routing-index §H 신설 (consult/enforce/amend 3행 표 → cycle-discipline §18/§19 + project_cli_infra_rule_candidates + §C deviation pointer). `.editorconfig` ktlint_standard 선언 유지 + advisory 명문화 (빌드 강제화 = 별 program). commit `51d8652`. | propagate (RULE-ARCH-PROPAGATE-001) |
| RULE-ARCH-PROPAGATE-001 | 2026-05-31 | RULE-ARCH closing — Phase 1~4 누적 master 변경 9 file(신규 2: rule-routing-index + code-style-guide · 편집 7: workflow-core + verification-and-review + reviewer + KMP_CMP_LAYER + MODEL_SEPARATION + SSOT_PRINCIPLES + TDD_WORKFLOW) → 4 자식 byte-identical 단방향 propagation. 사전 sync 측정 (편집 7 × 4 자식 = PRE-change in-sync ✓ · clobber risk 0) → propagate.sh ok=36/fail=0 → 자식 staged commit ×4 (FND `16ffa7c` · GB `acace74` · GD `6f35140` · GT `1c9c124` · 각 9 file/0 production) → verify-sync 156 PASS/0 drift → propagation-reports/RULE-ARCH-PROPAGATE-001/{REPORT,DIFF,VERIFY}.md + master audit commit `b2a138e`. 보호 5 종 sha 프로그램 통틀어 0 drift ✓ · 0 production code touch ✓. | **5-repo 적용** (master + app-foundation + GB + GD + GT byte-identical) |
| MASTER-CLI-KTLINT-WARN-GATE-001 | 2026-06-01 | ⚠ **master 무접촉 · 자식 product-layer 4-repo program** (= RULE-ARCH Phase 4 결정 후속 · `.editorconfig` ktlint_standard 선언↔빌드 강제 단절 해소 · master `b2a138e` 무변경이라 본 §15 등록은 audit 참조용). ktlint-gradle(org.jlleitschuh.gradle.ktlint 14.0.1) warn-only(`ignoreFailures=true` · 비차단) gate 를 4 빌드 repo 각 `build.gradle.kts subprojects{}` + `gradle/libs.versions.toml` 에 배선(빌드=repo별 고유·propagate X·repo별 독립 commit). 자식 commit: app-foundation `d4b7eab`(478 위반) · GentlyDay `53390c8`(10,016) · GentlyTable `3007912`(2,751·iOS source set 포함·GD형) · GentlyBreath `b5985b7`(3,212·**iOS source set 제외**=commonMain Room/sqlite klib no-KN-iOS-variant 비호환 → `projectsEvaluated` ktlintCheck dependsOn 에서 Ios/Apple 태스크 필터). auto-fix(ktlintFormat) 미실행=production `.kt` 0 변경 · 보호 5 종 0 drift. 후속(별 cycle): GB iOS klib 근본 해소 · gradlew 런처 깨짐 mitigation. | **4 자식 product-layer** (FND+GD+GT+GB · master 무접촉) |
| MASTER-CLI-ARCH-PATH-THEME-FACTFIX-001 | 2026-06-01 | 단순 사실오류 3건 정정 cycle (Mode M5 cli-infra-ops · 보호 file 아님 · production code 무접촉 · 구조결정 X). **본질**: (1) 부모 mount root `CLAUDE.md` §3.1 L40 reading-order 경로 `../claude-cli-master/docs/agent/architecture/app-implementation-guide.md` = 존재 X(실 = `docs/guides/`) → `guides/app-implementation-guide.md` 정정(= 비-git 직접 편집 · propagation X · 본 file §7 정합 · COMMON_ARCHITECTURE L42 경로 = `agent/architecture/` 실재 = scope-out 무접촉). (2) theme 문서 2곳 = Phase 1(foundation GentlyTheme = colorScheme/typography no-default 주입 + Color.kt/Typography.kt 삭제) 미반영 사실정정: `pencil-theme-multi-axis.md §4.1` + `design-to-code-sync.md §9.6` GentlyTheme 코드 샘플 = 옛 `darkMode` 내부도출 + 삭제 `GentlyTypography` 전역 → foundation 실 시그니처(`GentlyTheme(colorScheme: ColorScheme, typography: Typography, content)` no-default · ground truth app-foundation `GentlyTheme.kt` 정합) + `darkMode→colorScheme` 해소 = per-child `<Child>Theme.kt` 래퍼 reframe. multi-axis(spacing density/window size) 산문 = 보존(= "설계의도(일부 미구현)" 표기 · caller + CompositionLocal provider 해소 paradigm reframe · 삭제 X). **금지 준수**: 실 production Theme.kt 무접촉(foundation + 자식 3 working-tree diff 0) · multi-axis 산문 삭제 0 · COMMON_ARCHITECTURE/SSOT_PRINCIPLES 무접촉(= SSOT-3 rule-arch 이관). 진입 §0 baseline 5/5 HEAD drift = 5-31→6-01 후속 cycle forward progress(content target 3건 intact) · 사용자 진행 승인. GentlyTypography grep 0(2곳) · colorScheme: ColorScheme no-default 도입(2곳) · 보호 5 file sha 변동 0 ✓ · 0 production code touch ✓. propagate ok=4×2 fail=0 · WARN noise 0 · verify-sync PASS 156/0/0 · 2 rule file 5-repo byte-identical(pencil git-sha1 `5a20a2fe` · design `98e49e4f`). master scope-외 dirty(.ai/* + .auto-memory/* auto-log) = §7.1 baseline 보존(0 NEW dirty). | **5-repo 적용** (master b3580ab + app-foundation ce37525 + GB 1f9728e + GD d104ac3 + GT 4becd22 · 2 rule file byte-identical · 부모 CLAUDE.md = 비-git 직접 편집 · CLAUDE.md §15 audit 별도) |
| MASTER-CLI-GIT-HYGIENE-EPHEMERAL-ARTIFACTS-001 | 2026-06-01 | 휘발성 cron/runtime artifact git tracking 불일치 정렬 cycle (Mode M5 cli-infra-ops · 보호 file 아님 · production/rule 본문 무접촉 · 원칙 4 변동성 회피 · cleanup chat 마지막 cycle). **본질**: `.gitignore` 의도(= nightly cron 산출물 + baseline-snapshot hook 산출물 = 휘발성)와 실 tracking 혼재 정정. **master**: (a) `.gitignore` +`.ai/nightly-baseline/*.md` +`!.gitkeep` 추가 + `git rm --cached .ai/nightly-baseline/2026-05-14.md`(untrack · file 보존) → nightly tracked=`.gitkeep`만 · `??` 18→0. (b) `git rm --cached` baseline-snapshot tracked 6 file(latest.json + 5 timestamped · §0 reconcile 시 §2 박제값 "latest.json 1" → disk 실측 6 file = 예상 외 tracked 다수 · §6 #5 "측정 보고 후 진행" paradigm + §2/§4.3 "본 dir 내 다른 tracked file 동일 정렬" 정합) → snapshot tracked=빈 · `.gitignore` L22 의도 정합 · A2 stale snapshot(`f1825013`) 해소(runtime 매 session 재생성 단일 진실). master dirty 22→2(only `.auto-memory` pre-existing · §7.1 baseline 보존). **자식 §FREEDOM align**: GB/GD/GT = 동종 baseline-snapshot tracked json(GB 7 · GD 3 · GT 9 · 동일 불일치 · `.gitignore` 기 무시 의도 present) → `git rm --cached` untrack(tracked→0 · file 보존 · GB disk 19/GD 12/GT 19 무삭제 · dirty→0). app-foundation = tracked 0 무접촉. nightly = master-only(cron 산출 위치 · 자식 0 tracked). **금지 준수**: file 실삭제 0(untrack only · working-tree 보존) · `.gitkeep` 보존 · nightly 19개 commit 0(=ignore 본심 정합) · 보호/rule/production 무접촉. 보호 5 file sha 변동 0 ✓ · 0 production/rule touch ✓ · §0 baseline: master `512a7fc` exact match + 자식 GB/GD/GT forward progress(타 cycle 마감 · reconcile 승인). | **4-repo index 정렬** (master 2aa419c + GB 352e718 + GD e7a0c73 + GT a2a587d · app-foundation 무접촉 · 각 repo 독립 commit · propagation X = git index 영역 · CLAUDE.md §15 audit 별도) |
| MASTER-CLI-CONTEXT-OPT-PHASE1-CYCLE-HISTORY-COLD-001 | 2026-06-01 | CLI context 최적화 Phase 1 — §15 cycle history cold 재배치. master §15 65 entry → `.auto-memory/master-cycle-history-COLD.md` verbatim 100% 이전 (= 삭제 0 · 1 entry / 1 char 무손실) + hot §15 = 최근 5 entry + cold pointer 1 줄 축소 (= 헌법 항상로드 ~82% char ↓ · §15 가 운영 SoT 매몰 = lost-in-the-middle 환각 해소 · 양축 win). 자식 4 (FND+GB+GD+GT byte-identical) §15 = 38 entry · master 65 의 pure subset (= 전 row verbatim 포함 disk 확인) → 각 자식 hot §15 = 자식 자체 최근 5 + master cold pointer 축소 (= 별 자식 cold X · §4 subset 판정 · master cold = 단일 superset). disk 근거 = `cc-audit-CONTEXT-OPT-PHASE0-001.md`. M5 cli-infra-ops · 보호 5 sha drift 0 ✓ · production code 0 touch ✓ · verify-sync PASS ✓. | **5-repo 적용** (master 65→hot 5+1 / 4 자식 38→hot 5+1 · master cold superset · CLAUDE.md = verify-sync byte-identical scope 외) |
| MASTER-CLI-CONTEXT-OPT-PHASE3-L0-CHILD-DEDUP-001 | 2026-06-01 | CLI context 최적화 Phase 3 — L0 최소화(H4·H5) + 자식 CLAUDE.md moderate dedup(H2) (M5 cli-infra-ops). **본질**: 항상로드 context ↓ + 행동-무관 거대 paradigm 본문의 buried 환각 해소. **(H4)** L0 `cross-repo-parallel-exec.md`(18.2K = L0 58%) → kernel(8.2K · §2.4 subscription/billing guard + 단방향 + 영역 1/2/3 1-줄 요약 + §5 STOP/§6 trigger) + `cross-repo-parallel-exec-detail.md` 신설(12.6K · §2.1~§2.3 + §3~§4 verbatim demote · behavior-triggered) · 삭제 0(line 회계 0 missing). subscription/billing/단방향 = kernel 잔류(환각·요금 안전 · contract §3.2). `rule-routing-index.md` §A(L0 kernel 표기 + L1 detail 등록 43→44 rule) + §B(Reading Mode 6 cross-repo=detail 로드) 갱신. **(H5)** `CLAUDE.md §9` just-in-time 로드 wiring(`rule-routing-index.md §B` pointer · 삭제 0 add-only). **(H2)** 자식 CLAUDE.md ×4(24.7K→19.3K · 4 byte-identical) moderate dedup: 운영 §2/§3/§6~§13/§16 + §14a → master pointer 후퇴 · 진입 필수(§0/§0.1/§1/§4/§5/§14/§15) inline 유지 · 자식 §14a stale drift(2026-05-19→master pointer) 해소 · top master-read directive 추가(§3.3 진입 보장). **측정(contract §3.3)**: master CLAUDE.md = 자식 sibling(비-ancestor) → 자식 단독 진입 시 비-auto-load → 안전/진입-critical inline 보존 + master-read directive 로 강제. 삭제 0 ✓(자식 고유 §15 보존 · pointer 본문 = master 잔존) · 보호 5 drift 0 ✓ · production 0 touch ✓ · verify-sync PASS. | **5-repo 적용** (cross-repo kernel/detail + rule-routing-index byte-identical · 자식 CLAUDE.md 4 byte-identical(master clone dedup) · master CLAUDE.md = 운영 본문 SoT) |
| MASTER-CLI-CONTEXT-OPT-PHASE2-BASELINE-SURFACE-001 | 2026-06-01 | CLI context 최적화 Phase 2 — always-fresh baseline 표면화 (H3) + baseline-snapshot mount-root 탐지 정정 (M5 cli-infra-ops). **본질**: 진입 시점 stale HEAD 인용 환각 vector 차단. (1) `instructions-loaded-baseline-verify.sh` 확장 = InstructionsLoaded 시 현재 5-repo HEAD + 보호 5 sha 를 live 측정(git rev-parse + shasum)해 `hookSpecificOutput.additionalContext` 1-블록으로 표면화 → AI 인용 가능 · latest.json 신선도 무관 always-fresh · 기존 drift warn 보존. (2) `baseline-snapshot.sh` = mount root robust 탐지 (`claude-cli-master/.git` 존재 위치로 §3.1 자식 vs §3.2 부모 mount 분기) — dirname-only 가정이 부모 mount 진입 시 5-repo 전부 MISSING 산출하던 결함 정정(= latest.json 5/22 stale 근본 원인). **검증**: SessionStart 모사 → latest.json head=현 HEAD + ts 갱신 (§3.1 자식 + §3.2 부모 양쪽 0 MISSING disk 확인) · 표면화 emit valid JSON 1-블록 · warn-only 보존 (default warn=exit0 · enforce=exit1 advisory · `INSTRUCTIONS_LOADED_VERIFY_ENFORCE` upgrade path 유지 · blocking gate 신설 X). settings.json 무접촉 (hook 등록 기존 · 변경 0) → manifest sha row 무갱신. **STOP 보고 (예상 외 상태)**: manifest 하단 settings.json sha row(`c777a494…`)가 live(`549b142d…`) 대비 stale (commit 78fc97f 이후 advisory row 미갱신 · 본 cycle 무접촉 · 별 resync cycle 후보). 보호 5 sha drift 0 ✓ · production code 0 touch ✓ · master scope-외 dirty 2(.auto-memory auto-log)=§7.1 baseline 보존(무접촉 · verify-sync --no-update). | **5-repo 적용** (hook × 2 byte-identical · latest.json = repo-local 산출 byte-identical 아님 · CLAUDE.md = verify-sync scope 외) |

> **§15 cold 재배치** (= `MASTER-CLI-CONTEXT-OPT-PHASE1-CYCLE-HISTORY-COLD-001` · 2026-06-01): 위 표 = 최근 5 entry + 본 cycle entry 만 hot 유지 default. master cycle **65 entry 전체 이력** (= `C1-MASTER-BOOTSTRAP-001` ~ `MASTER-CLI-GIT-HYGIENE-EPHEMERAL-ARTIFACTS-001`) = verbatim 보존 → [`.auto-memory/master-cycle-history-COLD.md`](.auto-memory/master-cycle-history-COLD.md) (= 삭제 0 · 감사 추적 영구 보존 · lifecycle = 매 5 cycle 또는 분기 review). 신규 master cycle = 본 표 append (§16 절차) + 누적 시 cold 재이전.

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
