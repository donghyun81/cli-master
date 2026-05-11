## Meta
| 항목 | 값 |
|---|---|
| TaskId | MASTER-RELEASE-CHECKLIST-TEMPLATE-001 |
| Created (KST) | 2026-05-11 |
| Status | PLAN |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 원문 요구사항

master ledger task `MASTER-T03` 진행. 신규 `docs/templates/release-checklist.template.md` 신설.
3 자식 repo (GB / GD / GT) 의 `docs/release-readiness/LAUNCH-STATUS.md` §7 (Store readiness) / §8 (컴플라이언스 + 권한) / §9 (성능 budget) 의 공통 영역 추출 → master template 으로 흡수. 자식 P4 deployment cycle 진입 시 cp 표준 확보.
본 cycle = master single-repo scope (자식 propagation X · 자식 P4 진입 시 cp 발화).

## 분해된 문제 진술

1. 3 자식 LAUNCH-STATUS §7~§9 공통 영역 추출 의무 (master 측 명시된 placeholder syntax 의 9 섹션 template).
2. Play Console + App Store Connect 빌드 시 권한 / Privacy / ASO 누락 회피 → 자식 측 P4 진입 시 본 template cp 후 도메인 placeholder 치환 + 실측 갱신 의무.
3. PACKAGE-OVERVIEW.md ledger §3 master row `MASTER-T03` ☐ → ✓ + sha + 본심 1줄 갱신 의무 (master P0 progress 2/8 → 3/8).
4. `.auto-memory/decision-log.md` 1 entry append 의무.
5. `.ai/reports/<taskId>/` PLAN + EVIDENCE + VERIFY + REVIEW 4 산출물 (Low Risk lightweight).

## 성공 조건

1. `docs/templates/release-checklist.template.md` 신설 + 9 섹션 (`## 1.` ~ `## 9.`) + 헤더 (template 출처 · 활성 조건 · STOP 의무) + placeholder syntax (`<RepoName>` · `<예: ...>`).
2. PACKAGE-OVERVIEW.md §3 master row T03 ✓ 갱신 + master row §1 P0 progress 갱신 (2/8 → 3/8).
3. `.auto-memory/decision-log.md` MASTER-T03 entry append (cycle marker + 본심 + 근거 + 검증).
4. 4 보고서 (PLAN / EVIDENCE / VERIFY / REVIEW) + Verdict PASS.
5. 1 commit (`feat(template): MASTER-RELEASE-CHECKLIST-TEMPLATE-001 add release-checklist.template.md (자식 P4 cp 표준)` + 6-section body + Co-Authored-By).

## Measurable Exit Criteria

- **EC1**: `test -f docs/templates/release-checklist.template.md` — exit 0 (파일 존재)
- **EC2**: `grep -c '^## [0-9]\. ' docs/templates/release-checklist.template.md` — ≥ 9 (9 섹션 보유)
- **EC3**: `grep -c '^| MASTER-T03 .* ✓' docs/release-readiness/PACKAGE-OVERVIEW.md` — ≥ 1 (T03 ✓ 갱신)
- **EC4**: `grep -c 'MASTER-RELEASE-CHECKLIST-TEMPLATE-001' .auto-memory/decision-log.md` — ≥ 1 (decision-log entry 추가)
- **EC5**: 보호 파일 5종 sha 변동 X (master 측 정합 강제) — `git hash-object docs/schemas/ui-spec.schema.json .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md .claude/rules/uiux-sot-refresh.md docs/design/design-sot-policy.md` 결과 baseline 일치

## 비기능 요구사항

- master single-repo scope (자식 propagation 의무 X · 자식 P4 진입 시 cp 발화)
- ops-layer task (cleanup assessment N/A)
- Low Risk · DBMig No · MoneyAuth No
- 보호 파일 5종 sha 무변동 의무

## 불확실성 (UNKNOWN)

없음 (Reading Order 완료 · 3 자식 LAUNCH-STATUS §7~§9 실측 + 공통 영역 추출 완료).
