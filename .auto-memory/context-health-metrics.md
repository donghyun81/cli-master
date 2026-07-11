# Context Health Metrics — 항상로드 char + 환각 패턴 수 (정기 측정 SoT)

> **단일 목적**: CLI context 최적화 프로그램(Phase 0~4) 산출을 **회귀 방지**하기 위한 정기 측정 지표 SoT. 2 지표 family = (1) 항상로드 char(repo별 · proxy) + (2) 환각 패턴 수(disk 측정).
> **GSM 귀속** (= 2026-06-02 · MASTER-CLI-GSM-MEASUREMENT-LAYER-001): 본 2 family = [`gsm-measurement.md §2`](../docs/rules/gsm-measurement.md) 의 **context 건강 Metric family**(= program-level · 행동 무관 · §0 G/S 연결). `rule-routing-index.md §C` 행동별 GSM 과는 별 layer(= 행동 무관 context 건강 전체) · cycle-health(DORA) family 와 함께 `gsm-measurement-dashboard.md` 종합 view 노출.
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
| parent root CLAUDE.md | 9,094 (2026-07-10 재측정 · DIET-2) | §3.2 진입 항상 |
| master CLAUDE.md (FULL) | 47,004 (2026-07-10 재측정 · DIET-2 §15 entry append 후 · **§15 hot 13 > 10 = cold 재이전 advisory 발화 상태**) | §15 = hot 13 entry + cold pointer(전체 이력 = `master-cycle-history-COLD.md` 121 entry) · 직전 ~29K (06-22 hot 6 시점) — 증가분 = hot 재증식 (9회차 demote 후보) |
| L0 kernel (safety+anchor+cross-repo kernel) | 29,761 (2026-07-10 재측정 · anchor GSM/T7 + kernel T7 성장 누적) | **T5 재정독 개정 (DIET-2)**: 세션 최초 1회 Read → 이후 cycle = hook 주입값+경량 실측 갈음 = **per-cycle 재정독 실효 0** · drift 시만 재Read |
| child CLAUDE.md (deduped · ×4 byte-identical) | 9,581 (2026-06-10 재측정 · AUTO-DEMOTE) | 운영 §2/§3/§6~§13/§14a/§15/§16 = master pointer (= §15 박제 폐지 포함) |
| intake 정독 표 `rule-routing-table.md` (신설 · DIET-2) | 2,867 | intake 시 유일 정독 (index 전문 = 색인 갱신 cycle 한정 · 직전 index 전문 정독 관례 대비 −92%) |
| cycle-discipline hot | 9,854 (2026-07-10 · DIET-2 · 직전 ~40K cp) | 전문 verbatim = `cycle-discipline-COLD.md` (master-only) · Mode 1 가정 정독 합계 = 235,005→145,199 byte (세션 최초) / 107,180 (2+ cycle) |

### 환각 패턴 수

| 지표 | 값 | 근거 |
|---|---|---|
| `stale_pointer` | 0 (genuine) | H7(Phase 0) reviewer.md 실존 · figma = 의도 placeholder · SoftBudget→code-principles wrong pointer(Phase 4 정정) |
| `conflicting_sot` | 0 (actioned) | DependencyDecision 8항 3 framing → `DEPENDENCY_DECISION_CHECKLIST.md` canonical + UI 억제 → `ui-ux-analysis.md` canonical 로 reconcile 마감 (MASTER-CLI-DEPENDENCY-DECISION-RECONCILE-001 · `rule-routing-index §G` row 7+8 · grow-only merge 정보 소실 0) |
| `master §15 hot entry` | 6 | 8회차 cold 재이전(MASTER-CLI-S15-HOT-DEMOTE-004 · 2026-06-22 · hot 15→5+본 cycle · 직전 7회차 = S15-HOT-DEMOTE-003 2026-06-11) 후 · ≥ ~10 도달 시 cold 재이전 trigger — **재증식 자동 감시** = `measure-gsm-cycle.sh` §15 hot check(> 10 시 Stop hook advisory surface · warn-only · 이전 판정 = 수동) |

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

## §3.1. 분기 자동 측정 trajectory (= `measure-gsm-cycle.sh` context-health 블록 · append-only · MASTER-CLI-GSM-CONTEXT-HEALTH-ABSORB-001)

