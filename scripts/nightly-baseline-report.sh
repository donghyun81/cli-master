#!/usr/bin/env bash
# scripts/nightly-baseline-report.sh — 매일 04:00 KST launchd 야간 잡 본체
#
# 목적:
#   매 Cowork chat 진입 시 수동으로 하던 §D/§20 baseline 조사를 야간 자동화로 대체.
#   사람이 아침에 1 분 안에 읽는 markdown 리포트를 `.ai/nightly-baseline/<date>.md` 에 출력.
#
# Cycle: MASTER-NIGHTLY-BASELINE-CRON-001 (2026-05-14)
#
# 호출:
#   bash $HOME/AndroidStudioProjects/claude-cli-master/scripts/nightly-baseline-report.sh
#
# scope:
#   - 단일 repo (claude-cli-master) · 전파 자식 3 (app-foundation/toward-product-docs/Selfward · repo-config SoT) read-only.
#   - 출력 file 외 쓰기 X (= 보호 파일 / cli infra / 자식 repo 무접촉 의무).
#
# 산출물:
#   $MASTER_DIR/.ai/nightly-baseline/<date>.md  — 일자 리포트
#   $MASTER_DIR/.ai/nightly-baseline/latest.md  — 가장 최근 리포트 copy
#   $MASTER_DIR/.ai/nightly-baseline/nightly.log — 1 줄 append (timestamp + exit code)

set -uo pipefail

# === 절대경로 setup (launchd 환경 PATH 빈약 대비) ===
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=./repo-config.sh
. "$SCRIPT_DIR/repo-config.sh"

# claude binary resolve (nvm path 동적 + fallback)
resolve_claude() {
  local candidate
  candidate="$(command -v claude 2>/dev/null || true)"
  if [ -z "$candidate" ]; then
    local found
    found="$(ls -1 "$HOME"/.nvm/versions/node/*/bin/claude 2>/dev/null | tail -1)"
    if [ -n "$found" ] && [ -x "$found" ]; then
      candidate="$found"
    fi
  fi
  if [ -z "$candidate" ]; then
    for p in /opt/homebrew/bin/claude /usr/local/bin/claude "$HOME/.local/bin/claude"; do
      [ -x "$p" ] && candidate="$p" && break
    done
  fi
  echo "$candidate"
}
CLAUDE_BIN="$(resolve_claude)"

NIGHTLY_DIR="$MASTER_DIR/.ai/nightly-baseline"
mkdir -p "$NIGHTLY_DIR"

DATE_ISO="$(date '+%Y-%m-%d')"
TS_KST="$(TZ=Asia/Seoul date '+%Y-%m-%d %H:%M %Z')"
TS_UTC="$(TZ=UTC date '+%Y-%m-%dT%H:%M:%SZ')"
OUT_FILE="$NIGHTLY_DIR/${DATE_ISO}.md"
LATEST_FILE="$NIGHTLY_DIR/latest.md"
LOG_FILE="$NIGHTLY_DIR/nightly.log"

log_append() {
  echo "[$TS_UTC] $*" >> "$LOG_FILE"
}

log_append "start · claude_bin=${CLAUDE_BIN:-(부재)}"

REPOS_ALL="claude-cli-master $TARGET_REPOS"

# === 측정 A — 4-active HEAD ===
read_head() {
  local repo_dir="$1"
  if [ -d "$repo_dir/.git" ]; then
    (cd "$repo_dir" && git rev-parse HEAD 2>/dev/null) || echo "MISSING"
  else
    echo "MISSING"
  fi
}

build_head_block() {
  printf "| repo | HEAD |\n|---|---|\n"
  for repo in $REPOS_ALL; do
    local h
    h="$(read_head "$PARENT_DIR/$repo")"
    printf "| %s | \`%s\` |\n" "$repo" "$h"
  done
}

