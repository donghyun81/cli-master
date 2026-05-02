#!/bin/bash
# PostToolUse hook — 정책 파일 변경 감지 + 제품 코드 cleanup reminder.
# silent-success / verbose-failure: 매칭이 없으면 완전 무출력.
# macOS bash 3.x 호환. warn-only (차단 없음). 항상 exit 0.

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
cd "$REPO_ROOT" || exit 0

# Runtime observation (L5 SW-CLI-HARNESS-003): log every invocation so we can
# verify PostToolUse matcher fires on Edit|Write. Non-blocking — failure to
# write the log must not affect the hook main flow.
echo "[post-policy-watch] tool=${CLAUDE_TOOL_NAME:-unknown} ts=$(date -u +%FT%TZ)" >> "${CLAUDE_PROJECT_DIR:-$REPO_ROOT}/.ai/hooks/post-policy-watch.log" 2>/dev/null || true

INPUT=$(cat)

PARSED=$(printf '%s' "$INPUT" | python3 -c "
import json, shlex, sys
file_path = ''
try:
    data = json.load(sys.stdin)
    tool_input = data.get('tool_input', {}) or {}
    file_path = tool_input.get('file_path', '') or tool_input.get('path', '') or ''
except Exception:
    sys.exit(42)
print('FILE_PATH=%s' % shlex.quote(file_path))
")
PARSE_STATUS=$?

if [ $PARSE_STATUS -ne 0 ]; then
    mkdir -p .ai/hooks 2>/dev/null
    TS=$(date '+%Y-%m-%d %H:%M')
    echo "$TS post-policy-watch parse failed" >> .ai/hooks/last-error.log
    exit 0
fi

if [ -n "$PARSED" ]; then
    eval "$PARSED"
else
    FILE_PATH=""
fi

if [ -z "$FILE_PATH" ]; then
    exit 0
fi

REL_PATH="$FILE_PATH"
case "$REL_PATH" in
    "$REPO_ROOT"/*)
        REL_PATH=${REL_PATH#"$REPO_ROOT"/}
        ;;
    "$PWD"/*)
        REL_PATH=${REL_PATH#"$PWD"/}
        ;;
esac

POLICY_MATCH=0
case "$REL_PATH" in
    CLAUDE.md|.claude/settings*|.claude/rules/*|.claude/agents/*|.claude/hooks/*|.claude/skills/*)
        POLICY_MATCH=1
        ;;
esac

IS_OPS=0
case "$REL_PATH" in
    CLAUDE.md|.claude/*|.ai/*|docs/*|scripts/agent/*)
        IS_OPS=1
        ;;
esac

IS_PRODUCT_CODE=0
case "$REL_PATH" in
    app/*|feature/*|shared/*|iosApp/*)
        case "$REL_PATH" in
            *.kt|*.swift|*.ts|*.tsx|*.js|*.jsx|*.gradle|*.kts|*.xml)
                IS_PRODUCT_CODE=1
                ;;
        esac
        ;;
esac

# 매칭 없으면 완전 무출력
if [ "$POLICY_MATCH" = "0" ] && { [ "$IS_OPS" = "1" ] || [ "$IS_PRODUCT_CODE" = "0" ]; }; then
    exit 0
fi

if [ "$POLICY_MATCH" = "1" ]; then
    echo "[HOOK:POLICY-WATCH] $REL_PATH — 정책 변경. DocSync 또는 의도 확인 필요 (warn-only)." >&2
fi

if [ "$IS_OPS" = "0" ] && [ "$IS_PRODUCT_CODE" = "1" ]; then
    echo "[HOOK:CLEANUP-WATCH] $REL_PATH — EVIDENCE.md 에 '## Cleanup Assessment' 남기세요 (remind-only)." >&2
fi

exit 0
