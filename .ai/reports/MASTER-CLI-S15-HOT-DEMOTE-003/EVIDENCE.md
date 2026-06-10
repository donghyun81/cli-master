# EVIDENCE — MASTER-CLI-S15-HOT-DEMOTE-003

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | 운영 레이어 변경 (cli-infra context diet) |
| Reading Mode | 6. CLI 운영 레이어형 (M5) |
| Requirement Source | cc-paste-MASTER-CLI-S15-HOT-DEMOTE-003.md (frontmatter agent-commit: yes) |
| Info Gap | RESOLVABLE_IN_REPO (전량 disk 실측) |
| STOP Risk | 없음 (production 무접촉 · 보호 edit-set 교집합 ∅) |
| Implementer Entry | Allowed (M5 master-only) |

## Baseline (disk 실측 · 진입 시점)
- master HEAD `a2e4adf` · clean · origin 일치 (work-order §0 = push cross-verify 6/6 MATCH).
- §15 hot = **13** (hook 동일 awk 실측 · GSM-S15-HOT advisory 3 cycle 연속 발화 baseline).
- COLD `.auto-memory/master-cycle-history-COLD.md` = 103 entry (129 line).
- master CLAUDE.md char = **40,464** (codepoint · context-health §2 의 "~26K/23,716" 은 §15 비대 누적 미반영 stale).
- 보호 5 sha-256: `8502c014`(ui-spec.schema) · `b09b8d50`(pencil-uiux-workflow) · `2bfc81c5`(pencil-sot-policy) · `e3b9891d`(uiux-sot-refresh) · `4c566615`(design-sot-policy) — work-order §0 baseline 과 일치.

## Collect Results
- §15 13 data rows = 5번째 cold pointer 직전 표. 내부 line 298 = **table-split 빈 줄**(markdown 표 분리 결함 · 선재).
- COLD §1 heading = "94 entry"(line 11) ↔ blockquote(line 13) "103 entry" 불일치 = 직전 AUTO-DEMOTE +9 batch heading 미반영 stale (선재).
- COLD 마지막 data row = `MASTER-PRINCIPLES-OKR-ROUTING-001`(2026-06-07) → append point.

## Cleanup Assessment
N/A (ops-layer task — 제품 코드 미변경)

## Key Findings
- demote 8 = oldest (`P2-MECHANISM` 2026-06-09 ~ `PROTECTED-STALE-PATH-FIX` 2026-06-10) · retain 5 = newest (`COMPOUND-LINT-DEPRECATE` ~ `INFRA-SMALL-BATCH`).
- 이전 = list-slice 객체 이동(재타이핑 0) → verbatim 보장. 독립 검증 source = git `HEAD:CLAUDE.md`.
