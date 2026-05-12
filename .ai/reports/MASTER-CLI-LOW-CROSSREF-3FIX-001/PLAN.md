## GATESv2

| Field | Value |
|---|---|
| TaskId | MASTER-CLI-LOW-CROSSREF-3FIX-001 |
| Mode | cli infra ops-layer (3 rule file cross-ref 정합) |
| Workflow | Collect -> Plan -> Implement -> Master single commit -> Propagate -> Verify -> Review |
| Requirements Source | 사용자 cycle prompt (본 turn 진입 메시지) |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 3 변경 (master 단일 commit) + 자식 3-repo propagation |
| Modules | `.claude/rules/{cycle-discipline,verification-and-review,routing-and-delegation}.md` |
| Risk | Low (ops-layer · 본문 본질 영역 무접촉 · cross-ref 영역만) |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision

N/A

## 3. ArchitectureImpact

N/A (cli infra ops-layer · 정책 cross-ref 정합 영역만)

## 4. ModelBoundaryPlan

N/A

## 5. ErrorPolicy

N/A

## 6. UIStateFlowPlan

N/A

## 7. TestabilitySeams

N/A (테스트 변경 없음 · 본 cycle 검증 = sha cross-verify + grep 3 영역 hit × 4-repo + verify-sync.sh)

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | (1) `shasum -a 256` 4-repo × 3 file = 12 측정 sha 동일성 · (2) cycle-discipline §3 cli infra 단락 grep × 4-repo · (3) verification-and-review L46 §5 file 명시 grep × 4-repo · (4) routing-and-delegation L126 backend-api-architect [DEFERRED] grep × 4-repo · (5) 보호 5종 sha 변동 0 재 측정 · (6) `bash scripts/verify-sync.sh --skip-daemon-check` |

## 9. RollbackStrategy

- 롤백 가능 지점: 각 commit (master 1 + 자식 3 = 4 commit). `git revert <sha>` 가능.
- 롤백 조건: STOP 9 조건 발동 또는 verify-sync FAIL (본 cycle 영향 영역).
- 복구 경로: `git revert <commit-sha>` × 4-repo — 모든 변경 가역.

## 10. ExternalPrep / DeferredItems

N/A

---

## Plan (단계별 작업 목록)

### STEP 2 — master 3 file Edit

#### L2-#3: cycle-discipline.md §3 cli infra 단락 추가

위치 = L49 "다른 룰 파일은 repo-specific 가능. 단 워크플로우 표준 (본 §섹션 포함) 을 3-repo 모두에 적용하려면 task 별로 propagation 명시." 직후 영역 신설 단락.

wording draft:

```markdown
**cli infra 권장 byte-identical 영역**: `.claude/` 전체 (settings.json + rules + agents + hooks + skills + commands) + `scripts/` 측 propagation 도구 (propagate.sh + verify-sync.sh + ensure-child-gitignore-patches.sh 등) + `docs/agent/architecture/*` 등 = cli infra 권장 byte-identical 영역 (CLAUDE.md §2 "53 + α" 영역 정합). drift 발생 시 lazy mitigation default (= 다음 cycle 영향 시점 회복 의무).
```

#### L3-1: verification-and-review.md L46 §5 file 명시 정정

위치 = L46 "**UI 레이어 변경(Screen/ViewModel/UiState 신규·수정) 포함 시 §5 Model Separation 추가 필수.**"

정정 영역 = "§5 Model Separation" → "§5 Model Separation (= `workflow-core.md` "### 모델 분리 (Model Separation)" 영역 정합)" 또는 더 간결한 영역.

CLI 자율 결정 영역 정합 = 간결 wording 선택:

```diff
-- **Low Risk**: VERIFY.md (빌드/테스트 통과 확인) + 3-section REVIEW (Requirements, Regression, Secrets). **UI 레이어 변경(Screen/ViewModel/UiState 신규·수정) 포함 시 §5 Model Separation 추가 필수.** PromptFit 선택.
++ **Low Risk**: VERIFY.md (빌드/테스트 통과 확인) + 3-section REVIEW (Requirements, Regression, Secrets). **UI 레이어 변경(Screen/ViewModel/UiState 신규·수정) 포함 시 §5 Model Separation 추가 필수** (= `workflow-core.md` "### 모델 분리 (Model Separation)" §implement 영역 정합). PromptFit 선택.
```

#### L3-8: routing-and-delegation.md L126 backend-api-architect [DEFERRED] 표기

위치 = L126 Evaluator 표 안 "verifier, reviewer, layer-checker, 그리고 read-only 분석 11 종 (ux-auditor, backend-api-architect 등)"

정정 영역 = backend-api-architect 옆 `[DEFERRED]` 표기 추가:

```diff
-- | Evaluator | "만들어진 것이 목적을 충족하는가, 회귀 위험은 없는가" | verifier, reviewer, layer-checker, 그리고 read-only 분석 11 종 (ux-auditor, backend-api-architect 등) | VERIFY.md, REVIEW.md, 분석 리포트 |
++ | Evaluator | "만들어진 것이 목적을 충족하는가, 회귀 위험은 없는가" | verifier, reviewer, layer-checker, 그리고 read-only 분석 11 종 (ux-auditor, backend-api-architect [DEFERRED] 등 · 분석 전문가 표 [DEFERRED] 표기 정합) | VERIFY.md, REVIEW.md, 분석 리포트 |
```

### STEP 3 — master single commit

- subject: `chore(cli): MASTER-CLI-LOW-CROSSREF-3FIX-001 cycle-discipline §3 cli infra + verification-and-review §5 명확화 + routing-and-delegation [DEFERRED] 표기`
- body 6 섹션 (cycle-discipline §7)

### STEP 4 — propagation 자식 3-repo

1. `bash scripts/propagate.sh .claude/rules/cycle-discipline.md .claude/rules/verification-and-review.md .claude/rules/routing-and-delegation.md --targets GB,GD,GT`
2. 4-repo 3 file sha cross-verify
3. 자식 3-repo 각각 `git add` (명시 path 만) + single commit

### STEP 5 — VERIFY.md

1. 4-repo × 3 file = 12 측정 sha 동일성
2. grep × 4-repo:
   - cycle-discipline §3 cli infra 단락 hit ≥ 1
   - verification-and-review L46 §5 file 명시 hit ≥ 1
   - routing-and-delegation L126 `backend-api-architect [DEFERRED]` hit ≥ 1
3. 보호 5종 sha 변동 0 재 측정
4. `bash scripts/verify-sync.sh --skip-daemon-check` 결과 (Gently 4-repo PASS · app-foundation drift cycle scope 외)

### STEP 6 — REVIEW.md + decision-log + (CLI 자율) incident-log false positive entry

1. REVIEW.md 12-section + PromptFitScore
2. Verdict 판정 (PASS / PARTIAL)
3. 누적 mitigation 영역 명시 = C1 3 + C2 3 + C3 2 + C4 3 = **11/14** 영역
4. `.auto-memory/decision-log.md` 1 entry append
5. (CLI 자율 결정 default = append) `.auto-memory/incident-log.md` false positive 2 entry append (L3-2 + L3-9)
6. Coin 회수 7 항목 보고

---

## 진입 baseline (STEP 0 EVIDENCE.md 정합)

- 4-repo HEAD: `fdbd726 / 5e3370e / e24ae2a / 7a5a099` MATCH prompt BASELINE 100%
- 3 file sha: `5ba63684 / b107f7c9 / 059d80d8` MATCH (byte-identical 4-repo)
- 보호 5종 sha baseline MATCH
- §5 영역 실측 = `workflow-core.md "### 모델 분리 (Model Separation)"` 정합 (STOP 8 미발동)

## Notes

- 본 cycle 모든 stage 는 `git add <명시 path>` 명시 stage 의무 (STOP 9 영역 정합).
- L46 영역 실 line 번호 = 46 (= prompt 측 명시 L48 ≠ 실측 L46 · 본문 wording 정합 동일 · file format 측 단순 line offset 영역 · 본 cycle 영향 X).
- false positive 2 영역 (L3-2 + L3-9) = incident-log 측 cli 자율 entry append default (= 본 cycle 안 추가 작업 영역 정합 · STOP 7 방지 영역 정합).
