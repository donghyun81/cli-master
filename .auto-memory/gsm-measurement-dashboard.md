# GSM Measurement Dashboard — anchor G/S/M + cycle 건강 종합 view

> **단일 목적**: GSM 계측 layer 의 4 Metric family 를 한 화면으로 모은 종합 view. anchor(A1~A10) M 목표 + 행동 7종 + context 건강 + cycle 건강(DORA) 을 pointer 로 모으고, 현재 스냅샷을 둔다. 본문 측정값의 단일 SoT 는 각 source file (= 본 view 는 복제 X · 요약 + pointer).
> **신설**: MASTER-CLI-GSM-MEASUREMENT-LAYER-001 (2026-06-02 · M5 cli-infra-ops).
> **위치**: master only (`.auto-memory/` · propagation X · audit memory). canonical form = [`gsm-measurement.md`](../.claude/rules/gsm-measurement.md).
> SOT: `CLAUDE.md`

---

## §1. anchor family (A1~A10 · M 목표 · 본문 = `anchor-list.md`)

> 각 anchor 의 G/S/M 본문 = `.claude/rules/anchor-list.md`. 아래 = M(정량 지표) 목표 요약.

| anchor | 우선순위 | M (정량 지표 · 목표) |
|---|---|---|
| A1 baseline drift | P0 | baseline mismatch 미reconcile `= 0` |
| A2 보호 file 무결성 | P0 | 보호 5 sha drift `= 0` |
| A3 scope expansion | P0 | scope-외 신규 변경 file `= 0` |
| A4 단방향 propagation | P0 | 자식 cli infra drift `= 0` · verify-sync exit 0 |
| A5 disk 실측 | P0 | 미검증 추천 `= 0` · stale 후보 `= 0` |
| A6 subscription pool | P0 | `claude -p` spawn `= 0` · sub-agent `≤ 3` |
| A7 filename+content grep | P1 | filename-only STOP 분류 `= 0` |
| A8 paradigm autonomy | P1 | 본심 분기 미측정 진입 `= 0` |
| A9 도메인 SoT 정독 | P1 | 키워드 발견 후 SoT 미정독 `= 0` |
| A10 책임 경계 | P1 | 경계 침해 `= 0` |

---

## §2. 행동 family (Reading Mode 7종 · 본문 = `rule-routing-index.md §C`)

> G/S/M 3-tuple 본문 = `.claude/rules/rule-routing-index.md §C`. 7 행동(구현형 / UI-UX형 / API-서버형 / 빌드-릴리즈형 / 정책-계획 / CLI 운영 / task 재개) 각각 G/S/M + deviation. 게이트(enforce=warn · ROI-coverage · 보호 sha 0 등) = §C M 열 보존.

---

## §3. context 건강 family (program-level · 본문 = `context-health-metrics.md`)

> 측정값·trajectory 본문 = `.auto-memory/context-health-metrics.md` (= GSM §0 귀속). 최근 측정(2026-06-01 Phase 4):

| 지표 | 값 | 목표 |
|---|---|---|
| parent root CLAUDE.md char | 8,000 | (proxy · trajectory ↓) |
| master CLAUDE.md char | 25,392 | (proxy) |
| L0 kernel char | 21,561 | (proxy) |
| 자식 CLAUDE.md char | 19,260 | (proxy) |
| `stale_pointer` | 0 | 0 |
| `conflicting_sot` | 1 (defer) | 최소화 |

> ⚠ char = codepoint proxy(token 아님). 다음 분기 review 시 재측정(`cycle-discipline §18`).

---

## §4. cycle 건강 family (DORA 4-key · 본문 = `cycle-health-log.md`)

> DORA 4-key 정의 = `gsm-measurement.md §3`. 정량 append 본문 = `.auto-memory/cycle-health-log.md` (= `measure-gsm-cycle.sh` Stop hook surface). 최근 측정 = 해당 log 마지막 entry 참조.

| key | 최근 (= cycle-health-log.md 참조) |
|---|---|
| Deployment frequency | log 참조 |
| Lead time | log 참조 |
| Change failure rate | log 참조 |
| MTTR | log 참조 |

---

## §5. cadence + 유지

- **매 cli-infra cycle 마감**: anchor/행동 M 위반 발견 시 해당 source file 갱신 + 본 view 요약 동기.
- **분기 review** (`cycle-discipline §18`): context 건강 + cycle 건강 family 전량 재측정 + 본 view 갱신.
- **Stop hook** (`measure-gsm-cycle.sh`): cycle 건강 DORA proxy surface(advisory) → cycle-health-log append.
- 유지 주체 = master cycle (자동 file 신설 X · `automation-policy.md` Inspection 수동 정합). 본 view = master-only(전파 X).

---

## §6. cycle 이력

- 2026-06-02 · MASTER-CLI-GSM-MEASUREMENT-LAYER-001 · 본 view 신설(= 4 Metric family 종합 + anchor M 요약 + context/cycle 건강 pointer). master-only(propagation X).
