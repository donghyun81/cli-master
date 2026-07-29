#!/usr/bin/env bash
# scripts/report-gen.sh — propagation 보고서 자동 생성
#
# 사용:
#   bash scripts/report-gen.sh <cycle-id> [--commit-msg "..."]
#
# 환경 변수:
#   PARENT_DIR    기본: ~/AndroidStudioProjects
#   MASTER_DIR    기본: $PARENT_DIR/claude-cli-master
#
# 동작:
#   1. propagation-reports/<cycle-id>/ 디렉터리 신설
#   2. REPORT.md (cycle 메타 + 자식 별 결과 + 다음 단계)
#   3. DIFF.md (master 의 cycle 변경 파일 sha before/after)
#   4. VERIFY.md (verify-sync.sh 결과 raw)
#
# 의존:
#   verify-sync.sh (sha 결과)
#   master 의 git log

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 전파 대상 SoT = repo-config.sh TARGET_REPOS (= 하드코딩 금지 · 2026-07-17 T6 재편 후
# 구 판은 동결 3(GB/GD/GT)을 표로 뽑아 실 전파 대상과 무관한 REPORT 를 냈다).
# shellcheck source=./repo-config.sh
. "$SCRIPT_DIR/repo-config.sh"

: "${PARENT_DIR:=$HOME/AndroidStudioProjects}"
: "${MASTER_DIR:=$PARENT_DIR/claude-cli-master}"

CYCLE_ID="${1:-}"
COMMIT_MSG=""

if [ -z "$CYCLE_ID" ]; then
  echo "[report-gen] ERROR: cycle-id 필수. 예: bash scripts/report-gen.sh C2-RULES-RESTRUCTURE-001-PROPAGATE" >&2
  exit 2
fi

shift || true
while [ $# -gt 0 ]; do
  case "$1" in
    --commit-msg) COMMIT_MSG="$2"; shift 2 ;;
    *) shift ;;
  esac
done

REPORT_DIR="$MASTER_DIR/propagation-reports/$CYCLE_ID"
mkdir -p "$REPORT_DIR"

cd "$MASTER_DIR"
TS=$(date '+%Y-%m-%dT%H:%M:%S%z')
MASTER_HEAD=$(git rev-parse --short HEAD 2>/dev/null || echo "(no-git)")

# === 1. REPORT.md ===
{
  echo "# $CYCLE_ID — Propagation Report"
  echo ""
  echo "> 자동 생성: $TS · master HEAD: $MASTER_HEAD"
  echo ""
  echo "---"
  echo ""
  echo "## 1. Cycle 메타"
  echo ""
  echo "- cycle ID: $CYCLE_ID"
  echo "- timestamp: $TS"
  echo "- master HEAD: $MASTER_HEAD"
  echo "- master commit msg:"
  echo "  \`\`\`"
  git log -1 --format=%B 2>/dev/null | sed 's/^/  /'
  echo "  \`\`\`"
  echo ""
  echo "## 2. 자식 repo HEAD (propagation 직후)"
  echo ""
  echo "| repo | HEAD | branch | dirty? |"
  echo "|---|---|---|---|"
  for r in $TARGET_REPOS; do
    if [ -d "$PARENT_DIR/$r/.git" ]; then
      H=$(git -C "$PARENT_DIR/$r" rev-parse --short HEAD 2>/dev/null)
      B=$(git -C "$PARENT_DIR/$r" rev-parse --abbrev-ref HEAD 2>/dev/null)
      D=$(git -C "$PARENT_DIR/$r" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
      if [ "$D" = "0" ]; then DIRTY="clean"; else DIRTY="$D files"; fi
      echo "| $r | $H | $B | $DIRTY |"
    else
      echo "| $r | (no-repo) | - | - |"
    fi
  done
  echo ""
  echo "## 3. cross-verify 결과"
  echo ""
  echo "\`VERIFY.md\` 첨부 참조."
  echo ""
  echo "## 4. 변경 파일 sha 비교"
  echo ""
  echo "\`DIFF.md\` 첨부 참조."
  echo ""
  echo "## 5. 다음 단계"
  echo ""
  echo "- 자식 repo 별 commit (master commit body 인용)"
  echo "- \`.auto-memory/propagation-status.md\` 자동 갱신 확인"
  echo "- 본 cycle 마감 시 master \`CLAUDE.md\` §15 표 추가"
  echo ""
} > "$REPORT_DIR/REPORT.md"

# === 2. DIFF.md ===
{
  echo "# $CYCLE_ID — Diff (master 변경 파일 sha)"
  echo ""
  echo "> master HEAD ($MASTER_HEAD) 의 직전 commit 대비 변경된 파일 list."
  echo ""
  if git rev-parse HEAD~1 >/dev/null 2>&1; then
    echo "## 변경 파일"
    echo ""
    echo "\`\`\`"
    git diff --name-status HEAD~1 HEAD 2>/dev/null
    echo "\`\`\`"
    echo ""
    echo "## 신규 sha (HEAD)"
    echo ""
    echo "| 파일 | sha (12자) |"
    echo "|---|---|"
    git diff --name-only HEAD~1 HEAD 2>/dev/null | while read -r f; do
      [ -f "$f" ] || continue
      SHA=$(shasum -a 256 "$f" | awk '{print substr($1,1,12)}')
      echo "| $f | \`$SHA\` |"
    done
  else
    echo "(initial commit · diff 비교 대상 없음)"
  fi
  echo ""
} > "$REPORT_DIR/DIFF.md"

# === 3. VERIFY.md (verify-sync 결과 첨부) ===
{
  echo "# $CYCLE_ID — Verify-Sync Output"
  echo ""
  echo "> \`bash scripts/verify-sync.sh\` 의 raw output (자동 생성: $TS)."
  echo ""
  echo "\`\`\`"
  bash "$MASTER_DIR/scripts/verify-sync.sh" --no-update 2>&1 || true
  echo "\`\`\`"
  echo ""
} > "$REPORT_DIR/VERIFY.md"

echo "═══════════════════════════════════════════════════════"
echo "[report-gen] 보고서 자동 생성 박음"
echo "  $REPORT_DIR/REPORT.md"
echo "  $REPORT_DIR/DIFF.md"
echo "  $REPORT_DIR/VERIFY.md"
echo "═══════════════════════════════════════════════════════"

exit 0
