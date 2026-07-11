# PLAN — MASTER-CLI-CONTEXT-DIET-2-003

## 1. ChangeBudget
| FilesN | Modules | Risk | DBMig | MoneyAuth |
|---|---|---|---|---|
| master ~100 (44 rename + machinery + sweep + 2 protected rebaseline + CLAUDE.md/manifest) | cli infra only | Medium (보호 file 이동 + 6-repo propagation) | No | No (production/EF/DB 0 touch) |

## 8. VerificationPlan
- 이동 후 broken-link 스캔 = 0 (move-induced).
- 잔존 machinery residual `.claude/rules/<moved>` = 0 (hot surface).
- 보호 5 file: manifest ↔ live sha256 일치 · instructions-loaded hook(real master) drift 0.
- `test-protected-file-hooks.sh` #3/#4/#5 PASS (#1/#2 = pre-existing stdout-capture 이슈).
- propagate ok · verify-sync exit 판정 · docs/rules 6-repo byte-identical.

## 9. RollbackStrategy
- 문서/cli infra 전용: 미커밋 상태 = `git checkout`/`git mv` 역방향. 커밋 후 = `git revert` (production 무접촉이라 안전). 자식 propagation 전 master self-verify 게이트 = 커밋 전 되돌림 가능.

## 작업 목록 (T1~T5)
- **T1** `docs/rules/` 신설 + git mv 44 (잔존 5 = safety-and-secrets · anchor-list · cross-repo-parallel-exec · rule-routing-table · rule-footer-common). ✓
- **T2** pointer sweep: `.claude/rules/<moved>`→`docs/rules/<moved>` (substring = 절대+`../../` 형 동시) + `./잔존`→`../../.claude/rules/` + `./moved`(잔존 file 내)→`../../docs/rules/` + `../skills/`→`../../.claude/skills/`. 이력 verbatim(COLD/§15/.ai/archive/manifest-history/propagation-status) 제외. ✓
- **T3** 보호 절차: pencil-uiux-workflow.md + uiux-sot-refresh.md **양쪽** = 경로(manifest 14/16/63 · §14a 276/278 · §2/§14) + sha-256(manifest) + git-sha1(§14a) rebaseline. measure-gsm ch_l0 = 잔존 3 file → 무변동. ✓
- **T4** propagation + 자식 surgical rm (blanket --prune 금지). (진행)
- **T5** rule-routing-table.md 자동주입층 경계 문구 (잔존5 자동주입/compact 생존 · 이동44 Read-only). ✓

## §3 contract
- git mv 후 내용 치환 = staged 확인. 파일 삭제 = 자식 이동 44 surgical rm 한정.
- 정보 소실 0 (이동 내용 무변경 · sweep 경로문자열만 · 의미 변경 0).
- 6-repo byte-identical(신 경로) + verify-sync + context-health §2 재측정(master-only).

N/A: §2·§3·§4·§5·§6·§7·§10 (cli infra doc 이동 · 코드/모델/UI/의존성 무접촉).
