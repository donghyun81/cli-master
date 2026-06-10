# Anchor list (= 누락 시 cycle 무조건 실패 본질 영역 default)

> 본 file = 6-repo 측 anchor list 영구 SoT default · purpose 수준 default · hot 영역 default
> 위치 = `claude-cli-master/.claude/rules/anchor-list.md`
> Cold storage = `claude-cli-master/.auto-memory/anchor-list-COLD.md` (= Cycle 2b 신설 default · master only default · propagation X default)
> 신설: `MASTER-CLI-CYCLE-2A-ANCHOR-LIST-HOT-INSTALL-001` · 2026-05-22

---

## §1. 본질

- purpose 수준 default (= method 어휘 X default · 본질 외화 default)
- 본인 confirm 영역 default (= 10 anchor default · hot 영역 default)
- hot 제외 후보 = cold storage (= `.auto-memory/anchor-list-COLD.md` default) 측 누적 default · master only default · propagation X default
- hot 복귀 trigger = 본 cold anchor 영역 재발 사고 1+ 회 발견 시점 default
- **GSM 외화** (= MASTER-CLI-GSM-MEASUREMENT-LAYER-001 · 2026-06-02): 각 anchor = G/S/M 3-tuple 로 외화 (= [`gsm-measurement.md`](./gsm-measurement.md) canonical form 정합). G(의도) = 기존 Purpose 의 측정 restatement · 본질·우선순위(P0/P1)·적용 trigger 보존 · purpose 수준 유지 (= M 은 목표값 한정 · method 어휘 X). Metric family = `gsm-measurement.md §2` anchor family.

## §2. Hot anchor list (= 10 anchor default · P0 6 + P1 4 default)

### A1 — Baseline drift detection

**Purpose**: cycle 진입 시점 cowork chat 측 인용 baseline vs cli session 측 disk 실측 baseline 사이 mismatch 발견 의무 default — 표면 인용 X · 실측 default

**적용 trigger**: 매 cycle 진입 첫 turn + paste source authoring 시점 + paste-back PASS 보고 시점 default

**우선순위**: P0

**precedent**: `COWORK-PREP-BASELINE-MISMATCH-001~008` (= 8회차 재발 default · `cycle-discipline.md §14a` 정합 default)

**GSM** (= `gsm-measurement.md` form):
- **G** — cowork 인용 baseline 과 cli disk 실측 baseline 이 일치한다 (표면 인용이 실측을 대체하지 않음).
- **S** — 진입 첫 turn 의 6-repo HEAD 실측 + 박제 표 대조 흔적.
- **M** — baseline mismatch 미reconcile 건수 `= 0` (drift 발견 시 forward-progress 판정 + 기록 100%).

### A2 — Protected file integrity guard

**Purpose**: 6-repo 측 byte-identical 의무 영역 (= 보호 5 file default) 측 sha drift 발견 시 즉시 STOP default

**적용 trigger**: 매 cycle 진입 baseline 측정 + 보호 file 변경 commit 직후 + propagation cycle verify 시점 default

**우선순위**: P0

**precedent**: master `CLAUDE.md §2` + `cycle-discipline.md §10` default

**GSM** (= `gsm-measurement.md` form):
- **G** — 보호 5 file 이 6-repo byte-identical 을 유지한다.
- **S** — 보호 5 file 의 sha-256 측정값 vs `protected-file-hashes.md` baseline 대조 (= `shasum -a 256`).
- **M** — 보호 5 sha drift 건수 `= 0`.

### A3 — Cycle scope expansion containment

**Purpose**: 한 cycle 측 다른 영역 묶임 발견 시 즉시 분리 default — 검증 난이도 ↑ + 보고서 정합 ↓ + 책임 영역 모호 차단 default

**적용 trigger**: /plan 단계 + ChangeBudget 표 작성 시점 + 변경 file × N 측정 시점 default

**우선순위**: P0

