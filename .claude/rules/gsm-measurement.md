# GSM Measurement — Goal → Signal → Metric canonical form (계측 layer 단일 SoT)

> **단일 목적**: 6-repo cli infra 의 **측정 가능 목표**를 표현하는 canonical 3-tuple form(Goal–Signal–Metric) + 측정 layer(anchor / 행동 / context-health / cycle-health) 의 단일 기준. 흩어진 측정 인접 자산(anchor-list A1~A10 · `rule-routing-index §C` 행동 7종 · `context-health-metrics`)이 본 form 에 **정합**한다.
> **신설**: MASTER-CLI-GSM-MEASUREMENT-LAYER-001 (2026-06-02 · M5 cli-infra-ops · v2 realign-oriented).
> **계층**: L1 (프로세스·워크플로우) — `rule-routing-index.md §A L1` 등록. 계측·amend 시점 consult.
> **본 form 정합 자산 (pointer · 본문은 각 file 단일 SoT)**:
> - [`anchor-list.md`](./anchor-list.md) — anchor A1~A10 의 G/S/M 3-tuple
> - [`rule-routing-index.md`](./rule-routing-index.md) §C — 행동 7종(Reading Mode) 의 G/S/M
> - [`../../.auto-memory/context-health-metrics.md`](../../.auto-memory/context-health-metrics.md) — context 건강 Metric family
> - [`../../.auto-memory/cycle-health-log.md`](../../.auto-memory/cycle-health-log.md) — DORA 4-key Metric family
> - [`../../.auto-memory/gsm-measurement-dashboard.md`](../../.auto-memory/gsm-measurement-dashboard.md) — 종합 view
> SOT: `CLAUDE.md`

---

## §0. 본질 — 왜 GSM 인가

cli infra 는 "무엇을 지켜야 하는가"(목표)를 가지고 있었으나, 그 목표가 **관측 가능한 신호**와 **정량 지표**로 분해돼 있지 않았다. 목표만 있으면 "지켰는지" 판정이 주관에 의존한다. GSM 은 목표 한 겹을 세 겹(의도 → 신호 → 지표)으로 펼쳐 판정을 객관화한다.

본 layer 는 새 게이트를 만들지 않는다. 이미 흩어져 있던 목표(anchor·행동·context-health)를 **같은 form 으로 정렬**해 닫힌 loop(목표 → 신호 → 지표 → 측정 → amend)를 완성하는 것이 전부다.

두 경계를 항상 지킨다:

- **Goal-first** — 측정하기 쉬운 지표부터 고르지 않는다. 목표를 먼저 적고, 그 목표를 드러내는 신호를 찾고, 마지막에 지표를 붙인다. 측정 편의가 목표 선정을 끌고 가는 streetlight effect 를 피한다.
- **Goodhart 경계** — 지표는 목표의 proxy 일 뿐이다. 지표가 목표를 대체하는 순간(지표 충족 = 목표 달성으로 착각) 측정은 왜곡된다. 지표가 의심스러우면 목표로 돌아가 신호를 다시 고른다.

---

## §1. canonical 3-tuple form

측정 가능 목표 하나 = **G + S + M** 세 줄.

| 요소 | 이름 | 본질 | 작성 규칙 |
|---|---|---|---|
| **G** | Goal (의도) | 무엇을 지키려는가 — 결과/상태 서술 | 측정값 없이 의도만. "…을 충족/유지/회피" |
| **S** | Signal (관측 신호) | 그 목표가 지켜지는지를 드러내는 관측 대상 | 어디를 보면 알 수 있는가 (file·grep·exit code·sha 등) |
| **M** | Metric (정량 지표) | 신호를 수치/이진으로 환원한 판정 기준 | 목표값 동반 (예: `= 0` · `≥ 13` · `존재` · `PASS`) |

작성 순서 = **G → S → M** (Goal-first 강제). M 부터 적으면 streetlight.

예 (anchor A2 · 보호 file 무결성):
- **G** — 보호 5 file 이 6-repo byte-identical 을 유지한다.
- **S** — 보호 5 file 의 sha-256 측정값 vs `protected-file-hashes.md` baseline 대조.
- **M** — sha drift 건수 `= 0` (목표).

3-tuple 은 본문을 복제하지 않는다. 각 자산(anchor·§C·context-health)은 자기 file 안에서 본 form 으로 G/S/M 을 적고, 본 file 은 form 의 규약과 가드레일만 소유한다(단일 SoT 중복 0 · `rule-routing-index §G` 정합).

---

## §2. Metric family 지도 (어디에 어떤 M 이 사는가)

| family | 측정 대상 | G/S/M 위치 (본문 SoT) | 전파 |
|---|---|---|---|
| **anchor** | 누락 시 cycle 실패하는 10 anchor(A1~A10) | `anchor-list.md` 각 anchor 의 G/S/M | 6-repo byte-identical |
| **행동(Reading Mode)** | 7종 행동별 목표·deviation | `rule-routing-index.md §C` | 6-repo byte-identical |
| **context 건강** | 항상로드 char + 환각 패턴(program-level) | `context-health-metrics.md` | master-only |
| **cycle 건강(DORA)** | 운영 흐름 4-key(아래 §3) | `cycle-health-log.md` | master-only |

행동·anchor family = 행동/진입 시점 측정(수동 의무 · `automation-policy.md` Inspection). context·cycle family = 정기/Stop 시점 측정(아래 §4).

---

## §3. DORA 4-key (cycle 건강 Metric)

