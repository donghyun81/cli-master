# VERIFY — MASTER-CLI-DOCS-AUTOSYNC-PARADIGM-001

## Verify Commands

### master 측 (= commit 직전)

| 명령 | Exit Code | 결과 |
|---|---|---|
| `git hash-object .claude/rules/workflow-core.md` | 0 | `d1926fdb29f5caaebfc60157aeb21ce898892c25` (= baseline `7dd2c6e7...` 측 새 sha) |
| `git hash-object .claude/rules/cycle-discipline.md` | 0 | `be598ab5395945c58d7db924681f4b840d8ed80f` (= baseline `3419a7e0...` 측 새 sha) |
| `git hash-object .claude/agents/active/docs-change-communicator.md` | 0 | `e9aec85b001d75f610a61fcd45d25e4e981e194f` (= baseline `bb760105...` 측 새 sha) |
| `git hash-object docs/schemas/ui-spec.schema.json` | 0 | `5b84cd9e4bc361652d6d0e561d8846eed3400d00` (= drift 0 ✓) |
| `git hash-object .claude/rules/pencil-uiux-workflow.md` | 0 | `20c72ae66b513bdc991a377f73688c23d1154bcc` (= drift 0 ✓) |
| `git hash-object docs/design/pencil-sot-policy.md` | 0 | `b27fbe16edb688218d7e57dd9a66d0f2a31ef300` (= drift 0 ✓) |
| `git hash-object .claude/rules/uiux-sot-refresh.md` | 0 | `d3a0b57390bd0414cc89283a571dd6ecb8cb1562` (= drift 0 ✓) |
| `git hash-object docs/design/design-sot-policy.md` | 0 | `e580b6d7ca9a88aef67c03f4bb39360993ab996f` (= drift 0 ✓) |
| `git diff --stat CLAUDE.md` | 0 | `1 file changed, 1 insertion(+)` (= scope D entry 단독 · 002 cycle 영역 무접촉 ✓) |

### 5-repo byte-identical verify (= post-propagation 영역 · 다음 step 진입 후 갱신)

본 영역 = master commit 마감 후 `scripts/propagate.sh` + `scripts/verify-sync.sh` 호출 결과 흡수 영역. 본 file 측 post-propagation 갱신.

## Verification Summary

### 진입 baseline (= drift 0 ✓)

5-repo HEAD baseline 정합 + 보호 5 sha drift 0 + scope 3 file 5-repo byte-identical baseline 확인. paste source §0 정합.

### 변경 본문 정합 (= ChangeBudget 측정)

| 영역 | ChangeBudget 예측 | 실 변경 line 수 |
|---|---|---|
| (A) `workflow-core.md` DocSync bullet | +5~15 | +7 (= 6 line 본문 + 1 line 정합) |
| (B) `cycle-discipline.md` §20 신설 | +10~30 | +30 (= §20 header + 20.1~20.4 sub-section) |
| (C) `docs-change-communicator.md` Key questions 6~8 | +3~6 | +5 (= 3 questions + 1 separator + 1 정합 line) |
| (D) master `CLAUDE.md` §15 entry | +1~3 | +1 (= cycle entry row 단독) |

전 영역 ChangeBudget 한계 안 정합 ✓.

### pre-existing scope-외 dirty 보존 verify

git status 측 staged 영역 = scope 4 file (`workflow-core.md` + `cycle-discipline.md` + `docs-change-communicator.md` + `CLAUDE.md`) + reports 산출물. unstaged 영역 = 002 cycle 진행 영역 + nightly baseline 영역 (= pre-existing scope-외 dirty default · 무접촉 정합).

## UNKNOWN (검증 불가 항목)

post-propagation 5-repo byte-identical verify = scripts 호출 후 측정 (= 본 file 마감 후 갱신 영역).

## LOG

```
[LOG] 2026-05-19 KST · master commit 직전
CMD: git hash-object <3 scope file>
EXIT: 0
STDOUT:
- workflow-core.md: d1926fdb29f5caaebfc60157aeb21ce898892c25
- cycle-discipline.md: be598ab5395945c58d7db924681f4b840d8ed80f
- docs-change-communicator.md: e9aec85b001d75f610a61fcd45d25e4e981e194f

CMD: git hash-object <보호 5 file>
EXIT: 0
STDOUT: drift 0 (= paste source §0 baseline 정합)

CMD: git diff --stat CLAUDE.md
EXIT: 0
STDOUT: 1 file changed, 1 insertion(+) (= scope D entry 단독)
```

## Cleanup Verification

N/A (ops-layer task — paradigm SoT 강화 default · 제품 코드 미변경)
