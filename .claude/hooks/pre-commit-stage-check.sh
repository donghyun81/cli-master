#!/usr/bin/env bash
# pre-commit-stage-check.sh — git commit 측 stage 영역 측 rename + sed content 정합 검증
# matcher: PreToolUse "Bash" (settings.json) 측 등록 default · 내부 측 "git commit" substring filter default
# 정책: post-rename `git add -u` 의무 paradigm (= cycle-discipline.md §22 정합 default)
# mode: warn default (exit 0 non-blocking) · STAGE_CHECK_ENFORCE=enforce 시 exit 2 차단
# baseline: GB+GD 동족 사고 mitigation (= MASTER-CLI-GIT-MV-SED-STAGE-PARADIGM-CHECK-001 · 2026-05-21)

set -uo pipefail

ALLOW_JSON='{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'

INPUT="$(cat 2>/dev/null || echo '')"

CMD=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

# positional argument fallback (= self-test 영역)
if [ -z "$CMD" ] && [ "$#" -gt 0 ]; then
  CMD="$*"
fi

# trigger 영역 = "git commit" substring 단일 default
case "$CMD" in
  *"git commit"*) ;;
  *)
    echo "$ALLOW_JSON"
    exit 0
    ;;
esac

# working dir 추출 (= pre-tool-use.sh 동족 paradigm default)
WORK_DIR=""
if echo "$CMD" | grep -qE "git -C ([^ ]+)"; then
  WORK_DIR=$(echo "$CMD" | grep -oE "git -C ([^ ]+)" | head -1 | sed 's|git -C ||')
elif echo "$CMD" | grep -qE "cd ([^ &]+)"; then
  WORK_DIR=$(echo "$CMD" | grep -oE "cd ([^ &]+)" | head -1 | sed 's|cd ||')
fi
[ -z "$WORK_DIR" ] && WORK_DIR="$PWD"
WORK_DIR=$(eval echo "$WORK_DIR" 2>/dev/null || echo "$PWD")

# git repo 측 진입 default · 부재 시 silent skip default
if [ ! -d "$WORK_DIR/.git" ]; then
  echo "$ALLOW_JSON"
  exit 0
fi

cd "$WORK_DIR" 2>/dev/null || {
  echo "$ALLOW_JSON"
  exit 0
}

# rename (R prefix) 측 stage 영역 측정 default
RENAMED_FILES=$(git diff --cached --name-status 2>/dev/null | awk '$1 ~ /^R/ {print $3}' || true)

# rename 영역 0 = silent skip default (= 본 hook trigger 영역 X)
if [ -z "$RENAMED_FILES" ]; then
  echo "$ALLOW_JSON"
  exit 0
fi

# working tree 측 unstaged content 영역 측정 default
UNSTAGED_FILES=$(git diff --name-only 2>/dev/null || true)

if [ -z "$UNSTAGED_FILES" ]; then
  echo "$ALLOW_JSON"
  exit 0
fi

# warn 발화 (= rename 영역 + unstaged content 영역 동시 존재 default)
RENAMED_LINE=$(echo "$RENAMED_FILES" | tr '\n' ' ' | sed 's/  *$//')
UNSTAGED_LINE=$(echo "$UNSTAGED_FILES" | tr '\n' ' ' | sed 's/  *$//')

echo "[HOOK:PRE-COMMIT-STAGE-CHECK] WARN: git mv + sed paradigm 측 stage 정합 의심 영역 발견" >&2
echo "  staged rename: $RENAMED_LINE" >&2
echo "  unstaged working tree: $UNSTAGED_LINE" >&2
echo "  mitigation: post-rename 'git add -u' 의무 paradigm (= cycle-discipline.md §22 정합)" >&2

# mode 분기 (= warn default · enforce 별 cycle default)
MODE="${STAGE_CHECK_ENFORCE:-warn}"
if [ "$MODE" = "enforce" ]; then
  cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"git mv + sed paradigm stage 정합 위반 default (cycle-discipline.md §22 정합)"}}
JSON
  exit 2
fi

echo "$ALLOW_JSON"
exit 0
