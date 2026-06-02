# Context Health Metrics — 항상로드 char + 환각 패턴 수 (정기 측정 SoT)

> **단일 목적**: CLI context 최적화 프로그램(Phase 0~4) 산출을 **회귀 방지**하기 위한 정기 측정 지표 SoT. 2 지표 family = (1) 항상로드 char(repo별 · proxy) + (2) 환각 패턴 수(disk 측정).
> **GSM 귀속** (= 2026-06-02 · MASTER-CLI-GSM-MEASUREMENT-LAYER-001): 본 2 family = [`gsm-measurement.md §2`](../.claude/rules/gsm-measurement.md) 의 **context 건강 Metric family**(= program-level · 행동 무관 · §0 G/S 연결). `rule-routing-index.md §C` 행동별 GSM 과는 별 layer(= 행동 무관 context 건강 전체) · cycle-health(DORA) family 와 함께 `gsm-measurement-dashboard.md` 종합 view 노출.
> **신설**: MASTER-CLI-CONTEXT-OPT-PHASE4-SSOT-SWEEP-METRICS-001 (2026-06-01 · M5 · 프로그램 마지막 Phase).
> **위치**: master only (`.auto-memory/` · propagation X · `*-COLD.md` 동급 audit memory). 자식 측 char 은 repo별 측정값(byte-identical 아님).
> **⚠ proxy 주의**: char = UTF-8 codepoint(python) · **token 아님**. token 추정 시 proxy band(ASCII≈3.2~4 ch/tok · Hangul≈1.0~2.2 ch/tok) 라벨 의무 · over-claim 금지(`cc-audit-CONTEXT-OPT-PHASE0-001.md §0` 정합).
> SOT: `CLAUDE.md`

---

## §0. GSM 귀속 (= `gsm-measurement.md` context 건강 Metric family · 2026-06-02 realign)

본 file = GSM canonical 의 **context 건강 Metric family**(= `gsm-measurement.md §2` 지도 · program-level · 행동 무관). 측정 항목·값(§1~§3)은 그대로 두고 GSM 3-tuple 에 귀속만 정합:

- **G** (의도) — 매 진입 항상로드 context 가 작게 유지되고, 환각 vector(stale pointer / 매몰)가 낮게 유지된다.
- **S** (관측 신호) — 진입 paradigm 별 항상로드 char + disk 측 `stale_pointer` / `conflicting_sot` / `buried_ratio` (= §1 정의).
- **M** (정량 지표) — §1~§3 의 측정값·목표 (= 항상로드 char 4 지표 + 환각 패턴 3 지표). master-only(전파 X) · `gsm-measurement-dashboard.md` 종합 view 노출.

본 §0 = 위치/귀속 정합만 (= 측정 항목·값 보존 · `gsm-measurement.md` form 규약 복제 X · 단일 SoT 정합).

---

## §1. 지표 정의 (measurable)

### (1) 항상로드 char (= 매 진입 무조건 로드 · proxy)

진입 paradigm 별 "행동 무관 항상로드" char 합. 측정 = `python3 -c "len(open(f).read())"` (codepoint).

| 지표 | 정의 (항상로드 대상) | 측정 명령 |
|---|---|---|
| `parent_root_claude_md` | 부모 mount 진입(§3.2) 시 항상 | `CLAUDE.md` (parent root) |
| `master_claude_md` | master/자식 진입 시 (§15 = cold pointer 후 hot only) | `claude-cli-master/CLAUDE.md` |
| `L0_kernel` | 매 cycle L0 (safety + anchor + cross-repo **kernel**) | 3 rule char 합 (+ 헌법 §5 = master CLAUDE.md 내) |
| `child_claude_md` | 자식 단독 진입(§3.1) 시 (dedup 후 inline only) | `<child>/CLAUDE.md` (4 byte-identical) |

> cross-repo 실행 본문(`cross-repo-parallel-exec-detail.md` 12.6K) = **항상로드 X** (= behavior-triggered · Phase 3 H4 demote) → L0_kernel 에 미포함.

### (2) 환각 패턴 수 (= disk 측정 · 낮을수록 건강)

| 지표 | 정의 (disk 측정 방법) | 목표 |
|---|---|---|
| `stale_pointer` | 존재하지 않는 file/§ 를 가리키는 pointer 수 (grep pointer → target 존재 검증) | 0 |
| `conflicting_sot` | 같은 사실의 다중 divergent 본문(미해소 · `rule-routing-index §G` 외 잔여) | 최소화 |
| `buried_ratio` | 단일 최대 항상로드 file 의 운영-비필수 비율 (= 매몰 = lost-in-the-middle 환각 risk) | < 50% |

---

## §2. 현재 측정값 (2026-06-01 · Phase 4 마감 시점 · disk 실측)

### 항상로드 char (codepoint · proxy)

| repo 영역 | char | 비고 |
|---|---|---|
| parent root CLAUDE.md | 8,000 | §3.2 진입 항상 |
| master CLAUDE.md (FULL) | 25,392 | §15 = hot 8 entry + cold pointer(전체 이력 = `master-cycle-history-COLD.md`) |
| L0 kernel (safety+anchor+cross-repo kernel) | 21,561 | cross-repo = kernel 8.2K (Phase 3 H4 · 본문 12.6K demote) |
| child CLAUDE.md (deduped · ×4 byte-identical) | 19,260 | 운영 §2/§3/§6~§13/§16+§14a = master pointer |

