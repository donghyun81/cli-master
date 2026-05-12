# VERIFY — MULTI-REPO-RELEASE-LEDGER-INIT-001 / master

## Post-commit 검증 절차

1. 보호 5 sha 재실측 (master 측) — git rev-parse HEAD:&lt;file&gt; cut -c1-16
2. .claude/rules/billing-rules.md sha 4-repo byte-identical (별 cycle 산출 무결성)
3. bash scripts/verify-sync.sh — exit 0 의무
4. .auto-memory/protected-file-hashes.md sha 변동 X 검증 (master 측 git status)
5. 4-repo HEAD sha 4 건 cross-reference (REVIEW.md 안 박음)

## Verify 결과 (post-commit)

### 4-repo 신규 HEAD sha (12자)
| repo | sha |
|---|---|
| master | adda16f9e91b |
| GB | 397a5df8a34f |
| GD | 3d49e2eabb89 |
| GT | ec26196f11b1 |

### 보호 5 sha post-commit (변동 X · baseline 일치)
| file | sha |
|---|---|
| docs/schemas/ui-spec.schema.json | 5b84cd9e4bc36165 |
| .claude/rules/uiux-sot-refresh.md | d3a0b57390bd0414 |
| docs/design/design-sot-policy.md | e580b6d7ca9a88ae |
| .claude/rules/pencil-uiux-workflow.md | 3a703b30553e0d09 |
| docs/design/pencil-sot-policy.md | b27fbe16edb68821 |

### .claude/rules/billing-rules.md (4-repo byte-identical · 변동 X)
- master / GB / GD / GT = 0ec5d54f49dfd6e2

### scripts/verify-sync.sh
- 실행 결과: (post-commit 본 VERIFY.md 작성 시 캡쳐)

### .auto-memory/protected-file-hashes.md
- 변동 X (CLI 갱신 행동 금지 의무 준수)

## STOP 조건 post-commit 재검증
- HEAD baseline mismatch X (4-repo HEAD = 신규 commit sha · cycle 정상 진행)
- 보호 5 sha 변동 X
- billing-rules.md sha 변동 X
- ledger file line mismatch X (각 commit 안 line 수 baseline 일치)
- protected-file-hashes.md 변동 X
