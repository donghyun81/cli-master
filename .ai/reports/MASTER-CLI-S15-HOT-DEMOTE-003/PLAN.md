# PLAN — MASTER-CLI-S15-HOT-DEMOTE-003

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-S15-HOT-DEMOTE-003 |
| Mode | M5 (cli-infra-ops · master-only · propagation 불요) |
| Workflow | (M5 lightweight) Plan → Mutate → Verify → Review |
| Requirements Source | cc-paste-MASTER-CLI-S15-HOT-DEMOTE-003.md |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 3 tracked (CLAUDE.md · master-cycle-history-COLD.md · context-health-metrics.md) + report dir |
| Modules | cli-infra (master-only · `.claude/` 무접촉) |
| Risk | Low (ops-layer · production 0 LOC) |
| DBMig | No |
| MoneyAuth | No |

## 2~7. (N/A — ops-layer · 도메인/모델/의존성/UI/테스트 변경 0)

## 8. VerificationPlan
- `awk` (hook 동일 식) §15 hot count: 13 → 6
- 무손실 대칭: git `HEAD:CLAUDE.md` 측 §15 oldest-8 = working COLD 신규 8 entry exact-string (8=8)
- `GSM_CONTEXT_HEALTH_FORCE=1 bash .claude/hooks/measure-gsm-cycle.sh` → `[GSM-S15-HOT]` 무발화 (s15_count=6 ≤ 10)
- 보호 5 `shasum -a 256` drift 0 · `git status` NEW out-of-scope dirty 0

## 9. RollbackStrategy
- 문서/메모리 전용 변경 → `git revert <commit>` 즉시 복구 가능. mutate.py = validate-then-write (assert 실패 시 무기록).

## 10. ExternalPrep / DeferredItems
- N/A.

## Plan
1. baseline 실측 (hot 13 · cold 103 · master char · 보호 5 sha).
2. oldest 8 (`P2-MECHANISM`~`PROTECTED-STALE-PATH-FIX`) → COLD tail verbatim (list-slice 이동 · 재타이핑 0).
3. hot 잔존 = 최근 5 (`COMPOUND-LINT-DEPRECATE`~`INFRA-SMALL-BATCH`) + 본 cycle entry = 6. table-split 빈 줄 제거.
4. cold pointer / COLD 헤더·§1·blockquote / context-health §2 metadata 정합 (103→111 · §1 heading stale 94→111 reconcile).
5. 독립 검증 (vs git HEAD baseline) + GSM-S15-HOT silent + commit.

## §FREEDOM 결정
- 잔존 선정 = 최근 5 + 본 entry (= AUTO-DEMOTE/COLD-002 전례 "최근 5 + 본 cycle").
- cold 정렬 = append-order tail (demotion 순 · §15 원순서 보존).
- §15 table-split 빈 줄 제거 = §15-내부 valid-table 복귀 (§15-외 본문 무접촉).
- COLD §1 heading 94→111 reconcile = append 후 정합 필수 (직전 AUTO-DEMOTE +9 누락분 동반).
- §3.1 (분기 auto-trajectory) = hook-owned · quarter-guard auto-append → 수동 fabricate X (automation-policy Transport/Inspection 경계).