운영 흐름 자체의 건강을 보는 4 지표. 본문 측정값 = `cycle-health-log.md`(master-only · 정량 append). 본 §은 정의 단일 SoT.

| key | 본 패키지 정의 | proxy source |
|---|---|---|
| **Deployment frequency** | 단위 시간당 마감 cycle 수 (master cycle / 주) | `git log` master cycle commit subject 빈도 |
| **Lead time** | cycle 진입 → 마감(commit) 까지 경과 | 진입 baseline ts → 마감 commit ts |
| **Change failure rate** | 마감 cycle 중 STOP/drift/리뷰 FAIL 비율 | REVIEW Verdict + 보호 sha drift + revert 비율 |
| **MTTR** | 결함(drift/STOP) 발견 → 복구(mitigation 마감) 경과 | incident-log / mitigation cycle 간격 |

본 4-key 는 **proxy** 다(Goodhart 경계 · §0). 수치 자체가 목표가 아니라 흐름 건강의 신호다. 게이트로 쓰지 않는다(advisory).

---

## §4. 측정 layer (자동 surface + 수동 판정)

| 구성 | 역할 | 위치 | 전파 |
|---|---|---|---|
| `measure-gsm-cycle.sh` | Stop hook · git log 에서 DORA proxy 산출 + surface(advisory) | `.claude/hooks/` | 6-repo byte-identical |
| `cycle-health-log.md` | DORA 4-key 정량 append(cycle 단위 · idempotent) | `.auto-memory/` | master-only |
| `gsm-measurement-dashboard.md` | anchor G/S/M + cycle 건강 종합 view | `.auto-memory/` | master-only |

**자동/수동 경계** (`automation-policy.md` 정합): git log 파싱 = 결정론적 산출 → Transport(자동 OK). 지표가 건강한가의 **판정** = Inspection(수동 의무). 따라서 hook 은 측정값을 surface/append 하되, 판정·amend 결정은 사용자/master cycle 영역으로 남긴다. hook 기본 = advisory(non-blocking · 새 blocking gate 신설 X · 사용자 본심).

---

## §5. 가드레일 (상위 5원칙 gate 정합)

GSM 자산은 비대·고변동이면 보류한다(`rule-routing-index §D` + RULE-ARCH 5원칙):

- **양 최소화** — G/S/M 각 1줄. anchor/§C 를 부풀리지 않는다.
- **변동성 회피** — 자주 바뀌는 수치를 M 에 박지 않는다(변동 잦으면 신호로 격하).
- **단일 SoT** — form 규약은 본 file 만. 자산은 본 form 을 따르되 규약을 복제하지 않는다.
- **Goodhart/streetlight** — §0 경계. 지표가 목표를 대체하거나, 측정 쉬운 것부터 고르는 징후 = 보류 + 본심 회수.

---

## §6. amend loop 정량 trigger

GSM 의 닫힌 loop 마지막 단계 = 측정 결과가 규칙 진화를 부른다. 정성 amend(`rule-routing-index §C` 하단 + `cycle-discipline §18`/`§19`)에 **정량 trigger** 를 더한다.

**trigger 규칙**: 동일 anchor 또는 행동의 M 이 **N cycle 연속 목표 미달(deviation)** 이면 amend 후보로 승격한다.

- 기본 N = **3** (= `stop-reflect.sh` paradigm 누적 임계 + `text-degeneration-prevention §3` M2 임계와 동일 결). 고변동 지표는 N 상향 가능.
- 승격 경로 = `stop-reflect.sh`(silent 후보 stderr) → `cycle-discipline §18` 분기 review → 사용자 confirm → master cycle 정착. **자동 신설 X**(`cycle-discipline §2` L1-1 예외 = 사용자 본심 외화 영역만).
- prototype: cowork memory `feedback_cli_paste_back_sha_self_report_drift`(4-cycle 추세) = 본 정량 trigger 의 첫 관측 패턴.

trigger 는 게이트가 아니다. "이 목표는 현재 규칙으로 안 잡힌다"는 신호를 누적해 사람이 판단하게 할 뿐이다(Inspection 수동 · §4).

---

## §7. STOP 조건 pointer

본문 단일 SoT = master [`CLAUDE.md §5`](../../CLAUDE.md) (= 9 STOP 항 canonical). GSM 관련 추가 회수 신호: realign 의미 약화(게이트 약화·deviation 삭제·고위험 목표 제거·anchor 우선순위 변경) · Goodhart/streetlight 징후 · 비대/고변동 = 보류 + 본심 회수(§5 정합).

---

## §8. 본 file 의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](./rule-footer-common.md) (= 6-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).

---

## §9. 명시 cycle 이력

- 2026-06-02 · MASTER-CLI-GSM-MEASUREMENT-LAYER-001 · 본 file 신설(canonical G/S/M form + Metric family 지도 + DORA 4-key + 측정 layer + 가드레일 + amend 정량 trigger). 동반 realign: `anchor-list.md` A1~A10 G/S/M 외화 + `rule-routing-index.md §C` 행동 7종 G/S/M 재구성(의미 보존) + §A 등록 + `context-health-metrics.md` Metric family 재위치. 측정 layer: `measure-gsm-cycle.sh`(Stop hook) + `cycle-health-log.md`(DORA · master-only) + `gsm-measurement-dashboard.md`(master-only) + `settings.json` Stop 배선. 5-repo byte-identical propagation(cli infra) · .auto-memory 3 file = master-only.
