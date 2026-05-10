#!/bin/bash
# usage: cap.sh <repo> <screen> <state>  (state = light|dark|empty|error|loading)
REPO="$1"; SCREEN="$2"; STATE="$3"
BASE=~/AndroidStudioProjects/claude-cli-master/.ai/reports/MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001
PNG="$BASE/screenshots/$REPO/${SCREEN}_${STATE}.png"
XML="$BASE/ui-dumps/$REPO/${SCREEN}_${STATE}.xml"
adb -s emulator-5554 exec-out screencap -p > "$PNG"
adb -s emulator-5554 shell uiautomator dump /sdcard/ui.xml > /dev/null 2>&1
adb -s emulator-5554 pull /sdcard/ui.xml "$XML" > /dev/null 2>&1
PNG_SZ=$(stat -f%z "$PNG" 2>/dev/null)
XML_SZ=$(stat -f%z "$XML" 2>/dev/null)
echo "[$REPO/$SCREEN/$STATE] png=$PNG_SZ xml=$XML_SZ"
