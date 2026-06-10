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

## 14a. 보호 파일 sha baseline (2026-06-10 · MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001 마감 · git-sha1)

5종 보호 파일 git-sha1 (= `git hash-object` · post-cycle baseline · 본 cycle 변경 = Pencil 2 file 한정 — v1.1.62 제거 4종 stale sweep Phase B (open_document 등 참조 → 현 메커니즘 + 도구수 9 정합 + sot-binding 명칭 정합) · 나머지 3 무변동):

| 보호 파일 | git-sha1 | 본 cycle 변동 |
|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `8b46bb4952be03a7631b66096ba2b47e27a1c72a` | 무변동 (= COMPOUND-LINT-DEPRECATE-001 baseline 유지) |
| `.claude/rules/pencil-uiux-workflow.md` | `aba157e0a6fdfd180dfab68167270bdfb542e94f` | **갱신** (이전 `22570f97...` · :20/:22 도구수 12+1→9 + 추가 5종 lineage 정합 · :45/:56/:68 open_document step→현 메커니즘 · :93 STOP moot 항 교체 · :11 pencil-sot-binding 죽은 명칭→실 file 병기) |
| `docs/design/pencil-sot-policy.md` | `ce9c0d3e54534eb6eab3c7133cbb71a0e17ca6de` | **갱신** (이전 `acf88d95...` · :40 캔버스 열기 행→현 메커니즘 · :77 STOP moot 항 교체) |
| `.claude/rules/uiux-sot-refresh.md` | `d2c62265ceb0dfe934bb703f3a7c604c3c896f0f` | 무변동 (= COMPOUND-LINT-DEPRECATE-001 baseline 유지) |
| `docs/design/design-sot-policy.md` | `69649a36c75a221e1995a5f8437b2694db17fc42` | 무변동 (= COMPOUND-LINT-DEPRECATE-001 baseline 유지) |

