#!/usr/bin/env bash
# install-working-file-archiver.sh — launchd daemon 설치 (사용자 손 작업 1 회)

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLIST_SRC="$SCRIPT_DIR/com.coin.working-file-archiver.plist"
LAUNCH_AGENTS="$HOME/Library/LaunchAgents"
PLIST_DEST="$LAUNCH_AGENTS/com.coin.working-file-archiver.plist"

if [ ! -f "$PLIST_SRC" ]; then
  echo "plist 부재: $PLIST_SRC"
  exit 1
fi

mkdir -p "$LAUNCH_AGENTS"

# 기존 daemon unload (있으면)
if launchctl list | grep -q "com.coin.working-file-archiver"; then
  launchctl unload "$PLIST_DEST" 2>/dev/null || true
fi

cp "$PLIST_SRC" "$PLIST_DEST"
launchctl load "$PLIST_DEST"

echo "설치 완료: $PLIST_DEST"
echo "확인:"
launchctl list | grep "com.coin.working-file-archiver"
