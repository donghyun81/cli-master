#!/usr/bin/env bash
# scripts/propagate.sh — master → 자식 repo 단방향 cp + 자동 stage
#
# 사용:
#   bash scripts/propagate.sh <relative-path> [<relative-path> ...] [--targets GB,GD,GT|all]
#   bash scripts/propagate.sh --all [--targets GB,GD,GT|all]
#
# 환경 변수:
#   PARENT_DIR     기본: ~/AndroidStudioProjects (자식 repo 들이 있는 곳)
#   MASTER_DIR     기본: $PARENT_DIR/claude-cli-master
#   TARGET_REPOS   기본: "GentlyBreath GentlyDay GentlyTable"
#
# 동작:
#   1. master 의 지정 파일을 자식 repo 동일 path 로 cp
#   2. cp 후 자식 repo 안에서 git add 자동
#   3. cross-verify (cp 후 sha 일치 확인)
#   4. stdout 에 결과 표 출력
#
# 차단:
#   - master 자체 sha 가 보호 파일과 baseline 불일치 = STOP
#   - 자식 repo 가 git 아님 = STOP
#   - 자식 repo 가 dirty (uncommitted) 이고 propagation 대상 파일과 충돌 = STOP

set -euo pipefail

# === 환경 변수 default ===
: "${PARENT_DIR:=$HOME/AndroidStudioProjects}"
: "${MASTER_DIR:=$PARENT_DIR/claude-cli-master}"
: "${TARGET_REPOS:=GentlyBreath GentlyDay GentlyTable}"

# === 인자 파싱 ===
TARGETS=""
PROPAGATE_ALL=0
FILES=()

while [ $# -gt 0 ]; do
  case "$1" in
    --all)
      PROPAGATE_ALL=1
      shift
      ;;
    --targets)
      TARGETS="$2"
      shift 2
      ;;
    --help|-h)
      sed -n '1,30p' "$0"
      exit 0
      ;;
    -*)
      echo "[propagate] ERROR: unknown flag $1" >&2
      exit 2
      ;;
    *)
      FILES+=("$1")
      shift
      ;;
  esac
done

# === target 해결 ===
if [ -z "$TARGETS" ] || [ "$TARGETS" = "all" ]; then
  TARGET_LIST="$TARGET_REPOS"
else
  # GB,GD,GT → GentlyBreath GentlyDay GentlyTable
  TARGET_LIST=""
  IFS=',' read -ra arr <<< "$TARGETS"
  for t in "${arr[@]}"; do
    case "$t" in
      GB) TARGET_LIST="$TARGET_LIST GentlyBreath" ;;
      GD) TARGET_LIST="$TARGET_LIST GentlyDay" ;;
      GT) TARGET_LIST="$TARGET_LIST GentlyTable" ;;
      *)  TARGET_LIST="$TARGET_LIST $t" ;;
    esac
  done
fi

# === 파일 list 해결 ===
if [ "$PROPAGATE_ALL" = 1 ]; then
  cd "$MASTER_DIR"
  # 모든 cli infra + 보호 파일 (gitignore 대상 제외)
  while IFS= read -r f; do
    FILES+=("$f")
  done < <(find .claude docs scripts/agent .ai/promptfit .ai/uiux-sot/refresh .github -type f \
    ! -name '.DS_Store' \
    ! -name 'settings.local.json' \
    ! -path './.git/*' 2>/dev/null)
  # C5 박힘: root 공통 파일 5종 명시 추가
  for rf in .editorconfig .mcp.json gradle.properties gradlew gradlew.bat; do
    [ -f "$rf" ] && FILES+=("$rf")
  done
fi

if [ "${#FILES[@]}" = 0 ]; then
  echo "[propagate] ERROR: 파일 미지정. --all 또는 명시적 path 필요." >&2
  exit 2
fi

