## GATESv2

| Field | Value |
|---|---|
| TaskId | GENTLY-AGENT-BILLING-GUARDIAN-CLEANUP-001 |
| Mode | cli infra ops-layer (agent 본문 표준화 + cleanup pass) |
| Workflow | Collect -> Plan -> Implement -> Propagate -> Cleanup -> Verify -> Review |
| Requirements Source | 사용자 cycle prompt (본 chat 진입 메시지) |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 4 변경 (master 본문 + 자식 3 propagation) + 3 삭제 (자식 3 deferred 잔존본) |
| Modules | `.claude/agents/active/` (master + 자식 3) · `.claude/agents/deferred/` (자식 3 rm) |
| Risk | Low (ops-layer · 본문만 변경 · 실 결제 코드 무접촉) |
| DBMig | No |
| MoneyAuth | **Yes** (billing 도메인 보호 영역 · 본문 안 §Must escalate when 명시 의무 + cycle scope 한정) |

## 2. DependencyDecision

N/A (의존성 변경 없음 · libs.versions.toml 무접촉)

## 3. ArchitectureImpact

N/A (신규 인터페이스 / 추상화 없음 · agent 본문 표준화만)

## 4. ModelBoundaryPlan

N/A (모델 레이어 무접촉 · ops-layer task)

## 5. ErrorPolicy

N/A (UseCase / Repository 신규 작성 없음)

## 6. UIStateFlowPlan

N/A (UI 무접촉)

## 7. TestabilitySeams

