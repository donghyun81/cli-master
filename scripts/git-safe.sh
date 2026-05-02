#!/usr/bin/env bash
# scripts/git-safe.sh — git command wrapper · stale .git/index.lock 자동 정리 (PID 기반 + mtime 보조)
#
# 사용:
#   bash scripts/git-safe.sh <any git args>
#   또는 alias: alias git='bash ~/AndroidStudioProjects/claude-cli-master/scripts/git-safe.sh'
#
# 작동:
#   1. 현 디렉터리의 .git/index.lock 검사
#   2. PID 기반: lock 안 PID 가 죽었으면 즉시 rm
#   3. mtime 보조: PID 박힘 X 또는 PID 검증 실패 시 stale > 5s 면 rm
#   4. 살아있는 PID = 활성 git op = 보호
#   5. 정리 후 git command 정상 실행
#
# 환경 변수:
#   STALE_THRESHOLD_S    기본: 5초 (mtime 보조 마진)
#   GIT_SAFE_VERBOSE     기본: 0 (1 시 정리 로그 stderr)

: "${STALE_THRESHOLD_S:=5}"
: "${GIT_SAFE_VERBOSE:=0}"

# === 작업 디렉터리에서 git 작동 디렉터리 추정 ===
GIT_DIR=$(git rev-parse --git-dir 2>/dev/null || echo ".git")

cleanup_lock_safe() {
  local lock_file="$1"
  local lock_type="$2"
  [ -f "$lock_file" ] || return

  local lock_pid
  lock_pid=$(cat "$lock_file" 2>/dev/null | head -c 20 | tr -d '\n[:space:]')

  if [ -n "$lock_pid" ] && echo "$lock_pid" | grep -qE '^[0-9]+$'; then
    if ps -p "$lock_pid" > /dev/null 2>&1; then
      return  # 살아있는 PID = 보호
    else
      rm -f "$lock_file" 2>/dev/null
      [ "$GIT_SAFE_VERBOSE" = "1" ] && echo "[git-safe] auto-cleanup dead-PID=$lock_pid $lock_type" >&2
    fi
  else
    local now lock_mtime age
    now=$(date +%s)
    lock_mtime=$(stat -f %m "$lock_file" 2>/dev/null || stat -c %Y "$lock_file" 2>/dev/null || echo "$now")
    age=$((now - lock_mtime))
    if [ "$age" -gt "$STALE_THRESHOLD_S" ]; then
      rm -f "$lock_file" 2>/dev/null
      [ "$GIT_SAFE_VERBOSE" = "1" ] && echo "[git-safe] auto-cleanup no-PID $lock_type (age=${age}s)" >&2
    fi
  fi
}

# === C11 광역: 모든 .git/**/*.lock 검사 ===
cleanup_lock_safe "$GIT_DIR/index.lock" "index.lock"
cleanup_lock_safe "$GIT_DIR/HEAD.lock" "HEAD.lock"
cleanup_lock_safe "$GIT_DIR/packed-refs.lock" "packed-refs.lock"
cleanup_lock_safe "$GIT_DIR/config.lock" "config.lock"

if [ -d "$GIT_DIR/refs" ]; then
  while IFS= read -r ref_lock; do
    cleanup_lock_safe "$ref_lock" "${ref_lock#$GIT_DIR/}"
  done < <(find "$GIT_DIR/refs" -name "*.lock" -type f 2>/dev/null)
fi

# (legacy fallback removed: 광역 검사가 모든 case cover)

if false; then
  : # placeholder
fi

# === git command 실행 (wrapper 후 진짜 git 호출) ===
exec git "$@"
