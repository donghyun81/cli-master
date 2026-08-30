#!/usr/bin/env bash
# scripts/verify-sync.sh — 4-repo cli infra + 보호 파일 sha 동기 검증 (= master + 자식 3 · 2026-07-17 T6 재편)
#
# 사용:
#   bash scripts/verify-sync.sh                         # 전체 검증 + propagation-status.md 자동 갱신
#   bash scripts/verify-sync.sh --quick                 # 보호 파일 4 종 + 핵심 cli infra 만
#   bash scripts/verify-sync.sh --no-update             # 검증만 (propagation-status.md 갱신 X)
#   bash scripts/verify-sync.sh --target Selfward       # 특정 자식 repo 만
#
# 환경 변수:
#   PARENT_DIR     기본: ~/AndroidStudioProjects
#   MASTER_DIR     기본: $PARENT_DIR/claude-cli-master
#   TARGET_REPOS   기본: "app-foundation toward-product-docs Selfward"
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
  docs/rules/pencil-uiux-workflow.md
  docs/design/pencil-sot-policy.md
  docs/rules/uiux-sot-refresh.md
  docs/design/design-sot-policy.md
)
CORE_CLI=(
  .claude/settings.json
  docs/rules/workflow-core.md
  docs/rules/cycle-discipline.md
  docs/rules/pencil-automation.md
  docs/rules/reporting.md
  docs/rules/routing-and-delegation.md
  docs/rules/deferred-domains.md
  docs/rules/code-principles.md
  docs/rules/design-to-code-sync.md
  docs/rules/ux-laws.md
  docs/agent/architecture/COMMON_ARCHITECTURE.md
  docs/agent/architecture/TDD_WORKFLOW.md
  docs/agent/architecture/MODEL_SEPARATION.md
  docs/agent/architecture/SSOT_PRINCIPLES.md
  docs/agent/process/COMMIT_CONVENTION.md
  scripts/agent/frontmatter-grep.sh
  .editorconfig
  .mcp.json
)
# gradle.properties = domain-specific (repo-specific 자유 · L1-3 polyrepo)
# → byte-identical 검증 제외 (MASTER-CLI-VERIFY-SYNC-DIFFERENTIATION-SCOPE-001)
# gradlew / gradlew.bat 는 보존 (= FULL mode root file loop 참조)

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
    ! -path '*skills/run-*' \
    ! -path 'docs/release-readiness/*' \
    ! -path 'docs/agent/audits/*' \
    ! -path 'docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md' \
    ! -path 'docs/ops/*' \
    ! -path 'docs/stale-sweeps/*' \
    ! -path '.github/workflows/*' 2>/dev/null | sort)
  # skills/run-* = 자식별 차별화 launch recipe (실측: run-master / run-foundation / run-Selfward · 각 자식 한정 ·
  #   propagation X · §Q-2 / P0-4 NATIVE-RUN-VERIFY-SANDBOX) → byte-identical/MISS 검증 제외
  #   (MASTER-CLI-VERIFY-SYNC-DIFFERENTIATION-SCOPE-001)
  # docs/agent/audits/* = master-only 점-측정 audit (TESTING-BACKFILL-AUDIT.md ·
  #   자식 propagation 없음 · docs/release-readiness 격리 선례와 같은 결) → MISS 오인 제외
  #   (MASTER-PRELAUNCH3-SMALLFIX-001)
  #
  # === 제외 4종 (MASTER-PROPAGATION-HYGIENE-001 · 2026-08-23 · propagate.sh 동일 4행 정합) ===
  # ★양 script 에 같은 4종을 같은 순서로 넣는다 — 한쪽만 넣으면 cp 분모와 verify 분모가 갈린다.
  # docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md = master-only 거버넌스 문서 → MISS 오인 제외.
  #   ★file 단위 의무 · dir 제외 금지: 형제 external-dep-abstraction.md 는 FND/TPD/SW 전량 실재 =
  #   살아 있는 전파다 (실측 2026-08-23: docs/architecture 2본 · charter 만 자식 3 전량 부재).
  #   ⟹ 이 dir 에 master-only 문서가 또 생기면 그 1본이 다시 MISS 로 뜬다 (= file 단위의 대가 ·
  #      docs/rules/cross-repo-parallel-exec-detail.md §5).
  # docs/ops/* = master-only 운영 runbook (자격증명 주입 경로 서술) · 자식 도입 = 별 scope 결정.
  #   실측: 1본 (production-cli-access-tokens.md) · FND/TPD/SW 전량 부재 = MISS 3.
  # docs/stale-sweeps/* = ★자식별 고유 산출물 — MISS 와 DRIFT 를 동시에 냈다 (FND·TPD 부재 / SW 실재+sha 상이).
  #   근거 = docs/rules/stale-artifact-tracking.md:70 이 sweep 산출을 <repo>/docs/stale-sweeps/SWEEP-YYYYMMDD.md
  #   로 repo 별 정의 (동 rule :46 대장도 <repo>/STALE-DEBT.md · :93 = 대장·README 를 Selfward 측에 먼저 신설).
  #   실측 sha: README.md master=d0c280da ↔ SW=95b4781a · SWEEP-20260817.md master=f49c2b50 ↔ SW=8b8ab20a
  #   (루트 STALE-DEBT.md 동형: master=4a09c7a7 ↔ SW=a871f982) ⟹ skills/run-* 와 같은 결.
  # .github/workflows/* = ★예방적 제외. 2026-08-23 현재 4-repo 전량 0본 = 지금은 아무것도 안 잡는다.
  #   목적 = ci.yml 신설 시점에 Gradle 전제 workflow 가 Gradle 없는 TPD·master 로 번지는 것 차단.
  #   형제 .github/pull_request_template.md 는 계속 분모에 잔존 (= workflows/ 하위만 문다 · 실측 확인).
  # C5 박힘: root 공통 파일 명시 추가 (gradle.properties 제외 = domain-specific · L1-3)
  for rf in .editorconfig .mcp.json gradlew gradlew.bat; do
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
echo "[verify-sync] 4-repo sha 동기 검증"
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

