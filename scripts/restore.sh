#!/usr/bin/env bash
# restore.sh — filename partial match → INDEX.md 검색 → confirm → mv
# bash 3.x 호환. 자기 위치 archive 만 대상.

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ARCHIVE_DIR="$REPO_ROOT/archive"
INDEX_FILE="$ARCHIVE_DIR/INDEX.md"

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <filename-partial>"
  echo "예: $0 GT-AUTH-PIVOT"
  exit 1
fi

PATTERN="$1"

if [ ! -f "$INDEX_FILE" ]; then
  echo "INDEX 부재: $INDEX_FILE"
  exit 1
fi

# INDEX.md 안 매칭 행 찾기 (5-column table)
MATCHES=$(grep "$PATTERN" "$INDEX_FILE" | grep -v "^#" | grep -v "^| 시각" | grep -v "^|---")

if [ -z "$MATCHES" ]; then
  echo "매칭 없음: $PATTERN"
  exit 1
fi

echo "=== 매칭 list ==="
echo "$MATCHES"
echo ""

# 첫 매칭만 처리 (다중 시 사용자에게 더 좁은 패턴 의뢰)
MATCH_COUNT=$(echo "$MATCHES" | wc -l | tr -d ' ')
if [ "$MATCH_COUNT" -gt 1 ]; then
  echo "다중 매칭 ($MATCH_COUNT 건). 더 좁은 패턴 사용 의뢰."
  exit 1
fi

# 매칭 행에서 파일명 추출
FILE=$(echo "$MATCHES" | awk -F'|' '{gsub(/^[[:space:]]+|[[:space:]]+$/,"",$3); print $3}')

if [ -z "$FILE" ]; then
  echo "INDEX 형식 오류 — 파일명 추출 실패"
  exit 1
fi

# archive 안 실 파일 찾기
SRC=$(find "$ARCHIVE_DIR" -name "$FILE" -type f 2>/dev/null | head -1)

if [ -z "$SRC" ] || [ ! -f "$SRC" ]; then
  echo "archive 안 실 파일 없음: $FILE"
  exit 1
fi

DEST="$REPO_ROOT/$FILE"

if [ -e "$DEST" ]; then
  echo "destination 충돌: $DEST 이미 존재. 수동 처리 의뢰."
  exit 1
fi

echo "복원 대상:"
echo "  src:  $SRC"
echo "  dest: $DEST"
echo ""
read -p "복원 진행? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
  echo "취소"
  exit 0
fi

mv "$SRC" "$DEST"
echo "복원 완료: $DEST"
