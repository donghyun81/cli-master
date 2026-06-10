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
| MASTER-CLI-P2-MECHANISM-001 | 2026-06-09 | Delivery Layer 재설계 Phase 2 — 추적 2-세계 분리(`.ai/tasks/INDEX`=구현 cycle ↔ `LAUNCH-STATUS §3`=출시 목표) 차단 작업방식 메커니즘 3 + 6-repo propagation (Mode M5 cli-infra-ops · production 무접촉). **scope** = `workflow-core.md`(§A) + `rule-routing-index.md`(§B) + `launch-status-sync/SKILL.md`(§C 3→5) + `cycle-discipline.md`(§25.2 mirror 5 정합 · "3~4 file" 4번째). **본질**: ① §A upstream 등재 — `/plan 규칙`에 사용자 대면 신규 deliverable(기능/화면/수익화) 식별 시 자식 `LAUNCH-STATUS.md §3`(개념=INITIATIVES) 3축+KR 귀속 등재를 PLAN 산출물 포함 의무화(audit #3 "신규 출시 task §3 미등재" 차단 · downstream skill counterpart pointer only · 본문 복제 0). ② §B SoT→task drift trigger — `rule-routing-index §I` 제품 SoT(VISION/PRINCIPLES/STRATEGY) 변경 행동 시 하위 3앱 §3 정합 drift 1줄 검출 의무(audit #4 "구독 drift=SoT 변경 하위 미전파" 차단 · **SoT 본문 편집 아님**=가리키는 규칙만). ③ §C launch-status-sync skill 의무 3→5 — ④ KR 귀속 검증 gate(§3 active initiative 전수 KR 태그 1+ · 고아 0 · `[—] future-phase` 예외) + ⑤ 완료분 always-fresh(완료 task ☐→✓ · STALE 재발 방지) 추가 + §3.4/§3.5 subsection + cycle-discipline §25.2 mirror 동기. 명칭=출시 task 층 "INITIATIVES" 개념 참조 · 물리 경로 `LAUNCH-STATUS.md` 불변(rename=P2-RENAME 별 cycle). pointer only(SSOT 정합). **검증**: propagate ok=20/0 · verify-sync 160/0/0(직전 동일) · 보호 5 sha drift 0(§14a git-sha1 baseline 일치) · SoT 4층(`../gently-product-docs/docs/`) 본문 diff 0 · production/도메인 코드 0 LOC · 파일명 rename 0 · 자식 5 commit = `propagation-reports/MASTER-CLI-P2-MECHANISM-001/REPORT.md` 참조. **후속(scope 외)**: 파일명·skill rename(P2-RENAME) · cycle-discipline §25.2 de-dup(pointer 화) 후보 · git-lock daemon 재load(환경 advisory). | **6-repo 적용** (master 본 commit + 5 자식 propagate byte-identical: FND/GB/GD/GT/PDOCS × `workflow-core`+`rule-routing-index`+`launch-status-sync/SKILL`+`cycle-discipline`) |
| MASTER-CLI-P2-RENAME-A-001 | 2026-06-10 | Delivery Layer 재설계 Closeout ① P2-RENAME **Part A** — cli-infra 출시 task 층 auto-sync mechanism(skill+rule)·참조 물리 명칭을 `initiatives-sync` / `initiatives-auto-sync` / `INITIATIVES(.md)` 로 통일 rename + 6-repo propagation (Mode M5 cli-infra-ops · production 무접촉 · 개념은 P2-MECHANISM 정착분 = 이미 INITIATIVES · 구 물리 명칭 = §15 직전 P2-MECHANISM entry 참조). **scope** = `.claude/` 8 file (2 rename: `skills/initiatives-sync/SKILL.md` + `rules/initiatives-auto-sync.md` · 6 edit 참조: cycle-discipline + rule-routing-index + workflow-core + cross-repo-parallel-exec-detail + docs-change-communicator + paste-source-authoring) + master-only `docs/release-readiness/PACKAGE-OVERVIEW.md`. **본질**: 개념 구분 치환(blanket sed 금지) — git mv ×2 + 4-rule negative-lookahead 치환(69/69 symmetric · 내용 추가/삭제 0) + 자식 old path orphan prune(`git rm`). PRESERVE = 동결 paradigm ID `...-AUTO-SYNC-PARADIGM-001`(`-AUTO-SYNC-PARADIGM` lookahead 보존 · 9 hit 불변 · 역사). **검증**: 동결 ID hit 9 불변 · live cli-infra 구 skill/rule 명 잔존 0 · 구명 파일 0(6-repo `git ls-files`) · byte-identical(`initiatives-sync/SKILL.md` + `initiatives-auto-sync.md` 6-repo blob 동일) · 보호 5 git-sha1 변동 0(edit-set ∩ 보호 = ∅) · production/도메인 0 LOC · verify-sync = `propagation-reports/MASTER-CLI-P2-RENAME-A-001/REPORT.md` · CLAUDE.md §15 역사 line 불변. **후속(scope 외)**: Part B(자식 domain docs `INITIATIVES.md` 파일 rename + 본문) · Part C(PDOCS OKR+STRATEGY). | **6-repo 적용** (master 본 commit + 5 자식 propagate byte-identical: FND/GB/GD/GT/PDOCS × initiatives-sync/SKILL + initiatives-auto-sync + cycle-discipline + rule-routing-index + workflow-core + cross-repo-parallel-exec-detail + docs-change-communicator + paste-source-authoring/SKILL) |
| MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-001 | 2026-06-10 | §13 self-test pencil 게이트 재보정 13→9 (pencil 서버 4 종 제거 반영 · Mode M5 cli-infra-ops · production 무접촉). **scope** = `cycle-discipline.md §13` item 3(≥13 카운트 → 9 종 named-set 전수 판정 · 6-repo propagation) + master-only `incident-log.md`(PENCIL-MCP-TOOLSET-RECALIBRATE) + `CLAUDE.md §15`. **본질**: Pencil app v1.1.62 측 `find_empty_space_on_canvas`/`open_document`/`replace_all_matching_properties`/`search_all_unique_properties` 제거 → §13 게이트 noise FAIL → 9 종(batch_design/batch_get/export_nodes/get_editor_state/get_guidelines/get_screenshot/get_variables/set_variables/snapshot_layout) 전수 존재 판정으로 재보정(CC 버전 2.1.156 무관 · 2-환경 corroborate: cli ToolSearch 9 + cowork deferred 9). 게이트 self-exception(진입 FAIL=본 cycle 주제 · 2.1.139 downgrade 기각) 후 self-validating PASS. **검증**: self-test 9/9 전수 PASS + propagate ok=5/0 + verify-sync 무회귀 + 보호 5 sha drift 0(pencil-uiux-workflow.md / pencil-sot-policy.md 무변동). **후속(scope 외·별 cycle)**: 광역 pencil stale sweep(보호 2 file + ux-auditor agent find_empty_space_on_canvas 런타임 위험 + pencil-mcp-tools-reference + Path 2-A open_document). | **6-repo 적용** (master 본 commit + 5 자식 propagate byte-identical: FND/GB/GD/GT/PDOCS × cycle-discipline · incident-log/§15 master-only) |
| MASTER-CLI-PENCIL-TOOLSET-REMOVAL-STALE-SWEEP-001 | 2026-06-10 | Pencil v1.1.62 4종 제거 광역 stale sweep **Phase A**(비보호 land) — RECALIBRATE 후속 (Mode M5 cli-infra-ops · production 무접촉 · Phase B 보호 2 file = **Coin 승인 게이트 미진입**). **scope** = `pencil-mcp-tools-reference.md`(도구 SoT 13→9) + `ux-auditor.md`(런타임 위험) + `pencil-cli`+`pencil-pen-save` SKILL · cycle-discipline.md **무접촉**(§25.2 WIP 동거). **본질**: 제거 4종(find_empty_space_on_canvas/search_all_unique_properties/replace_all_matching_properties/open_document) = 전부 §2.5(D7) headless-PRIMARY 의 ALTERNATIVE 경로 소속 → ① tools-ref header/§0/Part A count 13→9 + §0.1 제거표+대체 메커니즘 + §2.2/§3.1/§3.2/§7 ⚠REMOVED stub ② ux-auditor `find_empty_space_on_canvas` 실호출 → `snapshot_layout(maxDepth=0)`(런타임 호출 실패 위험 해소) ③ skill 2 open_document → headless-primary redirect(Save-As 교훈 보존). deprecated 명시 접근(완전 삭제 X · 대체 기록 보존). **검증**: ToolSearch 9종 · ux-auditor find_empty_space 실호출 grep=0 · propagate ok=20/0 · verify-sync 160/0/0(§25.2 park 후 = phantom drift 회피) · 보호 5 sha drift 0(pencil 2 보호 file 무변동 = Phase B 미진입) · 자식 5 commit byte-identical. **후속(scope 외·별 cycle)**: Phase B(보호 2 file + sha 3-layer Coin 승인) · cycle-discipline.md:164/:227(§25.2 land 동반) · §25.2/propagate.sh WIP land. | **6-repo 적용**(Phase A) (master `0e1f7e3` + 5 자식 propagate byte-identical: FND/GB/GD/GT/PDOCS × pencil-mcp-tools-reference+ux-auditor+pencil-cli/SKILL+pencil-pen-save/SKILL · §15/incident-log master-only) |
| MASTER-CLI-25-2-DEDUP-PRUNE-EXCLUDE-LAND-001 | 2026-06-10 | master WIP 2건 land — ① cycle-discipline §25.2 de-dup + ② propagate.sh prune run-* EXCLUDE (Mode M5 cli-infra-ops · production 무접촉 · PENCIL-TOOLSET-REMOVAL-STALE-SWEEP-001 가 명시한 후속 WIP land · audit-P1 F2). **scope** = `cycle-discipline.md`(§25.2 5행 mirror 표 → [`initiatives-sync` skill §3] 단일 SoT pointer 1단락 후퇴 · 본문 복제 0 · L1-4) + master-only `scripts/propagate.sh`(--prune 측 `PRUNE_EXCLUDE_PATHS=('.claude/skills/run-*')` path-glob EXCLUDE + case-glob 검사 루프 · run-* false-orphan 차단 · 진짜 orphan 검출 유지). **본질**: §25.2 de-dup = WT 2회 소실분 재적용(라이브 부재 확정 · §3 복구 참조 의미 동등 land · skill §3 = ①INITIATIVES ②INDEX ③task file ④KR gate ⑤always-fresh 5 의무 실존 SoT). propagate.sh = master-only 도구(verify-sync 가 scripts/ root 미검사 · 자식 복제본 `b5dc13b6` 기존 stale = 전파 X · scope 외 · A3). **검증**: propagate ok=5/0(cycle-discipline.md × 5 자식) · verify-sync 160/0/0(land 후 master↔자식 byte-identical 복귀 · 진입 시점 = 소실로 이미 160/0/0) · 보호 5 sha drift 0(edit-set ∩ 보호 = ∅) · production/도메인 0 LOC · §25.4 paradigm 이력 무변경(pointer refactor). **분기 판정**: 라이브 §25.2 de-dup 부재(WT==HEAD blob `049cdceb` mirror 표 잔존) = 재적용 분기. **후속(scope 외)**: audit-P1 P2 O5 §21~§29 확대(별 cycle). | **6-repo 적용** (master 본 commit + 5 자식 propagate byte-identical cycle-discipline.md: FND/GB/GD/GT/PDOCS · §15·propagate.sh master-only · 자식 5 commit = propagation-reports/MASTER-CLI-25-2-DEDUP-PRUNE-EXCLUDE-LAND-001/REPORT.md 참조) |
| MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001 | 2026-06-10 | 항상로드 context 자동 demote + 다이어트 D1 일괄 (Mode M5 cli-infra-ops · production 무접촉 · audit-P2 D1(O1+O2+O5)+D3 · Coin 본심 회수 2건 정합). **본질**: ① §15 hot 14 → 최근 5 + 본 entry = 6회차 cold 재이전(9 entry verbatim → cold 94→103 · 무손실 · COLD-002 전례 절차) ② §15 hot 재증식 자동 감시 = `measure-gsm-cycle.sh` §15 hot check 확장(hot > 10 시 Stop hook advisory surface · warn-only · 신 hook 신설 0 · settings.json 무접촉 · GSM-CONTEXT-HEALTH-ABSORB-001 동형 흡수) ③ 자식 4 CLAUDE.md(Coin 확정안) = §15 박제 6 entry → master cold pointer 1행 후퇴(6/6 cold verbatim 기포함 disk 확인 · 정보 손실 0) + master 화자 문장 자식 framing 정정(헌법 blockquote + §0 인트로) + banner 실태 정합 · 19,260→9,581 cp · 4-repo byte-identical 유지 ④ cycle-discipline 다이어트 = §23·§24·§25(§25.2 외 잔여)·§26·§27·§28·§29 → skill/rule 단일 SoT pointer 후퇴(§25.2 동형 · 본문 SoT 실존 § 한정) · **§21+§22 보존**(= 본 § 자체 canonical · 본문 SoT 부재 · 정보 손실 0) · 43,819→36,866 cp ⑤ §22.2 step 7 신설 = repo 추가/대량 rename/file 이동 cycle 마감 gate "구명·구경로 dual grep sweep(A7) 보고 의무"(audit 동일 양식 4+회 재발 mitigation). **검증**: hook self-test PASS(bash -n + fixture 14행 발화 + 실 master 무발화 + exit 0) · 구 sub-§ live 참조 sweep = §23.2(anchor-list A7 precedent) 1건 → §23 pointer 본문 "구 §23.2 흡수" 명시(anchor-list 무접촉) · 자식 §15 6 row cold verbatim 6/6 검증 · 보호 5 sha drift 0 · production 0 LOC · master CLAUDE.md 32,531→26K± cp · verify-sync = propagation-reports/MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001/REPORT.md 참조 · context-health-metrics §2/§4/§6 갱신(master-only). **후속(scope 외)**: 어휘 sweep·dead pointer 등 타 audit finding(A3 별 cycle). | **6-repo 적용** (master 본 commit + 5 자식 propagate byte-identical: FND/GB/GD/GT/PDOCS × cycle-discipline.md + measure-gsm-cycle.sh · 자식 4 CLAUDE.md = repo-specific 직접 정정(byte-identical `b5d80303` · PDOCS 헌법 무접촉) · §15/cold/context-health-metrics = master-only) |

> **§15 cold 재배치** (= `MASTER-CLI-CONTEXT-OPT-PHASE1-CYCLE-HISTORY-COLD-001` 2026-06-01 + `MASTER-CLI-CONTEXT-OPT-CYCLE-HISTORY-COLD-002` 2026-06-04 2회차 + `MASTER-S15-PRELAUNCH-EXEC2-B-001` 2026-06-05 3회차 + `MASTER-S15-PRELAUNCH-EXEC3-001` 2026-06-05 4회차 + `MASTER-S15-PRELAUNCH-EXEC3-002` 2026-06-05 5회차 + `MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001` 2026-06-10 6회차): 위 표 = 최근 5 entry + 본 cycle entry 만 hot 유지 default. master cycle **103 entry 전체 이력** (= `C1-MASTER-BOOTSTRAP-001` ~ `MASTER-PRINCIPLES-OKR-ROUTING-001`) = verbatim 보존 → [`.auto-memory/master-cycle-history-COLD.md`](.auto-memory/master-cycle-history-COLD.md) (= 삭제 0 · 감사 추적 영구 보존 · lifecycle = 매 5 cycle 또는 분기 review). 신규 master cycle = 본 표 append (§16 절차) + hot > 10 도달 시 cold 재이전 (= `measure-gsm-cycle.sh` Stop hook 자동 advisory surface · 판정·이전 = 수동).

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
