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
> **그 외 일반 어휘** (SoT/SSOT 등): `docs/rules/terminology.md` 참조.

---

> **이 repo 는 cli infra + 보호 파일의 단일 source-of-truth.**
> 자식 repo (app-foundation / gently-product-docs / Selfward / 향후 추가) 는 본 repo 에서 단방향 propagation 을 받는다 (= 4-repo · 2026-07-17 T6 재편 · GB/GD/GT = 동결 계승 원천 = 전파 대상 X · §1.3).
> 시간대: Asia/Seoul (KST) · 운영 CLI: Claude Code 단일.

---

## 0. master repo 의 책임 (3 개)

> **이 repo = generic cli infra master · 도메인 코드 hub 아님.**
> 현재 활성 도메인 자식 = Selfward 「나에게로」 단일 (= 1 앱 N 도메인 · §1.1 · 구 Gently 패키지 3 자식 GB/GD/GT = 2026-07-17 T6 동결 계승 원천 · §1.3) 한정으로 운영되나, `scripts/` + `.claude/` cli infra + `docs/agent/`·`docs/schemas/`·`docs/templates/` 는 도메인 무관 = 다른 앱 패키지 (예: SteadyWell · 향후 신규) 로 확장 가능.
> 자칭 = `claude-cli-master` (`.auto-memory/decision-log.md` / `.auto-memory/protected-file-hashes.md` / `.auto-memory/child-claude-md-header.template.md` 일치). 폴더 이름 = 본 의도 명시.

### 0.1 baseline 3 줄 (= 2026-05-22 신설 default · `MASTER-CLI-CYCLE-0-OPS-EXCEPTION-BASELINE-3LINE-001`)

- **1 앱 N 도메인 = Selfward 「나에게로」 단일 사용자 base default** (= 2026-07-17 T6/T7 현행 default). 구 GB (= 마음 가꾸기) + GD (= 배움) + GT (= 몸 돌봄) 3 도메인 = Selfward 흡수 계승 default (= §1.1 · `shared/` 실측 mood / learning / daily 등) · 사용자 base 분리 X default. 공유 = cli infra + app-foundation default.
  - **supersession 이력** (= 구 baseline 보존 · 삭제 0): 직전 판 = "**3 앱 = 도메인별 독립 사용자 + 공유 인프라 default** (L1-3 정합 default) · GB/GD/GT 측 사용자 base 분리 default · '한 사용자가 3 앱 묶어서 산다' 가설 무효 default · 미공유 = 사용자 base default" (= 2026-05-22 `MASTER-CLI-CYCLE-0-OPS-EXCEPTION-BASELINE-3LINE-001` 신설 · L1-3 인용). 본 가설 = **1 앱 N 도메인 재편(T6)으로 supersede** default (= 3 앱 분리 전제 자체가 소멸 · L1-3 서술 = 이력 영역 보존 default).
- **1 인 운영 + AI reviewer = 의식적 선택 default** (L1-5 정합 default). 인간 reviewer 부재 = 의도된 architecture default · cli session 측 reviewer 역할 default (= `routing-and-delegation.md` reviewer 영역 default · `verification-and-review.md §독립 reviewer` 영역 default).
- **현 단계 = 4-repo (= master + 자식 3 · §1.2) 동일 mode / 미래 = 자식별 발산 허용 default** (L1-6 정합 default · 2026-07-17 T6 재편 = 구 "6-repo 동일 mode" 판 현행화). 현 4-repo 측 default mode = production-graduated default (= `mode-system.md` Cycle 4 신설 시점 default · 본 cycle 측 implicit default 영역 default) · 미래 자식별 mode 발산 = 본인 명시 결정 + migration cycle default.

1. **cli infra SoT 보유** — `.claude/` (agents/commands/hooks/rules/skills/settings) + `docs/schemas/` + `docs/design/pencil-sot-policy.md` 의 정합 source.
2. **propagation 도구 제공** — `scripts/propagate.sh` / `scripts/verify-sync.sh` / `scripts/activate-agent.sh` / `scripts/report-gen.sh` (C3 에서 신설).
3. **propagation 결과 보고** — `propagation-reports/<cycle-id>/REPORT.md` 누적.

자식 repo 는 위 3 개에 의존만 함. 자식 repo 가 cli infra 직접 수정 금지 (단방향 정합 강제).

> **역할 정합 진행중** (2026-07-13 · Coin): 본 repo = CLI/agent 도구 SoT. 제품/앱 표준(templates·schemas·design·backend·guides·architecture·도메인 rules·보호 5)은 역할상 분리 대상 → 감사·분리 지도 = `docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md`. 물리 분리 = 필요 시(Coin 결정).

---

## 1. 자식 repo 등록 (2026-07-17 재편 · `MASTER-T6-REPO-REALIGN-001` + `MASTER-T7-INSTRUCTIONS-REALIGN-001` · placeholder · 변경 가능)

### 1.1 활성 도메인 자식 (= Selfward 단일 · 1 앱 N 도메인)

| 자식 repo | 표시명 | 도메인 | 패키지 (appId) | 절대 경로 (placeholder) |
|---|---|---|---|---|
| Selfward (SW) | 「나에게로」 | **1 앱 N 도메인** (= `shared/` 실측 = mood · learning · daily · record · reply · companioninsight · ticketshop 등 · 구 GB+GD+GT 3 도메인 계승 흡수) | `com.gently.selfward` (staging = `com.gently.selfward.staging`) | `<PARENT>/Selfward` |

### 1.2 propagation 대상 자식 3 (= master 단방향 propagate · SoT = `scripts/repo-config.sh` TARGET_REPOS)

| 자식 repo | 역할 | 절대 경로 (placeholder) |
|---|---|---|
| app-foundation (FND) | shared KMP/CMP foundation | `<PARENT>/app-foundation` |
| gently-product-docs (PDOCS) | 공통 제품 기획·비전 문서 | `<PARENT>/gently-product-docs` |
| Selfward (SW) | 활성 도메인 자식 (= §1.1) | `<PARENT>/Selfward` |

cli infra byte-identical 형상 = **4-repo** (= master + 위 자식 3).

### 1.3 동결 계승 원천 (= 2026-07-17 `MASTER-T6-REPO-REALIGN-001` 전파 대상 제거 · 원본 보존 · 쓰기 0)

| 자식 repo | 도메인 | 패키지 | 절대 경로 (placeholder) | 처분 |
|---|---|---|---|---|
| GentlyBreath (GB) | 마음 가꾸기 | `com.example.gentlybreath` | `<PARENT>/GentlyBreath` | 동결 · 전파 대상 제거 (2026-07-17 T6) · GitHub archive 보류 (= Coin 콘솔 몫) · 원본 보존 |
| GentlyDay (GD · 앱 GentlyLearn) | 배움 | `com.example.gentlyday` | `<PARENT>/GentlyDay` | 동일 |
| GentlyTable (GT) | 몸 돌봄 | `com.example.gentlytable` | `<PARENT>/GentlyTable` | 동일 |

동결 = **계승 원천** (= Selfward 가 위 3 도메인 흡수 계승 · §1.1). repo 삭제 X · cli session 측 **쓰기 0** (= read-only 인용만 · 쓰기 필요 = STOP). `GB-*` / `GD-*` / `GT-*` task ID prefix + 기존 §15 이력 인용 = 보존 (= 이력 소실 0).

`<PARENT>` 는 환경별 변수 (예: `~/AndroidStudioProjects` · `$ANDROID_PROJECTS_ROOT`). `scripts/propagate.sh` 가 자동 해결.

신규 자식 repo 추가는 §1.2 표에 행 추가 + `repo-config.sh` TARGET_REPOS 등재 + 첫 propagation cycle 진입.

---

## 2. 정합 강제 3 등급 (`cycle-discipline.md` §3 명시됨)

| 등급 | 대상 | 강제 수준 | drift 발생 시 |
|---|---|---|---|
| **보호 파일 (강제)** | 5 종 — `docs/schemas/ui-spec.schema.json` · `docs/rules/pencil-uiux-workflow.md` · `docs/design/pencil-sot-policy.md` · `docs/rules/uiux-sot-refresh.md` · `docs/design/design-sot-policy.md` | master ↔ 자식 byte-identical 의무 | 즉시 mitigation cycle (리뷰 블로커) |
| **cli infra (권장)** | 53 + α — `.claude/` 전체 + `.claude/settings.json` 등 | 권장 byte-identical | lazy 가능 · 다음 cycle 영향 시 mitigation |
| **repo-specific (자유)** | 도메인 코드 / 화면 / `app/` / `<repo>/CLAUDE.md` 본문 도메인 섹션 / `settings.local.json` | 정합 강제 X | 자연 발생 |

---

## 3. propagation 표준 흐름 (단방향 master → 자식)

```
1. master 에서 cli infra 또는 보호 파일 변경 + commit
2. bash scripts/propagate.sh <relative-path> [--targets FND,gently-product-docs,Selfward|all]   # C3 에서 신설 · alias = GB/GD/GT/FND 만 · 그 외 = 폴더명 verbatim
3. 각 자식 repo 에서 staged commit (master commit body 인용)
4. bash scripts/verify-sync.sh   # cross-verify · sha 비교
5. propagation-reports/<cycle-id>/REPORT.md 자동 생성 (report-gen.sh)
6. master 에 audit commit (propagation-status.md 갱신)
```

자식 repo 에서 cli infra 변경 시도 → STOP + master 신설 cycle 권장.

---

## 4. 절대 금지 (4-repo 공통)

- 명령어 차단: `settings.json` deny list 참조 (`curl` `wget` `sudo` `git push` `git reset` `git clean` `git rebase` `git filter-branch` `*tmp*` `rm -rf /...`)
- 경로: `/tmp` · `$TMPDIR` 계열
- 데이터: 시크릿 / 토큰 / 키 / PII 값을 파일에 기록 (변수명 / 주입 경로만 허용)
- 네트워크: 웹 조회 / 다운로드 (레포 내 근거만 사용)
- **자식 repo 의 cli infra 직접 수정** (단방향 정합 위반)

---

## 5. STOP 조건 단일 SoT (= 본 cycle 통합 default · 2026-05-22 신설 default · `MASTER-CLI-CYCLE-1-STOP-CANONICAL-INTEGRATION-001`)

본 § = 4-repo 측 STOP 조건 단일 SoT default. 나머지 4 군데 (= `safety-and-secrets.md §비가역 변경 STOP 정책` + `cycle-discipline.md §21.4` + `cycle-discipline.md §22.4` + `cross-repo-parallel-exec.md §5`) = 본 § pointer 영역 default · 본문 무접촉 default. `cowork-project-instructions.md §D-1` = cowork sandbox 영역 default · 본 cycle scope X default · 본인 manual paste replace default.

### STOP 영역 (= 9 항 default · 즉시 중단 + 자동 수정/되돌리기 금지)

| # | 영역 | trigger | mitigation |
|---|---|---|---|
| 1 | DB migration / Money / Auth 영향 경로 | DB schema 변경 + auth/billing 변경 + secret 접촉 default | 비가역 영역 default · 사용자 본심 회수 의무 default |
| 2 | Scope expansion | 요구사항 범위 초과 + 다른 영역 묶임 default | cycle scope 명확화 의무 default |
| 3 | 비가역 변경 징후 | 파일 삭제 + 스키마 변경 + 기존 파일 대규모 override default | mitigation cycle 신설 default |
| 4 | 예상 외 시스템 상태 | sandbox 진입 시 baseline mismatch default | 사용자 회수 default |
| 5 | 보호 5 file sha drift | byte-identical 의무 영역 default · `protected-file-hashes.md` baseline 정합 default | 즉시 mitigation cycle default · 리뷰 블로커 default |
| 6 | 자식 cli infra drift | master 측 단방향 propagation 위반 default | master 측 정정 cycle 신설 default |
| 7 | Cross-repo HIGH RISK 도메인 진입 | 4-repo 측 동시 영향 영역 default (= DB migration / Money / Auth / production push) | 사용자 본심 회수 default |
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

