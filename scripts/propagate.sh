#!/usr/bin/env bash
# scripts/propagate.sh — master → 자식 repo 단방향 cp + 자동 stage
#
# 사용:
#   bash scripts/propagate.sh <relative-path> [<relative-path> ...] [--targets FND,toward-product-docs,Selfward|all]
#   bash scripts/propagate.sh --all [--targets FND,toward-product-docs,Selfward|all]
#
#   --targets 토큰: alias = GB / GD / GT / FND 만 (= 아래 resolver case) · 그 외 = 폴더명 verbatim
#     (예: toward-product-docs · Selfward). GB/GD/GT = 2026-07-17 T6 전파 대상 제거 (= 동결 계승 원천)
#     이나 alias 문법 자체는 보존 (= 명시 지정 시 유효 · 기본 대상 아님).
#
# 환경 변수:
#   PARENT_DIR     기본: ~/AndroidStudioProjects (자식 repo 들이 있는 곳)
#   MASTER_DIR     기본: $PARENT_DIR/claude-cli-master
#   TARGET_REPOS   기본: "app-foundation toward-product-docs Selfward"
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

# === 환경 변수 default (single SoT · MASTER-REPO-CONFIG-SOT-001) ===
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=./repo-config.sh
. "$SCRIPT_DIR/repo-config.sh"

# === 인자 파싱 ===
TARGETS=""
PROPAGATE_ALL=0
PRUNE_MODE=0
PRUNE_APPLY=0
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
    --prune)
      PRUNE_MODE=1
      shift
      ;;
    --apply)
      PRUNE_APPLY=1
      shift
      ;;
    --help|-h)
      sed -n '1,40p' "$0"
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
      FND) TARGET_LIST="$TARGET_LIST app-foundation" ;;
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
    ! -path './.git/*' \
    ! -path 'docs/release-readiness/*' \
    ! -path 'docs/agent/audits/*' \
    ! -path 'docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md' \
    ! -path 'docs/ops/*' \
    ! -path 'docs/stale-sweeps/*' \
    ! -path '.github/workflows/*' 2>/dev/null)
  # docs/agent/audits/* = master-only 점-측정 audit → --all propagation 제외
  #   (verify-sync.sh 매트릭스 정합 · MASTER-PRELAUNCH3-SMALLFIX-001)
  #
  # === 제외 4종 (MASTER-PROPAGATION-HYGIENE-001 · 2026-08-23 · verify-sync.sh 동일 4행 정합) ===
  # docs/architecture/CLI-MASTER-SCOPE-SEPARATION-CHARTER.md = master-only 거버넌스 문서 → 제외.
  #   ★file 단위 의무 · dir 제외 금지: 같은 dir 의 형제 external-dep-abstraction.md 는 자식 3 전량에
  #   실재 = 살아 있는 전파다. dir 로 빼면 그 3본이 분모에서 함께 사라진다.
  #   실측 2026-08-23: docs/architecture = 2본 · charter 는 FND/TPD/SW 전량 부재 ·
  #   external-dep-abstraction.md 는 FND/TPD/SW 전량 실재.
  #   ⟹ 이 dir 에 master-only 문서가 또 생기면 그 1본이 다시 MISS 로 뜬다 (= file 단위의 대가 ·
  #      살아 있는 전파를 죽이는 것보다 싸다 · docs/rules/cross-repo-parallel-exec-detail.md §5).
  # docs/ops/* = master-only 운영 runbook (자격증명 주입 경로 서술) · 자식 도입 = 별 scope 결정.
  #   실측: 1본 (production-cli-access-tokens.md) · FND/TPD/SW 전량 부재.
  # docs/stale-sweeps/* = ★자식별 고유 산출물 (byte-identical 대상 아님 · MISS 와 DRIFT 를 동시에 냈다).
  #   근거 = docs/rules/stale-artifact-tracking.md:70 이 sweep 산출을 <repo>/docs/stale-sweeps/SWEEP-YYYYMMDD.md
  #   로 repo 별 정의 (동 rule :46 대장도 <repo>/STALE-DEBT.md · :93 = 대장·README 를 Selfward 측에 먼저 신설).
  #   실측 sha 상이: README.md master=d0c280da ↔ SW=95b4781a · SWEEP-20260817.md master=f49c2b50 ↔ SW=8b8ab20a
  #   (루트 STALE-DEBT.md 동형: master=4a09c7a7 ↔ SW=a871f982) ⟹ .claude/skills/run-* 와 같은 결.
  # .github/workflows/* = ★예방적 제외. 2026-08-23 현재 4-repo 전량 0본 = 지금은 아무것도 안 잡는다.
  #   목적 = ci.yml 신설 시점에 Gradle 전제 workflow 가 Gradle 없는 TPD·master 로 번지는 것 차단
  #   (ⓓ CI-VERIFY 의 선행 조치). 형제 .github/pull_request_template.md 는 계속 분모에 잔존한다
  #   (= workflows/ 하위만 문다 · 실측 확인).
  # C5 박힘: root 공통 파일 5종 명시 추가
  for rf in .editorconfig .mcp.json gradle.properties gradlew gradlew.bat; do
    [ -f "$rf" ] && FILES+=("$rf")
  done
