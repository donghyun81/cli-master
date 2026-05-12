## GATESv2
| Field | Value |
|---|---|
| TaskId | PROTO-CLI-VERSION-UNPIN-PROPAGATION-001 |
| Mode | ops-layer (cli infra propagation 확장) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | 2-Task 통합 cycle 프롬프트 (Task 1) · 사용자 직접 전달 |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 6 (PB/PD/PT × 2 = cycle-discipline.md + protected-file-hashes.md) + cli-master 산출 4 + incident-log + protected-file-hashes + CLAUDE.md = 12 |
| Modules | Proto 3-repo `.claude/rules/` + Proto 3-repo `.auto-memory/` + cli-master `.ai/reports/<taskId>/` + cli-master `.auto-memory/` + cli-master `CLAUDE.md` |
| Risk | Low (cli infra cp · 보호 파일 무접촉 · Gently 4-repo 무접촉) |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision
N/A (libs.versions.toml 무변경)

## 3. ArchitectureImpact
N/A (cli infra propagation · 도메인 코드 무변경)

## 4. ModelBoundaryPlan
N/A

## 5. ErrorPolicy
N/A

## 6. UIStateFlowPlan
N/A

## 7. TestabilitySeams
N/A

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | `shasum -a 256 <7-repo cycle-discipline.md path>` (byte-identical 검증) + `git log -1 --format=%H` (각 Proto repo HEAD 캡처) + `git log -1 --format=%s` (commit subject 자기 검증) |

> **Risk 기반 경량화**: Low Risk task — §1 ChangeBudget + §8 VerificationPlan + §9 RollbackStrategy + Plan 목록 필수. §2~§7, §10 N/A.

## 9. RollbackStrategy
- 롤백 가능 지점: 각 Proto repo 의 직전 HEAD (`git reset --hard <parent>` · PB `7ded7008...` · PD `419d5a8b...` · PT `a8ec3c1c...`)
- 롤백 조건: cycle-discipline.md sha drift 발견 + 4-repo (Gently 측) sha 와 7-repo byte-identical 위반 감지
- 복구 경로: Proto 3-repo 각각 `git reset --hard <parent>` → `.auto-memory/protected-file-hashes.md` 의 Recent updates entry 제거 → cli-master 산출물 directory 제거

## 10. ExternalPrep / DeferredItems
N/A

## Plan

1. 7-repo `.claude/rules/cycle-discipline.md` sha 측정 + drift 진단 (Gently 4-repo `732017a7...` · Proto 3-repo `8e48d486...` baseline)
2. cli-master source (sha `732017a7...`) → Proto 3-repo cp (`PB/PD/PT`)
3. 각 Proto repo `.auto-memory/protected-file-hashes.md` Recent updates entry append (8e48d486 → 732017a7 갱신 + Gently 4-repo 이미 정합 명시)
4. 각 Proto repo stage 의무: `.claude/rules/cycle-discipline.md` + `.auto-memory/protected-file-hashes.md` 만 (다른 unrelated 변경 무접촉 STOP 조건)
5. 각 Proto repo commit (6-section body · `chore(rule): PROTO-CLI-VERSION-UNPIN-PROPAGATION-001 propagate cycle-discipline.md from cli-master`)
6. 7-repo cross-verify (shasum 동일성 PASS 의무)
7. cli-master 측 4 산출물 (PLAN/EVIDENCE/VERIFY/REVIEW.md) 작성 + incident-log entry + protected-file-hashes Recent updates + CLAUDE.md §15 갱신
8. cli-master audit commit
9. Task 1 paste-back 출력

## Notes

- 본 cycle = ops-layer (cli infra propagation 확장) · code-level cleanup 대상 X (`legacy-cleanup-governance.md` 정합 N/A)
- 보호 파일 5종 sha 변동 0 의무 (cycle-discipline.md = cli infra 권장 byte-identical 영역)
- Gently 4-repo 무접촉 의무 (이미 직전 cycle `CLI-VERSION-UNPIN-PROPAGATION-001` 마감으로 `732017a7...` 정합)
- 본 cycle 마감 후 7-repo 모두 `732017a7cdd589d496140156c019ab9b79439d4bb37a300e1d1c548d8948258d` byte-identical 정합 의무