N/A (테스트 변경 없음 · agent hook self-test 별도 없음 — agent 본문 검증 = sha cross-verify + verify-sync.sh)

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/verify-sync.sh --skip-daemon-check` (exit 0 또는 영향 영역 차이만) + `shasum -a 256` 4-repo active sha 동일성 + 자식 3-repo deferred 부재 확인 |

## 9. RollbackStrategy

- 롤백 가능 지점: 각 commit (master + 자식 3 propagation + 자식 3 cleanup = 최대 7 commit)
- 롤백 조건: STOP 8 조건 발동 또는 verify-sync FAIL
- 복구 경로: `git revert <commit-sha>` 또는 (이전 stub 복원 시) `git checkout 412b621 -- .claude/agents/active/billing-payments-guardian.md` 후 propagate.sh 재실행 + 자식 3-repo deferred 잔존본 `git checkout a98a29c|999e7a7|c835367 -- .claude/agents/deferred/billing-payments-guardian.md`

## 10. ExternalPrep / DeferredItems

N/A (외부 의존 없음)

---

## Plan (단계별 작업 목록)

### STEP 2 — master 본문 작성 + commit

1. `claude-cli-master/.claude/agents/active/billing-payments-guardian.md` Write (현 6 줄 stub → 표준 6+ 섹션 본문 + frontmatter name 추가).
2. `git add <명시 path>` (다른 dirty WT 영역 흡수 X).
3. commit subject: `chore(agent): GENTLY-AGENT-BILLING-GUARDIAN-CLEANUP-001 billing-payments-guardian active 본문 + frontmatter name`
4. commit body 6 섹션 (cycle-discipline.md §7):
   - `[Goal]` cli infra agent 본문 표준화 (auth-security-privacy + intake-router 정합)
   - `[Diff]` `.claude/agents/active/billing-payments-guardian.md` (6 → ~110 줄)
   - `[Sha]` (보호 파일 불변) — 새 active billing-payments-guardian.md sha 8자 prefix 명시
   - `[EC]` master 본문 sha 갱신 PASS · 보호 5종 sha 변동 0
   - `[Next]` propagate.sh → 자식 3-repo cp + cleanup pass
   - `[Refs]` parent `412b621` + task `GENTLY-AGENT-BILLING-GUARDIAN-CLEANUP-001`

### STEP 3 — propagation 자식 3-repo

1. `bash scripts/propagate.sh .claude/agents/active/billing-payments-guardian.md --targets GB,GD,GT` (master root cwd).
2. 4-repo sha cross-verify (`shasum -a 256` × 4) — 모두 동일 새 sha 확인.
3. 자식 3-repo 각각 `git add .claude/agents/active/billing-payments-guardian.md` + commit:
   - subject: `chore(agent): GENTLY-AGENT-BILLING-GUARDIAN-CLEANUP-001 propagate active 본문`
   - body 6 섹션 (cycle-discipline.md §7) · `[Refs]` 자식 parent + master commit sha

### STEP 4 — cleanup pass (자식 3-repo deferred 잔존본 rm)

1. `rm` 3 파일:
   - `GentlyBreath/.claude/agents/deferred/billing-payments-guardian.md`
   - `GentlyDay/.claude/agents/deferred/billing-payments-guardian.md`
   - `GentlyTable/.claude/agents/deferred/billing-payments-guardian.md`
2. 자식 3-repo 각각 `git add -u .claude/agents/deferred/billing-payments-guardian.md` + commit:
   - subject: `chore(agent): GENTLY-AGENT-BILLING-GUARDIAN-CLEANUP-001 remove deferred 잔존본 (active 정합)`
   - body 6 섹션 · `[Goal]` active 정합 + 잔존본 cleanup pass (`legacy-cleanup-governance.md` 측 code-level cleanup 영역 외 · cli infra cleanup)

### STEP 5 — VERIFY.md

1. 4-repo active sha 재 측정 (동일성 확인).
2. 자식 3-repo deferred 부재 확인 (`ls` exit code 2 = No such file 예상).
3. master `.claude/agents/deferred/billing-payments-guardian.md` 부재 (사전 baseline) 재확인.
4. 보호 5종 sha 재 측정 (변동 0 확인).
5. `routing-and-delegation.md` + `deferred-domains.md` + `billing-rules.md` sha 재 측정 (변동 0 확인 · 본 cycle 본문 무접촉 명시 정합).
6. `bash scripts/verify-sync.sh --skip-daemon-check` (master root cwd) exit code + 출력 캡처.

### STEP 6 — REVIEW.md 12-section + decision-log entry

1. REVIEW.md 12-section 정규 스키마 (report-formats.md 정합) + PromptFitScore.
2. Verdict 판정 (PASS / PARTIAL / FAIL).
3. `.auto-memory/decision-log.md` 1 entry append (cycle 마감 + sha 변동 + STOP 조건 미발동 명시).
4. Coin 회수 보고 6 항목 (cycle ID + Verdict + 4-repo commit sha + EC + 보호 5종 sha 변동 0 + STOP 미발동 + 별 cycle 후보).

---

## agent 본문 draft (STEP 2 입력 · 표준 6+ 섹션 · auth-security-privacy + intake-router 구조 차용)

### Frontmatter

```yaml
---
name: billing-payments-guardian
description: Call when changes may affect billing, subscriptions, IAP, entitlement, SKU, refund, Google Play Billing, or RevenueCat. Read-only analysis role. Any payment / entitlement path change triggers STOP and user confirmation.
tools: Read, Glob, Grep
---
```

### 섹션 매핑 (billing-rules.md SoT → agent 본문)

| billing-rules.md 섹션 | agent 본문 섹션 |
|---|---|
| §1 Mock-first paradigm | Key questions / Evidence to gather |
| §2 Edge Function 단일 진입점 | Must escalate when / Key questions |
| §3 시크릿 저장 의무 | Must escalate when / Evidence to gather |
| §4 BillingRepository 패턴 | Decision authority / Evidence to gather |
| §5 entitlement / 소비형 paradigm | Key questions / Evidence to gather |
| §6 RevenueCat Phase 2 | Decision authority (NOT 결정 영역) |
| §7 STOP trigger | Must escalate when (즉시 STOP 6 영역) |
| §8 절대 금지 | Must escalate when (위반 시 STOP) |

### 본문 섹션 outline (예상 ~110 줄)

1. `# Billing Payments Guardian` heading
2. `## Mission` (3~5 줄 · billing 도메인 보호 핵심)
3. `## Use when` (bullet 5~6 · billing-rules.md §7 STOP trigger 키워드)
4. `## Think like` (1 단락 · 결제 도메인 감사관 mental model)
5. `## Key questions` (5 항목 · §7 STOP trigger 정합)
6. `## Decision authority` (자율 / NOT 결정 분리)
7. `## Must escalate when` (6 항목 · §7 STOP trigger 직 매핑 + dark pattern + Forced Continuity ux-laws.md §3.4 정합)
8. `## Evidence to gather` (billing-rules.md SoT cross-ref 1 줄 + routing-and-delegation.md:55 active 매핑 cross-ref 1 줄 + 검색 영역)
9. `## Expected outputs` (EVIDENCE.md format + stdout 예시)