세부 단계 정의: `docs/rules/workflow-core.md` + `cycle-discipline.md` + `pencil-automation.md`.

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

## 8. Repo-First Intake (4-repo 공통)

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
| implement | 최소 변경 원칙. SoftBudget: `docs/rules/workflow-core.md` + `cycle-discipline.md` + `pencil-automation.md` 참조. |
| /verify | 0 command 금지. 불가 시 UNKNOWN(사유) + STOP. exit code 기록. |
| /review | 근거 기반 판정. 근거 없으면 UNKNOWN. |

verify / review 없이 완료 금지.

모든 implement task 는 REVIEW 에서 PromptFit 평가 (루브릭: `<repo>/docs/agent/solutions/PROMPTFIT_RUBRIC.md`) + `.ai/promptfit/INDEX.md` 갱신.

---

## 9. Context Hygiene

- **공통 불변 (= 진입 정독 범위 canonical · 부모 root `CLAUDE.md §3.1/§3.2` + 자식 배너 reading order 가 본 §9 를 가리킴)**: 매 진입 시 `.claude/settings.json` + `CLAUDE.md` **발췌** 먼저 읽음 — master 는 **§5 STOP(9항) + §2 정합 강제 3등급**만, 자식은 inline 필수 §(§0·§0.1·§1·§4·§5·§14). **전문·bulk 정독 X**(= just-in-time). 안전 조항(STOP 9 · 보호 5 · 단방향 propagation)은 발췌에 포함되어 손실 0.
- **역할별**: reading mode 에 맞는 `.claude/rules/**` / `.claude/agents/**` / `.claude/skills/**` 만 추가 열기.
- **just-in-time 로드 (= eager 회피 · `rule-routing-index.md §B` 정합)**: 역할별 로드 집합 = [`rule-routing-index.md`](docs/rules/rule-routing-index.md) §B Reading Mode → 의무 로드 표(L0 항상 + 해당 L1/L2/L3 subset 만). 큰 paradigm 본문(예: cross-repo 실행 = `cross-repo-parallel-exec-detail.md`)은 항상 로드 X · 해당 **행동 trigger 시점**에만 연다. L0 = kernel(safety + anchor + cross-repo kernel + 헌법 §5)만 항상.
- **task-local**: `.ai/tasks/<taskId>.md` + 현재 `.ai/reports/<taskId>/` + touched files 마지막 레이어.
- **bulk read 금지**: `.claude/**` 전체 일괄 읽지 않음.
- **Compaction 보존 (auto-compact 시)**: context 요약(auto-compact) 발생 시 요약에 **반드시 보존** = ① 진행 cycle-id ② Mode(M1/M3/M5) ③ git branch ④ 미완 step ⑤ 다음 행동 ⑥ STOP 상태. (= CLAUDE.md 는 compaction 시점 in-context → 본 지시가 요약에 반영 · compact 후 rule 전량 재정독·baseline 재측정 재발 방지 · `cycle-discipline.md §12` 세션 운영 정합)

---

## 10. 구현 / 설계 기본값 (4-repo 공통 · 변경 불가)

- 직접 구현 우선 (새 추상화 추가 전 직접 구현 단순성 평가)
- 신규 의존성 승인: `libs.versions.toml` 신규 항목 = PLAN `## 2. DependencyDecision` 8 항목 필수 (8항 canonical = `docs/agent/architecture/DEPENDENCY_DECISION_CHECKLIST.md` · UI 라이브러리 억제 canonical = `docs/rules/ui-ux-analysis.md §UI 라이브러리 억제 기본값`)
- TDD 우선: 새 UseCase / Coordinator 는 `FakeXxx` 기반 테스트 먼저 또는 함께
- 외부 준비 연기: 외부 콘솔 / 인프라 미준비 = `TODO(user-prep)` 또는 stub
- 모델 분리: DTO · Entity · DomainModel · UiState 레이어 간 혼용 금지
- 명시적 오류 처리: typed 도메인 오류 또는 Result 우선
- 테스트 심 주입: clock · dispatcher · identity · logger · uuid 인터페이스 주입
- 불변 UI 상태: UiState 불변 + ViewModel → UI 단방향
- DI baseline: 4-repo 모두 `Koin`. 위치는 `app/` (또는 향후 `shared/app` glue)

세부: `docs/rules/workflow-core.md` + `cycle-discipline.md` + `pencil-automation.md` + `docs/rules/ui-ux-analysis.md`.
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

PLAN / VERIFY / REVIEW / PromptFit 정규 스키마: `docs/rules/reporting.md` §5~§7 + §1 경로 규약 (= 직전 report-formats.md + report-paths.md 본문 통합 default · MASTER-CLI-CLEANUP-7CYCLE-001 M1 마감).

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

현 master HEAD sha + 자식 3 (= FND / PDOCS / SW · §1.2) 동기 상태는 `.auto-memory/propagation-status.md` 에서 동적 파악.

`scripts/verify-sync.sh` 가 매 cycle 자동 갱신 (C3 에서 신설).

---

## 14. UI/UX 규칙 하이라이트

- `docs/rules/pencil-uiux-workflow.md` (보호) — UI/UX 변경 = Pencil SoT → Compose 순서 강제 + `.ai/uiux-sot/latest/` 필수 (GT-strong patterns 채택)
- `docs/design/pencil-sot-policy.md` (보호) — Pencil SoT 정책 §1.1 디자인 도구 바인딩 / [CURRENT] / [TARGET] / [LOCKED] 라벨 / §3 Phase R 예외 / §8 고위험 STOP / §9 마이그레이션 escape
- `docs/rules/uiux-sot-refresh.md` (보호) — refresh trigger FULL / PARTIAL / DOC-ONLY 분류

신규 Pencil 측 cli infra (MASTER-CLI-PENCIL-OPTIMIZATION-001 · 2026-05-19):
- `docs/rules/pencil-cli-headless.md` — `@pencil.dev/cli` headless 진입점 + batch tasks.json + Save As 모달 회피 + CI/CD 통합 paradigm
- `docs/rules/pencil-mcp-tools-reference.md` — 12 official + 1 package-verified (`open_document`) 도구 단일 SoT
- `docs/rules/design-prompting-paradigm.md` — Effective Prompting 4 원칙 + verification 4-step + §FREEDOM

---

## 14a. 보호 파일 sha baseline (2026-06-18 · MASTER-CLI-DESIGN-SOT-ENFORCEMENT-CRITERIA-001 마감 · git-sha1)

5종 보호 파일 git-sha1 (= `git hash-object` · post-cycle baseline · 본 cycle 변경 = design SoT 2 file 한정 — `uiux-sot-refresh.md`("즉시 의무 vs Deferred" 분기 subsection + 게이트 [Design SoT Sync] 재배선) + `design-sot-policy.md`(§3 code-first deferred 예외) · 나머지 3(ui-spec.schema.json + pencil 2종) 무변동):

| 보호 파일 | git-sha1 | 본 cycle 변동 |
|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `8b46bb4952be03a7631b66096ba2b47e27a1c72a` | 무변동 (= COMPOUND-LINT-DEPRECATE-001 baseline 유지) |
| `docs/rules/pencil-uiux-workflow.md` | `68c6c213b18ed958aec21f5dc527aa5625c64424` | 무변동 (= PENCIL-PHASE-B-PROTECTED-001 baseline 유지) |
| `docs/design/pencil-sot-policy.md` | `ce9c0d3e54534eb6eab3c7133cbb71a0e17ca6de` | 무변동 (= PENCIL-PHASE-B-PROTECTED-001 baseline 유지) |
| `docs/rules/uiux-sot-refresh.md` | `7e70e365bb3085c0be9378a851685874e2c020da` | **갱신** (이전 `d2c62265...` · "Refresh Trigger Classification" 직후 "즉시 의무 vs Deferred (design-debt) 분기" subsection 신설 + 게이트 line REVIEW §1 FAIL→[Design SoT Sync] WARN 재배선) |
| `docs/design/design-sot-policy.md` | `0d265e0bbc6f0f848f1b34dc510a9d6d7d9f0bd9` | **갱신** (이전 `69649a36...` · §3 "원칙" code-first 역방향 항→Deferred (design-debt) lane 한정 허용 3-bullet · Phase R 예외 무접촉) |

> **algorithm 분기 주의** (`protected-file-hashes.md §CONVENTION` 정합): 본 §14a = **git-sha1 (40 char)** · `.auto-memory/protected-file-hashes.md` manifest + `.ai/baseline-snapshot/latest.json` = **sha-256 (64 char)**. pencil-uiux-workflow.md 측 sha-256 = `202d3f4f29c0668eb5f1a33b6d40d5153888cf1f1e55da9958f9ab605c68f40a` (= manifest 측 baseline). 두 algorithm 직접 비교 금지.

`.auto-memory/protected-file-hashes.md` 와의 정합 의무 (`cycle-discipline.md` §10 정합).

---

## 15. master cycle 진행 이력 (placeholder · 매 cycle 시 갱신)

