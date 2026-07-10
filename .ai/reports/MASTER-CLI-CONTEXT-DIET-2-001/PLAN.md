# PLAN — MASTER-CLI-CONTEXT-DIET-2-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-CONTEXT-DIET-2-001 |
| Mode | M5 cli-infra-ops |
| Workflow | §0 baseline → T1~T8 → §3 contract 검증 → propagation+verify-sync → §7 paste-back |
| Requirements Source | `../cc-paste-MASTER-CONTEXT-DIET2-001.md` |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 32 (rule 26 편집 + rule 2 신설 + template 2 신설 + COLD 2 신설) + master-only audit 4 |
| Modules | `.claude/rules/` + `.auto-memory/` + `docs/templates/` 한정 (paste §1) |
| Risk | Medium (파일 수 多 · 단 production 0 LOC · 의미 변경 금지 계약) |
| DBMig | No |
| MoneyAuth | No |

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `diff <(git show HEAD:...) <(tail ...)` verbatim 4구간 + 표본 grep 15쌍 + `shasum -a 256` 보호 5 + `bash scripts/verify-sync.sh` exit 0 + wc -c 전/후 |

## 9. RollbackStrategy
- 문서 전용: `git revert <content-commit>` 즉시 복구 + 자식 propagation commit revert (역순).

## Plan
1. §0 baseline 재측정 (HEAD·dirty·6-repo·manifest·hook 주입 실측) ✓
2. T1 cycle-discipline diet (COLD 전문 snapshot + hot 12.7K 재작성) ✓
3. T2 rule-routing-table.md 신설 + index §B/§F 이전 + 카운트 46→48 ✓
4. T3 PLAN/REVIEW 스키마 → docs/templates 이전 + N/A 집계 + 측정 기록 형식 ✓
5. T4 abbreviation-policy 의무 로드 제외 (table + 헤더 1줄) ✓
6. T5 L0 재정독 개정 (table/index §0 + anchor A1/A2 + cycle-discipline §8/§14a · STOP#5 불변) ✓
7. T6 rule-footer-common.md 신설 + 20 file footer pointer 치환 ✓
8. T7 billing split UNVERIFIED 병기 (anchor A6·kernel §2.4·detail §2.2·workflow-policy·plugin-policy · 행동 규정 불변) ✓
9. T8 세션 운영 P0 3줄 (cycle-discipline §12 신설) ✓
10. §3 contract 검증 → commit → propagate 30 file → verify-sync → REPORT → §15/context-health/audit

## N/A 집계 (T3 개정 형식)
N/A: §2 DependencyDecision · §3 ArchitectureImpact · §4 ModelBoundaryPlan · §5 ErrorPolicy · §6 UIStateFlowPlan · §7 TestabilitySeams · §10 ExternalPrep
