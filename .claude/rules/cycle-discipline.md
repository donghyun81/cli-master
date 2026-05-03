# Cycle Discipline Rules

> **단일 목적**: master ↔ 자식 repo 의 cycle 운영 표준 — 거시 목표 / 정합 강제 범위 / repo 규약 / commit 표준 / 자기 검증 / 보호 파일 변경 의무 / 환경 정합 / Phase C IMPL 흐름 / Cowork ↔ CLI 동기화.
> **분할 출처**: 기존 workflow.md (662 줄) 의 line 341~450 + 502~end 발췌 (C2-RULES-RESTRUCTURE-001 · §12 만 pencil-automation.md 로 분리).
> **연관 파일**:
> - `workflow-core.md` — 단계 흐름 (intake / collect / plan / implement / verify / review)
> - `pencil-automation.md` — Pencil .pen 저장 자동화 (§12 분리)
> - `safety-and-secrets.md` — 절대 금지 명령
> - `legacy-cleanup-governance.md` — cleanup 의무
> - `verification-and-review.md` — /verify 와 /review 세부
> SOT: `CLAUDE.md`

---

## Cycle Discipline

> 본 repo 의 cycle 운영 표준. 매 task 가 따르는 공통 규약.
> 근거: 2026-04-24~27 cycle 중 OPS 정책 mis-placement 사고 (Task I) + commit drift 사고 3건 (GT a308949 · GB 889740b · GD b6bed28) 이후 정립.

### 1) 거시 목표

본 repo 의 본 작업 = **Pencil → Compose 파이프라인**.
[디자인]  Pencil.dev 캔버스에서 화면을 그린다
[SoT]     화면별로 두 파일 유지: ui-spec.json (구조) + <screen>.pen (시각)
[검증]    두 SoT 가 sha 로 동기화되어 있는지 검증
[구현]    SoT 보고 Compose 코드 작성 (첫 product 변경 = Track D)
[배포]    실 앱 반영

모든 cycle 은 위 단계의 한 부분을 직접 진척시킨다. 그 외는 OPS 정비.

### 2) OPS 신설 금지 원칙

본 작업 직접 지원이 아닌 정책은 룰 파일에 하지 않는다.

- 새 룰 박기 전 **도메인 매칭 검증 1회 필수** : 어느 기존 룰 파일의 도메인에 속하는가.
- 어느 파일에도 안 속하면 하지 않는다. 운영 메모로만 유지.
- 본 작업 무관 OPS hygiene 류 task 신설 금지. **사고 발생 시 본 작업 직접 블로킹 시에만 처리** (lazy mode).

### 3) 3-repo byte-identical 강제 범위

보호 파일 4종에만 한정:
- `docs/schemas/ui-spec.schema.json`
- `.claude/rules/pencil-uiux-workflow.md`
- `docs/design/pencil-sot-policy.md`
- `.claude/rules/uiux-sot-refresh.md`

다른 룰 파일은 repo-specific 가능. 단 워크플로우 표준 (본 §섹션 포함) 을 3-repo 모두에 적용하려면 task 별로 propagation 명시.

### 4) repo 규약

task ID prefix 가 source repo 를 가리킨다:
- `GB-XXX` → GB source · GD/GT propagation
- `GD-XXX` → GD source · GB/GT propagation (드물지만 가능)
- `GT-XXX` → GT source · GB/GD propagation

보호 파일은 어느 repo source 든 3-repo byte-identical 결과 강제.

### 5) agent commit 한시 허가 정책 (v2)

`settings.json` deny list 의 `git commit` 차단을 아래 조건으로 한시 해제:

**자동 허용 (agent commit OK)**:
- docs / cleanup / propagation / report / refactor / test / chore / audit / discipline
- **`app/src/` 변경 + 빌드 PASS + STEP "go" 단계 Coin 명시 승인** (v2 신설)

**Coin direct 강제 (HIGH RISK · 빌드 검증 불가 영역)**:
- DB migration · auth/billing · secret 접촉
- 빌드 스크립트 자체 변경 (gradle 설정 / build.gradle 등)
- 빌드 검증 미수행 변경

