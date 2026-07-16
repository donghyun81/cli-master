#!/usr/bin/env bash
# scripts/repo-config.sh — propagation export 변수 단일 SoT
#
# 본 file = master 측 propagation 도구 (propagate.sh / verify-sync.sh /
# ensure-child-gitignore-patches.sh) 측 export 변수 single source-of-truth.
# 3 script 측 source 통합 의무 (literal default 박음 X).
#
# Cycle: MASTER-REPO-CONFIG-SOT-001 (= ledger MASTER-T05) · 2026-05-11
#
# 사용 (3 script 측 source pattern):
#   SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
#   # shellcheck source=./repo-config.sh
#   . "$SCRIPT_DIR/repo-config.sh"
#
# 환경 변수 override 가능 (사용자 측 export 시 우선 채택):
#   PARENT_DIR     기본: $HOME/AndroidStudioProjects
#   MASTER_DIR     기본: $PARENT_DIR/claude-cli-master
#   TARGET_REPOS   기본: "GentlyBreath GentlyDay GentlyTable app-foundation gently-product-docs Selfward"
#
# 변경 정책:
#   - master cycle 신설 + 6-repo propagation 의무 (`cycle-discipline.md` §15 패턴 1)
#   - 자식 repo 직접 수정 금지

# === default 변수 ===
: "${PARENT_DIR:=$HOME/AndroidStudioProjects}"
: "${MASTER_DIR:=$PARENT_DIR/claude-cli-master}"
# Selfward 편입 = MASTER-SELFWARD-CLAUDE-PARITY-001 (2026-07-17 · 6th propagation target · .claude 초회 backstop)
: "${TARGET_REPOS:=GentlyBreath GentlyDay GentlyTable app-foundation gently-product-docs Selfward}"

# === PROTECTED_FILES (5 종 보호 file 강제 byte-identical · master ↔ 5 propagation target = 6-repo) ===
# 본 baseline = `.auto-memory/protected-file-hashes.md` 측 sha-256 인용.
# 변동 시 = mitigation cycle (CLAUDE.md §16 + cycle-discipline.md §10).
PROTECTED_FILES=(
  "docs/schemas/ui-spec.schema.json"
  "docs/rules/uiux-sot-refresh.md"
  "docs/design/design-sot-policy.md"
  "docs/rules/pencil-uiux-workflow.md"
  "docs/design/pencil-sot-policy.md"
)

export PARENT_DIR MASTER_DIR TARGET_REPOS PROTECTED_FILES
