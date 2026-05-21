#!/usr/bin/env bash
# scripts/verify-sync.sh — 3-repo cli infra + 보호 파일 sha 동기 검증
#
# 사용:
#   bash scripts/verify-sync.sh                         # 전체 검증 + propagation-status.md 자동 갱신
#   bash scripts/verify-sync.sh --quick                 # 보호 파일 4 종 + 핵심 cli infra 만
#   bash scripts/verify-sync.sh --no-update             # 검증만 (propagation-status.md 갱신 X)
#   bash scripts/verify-sync.sh --target GB             # 특정 자식 repo 만
#
# 환경 변수:
#   PARENT_DIR     기본: ~/AndroidStudioProjects
#   MASTER_DIR     기본: $PARENT_DIR/claude-cli-master
#   TARGET_REPOS   기본: "GentlyBreath GentlyDay GentlyTable"
#
# 동작:
#   1. master 의 모든 cli infra + 보호 파일 sha 계산
#   2. 각 자식 repo 의 동일 path sha 비교
#   3. .auto-memory/propagation-status.md 자동 갱신 (default)
#   4. drift 발견 시 stderr + exit 1
#
# Exit code:
#   0 = 모두 일치 (PASS)
#   1 = drift 발견
#   2 = 환경 오류 (master 없음 / 자식 repo 없음 등)

set -uo pipefail

# === 환경 변수 default (single SoT · MASTER-REPO-CONFIG-SOT-001) ===
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=./repo-config.sh
. "$SCRIPT_DIR/repo-config.sh"

QUICK=0
NO_UPDATE=0
SINGLE_TARGET=""

SKIP_DAEMON_CHECK=0

while [ $# -gt 0 ]; do
  case "$1" in
    --quick) QUICK=1; shift ;;
    --no-update) NO_UPDATE=1; shift ;;
    --target) SINGLE_TARGET="$2"; shift 2 ;;
    --skip-daemon-check) SKIP_DAEMON_CHECK=1; shift ;;
    --help|-h) sed -n '1,30p' "$0"; exit 0 ;;
    *) echo "[verify-sync] unknown flag: $1" >&2; exit 2 ;;
  esac
done

if [ ! -d "$MASTER_DIR" ]; then
  echo "[verify-sync] ERROR: master 부재: $MASTER_DIR" >&2
  exit 2
fi

# === C13: launchd daemon 자동 진단 (git lock 영구 mitigation 활성 검증) ===
# - daemon = com.coin.git-lock-cleaner (C10 신설)
# - macOS 만 적용 (다른 OS = skip)
# - --skip-daemon-check flag 또는 LAUNCHCTL 부재 = skip
if [ "$SKIP_DAEMON_CHECK" = 0 ] && command -v launchctl >/dev/null 2>&1; then
  DAEMON_LABEL="com.coin.git-lock-cleaner"
  PLIST_PATH="$HOME/Library/LaunchAgents/$DAEMON_LABEL.plist"
  DAEMON_LOG="$HOME/Library/Logs/git-lock-daemon.log"

  if ! launchctl list | grep -q "$DAEMON_LABEL"; then
    echo "[verify-sync] ⚠ git-lock daemon 미활성 (C12 사고 패턴 재발 위험)"
    if [ -f "$PLIST_PATH" ]; then
      echo "  plist 존재하나 load 안 됨 — 수정: launchctl load $PLIST_PATH"
    else
      echo "  plist 부재 — 수정: bash $MASTER_DIR/scripts/install-git-lock-daemon.sh"
    fi
    echo "  (--skip-daemon-check 로 본 진단 제외 가능)"
    echo ""
  else
    # daemon 활성 + log mtime 체크 (1시간 이상 미작동 = stuck 의심)
    if [ -f "$DAEMON_LOG" ]; then
      LOG_MTIME=$(stat -f %m "$DAEMON_LOG" 2>/dev/null || stat -c %Y "$DAEMON_LOG" 2>/dev/null || echo 0)
      NOW=$(date +%s)
      AGE=$((NOW - LOG_MTIME))
      if [ "$AGE" -gt 3600 ]; then
        echo "[verify-sync] ⚠ git-lock daemon log mtime > 1시간 (stuck 의심 · age=${AGE}s)"
        echo "  진단: tail $DAEMON_LOG / 재 load: launchctl unload $PLIST_PATH && launchctl load $PLIST_PATH"
        echo ""
      fi
    fi
  fi
