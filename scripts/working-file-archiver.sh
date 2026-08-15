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

# 영구 제외 (= 패턴 매칭돼도 archive X · working-file-lifecycle.md §1 제외 정합)
#   - cowork-handoff-architecture.md = 영구 SoT
#   - cowork-handoff-active.md       = append SoT (handoff-active-rotate.sh 관할)
#   - CLAUDE.md / README.md / .gitignore = repo-specific 또는 보호
is_excluded() {
  case "$(basename "$1")" in
    cowork-handoff-architecture.md|cowork-handoff-active.md|CLAUDE.md|README.md|.gitignore) return 0 ;;
  esac
  return 1
}

# REVIEW.md PASS 판정 helper (= legacy inline heading + 표준 '## Verdict' 다음 줄 양식 둘 다 cover)
review_says_pass() {
  local rf="$1"
  [ -f "$rf" ] || return 1
  # (a) legacy: heading 줄 안 PASS (예: '## ... PASS')
  grep -qE '^##.*PASS' "$rf" && return 0
  # (b) 표준 (reporting.md §7): '## Verdict' 다음 첫 비빈 줄 = PASS
  awk '/^##[[:space:]]*Verdict/{v=1; next} v && NF {print; exit}' "$rf" | grep -qE '^PASS' && return 0
  return 1
}

# REVIEW.md / REPORT.md PASS 매칭 (= 정리trigger 의 task ID 검색 · repo-local + sibling repo lookup)
#   sibling lookup = mount root 아래 git repo 별 .ai/reports/ 검색 (= 부모 root sweep 시
#   master-cycle cc-paste 의 REVIEW(master repo 소재)도 PASS trigger 매칭 가능).
#
#   ★REPORT.md 인정 = MASTER-LIFECYCLE-4ACTIVE-REALIGN-001 (2026-08-15).
#     근인 = master cycle 산출물은 `REPORT.md` 뿐 (= master `CLAUDE.md §11` · 자식 cycle 만 REVIEW.md)
#     → REVIEW.md 만 조회하던 구 판에서 master-cycle working file 의 조기-archive 경로가 사문화
#       (= mtime 7 일 fallback 만 남아 cc-paste 가 최대 7 일 잔존).
#     ★넓힌 것은 **인정 file 집합 1 개뿐**: task ID 요건(= 아래 -z 조기 return)과
#       PASS 판정(= review_says_pass 무접촉) 은 무변 — 마감 판정의 그 외 요건 불변.
REPORT_BASENAMES="REVIEW.md REPORT.md"
MATCH_BASENAME=""   # 매칭된 판정 file 명 (= INDEX trigger 칸 표기용 · set -u 대비 초기화)

check_review_pass() {
  local task_id="$1"
  [ -z "$task_id" ] && return 1
  local b d
  # (1) repo-local
  for b in $REPORT_BASENAMES; do
    review_says_pass "$REPO_ROOT/.ai/reports/$task_id/$b" && { MATCH_BASENAME="$b"; return 0; }
  done
  # (2) sibling repo lookup (mount-root 인지)
  local mount_root="$REPO_ROOT"
  if [ ! -d "$REPO_ROOT/claude-cli-master" ] && [ -d "$REPO_ROOT/../claude-cli-master" ]; then
    mount_root="$(cd "$REPO_ROOT/.." && pwd)"
  fi
  for d in "$mount_root"/*/; do
    [ -d "${d}.git" ] || continue
    for b in $REPORT_BASENAMES; do
      review_says_pass "${d}.ai/reports/$task_id/$b" && { MATCH_BASENAME="$b"; return 0; }
    done
  done
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
  #   기존 5 패턴 + 신 4 패턴 (cowork-handoff-*ENTRY* / cowork-chat-entry-* / ENTRY-PROMPT-* / cc-audit-*)
  #   ※ cowork-handoff-active.md / cowork-handoff-architecture.md 는 *ENTRY* 패턴 비매칭 + is_excluded 이중 방어
  for pattern in "cycle-prompt-*.md" "cc-paste-*.md" "*_addendum*.md" "*-addendum-*.md" "*.bak" \
                 "cowork-handoff-*ENTRY*.md" "cowork-chat-entry-*.md" "ENTRY-PROMPT-*.md" "cc-audit-*.md"; do
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
  if is_excluded "$file"; then
    log "skip(excluded): $file"
    return
  fi
  local cleanup_trigger=$(extract_frontmatter "$file" "정리trigger")
  local task_id=$(echo "$cleanup_trigger" | grep -oE '[A-Z]+-[A-Z0-9-]+-[0-9]+' | head -1)
  local cycle_id="${task_id:-unknown}"

  # (b) REVIEW.md / REPORT.md PASS 매칭 우선
  MATCH_BASENAME=""
  if check_review_pass "$task_id"; then
    archive_one "$file" "${MATCH_BASENAME:-REVIEW.md} PASS" "$cycle_id"
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
