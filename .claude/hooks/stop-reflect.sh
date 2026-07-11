#!/bin/bash
# stop-reflect.sh — paradigm 누적 자동 추출 hook (Stop hook · silent-success default)
# 신설: MASTER-CLI-INFRA-SELFIMPROVING-REVIEW-CADENCE-001 (2026-05-17)
# 관련: docs/rules/cycle-discipline.md §19 (Hooks self-improving loop)
#
# 동작:
#   .ai/reports/<taskId>/REVIEW.md 또는 EVIDENCE.md 안 paradigm 누적 패턴 grep
#   → 한 file 안 3+ 회 발화 시점만 trigger
#   → stderr 1~3 줄 silent 후보 제안 (cli infra 정착 후보)
#
# Exit code: 항상 exit 0 (non-blocking · 기존 stop-gate.sh 영역 breakage X)
#
# mode (env: REFLECT_ENFORCE):
#   warn (default) = stderr 발화
#   silent = 출력 0 (debug 영역)
#
# self-test:
#   bash .claude/hooks/stop-reflect.sh
#   bash .claude/hooks/stop-reflect.sh <path>
#
# macOS bash 3.x 호환

set -u

MODE="${REFLECT_ENFORCE:-warn}"

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
cd "$REPO_ROOT" || exit 0

# 입력 결정 (positional arg fallback · self-test 영역)
TARGETS=""
if [ $# -ge 1 ] && [ -f "$1" ]; then
    TARGETS="$1"
else
    REPORTS_DIR=".ai/reports"
    if [ -d "$REPORTS_DIR" ]; then
        TARGETS=$(find "$REPORTS_DIR" -maxdepth 3 -type f \( -name "REVIEW.md" -o -name "EVIDENCE.md" \) 2>/dev/null)
    fi
fi

[ -z "$TARGETS" ] && exit 0

# paradigm 누적 패턴 (ERE · 한정 cluster · false positive 회피)
PATTERN='(신|새|emerging|new|정합|consistent|recurring|누적|반복|accumulated) (paradigm|패러다임)'
THRESHOLD=3

CANDIDATES=""

for f in $TARGETS; do
    [ -f "$f" ] || continue
    COUNT=$(grep -E -c "$PATTERN" "$f" 2>/dev/null)
    # grep -c 가 match 0 시 exit 1 + stdout 0 출력 → 안전 fallback
    [ -z "$COUNT" ] && COUNT=0
    if [ "$COUNT" -ge "$THRESHOLD" ]; then
        SAMPLE=$(grep -E "$PATTERN" "$f" 2>/dev/null | head -1 | sed 's/^[[:space:]]*//' | cut -c1-80)
        CANDIDATES="${CANDIDATES}  - ${f}: ${COUNT}회 paradigm 누적 (sample: ${SAMPLE})\n"
    fi
done

if [ -n "$CANDIDATES" ] && [ "$MODE" != "silent" ]; then
    echo "" >&2
    echo "[STOP-REFLECT] paradigm 누적 패턴 감지 (≥${THRESHOLD}회 · cli infra 정착 후보):" >&2
    printf "%b" "$CANDIDATES" >&2
    echo "" >&2
    echo "  채택 의사 = 사용자 자율 (CLAUDE.md / .auto-memory 갱신 후보 silent 제안 영역)." >&2
    echo "  규칙: docs/rules/cycle-discipline.md §19" >&2
    echo "" >&2
fi

exit 0
