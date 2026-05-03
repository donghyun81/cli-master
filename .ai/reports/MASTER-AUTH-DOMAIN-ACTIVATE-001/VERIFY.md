# VERIFY — MASTER-AUTH-DOMAIN-ACTIVATE-001

## Verify Commands

| 명령 | Exit Code | 결과 |
|---|---|---|
| `ls -1 .claude/rules/auth-rules.md .claude/agents/active/auth-security-privacy.md` | 0 | PASS |
| `grep -c "ACTIVE" .claude/rules/deferred-domains.md` | 0 | PASS (≥ 1 match) |
| `grep -c "active/auth-security-privacy.md" .claude/rules/routing-and-delegation.md` | 0 | PASS (≥ 1 match) |
| `[ ! -f .claude/agents/deferred/auth-security-privacy.md ]` | 0 | PASS (deferred 부재) |
| `shasum -a 256` 4 보호 파일 (ui-spec.schema.json / pencil-uiux-workflow.md / pencil-sot-policy.md / uiux-sot-refresh.md) | 0 | PASS (baseline 5aa52b23 / 6297080a / 96de2f5d / 1f871447 무변경) |
| `MASTER_DIR="$HOME/AndroidStudioProjects/gently-master" bash scripts/verify-sync.sh` | 0 | PASS (104 files / drift 0 / miss 0) |

## Verification Summary

- **EC1**: master 측 4 신규/갱신 파일 존재 + 1 deferred 파일 부재 (mv 완료) PASS
- **EC2**: 보호 파일 4종 sha baseline 무변경 PASS (이번 cycle 은 보호 파일 비건드림)
- **EC3**: 3-repo byte-identical 정합 PASS (verify-sync.sh 104/0/0)
- **EC4**: GT 측 cycle close memo (post-correction step 11 항목)

## UNKNOWN (검증 불가 항목)

- 자식 repo (GB / GD / GT) 의 git status 변경 검증 = post-correction step 9 commit 단계에서 별도 검증

## LOG

```
[LOG] 2026-05-03 KST
CMD: MASTER_DIR=$HOME/AndroidStudioProjects/gently-master bash scripts/propagate.sh .claude/rules/auth-rules.md .claude/rules/deferred-domains.md .claude/rules/routing-and-delegation.md .claude/agents/active/auth-security-privacy.md --targets all
EXIT: 0
STDOUT: 12 files propagated (4 files × 3 repos · ok=12 fail=0) · .gitignore patches OK 3/3

CMD: MASTER_DIR=$HOME/AndroidStudioProjects/gently-master bash scripts/verify-sync.sh
EXIT: 0
STDOUT: PASS 104 / DRIFT 0 / MISS 0

CMD: shasum -a 256 docs/schemas/ui-spec.schema.json .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md .claude/rules/uiux-sot-refresh.md
EXIT: 0
STDOUT: 5aa52b23 / 6297080a / 96de2f5d / 1f87144705380 (baseline 무변경)
```

## propagate.sh WARN 처리

`[propagate] WARN: 보호 파일 baseline 변경 감지` warning 박음 확인 — 보호 파일 sha 실측 결과 baseline 4종 모두 무변경. WARN false positive (script 측 baseline 비교 logic 문제 추정 · 별 trail post-correction lazy).
