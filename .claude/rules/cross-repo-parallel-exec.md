# Cross-Repo Parallel Execution Paradigm SoT

> **단일 목적**: 단일 cli session 측 cross-repo (= 6-repo · master + app-foundation + GB + GD + GT + gently-product-docs) 자식 병렬 실행 paradigm + 다중 cli session 운영 paradigm 양쪽 분기 + cli session 자율 판단 영역 + 자식별 cwd 분리 + cross-repo 정합 처리 paradigm 통합 SoT.
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

본 rule = **cross-repo (= 6-repo) 측 cli session 운영 paradigm 단일 reference**. 단일 cli session 측 sub-agent 측 fan-out paradigm + 다중 cli session 운영 paradigm 양쪽 분기 명시 default.

본 paradigm 핵심 본심 = **cli session 측 자율 판단 default** (= 요청사항 본질 측정 후 paradigm 선택 default · 사용자 본심 정합 = "양쪽 모두 가능한데 요청사항에 따라서 claude code cli 가 판단해서 일을 처리").


## 2. paradigm 분기 (= kernel 요약 · 본문 = detail file)

> **H4 demote** (`MASTER-CLI-CONTEXT-OPT-PHASE3-L0-CHILD-DEDUP-001` · 2026-06-01): cross-repo 실행 paradigm **본문**(영역 1/1.5/2/3 + dispatch + 경계 + 자식별 cwd 분리 + sub-agent token cost + 정합 처리)은 behavior-triggered 로 demote → [`cross-repo-parallel-exec-detail.md`](../../docs/rules/cross-repo-parallel-exec-detail.md) (= cross-repo 행동 진입 시 정독 · `rule-routing-index.md §B` Reading Mode 6). 본 kernel = 항상-on L0 (= 아래 §2.4 subscription/billing guard + 단방향 propagation + 영역 1/1.5/2/3 1-줄 요약). 선택 본심 = cli session 자율 (= 요청 본질 측정 후 영역 1 vs 영역 2).

- **영역 1** (= 단일 cli session 측 Task tool sub-agent fan-out): 가벼운 cross-repo 측정(sha / source grep / cross-verify) · 권장 ≤ 3 sub-agent · interactive pool. → detail §2.1 · §3 (자식별 cwd 분리) · §3.4 (sub-agent token cost) · §4 (정합 처리).
- **영역 1.5** (= git worktree 격리 · within-repo 병렬): 같은 repo 안 동시 2+ workstream + propagation cycle 중 별도 master cycle 격리 (= worktree dir = repo 외부 + `wt/<cycle-id>` branch + self-clean 의무 · `git worktree prune` 자동 실행 금지) · interactive pool 정합 (= 영역 3 무관) · 영역 2 대체 X. → detail §2.1.5 (= 유일 본문 canonical).
- **영역 2** (= 다중 cli session 운영 · **권장 default**): 실 IMPL / 자식 cli infra 정합 / 자식별 무거운 IMPL · 사용자 본인 terminal × N · interactive pool. → detail §2.2 · §2.2.1 (dispatch checklist) · §2.2.2 (dispatch ≠ fan-out 경계).
- **영역 3** (= `claude -p` sub-process spawn): **회피 default** (= 아래 §2.4 · Agent SDK credit pool 별 영역 · full API rate · roll over X · 요금 폭탄 risk). → detail §2.3 (paradigm 선택 본심).
- **동족 구현 정합** (= 같은 맥락 2+ repo 구현 결과의 advisory 비교 층 · paste-back 회수 시점): cli-infra byte-identical 강제(= A4)도 정확성 cross-verify(= detail §4.1)도 아닌 사후 surface · 도메인 자율(= detail §4.2/§4.3) 위 advisory · **auto-converge 금지**. → detail §4.4 (= 유일 본문 canonical) · surface 형식·발행 위치 = `reporting.md §14`.

