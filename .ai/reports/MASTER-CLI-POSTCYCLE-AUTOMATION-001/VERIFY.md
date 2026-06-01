## Verify Commands
| 명령 | Exit Code | 결과 |
|---|---|---|
| `bash -n scripts/working-file-archiver.sh` | 0 | PASS (Phase A syntax) |
| `bash -n scripts/handoff-active-rotate.sh` | 0 | PASS (Phase B syntax) |
| `bash -n scripts/verify-sync.sh` | 0 | PASS (Phase C syntax) |
| `bash -n .claude/hooks/stop-housekeeping.sh` | 0 | PASS (Phase D syntax) |
| `bash scripts/verify-sync.sh --skip-daemon-check` | 0 | **PASS 158 / DRIFT 0 / MISS 0** · 부재참조 WARN 0 |
| `bash scripts/handoff-active-rotate.sh` (부모-root) | 0 | rotate 948586B→1162B · archive 보존 |
| `bash .claude/hooks/stop-housekeeping.sh` (self-test ×3) | 0/0/0 | plain silent-success · forced-WARN 발화 · silent 음소거 |
| `shasum -a 256` (5-repo byte-identical) | — | 아래 §정합 표 |

## Verification Summary
- **verify-sync PASS 158/0/0** (= 직전 157 + 신 stop-housekeeping.sh 1 · DRIFT 0 · MISS 0 · exit 0).
- **부재참조 WARN: 10 → 0** (실증: 정정 전 run = workflow.md/evidence-and-reporting.md/domain-roles.md/save-as-result-check.sh/no-abbreviation-policy.md/allowed-acronyms.md/forbidden-abbreviations.md/COMMON-SETUP-SSOT.md/repo-config.sh 10건 WARN 발화 → 정정 후 0).
- **Phase A**: 부모-root cowork-handoff-* 13→2 (stale ENTRY 11 → archive/2026-06/ · INDEX 5-column 추가 · active+architecture 보존 · cc-paste 50/ENTRY-PROMPT 4/cc-audit 2/cowork-chat-entry 2 미touch · 활성 paste 보존).
- **Phase B**: cowork-handoff-active.md 948586B → 1162B(header+§0 rotation pointer+빈 append) · 전체 본문 → archive/2026-06/cowork-handoff-active-20260601-234503.md(948586B 보존) · architecture.md sha `8ae8c4c75fb0a772` 무변동 · master self-test = no-op(active 부재).
- **Phase D**: stop-housekeeping self-test exit0 ×3 · settings.json JSON valid Stop=[stop-gate, stop-reflect, stop-housekeeping](기존 2 무변경) · settings sha 549b142d→d22047d8.

## 정합 표 (shasum -a 256 · 12자)
| file | master | GB | GD | GT | FND | scope |
|---|---|---|---|---|---|---|
| working-file-archiver.sh | 5ded4ab445ab | 5ded4ab445ab | 5ded4ab445ab | 5ded4ab445ab | (제외) | sweep 위치 + 부모-root cp |
| verify-sync.sh | 21cd0143a385 | 21cd0143a385 | 21cd0143a385 | 21cd0143a385 | 21cd0143a385 | 5-repo |
| stop-housekeeping.sh | 102408357b2c | 102408357b2c | 102408357b2c | 102408357b2c | 102408357b2c | 5-repo |
| settings.json | d22047d89440 | d22047d89440 | d22047d89440 | d22047d89440 | d22047d89440 | 5-repo |
| 보호 5 (manifest grep) | f1edd39/e6a4a2a1/96de2f5d/ee377dc2/e5e3fe16 | — | — | — | — | 불변(drift 0) |

## 보호 file resync 3위치 정합
- (1) sha-256 manifest: 보호 5 row 보존(propagate.sh grep PASS) + settings.json row 549b142d→d22047d8.
- (2) CLAUDE.md §14a: 보호 5 git-sha1 불변(= 보호 5 본문 무접촉 → drift 0 · 갱신 불요).
- (3) §15: 본 cycle entry append.
- latest.json settingsSha = SessionStart 시 runtime 재생성 self-heal (CLAUDE_PROJECT_DIR set run = d22047d89440 확인 · git-ignored).

## UNKNOWN (검증 불가 항목)
- 없음.

## LOG
```
[LOG] 2026-06-02 00:36 KST
CMD: bash scripts/verify-sync.sh --skip-daemon-check
EXIT: 0
STDOUT: PASS: 158 / DRIFT: 0 / MISS: 0 · [verify-sync] PASS — 모든 sha 일치 · (부재참조 WARN block 부재 = 0)
```
