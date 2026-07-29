#!/usr/bin/env bash
# pre-tool-use.sh — Bash 호출 자동 allow + 위험 명령 warn + PID 기반 stale git lock 자동 정리
# matcher: "Bash" (settings.json) 가 이미 Bash 만 호출 → 안에서 도구 체크 불필요
# 정책: settings.json deny > hook ask > hook allow (deny 가 항상 우선)
# C9 강화: PID 기반 검증 (mtime 무관 · 정상 op 와 race 0) + mtime 보조 (5s 마진)

set -uo pipefail

INPUT="$(cat 2>/dev/null || echo '')"

CMD=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

# === C11 추가: git command 감지 시 .git/**/*.lock 광역 PID 검증 + stale 정리 ===
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
    GIT_DIR="$WORK_DIR/.git"

    cleanup_lock_hook() {
      local lock_file="$1"
      [ -f "$lock_file" ] || return
      local lock_pid
      lock_pid=$(cat "$lock_file" 2>/dev/null | head -c 20 | tr -d '
[:space:]')
      if [ -n "$lock_pid" ] && echo "$lock_pid" | grep -qE '^[0-9]+$'; then
        if ps -p "$lock_pid" > /dev/null 2>&1; then
          return  # 활성 PID = 보호
        else
          rm -f "$lock_file" 2>/dev/null && \
            echo "[HOOK:PRE-TOOL-USE] auto-cleanup dead-PID=$lock_pid ${lock_file#$GIT_DIR/}" >&2
        fi
      else
        local now lock_mtime age
        now=$(date +%s)
        lock_mtime=$(stat -f %m "$lock_file" 2>/dev/null || stat -c %Y "$lock_file" 2>/dev/null || echo "$now")
        age=$((now - lock_mtime))
        if [ "$age" -gt 5 ]; then
          rm -f "$lock_file" 2>/dev/null && \
            echo "[HOOK:PRE-TOOL-USE] auto-cleanup no-PID ${lock_file#$GIT_DIR/} (age=${age}s)" >&2
        fi
      fi
    }

    if [ -d "$GIT_DIR" ]; then
      cleanup_lock_hook "$GIT_DIR/index.lock"
      cleanup_lock_hook "$GIT_DIR/HEAD.lock"
      cleanup_lock_hook "$GIT_DIR/packed-refs.lock"
      cleanup_lock_hook "$GIT_DIR/config.lock"
      [ -d "$GIT_DIR/refs" ] && find "$GIT_DIR/refs" -name "*.lock" -type f 2>/dev/null | while read -r ref_lock; do
        cleanup_lock_hook "$ref_lock"
      done
    fi
    ;;
esac

# 위험 git 명령 warn (non-blocking, stderr)
case "$CMD" in
  *"git stash"*|*"git tag"*|*"git branch -D"*|*"git remote set"*)
    echo "[HOOK:PRE-TOOL-USE] WARN: 위험 git 명령 감지 — $CMD" >&2
    ;;
esac

# 판정 미반환 (= 2026-07-29 MASTER-CLI-CONTEXT-DIET-3-001).
# 구 판은 무조건 allow JSON 을 반환했으나 settings.json `defaultMode: bypassPermissions` 가
# 이미 같은 일을 하고 deny 는 어느 쪽이든 우선이라 → 판정 중복. 본 hook 의 실 기능은
# stale git lock 정리 + 위험 git warn 단독. 판정은 harness 소관으로 되돌린다.
exit 0
