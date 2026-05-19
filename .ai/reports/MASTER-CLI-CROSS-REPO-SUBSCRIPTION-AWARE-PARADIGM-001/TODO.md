# TODO — MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001

## Deferred items (= 별 cycle 분리 default)

### 1. 2026-06-15 Anthropic 공식 announce 본문 정합 측정 cycle

- 본질: 본 cycle 측 §2.4 Subscription-aware paradigm 본문 = 2026-05-19 KST 측정 시점 default. 2026-06-15 적용 default Anthropic 공식 announce 본문 정합 측정 의무 default.
- mitigation paradigm: 2026-06-15 이후 공식 announce 본문 측정 + 본 §2.4 본문 정정 영역 발견 시 별 cycle 진입 default
- 별 cycle 후보: `MASTER-CLI-SUBSCRIPTION-AWARE-PARADIGM-OFFICIAL-VERIFY-NNN` (= 또는 동등)
- 본 cycle scope 외 default (= 본 cycle = paradigm 본문 본질 정착 영역 default · 공식 announce 본문 정합 = 후속 영역 default)

### 2. cross-repo-orchestrator sub-agent 실 활용 paradigm 측정 (= 직전 cycle TODO 정합)

- 본질: 직전 cycle (= `MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001`) 신설 sub-agent 측 첫 실 활용 cycle default
- 본 cycle 측 §3.4 sub-agent 7× token cost warning sub-section 신설 = sub-agent fan-out paradigm 측 실 활용 시점 측 정합 의무 default
- 별 cycle 후보: `MASTER-CLI-CROSS-REPO-ORCHESTRATOR-FIRST-USE-NNN` (= 직전 cycle TODO 정합)
- 실 활용 시점 측 §3.4 paradigm 정합 측정 의무 default

### 3. intake-router.md drift @ foundation mitigation (= 직전 cycle TODO 정합)

- 본질: app-foundation 측 `.claude/agents/active/intake-router.md` sha drift (= 직전 cycle 동일 영역 default · 본 cycle 측 변경 X)
- 본 cycle scope 외 default
- 별 cycle 후보: `MASTER-CLI-INTAKE-ROUTER-FND-DRIFT-MITIGATION-NNN` (= 직전 cycle TODO 정합)

### 4. baseline-snapshot.sh REPOS 배열 app-foundation 추가 (= 직전 cycle TODO 정합)

- 본질: 직전 cycle 측 §FREEDOM 결정 = skip default (= file 자체 5-repo 모두 MISSING)
- 본 cycle scope 외 default
- 별 cycle 후보: `MASTER-CLI-BASELINE-SNAPSHOT-FOUNDATION-ADD-NNN` (= 직전 cycle TODO 정합)

## 본 cycle scope 외 dirty / drift / miss 영역 baseline preservation

본 cycle 진입 시점 baseline 측 발견 영역 (= 직전 cycle 동일 영역 default · 본 cycle 진행 무영향 default):

- **master**:
  - `.ai/nightly-baseline/2026-05-14.md` (M) + `.ai/nightly-baseline/2026-05-15.md ~ 2026-05-19.md` (??) = nightly baseline 영역 default
- **app-foundation**:
  - `cc-paste-FND-SHARED-KMP-MODULE-ACTIVATE-001.md` (??) = working file 영역 (= `working-file-lifecycle.md` 정합)
  - intake-router.md drift = 별 cycle 분리 default
  - `gradlew` + `gradlew.bat` (drift) = build script 영역 · 본 cycle scope 외
- **GB / GD / GT**:
  - 다수 production code (M) + 다수 untracked (.ai/reports + .idea + cc-paste + composeResources + login / splash / ui + supabase/.temp 등) = 자식 도메인 specific 영역 · 본 cycle 무접촉 의무 정합 default

`§7.1 paste-back dirty baseline 패러다임` 정합 default (= pre-existing scope-외 dirty 보존 + 0 NEW dirty 검증 의무).

## Follow-up cycle 후보 (= 본 cycle 본질 측 후속 영역)

1. **`MASTER-CLI-SUBSCRIPTION-AWARE-PARADIGM-OFFICIAL-VERIFY-NNN`** (= 2026-06-15 이후 default · 공식 announce 본문 정합 측정 후 본 §2.4 본문 정정 영역 발견 시 별 cycle)
2. **`MASTER-CLI-CROSS-REPO-ORCHESTRATOR-FIRST-USE-NNN`** (= cross-repo-orchestrator sub-agent 첫 실 활용 cycle · 본 §3.4 paradigm 정합 측정 default)
3. **`MASTER-CLI-INTAKE-ROUTER-FND-DRIFT-MITIGATION-NNN`** (= 직전 cycle TODO 정합)
4. **`MASTER-CLI-BASELINE-SNAPSHOT-FOUNDATION-ADD-NNN`** (= 직전 cycle TODO 정합)

## 본 cycle 측 완료 영역 (= 검증 완료)

- [x] baseline anchor verify (= 5-repo HEAD sha + cross-repo-parallel-exec.md sha + 부모 mount root CLAUDE.md sha-256 + 보호 5 file sha + dirty 영역)
- [x] cross-repo-parallel-exec.md 정독 + 정정 위치 결정 (= §2.4 + §3.4 신설 default · §2.2 expansion default · §FREEDOM)
- [x] (A) cross-repo-parallel-exec.md §2.4 Subscription-aware paradigm sub-section 신설
- [x] (B) cross-repo-parallel-exec.md §2.2 영역 2 paradigm 본문 강화
- [x] (C) cross-repo-parallel-exec.md §3.4 Sub-agent token cost warning sub-section 신설
- [x] (D) 부모 mount root CLAUDE.md §4 cross-repo paradigm pointer 정정 강화
- [x] master CLAUDE.md §15 본 cycle entry append
- [x] propagation 단방향 (= 4/0 ok · 1 file × 4 자식 byte-identical · sha `fa832655`)
- [x] 산출물 5 file 신설 (= PLAN + EVIDENCE + VERIFY + REVIEW + TODO)
- [ ] memory 갱신 (= .auto-memory/incident-log + propagation-status)
- [ ] 5-repo commit (= cli session 자체 시점 결정)
- [ ] paste-back 본문 cowork chat 측 회수
