# PLAN — MASTER-CLI-WORKTREE-PARADIGM-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-WORKTREE-PARADIGM-001 |
| Mode | M5 (cli-infra-ops) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | /Users/yundonghyeon/AndroidStudioProjects/cc-paste-MASTER-WORKTREE-PARADIGM-001.md (§3 contract D1~D8 Coin 본심 확정) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 5 (rule 3 + 부모 root CLAUDE.md + master CLAUDE.md §15) + 산출물 |
| Modules | .claude/rules (cli infra) · 부모 mount root (git-외) |
| Risk | Low (문서 한정 · production 0 LOC · 보호 5 무접촉) |
| DBMig | No |
| MoneyAuth | No |

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash scripts/verify-sync.sh` (exit 0 의무) + 보호 5 sha manifest 대조 + worktree refs grep |

## Plan
1. §0 baseline 라이브 재측정 (6-repo bash 한정) — paste 표 대조
2. detail.md §2.1.5 영역 1.5 본문 canonical 신설 (D1~D8 전수 반영)
3. kernel 1-bullet 요약 + §8 이력 / automation-policy §2 #12 Transport 행 (후보 채택)
4. 부모 root CLAUDE.md §3.3 행 + §4 영역 1.5 행 (직접 갱신 · git-외)
5. master commit → propagate 3 file --targets all → 자식 5 staged commit → verify-sync → REPORT
6. §15 entry + 산출물 4 + audit commit

## Notes
- 변경 후보 처분: automation-policy **채택** (Transport 분류 SoT 표 = 실 분류 가치) / mode-system **미채택** (L0 kernel 항상-on 으로 M5 행동 시 영역 1.5 요약 자동 노출 + mode 행동층 ↔ 실행 paradigm 직교) / anchor-list **미채택** (A4/A6 본질 무변동 · purpose-수준 hot 영역 양 최소화 · gsm-measurement §5 가드레일).
- scope-creep 금지 준수: worktree 만 · loop/goal/verifier 도입 0.
