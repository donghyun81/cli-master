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
| FND-DOCSYNC-HOUSEKEEPING-001 | 2026-06-05 | core/CLAUDE.md DocSync 정정 (Mode M1 production-graduated · PRELAUNCH-EXEC2 chat 완료 cycle 기록 · 본 §15 doc-only append · master cli infra 로직 무접촉). **scope** = FND `core/CLAUDE.md` 문서 + task 상태. **본질**: core/CLAUDE.md 모듈 상태표 정정(8 active + 3 dormant) · `FND-GRADLE-BASELINE-001` STOP→DONE 전환(사유 소멸 실측) · FND-T03 → DONE. **side-finding(scope 외)**: core/CLAUDE.md "6-repo ecosystem" ↔ A12 anchor 어휘 혼선 → 5-repo 통일 후보(cli infra). | **FND 적용** (FND `ba1257a` · master = 본 §15 entry append only) |
| GB-EF-HARDENING-001 | 2026-06-05 | verify-purchase / verify-integrity Edge Function hardening (Mode M3 migration-safe · PRELAUNCH-EXEC2 chat 완료 cycle 기록 · 본 §15 doc-only append · master cli infra 로직 무접촉). **scope** = GB Supabase Edge Function. **본질**: (a) verify-integrity raw-key Bearer → Service Account OAuth2(`PLAY_INTEGRITY_SCOPE` 파라미터화 · NEW secret 0). (b) verify-purchase ticketCount 서버 도출(`SKU_TO_TICKETS` 매핑 + mismatch reject — 클라이언트 inflation 경로 봉합 · 4-field contract 유지). (c) CI deno-test job 추가(blocking). **검증**: deno 53/0 PASS · deploy 미실행(Play 직전 일괄). **Money 후속**: `GB-BILLING-CLIENT-001` side-finding(ticketCount 서버 미검증) 봉합 cycle. | **GB 적용** (GB `25940de` · master = 본 §15 entry append only) |
| GB-PHASE-R-PEN-SWEEP-001 | 2026-06-05 | Pencil SoT Phase R 역공학 sweep (Mode M1 production-graduated · PRELAUNCH-EXEC2 chat 완료 cycle 기록 · 본 §15 doc-only append · master cli infra 로직 무접촉). **scope** = GB `docs/design/pencil-sot/` 6 화면. **본질**: 6 화면 `.pen`+`ui-spec.json` 역공학([CURRENT] 회복) · Main 제외(nav scaffold). **검증**: ajv 6/6 PASS · sha linkage 6/6 PASS. **a11y 부채(정직 기록)**: `#7B9BCC` 2.7:1 대비 FAIL(후속 후보). | **GB 적용** (GB `737f6e9` · master = 본 §15 entry append only) |
| GD-PHASE-R-PEN-SWEEP-001 | 2026-06-05 | Pencil SoT Phase R 역공학 sweep (Mode M1 production-graduated · PRELAUNCH-EXEC2 chat 완료 cycle 기록 · 본 §15 doc-only append · master cli infra 로직 무접촉). **scope** = GD `docs/design/pencil-sot/` 1 화면. **본질**: daily-suggestion 1 화면 역공학(GD 10건 기회복) · Main 제외. **검증**: cowork disk cross-verify PASS. | **GD 적용** (GD `06445b2` · master = 본 §15 entry append only) |
| GT-PHASE-R-PEN-SWEEP-001 | 2026-06-05 | Pencil SoT Phase R 역공학 sweep + Crashlytics guard (Mode M1 production-graduated · PRELAUNCH-EXEC2 chat 완료 cycle 기록 · 본 §15 doc-only append · master cli infra 로직 무접촉). **scope** = GT `docs/design/pencil-sot/` 5 화면 + Crashlytics 설정. **본질**: 5 화면 역공학 + Crashlytics `mappingFileUploadEnabled=false` guard. **발견(후속 후보)**: 구 4 `.pen` green↔terracotta TARGET drift(recolor 후보) + `#E07A5F` a11y 대비 FAIL. | **GT 적용** (GT `27f8e22`+`c993d52` · master = 본 §15 entry append only) |
| MASTER-PRELAUNCH3-SMALLFIX-001 | 2026-06-05 | master 소형 정정 5건 (Mode M5 cli-infra-ops · PRELAUNCH-EXEC3 wave 1 · 실 master cli infra 변경). **scope** = master rule/hook/scripts + FND doc. **본질**: ① `billing-rules.md §5` "GT 한입 티켓" → 자식별 ticket 상품 일반화(실 구현 예 GB `rest_tickets` · disk 실측 GB 10 file/GT 0). ② `check-abbreviation.sh` `ALLOWED_FRAMEWORK_IDENTIFIERS` whitelist 신설(Play Billing 3종 통과 · btn/params var 여전 block). ③ "6-repo"→"5-repo" 어휘 통일(anchor-list-COLD A12 + PACKAGE-OVERVIEW + FND core/CLAUDE.md+docs/CLAUDE.md L4). ④ `save-as-result-check.sh` 절대경로 → `repo-config.sh` `$PARENT_DIR` 통합. ⑤ verify-sync/propagate `docs/agent/audits/*` exclusion 추가(TESTING-BACKFILL-AUDIT.md false-MISS 봉합). **검증**: verify-sync 160/0/0(이전 160/0/4) · 보호 5종 sha drift 0 · advisory check-abbreviation sha 갱신 · cowork disk cross-verify 5/5 PASS. | **master 적용** (master `44e5ac5` · 5-repo propagate cc4ca21/679e4cf/8db1be7/025debb/9a5efee · FND `f8ba1d9`+`8db1be7`) |
| GB-A11Y-THEME-001 | 2026-06-05 | GB primary WCAG AA 정정 (Mode M1 production-graduated · PRELAUNCH-EXEC3 wave 1 · 본 §15 doc-only append · master cli infra 로직 무접촉). **scope** = GB `GentlyBreathTheme.kt` + `docs/design/pencil-sot/` 5 화면. **본질**: light primary `#7B9BCC`(2.5~2.84:1 FAIL) → `#426AA9`(4.61~5.43:1 AA · hue 216° soft sky blue 보존 · L 64→46% darken · on/container/dark scheme 무변경=최소). .pen 5 화면(breath-guidance/home/meditation/result/session-select) remap + sha 재동기 · 4 화면(login/onboarding/splash/settings) SKIP(별 accent #6B7DB3) · upgrade-account SKIP(green primary). **검증**: residue 0 · compileStagingDebugKotlin EXIT 0 · 보호 5종 무접촉 · cowork disk cross-verify PASS. **a11y companion FAIL(scope 외·별 cycle)**: #6B7DB3 palette B(4.0/3.8 FAIL) · #7A8694 outline aux(3.5 FAIL · theme blast radius) · #7BAE7F upgrade-account green drift(2.56 FAIL + sky-blue brand 이탈). | **GB 적용** (GB `848905d` · master = 본 §15 entry append only) |
| GT-A11Y-RECOLOR-001 | 2026-06-05 | GT primary WCAG AA 정정 + .pen drift recolor 일괄 (Mode M1 production-graduated · PRELAUNCH-EXEC3 wave 1 · 본 §15 doc-only append · master cli infra 로직 무접촉). **scope** = GT `GentlyTableTheme.kt` + `docs/design/pencil-sot/` 9 화면. **본질**: ① theme primary `#E07A5F` 살몬(2.60~2.90 FAIL) → `#A84A32` 딥 테라코타(5.02~5.59 AA · hue 12° 보존) + onPrimary cream flip. ② 구 green drift `#4A7C59`×11(splash/login/onboarding) → `#A84A32` clean remap. ③ `#7A7067` retired onSurfaceVariant×37 → `#685E54` · `#3A1408` btn label×2 → cream. ④ `#81B29A`×11 = theme secondary 정합 → 보존(drift 아님). ⑤ Phase R 5 화면 + daily-prescription(§8 자율편입) E07A5F→A84A32 + ui-spec WCAG annotation 9건 stale 정정. **검증**: dual-layer sha 9/9 MATCH · active drift 0 · compileStagingDebugKotlinAndroid EXIT 0 · 보호 5종 무접촉 · cowork disk cross-verify PASS. **followUp(scope 외)**: splash #8A9590(2.9 FAIL · 신 palette 필요) · annotation 과대표기 11건 · Roborazzi snapshot 재기록(Phase D-2). | **GT 적용** (GT `eea5641` · master = 본 §15 entry append only) |
| GD-GRAYTRAP-RECOLOR-001 | 2026-06-05 | GD gray-trap recolor — STOP(stale · 기집행) (Mode M1 production-graduated · PRELAUNCH-EXEC3 wave 1 · 본 §15 doc-only append · 변경 0 · commit 0). **scope** = GD `docs/design/pencil-sot/` 11 화면(read-only 측정). **본질**: cc-paste premise(gray-trap 잔존 + role-gap 4 화면) = stale. disk 실측 = recolor 가 `bd6aa02`(MASTER-CLI-PENCIL-RECOLOR-GENERATOR-001 · HEAD 조상)에서 GD 24-role full scheme + .pen recolor 로 기집행 → 전 11 .pen gray-trap hex 0 occurrence · role-gap 0(4 role 이미 scheme 정의 · cowork .pen/.ui-spec 분리 측정 재확인). off-token(일러스트/차트 #D8D9DB) = 보존(사람 결정). **판정**: STOP #4(예상 외 시스템 상태 = stale 후보) · A5 recommended-option-disk-verification — generator 무실행(색 0 변경 · 재포맷만 = SYNC 파괴 + 거짓 progress 회피). **검증**: dual-layer sha 11/11 SYNC · cowork disk cross-verify PASS(.pen role-gap 0 확인 · premise reconcile). | **GD 무변경** (GD HEAD `aafdda9`=W-A propagation · recolor 기집행 = `bd6aa02` · master = 본 §15 entry append only) |

> **§15 cold 재배치** (= `MASTER-CLI-CONTEXT-OPT-PHASE1-CYCLE-HISTORY-COLD-001` 2026-06-01 + `MASTER-CLI-CONTEXT-OPT-CYCLE-HISTORY-COLD-002` 2026-06-04 2회차 + `MASTER-S15-PRELAUNCH-EXEC2-B-001` 2026-06-05 3회차 + `MASTER-S15-PRELAUNCH-EXEC3-001` 2026-06-05 4회차): 위 표 = 최근 5 entry + 본 cycle entry 만 hot 유지 default. master cycle **90 entry 전체 이력** (= `C1-MASTER-BOOTSTRAP-001` ~ `GB-BILLING-CLIENT-001`) = verbatim 보존 → [`.auto-memory/master-cycle-history-COLD.md`](.auto-memory/master-cycle-history-COLD.md) (= 삭제 0 · 감사 추적 영구 보존 · lifecycle = 매 5 cycle 또는 분기 review). 신규 master cycle = 본 표 append (§16 절차) + 누적 시 cold 재이전.

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