> **append 주체** = [`.claude/hooks/measure-gsm-cycle.sh`](../.claude/hooks/measure-gsm-cycle.sh) 의 context-health 블록(= 신 hook 신설 X · 기존 GSM Stop hook 확장 흡수). **분기 guard**(= quarter bucket 경과) 통과 시 1행 append(= idempotent · 같은 분기 중복 X) · `GSM_MEASURE_ENFORCE=append` 한정 · 수동 분기 실행 = `GSM_CONTEXT_HEALTH_FORCE=1`. 매 Stop X = 분기 cadence(§4) · advisory 본질(= non-blocking · cycle 차단 X).
> **자동/수기 경계** = char 4 지표 + `stale_pointer` = **자동**(codepoint `python3` + 상대경로 .md file-link grep). `conflicting_sot` / `buried_ratio` / `ctx_실측(/context)`(= /context 실점유 값 · codepoint proxy char 보완) / `model_effort_전환수`(= 세션 중 model/effort 전환 사건 수 · 목표 0 · `cycle-discipline.md §12`) = **수기 advisory**(판정 자동화 난이도 ↑ 또는 세션 상태 → row 에 `manual` 표기 · 값은 §2/수기 갱신 · over-claim 금지 · DIET-2 T5).
> **⚠ proxy** = char = codepoint(token 아님 · 헤더 proxy band 라벨 정합). stale_pointer(auto) = file-link 존재 검증 한정(§-level anchor 검증 = manual · 자동 X).
> **위치 주의** = auto append 행은 file 말미(아래 §6 이후)에 `>>` 누적된다(= `cycle-health-log.md` 동일 패턴 · 분기 guard = `<!-- ch-auto YYYY-MM-DD -->` marker grep · 위치 무관). 본 §3.1 = schema 선언 면(= 누적 행은 EOF).

| 측정일 (KST) | parent_root | master | L0_kernel | child | stale_pointer(auto) | conflicting_sot | buried_ratio | ctx_실측(/context) | model_effort_전환수 | cycle | marker |
|---|---|---|---|---|---|---|---|---|---|---|---|

---

## §4. 측정 cadence + 유지

- **매 cli-infra cycle 마감 시**: 항상로드 char 영향 변경(헌법 §/L0 rule/자식 CLAUDE.md) 시 본 §2 갱신.
- **분기 정기 review**(= `cycle-discipline.md §18` · 1/6·4/6·7/6·10/6 부근): 4 char 지표 + 3 환각 지표 전량 재측정 + trajectory append.
  - **자동화**(= MASTER-CLI-GSM-CONTEXT-HEALTH-ABSORB-001 · 2026-06-04): [`measure-gsm-cycle.sh`](../.claude/hooks/measure-gsm-cycle.sh) context-health 블록이 **분기 guard**(quarter bucket 경과) 통과 시 char 4 + `stale_pointer`(auto)를 측정·surface(advisory) + `GSM_MEASURE_ENFORCE=append` 시 §3.1 append. 수동 분기 실행 = `GSM_CONTEXT_HEALTH_FORCE=1`(= new-cycle 게이팅 무관 즉시 평가 · 분기 guard 는 유지).
  - **수기 잔여**: `conflicting_sot` / `buried_ratio` = 판정 자동화 난이도 ↑ → master cycle 측 수기 §2 갱신(= `automation-policy.md` Inspection 수동 의무 정합).
