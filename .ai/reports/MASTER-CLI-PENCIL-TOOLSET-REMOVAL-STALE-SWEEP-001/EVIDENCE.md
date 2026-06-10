# EVIDENCE — MASTER-CLI-PENCIL-TOOLSET-REMOVAL-STALE-SWEEP-001

## Requirements Source
- paste source: `cc-paste-MASTER-CLI-PENCIL-TOOLSET-REMOVAL-STALE-SWEEP-001.md`
- 선행: PENCIL-SELFTEST-GATE-RECALIBRATE-001 LAND 후속 (동 Pencil v1.1.62 4종 제거 광역 stale 정리)
- Authority: M5 cli-infra-ops · Phase A(비보호 land) + Phase B(보호 2 file · **Coin 승인 게이트**)

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | 운영 레이어 변경 (cli infra · 문서/agent/skill/rule 정리) |
| Reading Mode | 6. CLI 운영 레이어형 (cli-ops · M5) |
| Info Gap | RESOLVABLE_IN_REPO |
| STOP Risk | 보호 file sha 절차(#5) · 외부 WIP · cycle-discipline 편집 · 제거 도구 호출 잔존 · Phase B 무승인 진입 |
| Implementer Entry | Allowed (Phase A) · Blocked (Phase B 무 Coin 승인) |

## Step 0 — baseline + WT 위생
- HEAD `5199111` (cowork baseline 일치 · drift 0).
- sweep 대상 file (ux-auditor / pencil-mcp-tools-reference / pencil-cli·pencil-pen-save skill / pencil-uiux-workflow / pencil-sot-policy) = WT clean.
- parked WIP (cycle-discipline.md §25.2 · scripts/propagate.sh run-* · archive/…bak) = 무접촉 확인.

## Step 1 — 도구 surface 측정
- `ToolSearch query="pencil"` → **9 종**: batch_design / batch_get / export_nodes / get_editor_state / get_guidelines / get_screenshot / get_variables / set_variables / snapshot_layout.
- 제거 4 종 부재 확인: open_document / find_empty_space_on_canvas / search_all_unique_properties / replace_all_matching_properties.

## Collect — 제거 4종 blast radius (content grep · A7 dual)
| 제거 도구 | 참조 file |
|---|---|
| open_document | pencil-uiux-workflow.md(보호·B) · cycle-discipline.md(제외) · pencil-mcp-tools-reference.md(A) · pencil-cli/SKILL.md(A) · pencil-pen-save/SKILL.md(A) · pencil-sot-policy.md(보호·B) |
| find_empty_space_on_canvas | ux-auditor.md(A·런타임) · pencil-uiux-workflow.md(B) · cycle-discipline.md(제외) · pencil-mcp-tools-reference.md(A) |
| search_all_unique_properties | pencil-uiux-workflow.md(B) · cycle-discipline.md(제외) · pencil-mcp-tools-reference.md(A) |
| replace_all_matching_properties | pencil-uiux-workflow.md(B) · cycle-discipline.md(제외) · pencil-mcp-tools-reference.md(A) |

## Key Findings
- 아키텍처 = 이미 §2.5(D7) headless 평문-JSON PRIMARY 전환 완료 → 제거 4종 = 전부 ALTERNATIVE(desktop-app+MCP) 경로 소속. sweep = 참조 정정 + 도구수 13→9 + ux-auditor 런타임 위험 1건.
- cycle-discipline.md = 제거 4종 참조하나 §25.2 WIP 동거 → **본 sweep 제외**(편집 시 propagate 오염). :164(§13 historical 명단) + :227(Path 2-A) = §25.2 land cycle 동반 처리.

## Cleanup Assessment
N/A (ops-layer task — 제품 코드 미변경)

## Phase A 변경 (4 file · 비보호)
- `pencil-mcp-tools-reference.md`(도구 SoT): header/§0/Part A count 13→9 · §0.1 제거 도구 표 + 대체 메커니즘 신설 · §2.2/§3.1/§3.2/§7 = ⚠REMOVED stub · §1.2.3 audit note(search/replace→batch_get+batch_design/headless) · §10 STOP(9 surface·open_document path-arg moot) 정합.
- `ux-auditor.md`:108 `find_empty_space_on_canvas` 실호출 → `snapshot_layout(maxDepth=0)` (런타임 위험 해소 · 호출 0 검증) · :110 count 9.
- `pencil-cli/SKILL.md`:168 open_document baseline → (구) + 제거 명시 + headless-primary redirect.
- `pencil-pen-save/SKILL.md`:28/34 open_document workflow → 제거 banner + headless-primary(§13) redirect (Save-As 교훈 보존).

## Phase B (보호 2 file · Coin 승인 대기)
- `pencil-uiux-workflow.md`(보호) + `pencil-sot-policy.md`(보호) = open_document 등 → 현 메커니즘. sha 3-layer 절차(protected-file-hashes.md sha-256 + §14a git-sha1 + baseline-snapshot) 동반 의무. **§6 STOP: Coin 명시 승인 없이 진입 X.**
