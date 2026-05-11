# EVIDENCE — MASTER-REPO-CONFIG-SOT-001

## Requirements Source

- Cowork prompt (= ledger MASTER-T05) · 2026-05-11
- 본심: ledger MASTER-T05 본문 = "repo-config.sh PROTECTED_FILES / CHILD_REPOS 갱신 · 의도 = propagation 의 export 변수 SoT"
- Authority boundary: master 측 단일 repo · 자식 propagation X (scripts/ 영역 = master only)

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | 운영 레이어 (ops-layer · scripts/) |
| Reading Mode | CLI 운영 레이어형 |
| Requirement Source | prompt + ledger MASTER-T05 |
| Info Gap | RESOLVABLE_IN_REPO (모두) |
| STOP Risk | 보호 5 sha 변동 X 의무 · 병렬 cycle commit 충돌 X |
| Read-Only Fan-Out | N/A (ops-layer · 단순 변경) |
| Implementer Entry | Allowed |

## Pre-EVIDENCE Contract

- Read evidence: CLAUDE.md / propagate.sh / verify-sync.sh / ensure-child-gitignore-patches.sh / protected-file-hashes.md / PACKAGE-OVERVIEW.md (Reading Order 6 file)
- Remaining gaps: 없음
- Chosen path: scripts/repo-config.sh 신설 (single SoT) + 3 script source 통합 + drift 정정
- Hold / Stop reasons: 없음 (baseline 모두 일치)
- Implement entry conditions: BASELINE 일치 + 보호 5 sha 변동 X + 병렬 cycle commit X 박힘

## Collect Results

### BASELINE 실측 (2026-05-11 KST)

| repo | HEAD (12자) | 비고 |
|---|---|---|
| claude-cli-master | `74d9ee509af1` | prompt baseline 일치 ✓ |
| app-foundation | `f1f40f42f706` | — |
| GentlyBreath | `0552529248e8` | — |
| GentlyDay | `4d867cc5c604` | — |
| GentlyTable | `d90c19eeed87` | — |

### scripts/ 측 baseline

| script | TARGET_REPOS default | 비고 |
|---|---|---|
| `scripts/propagate.sh` | `GentlyBreath GentlyDay GentlyTable app-foundation` | 4 repo ✓ |
| `scripts/verify-sync.sh` | `GentlyBreath GentlyDay GentlyTable app-foundation` | 4 repo ✓ |
| `scripts/ensure-child-gitignore-patches.sh` | `GentlyBreath GentlyDay GentlyTable` | **3 repo (drift 영역)** |
| `scripts/repo-config.sh` | (부재) | **본 cycle 신설 의제** |

### 보호 5 sha 측 baseline (변동 X 의무 검증)

| 파일 | sha-256 | baseline 일치 |
|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `f1edd397...` | ✓ |
| `.claude/rules/uiux-sot-refresh.md` | `ee377dc2...` | ✓ |
| `docs/design/design-sot-policy.md` | `e5e3fe16...` | ✓ |
| `.claude/rules/pencil-uiux-workflow.md` | `7621013e...` | ✓ |
| `docs/design/pencil-sot-policy.md` | `96de2f5d...` | ✓ |

### 사전 dirty 잔여물 (본 cycle scope 분리)

| 파일 | 상태 | 본 cycle 처리 |
|---|---|---|
| `docs/release-readiness/PACKAGE-OVERVIEW.md` | M (사전 cycle 측 §1 baseline 정정 미커밋) | 본 cycle 흡수 (§1 progress 갱신과 정합 영역 단일 commit) |
| `.ai/reports/MASTER-CLI-TERMINOLOGY-SOT-SSOT-DEFINE-001/` | ?? | 본 cycle stage X (별 cycle 측 영역) |
| `.ai/reports/MULTI-REPO-RELEASE-LEDGER-INIT-001/` | ?? | 본 cycle stage X (별 cycle 측 영역) |

### 0 Matches

- 병렬 cycle (MASTER-RELEASE-CHECKLIST-TEMPLATE-001) 측 master 신규 commit = 0 (baseline `74d9ee5` 정합)
- scripts/repo-config.sh 사전 신설 = 0 (부재 ✓)

## Key Findings

1. **scripts/repo-config.sh 부재** = ledger MASTER-T05 본 cycle 신설 의제 정합.
2. **3 script 측 TARGET_REPOS literal default 박음** = export 변수 SoT 측 분산 = 본 cycle 측 source 통합 의제.
3. **ensure-child-gitignore-patches.sh 측 app-foundation 미포함** = drift 영역. 본 cycle source 통합 시 자동 흡수 (4 repo SoT 정합).
4. **보호 5 sha baseline 일치** + **5-repo HEAD baseline 일치** = STOP 조건 X = 진입 OK.

## Cleanup Assessment

N/A (ops-layer task — scripts/ 측 단일 SoT 신설 + 3 script source 통합 · 제품 코드 미변경)