### 교차 권한 금지 본문 반영 (`routing-and-delegation.md` Planner/Generator/Evaluator §3)

- `## Decision authority` 안 NOT 결정 영역에 명시: "Evaluator 는 고치지 않음 · 실 결제 코드 수정 / Mock→Real 전환 결정 / RevenueCat 도입 결정 모두 별 cycle"
- frontmatter `tools` = `Read, Glob, Grep` 만 (write 도구 부재 = Evaluator 경계 강제)

---

## propagation 알고리즘 (STEP 3~4)

```
1. master 본문 Write + add + commit
   ↓
2. bash scripts/propagate.sh .claude/agents/active/billing-payments-guardian.md --targets GB,GD,GT
   (cwd = claude-cli-master)
   ↓
3. 4-repo sha cross-verify:
   for r in claude-cli-master GentlyBreath GentlyDay GentlyTable; do
     shasum -a 256 $r/.claude/agents/active/billing-payments-guardian.md
   done
   → 4 sha 모두 동일 = PASS (mismatch = 즉시 STOP + RCA · STOP 5)
   ↓
4. 자식 3-repo 각각:
   git -C <child> add .claude/agents/active/billing-payments-guardian.md
   git -C <child> commit -m "chore(agent): ... propagate active 본문"
   ↓
5. cleanup pass (propagate.sh 흐름 외 · 직접 rm):
   for r in GentlyBreath GentlyDay GentlyTable; do
     rm $r/.claude/agents/deferred/billing-payments-guardian.md
     git -C $r add -u .claude/agents/deferred/billing-payments-guardian.md
     git -C $r commit -m "chore(agent): ... remove deferred 잔존본 (active 정합)"
   done
   ↓
6. bash scripts/verify-sync.sh --skip-daemon-check
   exit 0 또는 본 cycle 영향 영역 차이만 (DRIFT source 검증)
```

---

## 진입 baseline (STEP 0 EVIDENCE.md 정합)

- 4-repo active billing-payments-guardian.md sha `fa6ea5a8…` MATCH (4-repo 동일)
- 자식 3-repo deferred billing-payments-guardian.md sha `fa6ea5a8…` MATCH (3-repo 동일)
- 보호 5종 sha baseline `f1edd397/ee377dc2/e5e3fe16/7621013e/96de2f5d` MATCH
- 4-repo HEAD: `412b621 / a98a29c / 999e7a7 / c835367`
- scripts/propagate.sh + scripts/verify-sync.sh 존재 PASS

## Notes

- 본 cycle 모든 stage 는 `git add <명시 path>` (`git add -A` / `git add .` 금지) — STOP 8 영역 정합.
- master `.auto-memory/propagation-status.md` 변경 발생 가능 (propagate.sh 측 자동 갱신 · 본 cycle commit 안 포함 가능 — propagate.sh 내부 자동 stage 여부 확인).
- billing-rules.md SoT 본문 변경 X (STOP 2) · routing-and-delegation.md + deferred-domains.md 본문 변경 X (STOP 3) · 보호 5종 sha 변동 X (STOP 1).