fi

# === C16: run-* recipe cp 가드 (= MASTER-CLI-INFRA-SMALL-BATCH-001) ===
# .claude/skills/run-*  = 자식별 run/verify launch recipe (실측: master=run-master · FND=run-foundation · SW=run-Selfward).
#   각 자식 한정 repo-local (L1-3 polyrepo · byte-identical 아님) → master→자식 cp 금지.
#   --prune EXCLUDE(PRUNE_EXCLUDE_PATHS · 동일 glob)는 역방향(orphan 오탐)만 막았고,
#   순방향 cp(--all find 자동 포착 + 명시 인자 양 경로)엔 가드 부재 → run-master 재seeding 사고.
#   실증: PROPAGATE-RUN-SKILL-RESEED-001 (incident-log · REPO-COUNT-VOCAB-SWEEP-001 중 자식 5 재seeding → 즉발 회수).
#   주의: glob `run-*` 는 하이픈 경계라 runtime-crash-mitigation 은 매칭 X (= verify-sync.sh DIFFERENTIATION-SCOPE-001 선례 동형).
if [ "${#FILES[@]}" -gt 0 ]; then
  FILTERED_FILES=()
  for f in "${FILES[@]}"; do
    case "$f" in
      .claude/skills/run-*)
        echo "[propagate] WARN: run-* recipe 제외 (= 자식 repo-local · byte-identical 아님 · cp skip): $f" >&2
        ;;
      *)
        FILTERED_FILES+=("$f")
        ;;
    esac
  done
  if [ "${#FILTERED_FILES[@]}" -gt 0 ]; then
    FILES=("${FILTERED_FILES[@]}")
  else
    FILES=()
  fi
fi

