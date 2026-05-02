#!/usr/bin/env bash
# scripts/git-lock-daemon.sh — 등록된 모든 repo 의 .git/index.lock 자동 정리 (PID 검증 + age 보조)
#
# launchd 가 5초마다 호출. 환경 (Cowork/IDE/터미널/sandbox) 무관 작동.
#
# 환경 변수:
#   PARENT_DIR              기본: ~/AndroidStudioProjects
#   GIT_LOCK_DAEMON_AGE_S   기본: 3 (PID 박힘 X 시 mtime 마진 — daemon 짧게)
#   GIT_LOCK_DAEMON_LOG     기본: ~/Library/Logs/git-lock-daemon.log

: "${PARENT_DIR:=$HOME/AndroidStudioProjects}"
: "${GIT_LOCK_DAEMON_AGE_S:=3}"
: "${GIT_LOCK_DAEMON_LOG:=$HOME/Library/Logs/git-lock-daemon.log}"

mkdir -p "$(dirname "$GIT_LOCK_DAEMON_LOG")" 2>/dev/null

log() {
  echo "[$(date '+%FT%T%z')] $*" >> "$GIT_LOCK_DAEMON_LOG"
}

# 모든 자식 repo + master 의 .git/index.lock 검사
for d in "$PARENT_DIR"/*/.git; do
  [ -d "$d" ] || continue
  LOCK="$d/index.lock"
  [ -f "$LOCK" ] || continue

  REPO_NAME=$(basename "$(dirname "$d")")

  # PID 검증
  LOCK_PID=$(cat "$LOCK" 2>/dev/null | head -c 20 | tr -d '\n[:space:]')

  if [ -n "$LOCK_PID" ] && echo "$LOCK_PID" | grep -qE '^[0-9]+$'; then
    if ps -p "$LOCK_PID" > /dev/null 2>&1; then
      # 살아있는 PID = 활성 op = 보호
      continue
    else
      # 죽은 PID = 즉시 rm
      rm -f "$LOCK" 2>/dev/null && log "$REPO_NAME: cleaned dead-PID=$LOCK_PID lock"
    fi
  else
    # PID 박힘 X = mtime 보조
    NOW=$(date +%s)
    LOCK_MTIME=$(stat -f %m "$LOCK" 2>/dev/null || stat -c %Y "$LOCK" 2>/dev/null || echo "$NOW")
    AGE=$((NOW - LOCK_MTIME))
    if [ "$AGE" -gt "$GIT_LOCK_DAEMON_AGE_S" ]; then
      rm -f "$LOCK" 2>/dev/null && log "$REPO_NAME: cleaned no-PID lock (age=${AGE}s)"
    fi
  fi
done

exit 0