> **algorithm 분기 주의** (`protected-file-hashes.md §CONVENTION` 정합): 본 §14a = **git-sha1 (40 char)** · `.auto-memory/protected-file-hashes.md` manifest + `.ai/baseline-snapshot/latest.json` = **sha-256 (64 char)**. pencil-uiux-workflow.md 측 sha-256 = `b09b8d5091a748e80a062e766ef51352a6f26a3afdffccc15d51ade4d643364e` (= manifest 측 baseline). 두 algorithm 직접 비교 금지.

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
| MASTER-CLI-DEAD-REF-SWEEP-001 | 2026-06-10 | 죽은 참조 대청소 + 측정 맹점 해소 (Mode M5 cli-infra-ops · production 무접촉 · cowork-infra-audit-P1/P2 F1·F3·F5·F6·F7·F8·F10·F12·O3·O8). outcome 10 중 8 land + ② HOLD. **①** baseline-snapshot.sh REPOS 배열 + drift loop 에 `gently-product-docs` literal 추가(6-repo 감시 · 다음 snapshot 부터 PDOCS 보호 sha 포함). **②** compound-lint HOLD — 라이브 grep 결과 `scripts/agent/compound-lint.sh` = **107 인용**(verify-all skill 실행 · PROPAGATION_PARAMETERS asset · COMMON_ARCHITECTURE tree = live operational gate)인데 file 전 6-repo 부재 = §6 STOP ①(>10 인용처 → scope-고정 의문). 3 ref(reporting:217·safety-and-secrets:135·verification-and-review:34) 무접촉 + 별 cycle 표면화(missing-tool 구현 vs 107-ref 일괄 deprecate 결정 = 사용자 본심). **③** ui-ux-analysis(수집목록 :11-13 + §KMP/CMP :124) + workflow-core(/collect :147-148) 부재 reading list(app_overview.ko.md · 40/30_UI_UX_DIRECTION · multiplatform-*) → 제품 SoT(`../gently-product-docs/docs/PRODUCT-*-SOT.md` sibling 상대경로 · rule-routing-index §I) + 자식 `docs/CLAUDE.md`·`docs/design/` + `docs/agent/architecture/**` 재배선. **④** 부재 `docs/agent/solutions/README.md` 역할표 갱신 의무 ×2 → domain-roles:77 redundant step 제거(step 2 매트릭스 흡수 note) + routing-and-delegation:251 retarget(domain-roles 매트릭스). **⑤** PDOCS `run-master` seeding artifact `git rm`(PDOCS 단독 `63a3e6a` · run-* = repo-specific L1-3 · master run-master byte-identical seeding · propagate --prune EXCLUDE → 수동). **⑥** mode-system §4 자식 헌법 경로 `<repo>/.claude/CLAUDE.md` → `<repo>/CLAUDE.md`(root 실측 3 자식). **⑦** 부재 `.auto-memory/cycle-handoff.md` ×2 — cycle-discipline:270 역사 인용 라벨(현행 `.ai/reports/<taskId>/HANDOFF.md` 병기) + text-degeneration:128 현행 HANDOFF.md retarget. **⑧** `archive/propagation-status.md.bak`(untracked) → `archive/2026-06/` 정식 등재 + INDEX 1행(rm deny → mv-only 정책 정합). **⑨** measure-gsm-cycle.sh `stale_pointer_count()` scan 확장 — md-link 한정 → backtick `.sh/.json/.md` 추가(master-owned dir `.claude/`/`scripts/`/`.auto-memory/`/`docs/agent/`/`docs/schemas/` 한정 · FP 억제 placeholder`<>`/glob`*`/var`$`/cross-repo`../`/`settings.local.json`) + scope-한계 label(proxy band 전례 동형 · non-backtick/자식-context/cross-repo/§-level 미검출 명시) + `GSM_STALE_SELFTEST` fixture. **⑩** rule-routing-index L0 note "본 42 집합" → "본 46 집합"(§A 헤더 46 정합). **검증**: propagate ok=50/0 · verify-sync **160/0/0** · ⑨ self-test=3(F3 compound-lint + F5 solutions/README + md-link) · 실 `.claude/rules` stale 7 surface(§8 별 cycle) · baseline-snapshot 6-repo PDOCS block 재생성 ✓ · 보호 5 sha drift 0(edit-set ∩ 보호 = ∅) · production 0 LOC · "5-repo" 어휘 무접촉(O7). **후속(별 cycle)**: ② compound-lint 107-ref · ⑨ surface 재확인 **F4·F9 보호 file stale 2**(pencil-uiux-workflow.md `.claude/hooks/save-as-result-check.sh`→`scripts/` + uiux-sot-refresh.md `scripts/agent/repo-config.sh`→`scripts/` · §6 STOP ② 무접촉) · ④ scope-외 동족 3(routing:268 + docs-change-communicator:28 + DOC_TASK_TYPES:88) · O7 어휘 sweep. | **6-repo 적용** (master `7654d36` + 5 자식 propagate byte-identical 10 cli-infra file: FND `c862134` / GB `12d04f1` / GD `3e13aca` / GT `94e0752` / PDOCS `0a108dd` · ⑤ PDOCS-only `63a3e6a` · ⑧/§15/propagation-status = master-only · REPORT = propagation-reports/MASTER-CLI-DEAD-REF-SWEEP-001/REPORT.md) |
| MASTER-CLI-PROTECTED-STALE-PATH-FIX-001 | 2026-06-10 | 보호 file 2종 본문 stale 경로 3곳 수술 정정 (Mode M5 cli-infra-ops · production 무접촉 · DEAD-REF-SWEEP-001 후속 F4·F9 land + Coin lineage 조항 폐기 본심 회수 완료). **scope** = 보호 2 file 본문 3곳 한정(1 char 외 무변경 · §6 STOP ① 회피). **본질**: ① `pencil-uiux-workflow.md`:12 save-as-result-check.sh hook 경로 `.claude/hooks/`→`scripts/` 실위치 정정(S4 이동 기마감 반영 · design-to-code-sync.md:97 선례 정합 · pencil-auto-save.sh 는 hook 유지 무접촉) ② `uiux-sot-refresh.md`:61 repo-config.sh 경로 `scripts/agent/`→`scripts/` 정정(실위치=scripts/ · scripts/agent/=frontmatter-grep.sh 단독) ③ `uiux-sot-refresh.md`:27 lineage 계약 조항(seed_audit_reference.md · `.ai/uiux-sot/lineage/` dir 6-repo 전수 부재 · 이행 0회) 폐기(strikethrough+폐기 명시 1줄 · git diff/commit 갈음 · Latest-Only Policy 정합). **2층 hash resync**: manifest sha-256(pencil `e6a4a2a1…`→`52c07576…` · uiux `ee377dc2…`→`75c0c47e…`) + §14a git-sha1(pencil `9d47624a…`→`bac8e801…` · uiux `d3a0b573…`→`b9a0c584…` · ⚠ algorithm 교차 기입 X) · 나머지 보호 3 sha 변동 0. **검증**: propagate ok=10/0 · verify-sync **160/0/0**(stale-ref WARN 0 — manifest Recent-updates 구경로 backtick→dir-only 회피) · 6-repo byte-identical(pencil sha-256 `52c07576…` · uiux `75c0c47e…`) · production/도메인 0 LOC · §0 의무② latest.json PDOCS block 존재 ✓ · `uiux-sot-refresh.md`:22 `lineage/` Package Boundary 서술 = scope 외 무접촉. **후속(scope 외)**: :22 `lineage/` historical-reference 서술 정합 재검 · DEAD-REF-SWEEP ② compound-lint 107-ref · ⑨ surface stale 잔여 · O7 어휘 sweep. | **6-repo 적용** (master 본 commit + 5 자식 propagate byte-identical 보호 2 file: FND `5598b0e` / GB `282cb23` / GD `4bd47eb` / GT `612b11f` / PDOCS `2f2e5a9` · manifest/§14a/§15/propagation-status = master-only · REPORT = propagation-reports/MASTER-CLI-PROTECTED-STALE-PATH-FIX-001/REPORT.md) |

