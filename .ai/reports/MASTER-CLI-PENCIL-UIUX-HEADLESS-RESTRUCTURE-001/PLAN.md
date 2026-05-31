# PLAN — MASTER-CLI-PENCIL-UIUX-HEADLESS-RESTRUCTURE-001

## GATESv2
| Field | Value |
|---|---|
| TaskId | MASTER-CLI-PENCIL-UIUX-HEADLESS-RESTRUCTURE-001 |
| Mode | M3 migration-safe (= 보호 file 변경 · STOP #5 sha drift 영역) |
| Workflow | Collect -> Plan -> Implement -> Verify -> Review |
| Requirements Source | cc-paste-MASTER-CLI-PENCIL-UIUX-HEADLESS-RESTRUCTURE-001.md |

## 1. ChangeBudget
| 항목 | 값 |
|---|---|
| FilesN | 1 PROTECTED (pencil-uiux-workflow.md · propagation 대상) + 부수: protected-file-hashes.md(manifest) + CLAUDE.md §14a/§15 (master only) |
| Modules | cli infra (보호 rule file) |
| Risk | Medium-High (= 보호 file · M3) |
| DBMig | No |
| MoneyAuth | No |

## 2~7. (N/A — design SoT 문서 · production code 무접촉)

## 8. VerificationPlan
| 항목 | 값 |
|---|---|
| VerifyCmds | grep 2.1.114=0 · primary 선언 grep>=1 · 섹션/Type 1~5 intact · live sha == manifest sha-256 == §14a git-sha1 coherence · propagate WARN 0 · verify-sync PASS |

## 9. RollbackStrategy
- git revert 359ba3b (master cleanup) + 자식 4 revert + manifest/§14a sha 환원. 비가역 0 (문서 위계 reframe · 절차 step 무변경).

## 10. ExternalPrep / DeferredItems
- N/A

## Plan (중간 깊이 = 위계 명시 + §9 승격 · 섹션 삭제/대이동 X)
1. stale pin 정정 2줄 (L23 §1 + L93 §6) → §13 latest-chase 정합.
2. §2.5 경로 위계 선언 신설 (= primary = headless 평문-JSON · D7 · alternative = desktop-app 시각 검증).
3. §9 framing 승격 (= "별도 진입점" → "기본 경로").
4. §9.1 표 headless-default 조정 (row 의미 보존).
5. §3 cross-ref 추가 (= desktop-app = 시각 검증 alternative · Type step 무변경).
6. STOP-protocol: manifest sha-256 resync → §14a git-sha1 resync → §15 → commit([Sha]) → propagate → verify-sync → audit.

## Notes
- M3 safety: PROTECTED file = STOP #5 영역. 양쪽 sha layer (manifest sha-256 + §14a git-sha1) 갱신 의무. coherence (live==manifest==§14a) 검증 PASS.
- 금지 정합: Type 1~5 step 무변경(=5 header intact) · 도구 list 무추가(=12 official ref intact) · 섹션 삭제/§3↔§9 swap X (= §1-§9+§2.5 순서 보존).
