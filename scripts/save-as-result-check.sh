#!/bin/bash
# Save As 결과 자동 검증 + cli 결과 출력
# 호출: bash scripts/save-as-result-check.sh <expected-filename> <expected-dir>
# (= MASTER-CLI-CLEANUP-7CYCLE-001 S4 안 .claude/hooks/ → scripts/ 이동 마감 · 수동 helper paradigm 정합 default · settings.json 등록 X default)
# 출력: 정상 저장 PASS / 잔존 untitled list / Coin 권장 정정 가이드

# === PARENT_DIR 등 propagation 변수 single SoT (MASTER-REPO-CONFIG-SOT-001) ===
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=./repo-config.sh
. "$SCRIPT_DIR/repo-config.sh"

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
cd "$REPO_ROOT" || exit 0

EXPECTED_NAME="$1"   # 예: splash-screen
EXPECTED_DIR="$2"    # 예: docs/design/pencil-sot

EXPECTED_PATH="$EXPECTED_DIR/$EXPECTED_NAME.pen"

echo "═══════════════════════════════════════════════════════"
echo "[Save As 결과 검증]"
echo "═══════════════════════════════════════════════════════"

if [ -f "$EXPECTED_PATH" ]; then
  SHA=$(shasum -a 256 "$EXPECTED_PATH" | awk '{print $1}')
  echo "✓ $EXPECTED_PATH"
  echo "  sha: $SHA"
else
  echo "✗ $EXPECTED_PATH 부재 (Save As 자동화 실패)"
fi

# untitled 잔존 검색 (전 repo)
UNTITLED_FILES=$(find . -iname "untitled*.pen" -not -path "./node_modules/*" -not -path "./.git/*" 2>/dev/null)
if [ -n "$UNTITLED_FILES" ]; then
  echo ""
  echo "✗ untitled 잔존 발견:"
  echo "$UNTITLED_FILES" | sed 's/^/  /'
  echo ""
  echo "[Coin 권장 정정 작업]"
  echo "  1. mv <untitled path> $EXPECTED_PATH (의도된 cycle 의 파일이면)"
  echo "  2. shasum -a 256 $EXPECTED_PATH (재검증)"
  echo "  3. ui-spec.json 의 lastSyncedPencilStateHash 동기 재확인"
  echo "  4. 또는 archive 격리: mv <untitled path> docs/design/pencil-exports/archive/<yyyymmdd>/_orphan/"
fi

# 다른 repo 잘못 저장 검증 (= 활성 SW 외 · 동결 3 포함 · 2026-07-29 4-active 재편)
WRONG_REPO=""
for _wr in GentlyBreath GentlyDay GentlyTable app-foundation toward-product-docs; do
  [ -d "$PARENT_DIR/$_wr" ] || continue
  WRONG_REPO="$WRONG_REPO$(find "$PARENT_DIR/$_wr" -iname "$EXPECTED_NAME.pen" 2>/dev/null)"
done
if [ -n "$WRONG_REPO" ]; then
  echo ""
  echo "✗ 다른 repo 에 잘못 저장 발견:"
  echo "$WRONG_REPO" | sed 's/^/  /'
  echo ""
  echo "[Coin 정정] mv 위 파일 → $EXPECTED_PATH"
fi

echo "═══════════════════════════════════════════════════════"
exit 0
