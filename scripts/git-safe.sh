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
LOCK_FILE="$GIT_DIR/index.lock"

cleanup_lock() {
  local reason="$1"
  rm -f "$LOCK_FILE" 2>/dev/null
  if [ "$?" = "0" ] && [ "$GIT_SAFE_VERBOSE" = "1" ]; then
    echo "[git-safe] auto-cleanup .git/index.lock ($reason)" >&2
  fi
}

if [ -f "$LOCK_FILE" ]; then
  # === PID 기반 검증 (가장 신뢰성 ↑) ===
  LOCK_PID=$(cat "$LOCK_FILE" 2>/dev/null | head -c 20 | tr -d '\n[:space:]')

  if [ -n "$LOCK_PID" ] && echo "$LOCK_PID" | grep -qE '^[0-9]+$'; then
    if ps -p "$LOCK_PID" > /dev/null 2>&1; then
      # 살아있는 PID — 활성 git op 의심 → 사용자 확인 의무
      echo "[git-safe] WARN: .git/index.lock PID=$LOCK_PID 활성 process 감지 — 5초 대기 후 재검증" >&2
      sleep 5
      if ps -p "$LOCK_PID" > /dev/null 2>&1; then
        echo "[git-safe] ERROR: PID=$LOCK_PID 여전히 살아있음 — git command 차단. 진행 시 'rm $LOCK_FILE' 수동 + 재시도." >&2
        exit 1
      else
        cleanup_lock "PID-died-after-wait"
      fi
    else
      # PID 죽음 = 확실한 stale → 즉시 rm
      cleanup_lock "dead-PID=$LOCK_PID"
    fi
  else
    # PID 박힘 X 또는 형식 X = 거의 stale (빈 파일 또는 손상)
    NOW=$(date +%s)
    LOCK_MTIME=$(stat -f %m "$LOCK_FILE" 2>/dev/null || stat -c %Y "$LOCK_FILE" 2>/dev/null || echo "$NOW")
    AGE=$((NOW - LOCK_MTIME))
    if [ "$AGE" -gt "$STALE_THRESHOLD_S" ]; then
      cleanup_lock "no-PID + age=${AGE}s > ${STALE_THRESHOLD_S}s"
    fi
  fi
fi

# === git command 실행 (wrapper 후 진짜 git 호출) ===
exec git "$@"
