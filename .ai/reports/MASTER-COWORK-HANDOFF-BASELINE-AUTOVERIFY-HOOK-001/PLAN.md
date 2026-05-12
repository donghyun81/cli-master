## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-COWORK-HANDOFF-BASELINE-AUTOVERIFY-HOOK-001 |
| Mode | ops-layer (cli infra · SessionStart hook 신설) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | 사용자 통합 prompt Task 2 영역 |
| Risk | Low |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 4 (master) + 6 (Gently 3 자식 × 2 file) = 10 |
| Modules | `.claude/hooks/baseline-snapshot.sh` 신설 + `.claude/settings.json` SessionStart 등록 + `.ai/reports/<taskId>/` 4 산출물 + propagation |
| Risk | Low (ops-layer · 비차단 hook · exit 0 · 보호 파일 5 종 sha 변동 0) |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision
N/A (외부 의존 추가 X · bash + shasum + 기본 macOS 도구만 사용)

## 3. ArchitectureImpact
N/A (ops-layer · 도메인 코드 영역 X)

## 4. ModelBoundaryPlan
N/A (UI / 도메인 model 변경 X)

## 5. ErrorPolicy
N/A (hook 측 exit 0 default · drift 발견 시 stderr warn-only · 차단 X)

## 6. UIStateFlowPlan
N/A (UI 영역 X)

## 7. TestabilitySeams
- hook self-test: `CLAUDE_PROJECT_DIR=<repo> bash .claude/hooks/baseline-snapshot.sh` (단독 실행 + exit 0 + JSON 유효성 검증)
- python3 parse: `python3 -c "import json; json.load(open('.ai/baseline-snapshot/latest.json'))"`
- FakeXxx N/A (shell hook 영역)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | (1) `bash .claude/hooks/baseline-snapshot.sh` exit code · (2) JSON 유효성 python3 parse · (3) 7-repo HEAD + sha 캡처 확인 · (4) drift 감지 logic 작동 검증 |

> **Risk 기반 경량화**: Low Risk = §1 ChangeBudget + §8 VerificationPlan + 작업 목록 + §9 RollbackStrategy 만 필수. 나머지 N/A.

## 9. RollbackStrategy
- 롤백 가능 지점: 본 cycle 신규 commit 들 (master + Gently 3) 의 직전 parent
- 롤백 조건: hook startup 시간 영향 > 1s 측정 / drift logic false positive 발생 / 자식 repo session 진입 시 hook 측 비정상 stderr 노이즈
- 복구 경로: `git revert <commit>` 으로 4-repo 모두 직전 상태 복구 + settings.json SessionStart 배열 단일 hook 복원

## 10. ExternalPrep / DeferredItems
N/A

## Plan

1. `.claude/hooks/baseline-snapshot.sh` 신설 (완료 · 7-repo capture + drift detection inline)
2. `.claude/settings.json` SessionStart 배열에 hook 추가 (완료)
3. `.ai/reports/MASTER-COWORK-HANDOFF-BASELINE-AUTOVERIFY-HOOK-001/{PLAN,EVIDENCE,VERIFY,REVIEW}.md` 4 산출물 작성
4. `CLAUDE.md` §15 cycle history 새 row
5. `.auto-memory/incident-log.md` 측 COWORK-PREP-BASELINE-MISMATCH-001~007 ledger close entry append
6. `.auto-memory/protected-file-hashes.md` Recent updates entry append (cli infra 변경 · 보호 5 종 sha 변동 0 명시)
7. master commit (feat type · 6-section body · 새 sha 기록)
8. Gently 3 자식 repo propagation (`cp` + 3 commit)
9. 최종 4-repo cross-verify (settings.json sha + hook sha + hook self-test on each)
10. paste-back 출력 (HEAD shas + commit shas + 새 sha baselines + 산출물 shas + PASS/FAIL)

## Notes

- 본 cycle = COWORK-PREP-BASELINE-MISMATCH-001~007 (5회차+ 누적) 의 자동화 mitigation. 6 의무 절차 (`cycle-discipline.md` §14a) 의 baseline 자동 캡처 영역.
- hook 측 비차단 default (exit 0). drift 발견 시 stderr warn-only.
- 7-repo capture scope (cli-master + Gently 3 + Proto 3) · propagation scope = 4-repo (cli-master + Gently 3) · Proto 3 무접촉.
- 보호 파일 5 종 sha 변동 0 · `.auto-memory/protected-file-hashes.md` 안 새 baseline 추가 X (cli infra 영역만 append).
