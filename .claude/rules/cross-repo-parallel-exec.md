# Cross-Repo Parallel Execution Paradigm SoT

> **단일 목적**: 단일 cli session 측 cross-repo (= 5-repo · master + app-foundation + GB + GD + GT) 자식 병렬 실행 paradigm + 다중 cli session 운영 paradigm 양쪽 분기 + cli session 자율 판단 영역 + 자식별 cwd 분리 + cross-repo 정합 처리 paradigm 통합 SoT.
> **신설**: MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001 (2026-05-19).
> **연관 파일**:
> - 부모 mount root `CLAUDE.md` (= `/Users/yundonghyeon/AndroidStudioProjects/CLAUDE.md` · cli session 진입 baseline) §3 cli session 진입 paradigm 분기
> - `.claude/agents/active/cross-repo-orchestrator.md` (= §FREEDOM · cross-repo routing sub-agent)
> - `.claude/agents/active/intake-router.md` (= 단일 repo routing paradigm baseline)
> - `.claude/rules/routing-and-delegation.md` §실행 방식 규칙 (= cross-repo sub-section)
> - `.claude/rules/cycle-discipline.md` §21 (= cross-repo cycle 영역)
> - `.claude/rules/report-formats.md` (= Subagent Return Contract · sub-agent 결과 통합 paradigm 정합)
> SOT: `CLAUDE.md`

---

## 1. 본 rule SoT 본질

본 rule = **cross-repo (= 5-repo) 측 cli session 운영 paradigm 단일 reference**. 단일 cli session 측 sub-agent 측 fan-out paradigm + 다중 cli session 운영 paradigm 양쪽 분기 명시 default.

본 paradigm 핵심 본심 = **cli session 측 자율 판단 default** (= 요청사항 본질 측정 후 paradigm 선택 default · 사용자 본심 정합 = "양쪽 모두 가능한데 요청사항에 따라서 claude code cli 가 판단해서 일을 처리").

## 2. paradigm 분기 본문

### 2.1 영역 1 — 단일 cli session 측 sub-agent 병렬 호출 paradigm

단일 cli session 측 main agent context 단일 + Task tool 측 sub-agent 호출 paradigm. sub-agent context 분리 default · 자식별 cwd 영역 명시 default.

**진입 조건**:
- cli session 측 cwd = 부모 mount root (= `/Users/yundonghyeon/AndroidStudioProjects`) 또는 자식 repo 중 1
- main agent 측 cross-repo 영역 본질 측정 결과 = 영역 1 paradigm 정합 default
- 자식별 sub-agent fan-out 측 main agent context 부담 ≤ 적절 (= sub-agent 결과 통합 가능 영역)

**호출 paradigm**:
```
main agent (cli session 측 cwd = 부모 mount root)
  ↓
Task tool sub-agent fan-out (= 자식별 병렬 또는 순차)
  ↓
sub-agent A (cwd = ~/AndroidStudioProjects/GentlyBreath)
sub-agent B (cwd = ~/AndroidStudioProjects/GentlyDay)
sub-agent C (cwd = ~/AndroidStudioProjects/GentlyTable)
  ↓
main agent 측 결과 통합 + cross-repo 정합 결정
```

**적용 case 예**:
- "GB + GD + GT 측 동일 paradigm 신설 영역 cycle" (= 동족 자식 측 sha 정합 측정 + 동일 patch 적용)
- "5-repo 측 보호 file sha drift 검증" (= 자식별 sha 측정 + master 측 baseline 비교)
- "3 자식 측 동일 도메인 영역 측 source 측정" (= 동족 자식 측 source code 비교 + 정합 측정)
- "cli infra rule SoT 본문 cross-repo cross-verify" (= 5-repo byte-identical 영역 측 drift 발견)

**Subagent Return Contract 정합 의무** (= `report-formats.md` 정합):
- 단일 sub-agent return ≤ 4,000 token 요약
- Verdict + Top Findings + Counter-example + Recommended Next Step + Pointers 5 섹션 의무
- raw output 그대로 return 금지 (= main agent context 압박 회피)

### 2.2 영역 2 — 다중 cli session 운영 paradigm

terminal × cli 측 독립 session × 독립 context paradigm. session 측 자식별 cwd 분리 default · cross-repo 정합 처리 책임 = 사용자 본인 영역 default.

**진입 조건**:
- 단일 자식 측 무거운 IMPL 영역 (= main agent context 측 단일 자식 본질 측 집중 의무)
- 자식별 IMPL 측 다른 자식 무접촉 영역 default (= cross-repo 정합 영역 X 또는 사후 정합)
- cli session 측 context 측 분리 의무 (= session 측 자식 도메인 단일 집중 default)

