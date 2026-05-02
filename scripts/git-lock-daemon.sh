#!/usr/bin/env bash
# scripts/git-lock-daemon.sh — 등록된 모든 repo 의 .git/**/*.lock 광역 자동 정리 (C11 강화)
#
# launchd 가 5초마다 호출. 환경 (Cowork/IDE/터미널/sandbox) 무관 작동.
# C11 강화: index.lock + HEAD.lock + refs/heads/*.lock + packed-refs.lock 모두 처리.

: "${PARENT_DIR:=$HOME/AndroidStudioProjects}"
: "${GIT_LOCK_DAEMON_AGE_S:=3}"
: "${GIT_LOCK_DAEMON_LOG:=$HOME/Library/Logs/git-lock-daemon.log}"

mkdir -p "$(dirname "$GIT_LOCK_DAEMON_LOG")" 2>/dev/null

log() {
  echo "[$(date '+%FT%T%z')] $*" >> "$GIT_LOCK_DAEMON_LOG"
}

cleanup_lock_file() {
  local lock_file="$1"
  local repo_name="$2"
  local lock_type="$3"

  [ -f "$lock_file" ] || return

  # PID 기반 검증
  local lock_pid
  lock_pid=$(cat "$lock_file" 2>/dev/null | head -c 20 | tr -d '\n[:space:]')

  if [ -n "$lock_pid" ] && echo "$lock_pid" | grep -qE '^[0-9]+$'; then
    if ps -p "$lock_pid" > /dev/null 2>&1; then
      return  # 살아있는 PID = 보호
    else
      rm -f "$lock_file" 2>/dev/null && log "$repo_name: cleaned dead-PID=$lock_pid $lock_type"
    fi
  else
    # PID 박힘 X = mtime 보조
    local now lock_mtime age
    now=$(date +%s)
    lock_mtime=$(stat -f %m "$lock_file" 2>/dev/null || stat -c %Y "$lock_file" 2>/dev/null || echo "$now")
    age=$((now - lock_mtime))
    if [ "$age" -gt "$GIT_LOCK_DAEMON_AGE_S" ]; then
      rm -f "$lock_file" 2>/dev/null && log "$repo_name: cleaned no-PID $lock_type (age=${age}s)"
    fi
  fi
}

# 모든 자식 repo + master 의 .git/**/*.lock 광역 검사
for d in "$PARENT_DIR"/*/.git; do
  [ -d "$d" ] || continue
  REPO_NAME=$(basename "$(dirname "$d")")

  # 1. index.lock
  cleanup_lock_file "$d/index.lock" "$REPO_NAME" "index.lock"

  # 2. HEAD.lock
  cleanup_lock_file "$d/HEAD.lock" "$REPO_NAME" "HEAD.lock"

  # 3. packed-refs.lock
  cleanup_lock_file "$d/packed-refs.lock" "$REPO_NAME" "packed-refs.lock"

  # 4. refs/heads/*.lock + refs/remotes/**/*.lock + refs/tags/*.lock
  if [ -d "$d/refs" ]; then
    while IFS= read -r ref_lock; do
      [ -f "$ref_lock" ] || continue
      LOCK_TYPE="${ref_lock#$d/}"
      cleanup_lock_file "$ref_lock" "$REPO_NAME" "$LOCK_TYPE"
    done < <(find "$d/refs" -name "*.lock" -type f 2>/dev/null)
  fi

  # 5. config.lock (config 갱신 중)
  cleanup_lock_file "$d/config.lock" "$REPO_NAME" "config.lock"

  # 6. shallow.lock + ORIG_HEAD.lock + FETCH_HEAD.lock 등 (catch-all)
  for misc_lock in "$d"/*.lock; do
    [ -f "$misc_lock" ] || continue
    LOCK_TYPE=$(basename "$misc_lock")
    # 이미 처리된 것 skip
    case "$LOCK_TYPE" in
      index.lock|HEAD.lock|packed-refs.lock|config.lock) continue ;;
    esac
    cleanup_lock_file "$misc_lock" "$REPO_NAME" "$LOCK_TYPE"
  done
done

exit 0
