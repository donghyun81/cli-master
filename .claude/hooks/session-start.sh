#!/bin/bash
# SessionStart hook — silent-success / verbose-failure.
# macOS bash 3.x 호환.
#
# 정상 경로 출력: branch / open task count / last REVIEW verdict / (PromptFit drift)
# 총 ≤ 4 줄 (PromptFit drift 포함 시). 누락/오류 신호가 있을 때만 WARN.
# read-only. 네트워크 없음. 항상 exit 0.

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
cd "$REPO_ROOT" || exit 0

# 1. branch
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "UNKNOWN")
echo "[session] branch=$BRANCH"

# 2. open task count
INDEX_FILE=".ai/tasks/INDEX.md"
OPEN_COUNT=0
if [ -f "$INDEX_FILE" ]; then
    OPEN_COUNT=$(grep "^|" "$INDEX_FILE" 2>/dev/null \
        | grep -v "^|---" \
        | grep -v "^| TaskId" \
        | grep -v "| DONE " \
        | grep -v "| STOP " \
        | wc -l \
        | tr -d ' ')
fi
echo "[session] open_tasks=$OPEN_COUNT"

# 3. last REVIEW verdict (가장 최근 수정된 REVIEW.md 한 건)
LAST_VERDICT="n/a"
LAST_TASK="n/a"
REPORTS_DIR=".ai/reports"
if [ -d "$REPORTS_DIR" ]; then
    LATEST_DIR=""
    LATEST_TIME=0
    for DIR in "$REPORTS_DIR"/*/; do
        [ -d "$DIR" ] || continue
        REVIEW_FILE="${DIR}REVIEW.md"
        [ -f "$REVIEW_FILE" ] || continue
        MOD_TIME=$(stat -f %m "$REVIEW_FILE" 2>/dev/null || echo "0")
        if [ "$MOD_TIME" -gt "$LATEST_TIME" ] 2>/dev/null; then
            LATEST_TIME="$MOD_TIME"
            LATEST_DIR="$DIR"
        fi
    done
    if [ -n "$LATEST_DIR" ]; then
        LAST_TASK=$(basename "$LATEST_DIR")
        VERDICT_LINE=$(grep -Eo "\b(PASS|FAIL|PARTIAL)\b" "${LATEST_DIR}REVIEW.md" 2>/dev/null | head -1)
        LAST_VERDICT="${VERDICT_LINE:-unknown}"
    fi
fi
echo "[session] last_review=$LAST_TASK $LAST_VERDICT"

# 4. PromptFit drift signal — 최근 5 건 PromptFitScore 평균
# INDEX.md row format: `| <taskId> | <date> | <score> | <verdict> | ...`
PROMPTFIT_INDEX=".ai/promptfit/INDEX.md"
if [ -f "$PROMPTFIT_INDEX" ]; then
    AVG=$(grep -E "^\| SW-|^\| MP-" "$PROMPTFIT_INDEX" 2>/dev/null \
        | awk -F'|' '{
            score = $4
            gsub(/ /, "", score)
            if (score ~ /^[0-9]+$/) print score
          }' \
        | tail -5 \
        | awk '{sum+=$1; n+=1} END { if (n>0) printf "%.1f", sum/n; }')
    if [ -n "$AVG" ]; then
        echo "[session] promptfit_avg5=$AVG"
    fi
fi

# 5. .auto-memory/protected-file-hashes.md snapshot (Cycle 16)
PROTECTED_HASHES=".auto-memory/protected-file-hashes.md"
if [ -f "$PROTECTED_HASHES" ]; then
    PROTECTED_COUNT=$(grep -cE "^\| (docs/|\.claude/)" "$PROTECTED_HASHES" 2>/dev/null | tr -d ' ')
    echo "[session] protected_baseline_count=$PROTECTED_COUNT"
fi

# === C3 추가: Claude Code 환경 정합 자동 검증 (cycle-discipline.md §13) ===
EXPECTED_VERSION="2.1.114"
ACTUAL_VERSION=$(claude --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
if [ -n "$ACTUAL_VERSION" ] && [ "$ACTUAL_VERSION" != "$EXPECTED_VERSION" ]; then
    echo "[session] WARN: Claude Code 버전 $ACTUAL_VERSION ≠ pin $EXPECTED_VERSION (cycle-discipline §13 의무 다운그레이드)" >&2
elif [ -n "$ACTUAL_VERSION" ]; then
    echo "[session] cc_version=$ACTUAL_VERSION (pin PASS)"
fi

# === C11 추가: 세션 시작 시 .git/**/*.lock 광역 PID 검증 + stale 자동 정리 ===
GIT_DIR_HOOK="$REPO_ROOT/.git"

cleanup_session_lock() {
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
                echo "[session] auto-cleanup dead-PID=$lock_pid ${lock_file#$GIT_DIR_HOOK/}"
        fi
    else
        local now lock_mtime age
        now=$(date +%s)
        lock_mtime=$(stat -f %m "$lock_file" 2>/dev/null || stat -c %Y "$lock_file" 2>/dev/null || echo "$now")
        age=$((now - lock_mtime))
        if [ "$age" -gt 30 ]; then
            rm -f "$lock_file" 2>/dev/null && \
                echo "[session] auto-cleanup no-PID ${lock_file#$GIT_DIR_HOOK/} (age=${age}s)"
        fi
    fi
}

if [ -d "$GIT_DIR_HOOK" ]; then
    cleanup_session_lock "$GIT_DIR_HOOK/index.lock"
    cleanup_session_lock "$GIT_DIR_HOOK/HEAD.lock"
    cleanup_session_lock "$GIT_DIR_HOOK/packed-refs.lock"
    cleanup_session_lock "$GIT_DIR_HOOK/config.lock"
    [ -d "$GIT_DIR_HOOK/refs" ] && find "$GIT_DIR_HOOK/refs" -name "*.lock" -type f 2>/dev/null | while read -r ref_lock; do
        cleanup_session_lock "$ref_lock"
    done
fi

# === 사고 1 mitigation: ARGUMENTS stale inject 방지 ===
# 직전 CLI 세션 마감 시 ARGUMENTS env 안 비움 → 새 세션 진입 시 stale [C1/N] 재 inject risk.
unset ARGUMENTS 2>/dev/null
echo "[session] arguments_purged"

# === 사고 4 mitigation: launchd daemon 활성 검증 (C12 권장 영구 적용) ===
if command -v launchctl >/dev/null 2>&1; then
    DAEMON_LABEL="com.coin.git-lock-cleaner"
    if ! launchctl list 2>/dev/null | grep -q "$DAEMON_LABEL"; then
        echo "[session] WARN: git-lock daemon 미활성 (사고 4 재발 risk)" >&2
        PLIST_PATH="$HOME/Library/LaunchAgents/$DAEMON_LABEL.plist"
        if [ -f "$PLIST_PATH" ]; then
            echo "[session]   load: launchctl load $PLIST_PATH" >&2
        else
            echo "[session]   install: bash \$MASTER_DIR/scripts/install-git-lock-daemon.sh" >&2
        fi
    else
        echo "[session] daemon=active"
    fi
fi

# === MASTER-WORKING-FILE-LIFECYCLE-001 — working file archive sweep (warn-only) ===
WFA_SCRIPT="$(cd "$(dirname "$0")/../.." && pwd)/scripts/working-file-archiver.sh"
if [ -x "$WFA_SCRIPT" ]; then
  "$WFA_SCRIPT" 2>/dev/null || true
fi

exit 0
