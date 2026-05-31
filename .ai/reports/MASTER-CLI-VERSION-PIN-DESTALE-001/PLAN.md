# PLAN — MASTER-CLI-VERSION-PIN-DESTALE-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-VERSION-PIN-DESTALE-001 |
| Mode | M5 cli-infra-ops |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | cc-paste · MASTER-CLI-VERSION-PIN-DESTALE-001 |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 2 (propagation 대상) + CLAUDE.md §15 (master only) |
| Modules | cli infra (`.claude/hooks/` + `docs/templates/`) |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2~7. (N/A — ops-layer · production code 무접촉)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `grep -c '2\.1\.114'` (2 file = 0 · cycle-discipline.md = 2 보존) · `bash -n session-start.sh` · `bash scripts/verify-sync.sh` |

## 9. RollbackStrategy
- git revert a755a42 (master) + 자식 4 revert 로 즉시 복구 가능 (문서/설정 전용 · 비가역 영역 0).

## 10. ExternalPrep / DeferredItems
- N/A

## Plan
1. session-start.sh L79-86 version block 정정 (옵션 b: hardcode compare + 다운그레이드 WARN + pin PASS 제거 → cc_version 진단 echo 보존).
2. setup-guide.template.md L11 정정 (2.1.114 박힘 → latest · §13 latest-chase · @anthropic-ai/claude-code@latest).
3. master commit (2 file) → propagate → 4 child commit → verify-sync → CLAUDE.md §15 audit.

## Notes
- 옵션 b 채택 근거: §13 self-test item 1 (`claude --version` raw capture → EVIDENCE) = cli session 측 manual 의무 (hook 기능 아님) · hook 진단 echo 제거 시 §13 공백 X · 기존 session banner (branch/open_tasks/last_review/promptfit/protected_baseline_count) 패턴 정합.
- scope-out (무접촉): cycle-discipline.md L139+L194 (history 보존) · pencil-uiux-workflow.md (보호 file · Cycle 2 PROTECTED).
