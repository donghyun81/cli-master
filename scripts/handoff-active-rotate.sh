#!/usr/bin/env bash
# handoff-active-rotate.sh — cowork-handoff-active.md size 기반 rotation
# 신설: MASTER-CLI-POSTCYCLE-AUTOMATION-001 Phase B (사후 단계 drift ④ · append-only 비대 mitigation).
#
# 본질:
#   cowork-handoff-active.md (= 부모 root · append-only 진척 file) 가 threshold 초과 시
#   전체 본문을 archive/<YYYY-MM>/ 로 mv (= 삭제 0 · 본문 보존) + 신 active 재생성
#   (= 헤더 + rotation pointer + 빈 append 영역). architecture.md §5 baseline 인계 정합
#   (= 신 active 는 archive file §A-CURRENT 정독 pointer 로 baseline 인계 · §B/§C reset).
#
# 동작 위치: REPO_ROOT = SCRIPT_DIR/.. (archiver 와 동일 derivation).
#   - 부모 root/scripts/ 에서 실행 → REPO_ROOT = 부모 root → cowork-handoff-active.md 대상.
#   - master/scripts/ (또는 자식) 에서 실행 → cowork-handoff-active.md 부재 → no-op exit 0.
#
# 무접촉: cowork-handoff-architecture.md (= 영구 SoT) 절대 무접촉.
# mv only — rm 사용 X (restore.sh 복원 가능 · working-file-lifecycle.md §8 정합).
#
# threshold (env: ROTATE_THRESHOLD_BYTES · default 262144 = 256 KB):
#   size ≤ threshold → no-op exit 0.
#   size > threshold → rotate.
#
# self-test: bash scripts/handoff-active-rotate.sh        (부모 root 외 = no-op)
#            ROTATE_THRESHOLD_BYTES=999999999 bash ...     (강제 no-op 확인)
#
# macOS bash 3.x 호환 (associative array X / ${var,,} X). 항상 exit 0 외 = 환경 오류만.

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="$REPO_ROOT/cowork-handoff-active.md"
ARCHIVE_DIR="$REPO_ROOT/archive"
INDEX_FILE="$ARCHIVE_DIR/INDEX.md"
LOG_DIR="$REPO_ROOT/.ai/hooks"
LOG_FILE="$LOG_DIR/handoff-active-rotate.log"
MONTH_DIR=$(TZ=Asia/Seoul date '+%Y-%m')
NOW_KST=$(TZ=Asia/Seoul date '+%Y-%m-%d %H:%M')
STAMP=$(TZ=Asia/Seoul date '+%Y%m%d-%H%M%S')

: "${ROTATE_THRESHOLD_BYTES:=262144}"   # 256 KB default

log() { mkdir -p "$LOG_DIR" 2>/dev/null; echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"; }

# active file 부재 → no-op (= master / 자식 repo 에서 inert)
[ -f "$TARGET" ] || { log "no-op: $TARGET 부재 (REPO_ROOT=$REPO_ROOT)"; exit 0; }

SIZE=$(stat -f %z "$TARGET" 2>/dev/null || stat -c %s "$TARGET" 2>/dev/null || echo 0)

# threshold 이하 → no-op
if [ "$SIZE" -le "$ROTATE_THRESHOLD_BYTES" ]; then
  log "no-op: size $SIZE ≤ threshold $ROTATE_THRESHOLD_BYTES"
  exit 0
fi

# === rotation ===
mkdir -p "$ARCHIVE_DIR/$MONTH_DIR"
DEST_NAME="cowork-handoff-active-${STAMP}.md"
DEST="$ARCHIVE_DIR/$MONTH_DIR/$DEST_NAME"
DEST_REL="archive/$MONTH_DIR/$DEST_NAME"

# INDEX.md 초기화 (없으면 · archiver 와 동일 5-column 형식)
if [ ! -f "$INDEX_FILE" ]; then
  cat > "$INDEX_FILE" << 'IDXEOF'
# Archive INDEX

| 시각 KST | 파일 | 출처 폴더 | 마감 cycle | trigger 종류 |
|---|---|---|---|---|
IDXEOF
fi

# 본문 전체 보존 mv (= 삭제 0)
mv "$TARGET" "$DEST"

# 신 active 재생성: (1) 직전 헤더 (archived copy 의 첫 '---' 까지) + (2) §0 rotation pointer + (3) 빈 append 영역
awk '{print} /^---$/{exit}' "$DEST" > "$TARGET"
{
  printf '\n'
  printf '## §0. Rotation pointer (= %s · MASTER-CLI-POSTCYCLE-AUTOMATION-001 Phase B)\n\n' "$NOW_KST"
  printf -- '- 직전 active 전체 본문 (= %s bytes · §A baseline + §B chat entry 누적 + §C 활성 trail 등) → `%s` 이동 (= 본문 삭제 0 · mv only · `scripts/restore.sh` 복원 가능).\n' "$SIZE" "$DEST_REL"
  printf -- '- 직전 §A-CURRENT baseline 인계 = 위 archive file 측 §A-CURRENT 정독 (= `cowork-handoff-architecture.md` §5 baseline 인계 정합).\n'
  printf -- '- 본 file = rotation 후 신 append 영역 (= §B chat entry / §C 활성 trail reset · architecture.md §5 정합 · `cowork-handoff-architecture.md` 무접촉).\n'
  printf '\n---\n\n'
  printf '<!-- append below (= 매 chat 마감 시 §A baseline 갱신 + §B entry append · architecture.md §3/§4 절차) -->\n'
} >> "$TARGET"

# INDEX.md 5-column append
REPO_LABEL=$(basename "$REPO_ROOT")
[ "$REPO_LABEL" = "AndroidStudioProjects" ] && REPO_LABEL="(parent root)"
echo "| $NOW_KST | $DEST_NAME | $REPO_LABEL | MASTER-CLI-POSTCYCLE-AUTOMATION-001 | size rotation |" >> "$INDEX_FILE"

log "rotated: $TARGET ($SIZE bytes) -> $DEST + 신 active 재생성"
echo "[handoff-active-rotate] rotated cowork-handoff-active.md ($SIZE bytes) -> $DEST_REL (신 active 재생성)" >&2
exit 0