**호출 paradigm**:
```
terminal A → cli session A (cwd = ~/AndroidStudioProjects/GentlyBreath) → GB 도메인 IMPL
terminal B → cli session B (cwd = ~/AndroidStudioProjects/GentlyDay) → GD 도메인 IMPL
terminal C → cli session C (cwd = ~/AndroidStudioProjects/GentlyTable) → GT 도메인 IMPL
  ↓
사용자 본인 측 cross-repo 정합 의무 (= session × session 측 직접 cross-verify 영역)
```

**적용 case 예**:
- "GB 측 Phase 2 Auth 도메인 무거운 IMPL cycle" (= GD/GT 무접촉)
- "GT 측 daily-prescription 측 LAUNCH-STATUS 갱신 cycle" (= 다른 자식 무접촉)
- "자식별 도메인 specific cycle 측 동시 운영" (= 사용자 본인 측 multi-tasking 영역)

### 2.3 paradigm 선택 본심 (= cli session 자율 판단 default)

본 paradigm 분기 측 선택 = **cli session 자율 결정 default**. 요청사항 본질 측정 후 paradigm 선택 default.

| 요청사항 본질 | 권장 paradigm | 근거 |
|---|---|---|
| 가벼운 cross-repo 정합 영역 (= sha 측정 / source grep / cross-verify) | **영역 1** (sub-agent fan-out) | main agent context 측 통합 가능 영역 default |
| 동족 자식 측 동일 paradigm 신설 (= GB + GD + GT 측 동일 patch) | **영역 1** (sub-agent fan-out) | 단일 cli session 측 효율 default |
| cli infra propagation cycle (= master → 4 자식 byte-identical) | **영역 1 또는 단일 cli session** | propagate.sh 측 단일 호출 paradigm default |
| 단일 자식 측 무거운 IMPL (= 다른 자식 무접촉) | **영역 2** (다중 cli session) | context 측 분리 의무 default |
| 자식별 도메인 specific cycle 동시 운영 (= 사용자 multi-tasking) | **영역 2** (다중 cli session) | session 측 독립 context default |
| cross-repo + 단일 자식 무거운 IMPL 혼합 영역 | **자율 결정** (= 사용자 본심 측정 의무) | 본심 분기 의제 본질 발견 시 = AskUserQuestion 영역 |

## 3. 자식별 cwd 분리 paradigm (= 영역 1 적용 시 default)

영역 1 (= 단일 cli session 측 sub-agent 병렬) 적용 시점 자식별 cwd 분리 의무. main agent 측 cwd 측 default 보존 + sub-agent 측 자식 repo 측 cwd 진입 paradigm 명시 default.

### 3.1 Task tool 호출 paradigm

```python
# main agent (cwd = 부모 mount root)
Agent(
  description="GB 측 cli infra rule sha 측정",
  subagent_type="general-purpose",
  prompt="""
  Working directory = /Users/yundonghyeon/AndroidStudioProjects/GentlyBreath
  
  본 자식 repo 측 .claude/rules/cycle-discipline.md sha 측정 의무 (`git hash-object`).
  결과 = sha + file 측 last commit 측 정합 측정.
  
  Return format: Verdict + Top Findings (sha + commit) + Pointers + Recommended Next Step.
  Return 본문 ≤ 2,000 token.
  """
)
```

### 3.2 sub-agent 측 인지 paradigm

sub-agent 측 자식 측 cli infra (= `../<repo>/CLAUDE.md` + `.claude/`) 인지 paradigm 정합 의무:
- sub-agent 측 자식 측 reading order 정합 default (= 부모 mount root CLAUDE.md §3.1 정합)
- sub-agent 측 자식 측 cli infra rule (= 자식 측 `.claude/rules/`) 측 byte-identical 영역 인지 (= cli infra SoT = master 측 단일 default)
- sub-agent 측 자식 측 보호 file 인지 (= 5 file × 5-repo byte-identical default)

### 3.3 sub-agent return 영역 통합 paradigm

main agent 측 sub-agent 결과 통합 paradigm (= `report-formats.md` Subagent Return Contract 정합):

1. **Verdict 측 비교** = 자식별 PASS / FAIL / PARTIAL / UNKNOWN 영역 통합 측정
2. **Top Findings 측 동족 영역 측정** = 동족 자식 측 paradigm 정합 측정 default (= sha 정합 / source code 정합 / lifecycle 영역 정합)
3. **Counter-example 측 영역** = main agent 측 cross-repo 정합 결정 측 보강 영역 default
4. **Pointers 측 lazy loading** = main agent 측 필요 시점 측 추가 read default (= just-in-time)

## 4. cross-repo 정합 처리 paradigm (= 영역 1 적용 시 default)

### 4.1 main agent 측 sub-agent 결과 통합

