#!/bin/bash
# measure-gsm-cycle.sh — GSM cycle 건강(DORA 4-key) 자동 측정 (Stop hook · non-blocking · 항상 exit 0)
# 신설: MASTER-CLI-GSM-MEASUREMENT-LAYER-001 (2026-06-02)
# 관련: .claude/rules/gsm-measurement.md §3 (DORA 정의) · §4 (측정 layer) ·
#       .auto-memory/cycle-health-log.md (정량 append source) ·
#       stop-reflect.sh / stop-housekeeping.sh (= 동일 non-blocking advisory 철학)
#
# 동작:
#   1. master repo 의 git log 에서 DORA 4-key proxy 산출 (= 결정론적 read-only · Transport)
#   2. cycle-health-log.md 의 마지막 기록 HEAD 와 현재 master HEAD 대조 (= idempotent guard)
#   3. 새 master cycle commit 발견 시에만 surface (= turn 단위 spam 회피 · cycle 단위)
#   4. mode=append 시 한 행 정량 append (= cycle-health-log.md)
#
# 판정 경계 (automation-policy.md 정합): git log 파싱 = Transport(자동 OK).
#   지표가 건강한가의 판정 + amend 결정 = Inspection(수동 · gsm-measurement.md §4·§6).
#   → 본 hook = surface/append 까지. 판정은 사용자/master cycle 영역.
#
# Exit: 항상 exit 0 (= stop-gate.sh blocking 영역 무접촉)
# mode (env GSM_MEASURE_ENFORCE):
#   advisory (default) = 새 cycle 시 stderr surface · log append X
#   append             = surface + cycle-health-log.md 한 행 append (idempotent)
#   silent             = 출력 0 (행동 유지)
# self-test: bash .claude/hooks/measure-gsm-cycle.sh           (= master 측정)
#            bash .claude/hooks/measure-gsm-cycle.sh <repo-dir> (= 지정 repo 측정)
# macOS bash 3.x 호환 (associative array X / ${var,,} X)

set -u

MODE="${GSM_MEASURE_ENFORCE:-advisory}"

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")

# mount root 탐지 (= claude-cli-master 포함 부모 · 부모 root 진입 + 자식 repo 진입 모두 cover)
if [ -d "$REPO_ROOT/claude-cli-master" ]; then
  MOUNT_ROOT="$REPO_ROOT"
elif [ -d "$REPO_ROOT/../claude-cli-master" ]; then
  MOUNT_ROOT="$(cd "$REPO_ROOT/.." && pwd)"
else
  MOUNT_ROOT="$REPO_ROOT"
fi
MASTER_DIR="$MOUNT_ROOT/claude-cli-master"

