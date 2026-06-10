#!/bin/bash
# measure-gsm-cycle.sh — GSM 측정 (DORA 4-key cycle 건강 + context 건강) 자동 측정 (Stop hook · non-blocking · 항상 exit 0)
# 신설: MASTER-CLI-GSM-MEASUREMENT-LAYER-001 (2026-06-02)
# 확장: MASTER-CLI-GSM-CONTEXT-HEALTH-ABSORB-001 (2026-06-04 · context-health 측정 흡수 · 신 hook 신설 X · settings.json 무접촉)
# 관련: .claude/rules/gsm-measurement.md §2 (Metric family) · §3 (DORA 정의) · §4 (측정 layer) ·
#       .auto-memory/cycle-health-log.md (DORA 정량 append) · .auto-memory/context-health-metrics.md §3.1 (context 건강 분기 append) ·
#       stop-reflect.sh / stop-housekeeping.sh (= 동일 non-blocking advisory 철학)
#
# 동작:
#   1. master repo 의 git log 에서 DORA 4-key proxy 산출 (= 결정론적 read-only · Transport)
#   2. cycle-health-log.md 의 마지막 기록 HEAD 와 현재 master HEAD 대조 (= idempotent guard)
#   3. 새 master cycle commit 발견 시에만 surface (= turn 단위 spam 회피 · cycle 단위)
#   4. mode=append 시 한 행 정량 append (= cycle-health-log.md)
#   5. (context 건강) 새 cycle 감지 + 분기(quarter) guard 통과 시 항상로드 char 4 + stale_pointer 측정·surface
#      · mode=append 시 context-health-metrics.md §3.1 한 행 append (= 분기 1회 idempotent)
#      · GSM_CONTEXT_HEALTH_FORCE=1 = new-cycle 게이팅 무관 즉시 평가 (self-test/수동 분기 · 분기 guard 유지)
#
# 판정 경계 (automation-policy.md 정합): git log 파싱 = Transport(자동 OK).
#   지표가 건강한가의 판정 + amend 결정 = Inspection(수동 · gsm-measurement.md §4·§6).
#   → 본 hook = surface/append 까지. 판정은 사용자/master cycle 영역.
#
# Exit: 항상 exit 0 (= stop-gate.sh blocking 영역 무접촉)
# mode (env GSM_MEASURE_ENFORCE):
#   advisory (default) = 새 cycle 시 stderr surface · log append X
#   append             = surface + cycle-health-log.md (DORA) + context-health-metrics.md §3.1 (분기) 한 행 append (idempotent)
#   silent             = 출력 0 (행동 유지)
# context-health 강제 (env GSM_CONTEXT_HEALTH_FORCE=1): new-cycle 게이팅 무관 즉시 context-health 평가 (분기 guard 는 유지)
# self-test: bash .claude/hooks/measure-gsm-cycle.sh                                  (= master DORA 측정)
#            bash .claude/hooks/measure-gsm-cycle.sh <repo-dir>                        (= 지정 repo DORA 측정)
#            GSM_CONTEXT_HEALTH_FORCE=1 GSM_MEASURE_ENFORCE=append bash .claude/hooks/measure-gsm-cycle.sh  (= context-health 분기 append)
# macOS bash 3.x 호환 (associative array X / ${var,,} X)

set -u

MODE="${GSM_MEASURE_ENFORCE:-advisory}"
# context-health 분기 측정 강제 (= self-test/수동 분기 · new-cycle 게이팅 무관 · 분기 guard 는 유지)
CH_FORCE="${GSM_CONTEXT_HEALTH_FORCE:-0}"

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

# === context-health 측정 (= MASTER-CLI-GSM-CONTEXT-HEALTH-ABSORB-001 · 2026-06-04 확장) ===
# 본질: context 건강 지표(항상로드 char 4 + 환각 stale_pointer)를 신 hook 신설 없이 본 GSM Stop hook 으로 흡수.
#   - cadence = 분기(quarter bucket 경과 guard) · 매 Stop X · advisory(non-blocking · cycle 차단 X · exit 0 보존)
#   - 자동 = char 4(codepoint python3) + stale_pointer(상대경로 .md file-link 존재 grep)
#   - 수기 = conflicting_sot / buried_ratio (판정 난이도 ↑ → row 에 manual · 값은 §2 수기 갱신)
#   - append 대상 = context-health-metrics.md §3.1 (master-only · propagation X · 자식 진입도 master 측 append)
#   - char = codepoint proxy(token 아님 · over-claim 금지 · proxy band 라벨 surface 보존)
CONTEXT_HEALTH_FILE="$MASTER_DIR/.auto-memory/context-health-metrics.md"

