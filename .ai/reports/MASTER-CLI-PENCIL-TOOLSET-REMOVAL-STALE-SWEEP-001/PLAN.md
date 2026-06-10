# PLAN — MASTER-CLI-PENCIL-TOOLSET-REMOVAL-STALE-SWEEP-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-PENCIL-TOOLSET-REMOVAL-STALE-SWEEP-001 |
| Mode | M5 cli-infra-ops |
| Workflow | Collect → Plan → Implement(Phase A) → Verify → Review → [Phase B gate] |
| Requirements Source | cc-paste-…-STALE-SWEEP-001.md |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | Phase A: 4 (master) + 4×5 propagate · Phase B: 2 보호 + sha manifest 3 (Coin 승인 후) |
| Modules | cli infra (`.claude/rules` + `.claude/agents` + `.claude/skills`) |
| Risk | Low (Phase A) · Medium (Phase B 보호 file sha 절차) |
| DBMig / MoneyAuth | No / No |

## 2~7. Dependency / Architecture / Model / Error / UIState / Testability
- N/A (도구 참조 문서 정정 · 제품 코드/모델/테스트 무변경)

## 8. VerificationPlan
| VerifyCmds |
|---|
| `ToolSearch query="pencil"`(9종) · 제거 4종 active-call grep=0 · `bash scripts/propagate.sh <4 file> --targets all` · `bash scripts/verify-sync.sh` · 보호 5 git-sha1 §14a 일치 |

## 9. RollbackStrategy
- 문서/cli infra 전용: `git revert <commit>` 즉시 복구. 제품 코드 무접촉.

## 10. ExternalPrep / DeferredItems
- **Phase B = Coin 명시 승인 게이트**(보호 file·별 세션 권장). 무승인 진입 = STOP §6.
- 무접촉(별 cycle): cycle-discipline.md:164/:227(§25.2 동거) · scripts/propagate.sh run-* prune.

## Plan (Phase A)
1. pencil-mcp-tools-reference.md 정정(도구 SoT first · 13→9 · 제거 4종 stub + §0.1 표 + 대체). [DONE]
2. ux-auditor.md find_empty_space 실호출 제거 → snapshot_layout(maxDepth=0) · 호출 0 검증. [DONE]
3. pencil-cli / pencil-pen-save skill open_document 정정(Save-As 교훈 보존). [DONE]
4. commit(Phase A 단일 concern) → propagate(4 file) → verify-sync → 보호 5 sha drift 0.
5. 자식 4 file commit · §15 + incident-log + audit commit.

## Plan (Phase B · Coin 승인 후)
6. pencil-uiux-workflow.md + pencil-sot-policy.md open_document → 현 메커니즘(§2.5 본질 보존).
7. sha 3-layer 절차(protected-file-hashes.md + §14a + baseline-snapshot · attribution=본 cycle).
8. commit + propagate(byte-identical) + verify-sync(신 sha == manifest == §14a coherence).

## Notes
- cycle-discipline.md 무접촉(§25.2 WIP 동거 오염 회피 · 본 sweep scope 외).
- propagate `--prune` 미사용.
