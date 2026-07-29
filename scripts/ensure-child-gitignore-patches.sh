#!/usr/bin/env bash
# scripts/ensure-child-gitignore-patches.sh — 자식 repo .gitignore 에 master cli infra patterns 자동 patch
#
# 사용:
#   bash scripts/ensure-child-gitignore-patches.sh                    # 모든 자식 patch (없으면 추가)
#   bash scripts/ensure-child-gitignore-patches.sh --verify           # patch 적용 여부만 확인 (수정 X)
#   bash scripts/ensure-child-gitignore-patches.sh --target Selfward  # 특정 자식 만
#
# 환경 변수:
#   PARENT_DIR     기본: ~/AndroidStudioProjects
#   TARGET_REPOS   기본: "app-foundation gently-product-docs Selfward"
#
# 정책:
#   - 자식 .gitignore = 자식 자율 영역 (Android Studio build/gradle 패턴 등 repo-specific)
#   - master cli infra patterns (.claude/settings.local.json 등) 만 자식 .gitignore 에 보장
#   - marker block = "# === claude-cli-master propagation patterns (auto-managed) ==="
#     → marker 있음 = 이미 patch 박힘 (skip · idempotent)
#     → marker 없음 = patch 추가
#
# Exit code:
#   0 = 모두 patch 박혀 있음 (또는 추가 성공)
#   1 = --verify 모드에서 1 자식 이상 patch 미적용
#   2 = 환경 오류 (자식 repo 부재 등)

set -uo pipefail

# === 환경 변수 default (single SoT · MASTER-REPO-CONFIG-SOT-001) ===
# drift 정정: 기존 literal default 측 3 repo (app-foundation 미포함) →
# repo-config.sh source 측 자동 흡수 (= literal 재기입 X · TARGET_REPOS 단일 SoT).
# 현행 TARGET_REPOS = app-foundation gently-product-docs Selfward (= 2026-07-17 MASTER-T6-REPO-REALIGN-001
# 전파 대상 6→4 재편 · GB/GD/GT 전파 제거 = 동결 계승 원천 · 구 "4 repo = GB GD GT FND" 서술 supersede).
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=./repo-config.sh
. "$SCRIPT_DIR/repo-config.sh"

VERIFY_ONLY=0
SINGLE_TARGET=""

while [ $# -gt 0 ]; do
  case "$1" in
    --verify) VERIFY_ONLY=1; shift ;;
    --target) SINGLE_TARGET="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,20p' "$0"
      exit 0
      ;;
    *) echo "[ensure-gitignore] ERROR: unknown arg: $1" >&2; exit 2 ;;
  esac
done

MARKER="# === claude-cli-master propagation patterns (auto-managed) ==="
PATCH_BODY=$(cat <<'PATCH'

# === claude-cli-master propagation patterns (auto-managed) ===
# master cli infra 와 동기 의무. 직접 수정 금지.
.claude/settings.local.json
.ai/hooks/*.log
.ai/hooks/.session-marker
.ai/traces/*.jsonl
.ai/nightly-baseline/*.log
.ai/nightly-baseline/latest.md
.ai/logs/
.ai/baseline-snapshot/
.kotlin/
supabase/.temp/
cc-batch-pencil.json
PATCH
)

# === target repos 해결 ===
if [ -n "$SINGLE_TARGET" ]; then
  TARGET_LIST="$SINGLE_TARGET"
else
  TARGET_LIST="$TARGET_REPOS"
fi

# === alias 해결 (GB → GentlyBreath 등) ===
resolve_repo() {
  case "$1" in
    GB) echo "GentlyBreath" ;;
    GD) echo "GentlyDay" ;;
    GT) echo "GentlyTable" ;;
    *) echo "$1" ;;
  esac
}

# === 처리 ===
PATCHED_COUNT=0
ALREADY_COUNT=0
MISSING_COUNT=0
ERROR_COUNT=0

for repo in $TARGET_LIST; do
  REPO_NAME=$(resolve_repo "$repo")
  GI="$PARENT_DIR/$REPO_NAME/.gitignore"

  if [ ! -d "$PARENT_DIR/$REPO_NAME" ]; then
    echo "[ensure-gitignore] ERROR: $REPO_NAME repo 부재 ($PARENT_DIR/$REPO_NAME)" >&2
    ERROR_COUNT=$((ERROR_COUNT+1))
    continue
  fi

  if [ ! -f "$GI" ]; then
    if [ "$VERIFY_ONLY" = 1 ]; then
      echo "  ✗ $REPO_NAME: .gitignore 부재"
      MISSING_COUNT=$((MISSING_COUNT+1))
    else
      echo "$PATCH_BODY" > "$GI"
      echo "  + $REPO_NAME: .gitignore 신설 + patch 적용"
      PATCHED_COUNT=$((PATCHED_COUNT+1))
    fi
    continue
  fi

  if grep -qF "$MARKER" "$GI"; then
    echo "  ✓ $REPO_NAME: 이미 patch 박혀 있음"
    ALREADY_COUNT=$((ALREADY_COUNT+1))
  else
    if [ "$VERIFY_ONLY" = 1 ]; then
      echo "  ✗ $REPO_NAME: patch 미적용"
      MISSING_COUNT=$((MISSING_COUNT+1))
    else
      echo "$PATCH_BODY" >> "$GI"
      echo "  + $REPO_NAME: patch 적용"
      PATCHED_COUNT=$((PATCHED_COUNT+1))
    fi
  fi
done

echo ""
if [ "$VERIFY_ONLY" = 1 ]; then
  echo "[ensure-gitignore] verify: 적용 $ALREADY_COUNT / 미적용 $MISSING_COUNT"
  if [ "$MISSING_COUNT" -gt 0 ] || [ "$ERROR_COUNT" -gt 0 ]; then
    exit 1
  fi
else
  echo "[ensure-gitignore] 신규 patch $PATCHED_COUNT / 이미 적용 $ALREADY_COUNT"
fi

exit 0
