# Cross-Repo Parallel Execution Paradigm SoT

> **단일 목적**: 단일 cli session 측 cross-repo (= 4-repo · master + app-foundation + gently-product-docs + Selfward · 동결 3[GB/GD/GT] = 전파 대상 X · 쓰기 0) 자식 병렬 실행 paradigm + 다중 cli session 운영 paradigm 양쪽 분기 + cli session 자율 판단 영역 + 자식별 cwd 분리 + cross-repo 정합 처리 paradigm 통합 SoT.
> **신설**: MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001 (2026-05-19).
> **연관 파일**:
> - 부모 mount root `CLAUDE.md` (= `/Users/yundonghyeon/AndroidStudioProjects/CLAUDE.md` · cli session 진입 baseline) §3 cli session 진입 paradigm 분기
> - `.claude/agents/active/cross-repo-orchestrator.md` (= §FREEDOM · cross-repo routing sub-agent)
> - `.claude/agents/active/intake-router.md` (= 단일 repo routing paradigm baseline)
> - `docs/rules/routing-and-delegation.md` §실행 방식 규칙 (= cross-repo sub-section)
> - `docs/rules/cycle-discipline.md` §21 (= cross-repo cycle 영역)
> - `docs/rules/reporting.md` §9 (= Subagent Return Contract · sub-agent 결과 통합 paradigm 정합)
> SOT: `CLAUDE.md`

---

## 1. 본 rule SoT 본질

본 rule = **cross-repo (= 4-repo) 측 cli session 운영 paradigm 단일 reference**. 단일 cli session 측 sub-agent 측 fan-out paradigm + 다중 cli session 운영 paradigm 양쪽 분기 명시 default.

본 paradigm 핵심 본심 = **cli session 측 자율 판단 default** (= 요청사항 본질 측정 후 paradigm 선택 default · 사용자 본심 정합 = "양쪽 모두 가능한데 요청사항에 따라서 claude code cli 가 판단해서 일을 처리").


## 2. paradigm 분기 (= kernel 요약 · 본문 = detail file)

> **H4 demote** (`MASTER-CLI-CONTEXT-OPT-PHASE3-L0-CHILD-DEDUP-001` · 2026-06-01): cross-repo 실행 paradigm **본문**(영역 1/1.5/2/3 + dispatch + 경계 + 자식별 cwd 분리 + sub-agent token cost + 정합 처리)은 behavior-triggered 로 demote → [`cross-repo-parallel-exec-detail.md`](../../docs/rules/cross-repo-parallel-exec-detail.md) (= cross-repo 행동 진입 시 정독 · `rule-routing-index.md §B` Reading Mode 6). 본 kernel = 항상-on L0 (= 아래 §2.4 subscription/billing guard + 단방향 propagation + 영역 1/1.5/2/3 1-줄 요약). 선택 본심 = cli session 자율 (= 요청 본질 측정 후 영역 1 vs 영역 2).

