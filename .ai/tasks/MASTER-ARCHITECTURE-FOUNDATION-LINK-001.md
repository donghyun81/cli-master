# MASTER-ARCHITECTURE-FOUNDATION-LINK-001 (= ledger MASTER-T04)

## Meta

| 항목 | 값 |
|---|---|
| TaskId | MASTER-ARCHITECTURE-FOUNDATION-LINK-001 |
| Ledger ID | MASTER-T04 |
| Created (KST) | 2026-05-12 |
| Status | DONE |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |
| Mode | ops-layer (docs/agent/architecture/ + .claude/rules/) |

## 원문 요구사항

Cowork prompt (= ledger MASTER-T04) — "13 architecture 문서 측 foundation 인용 link 박음 갱신 + cli infra 측 신규 정책 신설" (= 5-repo cli infra 권장 byte-identical 영역).

## 분해된 문제 진술

1. 13 architecture file 측 코드 path 인용 박은 영역 (= `shared/domain`, `shared/data`, `shared/feature-state` 등) = markdown link 박음 X 박음 = 자식 reading order 정합 정합 박음 (= app-foundation 측 실제 file path 박은 박음 clickable X).
2. 본 link 박은 patterns 박은 영역 박은 SoT 박음 부재 (= 향후 architecture 신설 박은 박음 시점 박은 박음 정합 박은 영역 박음 X).

## 성공 조건

- 7 file 측 link 박음 박음 (= COMMON_ARCHITECTURE + KMP_CMP_LAYER_DIRECTION + KOIN_DI_BASELINE + MODEL_SEPARATION + SSOT_PRINCIPLES + TDD_WORKFLOW + TESTABILITY_SEAMS 박은 박음 · ERROR_RESULT_POLICY 박은 code block 박은 박은 영역 박은 박은 박음 = link X 박은 의무 박은 박음).
- 신규 cli infra `.claude/rules/architecture-foundation-link-policy.md` 신설 박은 박음 (= link 박은 patterns 박은 SoT 박은 박은 박음).
- 5-repo byte-identical propagation 박음 (14 file × 4 자식 = 56 cp 박음).
- 본 cycle 측 14 file × 5 = 70 cross-check PASS 박음 (= verify-sync 측 사후 검증 박은 박음).
- 보호 5 sha 변동 X 박음.

## Measurable Exit Criteria

- [x] `bash scripts/propagate.sh <14 file> --targets all` — ok=56 fail=0 박음 ✓
- [x] `bash scripts/verify-sync.sh --no-update --skip-daemon-check` — PASS 112 / DRIFT 1 / MISS 4 (= 본 cycle 측 14×5=70 PASS + 사전 DRIFT 2 영역 박음 별 cycle 박음)
- [x] 보호 5 sha (`5b84cd9e4bc36165` / `d3a0b57390bd0414` / `e580b6d7ca9a88ae` / `3a703b30553e0d09` / `b27fbe16edb68821`) 변동 0 박음
- [x] 7 file 측 link 박음 박은 박음 검증 (= `shared/domain` + `shared/data` + `shared/feature-state` 박은 박은 첫 등장 시 link 박음 박은 의무)

## 비기능 요구사항

- 5-repo byte-identical 박음 (= cli infra 권장 byte-identical 영역 · 보호 5 sha 박은 영역 X).
- relative path 박은 `../../../../app-foundation/<path>` (= 4 step 박음 박은 5-repo 동일 박음).
- code block 안 박은 영역 박은 link 박음 X 박은 의무 (= rendering X 박은 박은 영역 박음).

## 불확실성 (UNKNOWN)

없음 — baseline 모두 박은 박음 + 사전 DRIFT 2 영역 박음 사용자 명시 별 cycle 박음 박은 박음 박음.

## 산출물

- `.claude/rules/architecture-foundation-link-policy.md` (신설)
- `docs/agent/architecture/{COMMON_ARCHITECTURE,KMP_CMP_LAYER_DIRECTION,KOIN_DI_BASELINE,MODEL_SEPARATION,SSOT_PRINCIPLES,TDD_WORKFLOW,TESTABILITY_SEAMS}.md` (M · 7 file 측 link 박음)
- `.auto-memory/decision-log.md` (append 1 entry)
- `.ai/reports/MASTER-ARCHITECTURE-FOUNDATION-LINK-001/{EVIDENCE,PLAN,VERIFY,REVIEW,TODO}.md`

## skip 영역 (= 사전 DRIFT 2 영역 박은 영역 · 본 cycle scope X · 별 cycle 박은 박음)

- `cycle-discipline.md` 측 app-foundation 측 propagation 누락 박음 = 별 cycle `CLI-VERSION-UNPIN-PROPAGATION-002` 박음 박음 의무 박음.
- `release-checklist.template.md` 측 자식 4 측 propagation 누락 박음 = 별 cycle `MASTER-RELEASE-CHECKLIST-TEMPLATE-002` 박음 박음 의무 박음.

## skip 영역 (= 사용자 결정 박음 박음)

- `PACKAGE-OVERVIEW.md` 측 §3 T04 ✓ 갱신 박음 = 사전 본 cycle 측 patterns 박은 박음 정합 = Cowork Edit 별 처리 박음 의무 박음 또는 본 cycle 박은 갱신 박음 (= 사전 cycle MASTER-REPO-CONFIG-SOT-001 측 patterns 박음 차용 박음).