# UTF-8 codepoint count (= context-health-metrics.md §1 측정 명령 정합) · 부재/실패 시 0
ch_count() {
  [ -f "$1" ] || { echo 0; return 0; }
  python3 -c "import sys; print(len(open(sys.argv[1], encoding='utf-8').read()))" "$1" 2>/dev/null || echo 0
}

# 다중 file codepoint 합 (= L0 kernel char)
ch_sum() {
  ch_total=0
  for ch_f in "$@"; do
    ch_n=$(ch_count "$ch_f")
    ch_total=$(( ch_total + ch_n ))
  done
  echo "$ch_total"
}

# stale_pointer(auto) = .claude/rules/*.md 안 죽은 내부 인용 수:
#   (a) 상대경로 .md markdown-link (sp_base 기준 해소 · 기존)
#   (b) backtick-wrap repo-root-relative .sh/.json/.md 경로 (sp_repo_root 기준 해소 · MASTER-CLI-DEAD-REF-SWEEP-001 확장)
#       = §-link 외 죽은 backtick 인용(예: 구 `scripts/agent/compound-lint.sh` · deprecated — 의도적 죽은-인용 예시) 검출. master-owned cli-infra dir 한정(= 절대 존재 의무 영역).
#       FP 억제: placeholder(<>)·glob(*)·var($)·공백·URL·절대(/)·cross-repo(../·./) 제외 +
#                whitelist prefix(.claude/ scripts/ .auto-memory/ docs/agent/ docs/schemas/) 한정(= 자식-context docs/ 경로 오검출 회피).
#   scope 한계(= surface label 명시 의무 · proxy band 라벨 동형): non-backtick bare 경로 · 자식-context(docs/CLAUDE.md 등) ·
#       cross-repo(../) 경로 · §-level anchor = 미검출 → 값(0 포함)은 scope-한정 신호 · 전역 dead-ref 부재 보증 X.
stale_pointer_count() {
  sp_dir="$1"
  sp_count=0
  [ -d "$sp_dir" ] || { echo 0; return 0; }
  # backtick repo-root-relative 경로 해소 base (= sp_dir 의 repo root · .claude/rules → ../..)
  sp_repo_root=$(cd "$sp_dir/../.." 2>/dev/null && pwd)
  [ -z "$sp_repo_root" ] && sp_repo_root="$sp_dir"
  for sp_f in "$sp_dir"/*.md; do
    [ -f "$sp_f" ] || continue
    sp_base=$(dirname "$sp_f")
    # (a) markdown-link 상대경로 .md (sp_base 기준)
    while IFS= read -r sp_link; do
      [ -z "$sp_link" ] && continue
      sp_target="${sp_link%%#*}"
      case "$sp_target" in
        http*|/*|"") continue ;;
      esac
      [ -f "$sp_base/$sp_target" ] || sp_count=$(( sp_count + 1 ))
    done <<CH_EOF
$(grep -oE '\]\(\.\.?/[^)]+\.md[^)]*\)' "$sp_f" 2>/dev/null | sed -E 's/^\]\(//; s/\)$//')
CH_EOF
    # (b) backtick repo-root-relative .sh/.json/.md (master-owned dir 한정 · FP 억제 · sp_repo_root 기준)
    while IFS= read -r sp_bt; do
      [ -z "$sp_bt" ] && continue
      sp_t="${sp_bt%%#*}"
      case "$sp_t" in
        *'<'*|*'>'*|*'*'*|*'$'*|*' '*|http*|/*|../*|./*) continue ;;
        */settings.local.json|settings.local.json) continue ;;  # 선택적 personal override (propagate.sh PRUNE_EXCLUDE_NAMES 정합 · 부재=정상)
      esac
      case "$sp_t" in
        .claude/*|scripts/*|.auto-memory/*|docs/agent/*|docs/schemas/*) ;;
        *) continue ;;
      esac
      [ -f "$sp_repo_root/$sp_t" ] || [ -d "$sp_repo_root/$sp_t" ] || sp_count=$(( sp_count + 1 ))
    done <<BT_EOF
$(grep -oE '`[^`]+\.(sh|json|md)`' "$sp_f" 2>/dev/null | tr -d '`')
BT_EOF
  done
  echo "$sp_count"
}

# self-test: stale_pointer 확장 scan fixture 검증 (= MASTER-CLI-DEAD-REF-SWEEP-001 · §7 paste-back)
#   사용: GSM_STALE_SELFTEST=1 bash .claude/hooks/measure-gsm-cycle.sh <fixture-repo>/.claude/rules
if [ "${GSM_STALE_SELFTEST:-0}" = "1" ]; then
  st_dir="${1:-}"
  if [ -d "$st_dir" ]; then
    echo "stale_pointer_count($st_dir) = $(stale_pointer_count "$st_dir")"
  else
    echo "GSM_STALE_SELFTEST: dir arg 필요 (예: bash $0 <fixture-repo>/.claude/rules)" >&2
  fi
  exit 0
fi

# context-health 측정 + 분기 guard + (append mode 시) §3.1 append + advisory surface
run_context_health() {
  [ -f "$CONTEXT_HEALTH_FILE" ] || return 0

  # 분기 guard (= quarter bucket · 마지막 auto row 분기 대조 · 같은(또는 과거) 분기 = skip · idempotent)
  ch_now_y=$(TZ='Asia/Seoul' date '+%Y' 2>/dev/null || date '+%Y')
  ch_now_m=$(TZ='Asia/Seoul' date '+%m' 2>/dev/null || date '+%m')
  ch_now_q=$(( (10#$ch_now_m - 1) / 3 ))
  ch_now_bucket=$(( 10#$ch_now_y * 4 + ch_now_q ))
  ch_last_date=$(grep -oE '<!-- ch-auto [0-9]{4}-[0-9]{2}-[0-9]{2} -->' "$CONTEXT_HEALTH_FILE" 2>/dev/null | tail -1 | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
  if [ -n "$ch_last_date" ]; then
    ch_last_y=$(echo "$ch_last_date" | cut -d'-' -f1)
    ch_last_m=$(echo "$ch_last_date" | cut -d'-' -f2)
    ch_last_q=$(( (10#$ch_last_m - 1) / 3 ))
    ch_last_bucket=$(( 10#$ch_last_y * 4 + ch_last_q ))
    [ "$ch_now_bucket" -le "$ch_last_bucket" ] && return 0
  fi

  # char 4 (codepoint · proxy)
  ch_parent=$(ch_count "$MOUNT_ROOT/CLAUDE.md")
  ch_master=$(ch_count "$MASTER_DIR/CLAUDE.md")
  CH_RULES="$MASTER_DIR/.claude/rules"
  ch_l0=$(ch_sum "$CH_RULES/safety-and-secrets.md" "$CH_RULES/anchor-list.md" "$CH_RULES/cross-repo-parallel-exec.md")
  ch_child_md=""
  for ch_c in GentlyBreath GentlyDay GentlyTable app-foundation; do
    if [ -f "$MOUNT_ROOT/$ch_c/CLAUDE.md" ]; then ch_child_md="$MOUNT_ROOT/$ch_c/CLAUDE.md"; break; fi
  done
  ch_child=$(ch_count "$ch_child_md")

  # stale_pointer(auto · file-link) · §-level anchor 검증 = manual
  ch_stale=$(stale_pointer_count "$CH_RULES")

  ch_now_kst=$(TZ='Asia/Seoul' date '+%Y-%m-%d %H:%M' 2>/dev/null || date '+%Y-%m-%d %H:%M')
  ch_now_date=$(TZ='Asia/Seoul' date '+%Y-%m-%d' 2>/dev/null || date '+%Y-%m-%d')
  ch_cyc=$(git -C "$MASTER_DIR" log -1 --format='%s' 2>/dev/null | grep -oE "$CYCLE_MARKER" | head -1)
  [ -z "$ch_cyc" ] && ch_cyc="(unmarked)"

  # append (= MODE=append 한정 · idempotent = 분기 guard) → §3.1 (행 = EOF 누적 · cycle-health-log.md 동일 패턴)
  if [ "$MODE" = "append" ]; then
    printf '| %s | %s | %s | %s | %s | %s | manual | manual | %s | <!-- ch-auto %s --> |\n' \
      "$ch_now_kst" "$ch_parent" "$ch_master" "$ch_l0" "$ch_child" "$ch_stale" "$ch_cyc" "$ch_now_date" \
      >> "$CONTEXT_HEALTH_FILE"
  fi

  # surface (= advisory · MODE != silent)
  if [ "$MODE" != "silent" ]; then
    echo "" >&2
    echo "[GSM-CONTEXT-HEALTH] context 건강 분기 측정 (= advisory · 판정 수동 · context-health-metrics.md §1·§3.1):" >&2
    echo "  항상로드 char(codepoint proxy≠token · band ASCII≈3.2~4 / Hangul≈1.0~2.2 ch/tok): parent_root ${ch_parent} · master ${ch_master} · L0_kernel ${ch_l0} · child ${ch_child}" >&2
    echo "  stale_pointer(auto · md-link + backtick .sh/.json/.md[master-owned dir] · 목표 0): ${ch_stale} (= scope-한정 신호 · non-backtick bare/자식-context docs/cross-repo(../)/§-level = 미검출 · 전역 dead-ref 부재 보증 X)" >&2
    echo "  conflicting_sot/buried_ratio = 수기 advisory(§2 갱신 · §-level 판정 자동 X)" >&2
    if [ "$MODE" = "append" ]; then
      echo "  → context-health-metrics.md §3.1 분기 trajectory append (${ch_now_y}Q$(( ch_now_q + 1 )))" >&2
    else
      echo "  → append 미실행 (= advisory · GSM_MEASURE_ENFORCE=append 로 분기 trajectory 기록)" >&2
    fi
    echo "" >&2
  fi
}

# === master CLAUDE.md §15 hot 재증식 advisory (= MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001 · 2026-06-10 확장) ===
# 본질: §15 hot entry 수 > trigger(10) 도달 시 cold 재이전 advisory 자동 surface (= 재증식 자동 감시).
#   - trigger 수치 SoT = .auto-memory/context-health-metrics.md §2 ("≥ ~10 도달 시 cold 재이전 trigger")
#   - cadence = 새 master cycle commit 감지 시 (= §15 entry append 발생 시점) + GSM_CONTEXT_HEALTH_FORCE=1 self-test
#   - warn-only · exit 0 보존 · 이전(demote) 절차 자체 = 수동 (= COLD-002 전례 · automation-policy.md
#     Transport=측정/surface 자동 + Inspection=판정·이전 수동 경계 정합)
S15_HOT_TRIGGER=10
run_s15_hot_check() {
  s15_md="$MASTER_DIR/CLAUDE.md"
  [ -f "$s15_md" ] || return 0
  # §15 표 data row 수 = "## 15." ~ 다음 "## " 사이 "| " 시작 행 - header 행("| cycle ID")
  s15_count=$(awk '/^## 15\./{f=1; next} /^## /{f=0} f && /^\| /{print}' "$s15_md" 2>/dev/null | grep -cv '^| cycle ID')
  [ -z "$s15_count" ] && s15_count=0
  if [ "$s15_count" -gt "$S15_HOT_TRIGGER" ] && [ "$MODE" != "silent" ]; then
    echo "" >&2
    echo "[GSM-S15-HOT] master CLAUDE.md §15 hot entry = ${s15_count} > ${S15_HOT_TRIGGER} (= cold 재이전 trigger · context-health-metrics.md §2):" >&2
    echo "  → cold 재이전 advisory (= COLD-002 전례 절차 · 무손실 verbatim · .auto-memory/master-cycle-history-COLD.md append + hot = 최근 5 + 본 cycle entry)" >&2
    echo "  → advisory only (= 자동 이전 X · 판정·이전 = master cycle 수동 · automation-policy.md Inspection)" >&2
    echo "" >&2
  fi
}

# FORCE = new-cycle 게이팅 무관 즉시 context-health 평가 (self-test/수동 분기) · 분기 guard 는 유지
if [ "$CH_FORCE" = "1" ]; then
  run_s15_hot_check
  run_context_health
  exit 0
fi

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

# §15 hot 재증식 advisory (= 새 cycle 감지 후 도달 = §15 append 시점 · MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001)
run_s15_hot_check

# context-health (= 새 cycle 감지 후 도달 · 분기 guard 통과 시만 측정/append · MASTER-CLI-GSM-CONTEXT-HEALTH-ABSORB-001)
run_context_health

exit 0
