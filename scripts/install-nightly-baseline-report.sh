#!/usr/bin/env bash
# scripts/install-nightly-baseline-report.sh — launchd 야간 잡 install (Coin 1 회 손 작업)
#
# 사용:
#   bash ~/AndroidStudioProjects/claude-cli-master/scripts/install-nightly-baseline-report.sh
#
# 작동:
#   1. ~/Library/LaunchAgents/com.coin.nightly-baseline-report.plist 신설 (HOME 치환)
#   2. 기존 등재 시 unload → load
#   3. 검증: launchctl list | grep + sleep + 1 회 즉시 강제 실행 → 출력 file 생성 확인
#
# 제거:
#   launchctl unload ~/Library/LaunchAgents/com.coin.nightly-baseline-report.plist
#   rm ~/Library/LaunchAgents/com.coin.nightly-baseline-report.plist
#
# Cycle: MASTER-NIGHTLY-BASELINE-CRON-001 (2026-05-14)

set -euo pipefail

LABEL="com.coin.nightly-baseline-report"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLIST_SRC="$SCRIPT_DIR/${LABEL}.plist"
PLIST_DST="$HOME/Library/LaunchAgents/${LABEL}.plist"
MASTER_DIR="$HOME/AndroidStudioProjects/claude-cli-master"
NIGHTLY_DIR="$MASTER_DIR/.ai/nightly-baseline"

if [ ! -f "$PLIST_SRC" ]; then
  echo "[install-nightly-baseline] ERROR: $PLIST_SRC 부재" >&2
  exit 1
fi

mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs" "$NIGHTLY_DIR"

# {{HOME}} → 실 $HOME 치환 cp
sed "s|{{HOME}}|$HOME|g" "$PLIST_SRC" > "$PLIST_DST"
echo "[install-nightly-baseline] plist 신설: $PLIST_DST"

# 기존 등재 시 unload
if launchctl list 2>/dev/null | grep -q "$LABEL"; then
  launchctl unload "$PLIST_DST" 2>/dev/null || true
  echo "[install-nightly-baseline] 기존 등재 unload 마감"
fi

# load
launchctl load "$PLIST_DST"
echo "[install-nightly-baseline] launchctl load 마감"

# 등재 검증
sleep 2
if launchctl list 2>/dev/null | grep -q "$LABEL"; then
  echo "[install-nightly-baseline] ✓ launchctl 등재 (매일 04:00 KST 자동 발화)"
else
  echo "[install-nightly-baseline] WARN: 등재 검증 실패. launchctl list | grep $LABEL 직접 확인" >&2
  exit 2
fi

# self-test 1 회 강제 실행 (install ≠ activation 사고 패턴 mitigation)
echo "[install-nightly-baseline] self-test 1 회 강제 실행 (kickstart)..."
UID_NUM="$(id -u)"
if launchctl kickstart -k "gui/$UID_NUM/$LABEL" 2>&1; then
  echo "[install-nightly-baseline] kickstart 발화 마감"
else
  echo "[install-nightly-baseline] WARN: kickstart 실패. 잡 직접 호출로 fallback 시도" >&2
  bash "$SCRIPT_DIR/nightly-baseline-report.sh" || true
fi

# 출력 file 생성 검증 (claude -p 호출 + 종합 소요로 최대 60 초)
echo "[install-nightly-baseline] 출력 file 생성 검증 (최대 90 초 대기)..."
DATE_ISO="$(date '+%Y-%m-%d')"
EXPECTED="$NIGHTLY_DIR/${DATE_ISO}.md"
LATEST="$NIGHTLY_DIR/latest.md"
i=0
while [ "$i" -lt 18 ]; do
  if [ -f "$EXPECTED" ] && [ -f "$LATEST" ]; then
    echo "[install-nightly-baseline] ✓ 출력 file 생성 확인:"
    echo "    - $EXPECTED ($(wc -c <"$EXPECTED") byte)"
    echo "    - $LATEST ($(wc -c <"$LATEST") byte)"
    echo ""
    echo "[install-nightly-baseline] 본 잡 install + self-test 마감. 매일 04:00 KST 자동 발화."
    echo "[install-nightly-baseline] 리포트: $LATEST"
    echo "[install-nightly-baseline] 로그: $HOME/Library/Logs/nightly-baseline-report.{log,err} + $NIGHTLY_DIR/nightly.log"
    exit 0
  fi
  sleep 5
  i=$((i+1))
done

echo "[install-nightly-baseline] WARN: 90 초 안 출력 file 미생성. 진단 단서:" >&2
echo "    tail -50 $HOME/Library/Logs/nightly-baseline-report.err" >&2
echo "    tail -20 $NIGHTLY_DIR/nightly.log" >&2
echo "    bash $SCRIPT_DIR/nightly-baseline-report.sh  # 직접 호출로 환경 의존 진단" >&2
exit 3
