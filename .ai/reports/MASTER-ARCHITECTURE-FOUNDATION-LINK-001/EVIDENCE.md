# EVIDENCE — MASTER-ARCHITECTURE-FOUNDATION-LINK-001

## Requirements Source

- Cowork prompt (= ledger MASTER-T04) · 2026-05-12 KST
- 본심: 13 architecture 문서 측 foundation 인용 link 박은 박음 갱신 박음 + cli infra 측 신규 정책 신설 박음 (= 5-repo cli infra 권장 byte-identical 영역 박음).
- Authority boundary: master 박은 박은 + 4 자식 측 propagation 박은 박은 박음 (= 5-repo cli infra 권장 byte-identical 영역).

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | 운영 레이어 (ops-layer · docs/agent/architecture/ + .claude/rules/) |
| Reading Mode | CLI 운영 레이어형 |
| Requirement Source | prompt + ledger MASTER-T04 |
| Info Gap | RESOLVABLE_IN_REPO (= grep 박은 박음 박은 영역 박은 박음 박은 박은 박은 박은 영역 박음) |
| STOP Risk | 보호 5 sha 변동 X 의무 박음 + 병렬 cycle X 박은 박은 박음 (= sequential 의무 박음) |
| Read-Only Fan-Out | N/A (= ops-layer 박은 단순 변경 박은 박음) |
| Implementer Entry | Allowed |

## Pre-EVIDENCE Contract

- Read evidence: 13 architecture file (grep 박은 영역 박음 8 file · 추가 inspection 박은 KMP_CMP_LAYER_DIRECTION + ERROR_RESULT_POLICY 박은 박음) + app-foundation 측 디렉터리 박은 박음 + cycle-discipline §13 박은 박음.
- Remaining gaps: 없음.
- Chosen path: 7 file 측 첫 등장 시 link 박음 (= verbose 박음 회피 박음) + 신규 cli infra `architecture-foundation-link-policy.md` 신설 박음 + 5-repo file 명시 propagation 박음 (= 사전 DRIFT 2 영역 박은 영역 박은 자동 흡수 회피 박음).
- Hold / Stop reasons: 없음 (= 보호 5 sha 변동 X + master HEAD 박은 baseline 박은 박은 박음).
- Implement entry conditions: §13 self-test 3/3 PASS 박음 + 보호 5 sha baseline 박은 박음 + 5-repo HEAD 새 baseline 박은 박음 + verify-sync 사전 DRIFT 2 영역 박은 박은 영역 박은 별 cycle 박은 박음.

## Collect Results

### §13 self-test 박음 (= cycle-discipline §13 의무)

| # | self-test | 결과 |
|---|---|---|
| 1 | `claude --version` | `2.1.121 (Claude Code)` ✓ |
| 2 | `claude mcp list` | `pencil: /Applications/Pencil.app/... - ✓ Connected` ✓ |
| 3 | `ToolSearch query="pencil"` | 13 tools 박음 (= batch_design / batch_get / export_nodes / find_empty_space_on_canvas / get_editor_state / get_guidelines / get_screenshot / get_variables / open_document / replace_all_matching_properties / search_all_unique_properties / set_variables / snapshot_layout) ✓ |

### 5-repo HEAD baseline 박음 (= prompt §A vs CLI 재실측 박음)

| repo | prompt §A baseline | CLI 재실측 | 변동 |
|---|---|---|---|
| claude-cli-master | `9487f16` | **`f1fc0bd6f2ac`** | +1 commit (= `CLI-VERSION-UNPIN-PROPAGATION-001`) |
| app-foundation | `f1f40f4` | `f1f40f42f706` | ✓ 동일 박음 |
| GentlyBreath | `0552529` | **`16f2816d0598`** | +3 commit (= CLI-VERSION-UNPIN + SENTRY + FIREBASE) |
| GentlyDay | `4d867cc` | **`96de0087125c`** | +3 commit (= CLI-VERSION-UNPIN + revert + GD-OPEN-DESIGN-POC) |
| GentlyTable | `d90c19e` | **`cc0a8feef83a`** | +3 commit (= CLI-VERSION-UNPIN + SENTRY + FIREBASE) |

= **새 baseline 박음 적용 박음 박음** (= 사용자 결정 박음 옵션 C 정합 박음).

### 보호 5 sha baseline 박음 (= 변동 X 의무 박음)

| 파일 | sha-16 prefix | baseline 일치 |
|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `5b84cd9e4bc36165` | ✓ |
| `.claude/rules/uiux-sot-refresh.md` | `d3a0b57390bd0414` | ✓ |
| `docs/design/design-sot-policy.md` | `e580b6d7ca9a88ae` | ✓ |
| `.claude/rules/pencil-uiux-workflow.md` | `3a703b30553e0d09` | ✓ |
| `docs/design/pencil-sot-policy.md` | `b27fbe16edb68821` | ✓ |

