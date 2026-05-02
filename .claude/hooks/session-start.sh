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

# === C3 박음: Claude Code 환경 정합 자동 검증 (cycle-discipline.md §13) ===
EXPECTED_VERSION="2.1.114"
ACTUAL_VERSION=$(claude --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
if [ -n "$ACTUAL_VERSION" ] && [ "$ACTUAL_VERSION" != "$EXPECTED_VERSION" ]; then
    echo "[session] WARN: Claude Code 버전 $ACTUAL_VERSION ≠ pin $EXPECTED_VERSION (cycle-discipline §13 의무 다운그레이드)" >&2
elif [ -n "$ACTUAL_VERSION" ]; then
    echo "[session] cc_version=$ACTUAL_VERSION (pin PASS)"
fi

# === C9 박음: 세션 시작 시 PID 기반 stale .git/index.lock 자동 정리 ===
# C8 의 5분 mtime 마진 한계 보완 — PID 검증 우선 (mtime 무관 · 정상 op 와 race 0)
# 작동: PID 죽음 = 즉시 rm / 살아있음 = 보호 / PID 박힘 X = mtime 30s 보조
LOCK_FILE="$REPO_ROOT/.git/index.lock"
if [ -f "$LOCK_FILE" ]; then
    LOCK_PID=$(cat "$LOCK_FILE" 2>/dev/null | head -c 20 | tr -d '\n[:space:]')

    if [ -n "$LOCK_PID" ] && echo "$LOCK_PID" | grep -qE '^[0-9]+$'; then
        if ps -p "$LOCK_PID" > /dev/null 2>&1; then
            echo "[session] .git/index.lock PID=$LOCK_PID 활성 (활성 git op 보호)" >&2
        else
            rm -f "$LOCK_FILE" 2>/dev/null && \
                echo "[session] auto-cleanup dead-PID=$LOCK_PID lock"
        fi
    else
        NOW=$(date +%s)
        LOCK_MTIME=$(stat -f %m "$LOCK_FILE" 2>/dev/null || stat -c %Y "$LOCK_FILE" 2>/dev/null || echo "$NOW")
        AGE=$((NOW - LOCK_MTIME))
        if [ "$AGE" -gt 30 ]; then
            rm -f "$LOCK_FILE" 2>/dev/null && \
                echo "[session] auto-cleanup no-PID lock (age=${AGE}s)"
        else
            echo "[session] WARN: .git/index.lock present (no PID · age=${AGE}s)" >&2
        fi
    fi
fi

exit 0
