# EVIDENCE — MASTER-CLI-CONTEXT-DIET-2-001 (rule 코어 다이어트 · T1~T8)

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | 운영 레이어 변경 (M5 cli-infra-ops) |
| Reading Mode | 6. CLI 운영 레이어형 |
| Requirement Source | `../cc-paste-MASTER-CONTEXT-DIET2-001.md` (전문 정독) |
| Info Gap | RESOLVABLE_IN_REPO |
| STOP Risk | 보호 manifest 절차 / rule 의미 충돌 / scope 외 의미 변경 / verify-sync drift / baseline 전진 접촉 (§6 · 전량 무발동) |
| Implementer Entry | Allowed (paste §2 outcome 계약 + §FREEDOM) |

## §0 baseline 재측정 (2026-07-10 · cli 라이브)
- master HEAD `8ece849` (paste 정합 ✓) · dirty 0 (착수 전).
- 6-repo: FND `b47b315` ✓ · PDOCS `44c744d` ✓ · GB `e388878` / GD `ab78769` / GT `2038d3c`→`e142b78` = paste 발행 후 전진. **전진분 접촉 게이트**: 자식 3 의 `.claude/rules/`+`docs/templates/` 최근 접촉 = 기존 propagation commit 뿐 (도메인 commit 만 전진) → 대상 rule 무접촉 · forward-progress 판정 · STOP#5 미발동.
- 보호 file 집합 = manifest 실측 (`protected-file-hashes.md`): **강제 byte-identical 5종** + advisory 기록 구조 (= "보호 5" = 강제 영역 한정 표기 · manifest 헤더 명시). edit-set ∩ 보호 5 = ∅.
- SessionStart hook 주입 실측: branch/open_tasks/last_review/protected_baseline_count/cc_version(2.1.170)/daemon — HEAD sha·보호 file별 sha = 미주입 (T5 rule 문구에 "경량 실측 fallback" 반영 근거).

## /context 실측 박제 (= 대체 실측 · 카테고리별 disk char)
`/context` = interactive 사용자 명령 (cli session 자체 실행 불가) → **disk char 실측으로 갈음** (전/후 비교 baseline 목적 충족 · codepoint proxy · token 아님):

| 카테고리 | 전 (HEAD 8ece849) | 후 (diet) | Δ |
|---|---|---|---|
| `.claude/rules/` 전체 | 528,332 | 502,477 (재측정 = VERIFY) | 하단 파일별 표 |
| master CLAUDE.md | 53,706 | 53,706 (+§15 entry 예정) | audit 시 재측정 |
| parent root CLAUDE.md | 11,237 | 무접촉 | 0 |
| docs/templates/ | 8 file | 10 file (+plan/review 스키마) | +8,012 |

## 전/후 char 실측 표 (파일별 · wc -c)
| file | 전 | 후 | Δ |
|---|---|---|---|
| cycle-discipline.md | 49,353 | 12,728 | **−36,625 (−74%)** |
| rule-routing-index.md | 36,325 | 27,213 | −9,112 (+ intake 실사용 = table 3,368 로 대체 = **−91%**) |
| rule-routing-table.md (신설) | — | 3,368 | intake 시 유일 정독 |
| reporting.md | 19,752 | 14,986 | −4,766 |
| rule-footer-common.md (신설) | — | 788 | footer canonical |
| anchor-list.md | 13,953 | 14,663 | +710 (T5/T7 주석) |
| cross-repo-parallel-exec.md | 13,848 | 14,145 | +297 (T7) − footer |
| cross-repo-parallel-exec-detail.md | 24,210 | 24,421 | +211 (T7) |
| workflow-core.md | 20,417 | 20,460 | +43 (pointer 재배선) |
| abbreviation-policy.md | 16,519 | 16,763 | +244 (T4 헤더) − footer · **의무 로드 제외 = 실효 −16.5K** |
| workflow-policy.md | 6,142 | 6,352 | +210 (T7) |
| plugin-policy.md | 5,864 | 6,046 | +182 (T7) |
| footer sweep 16 file | — | — | 각 −100~−160 (공통 문구 → pointer) |

## Mode 1 (구현형) 가정 정독 합계
| 시나리오 | char | Δ vs 전 |
|---|---|---|
| 전 (L0 3 + index 전문 + L1 7 + L2 3) | 235,005 | — |
| 후 · 세션 최초 cycle (L0 3 + table + L1 7 + L2 2 · abbreviation 제외) | 145,199 | **−38%** |
| 후 · 세션 2+ cycle (T5 · L0 재정독 hook 갈음) | 107,180 | **−54%** |

## COLD/템플릿 verbatim 검증
- 전문 diff: COLD1 tail vs `git show HEAD:cycle-discipline.md` = **DIFF0-PASS** · COLD2 §B/§F 구간 = **DIFF0-PASS** · 템플릿 2 구간 = **DIFF0-PASS** (4/4).
- 표본 grep: **15/15 쌍 PASS** (계약 ≥10 상회 · 사고 trail/명령 sequence/스키마 필드 등 분산 표본).

## Cleanup Assessment

N/A (ops-layer task — 제품 코드 미변경 · rule/템플릿/COLD 배치 변경 한정)