= 변동 X 박음 ✓.

### app-foundation 측 실제 박힌 path 박음 (= link 박을 영역 박음 baseline)

| path | 박힌 영역 | link 박음 |
|---|---|---|
| `shared/domain` | ✓ | **link 박음** |
| `shared/data` | ✓ | **link 박음** |
| `shared/feature-state` | ✓ | **link 박음** |
| `shared/app` | X (= 부재 박음) | link X 박음 |
| `core/{analytics,billing,di,feature-flag,network,notification,observability,supabase}` | ✓ (8 sub) | link X 박음 (= 13 architecture 측 인용 X) |
| `composeApp/` | 빈 디렉터리 박음 | link X 박음 |
| `iosApp/` | 빈 디렉터리 박음 | link X 박음 |

### 13 architecture file 측 코드 path 인용 영역 grep 결과

| # | file | 인용 박은 영역 (occurrences) | link 박을 영역 |
|---|---|---|---|
| 1 | ADR_TEMPLATE.md | 0 | X |
| 2 | COMMON_ARCHITECTURE.md | 1 (L14 박음 박은 영역) | `shared/` 측 첫 등장 → link 박음 |
| 3 | COMPOSE_STABILITY.md | 0 | X |
| 4 | DEPENDENCY_DECISION_CHECKLIST.md | 0 | X |
| 5 | ERROR_RESULT_POLICY.md | 2 (= L21 + L40 code block 박음) | **X** (= code block 안 박음) |
| 6 | KMP_CMP_LAYER_DIRECTION.md | 16 | L4 박은 영역 첫 등장 시 link 박음 (3 path 박음) |
| 7 | KOIN_DI_BASELINE.md | 8 | L4 + L25~L27 박은 박은 링크 박음 |
| 8 | LEGACY_CLEANUP_GOVERNANCE.md | 0 | X |
| 9 | MODEL_SEPARATION.md | 1 (L14 table 박음) | L14 박은 영역 link 박음 |
| 10 | PROPAGATION_PARAMETERS.md | 0 | X |
| 11 | SSOT_PRINCIPLES.md | 1 (L46) | L46 link 박음 |
| 12 | TDD_WORKFLOW.md | 5 (L50~L53 + L77) | L50 박은 첫 등장 시 link 박음 |
| 13 | TESTABILITY_SEAMS.md | 6 (L97 박은 박은 박은 첫 등장 박음) | L97 link 박음 |

= 진정한 link 박을 영역 = **7 file 박음** (= ERROR_RESULT_POLICY 측 code block 박은 X 박음).

### 사전 DRIFT 2 영역 박음 (= 별 cycle 박음 박은 박음)

| 영역 | 사유 |
|---|---|
| **DRIFT-1**: `cycle-discipline.md` app-foundation propagation 박음 X | CLI-VERSION-UNPIN-PROPAGATION-001 cycle 측 5-repo propagation 박은 박은 app-foundation 측 1 미박음 박은 사고 박음 (= subject "4-repo byte-identical propagation 마감" 박은 박은 mismatch) |
| **MISS-4**: `release-checklist.template.md` 자식 4 propagation 박음 X | MASTER-RELEASE-CHECKLIST-TEMPLATE-001 cycle 측 자식 propagation 박음 X 박음 영역 박음 |

= 본 cycle scope X 박음 · 사용자 명시 별 cycle 박음 (= CLI-VERSION-UNPIN-PROPAGATION-002 + MASTER-RELEASE-CHECKLIST-TEMPLATE-002).

## Key Findings

1. **link 박을 영역 = 7 file 박음** (= ERROR_RESULT_POLICY 측 code block 박은 박은 영역 박음 = link X 박은 의무 박은 박은 박음).
2. **5-repo byte-identical relative path = `../../../../app-foundation/<path>`** (= 4 step 박음 박은 5-repo 동일 박음 + foundation 측 자기 link 박음 정합 박음).
3. **사전 DRIFT 2 영역 박은 본 cycle scope X** (= 사용자 결정 옵션 C 박음 정합 박음 · 별 cycle 박음 박은 박음).
4. **§13 self-test 3/3 PASS 박음** ✓.

## Cleanup Assessment

N/A (ops-layer task — docs/agent/architecture/ + .claude/rules/ 측 markdown link 추가 박은 박은 + 신규 cli infra 신설 박은 박은 · 제품 코드 미변경 박은 박음)