> **단방향 propagation (A4 · 항상-on)**: cli infra = master 단방향 propagation + 6-repo byte-identical · 자식 직접 수정 금지 (= master `CLAUDE.md §3 + §4` · `cycle-discipline.md §15` 패턴 1). cross-repo 정합 처리 본문 (= sub-agent return 통합 §4.1 + sha 비교 §4.2 + drift mitigation §4.3) = detail §4.

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

> **본 §5 = pointer 영역 default**. 본문 단일 SoT = [`CLAUDE.md §5`](../../CLAUDE.md) (= `MASTER-CLI-CYCLE-1-STOP-CANONICAL-INTEGRATION-001` 마감 default · 9 STOP 항 default · cross-repo HIGH RISK 도메인 진입 = STOP #7 default · 보호 5 file sha drift = STOP #5 default). 본 § 본문 변경 시 = master cycle 신설 + 6-repo propagation 의무 default.

## 6. paradigm 호출 trigger 영역

### 6.1 본 rule reading 의무 trigger

사용자 요청사항 측 다음 키워드 / 본질 발견 시 본 rule reading 의무:

| 키워드 | 한국어 + 영어 |
|---|---|
| repo 측 영역 | `6-repo` / `5-repo` / `3 자식` / `GB + GD + GT` / `자식별` / `다중 repo` |
| paradigm 영역 | `cross-repo` / `fan-out` / `병렬` / `parallel` / `동족 자식` |
| 영역 영역 | `propagation` / `byte-identical` / `cli infra 6-repo` / `master + 5 자식` |

### 6.2 본 rule reading skip default trigger

다음 영역 = 본 rule reading skip default (= 자식 측 reading order 정합 default):
- 단일 자식 영역 cycle (= 단일 도메인 측 IMPL / 검증 / 리뷰 cycle)
- 자식 측 local override 영역 (= `.claude/settings.local.json` / `.ai/tasks/` 등)
- 자식 측 도메인 source 측 변경 (= app/ + composeApp/ + core/ 등 영역)

## 7. 본 rule 의 변경 정책

> 변경 정책 = [`rule-footer-common.md`](./rule-footer-common.md) (= 6-repo 권장 byte-identical · master cycle + propagation · 자식 직접 수정 금지 · T6).

## 8. 명시 cycle 이력

- 2026-05-19 · MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001 · 본 SoT 신설 + 부모 mount root CLAUDE.md 신설 + cross-repo-orchestrator sub-agent 신설 (§FREEDOM) + routing-and-delegation.md cross-repo sub-section append + cycle-discipline.md §21 신설 + 5-repo byte-identical propagation
- 2026-05-30 · MASTER-CLI-CROSS-REPO-DISPATCH-CHECKLIST-001 · §2.2.1 dispatch 체크리스트 sub-section 신설 (= cowork-role 측 영역 2 운영 5-step 표 · 자식별 cc-paste authoring → 본인 한 줄 트리거 → 자식 fresh context 실행 → cross-verify 복귀) + §2.2.2 dispatch ≠ sub-agent fan-out 경계 명시 (= B-5 정합 · 영역 1 sub-agent ≤ 3 가벼운 측정 한정) + scripts/propagate.sh line 11 header 주석 TARGET_REPOS 기본값 4-repo (app-foundation 포함) 정정 (= repo-config.sh SoT 정합) + 5-repo byte-identical propagation
- 2026-05-19 · MASTER-CLI-CROSS-REPO-SUBSCRIPTION-AWARE-PARADIGM-001 · 본 SoT 정정 강화: §2.2 영역 2 paradigm 본문 강화 (= 사용자 본인 측 의무 영역 표 + 자식 cli infra 자동 정합 영역 + subscription pool 정합 영역 + trade-off 영역 본문 추가) + §2.4 Subscription-aware paradigm sub-section 신설 (= 2026-06-15 Anthropic billing split 영역 + interactive pool vs Agent SDK credit pool 분기 + `claude -p` 사용 회피 paradigm) + §3.4 Sub-agent token cost warning sub-section 신설 (= 3-agent team token ~7× default + 실 사례 $8k~$15k / $47k 3 days + 권장 paradigm 정합) + 부모 mount root CLAUDE.md §4 정정 강화 + 5-repo byte-identical propagation
- 2026-06-01 · MASTER-CLI-CONTEXT-OPT-PHASE3-L0-CHILD-DEDUP-001 · H4 L0 최소화 — 본 file = kernel(§2.4 subscription + 단방향 + 영역 1/2/3 1-줄 요약 + §5 STOP/§6 trigger/§7-§8)로 축소 · paradigm 본문(§2.1~§2.3 + §3~§4) verbatim → `cross-repo-parallel-exec-detail.md` 신설 demote(삭제 0). `rule-routing-index.md §A`(L0 kernel 표기) + §B(Reading Mode 6 cross-repo = detail 로드) 갱신. L0 항상로드 char ↓ · subscription/billing/단방향 kernel 잔류(환각·요금 안전). 5-repo byte-identical propagation.
- 2026-06-04 · MASTER-CLI-WORKFLOW-SUBAGENT-BILLING-GUARD-001 · §2.4.1 신설 — `Workflow` 도구 dynamic subagent 의 interactive plan pool 귀속(gate ① · /usage "workflow-subagent" 실측 2026-06-04 · 별 Agent SDK credit pool 표기 0 · 영역 3 와 구분) + 2026-06-15 billing split 후 /usage 재확인 의무 + 토큰 예산 advisory 한계(10k 지시→79.6k 실소비) 200k hard cap 4-step 통제 절차(예산 prompt + /workflows 감시 + 수동 stop + 소규모 슬라이스 선행). 기존 §2.4 영역 1/2/3 본문 + 보호 5종 무접촉 · A6 정합 · 5-repo byte-identical propagation.
- 2026-06-04 · MASTER-CLI-WORKFLOW-ADOPTION-POLICY-002 · §2.4.1 본문(gate ① pool 귀속 + 2026-06-15 재확인 의무 + 토큰 예산 4-step) → [`workflow-policy.md`](../../docs/rules/workflow-policy.md) 별 rule 로 이관(유실 0) + §2.4.1 = 1줄 kernel pointer 환원(L0 de-bloat · 001 의 101→117줄 H4 역행 교정). 채택 정책 전반(본질·gate ②③·허용/회피 영역) = workflow-policy.md 에서 완성. 보호 5종 무접촉 · 5-repo byte-identical propagation.
- 2026-06-11 · MASTER-CLI-WORKTREE-PARADIGM-001 · §2 영역 1.5 (= git worktree 격리 · within-repo 병렬 + master propagation 격리) kernel 1-bullet 요약 신설 — 본문 canonical = `cross-repo-parallel-exec-detail.md §2.1.5` 단일 (= Coin 본심 D1~D8 확정 · 신 STOP 항 신설 X = 기존 #3/#4 해석 적용 · interactive pool 정합 = A6 무변동 · sub-agent cap ≤3 불변 · 영역 1 sub-agent 격리 = 보류). 부모 mount root CLAUDE.md §3.3/§4 행 + automation-policy.md §2 #12 Transport 행 = pointer 수준. 5-repo byte-identical propagation.
- 2026-06-22 · MASTER-CLI-CROSSREPO-RECONCILE-AUTONOMY-PARADIGM-001 · §2 영역 bullet 에 "동족 구현 정합" 1-bullet pointer 신설 (= L0 pointer-only · 본문 canonical = `cross-repo-parallel-exec-detail.md §4.4` 단일). 같은 맥락 2+ repo 구현 결과 advisory 비교 층(paste-back 회수 시점 · 3-bucket · auto-converge 금지)이 A4 byte-identical 강제·정확성 cross-verify(§4.1)와 직교함을 kernel 표면화. 동반(별 file): detail §4 intro 3층 구분 + §4.4 신설 · `anchor-list.md` A8/A10 확장(자율 폭 + 정합 step + paste source HOW-leak GSM-M) · `reporting.md §14` 동족 구현 정합 surface 규약. req2 cli HOW 자율 확대(범위 한정)와 한 쌍 = 사후 비교가 divergence catch. 보호 5종 무접촉 · 6-repo byte-identical propagation.
