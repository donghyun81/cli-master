# PLAN — MASTER-CLI-INFRA-SELFIMPROVING-REVIEW-CADENCE-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-INFRA-SELFIMPROVING-REVIEW-CADENCE-001 |
| Mode | ops-layer (cli infra · 제품 코드 무접촉) |
| Workflow | discipline 류 → §11 lightweight 4 file (PLAN / VERIFY / REVIEW / TODO) |
| Requirements Source | 사용자 통합 prompt (cycle 2 master infra · Anthropic blog 2026-05-14 권고 B-1 + B-3 흡수) |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 3 (cli infra) · 5-repo × 3 = 15 sha 측정 |
| Modules | `.claude/rules/` + `.claude/hooks/` + `.claude/settings.json` |
| Risk | Low (ops-layer · 제품 코드 무접촉 · 기존 quality gate 영역 분리 hook) |
| DBMig | No |
| MoneyAuth | No |

## 2~10. (Low Risk 경량화 · `workflow-core.md` §implement Risk-based 정합)

§2~§10 = N/A. ops-layer + Low Risk → §1 ChangeBudget + §8 VerificationPlan + 작업 목록 한정.

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `bash .claude/hooks/stop-reflect.sh` (silent-success) + 4 fixture self-test + `bash scripts/verify-sync.sh` (5-repo cross-verify) |

## Plan

1. cycle-discipline.md §18 (분기 review cadence) + §19 (Hooks self-improving loop) 본문 추가
2. .claude/hooks/stop-reflect.sh 신설 (paradigm 누적 grep · 임계 3+회 · silent-success default · exit 0)
3. .claude/settings.json Stop hook 영역에 stop-reflect.sh 추가 등록
4. 4 fixture self-test (silent-success · 3 회 발화 · 2 회 미달 · REFLECT_ENFORCE=silent 모드)
5. 기존 stop-gate.sh 미breakage 검증 (격리된 임시 git repo 안 PLAN+EVIDENCE fixture)
6. propagate.sh 5-repo (master + GB + GD + GT + app-foundation) 단방향 cp
7. verify-sync.sh cross-verify (본 cycle 3 file 측 byte-identical 확정)
8. master + 4 자식 commit (subject + body 6 섹션)
9. REVIEW.md 사용자 deliverable 5 영역 명시

## Notes

- Anthropic blog "How Claude Code works in large codebases" (2026-05-14) 권고 B-1 (분기 review) + B-3 (self-improving hook loop) 두 영역 동시 흡수 cycle.
- GD HEAD anchor stale (baseline `c72d1aa2` 측 → 현 `0d5fb1c`) = docs/report commit 단독 추가 영역 · cli infra 3 file + 보호 5 file sha 측 모두 baseline 정합 → 본 cycle scope 무영향.
- 보호 file 5종 sha 무변동 의무 (§3.1 STOP 조건 정합).
- stop-reflect.sh = stop-gate.sh 와 분리 (SRP 정합 · `code-principles.md` §1).