### 환각 패턴 수

| 지표 | 값 | 근거 |
|---|---|---|
| `stale_pointer` | 0 (genuine) | H7(Phase 0) reviewer.md 실존 · figma = 의도 placeholder · SoftBudget→code-principles wrong pointer(Phase 4 정정) |
| `conflicting_sot` | 0 (actioned) | DependencyDecision 8항 3 framing → `DEPENDENCY_DECISION_CHECKLIST.md` canonical + UI 억제 → `ui-ux-analysis.md` canonical 로 reconcile 마감 (MASTER-CLI-DEPENDENCY-DECISION-RECONCILE-001 · `rule-routing-index §G` row 7+8 · grow-only merge 정보 소실 0) |
| `master §15 hot entry` | 8 | cold 재배치(Phase 1) 후 hot · ≥ ~10 도달 시 cold 재이전 trigger(`CLAUDE.md §15` note) |

---

## §3. 프로그램 trajectory (Phase 0 → 4 · 회귀 방지 baseline)

| 영역 | before (Phase 0) | after (현재) | 출처 Phase |
|---|---|---|---|
| master CLAUDE.md 항상로드 | ~83.7K char (§15 inline 65 entry) | ~25.4K char (§15 cold) | P1 (§15 cold) |
| L0 kernel | 31.5K char (cross-repo 18.2K inline) | 21.6K char (cross-repo kernel 8.2K) | P3 (H4) |
| 자식 CLAUDE.md | 24.7K char (master clone full) | 19.3K char (dedup) | P3 (H2) |
| baseline 신선도 | latest.json 5/22 stale | always-fresh live emit | P2 (H3) |
| 환각 stale 해소 | latest.json + 자식 §14a + SoftBudget pointer | 0 genuine | P2·P3·P4 |

> 양축(토큰 ↓ + 환각 ↓) 동시 win 누적. token 절감 = char proxy band 추정(tokenizer-measured 아님).

---

## §4. 측정 cadence + 유지

- **매 cli-infra cycle 마감 시**: 항상로드 char 영향 변경(헌법 §/L0 rule/자식 CLAUDE.md) 시 본 §2 갱신.
- **분기 정기 review**(= `cycle-discipline.md §18` · 1/6·4/6·7/6·10/6 부근): 4 char 지표 + 3 환각 지표 전량 재측정 + trajectory append. `§18` 측정 항목 표에 "context health 지표(본 file)" 추가 후보(= 별 wiring cycle · 본 cycle 무접촉).
- **`stop-reflect.sh`**(= `cycle-discipline.md §19`) self-improving loop 이 buried/conflict 누적 감지 시 silent 후보 → 본 file 갱신 trigger.
- 유지 주체 = master cycle (자동 hook 신설 X · `automation-policy.md` Inspection = 수동 의무 정합).

---

## §5. 인접 paradigm 정합

- `rule-routing-index.md §C`(= 행동별 GSM · 본 file = program-level 보완) + §G(= SSOT canonical map · `conflicting_sot` 지표 source)
- `cc-audit-CONTEXT-OPT-PHASE0-001.md`(= Phase 0 측정 baseline · proxy 주의 source)
- `cycle-discipline.md §18`(분기 review cadence) + §19(stop-reflect self-improving)
- `.auto-memory/master-cycle-history-COLD.md`(= §15 cold · buried 해소 산출)

---

## §6. cycle 이력

- 2026-06-01 · MASTER-CLI-CONTEXT-OPT-PHASE4-SSOT-SWEEP-METRICS-001 · 본 file 신설(= 항상로드 char 4 지표 + 환각 패턴 3 지표 정의 + Phase 0~4 trajectory + cadence). H6 sweep = SoftBudget canonical 1건 actioned(§G row 6) + DependencyDecision 1건 defer + 23 footer 보일러플레이트 비-dedup. master only(propagation X).
- 2026-06-02 · MASTER-CLI-GSM-MEASUREMENT-LAYER-001 · GSM Metric family 재위치(= §0 GSM 귀속 신설 + 헤더 blurb reframe · `gsm-measurement.md §2` context 건강 family 귀속). 기존 2 family(항상로드 char + 환각 패턴) 측정 항목·값 무변경(= 위치/귀속만 GSM 정합 · program-level · 행동 무관). master-only(propagation X 유지).
- 2026-06-02 · MASTER-CLI-DEPENDENCY-DECISION-RECONCILE-001 · `conflicting_sot` 1(defer)→0(actioned). DependencyDecision 8항 3 framing(workflow-core/code-principles/CHECKLIST) → `DEPENDENCY_DECISION_CHECKLIST.md` canonical + UI 억제 → `ui-ux-analysis.md` canonical 로 reconcile(= `rule-routing-index §G` row 7+8 · grow-only merge · 정보 소실 0 · UI 강도 보존). 지표 정의(§1) 무변경(= 환각 패턴 측정값만 갱신) · master-only(propagation X).
