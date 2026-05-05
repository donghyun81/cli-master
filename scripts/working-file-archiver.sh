#!/usr/bin/env bash
# working-file-archiver.sh — mtime fallback + REVIEW.md PASS 매칭 sweep
# bash 3.x 호환. mv only. 5 위치 운영 — 자기 위치 자동 인식.

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ARCHIVE_DIR="$REPO_ROOT/archive"
INDEX_FILE="$ARCHIVE_DIR/INDEX.md"
LOG_DIR="$REPO_ROOT/.ai/hooks"
LOG_FILE="$LOG_DIR/working-file-archiver.log"
NOW_KST=$(TZ=Asia/Seoul date '+%Y-%m-%d %H:%M')
MONTH_DIR=$(TZ=Asia/Seoul date '+%Y-%m')
MTIME_THRESHOLD_DAYS=7

mkdir -p "$ARCHIVE_DIR/$MONTH_DIR"
mkdir -p "$LOG_DIR"

# INDEX.md 초기화 (없으면)
if [ ! -f "$INDEX_FILE" ]; then
  cat > "$INDEX_FILE" << 'IDXEOF'
# Archive INDEX

| 시각 KST | 파일 | 출처 폴더 | 마감 cycle | trigger 종류 |
|---|---|---|---|---|
IDXEOF
fi

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# repo 표시 이름 (출처 폴더 칸용)
REPO_LABEL=$(basename "$REPO_ROOT")
if [ "$REPO_LABEL" = "AndroidStudioProjects" ]; then
  REPO_LABEL="(parent root)"
fi

# frontmatter 3 키 추출
extract_frontmatter() {
  local file="$1"
  local key="$2"
  awk -v key="$key" '
    /^---$/ { fm = !fm; next }
    fm && $0 ~ "^"key":" {
      sub("^"key":[[:space:]]*", "")
      print
      exit
    }
  ' "$file"
}

# REVIEW.md PASS 매칭 (정리trigger 의 task ID 검색)
check_review_pass() {
  local task_id="$1"
  if [ -z "$task_id" ]; then return 1; fi
  local review_file="$REPO_ROOT/.ai/reports/$task_id/REVIEW.md"
  if [ -f "$review_file" ]; then
    grep -q "^## .*PASS" "$review_file" && return 0
  fi
  return 1
}

# mtime fallback (epoch 비교)
check_mtime_old() {
  local file="$1"
  local file_epoch=$(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null)
  local now_epoch=$(date +%s)
  local age_days=$(( (now_epoch - file_epoch) / 86400 ))
  [ "$age_days" -ge "$MTIME_THRESHOLD_DAYS" ]
}

# archive 1 파일
archive_one() {
  local src="$1"
  local rel_name=$(basename "$src")
  local trigger="$2"
  local cycle_id="$3"
  local dest="$ARCHIVE_DIR/$MONTH_DIR/$rel_name"

  if [ -e "$dest" ]; then
    # 충돌 시 timestamp suffix
    dest="$ARCHIVE_DIR/$MONTH_DIR/${rel_name%.md}-$(date +%H%M%S).md"
  fi

  mv "$src" "$dest"
  echo "| $NOW_KST | $rel_name | $REPO_LABEL | $cycle_id | $trigger |" >> "$INDEX_FILE"
  log "archived: $src -> $dest (trigger=$trigger cycle=$cycle_id)"
}

# 후보 파일 sweep
sweep_candidates() {
  # 부모 root / repo root 의 working file
  for pattern in "cycle-prompt-*.md" "cc-paste-*.md" "*_addendum*.md" "*-addendum-*.md" "*.bak"; do
    for f in "$REPO_ROOT"/$pattern; do
      [ -e "$f" ] || continue
      [ -f "$f" ] || continue
      process_candidate "$f"
    done
  done

  # .ai/prompts/*.md (자식 repo 만 — 부모 root .ai 는 다른 영역)
  if [ -d "$REPO_ROOT/.ai/prompts" ] && [ "$REPO_LABEL" != "(parent root)" ]; then
    for f in "$REPO_ROOT"/.ai/prompts/*.md; do
      [ -e "$f" ] || continue
      [ -f "$f" ] || continue
      process_candidate "$f"
    done
  fi
}

process_candidate() {
  local file="$1"
  local cleanup_trigger=$(extract_frontmatter "$file" "정리trigger")
  local task_id=$(echo "$cleanup_trigger" | grep -oE '[A-Z]+-[A-Z0-9-]+-[0-9]+' | head -1)
  local cycle_id="${task_id:-unknown}"

  # (b) REVIEW.md PASS 매칭 우선
  if check_review_pass "$task_id"; then
    archive_one "$file" "REVIEW.md PASS" "$cycle_id"
    return
  fi

  # (a) mtime fallback (frontmatter 3 키 부재 또는 mtime 경과)
  if check_mtime_old "$file"; then
    archive_one "$file" "mtime 경과" "$cycle_id"
    return
  fi

  log "skip: $file (조건 불일치)"
}

log "==== sweep 시작 (REPO=$REPO_LABEL) ===="
sweep_candidates
log "==== sweep 종료 ===="
