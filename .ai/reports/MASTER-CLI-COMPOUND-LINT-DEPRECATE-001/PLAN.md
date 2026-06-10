# PLAN — MASTER-CLI-COMPOUND-LINT-DEPRECATE-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-COMPOUND-LINT-DEPRECATE-001 |
| Mode | M5 (cli-infra-ops · Stage B = 보호 5 file 접촉) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | cc-paste-MASTER-CLI-COMPOUND-LINT-DEPRECATE-001.md |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 31 (master) + 자식 5 × 29 propagation |
| Modules | cli infra (rules/skills/commands/agents/hooks) + docs + 보호 5 + manifest/§14a/§15 |
| Risk | Medium (보호 5 전수 접촉 · 체인 1회 통합) |
| DBMig | No |
| MoneyAuth | No |

## 2~7. DependencyDecision / ArchitectureImpact / ModelBoundaryPlan / ErrorPolicy / UIStateFlowPlan / TestabilitySeams
N/A (ops-layer · production 0 LOC)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `git grep -in 'compound[-_ ]lint'` 잔존 분류 + `python3 json.load`(ui-spec) + `bash scripts/propagate.sh <29 files> --targets all` + `bash scripts/verify-sync.sh` |

## 9. RollbackStrategy
문서 전용 변경: git revert <commit> 으로 즉시 복구 가능 (보호 체인 = manifest/§14a 동반 revert 의무).

## 10. ExternalPrep / DeferredItems
N/A

## Plan
1. 라이브 재측정 (6-repo HEAD + 보호 양층 sha + dual grep 전수 115/-i 117)
2. Stage A: 비보호 운영 live 인용 — 인용처별 재배선/제거/라벨-보존 (§FREEDOM · 불확실 시 라벨-보존)
3. Stage B: 보호 5 file 7줄 (compound-lint 5줄 + :22 lineage 연장 + :9 명칭 정정) · ui-spec JSON 무결
4. 보호 체인: manifest sha-256 5/5 → §14a git-sha1 5/5 → §15 entry → master commit
5. 6-repo propagation (29 file · path-limited 자식 commit) → verify-sync → REPORT → audit commit

## Notes
- 역사 영역(.ai/reports / propagation-reports / .auto-memory COLD / §15·§F 이력행) = 무접촉 보존.
- "5-repo" 어휘 = 같은 줄이어도 무접촉 (별 cycle O7).
- gsm 스캐너(.claude/rules backtick .sh) noise 0 유지 — rules 내 deprecate 라벨에 backtick 경로형 미사용.
