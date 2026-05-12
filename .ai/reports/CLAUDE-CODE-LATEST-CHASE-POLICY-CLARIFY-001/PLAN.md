# PLAN — CLAUDE-CODE-LATEST-CHASE-POLICY-CLARIFY-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | CLAUDE-CODE-LATEST-CHASE-POLICY-CLARIFY-001 |
| Mode | ops-layer (cli infra · §13 본문 정정) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | 사용자 prompt (4-repo scope · Proto 무접촉) |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 4 (cycle-discipline.md ×4 byte-identical) + 산출물 4 + auto-memory 2 |
| Modules | `.claude/rules/` (1 file · 4-repo) + `.auto-memory/` (2 file · master 만) + `.ai/reports/` (4 file · master 만) |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision
N/A (ops-layer · 의존성 변경 X)

## 3. ArchitectureImpact
N/A (정책 본문 정정 · 추상화 변경 X)

## 4. ModelBoundaryPlan
N/A (도메인 코드 변경 X)

## 5. ErrorPolicy
N/A (UseCase 변경 X)

## 6. UIStateFlowPlan
N/A (UI 변경 X)

## 7. TestabilitySeams
N/A (테스트 변경 X)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `git -C <repo> hash-object .claude/rules/cycle-discipline.md` (4-repo byte-identical 확인) + `grep -n "2.1.121\|known-working" cycle-discipline.md` (현 시점 default hardcode 영역 부재 확인) |

## 9. RollbackStrategy
- 롤백 가능 지점: 본 cycle 직전 commit (master `a3605df` · GB `8e3d81a` · GD `e0029d3` · GT `7de44ea`)
- 롤백 조건: 4-repo byte-identical 깨짐 또는 §13 본문 의도 정합 X
- 복구 경로: `git revert <cycle commits>` (master 1 + 자식 3 = 4 revert)

## 10. ExternalPrep / DeferredItems
N/A

## Plan

1. cli-master 의 `.claude/rules/cycle-discipline.md` §13 본문 갱신:
   - line 163 "현 시점 default `2.1.121` · 회귀 발견 시점에 갱신" → 동적 영역 (incident-log.md trail reference)
   - line 174 "새 known-working 등재 전까지 본 §13 안 기재 known-working 갱신 의무 (별 cycle)" → 폐기 (lazy default · 매 갱신 의무 X)
   - self-test 3 항목 영역 = 무접촉
2. cli-master commit (§13 + 산출물 4종 + auto-memory 2)
3. GB / GD / GT 각각 cli-master 의 cycle-discipline.md cp → commit (byte-identical · 3 child commit)
4. cross-verify 4-repo cycle-discipline.md sha 동일 확인 (git blob sha1)
5. paste-back 보고

## Notes
- Proto 3-repo (PB / PD / PT) 무접촉 의무 (별 cycle scope · STOP 조건 정합)
- 보호 파일 5종 무변경 · `.mcp.json` 무변경 · `settings.json` 무변경
- self-test 3 항목 (claude --version + mcp list pencil ✓ Connected + ToolSearch ≥ 13) 본문 = 그대로 유지
- 별 trail `CLAUDE-CODE-LATEST-CHASE-001` 안 첫 PASS entry append 의무 (2026-05-12 / 2.1.139 / 3/3 PASS · 회귀 X · 직전 PASS reference 영역)
