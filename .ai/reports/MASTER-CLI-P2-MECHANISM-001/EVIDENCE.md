# EVIDENCE — MASTER-CLI-P2-MECHANISM-001

## Requirements Source
- SoT: `../cc-paste-MASTER-CLI-P2-MECHANISM-001.md` (정독 완료)
- charter Phase 2 + audit §4 Phase 2 (audit #3·#4 근본 차단)
- Authority: M5 cli-infra-ops · master 단방향 propagation · `agent-commit: yes`

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | 운영 레이어 변경 (cli infra rule/skill) |
| Reading Mode | 6 CLI 운영 레이어형 (M5) + cross-repo |
| Requirement Source | cc-paste §3 contract SoT (충족) |
| Info Gap | RESOLVABLE_IN_REPO (disk 실측 완료) |
| STOP Risk | 보호 5종 sha / SoT 4층 편집 / rename / 자식 직접수정 / production touch — 전부 회피 |
| Read-Only Fan-Out | N/A (단일 cli session · sub-agent 0 · 영역 1 회피) |
| Implementer Entry | Allowed (계약 고정 후) |

## Pre-EVIDENCE Contract
- Read evidence: cc-paste 전문 + 4 target file + propagate/verify-sync/report-gen/repo-config 스크립트.
- 대상 4 blob = cc-paste §0 일치 (07ce306 / a81eb38 / 8f3d938 / 26f4c58). 보호 5종 = §14a git-sha1 일치.
- Chosen path: §A workflow-core /plan + §B rule-routing-index §I note + §C launch-status-sync skill 3→5 + (필요 시 4번째) cycle-discipline §25.2 mirror.
- Hold/Stop: 보호 5종 무접촉 · SoT 4층 가리키기만 · rename 금지.
- Implement entry conditions: baseline drift 0 (A1) + 4 file 5-자식 byte-identical 사전 확인 (A4).

## Collect Results / Key Findings
- 추적 2-세계 분리 = audit #3·#4 근본 원인 (`.ai/tasks/INDEX`=구현 cycle ↔ `LAUNCH-STATUS §3`=출시 목표).
- **SSOT 발견(A5)**: launch-status "3 의무 영역" 카운트가 `cycle-discipline §25.2`(line 666 pointer + table)에 mirror 됨. skill 3→5 변경 시 §25.2 미갱신 = 신규 카운트 drift → 본 cycle 목적(anti-drift) 자기모순. → cc-paste "3~4 file" 의 4번째로 §25.2 mirror 동기 채택.
- 동족 `paste-authoring §26.2`("3 의무 영역")는 **다른 paradigm** → 무접촉 (오염 회피 grep 검증).
- 4 target file 5-자식 사전 byte-identical 확인 (clean baseline · master de6c695/ed6abdc/47682d9/88f0565).

## Cleanup Assessment

N/A (ops-layer task — 제품 코드 미변경)