# === 측정 B — 보호 파일 5 종 × 4-active sha matrix ===
sha_short() {
  local f="$1"
  if [ -f "$f" ]; then
    shasum -a 256 "$f" 2>/dev/null | awk '{print substr($1,1,12)}'
  else
    echo "MISSING"
  fi
}

build_protected_matrix() {
  printf "| 보호 파일 |"
  for repo in $REPOS_ALL; do printf " %s |" "$repo"; done
  printf "\n|---"
  for repo in $REPOS_ALL; do printf "|---"; done
  printf "|\n"
  local drift_total=0
  local drift_rows=""
  for pf in "${PROTECTED_FILES[@]}"; do
    printf "| \`%s\` |" "$pf"
    local master_sha
    master_sha="$(sha_short "$PARENT_DIR/claude-cli-master/$pf")"
    local row_drift=0
    for repo in $REPOS_ALL; do
      local child_sha
      child_sha="$(sha_short "$PARENT_DIR/$repo/$pf")"
      local marker=""
      if [ "$repo" = "claude-cli-master" ]; then
        marker=""
      elif [ "$child_sha" = "$master_sha" ]; then
        marker=" ✓"
      else
        marker=" ✗"
        row_drift=$((row_drift+1))
      fi
      printf " \`%s\`%s |" "$child_sha" "$marker"
    done
    printf "\n"
    if [ "$row_drift" -gt 0 ]; then
      drift_rows="$drift_rows\n  - \`$pf\` (drift $row_drift child)"
      drift_total=$((drift_total+row_drift))
    fi
  done
  echo ""
  echo "**drift count = $drift_total**"
  if [ "$drift_total" -gt 0 ]; then
    printf "%b\n" "drift 상세: $drift_rows"
  fi
}

# === 측정 C — cli infra drift (verify-sync.sh --no-update) ===
VS_OUT="$(bash "$MASTER_DIR/scripts/verify-sync.sh" --no-update --skip-daemon-check 2>&1)"
VS_EXIT="$?"
VS_SUMMARY="$(printf "%s\n" "$VS_OUT" | grep -E "^  (PASS|DRIFT|MISS):" || echo "  (요약 추출 실패 — verify-sync 출력 형식 변동 가능)")"

# === 측정 D — 최근 commit 5 건 / repo ===
build_recent_commits() {
  for repo in $REPOS_ALL; do
    local repo_dir="$PARENT_DIR/$repo"
    echo "### $repo"
    echo ""
    echo '```'
    if [ -d "$repo_dir/.git" ]; then
      (cd "$repo_dir" && git log --oneline -5 2>/dev/null) || echo "(git log 실패)"
    else
      echo "(repo 부재)"
    fi
    echo '```'
    echo ""
  done
}

