# Workflow adoption policy (= dynamic workflows 전면 미정 → 조건부 허용)

> 본 file = 5-repo 측 `Workflow` 도구(dynamic workflows) 채택 정책 단일 SoT. 판단 기준 + gate 실측 + 토큰 예산 통제의 유일 본문.
> 위치 = `claude-cli-master/.claude/rules/workflow-policy.md`
> 신설: `MASTER-CLI-WORKFLOW-ADOPTION-POLICY-002` · 2026-06-04
> 본질: `MASTER-CLI-WORKFLOW-SUBAGENT-BILLING-GUARD-001`(2026-06-04) 이 `cross-repo-parallel-exec.md §2.4.1` 에 정착시킨 gate ① + 토큰 예산 통제 본문을 별 rule 로 교정 이관(유실 0) + 채택 정책 전반 완성.
> 계층: L1 (프로세스·워크플로우) · `rule-routing-index.md §A L1` + `§B` Reading Mode 5(정책-계획 점검형) 정합. 채택 가부 판정 시점 consult.
> SOT: `CLAUDE.md`

---

## §1. 본질 (= 전면 미정 → 조건부 허용 전환)

`Workflow` 도구(dynamic workflows)는 Anthropic 이 2026-06-02 출시한 research preview 기능이다. 신생 영역이라 채택 가부가 전면 미정이었다. 본 file 은 그 미정 상태를 **조건부 허용**으로 전환한다 — `plugin-policy.md` 와 동족 paradigm(전면 회피도, 무조건 허용도 아님).

조건부 허용의 근거 = 2026-06-04 gate 실측 PASS(§2). dynamic workflow 가 spawn 하는 subagent 가 영역 1·2 와 동일한 interactive pool 에 귀속하고, 영역 3(`claude -p` sub-process)과 구분된다는 실측이 확인됐다.

---

## §2. gate 실측 기록 (= 2026-06-04 KST baseline)

### gate ① — pool 귀속 (/usage 실측)

- `Workflow` 도구로 spawn 한 subagent 는 /usage 의 "Subagents: workflow-subagent" 항목으로 집계되며 **interactive plan pool 에 귀속**한다 (2026-06-04 KST 실측 · 별 Agent SDK credit pool 표기 0). 영역 1·2 와 동일 pool 정합이고, 영역 3(`claude -p` sub-process spawn)과는 다르다 — **`Workflow` 도구 subagent 는 영역 3 이 아니다**.
- **2026-06-15 Anthropic billing split 발효 후 /usage 1회 재확인 의무**. 현 실측 = split 이전 baseline · split 후 pool 귀속이 바뀌면 본 file 갱신 cycle 진입.

### gate ② — 버전 + 활성화 전제 (실측)

- 버전 = `claude --version` 2.1.156 PASS (= `Workflow` 도구 가용).
- 활성화 전제 실측 발견: **plan 별 default 가 다르다**. Pro = OFF → `/config` "Dynamic workflows" 수동 활성화 필요.
- **ultracode 키워드 = trigger 보장 아님**. trivial task 는 Claude 재량으로 일반 턴 처리되고, fan-out 형태를 명시한 시점에만 trigger 된다.

### gate ③ — 예산 본심

- 토큰 예산 본심 = 200k hard cap (통제 절차 = §4.2).

---

## §3. 허용 영역 (= 고가치 cycle)

조건부 허용의 적용 권장 영역:

- **rule-adherence 검증** — STOP 9 + anchor 10 + 보호 5종 준수 검증 fan-out.
- **cross-repo fan-out 측정 / cross-verify** — 영역 1 sub-agent 강화 (sha 측정 / source grep / cross-verify).
- **audit / triage 형 고가치 cycle** — `TESTING-BACKFILL-AUDIT` R1~R6 loop-until-done 후보 류.

---

## §4. 회피 영역 + 토큰 예산 통제

### §4.1 회피 영역

- 일상 코딩 cycle.
- 도메인 IMPL.
- 공식 경고 영역 — "regular coding tasks don't need it".

### §4.2 토큰 예산 advisory 한계 + 200k hard cap 4-step

- "use Nk tokens" 류 예산 지시는 **advisory** 일 뿐 도구 차원의 강제가 없다 (2026-06-04 실측: 10k 지시 → workflow subagent 79.6k 실소비).
- 200k hard cap 통제 4-step:
  - (a) agent prompt 에 예산 명시
  - (b) `/workflows` 실시간 감시
  - (c) 초과 징후 시 수동 stop (`TaskStop`)
  - (d) 전면 fan-out 전 소규모 슬라이스 선행 측정
- 실 고가치 워크플로 실측이 누적되면 200k 상한 보정을 허용한다.

### §4.3 contract 내 보존 의무

- 워크플로 contract 내에서 보호 5종 + STOP 9 보존 의무.
- 워크플로 저장 시 skill 배포 경로를 따른다 (v16 bundled skill · `.claude/skills/`).

---

## §5. A6 subscription 경계 (= 요금 폭탄 차단)

- interactive pool 귀속은 weekly limit 잠식에 주의한다 (영역 1·2 와 동일 pool 분배).
- 영역 3(`claude -p` sub-process spawn / Agent SDK credit pool) 회피 원칙은 불변이다. 그 본문 = `cross-repo-parallel-exec.md §2.4` 단일 SoT 이며 본 file 은 중복하지 않고 가리킨다.
- `anchor-list.md` A6(subscription pool integrity) 정합.

---

## §6. 단일 SoT 정합

- 본 file = `Workflow` 도구 채택 정책 + gate 실측 + 토큰 예산 통제의 유일 본문.
- `cross-repo-parallel-exec.md §2.4.1` = 본 file pointer 만 보유한다 (kernel 1줄 잔존 · 본문 중복 금지).
- 기준 변경 시 = 본 file 단일 변경 + 5-repo byte-identical propagation.

---

## §7. 인접 paradigm 정합

- `cross-repo-parallel-exec.md §2.4`(subscription-aware · 영역 3 회피 · 2026-06-15 billing split) + `§2.4.1`(본 file pointer)
- `plugin-policy.md` (동족 조건부 허용 policy paradigm · §4 subscription 경계)
- `automation-policy.md §4` (sub-agent spawn 통제 · 영역 1 ≤ 3 · 영역 3 회피)
- `anchor-list.md` A6 (subscription pool integrity)
- `mode-system.md` (동급 policy paradigm rule)

---

## §8. 변경 정책

- cli infra 권장 byte-identical (5-repo · master + 4 자식 · 보호 5종 아님).
- 변경 시 master cycle 신설 + 5-repo propagation (`cycle-discipline.md §15` 패턴 1).
- 자식 repo 직접 수정 금지.

---

## §9. cycle 이력

- 2026-06-04 · `MASTER-CLI-WORKFLOW-SUBAGENT-BILLING-GUARD-001` · `cross-repo-parallel-exec.md §2.4.1` 신설(gate ① pool 귀속 + 토큰 예산 통제 4-step 외화) = 본 file 본문의 이관 원천.
- 2026-06-04 · `MASTER-CLI-WORKFLOW-ADOPTION-POLICY-002` · 본 file 신설. §2.4.1 본문 전부 이관(유실 0) + 채택 정책 전반 완성(§1 본질 + §2 gate 실측 3 + §3 허용 영역 + §4 회피 영역·토큰 예산 통제 + §5 A6 경계). 동반: `cross-repo-parallel-exec.md §2.4.1` = 1줄 pointer 환원(kernel de-bloat · H4 정합) + `rule-routing-index.md §A/§B/§F` 배선 + 5-repo byte-identical propagation.