분류 모호 시 agent 가 한 번 멈추고 Coin 명시 한 줄 받기.
묵시 동의: task 프롬프트에 `[agent-commit: yes]` 명시 시.

**v2 도입 근거**: GB-TRACK-D-PILOT-001 (Cycle 9, 64a110f) 에서 빌드 PASS + Coin "go" 명시 승인 후 회귀 위험이 객관적 검증됨 — Coin direct 와 결과 동등. v1 의 "app/src/ = 항상 Coin direct" 는 매 cycle 손 작업 강요로 Coin 의도 ("자동화") 와 어긋남. v2 는 명시 승인 + 빌드 검증을 위임 신뢰 단서로 인정.

### 6) commit subject 표준

형식: `<type>(<scope>): <task-id> <summary>`

- `type` : feat | fix | docs | chore | refactor | audit | test | perf | style
- `scope` : rule | schema | sot | app | ui | design | report | mcp | infra ...
- `task-id` : 해당 cycle 의 단일 task ID (다른 task ID 절대 포함 금지)
- `summary` : 50자 이하, 동사로 시작

### 7) commit body 표준 — 6 섹션 필수
[Goal]   거시 목적 1줄 (Pencil → Compose 파이프라인 어느 단계인지)
[Diff]   변경 파일 + 핵심 라인 수
[Sha]    변경된 보호 파일 새 sha 8자 prefix (해당 시 / 없으면 "(불변)")
[EC]     핵심 Exit Criteria 결과
[Next]   다음 cycle 트리거 1줄 (없으면 "(없음)")
[Refs]   parent commit hash + 연관 task ID

빈 섹션이라도 라벨은 유지. future grep 안정성.

### 8) future context 회복 패턴

새 cycle 시작 시 agent 자동 실행:
git log --oneline -20
git log --all --grep="<task-id-prefix>"
git log --all --grep="^[Sha]" -p
git show <commit>

memory 파일과 git log 충돌 시 **git log 우선** (immutable, point-of-truth).

### 9) 자기 검증 — 모든 commit 직후 1회 의무
git log -1 --format=%s
git log -1 --format=%b

expected message 와 1행씩 대조. 불일치 = drift = 해당 commit immutable 보존 + 다음 commit 부터 경로 점검.

### 10) 보호 파일 변경 시 추가 의무

보호 파일 4종 sha 가 바뀌는 commit:
- body `[Sha]` 섹션에 새 sha 8자 prefix 필수 명시
- 3-repo cross-verify 결과를 `[EC]` 섹션에 명시
- commit 후 memory baseline sha 갱신 (`.auto-memory/pencil_sot_protected_file_hashes.md`)

### 11) 보고서 lightweight 옵션

cleanup / docs / propagation / discipline 류 task 는 4 파일로 충분:
PLAN.md / VERIFY.md / REVIEW.md / TODO.md

`MODE.md` / `EVIDENCE.md` / `COMPOUND.md` 는 audit / evidence-heavy task 한정.


### 13) Claude Code 환경 정합 (Pencil MCP 본 작업 운영 baseline)

> 본 §13 = `Pencil → Compose 파이프라인` 의 agent 환경 가용성 보장 정책.
> 19c-1~6 사이 외부 검증된 환경 회귀 / mitigation 의 영구 정착.