# === propagation-status.md 자동 갱신 (= live sha 매트릭스 + Last verify-sync footer 재생성) ===
# Phase C (MASTER-CLI-POSTCYCLE-AUTOMATION-001): 수기 sha 표 = 영구 stale 원인 →
#   verify-sync 가 보호 5 + 핵심 cli infra 매트릭스를 live sha 로 재생성 (= 자동 footer + 자동 매트릭스 = 단일 진실).
#   auto-region = AUTO_MARKER 부터 EOF (수기 본문은 marker 위 = 무접촉).
if [ "$NO_UPDATE" = 0 ] && [ "$QUICK" = 0 ]; then
  STATUS_FILE="$MASTER_DIR/.auto-memory/propagation-status.md"
  TS=$(date '+%Y-%m-%dT%H:%M:%S%z')
  AUTO_MARKER="## Auto-generated (verify-sync · live · 직접 편집 금지)"
  BT='`'

  if [ -f "$STATUS_FILE" ]; then
    # --- live 매트릭스 rows 빌드 (보호 5 + 핵심 cli infra) ---
    MATRIX_ROWS=""
    for f in "${PROTECTED[@]}" "${CORE_CLI[@]}"; do
      MSHA=$(shasum -a 256 "$MASTER_DIR/$f" 2>/dev/null | awk '{print substr($1,1,12)}')
      [ -z "$MSHA" ] && continue
      ROW="| ${BT}${f}${BT} | ${BT}${MSHA}${BT} |"
      for repo in $TARGET_LIST; do
        DSHA=$(shasum -a 256 "$PARENT_DIR/$repo/$f" 2>/dev/null | awk '{print substr($1,1,12)}')
        if [ -z "$DSHA" ]; then CELL="MISS"
        elif [ "$DSHA" = "$MSHA" ]; then CELL="✓"
        else CELL="${BT}${DSHA}${BT}✗"; fi
        ROW="$ROW $CELL |"
      done
      MATRIX_ROWS="${MATRIX_ROWS}${ROW}\n"
    done
    COLHDR="| 파일 | master sha (12) |"; COLSEP="|---|---|"
    for repo in $TARGET_LIST; do COLHDR="$COLHDR $repo |"; COLSEP="$COLSEP---|"; done

    # --- auto-region 삭제 (신 marker 우선 · 없으면 legacy footer fallback) ---
    if grep -qF "$AUTO_MARKER" "$STATUS_FILE"; then
      sed -i.bak "/^## Auto-generated (verify-sync/,$ d" "$STATUS_FILE"; rm -f "${STATUS_FILE}.bak" 2>/dev/null
    elif grep -q "^## Last verify-sync" "$STATUS_FILE"; then
      sed -i.bak "/^## Last verify-sync/,$ d" "$STATUS_FILE"; rm -f "${STATUS_FILE}.bak" 2>/dev/null
    fi

    # --- auto-region append (marker + live 매트릭스 + footer) ---
    {
      echo "$AUTO_MARKER"
      echo ""
      echo "> 본 영역 = ${BT}verify-sync.sh${BT} 매 실행 시 live sha 재생성. 수기 편집 금지 (= 영구 stale 차단)."
      echo "> targets: $(echo $TARGET_LIST | xargs)"
      echo ""
      echo "### 보호 5 + 핵심 cli infra sha 매트릭스 (live)"
      echo ""
      echo "$COLHDR"
      echo "$COLSEP"
      printf "%b" "$MATRIX_ROWS"
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
    echo "[verify-sync] propagation-status.md 갱신 박음 (live 매트릭스 + footer)"
  fi
fi

# === 상태문서 부재 참조 WARN (= drift 재발 감지 · --no-update 에서도 실행) ===
# 두 상태문서가 인용하는 repo-relative file path 존재 검증 → 부재 시 stderr WARN.
# T1: 「모든 인용 행이 마킹된 path」= 병기(K-171) → 분모에서 제외 (★path 축 · 「왜」 = 아래 T4 주석).
STALE_REF_MARKERS='~~|소멸|이동|구 경로|폐기'
# --- T4 「왜」 (MASTER-VERIFY-SYNC-MARKED-REF-AXIS-001 · 2026-08-31) ---
# 원장 규약 = 「삭제 0 · 구 문면 병기」(㉣ K-171). 그런데 본 WARN 은 backtick path 의 **문자열
# 실재**를 센다 ⟹ 양립 불가 · 병기를 지키는 한 WARN 은 영구히 뜬다. 그 상시 소음이 ⑴ 진짜
# drift 를 덮고(3 줄이 늘 뜨면 4 줄째가 새로 생겨도 못 본다) ⑵ 다음 판을 「정정: 상태문서 본문
# 갱신」이라는 아래 지시로 유도해 K-171 을 위반시킨다. 고칠 곳은 문서가 아니라 「자」다.
#   ⓐ 구 경로를 지운다   → 버림: K-171 정면 위반 (WARN 끄려고 이력을 지우는 것이 곧 사고)
#   ⓑ WARN 을 끈다      → 버림: 소음을 없애려다 진짜 stale 까지 무감시가 된다
#   ⓒ 마킹 path 를 뺀다  → 채택: 이력(병기)도 신호(감시)도 둘 다 산다
# 마커 5 의 근거 좌표 = .auto-memory/protected-file-hashes.md 실사용 병기 행:
#   소멸 :11 :12 :13 :87 :98 :99 :111 (= 부재 인용 7 행 전량) · 이동 :13 :111 · ~~ :87 :99
#   · 폐기 :87 :99 ("sha record 폐기") · 구 경로 :111 · 규약 근거 = 같은 file :7~:16
#   (병기 표 · :15 「소멸/이동을 한 묶음으로 읽으면 틀린다」 · :16 「WARN 은 이력의 그림자」)
# ★뺀 어휘 (2026-08-31 census · 단위 = 행): 부재 = 본 WARN 이 쓰는 **증상어**라 처분을 안 적고
#   부재를 서술만 해도 마킹이 되어 진짜 stale 을 삼킨다(넓힘 +4/+6 = 최대) · 제거·삭제·통합·
#   deprecated = 그 cycle 이 **다른 file 에** 한 일을 서술해 인용 path 의 처분과 결합하지 않는다
#   (각 +4/+3 · +2/+1 · +2/+0 · +2/+2). 기준 = 「그 path 의 부재가 **의도된 기록**임을 단언」.
# ★현 데이터에서 실제로 일하는 마커는 `소멸` 하나다(빼면 마킹제외 3/3 → 1/3 · workflow-core 만
#   `이동` 으로 생존). 나머지 4 = 선행 커버리지로 존치 — 앞으로의 병기 행이 `~~`/`이동` 만 달고
#   올 수 있다. 이 줄의 목적 = 다음 판이 「안 쓰는 마커」로 오독하고 지우는 것을 막는다.
STATUS_DOCS="$MASTER_DIR/.auto-memory/protected-file-hashes.md $MASTER_DIR/.auto-memory/propagation-status.md"
REF_MISSING=""
REF_TOTAL=0
REF_MARKED=0
for doc in $STATUS_DOCS; do
  [ -f "$doc" ] || continue
  for path in $(grep -oE '`(\.claude|docs|scripts|\.auto-memory|\.ai)/[A-Za-z0-9._/-]+\.(md|json|sh|sql|toml|kt|py)`' "$doc" | tr -d '`' | sort -u); do
    [ -e "$MASTER_DIR/$path" ] && continue
    REF_TOTAL=$((REF_TOTAL + 1))
    # ★path 축: 이 path 를 인용하는 행이 **전량** 마킹일 때만 제외. 한 행이라도 비마킹이면 남긴다.
    ref_cited=$(grep -c -F -- "$path" "$doc")
    ref_marked=$(grep -F -- "$path" "$doc" | grep -c -E "$STALE_REF_MARKERS")
    if [ "$ref_cited" -gt 0 ] && [ "$ref_cited" -eq "$ref_marked" ]; then
      REF_MARKED=$((REF_MARKED + 1))
      continue
    fi
    REF_MISSING="${REF_MISSING}  - $path (in $(basename "$doc"))\n"
  done
done
# T2: 산출을 stdout 요약 1 행으로 낸다. 이유 = 이 트랙은 명령에 `2>` 를 쓰지 않으므로
# stderr WARN 은 파이프 없이 잴 수단이 없었다 ⟹ 자가 자기 값을 stdout 으로 낸다.
# 무조건 1 행 (부재 0 이어도 `분모=0 마킹제외=0 잔존=0`) · 아래 stderr 블록은 존치(사람이 읽는 층).
REF_LEFT=$((REF_TOTAL - REF_MARKED))
printf '[verify-sync] stale-ref: 분모=%s 마킹제외=%s 잔존=%s\n' "$REF_TOTAL" "$REF_MARKED" "$REF_LEFT"
if [ -n "$REF_MISSING" ]; then
  echo "" >&2
  echo "[verify-sync] ⚠ 상태문서 부재 참조 (= stale ref · drift 재발 신호):" >&2
  printf "%b" "$REF_MISSING" | sort -u >&2
  echo "  → 정정: 해당 .auto-memory 상태문서 본문 갱신 (master cycle)" >&2
  echo "" >&2
fi

if [ $((DRIFT_COUNT+MISS_COUNT)) -gt 0 ]; then
  echo "[verify-sync] FAIL — drift / miss 발견. propagation cycle 권장." >&2
  exit 1
fi
echo "[verify-sync] PASS — 모든 sha 일치"
exit 0