- **영역 1** (= 단일 cli session 측 Task tool sub-agent fan-out): 가벼운 cross-repo 측정(sha / source grep / cross-verify) · 권장 ≤ 3 sub-agent · interactive pool. → detail §2.1 · §3 (자식별 cwd 분리) · §3.4 (sub-agent token cost) · §4 (정합 처리).
- **영역 1.5** (= git worktree 격리 · within-repo 병렬): 같은 repo 안 동시 2+ workstream + propagation cycle 중 별도 master cycle 격리 (= worktree dir = repo 외부 + `wt/<cycle-id>` branch + self-clean 의무 · `git worktree prune` 자동 실행 금지) · interactive pool 정합 (= 영역 3 무관) · 영역 2 대체 X. **★같은 repo 병렬 = 「의무」** (2026-07-26 D-2 승격 · 구 "가능" 폐기) — **공유 자원은 file 이 아니라 `git index`**(repo 당 1개 · `add`→`commit` 비원자적)이므로 **file 겹침 0 이어도 격리 없이 병렬 금지**. → detail §2.1.5 (= 유일 본문 canonical) + §2.1.6 (= 판정 기준 정정 본문).
- **영역 2** (= 다중 cli session 운영 · **권장 default**): 실 IMPL / 자식 cli infra 정합 / 자식별 무거운 IMPL · 사용자 본인 terminal × N · interactive pool. → detail §2.2 · §2.2.1 (dispatch checklist) · §2.2.2 (dispatch ≠ fan-out 경계).
- **영역 3** (= `claude -p` sub-process spawn): **회피 default** (= 아래 §2.4 · Agent SDK credit pool 별 영역 · full API rate · roll over X · 요금 폭탄 risk). → detail §2.3 (paradigm 선택 본심).
- **동족 구현 정합** (= 같은 맥락 2+ repo 구현 결과의 advisory 비교 층 · paste-back 회수 시점): cli-infra byte-identical 강제(= A4)도 정확성 cross-verify(= detail §4.1)도 아닌 사후 surface · 도메인 자율(= detail §4.2/§4.3) 위 advisory · **auto-converge 금지**. → detail §4.4 (= 유일 본문 canonical) · surface 형식·발행 위치 = `reporting.md §14`.

> **단방향 propagation (A4 · 항상-on)**: cli infra = master 단방향 propagation + 4-repo byte-identical · 자식 직접 수정 금지 (= master `CLAUDE.md §3 + §4` · `cycle-discipline.md §15` 패턴 1). cross-repo 정합 처리 본문 (= sub-agent return 통합 §4.1 + sha 비교 §4.2 + drift mitigation §4.3) = detail §4.

### 2.4 Subscription-aware paradigm (= 2026-06-15 Anthropic billing split 정합 · `MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001` 신설)

> **본 sub-section = 2026-06-15 적용 default Anthropic billing split 영역 본문 + `claude -p` 사용 회피 paradigm 명시 default**. 본 paradigm 정합 의무 = 영역 1 + 영역 2 + 영역 3 분기 본문 측 billing 영역 정합 측정 default.
> ⚠ **"2026-06-15 billing split" 서술 = 공식 근거 UNVERIFIED** (2026-07-10 공식 문서 전수 조회 미발견 · 현행 공식 = 전 표면 구독 합산). **행동 규정 불변** — `claude -p` 회피 · 영역 1/2 = interactive · sub-agent ≤ 3 (MASTER-CLI-CONTEXT-DIET-2-001 T7 · 본 § 하위 표 서술 동일 적용).

**2026-06-15 Anthropic billing split 본질**:

| pool | 적용 영역 | 요금 paradigm | 본 cycle 측 권장 |
|---|---|---|---|
| **interactive pool** (= 변경 X) | `claude` 단순 interactive 진입 (= terminal 측 `claude` 호출 default) | subscription 요금 정합 default ✓ (= $20 Pro / $100 Max 5x / $200 Max 20x · weekly limit 영역 default) | **영역 1 + 영역 2 정합** (= 권장 paradigm) |
| **Agent SDK credit pool** (= 신 영역) | `claude -p` sub-process spawn + Agent SDK 호출 + GitHub Actions + 3rd-party agents | 별 monthly credit pool + **full API rate** (= subscription 요금 외 영역) + **roll over X** default | **영역 3 = 회피 default** (= 요금 폭탄 risk default) |

**`claude -p` 사용 회피 paradigm**:

- 본 paradigm 측 영역 3 (= `claude -p` sub-process spawn) paradigm **회피 default** (= 2026-06-15 이후 별 credit pool 측 full API rate 적용 default)
- 사용자 본인 측 cli session 진입 paradigm = **`claude` interactive default** · `-p` flag **미사용 default**
- cli session 측 자율 sub-process spawn paradigm **회피 default** (= Bash 측 `claude -p` 호출 의도적 회피 default)
- 단 별 영역 정합 (= cli session 자체 측 `claude -p` Bash 호출 X) = main agent 측 Bash deny list 정합 default + 사용자 본인 측 의무 default

**권장 paradigm 본질** (= 본 §2.4 정합 default):