# === 측정 E — 진행 중 cycle 미완 항목 ===
build_cycle_unfinished() {
  local recent
  recent="$(ls -lt "$MASTER_DIR/.ai/reports" 2>/dev/null | awk 'NR>1 && /^d/ {print $9}' | head -8)"
  echo "| cycle | Verdict | TODO 미해결 |"
  echo "|---|---|---|"
  if [ -z "$recent" ]; then
    echo "| (없음) | — | — |"
    return
  fi
  while IFS= read -r cycle; do
    [ -z "$cycle" ] && continue
    local review_path="$MASTER_DIR/.ai/reports/$cycle/REVIEW.md"
    local todo_path="$MASTER_DIR/.ai/reports/$cycle/TODO.md"
    local verdict="(REVIEW 부재)"
    local todo_count="0"
    if [ -f "$review_path" ]; then
      local extracted
      extracted="$(grep -iE "^(##? +)?Verdict" "$review_path" 2>/dev/null | head -1 | sed -E 's/^#+ *//;s/^ *//;s/ *$//')"
      if [ -n "$extracted" ]; then
        verdict="$extracted"
      else
        verdict="(Verdict 줄 부재)"
      fi
    fi
    if [ -f "$todo_path" ]; then
      todo_count="$(grep -cE "^- \[ \]" "$todo_path" 2>/dev/null || echo "0")"
    fi
    echo "| \`$cycle\` | $verdict | $todo_count 항목 |"
  done <<< "$recent"
}

HEAD_BLOCK="$(build_head_block)"
PROTECTED_BLOCK="$(build_protected_matrix)"
COMMITS_BLOCK="$(build_recent_commits)"
CYCLE_BLOCK="$(build_cycle_unfinished)"

# === claude -p prompt 본문 build ===
# CLAUDE.md §4 절대 금지 (/tmp · $TMPDIR 계열) + settings.json deny Bash(*tmp*) 정합:
# mktemp/$TMPDIR 미사용. heredoc 으로 prompt 영역을 shell 변수에 박고 stdin pipe.
# OUT_FILE.tmp 만 trap 정리 영역 (= $NIGHTLY_DIR 안 = repo 안 출력 영역 = §4 정합).
trap 'rm -f "$OUT_FILE.tmp"' EXIT

PROMPT_BODY=$(cat <<PROMPT
당신은 baseline 리포트 양식화 보조다. 아래 측정 데이터를 그대로 인용해 markdown 리포트 1 개를 만든다. 추측·창작 금지. 데이터 밖 fact 추가 금지.

## 본 작업 정의 (repo 도메인 baseline · 단방향 단일 진실)

- master = claude-cli-master (cli infra + 보호 파일 5 종 SoT 단일 source · 자식 repo 단방향 propagation 발행)
- 자식 3 repo = Selfward (「나에게로」· 활성 도메인 자식 단일 · 1 앱 N 도메인) / app-foundation (공통 foundation) / toward-product-docs (제품 기획·비전 문서)
- 보호 파일 5 종 = master ↔ 자식 byte-identical 강제 (drift 발견 시 mitigation cycle 의무)
- cli infra = .claude/ 전체 = 권장 byte-identical (drift lazy 가능)

## 본 리포트 의도

매 Cowork chat 진입 시 수동으로 하던 baseline 조사를 야간 자동화 결과로 대체. 사람이 아침에 1 분 안에 읽고 진행 중 cycle 재개 또는 drift mitigation 의 단서를 잡는다.

## 측정 timestamp

- KST: $TS_KST
- UTC: $TS_UTC

## raw 측정 데이터

### A. 4-active HEAD

$HEAD_BLOCK

### B. 보호 파일 5 종 × 4-active sha matrix

$PROTECTED_BLOCK

### C. cli infra drift (verify-sync.sh --no-update)

- exit code: $VS_EXIT (0 = PASS · 1 = drift/miss · 2 = 환경 오류)
- summary:
\`\`\`
$VS_SUMMARY
\`\`\`

### D. 최근 commit 5 건 / repo

$COMMITS_BLOCK

### E. 진행 중 cycle 미완 항목 (최근 8 디렉터리 기준)

$CYCLE_BLOCK

## 출력 의무

다음 layout 그대로 markdown 리포트 1 개 출력. 본문 외 사족 X. 코드펜스 \`\`\` 안 wrap X (즉 본 리포트는 plain markdown).

# Nightly Baseline Report — $DATE_ISO

> 측정 KST: $TS_KST · 측정 UTC: $TS_UTC
> 산출 cycle: MASTER-NIGHTLY-BASELINE-CRON-001

## 1. TL;DR (3 줄)

(보호 파일 정합 + cli infra drift + 진행 중 cycle 1 순위 · 사람 1 분 읽기 분량)

## 2. 4-active HEAD

(A 표 그대로)

## 3. 보호 파일 5 종 정합 (master 단일 진실 · 자식 byte-identical 의무)

(B 표 그대로 + drift count 강조 + drift 존재 시 어느 file / 어느 repo 명시)

## 4. cli infra drift

(C summary 그대로 + exit code 의미 1 줄 해석)

## 5. 진행 중 cycle 미완 (재개 단서)

(E 표 그대로 + Verdict 안 'PASS 외' row 우선순위 강조)

## 6. 최근 commit

(D block 그대로)

## 7. repo 도메인 (이 리포트 진입자용 baseline)

| repo | 도메인 |
|---|---|
| claude-cli-master | master · cli infra + 보호 파일 SoT |
| Selfward | 자식 · 「나에게로」 활성 도메인 단일 (1 앱 N 도메인) |
| app-foundation | 자식 · 공통 foundation |
| toward-product-docs | 자식 · 제품 기획·비전 문서 |

위 layout 그대로 출력하라. 데이터 안에 없는 fact 추가 X.
PROMPT
)

# === claude -p 호출 (read-only · LLM only · --tools "" 로 도구 비활성) ===
CLAUDE_EXIT=0
CLAUDE_OUT=""
if [ -z "$CLAUDE_BIN" ]; then
  CLAUDE_EXIT=127
  CLAUDE_OUT="(claude binary resolve 실패)"
else
  # --setting-sources "" = settings.json 미로드 (SessionStart hook 등 부산물 file 생성 차단).
  # --bare 제거 이유: --bare 는 OAuth keychain 인증 차단 (--help: "Anthropic auth is strictly
  # ANTHROPIC_API_KEY or apiKeyHelper via --settings"). Coin 의 정상 OAuth 세션 재사용 의무.
  # --tools "" = 모든 도구 비활성 (read-only LLM only · file/network/bash 접근 X).
  CLAUDE_OUT="$("$CLAUDE_BIN" -p \
    --setting-sources "" \
    --tools "" \
    --no-session-persistence \
    --output-format text \
    --max-budget-usd 0.50 \
    --append-system-prompt "You are a baseline report formatter. Use only the data provided in the user message. Do not invent facts. Output Korean markdown." \
    <<< "$PROMPT_BODY" 2>&1)"
  CLAUDE_EXIT="$?"
fi

# === fallback (claude 실행 실패 시 raw 측정 데이터 그대로 박음) ===
if [ "$CLAUDE_EXIT" -ne 0 ] || [ -z "$CLAUDE_OUT" ]; then
  {
    echo "# Nightly Baseline Report — $DATE_ISO (FALLBACK · claude -p 실행 실패)"
    echo ""
    echo "> 측정 KST: $TS_KST · 측정 UTC: $TS_UTC"
    echo "> claude exit = $CLAUDE_EXIT · 종합 단계 skip · 아래 raw 측정 데이터 그대로 박음"
    echo ""
    echo "## A. 4-active HEAD"
    echo ""
    printf "%s\n" "$HEAD_BLOCK"
    echo ""
    echo "## B. 보호 파일 sha matrix"
    echo ""
    printf "%s\n" "$PROTECTED_BLOCK"
    echo ""
    echo "## C. cli infra drift (verify-sync exit=$VS_EXIT)"
    echo ""
    echo '```'
    printf "%s\n" "$VS_SUMMARY"
    echo '```'
    echo ""
    echo "## D. 최근 commit"
    echo ""
    printf "%s\n" "$COMMITS_BLOCK"
    echo ""
    echo "## E. 진행 중 cycle 미완"
    echo ""
    printf "%s\n" "$CYCLE_BLOCK"
    echo ""
    echo "## claude -p output (stderr/stdout · debug 용)"
    echo ""
    echo '```'
    printf "%s\n" "$CLAUDE_OUT"
    echo '```'
  } > "$OUT_FILE.tmp"
else
  printf "%s\n" "$CLAUDE_OUT" > "$OUT_FILE.tmp"
fi

mv "$OUT_FILE.tmp" "$OUT_FILE"
cp "$OUT_FILE" "$LATEST_FILE"

log_append "done · claude_exit=$CLAUDE_EXIT verify_sync_exit=$VS_EXIT out=$OUT_FILE"

exit 0