# === C15: --prune 모드 분기 (master 부재 파일 = 자식 자동 list / rm) ===
# - 본 모드 = 일반 cp 모드와 별개. cp 흐름 전 분기.
# - 입력 = master 의 propagate 대상 base path (find 가 master 에서 인덱스).
# - 자식의 같은 base path 안 파일 중 master 부재 = orphan → list 출력 (--apply 면 rm).
# - 안전: --prune --apply 가 명시 안 되면 dry-run 만 (rm 안 함).
if [ "$PRUNE_MODE" = 1 ]; then
  cd "$MASTER_DIR"
  # === 안전 정책 (whitelist) ===
  # default = .claude/ 만 prune 후보 (master 가 SoT 인 cli infra 영역)
  # 자식의 도메인 영역 (docs/, .ai/, scripts/agent/, app/) = 자율 영역 = prune 안 함
  # cli infra 외 영역 추가 = Coin 명시 의무 (= 본 whitelist 확장 = 본심 회수 사항 · cli 자율 확장 금지)
  #   ★구 주석은 여기서 "include <path> flag" 사용을 안내했으나 그 flag 는 파서에 없다 —
  #     실측 분기 4종뿐 = --all(:44) / --targets(:48) / --prune(:52) / --apply(:56) ·
  #     미지 flag 는 :64 의 -*) 분기가 exit 2 로 떨군다. 안내는 거짓이었고 정책만 참이었다.
  #   ★docs/ 영역 삭제 전파의 실제 경로 = docs/rules/cross-repo-parallel-exec-detail.md §5
  #     (= .claude/** 는 본 --prune --apply · docs/** 는 자식별 수동 git rm · 2단).
  #   (MASTER-PROPAGATION-HYGIENE-001 · 2026-08-23)
  PRUNE_BASE_PATHS=(.claude)
  PRUNE_ROOT_FILES=()  # root 파일 = 자식 build 영향 (gradlew 등) → default prune 제외
  PRUNE_EXCLUDE_NAMES=(.DS_Store settings.local.json)
  # path-glob EXCLUDE = basename 으로 표현 불가한 자식 repo-local 영역 (case-glob · '*' 는 '/' 포함 매칭)
  #   .claude/skills/run-*  = 자식별 run/verify recipe (실측: master=run-master · FND=run-foundation · SW=run-Selfward)
  #   = byte-identical 아님 · L1-3 polyrepo 자식 차별화 영역 (workflow-core.md Native run/verify integration)
  #   → master 부재가 정상(false-orphan) · basename=SKILL.md 라 PRUNE_EXCLUDE_NAMES 로 표현 불가
  #   주의: run-* subtree 만 제외 · 진짜 orphan(master SoT cli-infra file 자식 잔존분)은 여전히 검출
  PRUNE_EXCLUDE_PATHS=('.claude/skills/run-*')

  # target 해결
  if [ -z "$TARGETS" ] || [ "$TARGETS" = "all" ]; then
    PRUNE_TARGETS="$TARGET_REPOS"
  else
    PRUNE_TARGETS=""
    IFS=',' read -ra arr <<< "$TARGETS"
    for t in "${arr[@]}"; do
      case "$t" in
        GB) PRUNE_TARGETS="$PRUNE_TARGETS GentlyBreath" ;;
        GD) PRUNE_TARGETS="$PRUNE_TARGETS GentlyDay" ;;
        GT) PRUNE_TARGETS="$PRUNE_TARGETS GentlyTable" ;;
        FND) PRUNE_TARGETS="$PRUNE_TARGETS app-foundation" ;;
        *)  PRUNE_TARGETS="$PRUNE_TARGETS $t" ;;
      esac
    done
  fi

  echo "═══════════════════════════════════════════════════════"
  echo "[propagate --prune] master 부재 파일 = 자식 orphan 검색"
  echo "  master:    $MASTER_DIR"
  echo "  targets:   $PRUNE_TARGETS"
  echo "  mode:      $([ "$PRUNE_APPLY" = 1 ] && echo "APPLY (실제 rm)" || echo "DRY-RUN (list 만)")"
  echo "═══════════════════════════════════════════════════════"

  TOTAL_ORPHAN=0
  TOTAL_RM=0
  for repo in $PRUNE_TARGETS; do
    REPO_DIR="$PARENT_DIR/$repo"
    if [ ! -d "$REPO_DIR" ]; then
      echo "  $repo: SKIP (부재)"
      continue
    fi
    echo ""
    echo "--- $repo ---"
    REPO_ORPHAN=0

    # 자식의 base path 안 모든 파일 iterate
    for base in "${PRUNE_BASE_PATHS[@]}"; do
      [ -d "$REPO_DIR/$base" ] || continue
      while IFS= read -r f; do
        # exclude name 검사 (basename 정확일치)
        BN=$(basename "$f")
        SKIP=0
        for ex in "${PRUNE_EXCLUDE_NAMES[@]}"; do
          [ "$BN" = "$ex" ] && SKIP=1 && break
        done
        # exclude path-glob 검사 (자식 repo-local 영역 · basename 으로 표현 불가 · run-* subtree)
        if [ "$SKIP" = 0 ] && [ "${#PRUNE_EXCLUDE_PATHS[@]}" -gt 0 ]; then
          for exp in "${PRUNE_EXCLUDE_PATHS[@]}"; do
            # shellcheck disable=SC2254  # unquoted case pattern = glob 매칭 의도 ('*' 는 '/' 포함)
            case "$f" in
              $exp) SKIP=1; break ;;
            esac
          done
        fi
        [ "$SKIP" = 1 ] && continue
        # master 부재 여부
        if [ ! -f "$MASTER_DIR/$f" ]; then
          if [ "$PRUNE_APPLY" = 1 ]; then
            rm -f "$REPO_DIR/$f" && \
              (cd "$REPO_DIR" && git add "$f" 2>/dev/null) || true
            echo "  rm  $f"
            TOTAL_RM=$((TOTAL_RM+1))
          else
            echo "  orphan: $f"
          fi
          REPO_ORPHAN=$((REPO_ORPHAN+1))
        fi
      done < <(cd "$REPO_DIR" && find "$base" -type f 2>/dev/null)
    done

    # root 파일 검사 (= bash 3.x 측 `set -u` 측 0-array `"${arr[@]}"` unbound 영역 mitigation · 명시적 size check default)
    if [ "${#PRUNE_ROOT_FILES[@]}" -gt 0 ]; then
      for rf in "${PRUNE_ROOT_FILES[@]}"; do
        if [ -f "$REPO_DIR/$rf" ] && [ ! -f "$MASTER_DIR/$rf" ]; then
          if [ "$PRUNE_APPLY" = 1 ]; then
            rm -f "$REPO_DIR/$rf" && (cd "$REPO_DIR" && git add "$rf" 2>/dev/null) || true
            echo "  rm  $rf (root)"
            TOTAL_RM=$((TOTAL_RM+1))
          else
            echo "  orphan: $rf (root)"
          fi
          REPO_ORPHAN=$((REPO_ORPHAN+1))
        fi
      done
    fi

    echo "  요약: orphan=$REPO_ORPHAN"
    TOTAL_ORPHAN=$((TOTAL_ORPHAN+REPO_ORPHAN))
  done

  echo ""
  echo "═══════════════════════════════════════════════════════"
  if [ "$PRUNE_APPLY" = 1 ]; then
    echo "[propagate --prune --apply] 총 orphan $TOTAL_ORPHAN / 실제 rm $TOTAL_RM"
    echo "  자식 repo 별 git status 검토 + commit 의무"
  else
    echo "[propagate --prune] 총 orphan $TOTAL_ORPHAN (DRY-RUN · 실제 rm 없음)"
    echo "  실제 rm = --apply flag 추가: bash scripts/propagate.sh --prune --apply"
  fi
  echo "═══════════════════════════════════════════════════════"
  exit 0