| 요청사항 본질 | 권장 paradigm | 본질 |
|---|---|---|
| 가벼운 cross-repo 측정 (= sha 측정 / source grep / cross-verify) | **영역 1** (= Task tool sub-agent fan-out · 단일 cli session) | interactive pool 정합 default · main agent context 단일 default |
| 실 IMPL / 자식 cli infra 정합 (= 자식 도메인 source / cli infra propagation cycle) | **영역 2** (= 다중 cli session · 권장 default) | interactive pool 정합 default · 자식 cli infra 자동 정합 default |
| 단일 자식 무거운 IMPL (= 다른 자식 무접촉) | **영역 2** (= 단일 자식 cli session 진입) | interactive pool 정합 default · context 단일 자식 집중 default |
| 자동화 영역 (= `claude -p` sub-process spawn / Agent SDK 호출) | **영역 3 = 회피 default** | Agent SDK credit pool 측 별 영역 default · 요금 폭탄 risk default |

**공식 reference**:

- Anthropic 공식 announce (= 2026-06-15 적용 default · Claude Code subscription pricing change 영역)
- search keyword: "Claude Code Max plan subscription pricing change 2026" / "Agent SDK credit pool June 15" / "claude -p print mode subscription policy"
- 측정 시점 = 2026-05-19 KST (= `MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001` cycle 진입 시점)

### 2.4.1 Workflow 도구 subagent pool 귀속 (= kernel pointer)

`Workflow` 도구(dynamic workflows) subagent = interactive plan pool 귀속 (= 영역 3 `claude -p` 아님 · A6 정합). 채택 가부 + gate 실측 + 토큰 예산 통제 본문 단일 SoT = [`workflow-policy.md`](../../docs/rules/workflow-policy.md).


## 5. STOP 조건 (= cross-repo 영역 한정)

> **본 §5 = pointer 영역 default**. 본문 단일 SoT = [`stop-canonical.md`](./stop-canonical.md) (= 9 STOP 항 default · cross-repo HIGH RISK 도메인 진입 = STOP #7 default · 보호 5 file sha drift = STOP #5 default · 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` 로 master `CLAUDE.md §5` 에서 이동). 본 § 본문 변경 시 = master cycle 신설 + 4-repo propagation 의무 default.

## 6. paradigm 호출 trigger 영역

### 6.1 본 rule reading 의무 trigger

사용자 요청사항 측 다음 키워드 / 본질 발견 시 본 rule reading 의무:

| 키워드 | 한국어 + 영어 |
|---|---|
| repo 측 영역 (현행) | `4-repo` / `4-active` / `전파 자식 3` / `FND + PDOCS + SW` / `동결 계승 원천` / `자식별` / `다중 repo` |
| repo 측 영역 (구 판 · 이력 인용 trigger 보존) | `6-repo` / `5-repo` / `3 자식` / `GB + GD + GT` |
| paradigm 영역 | `cross-repo` / `fan-out` / `병렬` / `parallel` / `동족 자식` |
| 영역 영역 | `propagation` / `byte-identical` / `cli infra 4-repo` / `master + 자식 3` |

### 6.2 본 rule reading skip default trigger

다음 영역 = 본 rule reading skip default (= 자식 측 reading order 정합 default):
- 단일 자식 영역 cycle (= 단일 도메인 측 IMPL / 검증 / 리뷰 cycle)
- 자식 측 local override 영역 (= `.claude/settings.local.json` / `.ai/tasks/` 등)
- 자식 측 도메인 source 측 변경 (= app/ + composeApp/ + core/ 등 영역)

## 7. 본 rule 의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](./rule-footer-common.md) (= 4-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).
## 8. 명시 cycle 이력

> 전문 (9 entry · 5,326B) = `claude-cli-master/.auto-memory/cross-repo-parallel-exec-COLD.md` verbatim (= 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` demote · 삭제 0 · **master only · propagation X** = 자식 판에는 부재가 정상). 본 rule = 자동 주입층이라 이력이 매 세션 상주할 이유가 없다.