**Claude Code version pin = 2.1.114 (#51736 패치 전까지 의무):**

- 2.1.116 이상 = stdio MCP tool discovery 회귀 (`anthropics/claude-code#51736`). 증상: `claude mcp list` 는 Connected 인데 ToolSearch query="pencil" empty. `mcp__pencil__*` 호출 자체 불가 → Path 2-A 본 작업 차단.
- 2.1.114 = #51736 회귀 직전 known-working. npm registry 의 2.1.115 부재 (skip).
- **npm 설치 의무** (native installer 아닌 npm scope). 이유: native auto-updater 가 다운그레이드 무력화.

**Native installer auto-updater 차단 (이중 설정 의무):**

- `~/.zshrc`:
  ```
  export DISABLE_AUTOUPDATER=1
  export DISABLE_UPDATES=1
  ```
- `~/.claude/settings.json` 의 `env`:
  ```json
  { "env": { "DISABLE_AUTOUPDATER": "1", "DISABLE_UPDATES": "1" } }
  ```

근거: native installer 의 background auto-updater 가 `~/.local/bin/claude` 심링크를 강제 재생성 (`anthropics/claude-code#41602`, `#3010`, `#28625`). 이중 차단 미설정 시 단순 `rm` 다운그레이드 무력.

**다운그레이드 절차 (1회 세팅):**

1. env 이중 설정 (`~/.zshrc` + `~/.claude/settings.json`)
2. `rm -rf ~/.local/share/claude && rm -f ~/.local/bin/claude` (native install 통째 제거)
3. `npm install -g @anthropic-ai/claude-code@2.1.114`
4. `hash -r && claude --version` → 2.1.114 검증
5. 30s 대기 후 `ls -la ~/.local/bin/claude` 재검증 (No such file 이어야 함)

**환경 자가 검증 (매 cycle 첫 행동 의무):**

매 cycle 진입 시 `claude --version` 검증. 2.1.114 아니면 STOP + Coin 다운그레이드 미적용 보고. Pencil → Compose 본 작업 진행 차단 위험.

**관련 별 trail:**

- `CLAUDE-CODE-VERSION-PIN-2.1.114-001` (open · `anthropics/claude-code#51736` 패치 추적). 패치 release 확인 시 별 cycle 으로 unpin + 외부 검증 + 통합.
- `LAUNCHER-PRE-WARM-PENCIL-001` (open · `~/bin/cc-pen` 런처 정착 후보).

**관련 사고 누적 (`.auto-memory/incident-log.md`):**

- `CLAUDE-CODE-2.1.116-MCP-DISCOVERY-REGRESSION-001` (#51736 회귀)
- `CLAUDE-CODE-NATIVE-AUTO-UPDATER-SYMLINK-RESTORE-001` (auto-updater 무력화)
- `NATIVE-VS-NPM-INSTALL-DUAL-PATH-001` (PATH 충돌)
- `/CLEAR-MCP-RELOAD-MISCONCEPTION-001` (`/clear` ≠ MCP 재attach)

---

### 14) Phase C — Pencil → Compose 파이프라인 5-type 분류

> 본 §14 = `Pencil → Compose 파이프라인` 운영 표준 (cli infra 측 추가).
> 6 화면 외부 검증 (home / meal-recommend / history / condition-input / exercise / onboarding · 2026-04-30) 후 정착.
> SoT IMPL 흐름 = `pencil-uiux-workflow.md` §Phase C 5-type IMPL 흐름 (보호 파일 측 추가). 본 §은 분류·진입·마감 신호만 다룬다.

#### 5-type 분류

| type | 정의 | 정책 위치 (SoT) | 예시 cycle |
|---|---|---|---|
| 1. drift 정정 | SoT 정답 · Compose outdated. SoT → Compose 단방향 sync. | Path 2-A 표준 흐름 (`pencil-uiux-workflow.md` §Path 2-A) | 19c-1~6 본 작업 |
| 2. SoT 갱신 | Compose 정답 · SoT incomplete. Compose → SoT 단방향 sync (별 cycle 정의 필수). | `CYCLE-PHASE-C-EXERCISE-SOT-UPDATE-001` 패턴 | exercise SoT update |
| 3. Phase R | SoT 부분 부재 · Compose + preview.png 로 [CURRENT] 역공학. | `pencil-uiux-workflow.md` §Phase R 한정 역공학 예외 + `pencil-sot-policy.md` §3 | 향후 `.pen` 부재 화면 진입 시 |
| 4. paradigm reconciliation | 의미 충돌 (SoT 와 Compose 가 다른 의미 모델) | (현 시점 부재 · 발생 시 system-architect 별 cycle) | — |
| 5. SoT 내부 reconciliation | `.pen` ↔ `ui-spec.json` 자체 충돌 | `pencil-uiux-workflow.md` §IMPL 인터랙션 패턴 충돌 정책 (`.pen` 우선) | `CYCLE-PHASE-C-CONDITION-INPUT-SOT-RECONCILE-001` · `CYCLE-PHASE-C-ONBOARDING-SOT-INTERNAL-RECONCILE-001` (A.1) |

#### type 별 cycle 흐름 요약

| type | 진입 cycle 형태 | 후속 cycle |
|---|---|---|
| 1 | Path 2-A 13 STEP (BASELINE → cmd+W cleanup → open_document → batch_design → hook save → commit → cmd+W close) | 6 화면 단위 반복. |
| 2 | EVIDENCE-only cycle (Compose 검증 + ui-spec.json append) | drift 정정이 필요하면 type 1 후속. |
| 3 | Phase R-1~4 (역공학 → [CURRENT] → [TARGET] → [LOCKED]) | type 1 후속으로 정착. |
| 4 | system-architect 분리 cycle | 파급 영향 평가 후 PLAN 재작성. |
| 5 | A.1 (SoT 내부 정합 → `.pen` 우선 추가) → A.2 (Compose 재구현) 2-step | A.1 마감 후 별 cycle 로 A.2. |

#### Phase 별 분류 (라이프사이클)

| Phase | 정의 | SoT 입력 | Compose 입력 |
|---|---|---|---|
| A | 신규 화면 Pencil 캔버스 + ui-spec 생성 | 신규 `.pen` + 신규 `ui-spec.json` | (후속 Phase C 1) |
| B-DETAIL | 기존 `.pen` 시각 정밀화 | `.pen` 갱신 | (후속 Phase C 1) |
| C | SoT ↔ Compose 정합 reconcile (5-type) | (분류별 dual-direction) | (분류별) |
| R | `.pen` 부재 화면 역공학 회복 | Compose + preview.png → `.pen` 신규 | 변경 없음 (역공학 단계) |
| **D** (정의 추가 · 2026-04-30 · `CYCLE-PHASE-D-DEFINITION-001`) | **검증 자동화** — Compose Preview ↔ Pencil canvas 자동 비교 (P6 ±2dp · ΔE≤3 자동 검증). Coin 시각 검증 manual 부담 폐기. | 변경 없음 (Phase C 정착 후) | 변경 없음 (Phase C 정착 후) |
| E | 배포 / Track D (GD/GB 도메인 본격 + Compose impl 분리) | (별 phase 정의 cycle) | (Track D 패턴) |
| F (장기) | 추가 화면 SoT-first 신설 (auth/settings/ticketshop/billing 등) | SoT-first 신규 (Phase A 패턴 차용) | TDD-first |

#### Phase D sub-cycle 표 (정의 + 후속 trigger · 별 cycle 추가 의무)

| sub-cycle | 본 작업 | 상태 (2026-05-01 갱신) |
|---|---|---|
| **D-1** | SoT-Compose preview 자동 비교 도구 추가 | **lazy** (별 trail `CYCLE-PHASE-D-PREVIEW-DIFF-TOOL-001`) · 화면 수 12+ 도달 후 trigger (§B-4 break-even) · 6 화면 단계 손 검증 30min/round 명시됨 |
| **D-2** | Compose @Preview 자동 캡처 도구 추가 (D-1 prerequisite) | **마감** (D-2.1 + D-2.2 · 2026-04-30) · **채택**: Roborazzi 1.32.0 + Robolectric 4.13 · 6/6 화면 first capture · `verifyRoborazzi` 자동 fire |
| **D-3** | 회귀 검증 자동화 통합 — Phase C 6 화면 + 신규 화면 자동 시각 검증 매 commit fire | **lazy** (별 trail `CYCLE-PHASE-D-VISUAL-REGRESSION-001`) · D-1 마감 + 화면 수 12+ 도달 후 trigger |

> Phase D-1/D-3 lazy 명시됨 근거 (2026-05-01 Coin 결정 · `CYCLE-PHASE-D-CLOSE-PHASE-F-DEFINE-001`): 6 화면 단계 자동화 build cost (~3-5h Cowork prep + 3 sub-cycle + brew install 정책 마찰) vs 손 검증 30min/round → break-even round = 6-10 round. Phase F 화면 grow 전 ROI 시기상조. 화면 수 12+ 도달 시 자연 trigger.
> Phase D-2 마감만으로 Phase D **부분 마감 신호** 명시됨 (아래 진입/마감 신호 §).
> 보호 파일 측 `pencil-uiux-workflow.md §Phase D 검증 자동화` IMPL 흐름은 D-1/D-3 trigger 시점에 추가 (사후 정정 default).

#### Phase F sub-cycle 패턴 (2026-05-01 신설 · `CYCLE-PHASE-D-CLOSE-PHASE-F-DEFINE-001`)

> Phase F = 추가 화면 lifecycle 컨테이너. 각 sub-cycle = **새 화면 1개의 mini A→B-DETAIL→C→D-2 묶음**.
> 기존 phase 패턴 차용 (Phase A 작성 패턴 · Phase B-DETAIL Path 2-A · Phase C 5-type · D-2 Roborazzi). 신규 패턴 추가 X (사후 정정 default).

| sub-cycle | 본 작업 | 후속 trigger |
|---|---|---|
| **F-N** (N=1,2,...) | 새 화면 1개 lifecycle: 도메인 결정 → Pencil `.pen` 작성 (Phase A) → `ui-spec.json` (Phase B-DETAIL Path 2-A) → 5-type 정합 (Phase C) → `RoborazziTest` + first capture (D-2 패턴) | 다음 화면 → F-(N+1) 또는 화면 수 12+ 도달 → D-1/D-3 trigger |

#### 진입 / 마감 신호

- **Phase C 진입**: 6 화면 SoT (`.pen` + `ui-spec.json`) 과 Compose 사이 drift 또는 paradigm 충돌 감지.
- **Phase C 마감**: 6 화면 5-type 명시됨 + 별 trail close 3건 (SOT-TO-COMPOSE-AUTO-CONVERSION-001 · PHASE-C-COMMIT-VERIFY-ORDER-001 · PHASE-C-PRESENTATION-DOMAIN-BOUNDARY-MAPPING-001).
- **Phase D 진입 신호**: Phase C 통합 cycle (`CYCLE-PHASE-C-INTEGRATION-001` 통합-A/B/C) 마감 + 별 trail close 3건 영구 명시됨. `.auto-memory/cycle-handoff.md` Phase D baseline rolling rewrite 됨 (외부 검증 PASS · 2026-04-30).
- **Phase D 부분 마감 신호** (2026-05-01 갱신 · Coin 결정): D-2 마감 (Roborazzi + Robolectric 채택 + 6/6 first capture + verify 자동 fire) 만으로 Phase D **부분 마감**. D-1/D-3 lazy (별 trail · 화면 수 12+ 도달 후 trigger). `SOT-TO-COMPOSE-VISUAL-VERIFY-MANUAL-001` 은 Coin 손 검증 30min/round 부담 명시됨 (lazy close). Phase F 진입 가능.
- **Phase D 완전 마감 신호** (장래): D-1/D-3 trigger 후 정착 + 매 commit 자동 fire + Coin 시각 검증 manual 부담 0 도달 시.
- **Phase F 진입 신호** (2026-05-01 신설): Phase D 부분 마감 명시됨 + Phase B-DETAIL 마감 6 화면 baseline 명시됨. Phase F-1 부터 진입 (7번째 화면 도메인 결정 + Pencil canvas 작성 → SoT → Compose → Roborazzi snapshot 한 묶음 mini lifecycle).
- **Phase F 마감 신호** (open-ended): Coin 결정 (목표 화면 수 도달) 또는 화면 수 12+ 도달 시 자동으로 Phase D-1/D-3 trigger 활성. Phase F 자체는 영구 컨테이너 (화면 추가 패턴 = 영구).

#### 운영 hard 의무 (Phase C 통합)

- **commit-then-verify 영구 채택**: Pencil → Compose cycle 은 .pen + ui-spec.json + Compose 변경을 **단일 commit** 으로 묶고 commit 직후 verify (역순 금지). 근거: `PHASE-C-COMMIT-VERIFY-ORDER-001`.
- **boundary mapping 단일 위치**: Compose 변경 시 presentation ↔ domain 변환은 **ViewModel 만**. UiState 가 DomainModel 을 직접 import 하면 REVIEW §4 FAIL. 근거: `PHASE-C-PRESENTATION-DOMAIN-BOUNDARY-MAPPING-001`.
- **TODO(user-prep) stub 유지**: 외부 의존 (PreferencesRepository, AlarmManager 등) 미준비 항목은 `TODO(user-prep)` 으로 stub 처리. UI 불변 상태 침해 금지.

#### 관련 별 trail (Phase C 마감 시점 close 후보)

- `SOT-TO-COMPOSE-AUTO-CONVERSION-001` — Phase C 본 작업 (6/6 + 5-type 정착 · type 4 부재 acceptable).
- `PHASE-C-COMMIT-VERIFY-ORDER-001` — commit-then-verify 영구 채택.
- `PHASE-C-PRESENTATION-DOMAIN-BOUNDARY-MAPPING-001` — boundary mapping 패턴 영구 채택.

### 14a) Cowork prep ↔ CLI baseline 동기화 패턴 (2026-05-01 신설 · `CYCLE-WORKFLOW-V12-REVISION-001`)

> 본 § = `COWORK-PREP-BASELINE-MISMATCH-001~004` 별 trail 의 4회차 재발 패턴 영구 정착 mitigation.

**근거**: cycle 진입 시 Cowork 측 sandbox memory 만 참조 + CLI repo 의 실측 baseline 미참조 → prep file anchor mismatch + entry 중복 + sha placeholder 불일치 + 마감 신호 정정 누락 + **기획 문서 미참조 (cycle 4/6) + 별 repo infra cycle 미참조 (cycle 5/6 전후)** 등 7회 사고 패턴.

**동족 사고 누적**:
- COWORK-PREP-BASELINE-MISMATCH-001 (cycle 2 prep file 04 anchor mismatch)
- COWORK-PREP-BASELINE-MISMATCH-002 (mcp save_as 영구 한계 미참조)
- COWORK-PREP-BASELINE-MISMATCH-003 (cycle 3 lazy close 마감 미참조)
- COWORK-PREP-BASELINE-MISMATCH-004 (pencil-uiux-workflow.md sha 변경 추적 누락)
- **COWORK-PREP-BASELINE-MISMATCH-005 (cycle 4/6 진입 시 docs/plan + docs/design/screen-flow.md 미참조 → meal-detail/meal-reaction 추정)**
- **COWORK-PREP-BASELINE-MISMATCH-006 (기획안의 ticket/billing 명시 미참조 → "기획 외 의문" 임의 추정)**
- **COWORK-PREP-BASELINE-MISMATCH-007 (cycle 5/6 전후 GT/GD/GB 의 별 infra cycle 미참조 — feat(infra) settings.json + hook patterns 추가한 cycle 추적 누락)**

**Cowork prep 추가할 의무 절차** (통합 prompt 작성 전 6건):

1. **GT git log 실측**: `git log --oneline -5 /Users/yundonghyeon/AndroidStudioProjects/GentlyTable` — 가장 최근 5 commit 확인 (직전 cycle 마감 + 별 cycle 추적).
2. **decision-log tail 실측**: `tail -50 /Users/yundonghyeon/AndroidStudioProjects/GentlyTable/.auto-memory/decision-log.md` — 직전 entry 명시됨 검증 (entry 중복 회피).
3. **보호 파일 sha 실측**: 4종 sha 변동 추적 (`shasum -a 256 docs/schemas/ui-spec.schema.json .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md .claude/rules/uiux-sot-refresh.md`) — sandbox memory baseline 과 비교.
4. **사용자 메시지 분류**: PASS 신호 ("OK" / "pass" / "권장사항대로 진행") vs 피드백 메시지 (정책 수정 / 결정 의뢰) 사전 분류 — PASS 신호 인지 미스 회피.
5. **기획 문서 실측 (신규 · 005/006 mitigation)**: 새 화면 도메인 결정 / 기능 추가 / 디렉터리 정합 검증 시 의무. `cat /Users/yundonghyeon/AndroidStudioProjects/GentlyTable/docs/plan/기획안_보강.md` + `cat /Users/yundonghyeon/AndroidStudioProjects/GentlyTable/docs/design/screen-flow.md` 참조 후 추정 금지. 도메인 외 의문 발견 시 **기획안 grep 의무** (예: "ticket" / "billing" / "결제" / "구독" 등).
6. **3-repo git log 실측 (신규 · 007 mitigation)**: 본 chat 외 추가된 별 cycle 추적 의무. `for r in GentlyTable GentlyDay GentlyBreath; do git log --oneline -5 /Users/yundonghyeon/AndroidStudioProjects/$r; done` — 본 chat 추가한 cycle 외 별 작업 진행 patterns 검증.

**적용 시점**: 본 chat 진입 시 §20 4 항목 추출 + 매 통합 prompt 작성 전 + Coin 본심 검증 시점 + 새 화면/도메인 결정 시.

**별 trail 신규 (closed at CYCLE-CYCLE8-BASELINE-MISMATCH-MITIGATION-001 · 2026-05-01)**:
- COWORK-PREP-BASELINE-MISMATCH-001~007 — 본 § 의 6 의무 절차 명시된 patterns 영구 정착 mitigation. 본 cycle 마감 시 일괄 close.
- 향후 8회차 재발 시 mitigation 강화 cycle 진입 (Cowork 측 baseline 자동 검증 hook 도입 검토).

---

### 15) cli 수정 패턴 3 종 (Q2 가이드 · C3 명시됨)

자식 repo 구현 중 cli infra 수정 필요 시 패턴 분류:

#### 패턴 1: 공통 cli 변경 (도메인 무관 정책)

**예**: `workflow-core.md` 의 `/verify` 단계 규칙 추가 / `settings.json` deny list 추가 / 신규 agent 추가.

```
[자식 repo] 사고 또는 개선 필요 발견
    ↓ STOP (자식 repo 에서 cli 직접 수정 금지 — master CLAUDE.md §3 §4)
    ↓
[switch] master 에서 새 cycle 진입 (예: C5-WORKFLOW-VERIFY-ENHANCE-001)
    ↓
[변경] master 에서 rule/hook/agent 수정 + commit
    ↓
[propagate] /cycle-report propagate <file> --targets all
    ↓
[verify] 자동 — script 가 verify-sync 실행 + propagation-status.md 갱신
    ↓
[자식 repo] cycle 마감 + 영향 검증 (build / test PASS)
```

#### 패턴 2: 자식 repo local-only 변경

**예**: `.claude/settings.local.json` (개인 환경 override) / `.ai/tasks/` / `.ai/reports/` / 자식 repo 의 `app/` 코드.

→ master 무관. 자식 repo 안에서 자유 변경. propagation 안 함.

#### 패턴 3: 도메인 활성화 (UNKNOWN → ACTIVE)

**예**: 자식 repo 에서 Auth 기능 시작 (Supabase Auth 도입).

```
[자식 repo] Auth 도메인 시작 결정
    ↓ STOP (auth-security-privacy agent 자동 발화 — deferred-domains.md §5 trigger 키워드)
    ↓
[switch] master 에서 새 cycle 진입
    ↓
[신설] master 에 .claude/rules/auth-rules.md 신설
[mv]   bash scripts/activate-agent.sh activate auth-security-privacy
[갱신] deferred-domains.md 표 (UNKNOWN → ACTIVE) + routing-and-delegation.md ([DEFERRED] 라벨 제거)
    ↓
[propagate] /cycle-report propagate --all
    ↓
[자식 repo] Auth 기능 구현 cycle 진입
```

### 16) cli 수정 우선순위 결정 트리

```
cli infra 수정 필요?
├── YES: 어디서?
│   ├── 자식 repo 안에서 사고 발견 → 패턴 1 (master switch + cycle)
│   ├── 자식 repo 의 local override 만 → 패턴 2 (자식 repo 자유)
│   └── 도메인 활성화 trigger → 패턴 3 (master 신설 + activate-agent.sh)
└── NO: 자식 repo 의 본 작업 cycle 진행
```
