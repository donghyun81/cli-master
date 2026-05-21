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

보호 파일 5종에만 한정:
- `docs/schemas/ui-spec.schema.json`
- `.claude/rules/pencil-uiux-workflow.md`
- `docs/design/pencil-sot-policy.md`
- `.claude/rules/uiux-sot-refresh.md`
- `docs/design/design-sot-policy.md`

다른 룰 파일은 repo-specific 가능. 단 워크플로우 표준 (본 §섹션 포함) 을 3-repo 모두에 적용하려면 task 별로 propagation 명시.

**cli infra 권장 byte-identical 영역**: `.claude/` 전체 (settings.json + rules + agents + hooks + skills + commands) + `scripts/` 측 propagation 도구 (propagate.sh + verify-sync.sh + ensure-child-gitignore-patches.sh 등) + `docs/agent/architecture/*` 등 = cli infra 권장 byte-identical 영역 (CLAUDE.md §2 "53 + α" 영역 정합). drift 발생 시 lazy mitigation default (= 다음 cycle 영향 시점 회복 의무).

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

**우선순위 정합**: `.claude/rules/safety-and-secrets.md §절대 금지 명령` 표 안 `git commit` 영역 = 본 §5 v2 (한시 허가) 우선 · `safety-and-secrets.md` 표 = 응급 백스탑 default 영역. 본 §5 v2 자동 허용 카테고리 영역 + app/src/ 변경 + 빌드 PASS + Coin 명시 승인 영역 측 agent commit 허용 정합.

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

보호 파일 5종 sha 가 바뀌는 commit:
- body `[Sha]` 섹션에 새 sha 8자 prefix 필수 명시
- 3-repo cross-verify 결과를 `[EC]` 섹션에 명시
- commit 후 memory baseline sha 갱신 (`.auto-memory/protected-file-hashes.md`)

### 11) 보고서 lightweight 옵션

cleanup / docs / propagation / discipline 류 task 는 4 파일로 충분:
PLAN.md / VERIFY.md / REVIEW.md / TODO.md

`MODE.md` / `EVIDENCE.md` / `COMPOUND.md` 는 audit / evidence-heavy task 한정.


### 13) Claude Code 환경 정합 (Pencil MCP 본 작업 운영 baseline)

> 본 §13 = `Pencil → Compose 파이프라인` 의 agent 환경 가용성 보장 정책.
> 19c-1~6 사이 외부 검증된 환경 회귀 / mitigation 의 영구 정착.

**Claude Code version 정책 = 최신 추격 (pin 폐기 · CLI-VERSION-UNPIN-PROPAGATION-001 갱신):**