자식별 sub-agent 결과 통합 시점 main agent 측 의무:
- 자식별 Verdict 비교 측 동족 영역 측정 (= 동족 자식 측 동일 영역 정합 measure)
- cross-repo 정합 결정 영역 측정 (= drift 발견 시점 mitigation cycle 진입 검토)
- 산출물 측 자식별 sub-agent return body 인용 default (= EVIDENCE.md 측 항목별 명시)

### 4.2 sub-agent 결과 비교 paradigm

동족 자식 측 paradigm 정합 측정 default. 영역:

| 비교 영역 | measure method | 정합 default |
|---|---|---|
| cli infra rule SoT 측 sha | `git hash-object` × 자식별 | 5-repo byte-identical 의무 (= master + 4 자식 측 동일 sha) |
| 보호 5 file 측 sha | `git hash-object` × 자식별 | 5-repo byte-identical 의무 (= `.auto-memory/protected-file-hashes.md` baseline 정합) |
| 자식 도메인 source code | `grep -rn` + 동족 자식 측 비교 | 자식별 도메인 specific 영역 default (= drift 영역 X · 자식 자율 default) |
| ui-spec.json 측 lifecycle | `grep -E "lifecycle\|deprecated"` | 자식별 lifecycle 영역 default (= 도메인 specific 영역 default) |

### 4.3 drift 발견 시점 mitigation

drift 발견 시점 main agent 측 mitigation:
- cli infra rule SoT 측 drift 발견 시 = master 측 정합 cycle 진입 (= `cycle-discipline.md` §15 패턴 1 정합 · 단방향 propagation cycle 진입)
- 보호 5 file sha drift 발견 시 = 즉시 STOP + 사용자 회수 (= `cycle-discipline.md` §10 + master CLAUDE.md §5 정합)
- 자식 도메인 source drift 발견 시 = lazy default (= 자식 자율 영역 default · cross-repo 정합 의무 X)

## 5. STOP 조건 (= cross-repo 영역 한정)

| # | trigger | mitigation |
|---|---|---|
| 1 | 자식별 sub-agent 결과 본질 어긋남 발견 (= 동족 자식 측 paradigm 정합 측 mismatch) | 즉시 STOP + 사용자 회수 default (= AskUserQuestion 영역) |
| 2 | cross-repo 영역 측 HIGH RISK 도메인 진입 (= DB migration / Money / Auth / production push) | 즉시 STOP default (= `cycle-discipline.md` §STOP 정합) |
| 3 | sub-agent 측 cwd 분리 paradigm 위반 (= main agent cwd 측 자식 측 write 시도) | 즉시 STOP + cwd 분리 paradigm 재 정합 의무 |
| 4 | sub-agent return body 측 raw output 그대로 (= `report-formats.md` 4k token 한도 초과) | sub-agent 재 호출 + return 본문 압축 paradigm 정합 의무 |
| 5 | 보호 5 file sha drift 발견 (= 자식별 sub-agent 측정 결과 mismatch) | 즉시 STOP + master 측 mitigation cycle 진입 (= §4.3 정합) |

## 6. paradigm 호출 trigger 영역

### 6.1 본 rule reading 의무 trigger

사용자 요청사항 측 다음 키워드 / 본질 발견 시 본 rule reading 의무:

| 키워드 | 한국어 + 영어 |
|---|---|
| repo 측 영역 | `5-repo` / `3 자식` / `GB + GD + GT` / `자식별` / `다중 repo` |
| paradigm 영역 | `cross-repo` / `fan-out` / `병렬` / `parallel` / `동족 자식` |
| 영역 영역 | `propagation` / `byte-identical` / `cli infra 5-repo` / `master + 4 자식` |

### 6.2 본 rule reading skip default trigger

다음 영역 = 본 rule reading skip default (= 자식 측 reading order 정합 default):
- 단일 자식 영역 cycle (= 단일 도메인 측 IMPL / 검증 / 리뷰 cycle)
- 자식 측 local override 영역 (= `.claude/settings.local.json` / `.ai/tasks/` 등)
- 자식 측 도메인 source 측 변경 (= app/ + composeApp/ + core/ 등 영역)

## 7. 본 rule 의 변경 정책

- cli infra 권장 byte-identical (= 5-repo · master + 4 자식)
- 변경 시 master cycle 신설 + 5-repo propagation 의무 (= `cycle-discipline.md` §15 패턴 1 정합)
- 자식 repo 측 직접 수정 금지

## 8. 명시 cycle 이력

- 2026-05-19 · MASTER-CLI-PARENT-MOUNT-PARALLEL-EXEC-PARADIGM-001 · 본 SoT 신설 + 부모 mount root CLAUDE.md 신설 + cross-repo-orchestrator sub-agent 신설 (§FREEDOM) + routing-and-delegation.md cross-repo sub-section append + cycle-discipline.md §21 신설 + 5-repo byte-identical propagation
