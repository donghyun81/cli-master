# PLAN — CLAUDE-CODE-VERSION-UNPIN-VERIFY-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | CLAUDE-CODE-VERSION-UNPIN-VERIFY-001 |
| Mode | ops-layer · verification-only |
| Workflow | Collect -> Verify (4 PASS criteria) -> Review |
| Requirements Source | 본 chat 직접 prompt (Coin) |
| Scope | cli-master 한정 · propagation 없음 |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 5 (PLAN/EVIDENCE/VERIFY/REVIEW + incident-log append) |
| Modules | `.ai/reports/CLAUDE-CODE-VERSION-UNPIN-VERIFY-001/` + `.auto-memory/incident-log.md` |
| Risk | Low (read-only 검증 · cli infra 무변경) |
| DBMig | No |
| MoneyAuth | No |

## 2~7. N/A (ops-layer task · 도메인 무관)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | (1) `claude --version` (2) `claude mcp list` (3) ToolSearch query="pencil" (4) `mcp__pencil__get_editor_state` 실호출 |

## 9. RollbackStrategy
- 산출물 파일 5개 모두 `.ai/reports/CLAUDE-CODE-VERSION-UNPIN-VERIFY-001/` + `.auto-memory/incident-log.md` append 1 줄만.
- 롤백 = `git revert <commit>` 단일 명령.

## 10. ExternalPrep / DeferredItems
- FAIL 시: 별 trail `CLAUDE-CODE-VERSION-PIN-2.1.114-001` 유지 + 2.1.114 rollback 분리 cycle.
- PASS 시: 별 cycle `CLI-VERSION-UNPIN-PROPAGATION-001` (cycle-discipline.md §13 갱신 + 4-repo propagation) 진입.

## Plan

1. `claude --version` 실측 → EVIDENCE.md
2. `claude mcp list` 실측 → EVIDENCE.md
3. ToolSearch query="pencil" 실측 (13 tool 명단 + count) → EVIDENCE.md
4. `mcp__pencil__get_editor_state(include_schema=false)` 실호출 → EVIDENCE.md
5. 4 항목 결과표 → VERIFY.md
6. REVIEW.md (12-section + 본심 검증 + 다음 cycle 권장)
7. `.auto-memory/incident-log.md` append (PASS 1 줄)
8. commit (산출물만 · cycle-discipline §5 v2 `chore(ops)` 카테고리)

## Notes
- 본 cycle 안 .mcp.json / .claude/ / 다른 repo 파일 변경 금지 (STOP 조건).
- propagation 명령 자체 금지 (별 cycle 책임).
- cycle-discipline.md §13 안 "2.1.114 pin 의무" 영역 수정 금지 (별 cycle = CLI-VERSION-UNPIN-PROPAGATION-001 책임).