| MASTER-CLI-COMPOUND-LINT-DEPRECATE-001 | 2026-06-10 | 존재한 적 없는 도구 compound-lint.sh 인용 전량 일괄 deprecate — 검증 의무 보존·수단만 실존 도구 재배선 (Mode M5 cli-infra-ops · production 무접촉 · DEAD-REF-SWEEP ② HOLD 의 Coin 본심 회수 = 일괄 deprecate 확정 + 보호 잔여 2건 동반). **2-stage**: Stage A = 비보호 운영 live 25 file(rules 5 + skills 4 + commands 2 + agents 5 + hooks 1 + docs/agent 4 + docs/backend RLS guide + CLAUDE.md §7 행 + .github PR template + .ai/uiux-sot/refresh/VERIFY.md) · Stage B = 보호 5 file 7줄(compound-lint 5줄 = design-sot-policy 3 + pencil-sot-policy 1 + ui-spec.schema.json 1(JSON parse PASS) + :22 lineage Package Boundary 폐기 연장(PROTECTED-STALE-PATH-FIX :27 정합) + :9 design-sot-refresh→uiux-sot-refresh 명칭 오기 정정 = F4 동족). **처분(전수 117줄 -i 기준)**: 재배선 61 · 제거 17(RLS guide 8블록 16줄 + CHECKLIST Refs 1행) · 라벨-보존 4(drift-auditor 예시 · gsm hook 죽은-인용 예시 · PROPAGATION_PARAMETERS 2) · 역사 무접촉 35(.ai/reports + propagation-reports + COLD + §15/§F 이력행). 대체 수단 = 시크릿 패턴 grep(safety-and-secrets §시크릿 스캔 패턴) + ls 산출물 검사 + `git diff --name-only` 실측(8c 대체) + layer-checker/check-layer(I2) + ktlint warn-gate(Lint 표) + /verify-all 3단 재구성. **2층 hash resync**: manifest sha-256 5/5 + §14a git-sha1 5/5 (algorithm 교차 X · 보호 5 전수 변동). **검증**: 잔존 grep = deprecate 라벨분+역사 이력행 외 0 · 실행형(`bash …/compound-lint.sh`) live 0 · gsm 스캐너 rules backtick 0 · ui-spec JSON 구조 무결 · verify-sync = REPORT 참조 · production 0 LOC. **81/107 reconcile**: 107 = DEAD-REF-SWEEP 시점 master 전체 → 이후 cycle 산출물·§15 역사 줄 +8 = 115 실측(-i 117) · 81 = cowork 운영-live 한정 집계. **후속(scope 외)**: PROPAGATION_PARAMETERS repo-config identity 인터페이스 광역 stale(REPO_NAME 등 변수 미export 실측) · pencil-uiux-workflow:11 `pencil-sot-binding.md` 명칭 잔존 · layer-checker scripts/agent/repo-config.sh 경로 stale · O7 "5-repo" 어휘 sweep · COMPOUND.md artifact 존치 재평가. | **6-repo 적용** (master 본 commit + 5 자식 propagate byte-identical 29 file: FND/GB/GD/GT/PDOCS · manifest/§14a/§15/propagation-status = master-only · REPORT = propagation-reports/MASTER-CLI-COMPOUND-LINT-DEPRECATE-001/REPORT.md) |
| MASTER-CLI-REPO-COUNT-VOCAB-SWEEP-001 | 2026-06-10 | v17.1(PDOCS 6번째 repo 합류) 이후 stale "5-repo" 어휘를 live 규범 본문에서만 현행화 + 비보호 소형 잔여 3 (Mode M5 cli-infra-ops · production 무접촉 · audit P2 O7 · blanket sed 금지 = 건별 행-단언 치환표 180 적용 · P2-RENAME 동결 보존 전례 정합). **집계 기준** = literal "5-repo" -i · 행 단위 · live 영역(rules/agents/skills/hooks/commands + scripts/*.sh + CLAUDE.md live + 부모 root) 진입 219행. **처분**: live 정정 157(자식 수=5 vs repo 수=6 의미 단위 — "master + 4 자식"→"master + 5 자식" · 열거 +gently-product-docs disk 실측 후) · 역사 박제 46(각 rule 이력행·§15·§F·갱신/결함 역사 — 그 시점 사실) · STOP③ 실태-정합 보존 8(instructions-loaded hook 7 + pencil-pending-sweep 1 = REPOS 하드코딩 5 · 거짓 라벨 회피) · 키워드 병기 4("6-repo" 추가 + "5-repo" 보존) · 모호 보존 4(rri §E·code-style §E cycle 자기서술 + text-degen 실측 baseline + domain-roles reconcile) · **보호 내 발견 0**(표면화 대상 무·보호 체인 미발동). **소형 3**: ① design-to-code-sync :12/:87 design-sot-refresh→uiux-sot-refresh(의미 병기) ② layer-checker scripts/agent/→scripts/ ×4 ③ 동족 check-layer/SKILL ×4 (+동반: propagate.sh usage FND 병기 · CLAUDE.md §3 --targets 현행화 · arch-link/supabase 열거 PDOCS 실측 추가). **검증**: 보호 5 sha drift 0 · live 현재형 잔존 0(잔존 62 = 보존 4분류 전수) · propagate ok=225/0 → run-master 자식 5 재seeding **즉발 자체 회수**(git rm+amend · run-* = repo-specific L1-3 · DEAD-REF ⑤ 전례 · propagate.sh 명시-cp 가드 부재 표면화) → 실효 44 file × 5 · verify-sync **160/0/0** · 자식 신규 dirty 0 · 부모 root CLAUDE.md §7 정합 직접 갱신(신 sha-256 `64ebf82c`) · production 0 LOC. **후속(scope 외)**: docs/** 잔존 15행 · instructions-loaded+pencil-sweep 6-repo 계측 확장 · 구세대 "3-repo"/"4 자식" 어휘(working-file-lifecycle 5 위치 포함) · propagate.sh run-* 가드 · G3=별 cycle 6 · B body=Coin paste. | **6-repo 적용** (master `558af38` + 5 자식 propagate byte-identical 44 cli-infra file: FND `a69a0af` / GB `d50c519` / GD `9e4aff6` / GT `7f188ff` / PDOCS `c937f4f` · scripts 4 + CLAUDE.md = master-only · 부모 root = git-외 직접 · REPORT = propagation-reports/MASTER-CLI-REPO-COUNT-VOCAB-SWEEP-001/REPORT.md) |
| MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001 | 2026-06-10 | Pencil v1.1.62 4종 제거 stale sweep **Phase B** — 보호 2 file 본문의 제거-도구 참조 현행화 + sha 3-layer resync (Mode M5 cli-infra-ops · production 무접촉 · TOOLSET-REMOVAL Phase A 0e1f7e3 defer분 = Coin 큐 확정 06-10 집행). **scope** = 보호 2(`pencil-uiux-workflow.md` :11/:20/:22/:45/:56/:68/:93 + `pencil-sot-policy.md` :40/:77 · 내용 기준 재탐색 = 원 좌표 전수 현행 일치) + 동반 비보호 `cycle-discipline.md`:227(잔존 실측 후 계약 허용분 · :164 = §13 게이트 정합 서술 = 무접촉). **본질**: ① 도구수 12+1→9(= tools-reference §0.1 pointer · 목록 중복 0) ② OPTIMIZATION-001 추가 5종 lineage = 현존 2(get_guidelines/export_nodes)+제거 3 명시 ③ Type 1/2/3 open_document step→현 메커니즘(Type 1 = `open -a Pencil <abspath>` active-doc · Type 2/3 = headless `pencil interactive -o` 신설+시각 진입) ④ STOP moot 항(open_document path-arg) 2곳→제거 4종 부활/9종 변동 검출 STOP ⑤ §2 표 캔버스 열기 행→headless PRIMARY+시각 alternative ⑥ audit backlog ⑥: `pencil-sot-binding.md` 죽은 명칭→실 file `pencil-sot-policy.md`(의미 alias 병기 보존). **§2.5/§9 headless-primary 본질 무접촉**. **sha 3-layer**: manifest sha-256(`2ec100bf…`→`b09b8d50…` · `ae20a79c…`→`2bfc81c5…`) + §14a git-sha1(`22570f97…`→`aba157e0…` · `acf88d95…`→`ce9c0d3e…`) + baseline-snapshot 재생성(직전 2-cycle stale `e6a4a2a1…`/`96de2f5d…` 정합 + PDOCS block 첫 포함) · 나머지 보호 3 변동 0. **검증**: §13 self-test 3/3(CC 2.1.170 + pencil Connected + ToolSearch 9종 전수 + 제거 4종 부재) · propagate ok=15/0 · verify-sync **160/0/0** · 제거 4종 잔존 = 제거-라벨 서술만 · 기존 dirty 무접촉(GB 2 · GD/GT 각 1) + 신규 dirty 0 · production 0 LOC. **후속(scope 외)**: §15 hot 11 entry > 10 = cold 재이전 advisory(별 판단). | **6-repo 적용** (master `57af6de` + 5 자식 propagate byte-identical 3 file: FND `1c3ce90` / GB `9170dd8` / GD `68cbe3e` / GT `41683b0` / PDOCS `b963ac8` × pencil-uiux-workflow + pencil-sot-policy + cycle-discipline · manifest/§14a/§15/incident-log/snapshot = master-only · REPORT = propagation-reports/MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001/REPORT.md) |
| MASTER-CLI-CC-VERSION-UPDATE-NATIVE-EVAL-001 | 2026-06-11 | Claude Code 버전 latest-chase 확인(npm @latest = **2.1.170** · 진입 시점 이미 latest = `npm install -g @latest` no-op) + native installer 전환 평가 박제 (Mode M5 cli-infra-ops · production 무접촉). **scope** = `cycle-discipline.md §13`(native installer 재검토 trigger 블록 신설 · 기존 §13 본문 무변경 · 6-repo propagation) + master-only `incident-log.md`(LATEST-CHASE PASS + NATIVE-MIGRATION-EVAL 2 trail) + `CLAUDE.md §15`. **본질**: ① npm 통제형 수동 갱신 확인 + self-test **3/3 PASS**(CC 2.1.170 + `pencil ✓ Connected` + ToolSearch 9종 named-set 전수 · 게이트 = PENCIL-SELFTEST-GATE-RECALIBRATE baseline · 구 ≥13 폐기) → LATEST-CHASE trail PASS entry(직전 PASS 2.1.139 · 회귀 X). ② native 전환 평가 = **전환 X** (auto-update 통제 미실효 #60956 OPEN 2026-06-11 live-verify + symlink 강제 재생성 #41602/#3010/#28625 미해결 + 설치 후 pin 부재) → §13 재검토 trigger 4조건 박제. setup-guide npm 참조 = 정책 정합(무변경). **self-re-anchor**: paste baseline `424644…` → 진입 `157a2c5` → 실행 중 `fc51d04` re-drift(PENCIL-PHASE-B 완결 cycle · 본 scope 와 orthogonal) · §13 줄번호(insert @203) + 보호 sha 라이브 재유도 · self-test 게이트 ≥13→9 정정. **검증**: self-test 3/3 + 보호 5 sha drift 0(edit-set ∩ 보호 = ∅ · fc51d04 재baseline 5/5 manifest 일치) + propagate ok=5/0 + verify-sync 무회귀(PHASE-B 160/0/0 baseline 유지) + production/도메인 0 LOC + 기존 child dirty 무접촉(GB 2·GD/GT 각 1) = propagation-reports/MASTER-CLI-CC-VERSION-UPDATE-NATIVE-EVAL-001/REPORT.md 확정. **후속(scope 외)**: trigger 충족 시 native 전환 별 cycle · npm 하드 EOL 모니터 · §15 hot >10 cold 재이전 advisory. | **6-repo 적용** (master 본 commit + 5 자식 propagate `cycle-discipline.md` byte-identical: FND/GB/GD/GT/PDOCS · incident-log/§15 = master-only · REPORT = propagation-reports/MASTER-CLI-CC-VERSION-UPDATE-NATIVE-EVAL-001/REPORT.md) |
| MASTER-CLI-INFRA-SMALL-BATCH-001 | 2026-06-11 | OPS 위생 소형 3건 일괄 — 오늘 audit/sweep 표면화 기계적 잔여 (Mode M5 cli-infra-ops · 도메인 키워드 0 · production 무접촉 · audit backlog ②③⑪). **① hook 6-repo 계측 확장**: `instructions-loaded-baseline-verify.sh`(REPOS 5→6 +gently-product-docs + 7 wording행 "5-repo"→"6-repo": :7/:44/:45/:46/:56/:81/:129) + `pencil-pending-sweep.sh`(REPOS 5→6 + :34 wording · PDOCS = pencil-sot dir 부재 → graceful skip) — REPO-COUNT-VOCAB-SWEEP-001 STOP③에서 "실태-정합 보존"했던 8행(=instructions 7 + pending 1)이 REPOS 확장으로 거짓이 되어 동반 현행화(baseline-snapshot.sh 6-repo 전례 = DEAD-REF-SWEEP ① 동형). **② propagate run-* cp 가드**: `propagate.sh` C16 신설 — `--prune` EXCLUDE만 있고 순방향 cp(--all find 자동 포착 + 명시 인자)엔 가드 부재 → `.claude/skills/run-*` 포함 시 skip+WARN(FILES 해결 직후 case-glob · runtime-crash-mitigation 하이픈 경계 비매칭 = DIFFERENTIATION-SCOPE-001 동형). 실증 = PROPAGATE-RUN-SKILL-RESEED-001(incident · run-master 자식 5 재seeding). **③ GT pre-push gate 정합**: 의도 근거 실측 = PRELAUNCH-CI-GATE-001(COLD:93) "GB/GD/GT 3앱 pre-push hook(core.hooksPath) 이중 발화" + GT install.sh 주석("per-clone local 설정 · 새 clone 마다 1회 실행") + GT 게이트 생성 commit `4e910c7` + hook file 실존 = **제외 의도 0 · unset = install.sh 미실행 gap** → GB/GD 동형 `git config --local core.hooksPath scripts/githooks`(repo-local · 비커밋 · 전파 X · GT 단독). **검증**: bash -n 3/3 + instructions-loaded live = 6-repo HEAD 블록(PDOCS=1db90fc 포함) + 보호 drift 0 + 가드 self-test(run-master 단독 WARN+exit2 비변경) + propagate ok 5(instructions)+4(pending) + verify-sync **160/0/0** + pencil-pending-sweep 4-child byte-identical `6875f63e`(verify-sync 미추적 수동) + GT 3-child hooksPath 동형 + 보호 5 sha drift 0(edit-set ∩ 보호 = ∅) + 기존 dirty 무접촉(GB 2·GD/GT 각 1) + 신규 dirty 0 + production 0 LOC. **후속(scope 외)**: §15 hot 13 > 10 = cold 재이전 overdue(CC-VERSION entry 후속 flag 정합 · 별 판단). | **혼합 scope** (master `513f964` + instructions-loaded → 5 자식 byte-identical `67d47ac6`: FND `f5c8b96`/GB `ecb8105`/GD `5e61110`/GT `3af52a0`/PDOCS `ab846b0` · pencil-pending-sweep → 4 자식 `6875f63e`(FND/GB/GD/GT · PDOCS 미보유) · propagate.sh = master-only · GT core.hooksPath = GT-local 비커밋 · §15/incident = master-only · REPORT = propagation-reports/MASTER-CLI-INFRA-SMALL-BATCH-001/REPORT.md) |

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
