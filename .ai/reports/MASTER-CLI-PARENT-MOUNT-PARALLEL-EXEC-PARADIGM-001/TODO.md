# TODO — MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001

## Deferred items (= 별 cycle 분리 default)

### 1. intake-router.md drift @ foundation mitigation

- 본질: app-foundation 측 `.claude/agents/active/intake-router.md` sha = `25565f49` (= master sha `fc397169` 측 drift)
- 본 cycle scope 외 (= 본 cycle 진입 baseline 측 발견 default · 본 chat 외부 변경 영역 default)
- 별 cycle 후보: `MASTER-CLI-INTAKE-ROUTER-FND-DRIFT-MITIGATION-001` (= 또는 동등)
- mitigation paradigm: `bash scripts/propagate.sh .claude/agents/active/intake-router.md --targets FND` (= app-foundation 측 master 정합 cp 단방향)

### 2. baseline-snapshot.sh REPOS 배열 app-foundation 추가 (= §FREEDOM 결정 = skip)

- 본질: paste source §2.1 #8 영역 + Finding 4 mitigation 본질
- 본 cycle 측 §FREEDOM 결정 = skip default (= file 자체 5-repo 모두 MISSING · `ls -la /Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/scripts/baseline-snapshot.sh` = `No such file or directory`)
- 별 cycle 후보: `MASTER-CLI-BASELINE-SNAPSHOT-FOUNDATION-ADD-001` (= 또는 동등)
- mitigation paradigm: `scripts/baseline-snapshot.sh` 신설 + `REPOS=(GentlyBreath GentlyDay GentlyTable app-foundation)` 배열 본문 명시 + master cycle 신설 + 5-repo propagation

### 3. cross-repo-orchestrator sub-agent 실 활용 paradigm 측정

- 본질: 본 cycle 측 cross-repo-orchestrator sub-agent 신설 default 단 실 활용 X (= 본 cycle 자체 = 단일 cli session 측 직접 5-repo 측정 + propagation 측 자체 호출 default)
- 후속 cross-repo cycle 측 본 sub-agent 호출 paradigm 정합 측정 의무
- 실 활용 시점 측 발견 영역 = paradigm 갱신 후보 (= `MASTER-CLI-CROSS-REPO-ORCHESTRATOR-PARADIGM-REFINE-NNN` 후보)

### 4. 본 cycle scope 외 dirty / drift / miss 영역 baseline preservation

본 cycle 진입 시점 baseline 측 발견 영역 (= 본 cycle 진행 무영향 default):

- **master**:
  - `.ai/nightly-baseline/2026-05-14.md` (M) + `.ai/nightly-baseline/2026-05-15.md ~ 2026-05-19.md` (??) = nightly baseline 영역 default · audit commit 시점 갱신 영역
  - `.auto-memory/incident-log.md` (M) + `.auto-memory/propagation-status.md` (M) = 본 cycle 측 audit commit 시점 갱신 영역
- **app-foundation**:
  - `core/designsystem/.../Color.kt` (M) + `GentlyTheme.kt` (M) = production code 영역 · 본 cycle 무접촉 의무 정합 default
  - `cc-paste-FND-SHARED-KMP-MODULE-ACTIVATE-001.md` (??) = working file 영역 (= `working-file-lifecycle.md` 정합)
  - `gradlew` + `gradlew.bat` (drift) = build script 영역 · 본 cycle scope 외
- **GB / GD / GT**:
  - 다수 production code (M) + 다수 untracked (.ai/reports + .idea + cc-paste + composeResources + login / splash / ui + supabase/.temp 등) = 자식 도메인 specific 영역 · 본 cycle 무접촉 의무 정합 default
- **master 단일 file**:
  - `docs/baseline/cowork-project-instructions-§20-redline-20260517.md` = master 단일 file · 자식 propagation 영역 X default · 본 cycle scope 외

`§7.1 paste-back dirty baseline 패러다임` 정합 default (= pre-existing scope-외 dirty 보존 + 0 NEW dirty 검증 의무).

## Follow-up cycle 후보 (= 본 cycle 본질 측 후속 영역)

1. **`MASTER-CLI-CROSS-REPO-ORCHESTRATOR-FIRST-USE-NNN`**: 본 cycle 신설 sub-agent 측 첫 실 활용 cycle (= cross-repo 영역 본질 발견 시점 paradigm 검증 default)
2. **`MASTER-CLI-INTAKE-ROUTER-FND-DRIFT-MITIGATION-NNN`**: intake-router.md @ foundation drift mitigation 별 cycle
3. **`MASTER-CLI-BASELINE-SNAPSHOT-FOUNDATION-ADD-NNN`**: baseline-snapshot.sh 신설 + app-foundation 추가 별 cycle (= Finding 4 mitigation)
4. **`MASTER-CLI-CROSS-REPO-PARALLEL-EXEC-PARADIGM-REFINE-NNN`** (= lazy default): cross-repo paradigm 본문 측 실 활용 paradigm 측정 후 paradigm 갱신 cycle (= 첫 실 활용 cycle 마감 후 자연 trigger)

## 본 cycle 측 완료 영역 (= 검증 완료)

- [x] baseline anchor verify (= 5-repo HEAD sha + 보호 5 file sha + dirty 영역 측정)
- [x] cli infra SoT 본문 정독 (= master CLAUDE.md + routing-and-delegation + cycle-discipline + workflow-core + intake-router + report-formats 등)
- [x] 부모 mount root CLAUDE.md 신설 (= `/Users/yundonghyeon/AndroidStudioProjects/CLAUDE.md` · sha-256 `183ad618...`)
- [x] cross-repo-parallel-exec.md 신설 (= master + 4 자식 byte-identical · sha `c4651d6a`)
- [x] cross-repo-orchestrator.md sub-agent 신설 (= §FREEDOM = 신설 default · master + 4 자식 byte-identical · sha `b683a10b`)
- [x] routing-and-delegation.md Cross-repo sub-section append (= master + 4 자식 byte-identical · sha `bc24704c`)
- [x] cycle-discipline.md §21 신설 append (= master + 4 자식 byte-identical · sha `09b445f2`)
- [x] master CLAUDE.md §15 본 cycle entry append
- [x] propagation 단방향 (= 16/0 ok · 4 file × 4 자식 byte-identical)
- [x] 산출물 5 file 신설 (= PLAN + EVIDENCE + VERIFY + REVIEW + TODO)
- [ ] memory 갱신 (= .auto-memory/incident-log + propagation-status)
- [ ] 5-repo commit (= cli session 자체 시점 결정)
- [ ] paste-back 본문 cowork chat 측 회수
