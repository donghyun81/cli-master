#!/bin/bash
# Pencil .pen 자동 save hook v2 (Save As filename 자동화 추가)
# 인자: $1 = filename (선택 · 신규 .pen 신설 cycle 시 전달 · 미전달 시 v1 동작 유지)
# 동작:
#   1. Pencil activate + Cmd+S
#   2. filename 인자 존재 시: Save As 모달 가정 + 전체 선택 + filename 입력 + Return
#   3. dir 변경 자동화 X (macOS Save panel 마지막 dir 기억 활용)
#   4. 자동화 실패 silent (CLI 진행 중단 X) · 결과 log 만 기록

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
cd "$REPO_ROOT" || exit 0

FILENAME="$1"
LOG=".ai/hooks/pencil-auto-save.log"
mkdir -p "$(dirname "$LOG")" 2>/dev/null

TS=$(date '+%Y-%m-%dT%H:%M:%S%z')
INPUT=$(cat 2>/dev/null || true)

{
  echo "[$TS] FIRED v2 filename=${FILENAME:-<none>}"
  printf '[%s] STDIN_LEN=%d\n' "$TS" "${#INPUT}"
} >> "$LOG"

osascript -e 'tell application "Pencil" to activate' 2>>"$LOG"
sleep 0.5

osascript -e 'tell application "System Events" to keystroke "s" using command down' 2>>"$LOG"
sleep 1.5

# filename 인자 존재 시 Save As 자동화 시도 (실패 silent)
if [ -n "$FILENAME" ]; then
  osascript 2>>"$LOG" <<OSAEND
tell application "System Events"
  keystroke "a" using command down
  delay 0.2
  keystroke "$FILENAME"
  delay 0.3
  keystroke return
end tell
OSAEND
  echo "[$TS] save-as auto attempted: $FILENAME" >> "$LOG"
  sleep 1.5
fi

exit 0
