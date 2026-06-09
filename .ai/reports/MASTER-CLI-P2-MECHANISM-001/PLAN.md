# PLAN — MASTER-CLI-P2-MECHANISM-001 (M5 lightweight)

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-P2-MECHANISM-001 |
| Mode | M5 cli-infra-ops |
| Workflow | Collect → Plan → Implement → Propagate → Verify → Review |
| Requirements Source | ../cc-paste-MASTER-CLI-P2-MECHANISM-001.md |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 4 (master cli infra) + CLAUDE.md §15 + propagation-status(auto) |
| Modules | .claude/rules + .claude/skills (no domain code) |
| Risk | Low (advisory rule/skill 문구 · pointer only) |
| DBMig | No |
| MoneyAuth | No (도메인=rule/skill 문서 · STOP #1 미발동) |

## 2~7. (N/A — ops-layer · 제품 코드/의존성/모델/오류/UI/테스트 변경 0)

## 8. VerificationPlan
- `bash scripts/propagate.sh <4 paths> --targets all` (ok=20/0 기대)
- `bash scripts/verify-sync.sh` (160/0/0 기대)
- `git hash-object <보호 5종>` (§14a baseline drift 0 기대)

## 9. RollbackStrategy
- 문서 전용: `git revert 878521f` (+ 5 자식 revert) 으로 즉시 복구. 비가역 변경 0.

## 10. ExternalPrep / DeferredItems
- N/A.

## Plan (작업 목록)
1. §A workflow-core.md `## /plan 규칙` — 신규 출시 deliverable 등재(upstream) subsection (pointer → launch-status-sync skill).
2. §B rule-routing-index.md §I — SoT 변경 → 하위 §3 task drift 검출 의무 note (SoT 본문 편집 아님).
3. §C launch-status-sync/SKILL.md — 의무 3→5 (④ KR 귀속 gate + ⑤ 완료분 always-fresh) + §3.4/§3.5 + count 정합 + §12 history.
4. (4번째) cycle-discipline.md §25.2 mirror 3→5 동기 (SSOT 정합).
5. CLAUDE.md §15 entry → propagate → verify-sync → report-gen → 자식 5 commit → audit commit.

## Notes
- §FREEDOM: 문구/배치 자율. 경계 = STOP 9 + 무접촉 강제군(보호 5 / SoT 4층 / production / rename).
