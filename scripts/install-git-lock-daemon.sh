#!/usr/bin/env bash
# scripts/install-git-lock-daemon.sh — launchd 데몬 install (Coin 1회 손 작업)
#
# 사용:
#   bash ~/AndroidStudioProjects/claude-cli-master/scripts/install-git-lock-daemon.sh
#
# 작동:
#   1. ~/Library/LaunchAgents/com.coin.git-lock-cleaner.plist 신설 (HOME 치환)
#   2. launchctl load
#   3. 검증: launchctl list | grep git-lock-cleaner
#
# 제거:
#   launchctl unload ~/Library/LaunchAgents/com.coin.git-lock-cleaner.plist
#   rm ~/Library/LaunchAgents/com.coin.git-lock-cleaner.plist

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLIST_SRC="$SCRIPT_DIR/com.coin.git-lock-cleaner.plist"
PLIST_DST="$HOME/Library/LaunchAgents/com.coin.git-lock-cleaner.plist"

if [ ! -f "$PLIST_SRC" ]; then
  echo "[install-daemon] ERROR: $PLIST_SRC 부재" >&2
  exit 1
fi

mkdir -p "$HOME/Library/LaunchAgents"

# {{HOME}} → 실 $HOME 치환 후 cp
sed "s|{{HOME}}|$HOME|g" "$PLIST_SRC" > "$PLIST_DST"
echo "[install-daemon] $PLIST_DST 박음"

# 기존 load 됐으면 unload (재load 의무)
if launchctl list 2>/dev/null | grep -q "com.coin.git-lock-cleaner"; then
  launchctl unload "$PLIST_DST" 2>/dev/null || true
  echo "[install-daemon] 기존 daemon unload"
fi

# load
launchctl load "$PLIST_DST"
echo "[install-daemon] launchctl load PASS"

# 검증
sleep 6
if launchctl list 2>/dev/null | grep -q "com.coin.git-lock-cleaner"; then
  echo "[install-daemon] ✓ daemon 활성 (5초마다 git lock 자동 정리)"
  echo "[install-daemon] log: $HOME/Library/Logs/git-lock-daemon.log"
else
  echo "[install-daemon] WARN: daemon 활성 검증 실패. launchctl list | grep git-lock-cleaner 직접 확인" >&2
fi
