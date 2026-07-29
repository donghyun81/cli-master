#!/usr/bin/env bash
# scripts/pencil-pending-sweep.sh
# Sweep all `<repo>/docs/design/pencil-sot/*/*.ui-spec.json` and report
# entries where `lastSyncedDesignToolStateHash` is PENDING or 64-zero placeholder.
#
# 운영 paradigm:
#   - 매뉴얼 호출 default (= 사용자 cli session 측 자율 진입 default)
#   - cron / launchd / scheduled task 정착 = 별 cycle 분리 default
#     (= `MASTER-CLI-PENCIL-PENDING-SWEEP-AUTOMATION-NNN` 후속 영역)
#   - 매 master cycle 마감 시점 sweep 권장 (= H27 사고 mitigation paradigm 정합)
#
# Trail:
#   - 결과 보고 = stdout + 별 trail `claude-cli-master/.auto-memory/pencil-pending-status.md` 갱신
#   - 누적 추적 paradigm = trail append default (= history 영역 보존)
#
# Exit code:
#   - 0 = sweep 마감 (= PENDING 0+ · informational default)
#   - 1 = repo scan FAIL (= cli session 측 회수 의무)
#
# Reference SoT:
#   - docs/rules/pencil-uiux-workflow.md §3 (5-type IMPL · Type 1 drift 정정)
#   - docs/design/pencil-sot-policy.md §1 (SoT 우선순위 · lastSyncedDesignToolStateHash field)
#   - docs/schemas/ui-spec.schema.json (= structural SoT schema)
#
# macOS bash 3.x 호환.

set -uo pipefail

# Resolve mount root (= 부모 mount root default).
# Default: /Users/yundonghyeon/AndroidStudioProjects (= 본 cycle baseline).
# Override: env var `PARENT_MOUNT_ROOT` 측 절대 path measurement.
: "${PARENT_MOUNT_ROOT:=/Users/yundonghyeon/AndroidStudioProjects}"

# 4-active scan target (= 2026-07-17 T6 재편 정합 · gently-product-docs = pencil-sot dir 부재 → graceful skip).
# 활성 `.pen` 보유 = Selfward (실측 2026-07-29: SW 14). 동결 3(GB/GD/GT)은 쓰기 0 = sweep 대상 X.
REPOS=("claude-cli-master" "app-foundation" "gently-product-docs" "Selfward")

# Trail target (= cli-master 단일 default).
TRAIL_REPO="claude-cli-master"
TRAIL_PATH="${PARENT_MOUNT_ROOT}/${TRAIL_REPO}/.auto-memory/pencil-pending-status.md"

# Timestamp (KST).
TS_KST="$(TZ='Asia/Seoul' date '+%Y-%m-%d %H:%M:%S KST')"
TS_ANCHOR="$(TZ='Asia/Seoul' date '+%Y-%m-%dT%H:%M:%S%z')"

# PENDING detection regex (= JSON value 측정 paradigm).
# Patterns:
#   1. "lastSyncedDesignToolStateHash": "PENDING_..." (= placeholder default)
#   2. "lastSyncedDesignToolStateHash": "0000...0000" (= 64-zero default)
PENDING_REGEX='"lastSyncedDesignToolStateHash"[[:space:]]*:[[:space:]]*"(PENDING|0000000000000000000000000000000000000000000000000000000000000000)'

# Aggregate counters.
TOTAL_SPECS=0
TOTAL_PENDING=0
PENDING_LIST=""

echo "=== Pencil PENDING sweep · ${TS_KST} ==="
echo "mount root: ${PARENT_MOUNT_ROOT}"
echo

for repo in "${REPOS[@]}"; do
    base="${PARENT_MOUNT_ROOT}/${repo}/docs/design/pencil-sot"

    if [ ! -d "$base" ]; then
        printf "%-20s (no pencil-sot dir · skip)\n" "$repo"
        continue
    fi

    # Find all ui-spec.json under base.
    specs=$(find "$base" -name "*.ui-spec.json" -type f 2>/dev/null)
    spec_count=0
    pending_count=0
    repo_pending=""

    for spec in $specs; do
        spec_count=$((spec_count + 1))
        if grep -E "$PENDING_REGEX" "$spec" > /dev/null 2>&1; then
            pending_count=$((pending_count + 1))
            # Extract value sample (first match · 80 char preview).
            value=$(grep -E "$PENDING_REGEX" "$spec" | head -1 | sed -E 's/.*"lastSyncedDesignToolStateHash"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/' | cut -c1-40)
            relative="${spec#${PARENT_MOUNT_ROOT}/}"
            repo_pending="${repo_pending}  - ${relative} (= ${value})\n"
            PENDING_LIST="${PENDING_LIST}| ${repo} | ${relative} | ${value} |\n"
        fi
    done

    printf "%-20s %d specs · %d PENDING\n" "$repo" "$spec_count" "$pending_count"
    if [ "$pending_count" -gt 0 ]; then
        printf "$repo_pending"
    fi

    TOTAL_SPECS=$((TOTAL_SPECS + spec_count))
    TOTAL_PENDING=$((TOTAL_PENDING + pending_count))
done

echo
echo "=== Summary ==="
echo "Total specs scanned:  ${TOTAL_SPECS}"
echo "Total PENDING found:  ${TOTAL_PENDING}"
echo

# Append trail entry (= history 누적 보존 default).
if [ ! -d "$(dirname "$TRAIL_PATH")" ]; then
    printf "WARN: trail directory missing: %s · skip trail append\n" "$(dirname "$TRAIL_PATH")" >&2
else
    # Bootstrap header if trail file absent (= check BEFORE redirect open · `>>` 측 file 신설 측정 회피).
    if [ ! -f "$TRAIL_PATH" ]; then
        {
            echo "# Pencil PENDING sweep trail (= history 누적 보존)"
            echo
            echo "> **신설**: MASTER-CLI-PENCIL-FLOW-ENFORCE-001 (2026-05-19)"
            echo "> **본 trail 본질** = \`scripts/pencil-pending-sweep.sh\` 측 매뉴얼 호출 결과 누적 보존 영역 default."
            echo "> 매 master cycle 마감 시점 sweep 권장 default (= 별 cycle 자동화 분리 영역)."
            echo
        } > "$TRAIL_PATH"
    fi
    {
        echo "---"
        echo
        echo "## ${TS_ANCHOR}"
        echo
        echo "- Total specs scanned: ${TOTAL_SPECS}"
        echo "- Total PENDING found: ${TOTAL_PENDING}"
        if [ "$TOTAL_PENDING" -gt 0 ]; then
            echo
            echo "| repo | path | lastSyncedDesignToolStateHash (preview) |"
            echo "|---|---|---|"
            printf "$PENDING_LIST"
        else
            echo "- PENDING 0 = clean baseline ✓"
        fi
        echo
    } >> "$TRAIL_PATH"
    echo "Trail appended: ${TRAIL_PATH}"
fi

exit 0
