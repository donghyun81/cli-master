#!/bin/bash
# baseline-snapshot.sh — SessionStart hook
# 목적: 7-repo (claude-cli-master + Gently 3 + Proto 3) HEAD + cycle-discipline.md sha +
#       보호 파일 5종 sha + settings.json sha 자동 측정 +
#       .ai/baseline-snapshot/<timestamp>.json 출력 + latest.json 복사.
# 신설: MASTER-COWORK-HANDOFF-BASELINE-AUTOVERIFY-HOOK-001 (2026-05-12)
# 관련: .claude/rules/cycle-discipline.md §14a (Cowork prep ↔ CLI baseline 동기화 6 의무 절차)
# 동작: 비차단 (warn-only · exit 0).
# self-test: bash .claude/hooks/baseline-snapshot.sh

set -u

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
SNAPSHOT_DIR="$PROJECT_DIR/.ai/baseline-snapshot"
mkdir -p "$SNAPSHOT_DIR" 2>/dev/null

TIMESTAMP=$(date +"%Y%m%dT%H%M%S%z")
OUT_FILE="$SNAPSHOT_DIR/${TIMESTAMP}.json"
LATEST_FILE="$SNAPSHOT_DIR/latest.json"

PARENT_DIR="$(dirname "$PROJECT_DIR")"

REPOS=(
  "claude-cli-master"
  "GentlyBreath"
  "GentlyDay"
  "GentlyTable"
  "ProtoGentlyBreath"
  "ProtoGentlyDay"
  "ProtoGentlyTable"
)

PROTECTED_FILES=(
  "docs/schemas/ui-spec.schema.json"
  ".claude/rules/pencil-uiux-workflow.md"
  "docs/design/pencil-sot-policy.md"
  ".claude/rules/uiux-sot-refresh.md"
  "docs/design/design-sot-policy.md"
)

CYCLE_DISCIPLINE_PATH=".claude/rules/cycle-discipline.md"
SETTINGS_PATH=".claude/settings.json"

sha_of() {
  local f="$1"
  if [ -f "$f" ]; then
    shasum -a 256 "$f" 2>/dev/null | awk '{print $1}'
  else
    echo "MISSING"
  fi
}

head_of() {
  local d="$1"
  if [ -d "$d/.git" ]; then
    (cd "$d" && git rev-parse HEAD 2>/dev/null) || echo "MISSING"
  else
    echo "MISSING"
  fi
}

{
  printf '{\n'
  printf '  "timestamp": "%s",\n' "$TIMESTAMP"
  printf '  "projectDir": "%s",\n' "$PROJECT_DIR"
  printf '  "parentDir": "%s",\n' "$PARENT_DIR"
  printf '  "repos": {\n'

  repo_count=${#REPOS[@]}
  i=0
  for repo in "${REPOS[@]}"; do
    i=$((i+1))
    REPO_PATH="$PARENT_DIR/$repo"
    HEAD_SHA=$(head_of "$REPO_PATH")
    CYCLE_SHA=$(sha_of "$REPO_PATH/$CYCLE_DISCIPLINE_PATH")
    SETTINGS_SHA=$(sha_of "$REPO_PATH/$SETTINGS_PATH")

    printf '    "%s": {\n' "$repo"
    printf '      "path": "%s",\n' "$REPO_PATH"
    printf '      "head": "%s",\n' "$HEAD_SHA"
    printf '      "cycleDisciplineSha": "%s",\n' "$CYCLE_SHA"
    printf '      "settingsSha": "%s",\n' "$SETTINGS_SHA"
    printf '      "protectedFiles": {\n'

    pf_count=${#PROTECTED_FILES[@]}
    j=0
    for pf in "${PROTECTED_FILES[@]}"; do
      j=$((j+1))
      PF_SHA=$(sha_of "$REPO_PATH/$pf")
      if [ "$j" -lt "$pf_count" ]; then
        printf '        "%s": "%s",\n' "$pf" "$PF_SHA"
      else
        printf '        "%s": "%s"\n' "$pf" "$PF_SHA"
      fi
    done

    printf '      }\n'
    if [ "$i" -lt "$repo_count" ]; then
      printf '    },\n'
    else
      printf '    }\n'
    fi
  done

  printf '  }\n'
  printf '}\n'
} > "$OUT_FILE"

cp "$OUT_FILE" "$LATEST_FILE" 2>/dev/null

# Drift detection (cli-master 측 cycle-discipline.md sha 가 자식과 다른 경우 stderr 경고)
MASTER_CYCLE=$(grep -A 4 '"claude-cli-master"' "$OUT_FILE" | grep cycleDisciplineSha | head -1 | sed -E 's/.*"([a-f0-9]{64}|MISSING)".*/\1/')
DRIFT_COUNT=0
DRIFT_LIST=""
for child in GentlyBreath GentlyDay GentlyTable; do
  CHILD_CYCLE=$(grep -A 4 "\"$child\"" "$OUT_FILE" | grep cycleDisciplineSha | head -1 | sed -E 's/.*"([a-f0-9]{64}|MISSING)".*/\1/')
  if [ -n "$CHILD_CYCLE" ] && [ "$CHILD_CYCLE" != "$MASTER_CYCLE" ] && [ "$CHILD_CYCLE" != "MISSING" ]; then
    DRIFT_COUNT=$((DRIFT_COUNT+1))
    DRIFT_LIST="$DRIFT_LIST $child"
  fi
done

if [ "$DRIFT_COUNT" -gt 0 ]; then
  echo "[baseline-snapshot] DRIFT cycle-discipline.md mismatch:$DRIFT_LIST (master=$MASTER_CYCLE)" >&2
  echo "[baseline-snapshot] snapshot: $LATEST_FILE" >&2
fi

exit 0