fi

cd "$MASTER_DIR"

# === 검증 대상 파일 list ===
PROTECTED=(
  docs/schemas/ui-spec.schema.json
  .claude/rules/pencil-uiux-workflow.md
  docs/design/pencil-sot-policy.md
  .claude/rules/uiux-sot-refresh.md
  docs/design/design-sot-policy.md
)
CORE_CLI=(
  .claude/settings.json
  .claude/rules/workflow-core.md
  .claude/rules/cycle-discipline.md
  .claude/rules/pencil-automation.md
  .claude/rules/reporting.md
  .claude/rules/routing-and-delegation.md
  .claude/rules/deferred-domains.md
  .claude/rules/code-principles.md
  .claude/rules/design-to-code-sync.md
  .claude/rules/ux-laws.md
  docs/agent/architecture/COMMON_ARCHITECTURE.md
  docs/agent/architecture/TDD_WORKFLOW.md
  docs/agent/architecture/MODEL_SEPARATION.md
  docs/agent/architecture/SSOT_PRINCIPLES.md
  docs/agent/process/COMMIT_CONVENTION.md
  scripts/agent/frontmatter-grep.sh
  .editorconfig
  .mcp.json
  gradle.properties
)

if [ "$QUICK" = 1 ]; then
  CHECK_FILES=("${PROTECTED[@]}" "${CORE_CLI[@]}")
else
  CHECK_FILES=()
  while IFS= read -r f; do
    CHECK_FILES+=("$f")
  done < <(find .claude docs scripts/agent .ai/promptfit .ai/uiux-sot/refresh .github -type f \
    ! -name '.DS_Store' \
    ! -name 'settings.local.json' \
    ! -path './.git/*' \
    ! -path 'docs/release-readiness/*' 2>/dev/null | sort)
  # C5 박힘: root 공통 파일 5종 명시 추가
  for rf in .editorconfig .mcp.json gradle.properties gradlew gradlew.bat; do
    [ -f "$rf" ] && CHECK_FILES+=("$rf")
  done
fi

# === target list ===
if [ -n "$SINGLE_TARGET" ]; then
  case "$SINGLE_TARGET" in
    GB) TARGET_LIST="GentlyBreath" ;;
    GD) TARGET_LIST="GentlyDay" ;;
    GT) TARGET_LIST="GentlyTable" ;;
    FND) TARGET_LIST="app-foundation" ;;
    *)  TARGET_LIST="$SINGLE_TARGET" ;;
  esac
else
  TARGET_LIST="$TARGET_REPOS"
fi

echo "═══════════════════════════════════════════════════════"
echo "[verify-sync] 3-repo sha 동기 검증"
echo "  master:  $MASTER_DIR"
echo "  targets: $(echo $TARGET_LIST | xargs)"
echo "  files:   ${#CHECK_FILES[@]}$([ "$QUICK" = 1 ] && echo ' (quick)' || echo ' (전체)')"
echo "═══════════════════════════════════════════════════════"

# === sha 계산 + 비교 ===
DRIFT_COUNT=0
PASS_COUNT=0
MISS_COUNT=0
DRIFT_DETAILS=""

