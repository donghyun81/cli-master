## GATESv2

| Field | Value |
|---|---|
| TaskId | MASTER-CLI-PROTECTED-PRIORITY-2FIX-001 |
| Mode | cli infra ops-layer (scripts + rules cross-ref + PROTECTED 5종 확장) |
| Workflow | Collect -> Plan -> Implement -> self-test -> Master single commit -> Propagate -> Verify -> Review |
| Requirements Source | 사용자 cycle prompt (본 turn 진입 메시지) |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 3 변경 (master 단일 commit) + cycle-discipline + safety-and-secrets 자식 3-repo propagation (scripts/verify-sync.sh = master 전용 · 자식 측 부재) |
| Modules | `scripts/verify-sync.sh` (master 전용) · `.claude/rules/cycle-discipline.md` (4-repo) · `.claude/rules/safety-and-secrets.md` (4-repo) |
| Risk | Low (ops-layer · 본문 본질 영역 무접촉 · cross-ref 1-2 줄만 + PROTECTED 1 line 추가) |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision

N/A

## 3. ArchitectureImpact

N/A (cli infra ops-layer · 정책 본문 + scripts 정정 영역 만)

## 4. ModelBoundaryPlan

N/A

## 5. ErrorPolicy

N/A

## 6. UIStateFlowPlan

N/A

## 7. TestabilitySeams

self-test 3 fixture (STEP 3 신설 · cycle prompt 명시):

| Fix | 검증 영역 | expected output |
|---|---|---|
| Fix 1 | `bash -n scripts/verify-sync.sh` syntax | exit 0 (PASS) |
| Fix 2 | `grep -c '^  [a-zA-Z.]' scripts/verify-sync.sh` 안 PROTECTED 영역 line 측 5 line + `bash scripts/verify-sync.sh --skip-daemon-check` 측 보호 5종 모두 PASS 영역 명시 | PROTECTED 배열 5 line 영역 hit + verify-sync.sh 측 보호 5종 모두 PASS line 측 출력 |
| Fix 3 | `grep -nE "safety-and-secrets" .claude/rules/cycle-discipline.md` + `grep -nE "cycle-discipline.*§5" .claude/rules/safety-and-secrets.md` | 양방향 hit ≥ 1 each |

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | (1) `shasum -a 256` 3 file sha 동일성 영역 (master + cycle-discipline + safety-and-secrets 측 4-repo · scripts/verify-sync.sh master 전용) · (2) self-test 3 fixture × 4-repo (가능 영역) · (3) `bash scripts/verify-sync.sh --skip-daemon-check` 측 PROTECTED 5종 cover 검증 + 본 cycle scope 영향 영역 PASS · (4) cross-ref 양방향 grep |

## 9. RollbackStrategy

- 롤백 가능 지점: 각 commit (master 1 + 자식 3 = 4 commit). `git revert <sha>` 가능.
- 롤백 조건: STOP 9 조건 발동 또는 self-test 1+ FAIL 또는 verify-sync FAIL (본 cycle 영향 영역).
- 복구 경로: `git revert <commit-sha>` × 4-repo — 모든 변경 가역.

## 10. ExternalPrep / DeferredItems

N/A (외부 의존 없음)

---

## Plan (단계별 작업 목록)

### STEP 2 — master 3 file Edit

#### δ: scripts/verify-sync.sh PROTECTED 5종 확장

```diff
 PROTECTED=(
   docs/schemas/ui-spec.schema.json
   .claude/rules/pencil-uiux-workflow.md
   docs/design/pencil-sot-policy.md
   .claude/rules/uiux-sot-refresh.md
+  docs/design/design-sot-policy.md
 )
```

- 5번째 라인 = `docs/design/design-sot-policy.md` 추가
- 위치 정합 = 마지막 영역 (cycle prompt 측 명시 영역 정합 · 알파벳순 영역 옵션 외)
- 본문 영역 변경 영역 = L91-96 PROTECTED 배열 영역만 (= 본문 기타 영역 무접촉)

#### ζ-1: cycle-discipline.md §5 v2 cross-ref 추가

위치 = L60 본문 머리 직후 + L75 v2 도입 근거 단락 직후 둘 중 선택. 영역 정합 = L75 직후 (= v2 도입 근거 영역 정합 영역).

wording draft:

```markdown
**우선순위 정합**: `safety-and-secrets.md §절대 금지 명령` 표 안 `git commit` 영역 = 본 §5 v2 (한시 허가) 우선 · `safety-and-secrets.md` 표 = 응급 백스탑 default 영역. 본 §5 v2 자동 허용 카테고리 영역 + app/src/ 변경 + 빌드 PASS + Coin 명시 승인 영역 측 agent commit 허용 정합.
```

#### ζ-2: safety-and-secrets.md §절대 금지 명령 cross-ref 추가

위치 = L23 표 직후 (= 표 영역 직후 영역 정합).