| cycle ID | 마감일 | 변경 요약 | 영향 자식 repo |
|---|---|---|---|
| MASTER-CLI-RELEASECHECKLIST-LAUNCHGAP-001 | 2026-07-13 | master `docs/templates/release-checklist.template.md` §1 Play Console 표에 출시 gap 2행 additive (row 9 = 비공개 테스트 12명×14일 연속 opt-in · row 10 = Google Payments 판매자 프로필 수립) (Mode M1 master cycle · cli-infra template doc-only · production 0 LOC · master-owned · 자식 cp = P4 lazy · agent-commit · cowork contract cc-paste-MASTER-RELEASECHECKLIST-LAUNCHGAP-001). **본질**: LAUNCH-GAP-AUDIT G4(비공개 테스트 12명×14일 연속 opt-in · 공식 Play answer/14151465)·G5(Google Payments 판매자 프로필 · answer/3092739)이 template §1에 미등록 → production 신청·유료 IAP 판매 前 필수 gate 2건을 §1 표 말미(도메인 disclosure 블록 위)에 additive 등재. template §변경 정책("9 섹션 row 추가/삭제 시 master cycle 신설 의무 · 자식 cp 정합 영향")의 그 master cycle. **scope = `release-checklist.template.md`(비보호 · +2/-0)**: ① row 9 = 비공개 테스트 12명 × 14일 연속 opt-in(신규 개인 계정 2023-11-13+ · production 신청 前 필수 · 앱별 각각 · 중단 시 카운터 리셋 · answer/14151465) ② row 10 = Google Payments 판매자 프로필 수립 + 개발자 계정 연결(유료 IAP 티켓 SKU 판매 前 전제 · 세금/판매자 정보 · answer/3092739) · §1 도메인 disclosure 블록 위 표 말미 append(번호·위치·문안 = cli 자율). **자식 cp = P4 lazy**: 본 cycle 자식 propagate.sh 실행 X(template §변경 정책 = 자식 P4 deployment cycle 진입 시 cp) · 자식 INITIATIVES G4 per-app row = 별 GB/GD/GT LAUNCHGAP-REGISTER paste 영역(본 cycle scope 외). **무접촉**: 기존 8행 0 변경(byte) · §2~§9 타 섹션 0 · §1 header "공통 8 항목"(additive-only +N/-0 계약 정합 · header count sync = 후속) · 자식 repo(직접 수정 STOP#6) · Money/EF/DB/보호 5 file. **검증**: additive +2/-0(git diff 삭제 0 · 기존 8행 byte 무변) · 보호 5 file sha drift 0(edit-set ∩ 보호 = ∅ · release-checklist.template = protected-5 아님 · cli infra 권장 byte-identical) · production/도메인 0 LOC · propagate X(P4 lazy · master-only) · propagation-status.md 무접촉(no propagation · auto-gen 매트릭스 = verify-sync 소유 · 직접 편집 금지 · "갱신 해당 시" 미해당) · §0 gate: 진입 재측정 HEAD `6ad6f3d` ahead 0 정확 일치 + template §1 8행(row 9/10 부재) 확인(STOP#4 미발동). **사고**: 없음. **후속(scope 외)**: 자식 GB/GD/GT P4 deployment cycle 진입 시 template cp + G4 per-app INITIATIVES 등재(별 LAUNCHGAP-REGISTER paste) · §1 header "공통 8 항목"→"10 항목" count sync(additive-only 계약 밖 · 별 판단) · §15 hot 17>10 = **S15-HOT-DEMOTE-005** advisory. Negative Space: 기존 8행 0 · 타 섹션 0 · 자식 0(cp=P4 lazy) · Money/EF/DB/보호 5 = 0. | **master-only** (master 본 commit · `release-checklist.template.md` content + CLAUDE.md §15 = master-owned · 자식 cp = P4 lazy(즉시 propagation X) · propagation-reports 없음(propagate 미실행) · 자식 5 repo 무접촉) |
| MASTER-GIT-ROLE-COMMIT-V3-001 | 2026-07-15 | git 역할 경계 v2(한시 허가) → **영구 v3**(commit + git log 위생 = cli 소관 default·전 카테고리 / push + 고위험 git = Coin 소관) 박제 + 4개 층 문언 모순 일괄 정합 (Mode M5 cli-infra-ops · production/EF/DB/Money 0 LOC · Coin 본심 2026-07-15 "commit·git log 관리 = cli 소관 레이어 정정 · Coin = push + 리스크 큰 git 처리만" · cowork contract cc-paste-MASTER-GIT-ROLE-COMMIT-V3-001 · **v3 첫 공식 적용 cycle**[cli 가 7-repo 전 commit 수행]). **본질**: 실운영은 이미 v3 일치(cli 커밋 관행 다수) + `settings.json` 실측(`Bash(git:*)` allow · commit 비-deny)과 4개 층 문언이 불일치(stale) → 문서를 실측·실운영에 맞춰 정정(문서가 뒤따라오는 정정). **scope = 비보호 4 file(6-repo byte-identical) + master-only(manifest·CLAUDE.md) + Selfward 1**: ① `cycle-discipline.md` §5 = "agent commit 한시 허가(v2)" → "git 역할 경계 정책(v3)" 재작성(commit=cli 전 카테고리·영구 / 품질 게이트[빌드 PASS·§9·§10] 불변 / STOP#1·M3 도메인 산출물 커밋도 cli 소관[단 paste 없는 자율 개시 금지 불변 = commit 권한 ≠ cycle 개시 권한] / Coin=push+reset·clean·rebase·filter-branch[deny]+amend·force·reflog[문서 금지]) + 이력 append ② `safety-and-secrets.md` deny 표 = `git commit` 행 제거(deny 아님)·`git rebase`+`git filter-branch` 행 추가·note v3 재작성 ③ `COMMIT_CONVENTION.md` §2 = "Claude 는 commit/push/reset/clean 실행 안 함" → v3 경계 재작성 + 정정 근거 1줄 + xref 2(line 5·184) 정합 ④ `settings.json` deny = `Bash(git rebase:*)`+`Bash(git filter-branch:*)` 2 추가(확실 패턴 한정 · amend/force/reflog = deny 패턴 불가분 = 문서 금지로 커버) → manifest sha resync(`9696afb3…`→`313fec8d…` · baseline-snapshot settingsSha = 다음 SessionStart self-heal · 선례 GSM-MEASUREMENT-LAYER-001) ⑤ master `CLAUDE.md` §4 L87 deny 나열 확장분 반영 + 본 §15 row(master-only) ⑥ Selfward = COMMIT_CONVENTION.md 1 file cp(byte-identical) + path-limited commit(supabase/_ops WIP 무흡수). **검증**: 4 file 6-repo byte-identical(cycle-discipline `d07235e1` · safety `ef87d083` · COMMIT_CONVENTION `e2e8c636` · settings `313fec8d`) + COMMIT_CONVENTION 7-repo(Selfward 포함 `e2e8c636`) · settings.json valid JSON ✓ · 보호 5 file sha drift 0(edit-set ∩ 보호 5 = ∅ · settings.json = 보호 5 아님 = manifest advisory resync) · production/EF/DB/Money 0 LOC · propagate ok=20/0 · verify-sync **163 PASS**(본 cycle 4 file 전량 PASS) · DRIFT 5(release-checklist.template = RELEASECHECKLIST-LAUNCHGAP-001 P4-lazy 의도적 미전파) + MISS 10(CLI-MASTER-SCOPE-SEPARATION-CHARTER + production-cli-access-tokens = master-only) = **전량 본 cycle 무관 pre-existing**(edit-set 무접촉 · 신규 DRIFT 0 = STOP 미발동) · 자식 path-limited commit(name-only = 4 file exact · WIP 무혼입 — GB 108/GD 81/GT 74/FND 5/PDOCS 4 dirty 무접촉) · Selfward path-limited(1 file · supabase/_ops 무흡수). **§0 gate**: 6-repo HEAD 정확 일치(5732291/0aa8ef8/d170036/0ab37a1/5de9e51/f5c7165) · Selfward `52932a9`→`e515396` = 동시 세션 SELFWARD-GIT-COMMIT-T2T3-001 forward-progress(A1 · COMMIT_CONVENTION baseline `9a6c17c1` 무변동 = 청정 landing · STOP#4 미발동). **사고**: 없음(git-lock daemon 미활성 advisory = 비차단 · follow-up launchctl load · verify-sync stale-ref 5 = DIET-2-003 후속 pre-existing non-blocking). **후속(scope 외)**: 자식 CLAUDE.md §4 deny 나열(rebase/filter-branch 미반영 = master-only §5 scope 정합 · 별 판단) · release-checklist P4-lazy DRIFT + CHARTER MISS reconcile(별 cycle) · git-lock daemon launchctl load · §15 hot 18>10 = **S15-HOT-DEMOTE-005** advisory. Negative Space: production/EF/DB/Money 0 · 보호 5 sha 0 · amend/force deny 미추가(불확실 = 문서 커버) · 자식 CLAUDE.md 무접촉 · blanket --prune 미사용. | **7-repo 적용** (master content `96347ae` + 5 자식 propagate byte-identical 4 file: GB `26aebf7`/GD `2ace817`/GT `bccc082`/FND `7ac5b80`/PDOCS `c85c14c` · Selfward `a3f71f9`[COMMIT_CONVENTION.md 1 file path-limited] · settings.json manifest resync + §15 + L87 + propagation-status + REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-GIT-ROLE-COMMIT-V3-001/REPORT.md) |
| MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-002 | 2026-07-15 | §13 pencil self-test named-set **1-swap 재보정** (`set_variables` 제거 → `export_html` 삽입 · count 9 유지 · Pencil app v1.1.62→v1.1.69 MCP surface 재변경 반영) + 도구 surface SoT 정합 + CC 2.1.210 trail PASS 겸결 (Mode M5 cli-infra-ops · production 0 LOC · doc(rule/skill) 5 file · 비보호 · CC 2.1.210 무관·유지 · 선례 = RECALIBRATE-001 동형[13→9] · cowork contract cc-paste-MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-002). **발동**: 진입 self-test ③ named-set FAIL = 실측 toolset(set_variables 부재 + export_html 존재 · 9종) ≠ §13 구 named-set → 게이트 self-exception(본 cycle 인가 주제) · 2 환경 corroborate(cli VS Code endpoint ToolSearch [`select:set_variables` 미해결·`export_html` 해결] + cowork desktop-proxy). count 불변(9=9)이라 §10 count STOP 미발동 → **named-set 게이트가 검출**(RECALIBRATE-001 13→9 count 축소와 대비 = count-invariant 1-swap). **scope = 비보호 5 file(6-repo byte-identical)**: T1 `cycle-discipline.md` §13 L69 named-set 1-swap(알파벳 batch_get 다음·9종 유지) · T2 `pencil-mcp-tools-reference.md`(§0.1a v1.1.69 1-swap 기록 신설 + §1.4 `set_variables` REMOVED stub + §4.3 `export_html` 신규[ToolSearch schema 실측·web 조회 X] + header/§0 Part A/§1[5→4]/§4[2→3]/§10 named-set STOP 정합 · 역사 서술[v1.1.62 4종=§0.1] 무접촉) · T3 3 file(`design-to-code-sync.md` L142 · `pencil-theme-multi-axis.md` L9/L285/L336 · `pencil-pen-save/SKILL.md` L39 = `mcp__pencil__set_variables`→headless 평문-JSON[`pencil-uiux-workflow §2.5` PRIMARY]). **보류(별 surface · §6-4 부분 land)** = `pencil-cli/SKILL.md`(L96/L176 `pencil interactive` REPL set_variables + L270 label = 헤드리스 CLI REPL surface[관측 0.2.6 · MCP 와 별 endpoint · 본 cycle 미측정] → 측정 후 별 판단). **T4 겸결** = `.auto-memory/incident-log.md` 2 entry(① PENCIL-MCP-TOOLSET-RECALIBRATE-002 1-swap 기록 · ② CLAUDE-CODE-LATEST-CHASE-001 **PASS entry** 2.1.210·self-test 3/3·직전 PASS 2.1.170[06-11] = UPGRADE-001 잔여 마감). **검증**: propagate ok=25/0 · verify-sync **163 PASS**(신규 DRIFT 0 · 기존 DRIFT 5[release-checklist P4-lazy] + MISS 10[CHARTER + production-cli-access-tokens master-only] = pre-existing 무관) · 5 file 6-repo byte-identical(cycle-discipline `551899306fbd` · pencil-mcp-tools-reference `f87443053e1a` · design-to-code-sync `81a52a9bc694` · pencil-theme-multi-axis `42fa0fbdd9b2` · pencil-pen-save `f77763ff80fe`) · 보호 5 file sha drift 0(edit-set ∩ 보호 = ∅ · pencil-uiux-workflow/pencil-sot-policy 무접촉 · manifest 갱신 불요) · production 0 LOC · self-test **3/3 PASS**(CC 2.1.210 ✓ + pencil ✔ Connected ✓ + ToolSearch 9종 named-set 전수 ✓). **§0 gate**: 진입 재측정 HEAD 5d8d485 + 7 blob(cycle-discipline 3bfd634 등) + 보호 2(ce9c0d3/68c6c21) 전량 §0 표 일치(STOP#4 미발동). **사고**: 없음(git-lock daemon 미활성 advisory = 비차단 · follow-up launchctl load · verify-sync stale-ref 5 = DIET-2-003 후속 pre-existing non-blocking). **후속(scope 외)**: pencil-cli CLI REPL surface 측정 + Phase B(보호 2 set_variables 잔존[pencil-sot-policy:45 + pencil-uiux-workflow:58/:76] + open_document 묶음) + pencil scope-conflict(user/project endpoint 정리) + git-lock daemon launchctl load + §15 hot 19>10 = **S15-HOT-DEMOTE-005** advisory. Negative Space: production/EF/DB/Money 0 · 보호 5 sha 0 · 역사 서술(§0.1) 무접촉 · pencil-cli/보호 2/scope-conflict/.pen 무접촉 · blanket --prune 미사용. | **6-repo 적용** (master content `f38e6fd` + 5 자식 propagate byte-identical 5 file: GB `a67a5a3`/GD `912e80a`/GT `6612e4d`/FND `6d6a601`/PDOCS `2e91d1b` · incident-log T4 2 entry + §15 + propagation-status + REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-002/REPORT.md) |
| MASTER-SELFWARD-CLAUDE-PARITY-001 | 2026-07-17 | ⑦ Selfward `.claude/` 초회 propagate 편입 — T1~T5 내내 paste 문면이 유일 rule 가드였던 Selfward 에 rule 백스탑 확보 (Mode M5 cli-infra-ops · production 0 LOC · cli-infra propagate only · 도메인 rule 내용 변경 0 · T6 정체성·repo 재편 전 backstop). **본질**: master 단방향 propagate 대상 Selfward **6번째 편입**(`repo-config.sh` TARGET_REPOS += Selfward) + `--all` set − master-only 2 = **165 file 초회 전파**. **scope**: master `repo-config.sh`(비보호 = manifest 직접 grep 실측 확인 · propagate.sh/verify-sync/ensure-child-gitignore = repo-config live source · SoT 1행 수정 충분) + Selfward 89 file(신규 83: `.claude/**` 76[agents 25·skills 20·hooks 17·commands 8·rules 5·settings.json 1] + `.editorconfig`·`.mcp.json`·`.github/PR template`·`.ai/uiux-sot` 3·`.ai/promptfit` 1 · 갱신 5: stale cli-infra→master SoT[cycle-discipline·design-to-code-sync·pencil-mcp-tools-reference·pencil-theme-multi-axis·release-checklist.template] · `.gitignore` C14 patch · 무변 77 byte-identical no-op). **master-only 2 제외**: `docs/ops/production-cli-access-tokens.md`(header "6-repo propagation 대상 X · master-only") + `docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md`(master-scope 감사 헌장) = 5자식 동일 MISS pre-existing 정합. **CLAUDE.md 처분**: Selfward top-level CLAUDE.md = 4-repo byte-identical 자식 clone `753a2e0`(== GB/GD/GT/FND) 이미 실존 → **propagate 절대 금지 준수 · 무접촉**(§1 registry Selfward 미등재 = T6 몫). **검증**: propagate ok=165/0 · verify-sync 6-repo Selfward **164 PASS/DRIFT 0/MISS 2**(master-only 2 = 5자식 동일 pre-existing) · 전체 163 PASS/DRIFT 5(release-checklist 5자식 stale · **Selfward=✓** 신규 drift 0)/MISS 12(+2 Selfward master-only) · 보호 5 sha drift 0(edit-set ∩ 보호 = ∅ · repo-config 비보호 · manifest 갱신 불요) · 기존 5자식 무접촉(dirty 104/77/70/0/0 불변 · .gitignore/.claude 무변 = env TARGET_REPOS=Selfward isolation) · secret grep 0 · production/도메인/build 0 LOC(gradlew/build.gradle.kts master 부재 · gradle.properties byte-identical no-op). **사고**: 없음(verify-sync stale-ref 5[.claude/rules/* in status docs] = DIET-2-003 후속 pre-existing non-blocking · git-lock daemon advisory 비차단). **후속(scope 외)**: Selfward run-* launch recipe 신설(자식별 = 별 cycle) · CLAUDE.md §1 registry Selfward 등재 + repo 재편 = T6 · §15 hot 20>10 = S15-HOT-DEMOTE-005 advisory. | **Selfward 단독** (master content `0c62052` [repo-config TARGET_REPOS += Selfward] + Selfward `.claude` propagate `8e2a45d` [89 file byte-identical master 1163a71] · 기존 5자식[GB/GD/GT/FND/PDOCS] 무접촉 · §15/propagation-status/incident-log/REPORT = master-only audit commit · REPORT = propagation-reports/MASTER-SELFWARD-CLAUDE-PARITY-001/REPORT.md) |
| MASTER-T6-REPO-REALIGN-001 | 2026-07-17 | propagate 대상 6→4 재편 — `TARGET_REPOS` 기본값에서 GB/GD/GT 3 토큰 제거 → 전파 자식 3(app-foundation/gently-product-docs/Selfward) (Mode M5 cli-infra-ops · production 0 LOC · master 측 targets 문자열 한정 · 도메인 rule 내용 변경 0 · CLAUDE.md propagate 금지 불변 · cowork contract cc-paste-MASTER-T6-REPO-REALIGN-001 · BLUEPRINT-T6-IDENTITY-REPO FINAL 본심 ⓒ). **본질**: ⑦(SELFWARD-PARITY) Selfward 편입 후, GB/GD/GT 를 단방향 propagation 대상에서 제거(GitHub archive = Coin 콘솔 몫 · 원본 = 계승 원천 보존) → cli-infra propagate 형상 = master + FND/PDOCS/Selfward(= 4-repo byte-identical). 제거 = **master 측 targets 문자열 한정**(자식 repo 파일/커밋 0 · repos 삭제 X · resolver 보존). **보호 manifest**: `.auto-memory/protected-file-hashes.md` 직접 grep 실측 선행 → 보호 5(ui-spec.schema/uiux-sot-refresh/design-sot-policy/pencil-uiux-workflow/pencil-sot-policy) ∌ scripts/* + advisory-tracked(settings.json/check-abbreviation.sh) ∌ scripts/* → edit-set(repo-config.sh + propagate.sh) ∩ 보호 = ∅ → **비보호 · manifest 갱신 불요**('기억 단정' 회피 · 실측 선행 준수). **scope = 비보호 2 script(master-only tooling · top-level `scripts/` = verify-sync 매트릭스 밖 · 자식 propagate X)**: ① `repo-config.sh`(SoT · L28 default `GentlyBreath GentlyDay GentlyTable app-foundation gently-product-docs Selfward`→`app-foundation gently-product-docs Selfward` + L18 default 주석 동일 정합 + L27 lineage 'Selfward 6th target'→T6 재편 attribution 1행 add) ② `propagate.sh:11`(stale 5자식 default 주석[⑦ 미반영]→3자식 정합). **검증**: `bash -n` 2/2 OK · TARGET_REPOS clean-env resolve = 3 토큰(GB/GD/GT 제거 확증) · verify-sync **신 형상**(targets=app-foundation/gently-product-docs/Selfward · GB/GD/GT 매트릭스 배제 확인) = **163 PASS / DRIFT 2 / MISS 6**(exit 1 = MISS/DRIFT 비차단) — DRIFT 2 = release-checklist.template FND/PDOCS(P4-lazy · RELEASECHECKLIST-LAUNCHGAP-001 의도적 미전파 · Selfward=✓) · MISS 6 = CHARTER + production-cli-access-tokens 2 master-only × 3자식 = **전량 pre-existing**(⑦ 6-child baseline 163/5/12 대비 DRIFT 5→2·MISS 12→6 = GB/GD/GT 배제 산술 · **신규 drift 0**) · 보호 5 sha drift 0 · production/도메인 0 LOC · GB/GD/GT **파일/커밋 0**(HEAD a67a5a3/912e80a/6612e4d 불변 · ahead 0/0 · dirty 104/77/70 = §0 baseline 불변 · GD staged 3 = concurrent 세션 pencil WIP `docs/design/pencil-sot/monthly-stats/*` = 본 cycle 무관). **§0 gate**: master HEAD aae09ab(⑦ 마감 · ahead 0/0) + repo-config Selfward 포함(6target) + GB/GD/GT/FND/PDOCS ahead 0 = §0 baseline 정확 일치(STOP#4 미발동). **사고**: 없음(git-lock daemon 미활성 advisory 비차단 · verify-sync stale-ref 5 = DIET-2-003 후속 pre-existing non-blocking). **후속(scope 외 · T7 회부)**: `propagate.sh:5-6` `--targets GB,GD,GT,FND|all` 사용례 + resolver(propagate `:75-86`/`:164-166` · verify-sync `:150`) = repos 원본 보존 → 명시 `--targets GB` 유효 문법 유지(targets 문자열 한정 정합 · 보존) · topology-count 주석(`repo-config.sh:20-22` '6-repo propagation 의무' + `:30` '5 propagation target = 6-repo' · `verify-sync.sh:13` + `ensure-child-gitignore-patches.sh:11/29` stale) = rule/문서 본격 개정 = T7 · GitHub archive GB/GD/GT ×3 = Coin 콘솔 · CLAUDE.md §1 registry GB/GD/GT 처분 = T6 후속 · §15 hot 21>10 = S15-HOT-DEMOTE-005 advisory. Negative Space: 자식 repo 파일/커밋 0 · resolver/repos 보존(삭제 X) · 보호 5 sha 0 · verify-sync 매트릭스 콘텐츠(cli-infra) 0 변경 · blanket --prune 미사용 · CLAUDE.md propagate 0. | **master-only** (master 본 commit · `scripts/repo-config.sh` + `scripts/propagate.sh`[targets 문자열 realign · top-level scripts = 자식 propagate X] + `.auto-memory/propagation-status.md`[verify-sync auto-regen 3-child 매트릭스] + CLAUDE.md §15 + `.auto-memory/incident-log.md` = master-only audit commit · GB/GD/GT/FND/PDOCS/Selfward 파일·커밋 0 · propagation-reports 없음[propagate 미실행 · targets 문자열 realign만 · RELEASECHECKLIST-LAUNCHGAP-001/S15-HOT-DEMOTE-004 master-only 선례] · push=Coin) |
| MASTER-T7-INSTRUCTIONS-REALIGN-001 | 2026-07-17 | T6 재편(propagate 6→4)의 **서술/주석 층 stale 전량 현행화** — §1 registry 재저작(활성 도메인 자식 = Selfward 단일 + 전파 자식 3 + GB/GD/GT 동결 계승 원천) + CLAUDE.md 내부 topology 12곳 + scripts 주석 4 file + 부모 root umbrella 재정합 (Mode M5 cli-infra-ops · production/EF/DB/Money 0 LOC · master-only · doc/주석 한정 · 코드 behavior 0 · cowork contract cc-paste-MASTER-T7-INSTRUCTIONS-REALIGN-001 · HANDOFF-SELFWARD-T7 §1-B). **본질**: T6 = `TARGET_REPOS` 문자열 한정 재편(6→4) → 실 전파 형상은 이미 4-repo 인데 **문서/주석 서술은 6-repo·3자식·GB/GD/GT 전제** 잔존(T6 §15 후속 "rule/문서 본격 개정 = T7" 회부분) → 본 cycle 이 서술 층을 실측 형상에 수렴(문서가 실측을 뒤따르는 정정 · `MASTER-GIT-ROLE-COMMIT-V3-001` 동형). **scope = master-only 6 file**: ① `CLAUDE.md §1` registry 재저작(§1.1 활성 = Selfward「나에게로」`com.gently.selfward`(+`.staging`)·1앱 N도메인[`shared/` 실측 mood/learning/daily/record/reply/companioninsight/ticketshop] / §1.2 전파 자식 3 = FND·PDOCS·SW + 4-repo byte-identical 형상 / §1.3 **동결 계승 원천** GB·GD·GT = 구 3행 정보[도메인·`com.example.*` 패키지·경로] **전량 보존** + 처분[전파 제거 T6 · GitHub archive 보류=Coin 콘솔 · 원본 보존 · 쓰기 0 · task ID prefix/이력 인용 보존] = **이력 소실 0**) ② CLAUDE.md 내부 topology **12곳**(L19 header 자식 나열 · L27 §0 "3 자식 GB/GD/GT 한정" · L32 §0.1 "3앱=독립 사용자" 가설→**1앱 N도메인 현행 + supersession 이력 bullet**[구 판 문면 verbatim 인용 + L1-3 서술 이력 보존 · 삭제 0] · L34 "6-repo 동일 mode"→4-repo · §3 propagate 사용례 · §4/§8/§10 "(3-repo 공통)"→4-repo · §5 intro "6-repo"→4-repo · **STOP#7 어휘만**[9항 구조·의미·행 수 불변] · §10 DI baseline "3-repo"→4-repo · §13 "3 자식 repo"→자식 3) ③ scripts 주석 4 file(**문면 한정 · 코드 0**): `repo-config.sh`(L21 "6-repo propagation 의무"→4-repo · L31 PROTECTED_FILES 헤더 "master ↔ 5 propagation target = 6-repo"→"3 target = 4-repo") · `verify-sync.sh`(L2 header 6-repo→4-repo · L8 `--target GB`→`--target Selfward` · L13 TARGET_REPOS 기본 5자식 문자열→3자식 · :160 runtime echo "6-repo sha 동기 검증"→4-repo) · `ensure-child-gitignore-patches.sh`(L7 `--target GB`→Selfward · L11 기본 "GB GD GT"→3자식 · L27-29 "repo-config 4 repo 자동 흡수(= GB GD GT FND)" drift 주석→현행 TARGET_REPOS + T6 supersede 명시) · `propagate.sh`(L5-6 사용례 ×2) ④ 부모 root `~/AndroidStudioProjects/CLAUDE.md`(git repo X · §7 관례 준수 = 본 §15 entry 동반): title/§1/§2 = **7-repo umbrella (= 4-active + 3 동결)** 재정합(§2.1 4-active[master·FND·PDOCS·**SW 신 row** = 「나에게로」·appId·1앱N도메인] / §2.2 3 동결[GB/GD/GT 기존 descriptor **전량 보존** + 쓰기 0]) + §3.1 진입 예시 `cd .../GentlyBreath`→`Selfward` + §3.3/§4 표 + 영역 2 terminal 예시 ×3(GB/GD/GT→SW/FND/PDOCS) + reading trigger 키워드(**현행 + 구 판 이력 인용 trigger 보존**) + §5 propagate 사용례 · sha-256 `374c4a43…`→`ca8221e6…`. **★alias resolver 실측 정정**(A5 · paste 문면 교정): propagate/verify-sync resolver 실측 = alias **GB/GD/GT/FND 4종만** · 그 외 = 폴더명 verbatim fallthrough(`*)`) → `--targets FND,PDOCS,SW` = **PDOCS/SW 미해결 = 존재하지 않는 dir**(사용례 오기 risk) → 사용례 = `--targets FND,gently-product-docs,Selfward|all` + alias 경계 주석 병기로 확정(= 문서가 실행 가능한 명령을 보이도록 · resolver 코드 **무접촉**[alias 추가 = 코드 변경 = scope 밖 · T6 "GB alias 문법 보존" 정합]). **검증**: `bash -n` 4/4 OK · **TARGET_REPOS clean-env resolve = 3 토큰 불변**(= 주석 편집이 behavior 무영향 확증) · verify-sync **163 PASS / DRIFT 2 / MISS 6** = T6 post-state와 **동일**(= **신규 drift 0** · DRIFT 2 = release-checklist.template FND/PDOCS[P4-lazy 의도적 미전파 · Selfward=✓] · MISS 6 = CHARTER + production-cli-access-tokens 2 master-only × 3자식 = 전량 pre-existing · 자율 해소 X) · 보호 5 file sha-256 drift 0(manifest **직접 grep 실측 선행** = edit-set[CLAUDE.md + scripts 4 + COLD + context-health + 부모root] ∩ 보호 5 = ∅ · advisory-tracked[settings.json/check-abbreviation.sh] ∩ ∅ → **manifest resync 불요** · 8502c014/31c0da56/92a5e998/202d3f4f/2bfc81c5 전후 불변) · production/도메인 0 LOC · §15 기존 행 **diff 0**(= 박제 무접촉 실측) · propagate **미실행**(edit-set 전량 master-only 실측 = top-level `scripts/` + `CLAUDE.md` + `.auto-memory/**` = propagation scan set[`find .claude docs scripts/agent .ai/promptfit .ai/uiux-sot/refresh .github`] **밖** · context-health-metrics = `.auto-memory/` + 자식 3 부재 실측) · 자식 3 + GB/GD/GT **파일/커밋 0**. **§0 gate**: master HEAD `c3ae191` ahead 0 WT clean 정확 일치 · FND `6d6a601` + GB/GD/GT `a67a5a3`/`912e80a`/`6612e4d` 일치 · **PDOCS `2e91d1b`→`d7f6120`(ahead 1) + SW `bad809b`→`87ac760`(ahead 1·dirty 2)** = **A1 forward-progress**(동시 세션 도메인 commit = PDOCS-AI-BACKGROUNDING-001[제품 SoT 2 file] + SELFWARD-AI-QUIET-SURFACE-001[client/design 6 file] · **cli-infra edit-set 무접촉 실측** · SW dirty 2 = `.ai/reports`+`supabase/_ops` untracked = §0 허용 노이즈 · `MASTER-GIT-ROLE-COMMIT-V3-001`/`SOTMAP-REGISTER-001` §0 gate 선례 정합 · **STOP#4 미발동** · raw 보고). **사고**: 없음(git-lock daemon plist 존재·load 안 됨 advisory = 비차단 · verify-sync stale-ref 5 = DIET-2-003 후속 pre-existing non-blocking). **후속(scope 외)**: `.claude/rules`·`docs/rules` 층 topology 어휘 sweep(= 별 cycle 등재 예정 · 본 cycle 접촉 = STOP#2 → 무접촉 준수) · 부모 root §8 Refs 측 `.claude/rules/{cycle-discipline,routing-and-delegation}.md` = DIET-2-003 `docs/rules/` 이전 미반영 stale path(= topology 아님 · 별 class · 별 판단) · verify-sync stale-ref 5 · release-checklist P4-lazy DRIFT + CHARTER MISS reconcile · git-lock daemon launchctl load · GitHub archive GB/GD/GT ×3 = Coin 콘솔. **Negative Space**: production/EF/DB/Money 0 · 보호 5 sha 0 · §15 기존 행 0 · resolver/alias 코드 0(문면만) · GB/GD/GT repo 0 · 자식 3 파일 0 · rules 층 어휘 sweep 0(scope 준수) · blanket --prune 미사용. | **master-only** (master content+audit commit · `CLAUDE.md`[§1 registry + topology 12 + §15] + `scripts/`{repo-config,verify-sync,ensure-child-gitignore-patches,propagate}.sh[주석 한정] + `.auto-memory/propagation-status.md`[verify-sync auto-regen] + `.auto-memory/incident-log.md` = master-only · 부모 root `CLAUDE.md` = git repo X 직접 갱신(sha-256 `ca8221e6…`) · 자식 3(FND/PDOCS/SW) + GB/GD/GT 파일·커밋 0 · propagation-reports 없음(propagate 미실행 = edit-set 전량 master-only · T6/RELEASECHECKLIST-LAUNCHGAP-001/S15-HOT-DEMOTE-004 선례) · push=Coin) |
| MASTER-CLI-S15-HOT-DEMOTE-005 | 2026-07-17 | §15 hot 22행 → cold **9회차** 재이전 (Mode M5 cli-infra-ops · production 무접촉 · GSM-S15-HOT advisory 발화 hot 22>10 · 선례 `MASTER-CLI-S15-HOT-DEMOTE-004`(8회차) 동형 · master-only · 직전 `MASTER-T7-INSTRUCTIONS-REALIGN-001` 별 commit 분리). **본질**: hot 22 entry 가운데 오래된 **16** (`MASTER-SUPABASE-PROD-APPLY-RECIPE-001`~`MASTER-CLI-SOTMAP-REGISTER-001`) 을 `.auto-memory/master-cycle-history-COLD.md` 로 verbatim append (**LOSS NONE** · §15 제거 16행 = cold 신규 16 entry exact-string 대칭 · `git diff` removed==added **block sha-256 `0301724f0a0bdb46…` 일치 실측**) → cold **121→137** · 잔존 hot = 최근 5 (`MASTER-CLI-RELEASECHECKLIST-LAUNCHGAP-001`~`MASTER-T6-REPO-REALIGN-001`) + 본 cycle 계열 2 (= `MASTER-T7-INSTRUCTIONS-REALIGN-001` + 본 entry) = **7** (= DEMOTE-004 의 "최근 5 + 본 entry = 6" 대비 +1 = 본 cycle 이 T7 + demote 2 entry 발행분). **동반 정정**: 직전 T7 §15 entry append 시 유입된 **표 split 빈 줄 1**(= T6 row ↔ T7 row 사이 · 기존 표↔note 구분 빈 줄 뒤에 신 row 가 삽입되어 orphan) 제거 → §15 표 **연속 6행 복구** (= DEMOTE-004 "표 split 빈 줄 0" 계약 정합 · `--amend` = Coin 소관[git v3] → 본 별 commit 에서 정정). **동반**: COLD title(line 1) + §1 heading(line 11) + verbatim note(line 13) = 121→137 + lineage `S15-HOT-DEMOTE-005 +16`(+ 대칭 sha 실측 명기) reconcile · 본 §15 아래 cold 재배치 note(count 121→137 · range 끝 `…DESIGN-SOT-ENFORCEMENT-CRITERIA-001`→`…SOTMAP-REGISTER-001` · 9회차 추가) · `context-health-metrics.md` §2 갱신 (master CLAUDE.md **47,004→41,057** cp = advisory 무발화 복귀 + cold pointer 121→137 + hot entry 행 9회차 desc) + §6 이력 entry. **검증**: hot 22→**7** (`measure-gsm-cycle.sh` awk 실측 · **GSM-S15-HOT advisory 재실행 무발화** 7 ≤ 10 ✓) · 무손실 대칭 16 = 16 exact-string (sha `0301724f0a0bdb46`) · 표 연속성 실측(§15 표 내부 빈 줄 0) · 보호 5 sha drift 0 (edit-set ∩ 보호 = ∅ · 편집 3 file = CLAUDE.md + COLD + context-health = 전량 비보호 · manifest resync 불요) · production/도메인 0 LOC · 자식 3 + GB/GD/GT 무접촉. **후속(scope 외)**: 다음 hot > 10 도달 시 10회차 재이전 (= advisory · `measure-gsm-cycle.sh` Stop hook 자동 surface). | **master-only** (master 본 commit · §15 / cold / context-health-metrics = master-only · 자식 3 + GB/GD/GT 무접촉 · propagation 불요 · push=Coin) |
| MASTER-CLI-COMPOSITION-RULES-S3-001 | 2026-07-26 | **명시 조합(explicit composition) paradigm 규칙 정착 + 4-repo 전파** — 코드(S0~S2)가 고친 F1 의 *구조적 원인이었던 규칙*을 착지시킴 (Mode M5 cli-infra-ops · production/EF/DB/Money **0 LOC** · rule/docs only · 초안 원천 = `SELFWARD-SSOT-COMPOSITION-S4-001` §5 · 설계 SoT = `BLUEPRINT-SELFWARD-DI-COMPOSITION-REDESIGN-20260725` S3 · cowork contract cc-paste-MASTER-CLI-COMPOSITION-RULES-S3-001). **본질**: F1(= production `EntitlementRepository` 가 잔액 0 하드코딩 NoOp 으로 잔존)은 코드가 비어서 났지만 **그 자리를 비워도 되게 만든 것은 `billing-rules.md §1`**(*"production-safe NoOp 기본 bind + 자식 override"*)이었다. 코드는 S0~S2 로 고쳤는데 규칙은 그대로 → **다음 세션이 규칙을 근거로 되돌린다.** **규칙이 코드보다 오래 산다**가 본 cycle 의 명제. **S4 인계**: S4 는 STOP #6(자식 cli infra 직접 수정 금지)으로 편집 0 · 판정만 하고 마감 — 본 cycle 이 그 편집을 **master 에서** 수행(= S4 판정이 옳았음을 실행으로 확인 · 대상 6 file 전량 master 소유 실측). **scope = 비보호 6 file(4-repo byte-identical)**: ⒜ `docs/rules/billing-rules.md` = 제목(`:1`) 정정(Mock-first → 명시 조합) + §1 전문 재저작(기본값 금지 · 조합 루트 단일 자리 · 등록 순서 의존 금지 · Mock 은 이름을 불러야만 + debug guard 불변 · 통짜 mock 금지 = per-seam 의무 · NoOp = 강등 · **★도구는 구조만 본다**) + **§1.1 supersede 절 신설**(구 서술 2종 verbatim 무삭제 = additive-ledger) + §1.2 착지 좌표 표 + 신설 유래 줄(`:4`) supersede 표식 + `:65`/§10 정합 · **§2·§3·§4·§5·§7·§8 무접촉**(전부 유효) ⒝ `code-principles.md` §2 **"암묵 기본값 금지 — 누락은 컴파일 오류여야 한다"** 신설 + §4-C 체크리스트 2행(핵심 = Koin verify/Compiler Plugin 계약 *"structural dependency presence, **not semantic correctness**"* → **기본값 제거가 유일한 구조적 방어** · 실증 2 = F1 + `GentlyTheme` 반대 방향[기본값 제거 → 호출부 미갱신이 컴파일 오류로 즉시 노출]) ⒞ `docs/agent/architecture/KOIN_DI_BASELINE.md` §5a **foundation ↔ 앱 책임 경계** 신설(FND = 계약+구현 제공 · **기본 선택은 하지 않는다** · 선택 = 자식 조합 루트 · aggregate 기본 인자 금지 · 구 `FND-BILLING-SEAM-001` 서술 supersede 보존) — **★대상 재지정**(원 paste 지정 `architecture-foundation-link-policy.md` = markdown link 표기 의무 전용(`:3`) → 주제 불일치 · **S4 자진 정정 채택**) ⒟ `code-style-guide.md` §C 가이드라인 = 클래스 위임 `by` + **Kotlin 공식 주의**(*delegate 는 위임 클래스의 `override` 를 보지 못한다* → "일부만 갈아끼우면 나머지가 따라온다" 가정 금지) ⒠ `verification-and-review.md` `/verify` §기본 원칙 = **production 바인딩 실체 검증 의무**(① identity assertion `assertSame` — **타입 assertion 은 기본값 부활을 못 잡는다**[NoOp 도 정상 타입 · S1 실증] ② **음성 대조** — 가드를 깨보고 FAIL 확인[S0·S2 실증 3/3] · 통과만 기록 = 공허한 테스트와 구분 불가) + REVIEW 12-section §7 판정 기준 1행 ⒡ **F 채택** `libs-versions-cross-verify.md` §9a = Koin **4.0.0**(실측 · FND+SW `libs.versions.toml`) → 4.2 + Compiler Plugin 상향 4-repo 동시 검증 절차 + **★플러그인은 F1 을 못 잡으므로 선결 조건/안전성 근거 아님** 명기. **G 미채택**(= `.claude/rules/` 신설 0 · paste 권고 정합): `.claude/` = 세션 자동 적재 = 4-repo 상시 토큰 비용 · T1 다이어트(`MASTER-CLI-CONTEXT-DIET-2-003`) 취지 역행 · 내용 도달성 실측 = `rule-routing-table.md` Reading Mode 1/2/3 이 `code-principles`+`verification-and-review` 를 이미 의무 로드 + `billing-rules` = L3 키워드 trigger → **신설 0 이 낫다**. **검증**: 좌표 **9/9 disk 실측 선행**(A5 · `BillingSeams.kt:39` 기본값 0 · `BillingModule.kt:36` · `FoundationKoin.kt:62` 기본 인자 0 · `SelfwardAppContainer.kt:61` **class**(object 아님) · `:144` per-seam · `mockBillingSeams` `BillingSeams.kt:63` · **`billingMockModule` 실 심볼 0**[A7 dual grep — decl-pattern 1 hit = KDoc 인용 · 유일 non-comment hit = 테스트 assertion **메시지 문자열** · 실 심볼 아님] · `GentlyTheme` 필수 인자 실측 · `317f4e8` = S2 commit 실재) · **모순 해소 grep** = `Mock-first`/`NoOp 기본 bind`/`billingMockModule` 전 hit 이 §1.1 supersede(`:40`/`:44`/`:51`) 또는 §10 이력(`:157`) 또는 유래 줄(`:4`+`:5` supersede 표식) 안 · **§1 현행 본문(`:16`~`:36`) hit 0** · 제목 hit 0 · **이력 보존 grep** = `Mock-first paradigm` 1 + `MASTER-BILLING-DOMAIN-ACTIVATE-001` 3 + `FND-BILLING-SEAM-001` 1 잔존 · **삭제 라인 -9 전량 in-place supersede**(구 §1 6행 → §1.1 verbatim 재수록 · 제목 1 · `:65` 1 · REVIEW §7 행 1 = 이력 삭제 0) · propagate **ok=18 fail=0** · **전파 후 4-repo per-file sha 재일치 6/6**(billing-rules `8f6c4a2dc79b` · code-principles `de906ed2445b` · code-style-guide `a2527f9b46ed` · verification-and-review `d2e5f7cba720` · libs-versions `eb0bbd798a56` · KOIN_DI `fe2f2da2da1e`) + `docs/rules` 44-file aggregate `425f4d00…`→**`b368fcdbffcdb0e5` 4-repo 동일** · `.claude/rules` aggregate `84ee6331ab086cdc` **무변동**(G 미채택 증명) · verify-sync **163 PASS / DRIFT 2 / MISS 6**(= T6/T7 post-state **동일** = **신규 drift 0** · 본 cycle 6 file 전량 PASS 실측 · DRIFT 2 = release-checklist.template FND/PDOCS P4-lazy · MISS 6 = CHARTER + production-cli-access-tokens master-only × 3 = **전량 pre-existing** · exit 1 = 비차단) · **보호 5 sha drift 0**(edit-set ∩ 보호 5 = ∅ 실측 · manifest resync 불요) · **production 확장자 0 건**(4-repo 전부) · **동결 GB/GD/GT 파일·커밋 0**(전파 로그 3 repo 이름 0건) · `run-*` recipe 보존(**`--prune` 미사용** = 명시 file list 전파 · 선례 사고 회피) · 자식 path-limited commit(각 **files=6** exact · **Selfward dirty 27 WIP 무흡수** 실측). **§0 gate**: 4-repo HEAD 전량 paste 기대 정확 일치(master `739ea9f` · SW `db1c106` ahead 9 · FND `b1ff997` · PDOCS `2d762a8`) · **자진 정정 1** = paste §0-1 인용 aggregate sha 3종(`b23a8524…`/`21456187…`/`8e069456…`)이 본 세션 측정 3 방법(concat / per-file-hash / git-index) 어느 것으로도 재현 X → **불변식(4-repo 동일)은 전 방법 성립 확인** · 실측값 박제로 갈음(= 방법 차이 · content drift 아님 · 실체가 이긴다). **사고**: 없음(zsh word-split 로 1차 자식 commit 3건 pathspec 오류 = **commit 0 · 파일 변경 0** · 명시 인자로 즉시 재실행 성공 · git-lock daemon plist 미load advisory 비차단 · verify-sync stale-ref 5 = DIET-2-003 후속 pre-existing). **후속(scope 외)**: `billing-rules.md:3` "자식 repo (GT/GD/GB)" + §9 footer "6-repo" = topology 어휘 stale(= T7 §15 가 별 cycle 로 회부한 rules 층 sweep 영역 · 본 cycle 접촉 = STOP#2 → **무접촉 준수**) · Koin 4.2 상향 자체(= §9a 는 절차만 신설 · 실 상향 X) · push = Coin(순서 = FND `b1ff997` → SW → 본 cycle 분). **Negative Space**: production/EF/DB/Money 0 · 보호 5 sha 0 · 구 서술 삭제 0 · `.claude/rules/` 신설 0 · GB/GD/GT 0 · `--prune` 0 · `scripts/` 로직 0 · billing-rules §2/§3/§4/§5/§7/§8 0 · rules 층 topology sweep 0(scope 준수). | **4-repo 적용** (master content `41d7eda` + 자식 3 propagate byte-identical 6 file: app-foundation `08248c8` / gently-product-docs `24eb03f` / Selfward `624bec1` · `.auto-memory/propagation-status.md`[verify-sync auto-regen] + CLAUDE.md §15 + REPORT = master-only audit commit · REPORT = `.ai/reports/MASTER-CLI-COMPOSITION-RULES-S3-001/REPORT.md` · propagation-reports 없음[명시 file list propagate · report-gen 미실행] · GB/GD/GT 파일·커밋 0 · push=Coin) |
| MASTER-CLI-RULES-SETTLE-001 | 2026-07-26 | **실측이 낳은 규칙 13 + 정정 6 = 19 정착 + ★병렬 판정 기준 정정** (Mode M5 cli-infra-ops · production/EF/DB/Money **기전 0 LOC** · docs-only · 원천 = `RULES-CANDIDATES-FROM-CHAT-20260726` §A 7 + §B 3 + §C 3 **+ 그 뒤 3 cycle 이 낳은 정정·신설 6** · cowork contract cc-paste-MASTER-CLI-RULES-SETTLE-001). **본질**: 사고를 낸 것은 코드였지만 **그 사고를 허용한 것은 규칙**이었다 — 특히 §D. `cross-repo-parallel-exec-detail.md:83` 은 *"같은 file 접촉 workstream = 병렬 금지"* 라고만 말했고, 2026-07-26 Selfward 3 cycle 동시 진행(`RULES-AS-TESTS`=composeApp/rules · `DOCS-ENTRY-REALIGN`=docs/CLAUDE.md · `OUTPUT-BUDGET`=supabase/functions)은 **file 겹침 0 = 현행 규칙 전부 준수**였는데 **커밋이 오염**됐다(9건). ★**공유 자원은 file 이 아니라 `git index`** 다(repo 당 1개 · `add`→`commit` 비원자적). **scope = 비보호 10 file (4-repo byte-identical)**: ⒜ `verification-and-review.md:19,21,23` = A-1 **실 데이터 검증 의무**(빈 계정 금지 · seed 계정 자산화 · 근거 F2 = 기록 **0건 200 / 실 기록 502** · "AI 기능이 한 번도 작동한 적 없다"가 몇 달간 미검출) + A-2 **성공 경로 관측 선행**(관측→변경 · 역순 금지) + A-3 **진단 로그**(분기 식별자+발췌 상한+에러 · **마스킹 의무** = 모델 출력 한정 · 사용자 원문/키/토큰 제외) ⒝ `supabase-handling.md:76` **§2.10 신설** = A-4 **EF 로그 = Management API `logs.all`**(`/database/query` 와 **동일 PAT** · `function_logs`/`function_edge_logs`/`edge_logs` · 콘솔=fallback) + **§2.1·§4.4·§10.3 3곳 supersede 표식**(★`supabase functions logs` **서브커맨드 부재 실측** v2.98.2 = `delete/deploy/download/list/new/serve` 6종 · **도구 부재 ≠ 경로 부재**) · `:308,314,322,328` **§11 AI 응답 계약 신설** = C-1 **낫표 「」 명시**(F2 주 원인 = **프롬프트 자신의 verbatim 지시**가 raw `"` 유도 → JSON 조기 종료) + C-2 **정정본**(절단 감지 = **`stop_reason` 1차** · `outputTokens>=maxTokens` = **폴백 전용** · ★**OR 금지** — 초안은 **대리 신호를 규칙화**하려 했다 = **A-7 과 정면 충돌** · SDK 0.30.0 실취득 23/23) + C-3 **파싱 후 절단**(`MAX_OUTPUT_CHARS 5000` 선절단 → 초과 시 **100% 파싱 실패**) + A-3 EF 측 ⒞ `reporting.md:193` **§8.1 신설** = A-5+**A-5′**(수치 = **산출 명령 + 환경**[shell·`LC_COLLATE`·해시 도구·glob `n`] · ★**aggregate 해시 = 정체성 아닌 drift 검출기** = 재현 대상은 hex 가 아니라 **"한 실행 안에서 N-repo 동일"** 불변식 · 불일치 = **먼저 환경 차이 의심** · 산식 교체 시 박제) ⒟ `cycle-discipline.md:131` **§30 신설** = A-6+**A-6′**(ChangeBudget **3층 분리** + **밴드가 분류 기준을 직접 말한다** + ★**재작성 file 은 밴드에서 빼고 "재작성 N+사유" 별도 보고** — `numstat` 은 **재작성을 재지 변경을 재지 않는다** · 근거 **5회 연속 초과** S0+181/S2+92/HARDEN/OUTPUT-BUDGET+176·+205/SETTLE+248 · **초과분은 매번 paste 자신이 요구한 문서·test**) ⒠ `code-principles.md:79` = **A-7 표면 속성 분류 금지 · 불변식을 잰다**(실측 3 = `probe.ts` 오분류[유일 Money probe 폐기 직전] · `docs/rules` 경로 오판[4-repo drift 직전] · `functions logs` 부재→"콘솔만 가능" 오단정) ⒡ `billing-rules.md:118,124,130,135` **§5a 신설** = B-1 **`settle-after-success` 기본**(Coin 확정 · `deduct-first`=예외+**사유 기재 의무** · 근거 = 같은 3 시도 구 판 **3 차감/결과 1** → 신 판 **1 차감/결과 1** 원장 실증) + B-2 **모호하면 차감 X**(under-charge < over-charge · `skipped_ambiguous` 계측) + B-3 **degrade = 내용 규칙 위반 한정**(parse 실패 = **재시도가 정답**) + **B-4 신설 = 금전 변동 RPC 멱등 fence**(★같은 파일 안 비대칭 실측: `grant_ad_credit` PK dedup ✓ · `credit_purchase` `external_id` UNIQUE ✓ · **`consume_ticket` 만 부재** ✗ · 구 `ConsumeFailed` 주석 *"차감 0 → 재시도 안전"* = **알 수 없는 것을 단언** → **과다→과소 청구**로 정정) ⒢ `cross-repo-parallel-exec-detail.md:84,99` = **`:83` 판정 기준 정정**(구 문면 **무삭제** · 바로 아래 *"★본 행의 판정 기준은 틀렸다"* 명시) + **§2.1.6 신설** D-1(file 겹침 = **필요조건이지 충분조건 아님**) · D-2(**worktree "가능"→같은 repo 병렬 시 「의무」 승격**) · D-3(`git commit -- pathspec` = 보조 · ★**HEAD 없는 신 file 엔 안 먹는다 = 반쪽**) · D-4(**디렉터리 pathspec 금지 · file 단위만**) · D-5(**복구 절차 = 절대 sha** · `HEAD~1` 이 **남의 커밋**을 가리킨 실측) · D-6(**커밋 file 집합 대조 의무**) ⒣ `.claude/rules/cross-repo-parallel-exec.md:28` kernel 1-bullet 동기화 ⒤ `paste-source-authoring/SKILL.md` **§4.5**(D-6 · *"내 diff 는 깨끗하다"* = **diff 에 참 · 커밋에 거짓 가능**) + **§4.6**(A-5′) ⒥ `paste-authoring-disk-verification.md` = **thin 유지**(정착 좌표 1줄만 · 본문 SoT = skill body). **§C 소유 판정 3 기준 실측 PASS**(① 4-repo byte-identical `f567cff5a52e`×4 ② 자기 선언 §8→`rule-footer-common` ③ `propagate.sh:99` scan set `docs`) ⟹ **master 소유** · §5-7(Selfward 전유 시 초안만) **미발동**. **검증**: **additive-ledger PASS** = 삭제 5 라인 **전량 in-place supersede 원문 보존 5/5**(60자 prefix 대조) · **통째 재작성 0** · ChangeBudget **+166/−5 = 순 +161**(밴드 +150~+320 · **분류 기준 명시** = 문서라 주석/실코드 구분 없음·빈 줄 포함) · propagate **ok=30 fail=0**(`--prune` **미사용** = 명시 file list · run-* recipe 보존) · **전파 후 4-repo per-file sha 10/10 동일** + `docs/rules` 44-file aggregate `b368fcdbffcdb0e5`→**`52a4f0c0a62614e8` 4-repo 동일**(산식 `cat docs/rules/*.md | shasum -a 256` · 환경 `bash 3.2.57` `LC_COLLATE=C.UTF-8` `n=44` **병기** = A-5′ 자기적용 · paste 인용 `ecda3384…` 미재현이나 **불변식은 전·후 양쪽 성립** → §0-2 규약대로 통과) · verify-sync **163 PASS / DRIFT 2 / MISS 6** = T6·T7·S3 post-state **동일** = **신규 drift 0**(본 cycle 10 file **DRIFT+MISS 0건** · DRIFT 2 = release-checklist.template FND/PDOCS **P4-lazy**[Selfward=✓] · MISS 6 = CHARTER + production-cli-access-tokens **master-only**×3 = 전량 pre-existing) · **보호 5 sha drift 0**(manifest **직접 grep 실측** 선행 · edit-set ∩ 보호 5 = **∅** → resync 불요) · **production 0 LOC**(4-repo) · **동결 GB/GD/GT 파일·커밋 0**(HEAD `a67a5a3`/`912e80a`/`6612e4d` + dirty 104/74/70 = §0 baseline 불변) · **D-6 자기적용 = 커밋 집합 대조 4/4 정확 일치**(각 10/10 exact · scope 밖 0 · ★**Selfward untracked WIP 35 무흡수** 실증 · D-3+D-4 준수 = file 단위 명시 pathspec · 디렉터리 pathspec 0). **§0 gate**: master HEAD `5837604` ahead 0 dirty 0 **정확 일치** + §0-1 sha12 **7/7 일치** · FND `08248c8` + PDOCS `96d33c4`(ahead 1) 일치 · **SW `1ec4c8e`→`fde306e`(ahead 14 · dirty 35) = A1 forward-progress**(동시 세션 `SELFWARD-SUBDIR-ENTRY-REALIGN-002` 2 commit = `composeApp/CLAUDE.md`+`supabase/CLAUDE.md` · **edit-set 무접촉 실측** · dirty 35 = **전량 untracked** `_scratch/`22+`cc-paste-*`13 · **tracked 수정 0 · staged 0** · STOP#4 미발동) · **§5-5 STOP 미발동 판정**(전파 직전 재측정 +23분 시점 = HEAD 불변 · tracked-dirty 0 · staged 0 · worktree main 단독 · 전파 경로 clean). **사고**: 자식 commit 1차 pathspec 오류 3건(= zsh 미분할로 `$FILES` 전체가 단일 pathspec) = **commit 0 · 파일 변경 0** · 명시 인자 즉시 재실행 성공(선례 = S3-001 동형) · verify-sync stale-ref 5 + git-lock daemon advisory = pre-existing 비차단. **후속(scope 외)**: `billing-rules.md:3`(*"자식 repo (GT/GD/GB)"*) + §9 footer *"6-repo"* topology 어휘 = **T7 이 별 cycle 로 회부한 rules 층 sweep** (본 cycle 접촉 = STOP#2 → **무접촉 준수**) · D-2 승격의 hook enforce(현재 문서 규범 단일) · `consume_ticket` 멱등 키 **실 도입**(= B-4 는 rule 만 · `skipped_ambiguous` 계측치 동반 재판정 · 현재 실측 0건) · push = Coin. **Negative Space**: production/EF/DB/Money 기전 0 · 보호 5 sha 0 · 기존 서술 삭제 0 · 동결 3 = 0 · `--prune` 0 · `scripts/` 로직 0 · `.pen`/migration 0 · 자식 `docs/rules` 직접 편집 0 · rules 층 topology sweep 0. | **4-repo 적용** (master content `d9fd3c1` + 자식 3 propagate byte-identical 10 file: app-foundation `6459f45` / gently-product-docs `d3fd51e` / Selfward `f21a506` · `.auto-memory/propagation-status.md`[verify-sync auto-regen] + CLAUDE.md §15 + REPORT = master-only audit commit · REPORT = `.ai/reports/MASTER-CLI-RULES-SETTLE-001/REPORT.md` · propagation-reports 없음[명시 file list propagate · report-gen 미실행] · GB/GD/GT 파일·커밋 0 · push=Coin) |
| MASTER-CLI-MEASUREMENT-DISCIPLINE-001 | 2026-07-26 | **측정 규율 2 규칙 정착 + 4-repo 전파** — 둘 다 *이미 반복 발현했는데 아직 아무데도 안 적혀 있던* 것 (Mode M5 cli-infra-ops · production/EF/DB/Money **0 LOC** · docs-only · 원천 = `AUDIT-SELFWARD-SOT-COHERENCE-LEDGER-20260726` §8-P + `RULES-CANDIDATES-FROM-CHAT-20260726` §A-7/§D-5/§D-7 · cowork contract cc-paste-MASTER-CLI-MEASUREMENT-DISCIPLINE-001 · 선행 `MASTER-CLI-RULES-SETTLE-001` 이 19 규칙을 정착시켰으나 본 2건 미포함 = 진입 grep **0 hit** 실측 확인). **본질**: 규칙 1 = **"없다" 는 탐색 범위에 대한 진술이지 대상에 대한 진술이 아니다** — subset(staged 사본·단일 repo cwd glob·부분 grep·디렉터리 목록) 위의 부재 판정은 **무효**(없는 게 아니라 **안 본 것**) · 범위 밖 = 「부재」아닌 **「판정 보류」** · 위임 시 범위 명시 · **받은 부재 보고는 회수 시 재측정**(보고자가 정직해도 안 쓴 것이 섞인다). 규칙 2 = **상충은 문면끼리만 나지 않는다** — paste 발행 전 ①scope×제외 **+ ②scope×ChangeBudget 밴드/수치/xverify 기준** 양쪽 대조 의무 · **①의 통과가 ②의 알리바이가 되지 않는다**. **scope = 비보호 3 file(4-repo byte-identical) · +35/−0 순수 additive**: ⒜ `code-principles.md:97` = 규칙 1 **본문** 「부재는 전수 트리에서만 판정한다」(6 규범 bullet + 실측 사례 2) ⒝ `cycle-discipline.md:141` **§31 신설** = 규칙 2 본문(6 bullet · **★집행자 측 대칭 의무** = 상충 발견 시 **자동 봉합 금지 · paste-back 보고**) + `:96` **§17 범위 축 pointer 1행**(BASELINE 4-step 은 **전수 트리 위에서만** 유효) ⒞ `paste-authoring-disk-verification.md:17` = **thin 유지** + 정착 좌표 2 기록(본문 복제 0). **★정착처 재판정 = paste §3.1 원안 기각(§FREEDOM 행사 · 규칙 2 자기 시연)**: 원안 정착처 `paste-authoring-disk-verification.md` = 실측 **17-line thin pointer**(`:3` 본문 SoT = `paste-source-authoring/SKILL.md` · 본문 0)이고 **직전 cycle 이 의도적으로 thin 유지**(`:17` = *"본문 복제 0 · 정착 좌표만"*)인데, 실 본문 SoT(skill)은 본 paste **§3.3 무접촉 + §6 STOP#2** 대상 ⟹ **§3.1(scope) × §3.3·§6-2(제외) = 충돌 1**(paste §3.4 자가 검사는 *"충돌 0"* 선언 · **"지정 정착처가 본문을 담을 수 있는 file 인가"** 를 안 봄) · 원안대로면 직전 cycle L1-4 판정을 **1 commit 만에 반전** + paste 자신의 경고(*"중복 박제 = 재drift 원인"*) 위반 → **자동 봉합 X · 보고 후 재판정**(규칙 1 = 기존 §2 「표면 속성으로 분류하지 않는다」의 ***부재* 축** = 그 절 실측 3 사례가 곧 paste §1 #1·#2·#3 = 같은 원칙을 두 file 로 쪼개지 않음 / 규칙 2 = **§30 ChangeBudget 바로 뒤** = *"문면↔밴드/수치"* 축과 같은 자리). **paste 전제 재측정(§8 반증 의무)**: §1 실측 **5/5 substantiated**(#1·#2·#3 = 이미 `code-principles.md` §2 disk 박제 · #4 = `AUDIT…:63` verbatim *"staged subset 28 file … 오탐 13건 … 전량 기각"* · #5 = 부모 mount root **실존** + **tracked 0/4 repo**) · §2 상충 **3/3 CONFIRMED**(#1 = `:126` 상단 배너 ↔ `:137` *"이력 블록 내부에만"* + `:100` 이력 블록 = 말미 / #2 = `:120` S10 `L99` ↔ `:65` D3 zone · ★**독립 교차 확인** = *후행* paste `UPSTREAM-LAYER-EVICTION` §2.4 가 *"`96d33c4` 에서 §3-S10 이 §2.3 D3 zone 과 상충했다(L99)"* 자기 박제 / #3 = `:188` *"순감 −120~−40"* ↔ `:130` *"구 문면 = 삭제 0 · verbatim 보존"* + `:190` *"이력 보존 +140"*). **★재측정이 규칙을 강화한 발견**: #3 의 그 paste 는 §2.4 에서 **교차 검사를 실제 돌리고 "충돌 0" 선언**했는데도 #3 이 남았다 = **①은 통과 · ②를 안 봄** ⟹ 규칙 2 에 *"①의 통과가 ②의 알리바이가 되지 않는다"* 명문화. **자진 정정 2**: ① paste §1-#5 *"16,022 bytes"* → 실측 **17,903**(mtime `07-26 20:54` · ledger `20:18` 이후 증가 유력 · 파일 정체성·결론 불변 · **규칙 본문에 미인용**) ② paste §11 *"`d3fd51e` MASTER-CLI-RULES-SETTLE-001"* = 실측 **PDOCS propagate sha** · master content = **`d9fd3c1`**(판정 불변). **검증**: **본문 1곳 + pointer**(grep `전수 트리|판정 보류|교차 검사` = 본문 2 각 1곳 + pointer 2 · **동일 본문 2회 박제 0** · **`.claude/` 0 hit** = STOP#2 준수) · propagate **ok=9 fail=0**(**명시 file list** · `--all`/`--prune` **미사용** = STOP#4 · run-* recipe false-orphan 회피) · **4-repo per-file sha 3/3 동일**(code-principles `1eb738b2fb80992a` · cycle-discipline `05836ebe130008a0` · paste-authoring `b4ce494dab8097ea`) + `docs/rules` 44-file aggregate `52a4f0c0a62614e8`→**`0c4090af02e5ebf8` 4-repo 동일**(산식=`cat docs/rules/*.md \| shasum -a 256` · 환경=bash 3.2.57 · LC_COLLATE=unset(C) · shasum 6.02 · n=44 = **§8.1 자기적용**) · verify-sync **163 PASS / DRIFT 2 / MISS 6** = T6·T7·S3·SETTLE post-state **동일** = **신규 drift 0**(본 cycle 3 file **DRIFT+MISS 0건** · DRIFT 2 = release-checklist.template FND/PDOCS **P4-lazy**[Selfward=✓] · MISS 6 = CHARTER + production-cli-access-tokens **master-only**×3 = 전량 pre-existing) · **보호 5 sha drift 0**(manifest **직접 grep 실측 선행** · edit-set ∩ 보호 = **∅** → resync 불요) · **production 0 LOC**(4-repo · 변경 확장자 `.md` 단독) · **D-6 커밋 집합 대조 3/3 exact × 3 자식**(scope 밖 0 · ★**Selfward untracked WIP 37 무흡수** · **file 단위 명시 pathspec** = D-4 · 디렉터리 pathspec 0) · **동결 GB/GD/GT 파일·커밋 0** · ChangeBudget **+35** vs paste 밴드 **+57 = 하회**(§30 3층 자기적용 = 실코드 0 · 주석 N/A · test 0 · 문서 산문 +35 빈 줄 포함). **§0 gate**: master `b5d3def` ahead 2 dirty 0 + PDOCS `a17375b` ahead 3 = **정확 일치** · **FND `08248c8`→`6459f45` + SW `fde306e`→`f21a506` (각 forward 1) = A1 forward-progress**(`merge-base --is-ancestor` 4/4 ANCESTOR · delta 1 commit = **직전 `MASTER-CLI-RULES-SETTLE-001` propagate commit 그 자체** = paste §0 이 전파 **이전** sha 인용 · **STOP#1 실질 조건은 통과** = 대상 rule **4-repo byte-identical** 실측[`9edd66771a118e3a`×4 · `1f3bd3832d2f1c94`×4 · aggregate `52a4f0c0…`×4] = **drift 0** · paste 인용값대로였다면 FND/SW 가 master 보다 **뒤처진 = 실제 drift** 였을 것 = **실측이 paste 기대보다 안전한 방향** · SW dirty 37 = **전량 untracked** · `docs/rules`+`.claude` **0 hit** · 선례 T7/SETTLE §0 gate · **STOP#1 미발동** · raw 보고). **사고**: 없음(★직전 2 cycle 반복된 **zsh word-split pathspec 오류 재발 0** = 자식 commit 을 변수 없이 **literal 인자** 실행 · git-lock daemon plist 미load advisory + verify-sync stale-ref 5 = pre-existing 비차단). **후속(scope 외 · STOP#6 준수)**: `billing-rules.md:3` + §9 footer *"6-repo"* + `rule-footer-common.md` + `cross-repo-parallel-exec.md` topology 어휘 = **T7 회부 rules 층 sweep**(본 cycle **무접촉**) · 규칙 2 hook enforce(발행 측 = cowork → cli hook 은 반쪽) · push = Coin. **Negative Space**: `verification-and-review.md` **고려 후 제외**(= 규칙 1 의 *"받은 부재 보고 회수 시 재측정"* 이 `/verify` 층에도 걸리나 **본문 1곳** 원칙상 4번째 file = scope 확장 · 해당 의무는 §2 본문 bullet 으로 이미 규범화) · `reporting.md` 역방향 pointer 0(= §8.1 이 이미 `code-principles.md §2` 인용 = 링크 기성립) · `.claude/rules/` 신설 0(= 자동 적재층 · T1 다이어트 역행) · `.claude/skills/` 0(STOP#2) · production/EF/DB/Money 0 · 보호 5 sha 0 · 기존 서술 삭제 0 · GB/GD/GT 0 · `--prune` 0 · `scripts/` 로직 0 · rules 층 topology sweep 0. | **4-repo 적용** (master content `9973d10` + 자식 3 propagate byte-identical 3 file: app-foundation `179dc0f` / gently-product-docs `a4bbc24` / Selfward `044dda3` · `.auto-memory/propagation-status.md`[verify-sync auto-regen] + CLAUDE.md §15 + REPORT = master-only audit commit · REPORT = `.ai/reports/MASTER-CLI-MEASUREMENT-DISCIPLINE-001/REPORT.md` · propagation-reports 없음[명시 file list propagate · report-gen 미실행] · GB/GD/GT 파일·커밋 0 · push=Coin) |

| MASTER-CLI-STALE-SWEEP-4ACTIVE-001 | 2026-07-29 | T6 재편(4-active + 3 동결) 실행 층 stale 일소 (M5 · production 0 LOC · 보호 5 sha 0 변동). **실행 결함 3**: ① hooks 3 REPOS 구 6-repo → Selfward 무감시 + 동결 3 영구 false DRIFT 3건(4-active parity + `FROZEN_REPOS` HEAD 관찰 분리 = 오탐 0) ② archiver plist = 동결 3 **쓰기** 유도 + SW 누락 ③ `report-gen.sh` 전파 대상 하드코딩 → `$TARGET_REPOS`. 문면 = G1 19 + G2 8 + G4 32 + 부모root §6(STOP 5항 재복제 → 9항 pointer+발췌) + `claude-wrap.sh`(slot miss fail-fast → warn+skip). propagate ok=150/0 · verify-sync **163 PASS / DRIFT 2 / MISS 6 = 신규 drift 0**. **사고 4**(자기검출·복구): PAT 4종 transcript 노출(**Coin rotation 회수** · 디스크 0) · G4 스윕 역사서술 훼손 → `PACKAGE-OVERVIEW.md` revert · master-only CHARTER 오전파 → 복구 · zsh word-split(파일 0). 상세 = [`REPORT.md`](.ai/reports/MASTER-CLI-STALE-SWEEP-4ACTIVE-001/REPORT.md) | **4-repo 적용** (master content + 자식 3 byte-identical 50 file · 동결 3 파일·커밋 0) |
| MASTER-CLI-JUDGMENT-SHIFT-001 | 2026-07-29 | 구형 모델 전제 검사장치 → **판단 위임** (M5 · production 0 LOC · 보호 5 sha 0). 제거 3 hook + rule 2 → COLD verbatim(소실 0) · 축소 2 · stdout 7→1·4→1줄 · stop-gate 현 세션 scope + exit 정합. 등록 17→14 · verify-sync **158 PASS · 신규 drift 0** · 사고 0. 상세 = [`REPORT.md`](.ai/reports/MASTER-CLI-JUDGMENT-SHIFT-001/REPORT.md) | **4-repo 적용** (master content `15b1ba1` + 자식 3 byte-identical 22 file: FND `986a25b` / PDOCS `33c4d93` / SW `86b2e8f` · 동결 3 파일·커밋 0) |

> **§15 cold 재배치** (= `MASTER-CLI-CONTEXT-OPT-PHASE1-CYCLE-HISTORY-COLD-001` 2026-06-01 + `MASTER-CLI-CONTEXT-OPT-CYCLE-HISTORY-COLD-002` 2026-06-04 2회차 + `MASTER-S15-PRELAUNCH-EXEC2-B-001` 2026-06-05 3회차 + `MASTER-S15-PRELAUNCH-EXEC3-001` 2026-06-05 4회차 + `MASTER-S15-PRELAUNCH-EXEC3-002` 2026-06-05 5회차 + `MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001` 2026-06-10 6회차 + `MASTER-CLI-S15-HOT-DEMOTE-003` 2026-06-11 7회차 + `MASTER-CLI-S15-HOT-DEMOTE-004` 2026-06-22 8회차 + `MASTER-CLI-S15-HOT-DEMOTE-005` 2026-07-17 9회차): 위 표 = 최근 5 entry + 본 cycle entry 만 hot 유지 default. master cycle **137 entry 전체 이력** (= `C1-MASTER-BOOTSTRAP-001` ~ `MASTER-CLI-SOTMAP-REGISTER-001`) = verbatim 보존 → [`.auto-memory/master-cycle-history-COLD.md`](.auto-memory/master-cycle-history-COLD.md) (= 삭제 0 · 감사 추적 영구 보존 · lifecycle = 매 5 cycle 또는 분기 review). 신규 master cycle = 본 표 append (§16 절차) + hot > 10 도달 시 cold 재이전 (= `measure-gsm-cycle.sh` Stop hook 자동 advisory surface · 판정·이전 = 수동).

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
- [docs/rules/workflow-core.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/docs/rules/workflow-core.md)
- [docs/rules/cycle-discipline.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/docs/rules/cycle-discipline.md)
- [.auto-memory/protected-file-hashes.md](computer:///Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/.auto-memory/protected-file-hashes.md)
