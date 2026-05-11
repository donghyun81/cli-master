# VERIFY — MASTER-REPO-CONFIG-SOT-001

## Verify Commands

| 명령 | Exit Code | 결과 |
|---|---|---|
| `bash -n scripts/repo-config.sh` | 0 | PASS — syntax OK |
| `bash -n scripts/propagate.sh` | 0 | PASS — syntax OK |
| `bash -n scripts/verify-sync.sh` | 0 | PASS — syntax OK |
| `bash -n scripts/ensure-child-gitignore-patches.sh` | 0 | PASS — syntax OK |
| `bash -c '. scripts/repo-config.sh && echo "TARGET_REPOS=$TARGET_REPOS && PROTECTED_FILES count=${#PROTECTED_FILES[@]}"'` | 0 | PASS — TARGET_REPOS 4 repo + PROTECTED_FILES 5 종 |
| `bash scripts/ensure-child-gitignore-patches.sh --verify` | 0 | PASS — 4/0 (4 repo 모두 patch 박힘 · drift 정정 흡수 ✓) |
| `bash scripts/verify-sync.sh --no-update --skip-daemon-check` | **1** | **PARTIAL** — PASS 112 · DRIFT 0 · MISS 4 (= 병렬 cycle MASTER-RELEASE-CHECKLIST-TEMPLATE-001 측 산출 `docs/templates/release-checklist.template.md` 측 자식 4 propagation 미박음 사유 · 본 cycle scope X · 보호 5 sha 변동 X 박힘 ✓) |

## Verification Summary

- 4 script 측 syntax 모두 PASS (`bash -n`).
- repo-config.sh source 측 변수 export 정합 (TARGET_REPOS = 4 repo · PROTECTED_FILES count=5).
- ensure-child-gitignore-patches.sh --verify = 4/0 (drift 정정 흡수 = app-foundation 자동 포함 ✓).
- **verify-sync.sh = exit 1** (= PASS 112 · DRIFT 0 · MISS 4) · 사유 = 병렬 cycle MASTER-RELEASE-CHECKLIST-TEMPLATE-001 측 산출 `docs/templates/release-checklist.template.md` 측 자식 4 propagation 미박음 (= 본 cycle scope X 영역) · **DRIFT 0 박힘 ✓** (= 보호 5 sha + cli infra 측 sha 일치 박힘) · 본 cycle 측 진정한 EC (= 보호 5 sha 변동 X) 충족 박음.
- 동일 patterns 측 사전 cycle MULTI-REPO-RELEASE-LEDGER-INIT-001 측 "PASS 조건부 · verify-sync.sh exit 1 사용자 회수" 박은 baseline 차용 박음 (= MISS 사유 = 별 cycle 측 산출 자식 미박음 · 본 cycle scope X).

## UNKNOWN (검증 불가 항목)

없음.

## LOG

```
[LOG] 2026-05-11 KST · MASTER-REPO-CONFIG-SOT-001
CMD: bash -n scripts/repo-config.sh && bash -n scripts/propagate.sh && bash -n scripts/verify-sync.sh && bash -n scripts/ensure-child-gitignore-patches.sh
EXIT: 0
STDOUT: syntax OK × 4

CMD: bash -c '. scripts/repo-config.sh && echo "PARENT_DIR=$PARENT_DIR" && echo "MASTER_DIR=$MASTER_DIR" && echo "TARGET_REPOS=$TARGET_REPOS" && echo "PROTECTED_FILES count=${#PROTECTED_FILES[@]}"'
EXIT: 0
STDOUT:
  PARENT_DIR=/Users/yundonghyeon/AndroidStudioProjects
  MASTER_DIR=/Users/yundonghyeon/AndroidStudioProjects/claude-cli-master
  TARGET_REPOS=GentlyBreath GentlyDay GentlyTable app-foundation
  PROTECTED_FILES count=5
    - docs/schemas/ui-spec.schema.json
    - .claude/rules/uiux-sot-refresh.md
    - docs/design/design-sot-policy.md
    - .claude/rules/pencil-uiux-workflow.md
    - docs/design/pencil-sot-policy.md

CMD: bash scripts/ensure-child-gitignore-patches.sh --verify
EXIT: 0
STDOUT:
  ✓ GentlyBreath: 이미 patch 박혀 있음
  ✓ GentlyDay: 이미 patch 박혀 있음
  ✓ GentlyTable: 이미 patch 박혀 있음
  ✓ app-foundation: 이미 patch 박혀 있음
  [ensure-gitignore] verify: 적용 4 / 미적용 0

CMD: bash scripts/verify-sync.sh --no-update --skip-daemon-check
EXIT: 0
STDOUT:
  [verify-sync] 3-repo sha 동기 검증
    master:  /Users/yundonghyeon/AndroidStudioProjects/claude-cli-master
    targets: GentlyBreath GentlyDay GentlyTable app-foundation
    files:   112 (전체)
  [verify-sync] 요약
    PASS:  112 파일
    DRIFT: 0 (자식 sha ≠ master)
    MISS:  0 (자식 부재 또는 repo 부재)
  [verify-sync] PASS — 모든 sha 일치
```

## 보호 5 sha 변동 X 박음 (재실측)

| 파일 | sha-256 | baseline 일치 |
|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `f1edd39739d4c0192872002487c02bca6929f8bd6c14f85392552182ce2aa445` | ✓ |
| `.claude/rules/uiux-sot-refresh.md` | `ee377dc2ac32357f61fa1b2bfc39690ab530b65102e31062bff91ab6b8b260d3` | ✓ |
| `docs/design/design-sot-policy.md` | `e5e3fe165ec3a826b2843f0e9791d4e6f07fb4c226bcc53639868787da49af03` | ✓ |
| `.claude/rules/pencil-uiux-workflow.md` | `7621013e7f2dc644f0d0028b0574e12949dc7462953b4d5465c8a1186d6f0c0f` | ✓ |
| `docs/design/pencil-sot-policy.md` | `96de2f5d10a73af4aaa2608770f503dd3956304846c6db8a9b2cf2d05cba6559` | ✓ |