fi

if [ "${#FILES[@]}" = 0 ]; then
  echo "[propagate] ERROR: 파일 미지정. --all 또는 명시적 path 필요." >&2
  exit 2
fi

# === BASELINE 검증: 보호 파일 5종 (manifest 동적 reference · stale-hardcode 폐기) ===
# EXPECTED = .auto-memory/protected-file-hashes.md 측 sha-256 row 동적 parse (= 직전 stale hardcode heredoc 폐기 · manifest 단일 source).
# ACTUAL   = 동일 5 보호 file 측 live shasum. 두 baseline 불일치 시에만 WARN = 실 (manifest ≠ live-disk) drift 신호 (= stale-hardcode noise 제거 · WARN-only non-blocking 보존).
# 보호 file list = verify-sync.sh PROTECTED 배열 정합 (5종 · design-sot-policy.md 포함).
cd "$MASTER_DIR"
PROTECTED_MANIFEST=".auto-memory/protected-file-hashes.md"
PROTECTED_BASELINE_FILES=(
  docs/schemas/ui-spec.schema.json
  docs/rules/pencil-uiux-workflow.md
  docs/design/pencil-sot-policy.md
  docs/rules/uiux-sot-refresh.md
  docs/design/design-sot-policy.md
)
EXPECTED_BASELINE=$(for f in "${PROTECTED_BASELINE_FILES[@]}"; do
  msha=$(grep -F "\`$f\`" "$PROTECTED_MANIFEST" 2>/dev/null | grep -oE '[a-f0-9]{64}' | head -1 || true)
  printf '%s  %s\n' "$msha" "$f"
done)
ACTUAL_BASELINE=$(for f in "${PROTECTED_BASELINE_FILES[@]}"; do
  shasum -a 256 "$f" 2>/dev/null
done)
if [ "$EXPECTED_BASELINE" != "$ACTUAL_BASELINE" ]; then
  echo "[propagate] WARN: 보호 파일 baseline 변경 감지 (manifest ≠ live-disk). .auto-memory/protected-file-hashes.md 갱신 의무." >&2
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

# === C14: .gitignore patches 자동 보장 (자식 .gitignore 가 master cli infra patterns 포함) ===
if [ -x "$MASTER_DIR/scripts/ensure-child-gitignore-patches.sh" ]; then
  echo ""
  echo "[propagate] .gitignore patches 보장 (C14):"
  PARENT_DIR="$PARENT_DIR" TARGET_REPOS="$TARGET_REPOS" \
    bash "$MASTER_DIR/scripts/ensure-child-gitignore-patches.sh" || \
    echo "  (warning) ensure-child-gitignore-patches.sh 실패 — 본 propagation 영향 X"
fi

if [ "$TOTAL_FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
