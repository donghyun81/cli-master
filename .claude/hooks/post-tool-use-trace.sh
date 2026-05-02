#!/bin/bash
# PostToolUse hook — 도구 호출 트레이스 기록.
# 모든 도구 호출을 .ai/traces/<taskId>.jsonl 에 한 줄씩 append.
# macOS bash 3.x 호환. warn-only (차단 없음). 항상 exit 0.

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
cd "$REPO_ROOT" || exit 0

# 에러 로그 디렉터리 보장
mkdir -p .ai/hooks 2>/dev/null || true

# stdin 읽기
INPUT=$(cat)

# tool_name, file_path, exit_code 파싱
PARSED=$(printf '%s' "$INPUT" | python3 -c "
import json, shlex, sys
tool_name = ''
file_path = ''
exit_code = ''
try:
    data = json.load(sys.stdin)
    tool_name = data.get('tool_name', '') or ''
    tool_input = data.get('tool_input', {}) or {}
    file_path = tool_input.get('file_path', '') or tool_input.get('path', '') or ''
    tool_response = data.get('tool_response', {}) or {}
    exit_code = str(tool_response.get('exit_code', '')) if tool_response else ''
except Exception:
    sys.exit(42)
print('TOOL_NAME=%s' % shlex.quote(tool_name))
print('FILE_PATH=%s' % shlex.quote(file_path))
print('EXIT_CODE=%s' % shlex.quote(exit_code))
" 2>/dev/null)
PARSE_STATUS=$?

if [ $PARSE_STATUS -ne 0 ]; then
    TS=$(date '+%Y-%m-%d %H:%M')
    echo "$TS post-tool-use-trace parse failed (exit $PARSE_STATUS)" >> .ai/hooks/trace-error.log 2>/dev/null || true
    exit 0
fi

if [ -n "$PARSED" ]; then
    eval "$PARSED"
else
    TOOL_NAME=""
    FILE_PATH=""
    EXIT_CODE=""
fi

# taskId 결정: $CLAUDE_TASK_ID 환경변수 우선, 없으면 INDEX.md 마지막 활성 task
TASK_ID="${CLAUDE_TASK_ID:-}"

if [ -z "$TASK_ID" ]; then
    INDEX_FILE=".ai/tasks/INDEX.md"
    if [ -f "$INDEX_FILE" ]; then
        # 마지막 활성 task: DONE/STOP 아닌 행에서 첫 번째 | 컬럼 추출
        TASK_ID=$(grep "^|" "$INDEX_FILE" 2>/dev/null \
            | grep -v "^|---" \
            | grep -v "^| TaskId" \
            | grep -v "| DONE " \
            | grep -v "| STOP " \
            | tail -1 \
            | awk -F'|' '{print $2}' \
            | tr -d ' ')
    fi
fi

if [ -z "$TASK_ID" ]; then
    TASK_ID="_unknown"
fi

# 트레이스 디렉터리 보장
TRACE_DIR=".ai/traces"
mkdir -p "$TRACE_DIR" 2>/dev/null || true

TRACE_FILE="$TRACE_DIR/$TASK_ID.jsonl"

# ISO8601 타임스탬프 (bash 3.x: date -u)
TS=$(date -u +%FT%TZ 2>/dev/null || date -u +%Y-%m-%dT%H:%M:%SZ)

# JSON 한 줄 append (python3로 안전한 JSON 직렬화)
printf '%s' "" | python3 -c "
import json, sys
entry = {
    'ts': '$TS',
    'tool': '$TOOL_NAME',
    'path': '$FILE_PATH',
    'exit': '$EXIT_CODE'
}
print(json.dumps(entry, ensure_ascii=False))
" >> "$TRACE_FILE" 2>/dev/null || {
    TS2=$(date '+%Y-%m-%d %H:%M')
    echo "$TS2 post-tool-use-trace write failed: $TRACE_FILE" >> .ai/hooks/trace-error.log 2>/dev/null || true
}

exit 0
