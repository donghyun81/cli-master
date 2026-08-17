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
> 자식 repo (app-foundation / toward-product-docs / Selfward / 향후 추가) 는 본 repo 에서 단방향 propagation 을 받는다 (= 4-repo · 2026-07-17 T6 재편 · GB/GD/GT = 동결 계승 원천 = 전파 대상 X · §1.3).
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
| toward-product-docs (PDOCS) | 공통 제품 기획·비전 문서 | `<PARENT>/toward-product-docs` |
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
2. bash scripts/propagate.sh <relative-path> [--targets FND,toward-product-docs,Selfward|all]   # C3 에서 신설 · alias = GB/GD/GT/FND 만 · 그 외 = 폴더명 verbatim
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

## 5. STOP 조건 (= pointer · 본문 = `.claude/rules/stop-canonical.md`)

> **본 § = pointer 영역** (= 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` 이동 · Coin 본심 ③). 본문 단일 SoT = [`.claude/rules/stop-canonical.md`](.claude/rules/stop-canonical.md) — **자동 주입층**이라 전 세션 상시 가시 + propagate 자동 정합. 구 본문 = 본 § inline 9 항 표 (2026-05-22 `MASTER-CLI-CYCLE-1-STOP-CANONICAL-INTEGRATION-001` 통합판) + 자식 `CLAUDE.md §5` 복제 2 (= FND · SW) → **복제 3 → 1** · 9 항 표 byte-identical 이동 · 의미 손실 0.
> **재복제 금지**: 아래 발췌는 9 항 **전량** 제목만. 부분 재복제가 drift 를 낳는다 (= 부모 root `CLAUDE.md §6` 이 canonical 9 중 5 만 복제해 drift 했던 선례 · 2026-07-29 `MASTER-CLI-STALE-SWEEP-4ACTIVE-001` 정정).

**9 항 발췌** (= trigger·mitigation 상세 = canonical 정독 의무): ① DB migration / Money / Auth 영향 경로 ② Scope expansion ③ 비가역 변경 징후 ④ 예상 외 시스템 상태 (baseline mismatch) ⑤ 보호 5 file sha drift ⑥ 자식 cli infra drift ⑦ Cross-repo HIGH RISK 도메인 진입 ⑧ `git mv` + sed stage 누락 ⑨ 사용자 본심 분기 의제 (= **Mode 오결정 sub-case 흡수**). 추가 = **동결 3 (GB/GD/GT) 쓰기 = STOP**. `BLOCKED` 종료 = 권한 / 환경 이슈 한정.

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
아키텍처 공통 SoT: 각 자식 repo 의 `docs/agent/architecture/` (각 자식 repo 가 `claude-cli-master` propagation 받음).

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

## 15. master cycle 진행 이력 (= **hot 상한 3 entry · 각 ≤400B**)

> **상한 규약** (= 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` 신설 · 상시 로드 헌법의 ~70% 를 이력이 차지하던 상태 해소): 본 표 = **최근 3 entry 만** · 각 entry **≤400B**. **entry 신설 시 3 초과분 = 즉시 COLD demote** (= `.auto-memory/master-cycle-history-COLD.md` verbatim append · advisory 대기 X · 마감 step 안에서 집행). 400B 초과 서술은 재작성하되 **원문은 COLD 에 verbatim** (= 소실 0) · 상세는 `.ai/reports/<cycle-id>/REPORT.md` 가 진짜 SoT. 집행 절차 = `docs/rules/cycle-discipline.md §15`.

| cycle ID | 마감일 | 변경 요약 | 영향 자식 repo |
|---|---|---|---|

| MULTI-REPO-RENAME-TOWARD-001 | 2026-08-15 | repo명 `gently-product-docs` → **`toward-product-docs`** (Gently→Toward 브랜드층 · prod 0 · 보호 sha 0). 부모 root `mv` + 기계층 술어 전수 치환 **92 file**(master 29·FND 21·SW 21·PDOCS 20·root 1) + 안내층 2. 이력층 무접촉 · appId·코드 심볼·동결 3·GitHub remote 무변. [R](.ai/reports/MULTI-REPO-RENAME-TOWARD-001/REPORT.md) | 4-repo 91 + root 1 |
| MASTER-BRAND-TOWARD-INFRA-001 | 2026-08-15 | 브랜드층 Gently→Toward (docs-only · prod 0 · 보호 sha 0). census 56 = ㉯심볼 28·㉰계보 25 존치 · ㉮치환 **3** = 대문자 grep 밖 소문자 `gently-product-docs`. `reporting.md §8.2` 신설(REPORT 자기 sha 금지) · 부모 root §2.1 정정. [R](.ai/reports/MASTER-BRAND-TOWARD-INFRA-001/REPORT.md) | 4-repo 4 + root 1 |
| MASTER-STALE-TRACKING-001 | 2026-08-17 | 낡은 문면 추적 기제 신설 (M5 · prod 0 LOC · 보호 sha 0 · 자동주입 file 수 0). `stale-artifact-tracking.md` = `legacy-cleanup-governance` 자매(그쪽 「적용 범위」가 문서형/ops 를 **명시 제외** = 공백 실측 · 겹침 0). 발견 의무 3단계 + `STALE-DEBT.md` 대장(SW 단독 · DESIGN-DEBT 선례 정합) + sweep trigger 3. ★이력·박제 = 대상 밖(후보 6 중 **2 기각** 실증). [R](.ai/reports/MASTER-STALE-TRACKING-001/REPORT.md) | 4-repo 5 + SW 2 |

> **§15 cold 재배치** (= 10 회차 누적 · `MASTER-CLI-CONTEXT-OPT-PHASE1-CYCLE-HISTORY-COLD-001` 2026-06-01 → … → `MASTER-CLI-S15-HOT-DEMOTE-005` 2026-07-17 9회차 → **`MASTER-CLI-CONTEXT-DIET-3-001` 2026-07-29 10회차** · 회차 전량 열거 = COLD §1 heading lineage): master cycle **149 entry 전체 이력** (= `C1-MASTER-BOOTSTRAP-001` ~ 본 cycle 직전) = verbatim 보존 → [`.auto-memory/master-cycle-history-COLD.md`](.auto-memory/master-cycle-history-COLD.md) (= 삭제 0 · 감사 추적 영구 보존 · lifecycle = 매 5 cycle 또는 분기 review). **hot 압축 행의 원문도 COLD 에 verbatim 실재** (= 재작성 ≠ 소실).

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
