# Anchor list COLD storage (= 12 후보 영구 누적 + cold 영역 default)

> 본 file = anchor list cold storage default · hot 영역 = `.claude/rules/anchor-list.md` default · 재발 시점 hot 복귀 default
> 위치 = `claude-cli-master/.auto-memory/anchor-list-COLD.md` (= master only default · propagation X default)
> 신설: `MASTER-CLI-CYCLE-2B-ANCHOR-LIST-COLD-INSTALL-001` · 2026-05-22
> lifecycle: 매 5 cycle 또는 분기 review default (= `cycle-discipline.md §18` 정합 default)

---

## §1. 12 후보 영구 누적 (= Phase 1 본문 default)

### Hot 영역 (= `.claude/rules/anchor-list.md` 측 hot default · Cycle 2a 마감 default · 본인 confirm 10 default)

- A1 baseline drift detection (= P0 default)
- A2 protected file integrity guard (= P0 default)
- A3 cycle scope expansion containment (= P0 default)
- A4 cli infra single-direction propagation (= P0 default)
- A5 disk verification before recommendation (= P0 default)
- A6 subscription pool integrity (= P0 default)
- A7 filename + content dual grep (= P1 default)
- A8 cross-repo paradigm selection autonomy (= P1 default)
- A9 domain SoT mandatory read (= P1 default)
- A10 responsibility split cowork vs cli (= P1 default)

### Cold 영역 (= hot 제외 영역 default · 재발 시점 hot 복귀 default · 본 cycle 신설 default)

#### A11 — Cli self-test 3 항

**Purpose**: 매 cycle 진입 시점 cli session 측 self-test 3 항목 (= `claude --version` + `claude mcp list` 측 `pencil ✓ Connected` + ToolSearch query=`pencil` ≥ 13 tools default) 모두 PASS 의무 default — 1+ FAIL = 즉시 STOP + 복귀 절차

**적용 trigger**: 매 cli session 진입 첫 행동 default + cli 버전 변경 직후 default

**우선순위**: P2 (= cli session 측 자체 측정 default · cowork chat 측 무접촉 default)

**cold 본질**: cli session 측 자체 측정 default · cowork chat 측 무접촉 default · paste source authoring 측 인용 영역 X default · trigger frequency 낮음 default (= cli session 진입 시점 default · 매 cli 버전 변경 시점 default · `CLAUDE-CODE-LATEST-CHASE-001` open trail 정합 default)

**precedent**: `cycle-discipline.md §13` (= Claude Code 환경 정합 default · self-test 3 항목 baseline default) + `CLAUDE-CODE-LATEST-CHASE-001` trail default

#### A12 — App-foundation 5-repo scope

**Purpose**: 5-repo 영역 (= master + app-foundation + GB + GD + GT default) cli infra propagation + verify-sync 영역 cover 의무 default — app-foundation 누락 사고 (= `MASTER-CLEANUP-PROPAGATION-BUNDLE-001` default) 회피 default

**적용 trigger**: propagation cycle 진입 시점 + verify-sync 호출 시점 + baseline-snapshot.sh REPOS 배열 측정 시점 default

**우선순위**: P2 (= 신설 영역 default · 사고 1 회 mitigation default · 후속 trigger frequency 낮음 default)

**cold 본질**: 신설 영역 default (= 2026-05-11 app-foundation 신설 default · 2026-05-19 baseline-snapshot v6 mitigation default) · 본 paradigm 정착 후 propagation cycle 측 자동 적용 default · 사고 frequency 낮음 default · 본 anchor 측 trigger 시점 hot 복귀 default

**precedent**: 부모 mount root `CLAUDE.md §2` + master `CLAUDE.md §15` MASTER-CLI-BASELINE-SNAPSHOT-REPOS-V6-MITIGATION-001 row default

---

## §2. hot 복귀 trigger

- 본 cold anchor 영역 재발 사고 1+ 회 발견 시점 default
- 본 cold anchor 영역 trigger frequency ↑ 측정 시점 default (= 매 5 cycle 측정 default · `cycle-discipline.md §18` 분기 review cadence 정합 default)
- 사용자 본심 명시 default
- hot 복귀 cycle = 별 master cycle default (= `MASTER-CLI-ANCHOR-LIST-HOT-PROMOTE-NNN` 가칭 default · 5-repo byte-identical propagation 의무 default)

---

## §3. cycle 이력

- 2026-05-22 · `MASTER-CLI-CYCLE-2B-ANCHOR-LIST-COLD-INSTALL-001` · 본 file 신설 default · master only default · propagation X default

---

## §4. hot rule 측 `§7. cycle 이력` verbatim 이전 (4 entry · 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001`)

> 아래 = `.claude/rules/anchor-list.md §7` 원문 verbatim (= 삭제 0 · hot 은 1줄 pointer 후퇴 · 자동 주입층이라 이력 상주 불요).

## §7. cycle 이력

- 2026-05-22 · `MASTER-CLI-CYCLE-2A-ANCHOR-LIST-HOT-INSTALL-001` · 본 file 신설 + reporting.md §13 append + cycle-discipline.md §27 pointer 신설 + 5-repo byte-identical propagation default
- 2026-05-22 · `MASTER-CLI-CYCLE-2B-ANCHOR-LIST-COLD-INSTALL-001` · cold storage `anchor-list-COLD.md` 신설 default (= master only default · 본 § 본문 X default · Cycle 2b 측 본문 default)
- 2026-06-02 · `MASTER-CLI-GSM-MEASUREMENT-LAYER-001` · A1~A10 각 anchor 에 G/S/M 3-tuple 외화 (= `gsm-measurement.md` canonical form 정합 · §1 본질 bullet 추가). 기존 Purpose / 적용 trigger / 우선순위(P0 6 + P1 4) / precedent 본문 무삭제 · 본질·우선순위·trigger 보존 (= 형식 GSM 정합 · 내용 약화 0). 5-repo byte-identical propagation.
- 2026-06-22 · `MASTER-CLI-CROSSREPO-RECONCILE-AUTONOMY-PARADIGM-001` · A8 확장(= 동족 구현 정합 advisory step · G/S/M 에 "같은 맥락 2+ repo 구현 후 paste-back 회수 시점 정합 advisory 수행 · 미수행 = 0 · auto-converge 금지" + precedent `cross-repo-parallel-exec-detail.md §4.4`) + A10 확장(= cli 도메인 구현 HOW §FREEDOM 자율 폭 명시 + S/M 에 "paste source HOW-leak 건수 = 0" GSM-M + cli 자율 = 도메인 HOW 한정 경계[STOP 9 #1 Money/Auth/DB · 보호5 A2 · cli-infra byte-identical A4 미확대] + precedent `§B-5`). **신 hot anchor 신설 X** (= hot 10 baseline 유지 · 기존 A8/A10 확장 default · P0 6 + P1 4 불변). req1(동족 구현 정합 advisory) + req2(cli HOW 자율 확대 범위 한정) 한 쌍 정합. 6-repo byte-identical propagation.
