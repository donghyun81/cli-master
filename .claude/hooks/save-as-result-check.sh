#!/bin/bash
# Save As 결과 자동 검증 + cli 결과 출력
# 호출: bash .claude/hooks/save-as-result-check.sh <expected-filename> <expected-dir>
# 출력: 정상 저장 PASS / 잔존 untitled list / Coin 권장 정정 가이드

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

# 다른 repo (GentlyTable / GentlyBreath) 잘못 저장 검증
WRONG_REPO=$(find /Users/yundonghyeon/AndroidStudioProjects/GentlyTable -iname "$EXPECTED_NAME.pen" 2>/dev/null; \
             find /Users/yundonghyeon/AndroidStudioProjects/GentlyBreath -iname "$EXPECTED_NAME.pen" 2>/dev/null)
if [ -n "$WRONG_REPO" ]; then
  echo ""
  echo "✗ 다른 repo 에 잘못 저장 발견:"
  echo "$WRONG_REPO" | sed 's/^/  /'
  echo ""
  echo "[Coin 정정] mv 위 파일 → $EXPECTED_PATH"
fi

echo "═══════════════════════════════════════════════════════"
exit 0