for f in "${CHECK_FILES[@]}"; do
  MASTER_SHA=$(shasum -a 256 "$MASTER_DIR/$f" 2>/dev/null | awk '{print substr($1,1,12)}')
  if [ -z "$MASTER_SHA" ]; then
    continue
  fi

  ROW_RESULT="$f  master=$MASTER_SHA"
  ROW_DRIFT=0
  ROW_MISS=0

  for repo in $TARGET_LIST; do
    REPO_DIR="$PARENT_DIR/$repo"
    if [ ! -d "$REPO_DIR" ]; then
      ROW_RESULT="$ROW_RESULT  $repo=NO_REPO"
      ROW_MISS=$((ROW_MISS+1))
      continue
    fi

    DST_SHA=$(shasum -a 256 "$REPO_DIR/$f" 2>/dev/null | awk '{print substr($1,1,12)}')
    if [ -z "$DST_SHA" ]; then
      ROW_RESULT="$ROW_RESULT  $repo=MISS"
      ROW_MISS=$((ROW_MISS+1))
    elif [ "$DST_SHA" = "$MASTER_SHA" ]; then
      ROW_RESULT="$ROW_RESULT  $repo=✓"
    else
      ROW_RESULT="$ROW_RESULT  $repo=$DST_SHA(✗)"
      ROW_DRIFT=$((ROW_DRIFT+1))
    fi
  done

  if [ "$ROW_DRIFT" -gt 0 ] || [ "$ROW_MISS" -gt 0 ]; then
    DRIFT_DETAILS="${DRIFT_DETAILS}${ROW_RESULT}\n"
    DRIFT_COUNT=$((DRIFT_COUNT+ROW_DRIFT))
    MISS_COUNT=$((MISS_COUNT+ROW_MISS))
    echo "  ✗ $ROW_RESULT" >&2
  else
    PASS_COUNT=$((PASS_COUNT+1))
  fi
done

echo ""
echo "═══════════════════════════════════════════════════════"
echo "[verify-sync] 요약"
echo "  PASS:  $PASS_COUNT 파일"
echo "  DRIFT: $DRIFT_COUNT (자식 sha ≠ master)"
echo "  MISS:  $MISS_COUNT (자식 부재 또는 repo 부재)"
echo "═══════════════════════════════════════════════════════"

# === propagation-status.md 자동 갱신 ===
if [ "$NO_UPDATE" = 0 ] && [ "$QUICK" = 0 ]; then
  STATUS_FILE="$MASTER_DIR/.auto-memory/propagation-status.md"
  TS=$(date '+%Y-%m-%dT%H:%M:%S%z')

  # 기존 파일 백업 후 자동 검증 timestamp + 결과 박음
  if [ -f "$STATUS_FILE" ]; then
    # 마지막 "Last verify-sync" 섹션 찾아서 갱신, 없으면 append
    if grep -q "^## Last verify-sync" "$STATUS_FILE"; then
      # in-place edit (sed)
      sed -i.bak "/^## Last verify-sync/,$ d" "$STATUS_FILE"
      rm -f "${STATUS_FILE}.bak" 2>/dev/null
    fi
    {
      echo ""
      echo "## Last verify-sync"
      echo ""
      echo "- timestamp: $TS"
      echo "- pass: $PASS_COUNT"
      echo "- drift: $DRIFT_COUNT"
      echo "- miss: $MISS_COUNT"
      echo "- exit: $([ $((DRIFT_COUNT+MISS_COUNT)) -eq 0 ] && echo 0 || echo 1)"
      if [ -n "$DRIFT_DETAILS" ]; then
        echo ""
        echo "### Drift 상세"
        echo ""
        printf "%b" "$DRIFT_DETAILS" | sed 's/^/- /'
      fi
    } >> "$STATUS_FILE"
    echo "[verify-sync] propagation-status.md 갱신 박음"
  fi
fi

if [ $((DRIFT_COUNT+MISS_COUNT)) -gt 0 ]; then
  echo "[verify-sync] FAIL — drift / miss 발견. propagation cycle 권장." >&2
  exit 1
fi
echo "[verify-sync] PASS — 모든 sha 일치"
exit 0