**precedent**: `CYCLE-PHASE-SCOPE-PUFFY-001` + master `CLAUDE.md §5` "Scope expansion" (= STOP #2 default)

**GSM** (= `gsm-measurement.md` form):
- **G** — 한 cycle 이 단일 scope 를 유지한다 (다른 영역이 묶이지 않음).
- **S** — /plan ChangeBudget 표 + 변경 file × N 측정 + 신규 dirty 측정.
- **M** — scope-외 신규 변경 file 건수 `= 0` (= pre-existing baseline dirty 제외).

### A4 — Cli infra single-direction propagation

**Purpose**: cli infra 영역 = master 측 단일 source · 자식 측 직접 수정 차단 default — drift 발견 시 즉시 mitigation cycle default

**적용 trigger**: 자식 repo 측 `.claude/**` 또는 `docs/schemas/**` 변경 시도 시점 + cli infra 변경 직후 propagation 의무 시점 default

**우선순위**: P0

**precedent**: master `CLAUDE.md §3 + §4` + `cycle-discipline.md §3 + §15` default

**GSM** (= `gsm-measurement.md` form):
- **G** — cli infra = master 단일 source · 자식 측 직접 수정이 0 이다.
- **S** — 자식 `.claude/**` 직접 변경 시도 측정 + propagation 후 `verify-sync.sh` 결과.
- **M** — 자식 cli infra drift 건수 `= 0` · propagation 후 6-repo byte-identical (`verify-sync` exit 0).

### A5 — Disk verification before recommendation

**Purpose**: Recommended option 발행 + cycle scope 결정 + paste source authoring 시점 = disk 측 이미 구현 여부 측정 의무 default — 표면 패턴 추측 차단 + stale 후보 차단 default

**적용 trigger**: 후속 cycle 후보 발행 시점 + Recommended option 발행 직전 + paste source umbrella §1 + §1.3 + §2 + §3 작성 시점 default

**우선순위**: P0

**precedent**: `recommended-option-disk-verification.md` §2.1~§2.4 + `paste-authoring-disk-verification.md` §3 + `cycle-discipline.md §23 + §26` default

**GSM** (= `gsm-measurement.md` form):
- **G** — 추천 / scope 결정이 disk 실측에 근거한다 (표면 추측 0).
- **S** — Recommended option / paste authoring 시점 grep / find / git ls-files / Read 측정 흔적.
- **M** — 미검증 추천 건수 `= 0` · stale 후보 건수 `= 0`.

### A6 — Subscription pool integrity

**Purpose**: cli session 측 영역 1 + 영역 2 = interactive subscription pool 정합 default + 영역 3 (= `claude -p`) 회피 default — 요금 폭탄 risk (= 49-subagent $8k~$15k / 23-subagent $47k/3d default) 차단

**적용 trigger**: cross-repo cycle 진입 시점 + sub-agent 호출 결정 시점 + automation paradigm 신설 시점 default

**우선순위**: P0

**precedent**: `cross-repo-parallel-exec.md §2.4`(kernel) + `cross-repo-parallel-exec-detail.md §3.4` + 부모 mount root `CLAUDE.md §4` default

**GSM** (= `gsm-measurement.md` form):
- **G** — 영역 1 + 영역 2 = interactive pool 정합 · 영역 3(`claude -p`) 회피 (= 요금 폭탄 risk 차단).
- **S** — cross-repo cycle 진입 시 sub-agent 호출 결정 + Bash `claude -p` 호출 측정.
- **M** — `claude -p` sub-process spawn 건수 `= 0` · sub-agent parallelism `≤ 3`.

### A7 — Filename + content dual grep

**Purpose**: filename find 1차 + container 내부 content grep 2차 의무 default — filename 부재 시점 즉시 STOP/UNKNOWN 분류 차단 default

**적용 trigger**: BASELINE 실측 시점 + symbol/object/function 존재 측정 시점 + lifecycle/deprecated 키워드 측정 시점 default

**우선순위**: P1

**precedent**: `cycle-discipline.md §17` + §23.2 default

**GSM** (= `gsm-measurement.md` form):
- **G** — BASELINE 실측이 filename find + content grep 2단을 수행한다 (filename-only false negative 0).
- **S** — find 1차 흔적 + container 내부 content grep 2차 흔적.
- **M** — filename-only STOP/UNKNOWN 분류(content grep 미수행) 건수 `= 0`.

### A8 — Cross-repo paradigm selection autonomy

**Purpose**: cross-repo paradigm 영역 1 vs 영역 2 선택 = cli session 자율 판단 default — 요청 본질 측정 후 결정

**적용 trigger**: cross-repo cycle 진입 시점 + 부모 mount root cwd 진입 시점 default

**우선순위**: P1

**precedent**: `cross-repo-parallel-exec-detail.md §2.1~§2.3` + 부모 mount root `CLAUDE.md §3.3` default

**GSM** (= `gsm-measurement.md` form):
- **G** — 영역 1 vs 영역 2 선택이 요청 본질 측정 후 자율 결정된다.
- **S** — cross-repo 진입 시 paradigm 선택 근거 기록 흔적.
- **M** — 본심 분기 미측정 진입 건수 `= 0` (= 선택 근거 명시율 100%).

### A9 — Domain SoT mandatory read

**Purpose**: paste source authoring + cycle scope 결정 시점 = 4 도메인 (Auth + Data + Backend + Perf default) 측 키워드 측정 + 도메인 SoT 정독 의무 default

**적용 trigger**: paste source umbrella 작성 시점 + cycle scope 본문 측 도메인 키워드 발견 시점 default

**우선순위**: P1

**precedent**: `cowork-project-instructions §E-1-1` + `deferred-domains.md` + master `CLAUDE.md §5` STOP #1 (= DB migration / Money / Auth default) default

**GSM** (= `gsm-measurement.md` form):
- **G** — paste authoring / scope 결정 시 4 도메인(Auth/Data/Backend/Perf) 키워드 측정 + 도메인 SoT 정독을 수행한다.
- **S** — 도메인 키워드 측정 흔적 + 도메인 SoT 인용.
- **M** — 도메인 키워드 발견 후 SoT 미정독 건수 `= 0`.

### A10 — Responsibility split cowork vs cli

**Purpose**: cowork chat = 기획 + paste source authoring + cross-verify 영역 default · cli session = 실 IMPL + ADB + emulator + Logcat + commit 영역 default — 책임 경계 침해 차단 default

**적용 trigger**: 매 cycle 진입 시점 + paste source 발행 시점 + runtime crash mitigation cycle 진입 시점 default

**우선순위**: P1

**precedent**: `cowork-project-instructions §B-1~§B-3` + `runtime-crash-mitigation-process.md` + `paste-authoring-disk-verification.md` default

**GSM** (= `gsm-measurement.md` form):
- **G** — cowork(기획 + authoring + cross-verify) ↔ cli(실 IMPL + ADB + emulator + commit) 책임 경계가 유지된다.
- **S** — 책임 경계 침해 시도 측정 (= 역할 밖 행동 흔적).
- **M** — 경계 침해 건수 `= 0`.

## §3. 적용 trigger 종합

- 매 cycle 진입 baseline 측정 시점 → A1 + A2 default
- paste source authoring 시점 → A5 + A9 + A10 default
- Recommended option 발행 시점 → A5 default
- 후속 cycle 후보 발행 시점 → A5 default
- cross-repo cycle 진입 시점 → A6 + A8 default
- /plan 단계 → A3 default
- 자식 repo cli infra 변경 시도 시점 → A4 default
- BASELINE 실측 시점 → A7 default

## §4. cycle 보고 format negative space line (= 의무 default)

매 cycle 보고 끝 1 줄 "고려했으나 hot 제외 영역: <영역 default>" 의무 default. 본 line = anchor list 진화 signal default (= 사용자 본심 정합 default). 비어 있는 영역 = "(없음)" 명시 default. 발행 영역 = REVIEW.md §13 + paste-back 본문 default · 본문 단일 SoT = `reporting.md §13` default.

## §5. STOP 조건 pointer

본문 단일 SoT = master `CLAUDE.md §5` (= Cycle 1 canonical 결과 default · 9 항 default · Mode 잘못 결정 sub-case 흡수 default · L1-7 정합 default)

## §6. 인접 paradigm 정합

- `recommended-option-disk-verification.md` (= A5 baseline default)
- `paste-authoring-disk-verification.md` (= A5 + A10 baseline default)
- `cross-repo-parallel-exec.md §2.4`(kernel) + `cross-repo-parallel-exec-detail.md §3.4` (= A6 + A8 baseline default)
- `cycle-discipline.md §17` (= A7 baseline default)
- `reporting.md §13` (= negative space line default)
- `cowork-project-instructions §B-1~§B-3` (= A10 baseline default)
- 부모 mount root `CLAUDE.md §3 + §4`
- **`.auto-memory/anchor-list-COLD.md`** (= **Cycle 2b 신설 default · master only default · cold storage pointer default**)

## §7. cycle 이력

- 2026-05-22 · `MASTER-CLI-CYCLE-2A-ANCHOR-LIST-HOT-INSTALL-001` · 본 file 신설 + reporting.md §13 append + cycle-discipline.md §27 pointer 신설 + 5-repo byte-identical propagation default
- 2026-05-22 · `MASTER-CLI-CYCLE-2B-ANCHOR-LIST-COLD-INSTALL-001` · cold storage `anchor-list-COLD.md` 신설 default (= master only default · 본 § 본문 X default · Cycle 2b 측 본문 default)
- 2026-06-02 · `MASTER-CLI-GSM-MEASUREMENT-LAYER-001` · A1~A10 각 anchor 에 G/S/M 3-tuple 외화 (= `gsm-measurement.md` canonical form 정합 · §1 본질 bullet 추가). 기존 Purpose / 적용 trigger / 우선순위(P0 6 + P1 4) / precedent 본문 무삭제 · 본질·우선순위·trigger 보존 (= 형식 GSM 정합 · 내용 약화 0). 5-repo byte-identical propagation.
