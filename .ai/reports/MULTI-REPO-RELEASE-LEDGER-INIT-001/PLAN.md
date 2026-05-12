# PLAN — MULTI-REPO-RELEASE-LEDGER-INIT-001 / master

## TaskId
MULTI-REPO-RELEASE-LEDGER-INIT-001

## Mode / Workflow
docs (operating-layer-adjacent · ops-layer task) · Collect → Plan → Implement → Verify → Review

## Scope
- 4-repo (claude-cli-master + GentlyBreath + GentlyDay + GentlyTable) 동시 cycle 의 master 측 entry.
- app-foundation 미신설 = 본 cycle scope 제외 (MASTER-T01 별 cycle 의제).

## Baseline (2026-05-10 18:35 KST)
- master = 7334e87 · GB = de1a97a · GD = a7cac49 · GT = 230ca64
- 보호 5 sha (이전 prompt 그대로):
    - docs/schemas/ui-spec.schema.json 5b84cd9e4bc36165
    - .claude/rules/uiux-sot-refresh.md d3a0b57390bd0414
    - docs/design/design-sot-policy.md e580b6d7ca9a88ae
    - .claude/rules/pencil-uiux-workflow.md 3a703b30553e0d09
    - docs/design/pencil-sot-policy.md b27fbe16edb68821
- 별 cycle 산출 (정합 검증만): .claude/rules/billing-rules.md 0ec5d54f49dfd6e2 (4-repo byte-identical)

## ChangeBudget
- 6 git op (4 commit · 1 add per repo + 1 stage check op)
- 16 .ai/reports file (4 file × 4 repo)
- 1 decision-log entry append (master)

## Dependency
- master commit 먼저 (자식 cycle 의 master ledger 참조 의존성)
- 자식 GB / GD / GT = 독립 (병렬 commit 가능)
- decision-log append = 4 commit sha 4 건 회수 후

## ArchitectureImpact
- ledger 영역 신설 only · code/agent/rule 영역 변동 X
- ledger ID 표준 = `<repo>-T<NN>` 박음 (master 자체 task = MASTER-T<NN>, 자식 = GB/GD/GT-T<NN>)
- 갱신 trigger = 자식 cycle REVIEW PASS 시 master ledger cleanup pass 자동

## ModelBoundaryPlan
- 본 cycle = ledger file commit 만 · 본문 편집 X (Cowork 측 작성 그대로)
- ledger ID 명명 변경 X
- app-foundation repo 신설 X
- 자식 cycle 본 작업 진행 X

## File Stage 의무
- master commit 안 동시 stage:
    - docs/release-readiness/PACKAGE-OVERVIEW.md (96 line)
    - docs/release-readiness/COMMON-SETUP-SSOT-DRAFT.md (114 line)

## Stage 금지 항목 (cycle 무관 dirty)
- .auto-memory/propagation-status.md (M · 별 cycle 영역)
- .ai/reports/MASTER-CLI-TERMINOLOGY-SOT-SSOT-DEFINE-001/ (?? · 별 cycle 영역)
- gradlew.bat (cycle 무관 · 본 status 시점에는 dirty X)

## STOP 조건 모니터링
- HEAD baseline mismatch → STOP
- docs/release-readiness/ 부분 존재 → STOP + RCA
- 보호 5 sha 변동 → STOP + 별 mitigation
- ledger line 수 mismatch → STOP + cowork 회수
- billing-rules.md sha mismatch → STOP + 별 mitigation
