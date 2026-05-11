## Verify Commands

| 명령 | Exit Code | 결과 |
|---|---|---|
| `bash scripts/propagate.sh .claude/rules/deferred-domains.md --targets all` | 0 | PASS (ok=4 fail=0) |
| `bash scripts/verify-sync.sh` | 0 | PASS (112/0/0) |
| `git hash-object` 5 protected files × 5 repos | 0 | MATCH (baseline 변동 0) |
| `shasum -a 256 .claude/rules/deferred-domains.md` × 5 repos | 0 | MATCH (5b 동일 sha = f43303b082f645cd2fa55bcfed6c28a53879c3a536e23486b7e43ad70b28ef9a) |

## Verification Summary

- **EC1 (deferred-domains.md ACTIVE count ≥ 3)**: PASS — master `grep "^| Auth" deferred-domains.md | grep -c ACTIVE` = 3 (master ¹ + GB ³ + GT ¹ · GD UNKNOWN 유지).
- **EC2 (verify-sync.sh exit 0 + DRIFT 0 + MISS 0)**: PASS — `PASS: 112 파일 | DRIFT: 0 | MISS: 0`.
- **EC3 (보호 파일 5종 sha 변동 0)**: PASS — 5 repos × 5 files 모두 baseline sha 일치:
  - `5b84cd9e4bc361652d6d0e561d8846eed3400d00` (ui-spec.schema.json)
  - `3a703b30553e0d09609d30fe4fd23fc326eecfde` (pencil-uiux-workflow.md)
  - `b27fbe16edb688218d7e57dd9a66d0f2a31ef300` (pencil-sot-policy.md)
  - `d3a0b57390bd0414cc89283a571dd6ecb8cb1562` (uiux-sot-refresh.md)
  - `e580b6d7ca9a88aef67c03f4bb39360993ab996f` (design-sot-policy.md)
- **EC4 (4-repo deferred-domains.md shasum 동일)**: PASS — 5-repo 모두 `f43303b082f6...`.
- **EC5 (5 commit subject 정합)**: 본 cycle commit phase 에서 검증 (Step 5).

## UNKNOWN (검증 불가 항목)

None.

## LOG

```
[LOG] 2026-05-11 KST
CMD: bash scripts/propagate.sh .claude/rules/deferred-domains.md --targets all
EXIT: 0
STDOUT: 전체 요약: ok=4 fail=0 (GB f43303b082f6 · GD f43303b082f6 · GT f43303b082f6 · FND f43303b082f6)
```

```
[LOG] 2026-05-11 KST
CMD: bash scripts/verify-sync.sh
EXIT: 0
STDOUT: PASS: 112 파일 | DRIFT: 0 | MISS: 0
NOTE: git-lock daemon 미활성 경고 (별 cycle · 본 cycle 영향 X)
```

```
[LOG] 2026-05-11 KST
CMD: shasum -a 256 .claude/rules/deferred-domains.md (× 5 repos)
EXIT: 0
STDOUT: 5b f43303b082f645cd2fa55bcfed6c28a53879c3a536e23486b7e43ad70b28ef9a (5-repo 동일)
```

```
[LOG] 2026-05-11 KST
CMD: git hash-object docs/schemas/ui-spec.schema.json .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md .claude/rules/uiux-sot-refresh.md docs/design/design-sot-policy.md (× 5 repos)
EXIT: 0
STDOUT: 5b 5 protected files baseline sha MATCH (변동 0)
```

## Cleanup Verification

N/A (ops-layer task — 제품 코드 미변경 · 제거 항목 0)
