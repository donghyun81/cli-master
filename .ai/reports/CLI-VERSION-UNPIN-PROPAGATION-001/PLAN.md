# PLAN — CLI-VERSION-UNPIN-PROPAGATION-001

## GATESv2

| Field | Value |
|---|---|
| TaskId | CLI-VERSION-UNPIN-PROPAGATION-001 |
| Mode | ops-layer · cli infra propagation (cycle-discipline.md §13 본문 갱신 + 4-repo byte-identical) |
| Workflow | Collect → Plan → Implement → Verify → Review |
| Requirements Source | 사용자 turn 본문 (다중 repo cycle prompt) + 직전 cycle `CLAUDE-CODE-VERSION-UNPIN-VERIFY-001` 산출물 |
| Risk | Low (ops-layer · 보호 파일 5종 sha 변동 0 · cli infra 권장 byte-identical 단일 파일 갱신) |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 4 (cycle-discipline.md × 4-repo) + 산출물 4 (PLAN/EVIDENCE/VERIFY/REVIEW) + 별 trail 영역 3 (incident-log.md / protected-file-hashes.md / CLAUDE.md §15) = 11 |
| Modules | `.claude/rules/` (4-repo) + `.ai/reports/CLI-VERSION-UNPIN-PROPAGATION-001/` + `.auto-memory/` + `CLAUDE.md` (master) |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision

N/A (libs.versions.toml 변경 X)

## 3. ArchitectureImpact

N/A (cli infra 영역 · 코드 아키텍처 영향 X)

## 4. ModelBoundaryPlan

N/A (DTO/Entity/DomainModel/UiState 변경 X)

## 5. ErrorPolicy

N/A (UseCase / Repository 신설 X)

## 6. UIStateFlowPlan

N/A (UI 변경 X)

## 7. TestabilitySeams

N/A (테스트 변경 X · 본 cycle 진입 self-test 3 항목은 EVIDENCE.md 안 실측 캡처)

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | (1) `git -C <repo> hash-object .claude/rules/cycle-discipline.md` × 4-repo cross-verify (2) self-test 3 항목 EVIDENCE.md 안 raw output 박음 (3) `grep -n "최신 추격" <repo>/.claude/rules/cycle-discipline.md` 4-repo 동일 hit |

## 9. RollbackStrategy

- 롤백 가능 지점: 본 cycle 4 commit (cli-master + 자식 3) — `git revert` 단위 롤백 가능.
- 롤백 조건: (a) §13 본문 새 정책이 4-repo 안 의도 X 동작 발견 시 (b) self-test 3 항목 영구 FAIL 시 (c) 사용자 승인 회수 시.
- 복구 경로: `git revert <commit-hash>` × 4-repo + 직전 sha `4cd01b4eca11feeec8e67619df87c7cbed3d9913` 복원 + `protected-file-hashes.md` "Recent updates" entry 정정.

## 10. ExternalPrep / DeferredItems

N/A (외부 의존 연기 항목 X · 본 정책의 능동 갱신은 사용자 자율 영역으로 명시 박음)

## Plan

1. baseline 4 항목 검증 (HEAD / cli infra sha / §13 line / 별 trail) — DONE in pre-cycle turn.
2. self-test 3 항목 실측 capture (EVIDENCE.md baseline) — DONE in pre-cycle turn.
3. cli-master `.claude/rules/cycle-discipline.md` §13 line 132~174 영역 본문 갱신 (5 핵심 요소 모두 반영) — DONE.
4. 자식 3-repo cp (byte-identical) — DONE.
5. cross-verify 4-repo sha 동일 — DONE (`0e4a7d01997c0d12ddb432d14ee37cdb1c4f1bbc`).
6. 산출물 4종 작성 (본 PLAN + EVIDENCE + VERIFY + REVIEW).
7. `.auto-memory/incident-log.md` append (별 trail 2 종 갱신 — close VERSION-PIN / open LATEST-CHASE).
8. `.auto-memory/protected-file-hashes.md` "Recent updates" append (4-repo cycle-discipline.md sha 명시).
9. cli-master `CLAUDE.md` §15 row append (본 SoT 변경 의무 절차 §16 정합).
10. cli-master commit (master 산출물 묶음) + 자식 3-repo 각 cp commit (총 4 commit).

## Notes

- cycle-discipline §11 lightweight 옵션 채택 (cleanup / docs / propagation / discipline 류 = 4 파일 PLAN/VERIFY/REVIEW/TODO). 본 cycle 은 산출물 list 의무 안 EVIDENCE 도 명시되어 5 파일 (PLAN/EVIDENCE/VERIFY/REVIEW). TODO.md 미작성 (잔여 블로커 X).
- 보호 파일 5종 (`ui-spec.schema.json` · `pencil-uiux-workflow.md` · `pencil-sot-policy.md` · `uiux-sot-refresh.md` · `design-sot-policy.md`) 무접촉 ✓.
- Proto 3-repo (ProtoGentlyBreath / ProtoGentlyDay / ProtoGentlyTable) 무접촉 ✓ (본 cycle scope X).
- `.mcp.json` / `settings.json` / `agents/active` / `workflow-core.md` / `code-principles.md` / `safety-and-secrets.md` / `auth-rules.md` / `ux-laws.md` / `design-to-code-sync.md` 무접촉 ✓.
- 자식 repo HEAD baseline 정정 — turn 안 사용자 A 채택: GentlyBreath `0552529 → 219a2245` / GentlyDay `4d867cc → ffd82656` / GentlyTable `d90c19e → e8bca80c`. drift 내용 = Sentry/Firebase SDK 통합 (cli infra 무관 · cycle-discipline.md 무접촉).