# 측정 대상 = master (DORA = master cycle 지표). positional arg 로 override (self-test).
MEASURED_DIR="$MASTER_DIR"
if [ $# -ge 1 ] && [ -d "$1/.git" ]; then
  MEASURED_DIR="$1"
fi

# master 부재 또는 git 아님 = no-op
[ -d "$MEASURED_DIR/.git" ] || exit 0

LOG_FILE="$MASTER_DIR/.auto-memory/cycle-health-log.md"

# cycle-marker = commit subject 안 cycle ID 패턴 (= 대문자 토큰 + -NNN)
CYCLE_MARKER='[A-Z][A-Z0-9_-]+-[0-9]{3}'

# --- 현재 / 직전 기록 HEAD ---
CURRENT_HEAD=$(git -C "$MEASURED_DIR" rev-parse --short=12 HEAD 2>/dev/null || echo "")
[ -z "$CURRENT_HEAD" ] && exit 0

LAST_HEAD=""
if [ -f "$LOG_FILE" ]; then
  # log 마지막 행의 HEAD 토큰 (= 12 hex · backtick 래핑)
  LAST_HEAD=$(grep -oE '`[0-9a-f]{12}`' "$LOG_FILE" 2>/dev/null | tail -1 | tr -d '`')
fi

# 이미 기록된 HEAD = 새 cycle 아님 = 조용히 종료 (turn 단위 spam 회피)
if [ -n "$LAST_HEAD" ] && [ "$LAST_HEAD" = "$CURRENT_HEAD" ]; then
  exit 0
fi

# 새 commit 중 cycle-marker 존재 여부 (= 평범한 commit 이면 no-op)
# grep -c 는 match 0 시에도 "0" 을 stdout 에 출력(+exit 1) → `|| echo 0` 미사용(= 이중 출력 방지).
NEW_CYCLE_HITS=0
if [ -n "$LAST_HEAD" ]; then
  NEW_CYCLE_HITS=$(git -C "$MEASURED_DIR" log "${LAST_HEAD}..${CURRENT_HEAD}" --format='%s' 2>/dev/null | grep -cE "$CYCLE_MARKER")
else
  # log 비어 있음(첫 측정) = 최근 1 commit 의 cycle-marker 로 판정
  NEW_CYCLE_HITS=$(git -C "$MEASURED_DIR" log -1 --format='%s' 2>/dev/null | grep -cE "$CYCLE_MARKER")
fi
[ -z "$NEW_CYCLE_HITS" ] && NEW_CYCLE_HITS=0

# cycle-marker 없는 평범한 commit = no-op (= 측정 cadence = cycle 단위)
if [ "$NEW_CYCLE_HITS" -eq 0 ]; then
  exit 0
fi

# --- DORA 4-key proxy 산출 (read-only) ---
# Deployment frequency: distinct cycle ID 수 (7d / 30d) — commit 수 아님(= 1 cycle = master+propagate+audit 다중 commit → dedup).
FREQ_WEEK=$(git -C "$MEASURED_DIR" log --since='7 days ago' --format='%s' 2>/dev/null | grep -oE "$CYCLE_MARKER" | sort -u | wc -l | tr -d ' ')
FREQ_MONTH=$(git -C "$MEASURED_DIR" log --since='30 days ago' --format='%s' 2>/dev/null | grep -oE "$CYCLE_MARKER" | sort -u | wc -l | tr -d ' ')
[ -z "$FREQ_WEEK" ] && FREQ_WEEK=0
[ -z "$FREQ_MONTH" ] && FREQ_MONTH=0

# Change failure rate proxy: revert/rollback/hotfix commit 수 (30d) — STOP/drift 정성 = incident-log(수동)
FAILURE_MONTH=$(git -C "$MEASURED_DIR" log --since='30 days ago' --format='%s' 2>/dev/null | grep -ciE '(^revert|revert:|rollback|hotfix)')
[ -z "$FAILURE_MONTH" ] && FAILURE_MONTH=0

# Lead time proxy: 최근 2 cycle-marker commit 간 경과(시간)
GAP_HOURS="n/a"
TWO_TS=$(git -C "$MEASURED_DIR" log --since='90 days ago' --format='%ct|%s' 2>/dev/null | grep -E "\|.*$CYCLE_MARKER" | head -2 | cut -d'|' -f1)
TS_NEW=$(echo "$TWO_TS" | sed -n '1p')
TS_OLD=$(echo "$TWO_TS" | sed -n '2p')
if [ -n "$TS_NEW" ] && [ -n "$TS_OLD" ] && [ "$TS_NEW" -gt "$TS_OLD" ] 2>/dev/null; then
  GAP_HOURS=$(( (TS_NEW - TS_OLD) / 3600 ))
fi

NOW_KST=$(TZ='Asia/Seoul' date '+%Y-%m-%d %H:%M' 2>/dev/null || date '+%Y-%m-%d %H:%M')
CYCLE_SUBJECT=$(git -C "$MEASURED_DIR" log -1 --format='%s' 2>/dev/null | grep -oE "$CYCLE_MARKER" | head -1)
[ -z "$CYCLE_SUBJECT" ] && CYCLE_SUBJECT="(unmarked)"

# --- mode=append: cycle-health-log.md 한 행 append (idempotent · LAST_HEAD guard 통과분만) ---
if [ "$MODE" = "append" ] && [ -f "$LOG_FILE" ]; then
  printf '| %s | %s | `%s` | %s/주 (30d %s) | %sh | revert %s (30d) | incident-log 참조 |\n' \
    "$NOW_KST" "$CYCLE_SUBJECT" "$CURRENT_HEAD" "$FREQ_WEEK" "$FREQ_MONTH" "$GAP_HOURS" "$FAILURE_MONTH" \
    >> "$LOG_FILE"
fi

# --- surface (mode != silent) ---
if [ "$MODE" != "silent" ]; then
  echo "" >&2
  echo "[GSM-MEASURE] cycle 건강 DORA proxy (= advisory · 판정은 수동 · gsm-measurement.md §3·§4):" >&2
  echo "  cycle: $CYCLE_SUBJECT @ $CURRENT_HEAD" >&2
  echo "  Deployment freq: ${FREQ_WEEK} cycle/주 (distinct · 30d ${FREQ_MONTH}) · Lead time proxy: ${GAP_HOURS}h(최근 cycle commit 간격) · Change failure proxy: revert ${FAILURE_MONTH}/30d · MTTR: incident-log(수동)" >&2
  if [ "$MODE" = "append" ]; then
    echo "  → cycle-health-log.md append 박음 ($CURRENT_HEAD)" >&2
  else
    echo "  → append 미실행 (= advisory · GSM_MEASURE_ENFORCE=append 로 정량 기록)" >&2
  fi
  echo "  규칙: gsm-measurement.md §6 amend 정량 trigger (N cycle 연속 deviation → 후보) · GSM_MEASURE_ENFORCE=silent 음소거" >&2
  echo "" >&2
fi

exit 0
