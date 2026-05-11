## Verify Commands

| 명령 | Exit Code | 결과 |
|---|---|---|
| `test -f docs/templates/release-checklist.template.md` | 0 | PASS (EC1 — 파일 존재) |
| `grep -c '^## [0-9]\. ' docs/templates/release-checklist.template.md` | 0 | PASS (EC2 — 9 ≥ 9 · 9 섹션 보유) |
| `grep -c '^\| MASTER-T03 .* ✓' docs/release-readiness/PACKAGE-OVERVIEW.md` | 0 | PASS (EC3 — 1 ≥ 1 · T03 ✓ 갱신) |
| `grep -c 'MASTER-RELEASE-CHECKLIST-TEMPLATE-001' .auto-memory/decision-log.md` | 0 | PASS (EC4 — 1 ≥ 1 · entry 추가) |
| `git hash-object <protected 5>` | 0 | PASS (EC5 — 5 sha baseline 일치 · 변동 0) |

## Verification Summary

5 EC 모두 PASS. master single-repo scope 으로 7 파일 신설/갱신 (template 1 · PACKAGE-OVERVIEW edit 1 · decision-log append 1 · task 1 · 4 reports). 보호 파일 5종 sha = baseline (5b84cd9e · 3a703b30 · b27fbe16 · d3a0b573 · e580b6d7) 유지. verify-sync 영향 X.

## UNKNOWN (검증 불가 항목)

없음.

## LOG

```
[LOG] 2026-05-11 KST
CMD: test -f docs/templates/release-checklist.template.md
EXIT: 0
STDOUT: EC1 PASS (exit 0)

CMD: grep -c '^## [0-9]\. ' docs/templates/release-checklist.template.md
EXIT: 0
STDOUT: 9

CMD: grep -c '^| MASTER-T03 .* ✓' docs/release-readiness/PACKAGE-OVERVIEW.md
EXIT: 0
STDOUT: 1

CMD: grep -c 'MASTER-RELEASE-CHECKLIST-TEMPLATE-001' .auto-memory/decision-log.md
EXIT: 0
STDOUT: 1

CMD: git hash-object docs/schemas/ui-spec.schema.json .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md .claude/rules/uiux-sot-refresh.md docs/design/design-sot-policy.md
EXIT: 0
STDOUT:
5b84cd9e4bc361652d6d0e561d8846eed3400d00
3a703b30553e0d09609d30fe4fd23fc326eecfde
b27fbe16edb688218d7e57dd9a66d0f2a31ef300
d3a0b57390bd0414cc89283a571dd6ecb8cb1562
e580b6d7ca9a88aef67c03f4bb39360993ab996f
(= baseline · 변동 0)

CMD: grep '^| claude-cli-master |' docs/release-readiness/PACKAGE-OVERVIEW.md
EXIT: 0
STDOUT: | claude-cli-master | `<TBD-AMEND>` | 운영 (T01/T02/T03/T05 ✓ · T04/T06~T08 진행 대기) | 4/8 (50%) | — |
(= master row P0 progress 3/8 → 4/8 갱신 PASS)
```
