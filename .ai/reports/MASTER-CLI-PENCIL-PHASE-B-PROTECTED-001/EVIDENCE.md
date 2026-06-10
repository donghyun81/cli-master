# EVIDENCE — MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | 운영 레이어 변경 (cli infra · 보호 2 file) |
| Reading Mode | 6. CLI 운영 레이어형 (M5) |
| Requirement Source | cc-paste-MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001.md + 원 계약 §Phase B/§6 정독 ✓ |
| Info Gap | RESOLVABLE_IN_REPO (전부 해소) |
| STOP Risk | 보호 2 접촉 = STOP #5 → sha 3-layer 절차 동반으로 사면 (계약 명시) |
| Implementer Entry | Allowed (paste 계약 = pre-EVIDENCE 계약 대체) |

## Baseline 실측 (진입 시점 · §0 표 전수 일치)
- master HEAD `157a2c5` clean · FND `a69a0af` · GB `d50c519` · GD `9e4aff6` · GT `7f188ff` · PDOCS `9f1d44a`
- 보호 2 현행: pencil-uiux-workflow.md sha-256 `2ec100bf…` / git-sha1 `22570f97…` · pencil-sot-policy.md sha-256 `ae20a79c…` / git-sha1 `acf88d95…` — §0 표와 전수 일치 (재baseline 정합)
- 기존 dirty baseline (무접촉 대상): GB = `.ai/reports/GB-VISION-MOTIVATION-001/TODO.md`(M) + `package-lock.json`(??) · GD = `supabase/.temp/cli-latest`(M) · GT = `supabase/.temp/cli-latest`(M) · FND/PDOCS clean

## §13 self-test (3/3 PASS)
1. `claude --version` = 2.1.170 (Claude Code)
2. `claude mcp list` = pencil ✔ Connected (scope 중복 warning = 비차단 advisory)
3. ToolSearch "+pencil" = 9종 전수 (batch_design/batch_get/export_nodes/get_editor_state/get_guidelines/get_screenshot/get_variables/set_variables/snapshot_layout) · 제거 4종 부재 ✓

## Dual grep 재탐색 (내용 기준 · 원 좌표 대조)
- pencil-uiux-workflow.md: :11(pencil-sot-binding 죽은 명칭) :20(12 official+1) :22(추가 5종) :45/:56/:68(open_document step) :93(STOP path-arg) — 원 문서 좌표 전수 현행 일치 (오늘 2 cycle 편집에도 불이동)
- pencil-sot-policy.md: :40(캔버스 열기 표 행) :77(STOP) — 일치
- cycle-discipline.md: :227 잔존 (Path 2-A 요약 행) → 계약 §2.3 허용분으로 동반 정정 · :164 = §13 게이트 본문의 제거 4종 열거 = 정합 서술 → 무접촉
- 추가 발견: `.ai/baseline-snapshot/latest.json` 2-cycle stale (`e6a4a2a1…`/`96de2f5d…` = PROTECTED-STALE-PATH-FIX 이전 값) + PDOCS block 부재 → 본 계약 3-layer 정합 의무로 마감

## Cleanup Assessment
N/A (ops-layer task — 제품 코드 미변경)