- 특정 버전 pin 박지 X (이전 2.1.114 pin 폐기 · `CLAUDE-CODE-VERSION-UNPIN-VERIFY-001` 안 #51736 회귀 해소 실측 PASS 후 정책 전환).
- npm scope 의무 (`@anthropic-ai/claude-code` · native installer auto-updater path 회피).
- 의도 X 백그라운드 jump 차단 default = `DISABLE_AUTOUPDATER` + `DISABLE_UPDATES` 이중 차단 유지 (해제 금지).
- 능동 갱신 = 사용자 직접 `npm install -g @anthropic-ai/claude-code@latest` 실행. default 주 1회 권장 (timing 사용자 자율).

**Native installer auto-updater 차단 (이중 설정 의무 · 본 정책 default):**

- `~/.zshrc`:
  ```
  export DISABLE_AUTOUPDATER=1
  export DISABLE_UPDATES=1
  ```
- `~/.claude/settings.json` 의 `env`:
  ```json
  { "env": { "DISABLE_AUTOUPDATER": "1", "DISABLE_UPDATES": "1" } }
  ```

근거: native installer 의 background auto-updater 가 `~/.local/bin/claude` 심링크를 강제 재생성 (`anthropics/claude-code#41602`, `#3010`, `#28625`). 이중 차단 미설정 시 사용자 능동 jump 정책 무력 (의도 X 자동 jump 사고 · 다운그레이드 무력화 영역 포함).

**매 cycle 진입 self-test 3 항목 (모두 PASS 의무):**

매 cycle 첫 행동:

1. `claude --version` raw output 캡처 — EVIDENCE.md 안 그대로 박음.
2. `claude mcp list` 안 `pencil ✓ Connected` 명시 — 출력 안 verbatim 박음.
3. CLI 세션 안 `ToolSearch query="pencil"` 결과 ≥ 13 tools (`mcp__pencil__*` prefix · `CLAUDE-CODE-VERSION-UNPIN-VERIFY-001` baseline 명단: batch_design / batch_get / export_nodes / find_empty_space_on_canvas / get_editor_state / get_guidelines / get_screenshot / get_variables / open_document / replace_all_matching_properties / search_all_unique_properties / set_variables / snapshot_layout).

3 항목 모두 PASS = cycle 진행 가능. 1+ FAIL = 즉시 STOP + 아래 복귀 절차.

**self-test FAIL 시 복귀 절차 — 직전 known-working 버전 복귀 (동적 영역 · 본 §13 안 버전 hardcode X):**

현 시점 known-working 버전 = `.auto-memory/incident-log.md` 안 `CLAUDE-CODE-LATEST-CHASE-001` trail 의 **마지막 PASS entry** 영역 reference. 본 §13 본문 측 버전 명시 X · lazy default · grep 영역 단일 진실.

```bash
# 1. 마지막 PASS 버전 grep
grep -A2 "CLAUDE-CODE-LATEST-CHASE-001" .auto-memory/incident-log.md | grep -i "PASS"

# 2. 복귀 실행
rm -rf ~/.local/share/claude && rm -f ~/.local/bin/claude
npm install -g @anthropic-ai/claude-code@<known-working-from-grep>
hash -r && claude --version
```

복귀 후 의무:

- `.auto-memory/incident-log.md` 안 `CLAUDE-CODE-LATEST-CHASE-001` trail 안 entry append (회귀 버전 / 증상 / 복귀 시각 KST / 외부 issue link 4 항목 의무 · 회귀 case) 또는 PASS entry append (자연 PASS case · 버전 / self-test 결과 / 직전 PASS reference 영역).
- 본 §13 본문 측 known-working 버전 갱신 의무 **폐기** (= lazy default · 매 갱신 의무 X · 별 trail 영역 단일 갱신 default).

**참고 (외부 검증 영역 · `CLAUDE-CODE-VERSION-UNPIN-VERIFY-001`):**

- 직전 #51736 회귀 = changelog 안 v2.1.122 fix 직접 인용: "ToolSearch missing post-startup MCP tools in nonblocking mode".
- 2.1.121 환경 안 회귀 해소 실측 PASS (`CLAUDE-CODE-VERSION-UNPIN-VERIFY-001` 안 4 항목 검증 · ToolSearch ≥ 13 + mcp__pencil__get_editor_state 실호출 + active editor `daily-prescription.pen` 확인).

**관련 별 trail:**

- `CLAUDE-CODE-VERSION-PIN-2.1.114-001` (close · `CLI-VERSION-UNPIN-PROPAGATION-001` 마감 영역 · pin 폐기 정책 채택 + #51736 회귀 해소 실측 + 4-repo propagation 마감).
- `CLAUDE-CODE-LATEST-CHASE-001` (open · 회귀 누적 영역 · 새 회귀 발견 시 entry append + known-working 갱신 + 별 cycle 진입).
- `LAUNCHER-PRE-WARM-PENCIL-001` (open · `~/bin/cc-pen` 런처 정착 후보).

**관련 사고 누적 (`.auto-memory/incident-log.md`):**

- `CLAUDE-CODE-2.1.116-MCP-DISCOVERY-REGRESSION-001` (#51736 회귀 · v2.1.122 fix 마감)
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
3. **보호 파일 sha 실측**: 5종 sha 변동 추적 (`git hash-object docs/schemas/ui-spec.schema.json .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md .claude/rules/uiux-sot-refresh.md docs/design/design-sot-policy.md`) — sandbox memory baseline 과 비교.
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

---

### 17) BASELINE 실측 표준 (filename + content 동시 grep 의무)

> 본 § = filename-only baseline 사고 영구 정착 mitigation.
> 사고 패턴: agent 가 `find -name "Routes*.kt"` 만 실행 → file 이름 부재 인용 → 실제 = `GentlyDayNavGraph.kt` 안에 `object Routes` 존재. STOP 부적절 (실측 X).

**의무 절차** (BASELINE 실측 시):

1. **filename find 1차** — `find <path> -name "<pattern>" -type f`
2. **container 내부 content grep 2차 (의무)** — filename 부재 시점에서 즉시 STOP/UNKNOWN 분류 금지. container 내부 동일 의미의 symbol/object/function grep 의무.
   - Kotlin: `grep -rn "object <Name>\|class <Name>\|fun <Name>" --include="*.kt" <path>`
   - Java: `grep -rn "class <Name>\|interface <Name>" --include="*.java" <path>`
   - 일반: filename 으로 찾던 의미를 content keyword 로 변환 후 grep
3. **lifecycle/deprecated 키워드 grep (의무)** — ui-spec.json / SoT 파일 BASELINE 실측 시 의무. `grep -E "lifecycle|deprecated|replaced-by"` (§14a 6 절차와 정합).
4. **filename + content 둘 다 부재 시점에만 STOP/UNKNOWN 분류** 가능.

**근거 사고**:
- `BASELINE-FILENAME-ONLY-FALSE-NEGATIVE-001` — Routes.kt 부재 잘못 주장 · 실제 `GentlyDayNavGraph.kt` 안 `object Routes` 존재.
- `COWORK-PREP-BASELINE-MISMATCH-005~006` — lifecycle/deprecated 키워드 미점검 (Cowork → CLI handoff 사고).

**적용 대상**: `.claude/agents/active/intake-router.md` "Evidence to gather" 섹션 + §14a Cowork prep 6 절차 + 모든 BASELINE 실측 cycle.

---

### 18) cli infra 분기 정기 review cadence (2026-05-17 신설 · `MASTER-CLI-INFRA-SELFIMPROVING-REVIEW-CADENCE-001`)

> 본 § = Anthropic blog "How Claude Code works in large codebases" (2026-05-14) 권고 (B-1) 흡수. 종전 cli infra review = incident-driven 한정 (= 사고 발생 시 mitigation cycle). 본 § 정착 후 = 분기 별 정기 점검 cadence 추가.

**trigger 시점**: 매 quarter 첫 월요일 (1/6, 4/6, 7/6, 10/6 부근 첫 월요일 KST). 본 timing = anchor 단일 sot · 사용자 자율 직접 진입.

**scope 한정** (= 본 §의 review cycle 영역 한정 · 제품 코드 무접촉):

| 점검 대상 | grep / 측정 |
|---|---|
| `.claude/rules/*.md` outdated rule 발견 | 모델 진화 (Sonnet/Opus major 갱신) 이후 어휘 / 패러다임 / 권고 영역 정합 검토 |
| `.claude/hooks/*.sh` self-test PASS 여부 | 각 hook 단독 실행 → silent-success 또는 의도된 fixture 발화 |
| `.claude/settings.json` deny list + hook 등록 영역 정합 | 새 hook 누락 / deprecated hook 잔존 검토 |
| `.auto-memory/protected-file-hashes.md` baseline | 5 보호 file sha 정합 |
| 직전 분기 incident-log entry 누적 추세 | 동일 패러다임 사고 3+ 누적 = 신 rule 신설 후보 |

**cycle 산출**: lightweight 4 file (§11 정합) — PLAN.md / VERIFY.md / REVIEW.md / TODO.md. 보고서 측 `[Diff]` 영역 0 인 경우 = "cli infra 영역 분기 무사고 PASS" 1 줄 명시.

**자동 발화 X**: 본 § = 정책 명시 영역 only · 자동 trigger hook 신설 X (= scope 폭발 회피 · §15 패턴 1 정합). 사용자 인지 영역 단일.

**관련 별 trail**: `MASTER-CLI-INFRA-QUARTERLY-REVIEW-NNN` (N = 분기 진입 시점 부여 · TaskId 자율).

---

### 19) Hooks self-improving loop (2026-05-17 신설 · `MASTER-CLI-INFRA-SELFIMPROVING-REVIEW-CADENCE-001`)

> 본 § = Anthropic blog (2026-05-14) 권고 (B-3) 흡수. 기존 hook 영역 = quality gate (stop-gate.sh) + degeneration (post-edit-degeneration-check.sh) + libs cross-verify 영역 중심. 추가 영역 = 활성 cycle 측 paradigm 누적 자동 추출 후 cli infra 정착 후보 silent 제안.

**역할**: `.claude/hooks/stop-reflect.sh` (= Stop hook · stop-gate.sh 와 분리 · SRP 정합). 매 cycle 마감 시점 `.ai/reports/<taskId>/REVIEW.md` 또는 `EVIDENCE.md` 안 paradigm 누적 패턴 grep + silent 후보 출력.

**감지 패턴** (= grep 정규식 · false positive 회피 한정 cluster):

| 패턴 | 한국어 + 영어 |
|---|---|
| 신 paradigm | `(신\|새\|emerging\|new) (paradigm\|패러다임)` |
| 정합 paradigm | `(정합\|consistent\|recurring) (paradigm\|패러다임)` |
| 누적 paradigm | `(누적\|반복\|accumulated) (paradigm\|패러다임)` |

**임계**: 한 file 안 3+ 회 등장 시점만 trigger (= M2-like 임계 · `text-degeneration-prevention.md` §3 정합).

**출력 정책**: silent-success default · 발화 시점만 stderr 1~3 줄 후보 명시. exit 0 의무 (non-blocking · 기존 stop-gate.sh 영역 breakage X).

**self-test**: `bash .claude/hooks/stop-reflect.sh` (positional arg fallback) 또는 `bash .claude/hooks/stop-reflect.sh <path>`.

**mode**: env `REFLECT_ENFORCE=warn` (default) · `REFLECT_ENFORCE=silent` (= 출력 0 · debug 영역).

**관련 cycle**: 본 §의 첫 정착 = `MASTER-CLI-INFRA-SELFIMPROVING-REVIEW-CADENCE-001`. paradigm 추출 결과 = 사용자 자율 채택 (= 자동 file 신설 X · `CLAUDE.md` 또는 `.auto-memory` 갱신 후보 silent 제안 영역 단일).

---

### 20) DocSync 단계 본문 (= 자식 repo 출시 docs 영역 명시 · 2026-05-19 신설 · `MASTER-CLI-DOCS-AUTOSYNC-PARADIGM-001`)

> 본 § = `workflow-core.md` §단계 흐름 안 DocSync 단계 본문 정합 + 매 cycle 마감 step 안 docs 갱신 의무 영역 단일 SoT. paste source baseline = H24 finding (= 3-repo 측 `LAUNCH-STATUS.md` + `docs/CLAUDE.md` + `docs/setup/*` 영역 7~8 일 stale 누적 default · 사용자 manual 갱신 영역 default).

#### 20.1 갱신 대상 영역

cycle 마감 시 DocSync 단계 안 대상 본문:

| 영역 | 본질 | 위치 |
|---|---|---|
| task 산출물 | 본 cycle 진행 EVIDENCE / PLAN / VERIFY / REVIEW (= 기존 영역) | `.ai/reports/<taskId>/*.md` |
| 운영 레이어 | 아키텍처 / 프로세스 / 솔루션 (= 기존 영역) | `docs/agent/**` |
| 자식 출시 docs (= 본 cycle 추가) | next release task 표 + 자식 헌법 + setup 가이드 | `docs/release-readiness/LAUNCH-STATUS.md` + `docs/CLAUDE.md` 또는 자식 root `CLAUDE.md` + `docs/setup/*` |

#### 20.2 갱신 의무

- 본 cycle 변경 영향 영역 발견 시 = 해당 자식 출시 docs 항목 갱신 의무
- 본 cycle 변경 영향 X = 0 갱신 default (= 강제 X · 빈 변경 commit 금지)
- 진입 paradigm = `docs-change-communicator` agent 호출 (= Key questions 본문 안 자식 출시 docs 영역 명시 · 본 cycle 안 추가)
- 사용자 manual 갱신 영역 폐기 (= 본 paradigm 정착 후 default · 자동 / 반자동 진입 우선)

#### 20.3 정합 의무

- `workflow-core.md` §단계 흐름 DocSync bullet = 본 § 본문 인용
- `docs-change-communicator.md` Key questions = 자식 출시 docs 영역 questions 6~8 포함
- 본 § 본문 변경 시 master cycle 신설 + 5-repo propagation (= §15 패턴 1 정합)

#### 20.4 명시 cycle 이력

- 2026-05-19 · `MASTER-CLI-DOCS-AUTOSYNC-PARADIGM-001` · 본 § 신설 + `workflow-core.md` §단계 흐름 DocSync bullet 본문 보강 + `docs-change-communicator.md` Key questions 6~8 append + 5-repo byte-identical propagation

---

### 21) Cross-repo cycle 영역 (= 5-repo · 2026-05-19 신설 · `MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001`)

> 본 § = master cycle 측 cross-repo (= 5-repo · master + app-foundation + GB + GD + GT) 영역 운영 paradigm + cli infra 5-repo byte-identical 영역 정합 + cross-repo sub-agent (= cross-repo-orchestrator) 측 routing 영역 단일 SoT. paste source baseline = `MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001` H27-β cowork chat 사용자 본심 정합 (= "양쪽 모두 가능한데 요청사항에 따라서 claude code cli 가 판단해서 일을 처리").

#### 21.1 cross-repo cycle 영역 본질

cross-repo cycle = 5-repo (= master + app-foundation + GB + GD + GT) 측 동시 영향 영역 default. 본 영역 cycle 진입 시점 paradigm 2 영역 (= 본 §15 패턴 1 cli infra 측 단방향 propagation + 본 § 영역 1 sub-agent 병렬 paradigm) 정합 default.

| 영역 | 본질 | 본 §15 패턴 정합 |
|---|---|---|
| cli infra 5-repo byte-identical 영역 | `.claude/` (rules + agents + hooks + skills + commands + settings) + `docs/schemas/` + 보호 5 file + `scripts/` 측 propagation 도구 | §15 패턴 1 (= master cycle 신설 + propagation) |
| 자식 도메인 specific 영역 | 자식별 도메인 source (= app/ + composeApp/ + core/ + domain/) | §15 패턴 2 (= 자식 local · 본 § 영역 X) |
| cross-repo 정합 검증 영역 | 동족 자식 측 sha 정합 + 보호 file sha cross-verify + paradigm 정합 측정 | §15 패턴 1 + 본 § 영역 1 sub-agent fan-out |

#### 21.2 cross-repo paradigm 분기 (= `cross-repo-parallel-exec.md` 정합)

본 § 측 cross-repo paradigm 분기 단일 SoT = `.claude/rules/cross-repo-parallel-exec.md`. 본 §은 cycle 운영 측 paradigm pointer 본질 default.

| paradigm | 진입 조건 | 호출 방식 |
|---|---|---|
| **영역 1** (= 단일 cli session 측 sub-agent 병렬) | 가벼운 cross-repo 정합 영역 + 동족 자식 측 동일 paradigm 신설 + cli infra propagation cycle | `cross-repo-orchestrator` sub-agent 호출 + 자식별 Task tool fan-out + return 통합 |
| **영역 2** (= 다중 cli session 운영) | 단일 자식 측 무거운 IMPL + 다른 자식 무접촉 | 사용자 본인 측 terminal × cli session ×N · cross-repo 정합 책임 = 사용자 영역 |

paradigm 선택 본심 = cli session 측 자율 판단 default.

#### 21.3 cross-repo cycle 운영 표준

cli infra 5-repo byte-identical 영역 cycle 진입 시점 표준:

1. **master 측 변경 + commit** (= cli infra 또는 보호 file 영역 default · `cycle-discipline.md` §5 v2 자동 허용 카테고리 정합)
2. **propagation 단방향** (= `bash scripts/propagate.sh <relative-path> [--targets FND,GB,GD,GT|all]`)
3. **자식별 staged commit** (= 각 자식 repo 측 `chore(cli-infra): propagation <cycle-id>` body 정합 · master commit body 인용)
4. **cross-verify** (= `bash scripts/verify-sync.sh` exit 0 default · sha 정합 표 산출)
5. **propagation report 생성** (= `propagation-reports/<cycle-id>/REPORT.md` 자동 생성)
6. **audit commit** (= master 측 `.auto-memory/propagation-status.md` + `.auto-memory/incident-log.md` 갱신 + commit)
7. **master CLAUDE.md §15 entry append** (= 본 cycle entry 1 row 추가 의무)

#### 21.4 cross-repo 영역 STOP 조건

| trigger | mitigation |
|---|---|
| 보호 5 file sha drift 발견 (= 자식별 sub-agent 측정 결과 또는 verify-sync 측 mismatch) | 즉시 STOP + 사용자 회수 default (= `cycle-discipline.md` §10 + master CLAUDE.md §5 정합) |
| 자식별 sub-agent 결과 본질 어긋남 (= 동족 자식 측 paradigm 정합 측 mismatch) | STOP + 사용자 회수 default |
| cross-repo 영역 측 HIGH RISK 도메인 진입 (= DB migration / Money / Auth / production push 영향) | 즉시 STOP default |
| 자식 repo 측 cli infra 직접 수정 시도 (= 단방향 정합 위반) | 즉시 STOP + master 측 정합 cycle 진입 의뢰 |
| production code touch 징후 (= cli infra cycle 측 0 LOC touch 의무 default) | 즉시 STOP |

#### 21.5 cross-repo cycle 측 산출물 영역

| 산출물 | 위치 | 본질 |
|---|---|---|
| PLAN.md | `claude-cli-master/.ai/reports/<cycle-id>/PLAN.md` | ChangeBudget + cross-repo 영역 명시 + §FREEDOM 영역 결정 default |
| EVIDENCE.md | `claude-cli-master/.ai/reports/<cycle-id>/EVIDENCE.md` | baseline 실측 (= 5-repo HEAD sha + 보호 file sha) + dirty 영역 + 자식별 sub-agent return body 인용 default |
| VERIFY.md | `claude-cli-master/.ai/reports/<cycle-id>/VERIFY.md` | propagation cycle PASS + sha 정합 + production code touch 0 LOC verify |
| REVIEW.md | `claude-cli-master/.ai/reports/<cycle-id>/REVIEW.md` | 12-section 또는 lightweight 4 section (= cli infra 영역 default · `cycle-discipline.md` §11 정합) + PromptFit |
| TODO.md | `claude-cli-master/.ai/reports/<cycle-id>/TODO.md` | 후속 작업 + scope 외 dirty 영역 baseline 명시 default |

#### 21.6 정합 의무

- `.claude/rules/cross-repo-parallel-exec.md` 측 paradigm 분기 본문 단일 SoT 정합
- `.claude/agents/active/cross-repo-orchestrator.md` 측 sub-agent routing 정합
- `.claude/rules/routing-and-delegation.md` §실행 방식 규칙 Cross-repo sub-section 정합
- 부모 mount root `CLAUDE.md` (= `/Users/yundonghyeon/AndroidStudioProjects/CLAUDE.md`) §3 cli session 진입 paradigm 분기 정합
- 본 § 본문 변경 시 master cycle 신설 + 5-repo propagation (= §15 패턴 1 정합)

#### 21.7 명시 cycle 이력

- 2026-05-19 · `MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001` · 본 § 신설 + `cross-repo-parallel-exec.md` 신설 + `cross-repo-orchestrator.md` sub-agent 신설 (§FREEDOM) + 부모 mount root CLAUDE.md 신설 + `routing-and-delegation.md` Cross-repo sub-section append + 5-repo byte-identical propagation

---

### 22) git mv + sed 측 stage 정합 (= 2026-05-21 신설 · `MASTER-CLI-GIT-MV-SED-STAGE-PARADIGM-CHECK-001`)

> 본 § = rename + content 변경 동시 cycle 측 stage 누락 사고 mitigation 단일 SoT. GB+GD 동족 사고 baseline (= directory 측 file rename 후 sed content 정정 영역 측 stage 분리 사고 default · GT 측 자율 회피 default). post-rename `git add -u` 의무 paradigm + `pre-commit-stage-check.sh` hook 정합 본문 단일 default.

#### 22.1 사고 본질

`git mv` 측 directory 측 file rename 호출 시점:

- git 자체 측 rename detection 자동 PASS default (= `R` prefix 측 staged 영역 표시)
- 단 후속 sed 측 content 정정 영역 (= rename 측 file 본문 측 path string 또는 인용 경로 정합 영역) = working tree 측 변경 default · stage 영역 미반영 default
- 결과 = commit 측 rename + 일부 content 정합 영역 단일 staged · 나머지 content 정정 영역 unstaged default · review 측 누락 발견 사고 default

본 사고 GB+GD 측 동족 발화 (= 2 자식 측 동일 paradigm cycle 진입 시점 cluster 발화 default). GT 측 본 패턴 회피 default (= 사용자 본인 측 manual mitigation default).

#### 22.2 mitigation paradigm

| step | 본질 |
|---|---|
| 1 | `git mv <old> <new>` 호출 (= rename detection 자동) |
| 2 | sed 또는 Edit tool 측 content 정정 (= rename 측 file 본문 + 인용 file 측 path 정합) |
| 3 | **`git add -u` 의무** (= post-rename + post-sed 측 일괄 stage default · unstaged content 영역 0 보장) |
| 4 | `git diff --cached --name-only` 측 list 측정 (= stage 영역 측 전체 file 확인 default) |
| 5 | `git status` 측 working tree 측 unstaged 영역 0 확인 default |
| 6 | commit 진입 (= `cycle-discipline.md` §5 v2 정합) |

본 paradigm 측 step 3 (`git add -u`) 누락 = 사고 발화 baseline default. 본 § 측 의무 영역 default.

#### 22.3 pre-commit hook 정합

`.claude/hooks/pre-commit-stage-check.sh` (= 2026-05-21 신설 default) PreToolUse Bash matcher 측 등록 default. 본 hook 본질:

- trigger = `git commit` substring 측 Bash command 측정 (= hook 자체 측 filter default)
- detection = `git diff --cached` 측 rename (= `R` prefix) 영역 발견 시점 + 동족 file 측 working tree 측 unstaged 영역 측정 default
- 발화 시점 = unstaged content 영역 발견 시점 stderr 측 warn 출력 default (= post-rename `git add -u` 의무 paradigm 안내 default)
- mode = warn default (= exit 0 · non-blocking default · `enforce` mode 별 cycle default)

상세 본문 = `pre-commit-stage-check.sh` 측 self-test paradigm 정합 default.

#### 22.4 STOP 조건

| trigger | mitigation |
|---|---|
| `git mv` 호출 후 `git add -u` 미호출 + 동족 sed 측 content 정정 영역 발견 | hook warn 발화 default · 사용자 측 step 3 진입 의뢰 |
| `git diff --cached` 측 rename + working tree 측 unstaged 영역 잔존 발견 | 즉시 STOP + step 3 mitigation 진입 default |
| rename 측 path 정합 영역 측 다른 file 측 인용 경로 변경 미발견 (= `grep -rn <old-path>`) | 별 cycle 진입 권장 default (= 본 cycle scope 외 영역 default) |

#### 22.5 안내 paradigm (= safety-and-secrets.md 측 pointer 정합)

본 § = `safety-and-secrets.md` 측 신 § "git mv + sed paradigm pointer" 측 단일 SoT default. safety-and-secrets.md 측 본문 = 본 §22 인용 default · 보호 영역 본질 X default.

#### 22.6 명시 cycle 이력

- 2026-05-21 · `MASTER-CLI-GIT-MV-SED-STAGE-PARADIGM-CHECK-001` · 본 § 신설 + `safety-and-secrets.md` pointer § 신설 + `.claude/hooks/pre-commit-stage-check.sh` 신설 + `.claude/settings.json` PreToolUse Bash matcher 신 hook 등록 + 5-repo byte-identical propagation

---

### 23) Recommended option disk verification paradigm (= 2026-05-21 신설 · `MASTER-CLI-RECOMMENDED-OPTION-DISK-VERIFICATION-PARADIGM-001`)

> 본 § = 후속 cycle 후보 / Recommended option / paste source umbrella 발행 시점 disk 측 이미 구현 여부 측정 의무 paradigm 명시 영역 default. 본문 단일 SoT = [`recommended-option-disk-verification.md`](./recommended-option-disk-verification.md) (= 4 의무 영역 + paste source authoring ⑤ 자기 정합 paradigm + 예시 case 3 + 위반 mitigation cycle default).

#### 23.1 cycle scope 결정 영역 측 적용

cycle scope file 영역 결정 시점 (= master cycle 또는 자식 cycle 측) 본 paradigm 정합 의무 default:

- cycle scope file × N 측 측정 명령 호출 default (= `find` + `grep` + `git hash-object` + `git ls-files`)
- 측정 결과 = 중복 신설 차단 default + 갱신 vs 신설 결정 default + 부분 구현 영역 측 scope 재 정의 default
- 측정 결과 인용 default (= paste source 본문 §0 baseline 영역 + §3 contract SoT 영역 default)

#### 23.2 §17 BASELINE 실측 표준 정합

본 paradigm 측 의무 ① (= disk 측 이미 구현 여부 측정 의무) 측 측정 명령 영역 정합 default = §17 BASELINE 실측 표준 의무 절차 (= filename + content 동시 grep 의무) 본문 정합 default.

- filename find 1차 + container 내부 content grep 2차 의무 default (= §17 정합 default)
- lifecycle / deprecated 키워드 grep 의무 default (= §17 §14a 6 절차 정합 default)
- filename + content 둘 다 부재 시점만 STOP / UNKNOWN 분류 가능 default

본 §23 + §17 = 본 paradigm 측 측정 영역 본문 단일 default.

#### 23.3 위반 시 mitigation

본 paradigm 측 위반 mitigation 본문 단일 SoT = `recommended-option-disk-verification.md` §5 위반 시 mitigation cycle paradigm 정합 default.

#### 23.4 명시 cycle 이력

- 2026-05-21 · `MASTER-CLI-RECOMMENDED-OPTION-DISK-VERIFICATION-PARADIGM-001` · 본 § 신설 + `recommended-option-disk-verification.md` 신 rule 신설 + 5-repo byte-identical propagation
