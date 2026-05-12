# EVIDENCE — MASTER-CLEANUP-PROPAGATION-BUNDLE-001

## Requirements Source

- 본 cycle TaskId = MASTER-CLEANUP-PROPAGATION-BUNDLE-001
- 의제 = TRAIL-1 (CLI-VERSION-UNPIN-PROPAGATION-002) + TRAIL-2 (MASTER-RELEASE-CHECKLIST-TEMPLATE-002) + TRAIL-11 (CLAUDE-CODE-LATEST-CHASE-POLICY-CLARIFY-001 측 app-foundation 측 propagation 누락) 3 trail 묶음 close.
- 정합 결정 = Path-C (= 실측 정합 단일 진실 · 5-repo byte-identical 5/5 회복 단일 진실).
- Cowork chat 측 본심 회수 결과 = master 측 cycle-discipline.md HEAD blob (sha 5726cb44c5f4d53d) propagation 흡수 영역 본 cycle 진행.

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | 운영 레이어 변경 (cli infra propagation) |
| Reading Mode | CLI 운영 레이어형 |
| Requirement Source | 본 cycle prompt + cowork chat 측 baseline 재 측정 |
| Info Gap | RESOLVABLE_IN_REPO (= 실측 5-repo sha + git log 측 baseline 충족) |
| STOP Risk | 보호 5 sha 변동 + scope 외 stage 흡수 + cp 후 sha mismatch + byte-identical 5/5 미달 — 모두 실측 PASS |
| Read-Only Fan-Out | 없음 (= 본 cycle 단순 propagation 영역) |
| Implementer Entry | Allowed |

## Pre-EVIDENCE Contract

- Read evidence: 5-repo HEAD + 5-repo cycle scope file sha + 보호 5 sha + master 작업 트리 dirty 영역 + 자식 4 측 기존 dirty 영역.
- Remaining gaps: 없음 (= 실측 PASS · 본 cycle scope 외 영역 stage 격리 사전 인지 마감).
- Chosen path: Path-C (= 실측 정합 단일 진실 · 5-repo byte-identical 회복).
- Hold / Stop reasons: 없음.
- Implement entry conditions: 실측 baseline PASS + STOP 조건 5 항목 사전 인지 마감 + 본 cycle scope 외 영역 (= master 측 .ai/baseline-snapshot/* + 자식 4 측 기존 dirty 영역) 무접촉 의무 정합.

## Collect Results

### 측정 baseline (= STEP 1)

| 항목 | 측정값 |
|---|---|
| master HEAD | `e31dc2707e7debf3663855ac3f8b2428209258dc` |
| app-foundation HEAD (pre-cycle) | `18b3f6ef68dd8126fe574c70bcd930ced550d146` |
| GentlyBreath HEAD (pre-cycle) | `f248d87a409b7551eeacc6f62d73c9f1900a9dbe` |
| GentlyDay HEAD (pre-cycle) | `4b9c0cf5cf84cd997823e67bbcc98819f636083d` |
| GentlyTable HEAD (pre-cycle) | `e279257673122cafcf82709525b1db6165cc7804` |
| master 측 cycle-discipline.md HEAD blob | `5726cb44c5f4d53d` |
| master 측 release-checklist.template.md HEAD blob | `bd112d5457409e7a` |

### drift 분포 (= 본 cycle 진입 시점)

| repo | cycle-discipline.md (pre-cycle) | release-checklist.template.md (pre-cycle) |
|---|---|---|
| master | `5726cb44c5f4d53d` (✓) | `bd112d5457409e7a` (✓) |
| app-foundation | `4cd01b4eca11feee` (✗ · TRAIL-11 drift) | 부재 (✗ · TRAIL-2 miss) |
| GentlyBreath | `5726cb44c5f4d53d` (✓ · 별 cycle 측 propagation 마감) | 부재 (✗ · TRAIL-2 miss) |
| GentlyDay | `5726cb44c5f4d53d` (✓ · 별 cycle 측 propagation 마감) | 부재 (✗ · TRAIL-2 miss) |
| GentlyTable | `5726cb44c5f4d53d` (✓ · 별 cycle 측 propagation 마감) | 부재 (✗ · TRAIL-2 miss) |

### 보호 5 sha (= 변동 X 의무 baseline)

| path | sha-16 (측정) | baseline §3 |
|---|---|---|
| docs/schemas/ui-spec.schema.json | `5b84cd9e4bc36165` | ✓ |
| .claude/rules/uiux-sot-refresh.md | `d3a0b57390bd0414` | ✓ |
| docs/design/design-sot-policy.md | `e580b6d7ca9a88ae` | ✓ |
| .claude/rules/pencil-uiux-workflow.md | `3a703b30553e0d09` | ✓ |
| docs/design/pencil-sot-policy.md | `b27fbe16edb68821` | ✓ |

### master 측 working tree dirty 영역 (= 본 cycle 무접촉 의무)

- `.ai/baseline-snapshot/latest.json` (M · 별 cycle 영역)
- `.ai/baseline-snapshot/20260512T064910+0000.json` (?? · 별 cycle 영역)
- `.ai/baseline-snapshot/20260512T154651+0900.json` (?? · 별 cycle 영역)
- 본 cycle 안 추가 산출물 = .ai/reports/MASTER-CLEANUP-PROPAGATION-BUNDLE-001/ + .auto-memory/* 갱신 영역 (= master audit commit 측 명시 path add)

### 자식 4 측 working tree dirty 영역 (= 본 cycle 무접촉 의무)

- app-foundation: `.gitignore` (M) + `gradlew.bat` (M) — 별 cycle 영역.
- GentlyBreath / GentlyDay / GentlyTable: `.idea/*` + `cc-paste-*.md` 등 다수 entry — 모두 본 cycle scope 외 영역.

## Key Findings

1. Cowork chat 측 baseline §1 (= master HEAD `a3605df`) 측 본 cycle prompt 첫 turn 측 baseline → 두 번째 turn 측 baseline (= HEAD `e31dc27`) 측 갱신 영역 발생 (= 별 cycle LATEST-CHASE-POLICY-CLARIFY-001 measureable). 본 cycle 진입 시점 = HEAD `e31dc27` baseline 정합.
2. baseline §2 (자식 4 HEAD) 측 별 cycle propagation 마감 영역 (= GB/GD/GT 측 `5726cb4` 흡수 commit) 영역 사전 미인지 → 진정 target sha 측 재정의 의무 (= Path-C 선택).
3. master 측 작업 트리 측 cycle scope file 변경 X 영역 정합 (= HEAD blob = working tree byte 동일 영역).
4. 자식 4 측 기존 dirty 영역 (= app-foundation 2 / GB 17 / GD 17 / GT 15) 측 본 cycle scope 외 영역 정합 (= stage 격리 의무 정합).

## Cleanup Assessment

N/A (ops-layer task — 제품 코드 미변경 · cli infra 단방향 propagation 영역)
