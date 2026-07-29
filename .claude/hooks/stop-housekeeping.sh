#!/bin/bash
# stop-housekeeping.sh — 사후 단계 housekeeping (Stop hook · non-blocking · 항상 exit 0)
# 신설: MASTER-CLI-POSTCYCLE-AUTOMATION-001 Phase D
# 관련: cycle-discipline.md §19 (반복 패턴 자기관측) · working-file-lifecycle.md ·
#       stop-gate.sh (blocking 영역 = 무접촉 · 본 hook 은 항상 exit 0 = 완료 차단 X)
#
# 동작 (모두 silent-success · 이상 시에만 stderr WARN):
#   1. working-file-archiver.sh sweep — 현 repo 한정 · [ -x ] guard (= archiver 부재 repo = no-op · 예: app-foundation)
#   2. 상태문서 freshness — master .auto-memory 2 status doc 부재참조 grep → WARN (read-only)
#   3. cowork-handoff-active.md size — mount root · threshold 초과 → WARN + rotate 권유 (read-only · 자동 rotate X)
#
# Exit: 항상 exit 0 (= stop-gate.sh 의 blocking 영역 breakage X · non-blocking advisory 철학)
# mode (env HOUSEKEEPING_ENFORCE): warn (default · WARN stderr 출력) / silent (= 출력 0 · 행동은 유지)
# self-test: bash .claude/hooks/stop-housekeeping.sh
# macOS bash 3.x 호환 (associative array X / ${var,,} X)

set -u

MODE="${HOUSEKEEPING_ENFORCE:-warn}"
: "${HANDOFF_SIZE_WARN_BYTES:=262144}"   # 256 KB (= handoff-active-rotate.sh threshold 정합)

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")

# mount root 탐지 (= claude-cli-master 를 포함하는 부모 영역 · 부모 root 진입 + 자식 repo 진입 모두 cover)
if [ -d "$REPO_ROOT/claude-cli-master" ]; then
  MOUNT_ROOT="$REPO_ROOT"
elif [ -d "$REPO_ROOT/../claude-cli-master" ]; then
  MOUNT_ROOT="$(cd "$REPO_ROOT/.." && pwd)"
else
  MOUNT_ROOT="$REPO_ROOT"
fi
MASTER_DIR="$MOUNT_ROOT/claude-cli-master"

WARN=""

# --- step 1: working-file-archiver.sh sweep (현 repo · [ -x ] guard) ---
# archiver 부재 repo (= app-foundation 등) = sweep step no-op (= guard skip).
if [ -x "$REPO_ROOT/scripts/working-file-archiver.sh" ]; then
  "$REPO_ROOT/scripts/working-file-archiver.sh" >/dev/null 2>&1 || true
fi

# --- step 2: 상태문서 freshness (master 2 status doc · read-only 부재참조 grep) ---
for doc in "$MASTER_DIR/.auto-memory/protected-file-hashes.md" "$MASTER_DIR/.auto-memory/propagation-status.md"; do
  [ -f "$doc" ] || continue
  miss=0
  for path in $(grep -oE '`(\.claude|docs|scripts|\.auto-memory|\.ai)/[A-Za-z0-9._/-]+\.(md|json|sh|sql|toml|kt|py)`' "$doc" 2>/dev/null | tr -d '`' | sort -u); do
    [ -e "$MASTER_DIR/$path" ] || miss=$((miss + 1))
  done
  [ "$miss" -gt 0 ] && WARN="${WARN}  - $(basename "$doc"): 부재 참조 $miss 건 (= 'bash scripts/verify-sync.sh --no-update' 로 상세 + 정정)\n"
done

# --- step 3: cowork-handoff-active.md size (mount root · read-only) ---
HANDOFF="$MOUNT_ROOT/cowork-handoff-active.md"
if [ -f "$HANDOFF" ]; then
  hsize=$(stat -f %z "$HANDOFF" 2>/dev/null || stat -c %s "$HANDOFF" 2>/dev/null || echo 0)
  if [ "$hsize" -gt "$HANDOFF_SIZE_WARN_BYTES" ]; then
    WARN="${WARN}  - cowork-handoff-active.md ${hsize}B > ${HANDOFF_SIZE_WARN_BYTES}B → rotate 권유: 'bash scripts/handoff-active-rotate.sh' (= 본문 보존 mv · 자동 rotate X)\n"
  fi
fi

# --- 출력 (mode != silent · WARN 발화 시에만) ---
if [ -n "$WARN" ] && [ "$MODE" != "silent" ]; then
  echo "" >&2
  echo "[STOP-HOUSEKEEPING] 사후 단계 점검 (= non-blocking 권유):" >&2
  printf "%b" "$WARN" >&2
  echo "  규칙: working-file-lifecycle.md · cycle-discipline.md §19 (HOUSEKEEPING_ENFORCE=silent 로 음소거)" >&2
  echo "" >&2
fi

exit 0
