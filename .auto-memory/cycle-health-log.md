# Cycle Health Log — DORA 4-key 정량 append (GSM cycle 건강 Metric family)

> **단일 목적**: 운영 흐름 건강(DORA 4-key) 의 cycle 단위 정량 기록. `measure-gsm-cycle.sh`(Stop hook) 가 새 master cycle 마감 감지 시 한 행 append(= `GSM_MEASURE_ENFORCE=append`). DORA 4-key **정의** 단일 SoT = [`gsm-measurement.md §3`](../.claude/rules/gsm-measurement.md).
> **신설**: MASTER-CLI-GSM-MEASUREMENT-LAYER-001 (2026-06-02 · M5 cli-infra-ops).
> **위치**: master only (`.auto-memory/` · propagation X · `*-COLD.md` / `context-health-metrics.md` 동급 audit memory).
> **⚠ proxy 주의**: 아래 값 = `git log` 측 **coarse proxy**(= master commit subject 의 cycle/task ID 토큰 dedup · revert commit 수). 정밀 cycle-close 측정 아님 · token/정확 cadence over-claim 금지(`context-health-metrics.md §⚠` 정합). 판정·amend = 수동(`gsm-measurement.md §4·§6`).
> SOT: `CLAUDE.md`

---

## §1. schema (= measure-gsm-cycle.sh append 형식)

| 컬럼 | 의미 | source |
|---|---|---|
| 시각 KST | append 시각 (또는 entry baseline) | hook NOW / 수동 |
| cycle | cycle ID (commit subject 의 cycle-marker) | `git log -1 %s` grep |
| HEAD | master HEAD short-12 (= idempotent guard key) | `git rev-parse --short=12` |
| Deployment freq | distinct cycle/task ID 수 (7d/주 · 30d) — **coarse proxy** | `%s` grep+dedup |
| Lead time | 최근 2 cycle-marker commit 간격(h) — **coarse proxy** | commit ts gap |
| Change failure | revert/rollback/hotfix commit 수 (30d) — proxy | subject grep |
| MTTR | 결함→복구 경과 (정성 = incident-log 수동) | pointer |

> DORA 정의 본문 = `gsm-measurement.md §3`. 본 log = 그 4-key 의 정량 append 면. Goodhart 경계(§0) — 수치는 흐름 신호이지 목표가 아님.

---

## §2. 측정 기록 (append-only · 최신 = 마지막 행)

| 시각 KST | cycle | HEAD | Deployment freq | Lead time | Change failure | MTTR |
|---|---|---|---|---|---|---|
| 2026-06-02 (entry baseline) | MASTER-CLI-GSM-MEASUREMENT-LAYER-001 | `35019486394a` | 30/주 (30d 102) | n/a (entry) | revert 0 (30d) | incident-log 참조 |

> entry baseline = GSM 계측 layer 신설 진입 시점 측정(= 박제 HEAD `3501948639…`). 본 cycle 마감 commit 후 HEAD 변경 → 다음 Stop 시 hook 이 새 cycle 감지(advisory surface · append 는 `GSM_MEASURE_ENFORCE=append` 시).

---

## §3. cadence + amend 연결

- **append cadence**: cycle 단위(= 새 master cycle commit 감지 시 1행 · turn 단위 X · idempotent HEAD guard). 기본 hook mode = advisory(surface only) · append = `GSM_MEASURE_ENFORCE=append`.
- **분기 review** (`cycle-discipline §18`): 본 log 추세 검토 + `gsm-measurement-dashboard.md §4` 동기.
- **amend 정량 trigger** (`gsm-measurement.md §6`): 동일 지표가 N(기본 3) cycle 연속 deviation → amend 후보(= `stop-reflect.sh` 임계 정합 · 게이트 X). 수동 판정.

---

## §4. cycle 이력

- 2026-06-02 · MASTER-CLI-GSM-MEASUREMENT-LAYER-001 · 본 log 신설(= DORA 4-key schema + entry baseline 1행) + `measure-gsm-cycle.sh` Stop hook 배선. master-only(propagation X).
