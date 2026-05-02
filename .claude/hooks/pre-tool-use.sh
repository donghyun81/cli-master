#!/usr/bin/env bash
# pre-tool-use.sh — Bash 호출 자동 allow + 위험 명령 warn + PID 기반 stale git lock 자동 정리
# matcher: "Bash" (settings.json) 가 이미 Bash 만 호출 → 안에서 도구 체크 불필요
# 정책: settings.json deny > hook ask > hook allow (deny 가 항상 우선)
# C9 강화: PID 기반 검증 (mtime 무관 · 정상 op 와 race 0) + mtime 보조 (5s 마진)

set -uo pipefail

INPUT="$(cat 2>/dev/null || echo '')"

CMD=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

# === C9 박음: git command 감지 시 PID 기반 stale lock 자동 정리 ===
case "$CMD" in
  *"git "*|*"git -C"*|*"&& git"*)
    WORK_DIR=""
    if echo "$CMD" | grep -qE "git -C ([^ ]+)"; then
      WORK_DIR=$(echo "$CMD" | grep -oE "git -C ([^ ]+)" | head -1 | sed 's|git -C ||')
    elif echo "$CMD" | grep -qE "cd ([^ &]+)"; then
      WORK_DIR=$(echo "$CMD" | grep -oE "cd ([^ &]+)" | head -1 | sed 's|cd ||')
    fi
    [ -z "$WORK_DIR" ] && WORK_DIR="$PWD"
    WORK_DIR=$(eval echo "$WORK_DIR")
    LOCK_FILE="$WORK_DIR/.git/index.lock"

    if [ -f "$LOCK_FILE" ]; then
      LOCK_PID=$(cat "$LOCK_FILE" 2>/dev/null | head -c 20 | tr -d '\n[:space:]')

      if [ -n "$LOCK_PID" ] && echo "$LOCK_PID" | grep -qE '^[0-9]+$'; then
        if ps -p "$LOCK_PID" > /dev/null 2>&1; then
          # 살아있는 PID = 활성 op = 보호 (단 30s 후에도 살아있으면 stale 의심)
          NOW=$(date +%s)
          LOCK_MTIME=$(stat -f %m "$LOCK_FILE" 2>/dev/null || stat -c %Y "$LOCK_FILE" 2>/dev/null || echo "$NOW")
          AGE=$((NOW - LOCK_MTIME))
          if [ "$AGE" -gt 30 ]; then
            # 30s 초과 + PID 살아있음 = 의심 (long-running git op 또는 hung)
            echo "[HOOK:PRE-TOOL-USE] WARN: .git/index.lock PID=$LOCK_PID 살아있음 + age=${AGE}s (long-running 또는 hung)" >&2
          fi
        else
          # PID 죽음 = 확실한 stale → 즉시 rm
          rm -f "$LOCK_FILE" 2>/dev/null && \
            echo "[HOOK:PRE-TOOL-USE] auto-cleanup dead-PID=$LOCK_PID lock at $WORK_DIR" >&2
        fi
      else
        # PID 박힘 X = 빈 파일 또는 손상 → mtime 보조 (5s 마진)
        NOW=$(date +%s)
        LOCK_MTIME=$(stat -f %m "$LOCK_FILE" 2>/dev/null || stat -c %Y "$LOCK_FILE" 2>/dev/null || echo "$NOW")
        AGE=$((NOW - LOCK_MTIME))
        if [ "$AGE" -gt 5 ]; then
          rm -f "$LOCK_FILE" 2>/dev/null && \
            echo "[HOOK:PRE-TOOL-USE] auto-cleanup no-PID lock (age=${AGE}s) at $WORK_DIR" >&2
        fi
      fi
    fi
    ;;
esac

# 위험 git 명령 warn (non-blocking, stderr)
case "$CMD" in
  *"git stash"*|*"git tag"*|*"git branch -D"*|*"git remote set"*)
    echo "[HOOK:PRE-TOOL-USE] WARN: 위험 git 명령 감지 — $CMD" >&2
    ;;
esac

# 자동 allow JSON 반환 (deny 패턴은 settings.json 이 우선 차단)
echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
exit 0