- **§15 hot 재증식 자동 감시**(= MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001 · 2026-06-10): `measure-gsm-cycle.sh` 의 §15 hot check 가 새 master cycle commit 감지 시 hot entry 수 측정 → **> 10 도달 시 cold 재이전 advisory surface**(warn-only · trigger 수치 SoT = 본 file §2 행). 이전(demote) 실행·판정 = master cycle 수동(= COLD-002 전례 절차 · Inspection 수동 경계).
- **`stop-reflect.sh`**(= `cycle-discipline.md §19`) self-improving loop 이 buried/conflict 누적 감지 시 silent 후보 → 본 file 갱신 trigger.
- 유지 주체 = master cycle + 자동 surface(= 기존 GSM Stop hook 확장 · **신 hook 신설 X** · `automation-policy.md` Transport=측정/surface 자동 + Inspection=판정 수동 정합).

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
- 2026-06-04 · MASTER-CLI-GSM-CONTEXT-HEALTH-ABSORB-001 · context-health 측정 **자동화 흡수**(= 신 hook 신설 X · 기존 `measure-gsm-cycle.sh` GSM Stop hook 확장 · settings.json 무접촉). §3.1 분기 자동 측정 trajectory(append-only · quarter-bucket guard · idempotent) 신설 + §4 cadence 에 자동화/수기 경계 명문화. 자동 범위 = char 4(codepoint) + `stale_pointer`(file-link grep) · 수기 잔여 = `conflicting_sot`/`buried_ratio`(판정 난이도 ↑). hook = 5-repo byte-identical 전파(= context-health 블록 포함) · 본 file(append 대상) = master-only(propagation X 유지). 지표 정의(§1) + Phase 0~4 trajectory(§3) 무변경(= 자동화 면만 추가). proxy band 라벨 보존(over-claim 금지).
- 2026-06-10 · MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001 · ① §15 hot 6회차 cold 재이전(14→5+본 cycle entry · cold 94→103 verbatim · 무손실) ② **§15 hot 재증식 자동 감시** = `measure-gsm-cycle.sh` §15 hot check 확장(> 10 시 advisory surface · 신 hook 신설 X · settings.json 무접촉 · ABSORB-001 동형) ③ 자식 4 CLAUDE.md §15 박제 → master cold pointer 후퇴(19,260→9,581 cp · 6 entry cold verbatim 기포함 확인) ④ cycle-discipline §23~§29 pointer 후퇴(§21/§22 보존 · 43,819→36,866 cp) ⑤ §22.2 확장/이동 cycle 마감 dual grep sweep gate 1행. §2 측정값 갱신(master/child char + §15 hot 6) · §4 cadence §15 자동 감시 1줄 추가.
- 2026-07-10 · MASTER-CLI-CONTEXT-DIET-2-001 · rule 코어 다이어트 T1~T8 (= cc-paste-MASTER-CONTEXT-DIET2-001 · 정보 소실 0 · verbatim diff 4/4 + 표본 grep 15/15). §2 재측정: cycle-discipline hot 9,854 cp (전문 = `cycle-discipline-COLD.md`) · intake 정독 = `rule-routing-table.md` 2,867 cp 신설 (index 전문 = 색인 갱신 한정 · §B/§F 원문 = `rule-routing-index-COLD.md`) · PLAN/REVIEW 스키마 = `docs/templates/` 이전 (Risk≥Medium 시만 Read) · abbreviation-policy 의무 로드 제외 · **T5 L0 재정독 개정 = per-cycle L0 파일 재Read 실효 0** (세션 최초 1회 + hook/경량 실측 갈음 · STOP #5 불변) · Mode 1 가정 정독 합계 235,005→145,199/107,180 byte (−38%/−54%). master 47,004 cp = **§15 hot 13 > 10 advisory 발화 상태** (9회차 demote = 별 cycle 후보). rule 26 편집 + 신설 4 (table/footer-common/템플릿 2) 6-repo propagation · COLD 2 = master-only.
- 2026-07-10 · MASTER-CLI-CONTEXT-DIET-2-002 · §3.1 context-health 블록 실측 열 2 신설 (= `ctx_실측(/context)` /context 실점유 값 기록 자리[codepoint proxy 보완] + `model_effort_전환수` 세션 중 model/effort 전환 사건 수 M[목표 0] · 둘 다 수기 advisory · `measure-gsm-cycle.sh` context-health printf/surface/comment 동기 · 신 hook X · 신 hot anchor X · ABSORB-001 동형 확장). hook = 6-repo byte-identical 전파(context-health 블록 포함) · 본 file(header/§3.1 doc/§6) = master-only(propagation X). §2 측정값 무변경(= schema 면만 확장 · 기존 auto-row[2026-06-04] = 10-col 히스토리 보존 · 신 row = 12-col).
| 2026-06-04 14:01 | 8000 | 52652 | 25730 | 19260 | 0 | manual | manual | MASTER-CLI-WORKFLOW-ADOPTION-POLICY-002 | <!-- ch-auto 2026-06-04 --> |
