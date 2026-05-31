# VERIFY — MASTER-CLI-VERSION-PIN-DESTALE-001

## Verify Commands
| 명령 | Exit Code | 결과 |
|---|---|---|
| `grep -c '2\.1\.114' .claude/hooks/session-start.sh docs/templates/setup-guide.template.md` | 0 | PASS (각 0) |
| `grep -c '다운그레이드\|pin PASS' .claude/hooks/session-start.sh` | — | PASS (다운그레이드 0 · pin PASS 0) |
| `grep -c '2\.1\.114' .claude/rules/cycle-discipline.md` | 0 | PASS (2 = history 보존) |
| `bash -n .claude/hooks/session-start.sh` | 0 | PASS (syntax OK) |
| `claude --version` | 0 | 2.1.156 (구 hook = 의무 다운그레이드 WARN 발화 영역 · 신 hook = cc_version echo) |
| `bash scripts/propagate.sh <2 file>` | 0 | ok=8 fail=0 |
| `bash scripts/verify-sync.sh` | 0 | PASS 154 / DRIFT 0 / MISS 0 |

## Verification Summary
- 2 file 측 2.1.114 + 다운그레이드 의무 + pin PASS 어휘 = 0 (의무 정합).
- cycle-discipline.md 2.1.114 = 2 보존 (history 무변동).
- 5-repo byte-identical: session-start.sh `1a94811f...` · setup-guide.template.md `709f11fe...` (verify-sync PASS 154/0/0).
- 보호 5 file sha-256 변동 0 (master pre=post · 5-repo git-sha1 byte-identical OK).
- production code touch 0 LOC.

## UNKNOWN
- (없음)

## LOG
```
[LOG] 2026-05-31 KST
CMD: bash scripts/verify-sync.sh
EXIT: 0
STDOUT: PASS 154 / DRIFT 0 / MISS 0 — 모든 sha 일치
```

## 알려진 scope-out finding (본 cycle 무접촉)
- propagate.sh `EXPECTED_BASELINE` heredoc (line 224-229) = stale sha-256 4종 (예: ui-spec `bba7745e` vs 실 `f1edd397`) → WARN-only 발화. 실 보호 5 file drift 아님 (5-repo byte-identical 확인). 별 cycle 후보 (manifest convention cycle 가 manifest 만 reconcile · propagate.sh 내부 heredoc 미반영).
- verify-sync git-lock daemon 미활성 WARN = 환경 noise (본 cycle 무관).