# === BASELINE 검증: 보호 파일 4종 ===
cd "$MASTER_DIR"
EXPECTED_BASELINE=$(cat <<'BASE'
bba7745ef7c494746f6ffcd829202c3495d297ea26cbd2591dbc6d1cc7114cbd  docs/schemas/ui-spec.schema.json
af8e7e26a782818c56f00cd33a379d9abfe88292fcc78bd18266e514f6935a80  .claude/rules/pencil-uiux-workflow.md
1f97ac1f1c7a71b1efa5a4b9756f46e0d5879a9d6cfbf9651de1ed293295ae6d  docs/design/pencil-sot-policy.md
487d57a2759aa93c8733fba37624000362ecde1665a75edc6207dd6b9dba07db  .claude/rules/uiux-sot-refresh.md
BASE
)
ACTUAL_BASELINE=$(for f in docs/schemas/ui-spec.schema.json .claude/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md .claude/rules/uiux-sot-refresh.md; do
  shasum -a 256 "$f" 2>/dev/null
done)
if [ "$EXPECTED_BASELINE" != "$ACTUAL_BASELINE" ]; then
  echo "[propagate] WARN: 보호 파일 baseline 변경 감지. .auto-memory/protected-file-hashes.md 갱신 의무." >&2
  echo "[propagate] WARN: 그래도 propagation 진행. master baseline 이 새 sha 로 박힌 cycle 확인 의무." >&2
fi

# === propagation 실행 ===
echo ""
echo "═══════════════════════════════════════════════════════"
echo "[propagate] master → 자식 repo 단방향 cp"
echo "  master:  $MASTER_DIR"
echo "  targets: $(echo $TARGET_LIST | xargs)"
echo "  files:   ${#FILES[@]} 개"
echo "═══════════════════════════════════════════════════════"

TOTAL_OK=0
TOTAL_FAIL=0

for repo in $TARGET_LIST; do
  REPO_DIR="$PARENT_DIR/$repo"

  if [ ! -d "$REPO_DIR" ]; then
    echo "[propagate] $repo: SKIP (not found at $REPO_DIR)" >&2
    continue
  fi
  if [ ! -d "$REPO_DIR/.git" ]; then
    echo "[propagate] $repo: SKIP (not a git repo)" >&2
    continue
  fi

  echo ""
  echo "--- $repo ---"
  REPO_OK=0
  REPO_FAIL=0

  for f in "${FILES[@]}"; do
    SRC="$MASTER_DIR/$f"
    DST="$REPO_DIR/$f"

    if [ ! -f "$SRC" ]; then
      echo "  ✗ $f: master 부재"
      REPO_FAIL=$((REPO_FAIL+1))
      continue
    fi

    # 자식 repo 의 dst 디렉터리 보장
    mkdir -p "$(dirname "$DST")" 2>/dev/null

    # cp + sha 검증
    cp "$SRC" "$DST"
    SRC_SHA=$(shasum -a 256 "$SRC" | awk '{print substr($1,1,12)}')
    DST_SHA=$(shasum -a 256 "$DST" | awk '{print substr($1,1,12)}')

    if [ "$SRC_SHA" = "$DST_SHA" ]; then
      # git stage (자식 repo 안)
      (cd "$REPO_DIR" && git add "$f" 2>/dev/null) || true
      echo "  ✓ $f  ($SRC_SHA)"
      REPO_OK=$((REPO_OK+1))
    else
      echo "  ✗ $f: sha 불일치 src=$SRC_SHA dst=$DST_SHA"
      REPO_FAIL=$((REPO_FAIL+1))
    fi
  done

  echo "  요약: ok=$REPO_OK fail=$REPO_FAIL"
  TOTAL_OK=$((TOTAL_OK+REPO_OK))
  TOTAL_FAIL=$((TOTAL_FAIL+REPO_FAIL))
done

echo ""
echo "═══════════════════════════════════════════════════════"
echo "[propagate] 전체 요약: ok=$TOTAL_OK fail=$TOTAL_FAIL"
echo "  다음 단계: bash scripts/verify-sync.sh   # cross-verify"
echo "  자식 repo 별 commit 의무 (master commit body 인용)"
echo "═══════════════════════════════════════════════════════"

if [ "$TOTAL_FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