wording draft:

```markdown
> **`git commit` 영역 우선순위 정합**: `cycle-discipline.md §5 v2 agent commit 한시 허가 정책` 우선 · 본 표 = 응급 백스탑 default 영역. v2 자동 허용 카테고리 (docs / cleanup / propagation / report / refactor / test / chore / audit / discipline) + app/src/ 변경 + 빌드 PASS + Coin 명시 승인 영역 측 agent commit 허용 정합.
```

### STEP 3 — self-test 3 fixture (master commit 전 의무)

순서:
1. Fix 1: `bash -n scripts/verify-sync.sh` (master 측) exit 0 확인
2. Fix 2: PROTECTED 배열 line count 영역 검증 + verify-sync.sh 측 보호 5종 모두 PASS line 영역 검증 (= 자식 측 변경 후 verify-sync 측 5종 cover 검증)
3. Fix 3: cycle-discipline + safety-and-secrets cross-ref 양방향 grep hit ≥ 1 each

### STEP 4 — master single commit

- subject: `chore(cli): MASTER-CLI-PROTECTED-PRIORITY-2FIX-001 verify-sync.sh PROTECTED 5종 확장 + git commit 우선순위 양방향 cross-ref`
- body 6 섹션 (cycle-discipline §7)

### STEP 5 — propagation 자식 3-repo

1. `bash scripts/propagate.sh scripts/verify-sync.sh .claude/rules/cycle-discipline.md .claude/rules/safety-and-secrets.md --targets GB,GD,GT` (master root cwd)
2. propagate.sh 측 scripts/verify-sync.sh 영역 cp 가능 영역 검증 (= 자식 측 부재 → mkdir + cp 영역)
3. 4-repo 3 file sha cross-verify (= cycle-discipline + safety-and-secrets 4-repo 측 byte-identical · scripts/verify-sync.sh 측 자식 측 cp 영역 검증)
4. 자식 3-repo 각각 `git add` (명시 path 만) + single commit

### STEP 6 — VERIFY.md

1. 4-repo cycle-discipline + safety-and-secrets sha 동일성 (= 2 file × 4 repo = 8 측정)
2. scripts/verify-sync.sh 측 master sha (1 영역) + 자식 측 cp 영역 검증 (= scripts/verify-sync.sh 자식 측 cp 영역 = 4-repo 동일 또는 master 전용 baseline 영역 명시)
3. `bash -n scripts/verify-sync.sh` × 4-repo syntax PASS (= 자식 측 cp 영역 검증 영역)
4. `bash scripts/verify-sync.sh --skip-daemon-check` (master cwd) 측 PROTECTED 5종 cover + 본 cycle scope 영향 영역 PASS
5. 보호 5종 sha 변동 0 재 측정
6. cross-ref 양방향 grep × 4-repo

### STEP 7 — REVIEW.md 12-section + decision-log

1. REVIEW.md 12-section + PromptFitScore
2. Verdict 판정 (PASS / PARTIAL · 본 cycle 영향 영역 외 DRIFT 시 PARTIAL 정합)
3. 누적 mitigation 영역 명시 (C1 3 + C2 3 + C3 2 = 8 영역 mitigation · 잔존 6 영역)
4. `.auto-memory/decision-log.md` 1 entry append
5. Coin 회수 보고 7 항목

---

## 진입 baseline (STEP 0 EVIDENCE.md 정합)

- 4-repo HEAD: `f6f1bdc / af21cd5 / 04afab8 / 6518d01` MATCH prompt BASELINE 100%
- 3 file sha: `5db17df2 / 9c5021e5 / 7e9e35b4` MATCH
- 보호 5종 sha baseline `f1edd397 / 7621013e / 96de2f5d / ee377dc2 / e5e3fe16` MATCH
- scripts/verify-sync.sh 자식 3-repo 측 부재 baseline (= master 전용 영역)

## Notes

- 본 cycle 모든 stage 는 `git add <명시 path>` (`git add -A` / `git add .` 금지) — STOP 9 영역 정합.
- propagate.sh 측 `EXPECTED_BASELINE` 4종 hardcoded 영역 (L232-244) = 본 cycle scope 외 (= 별 cycle 후보 영역 · LOW 잔존 사고 영역 가능). 본 cycle 측 propagate.sh 본문 무접촉.
- self-test Fix 2 영역 = `--quick` 모드 측 CHECK_FILES = PROTECTED + CORE_CLI 영역 측정 영역 (= PROTECTED 만 영역 측정 별 의미 영역). 본 cycle 측 Fix 2 = PROTECTED 배열 line count = 5 영역 + verify-sync.sh 측 5종 모두 PASS line 출력 영역 정합 (= grep + 실행 영역).
- propagation 시 자식 측 scripts/ 디렉터리 부재 영역 검증 의무 — propagate.sh 측 mkdir 가능 영역 검증.
