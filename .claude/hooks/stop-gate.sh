#!/bin/bash
# Stop hook — 품질 게이트
# implement 단계 이상 진행된 태스크에 VERIFY 또는 REVIEW 가 없으면 완료를 차단
# silent-success: 모든 태스크가 clean 이면 무출력. 차단 시에만 발화.
# macOS bash 3.x 호환
#
# 판정 기준:
#   PLAN.md + EVIDENCE.md 존재 → implement 이상 진행된 태스크로 간주
#   → VERIFY.md 또는 REVIEW.md 없으면 exit 2 (완료 차단)
#   → EVIDENCE.md 에 '## Cleanup Assessment' 없으면 exit 2 (완료 차단)
#
# Exit code policy: exit 0=pass / exit 1=internal error / exit 2=blocking
#   exit 0=pass (완료 허용)
#   exit 1=internal error (환경/권한/파일 읽기 실패 등 — stderr 에 사유 1 줄)
#   exit 2=blocking (Claude Code 가 계속 응답하도록 차단)
#
# 범위 한정 + 주석↔exit 정합 (MASTER-CLI-JUDGMENT-SHIFT-001 · 2026-07-29):
#   (1) 구 판은 `.ai/reports/` **전체**를 순회했다 — 몇 달 전 미완 task 1 건이 이후 모든 세션의 Stop 을
#       영구 차단하는 구조였고, 게이트가 지목하는 대상은 이번 세션이 손대지도 않은 task 였다.
#       → SessionStart 가 남기는 `.ai/hooks/.session-marker` 보다 새로 변경된 task 만 대상으로 한다.
#          marker 부재 시(hook 미실행 등) = 구 전수 순회로 fallback — 게이트가 조용히 사라지지 않게.
#   (2) Cleanup 분기는 주석이 "exit 2 (완료 차단)" 이라 선언하면서 실제로는 `exit 1` 을 반환했다.
#       같은 파일이 exit 1 을 "internal error" 로 정의하므로, 정책 위반을 내부 오류로 신고하는 셈이었고
#       차단도 되지 않았다(= 선언된 게이트가 실재하지 않음). → exit 2 로 정합. 범위가 현 세션으로
#       좁혀졌으므로 차단이 실제로 고칠 수 있는 사람 앞에서만 발생한다.

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
cd "$REPO_ROOT" || exit 0

REPORTS_DIR=".ai/reports"

if [ ! -d "$REPORTS_DIR" ]; then
    exit 0
fi

# 검사 대상 = 현 세션에 변경된 task dir (marker 기준). marker 없으면 전수.
SESSION_MARKER=".ai/hooks/.session-marker"
SCOPED_DIRS=""
if [ -f "$SESSION_MARKER" ]; then
    SCOPED_DIRS=$(find "$REPORTS_DIR" -mindepth 1 -maxdepth 1 -type d -newer "$SESSION_MARKER" 2>/dev/null)
    # 대상 0 = 이번 세션이 건드린 task 없음 = 게이트할 것 없음
    [ -z "$SCOPED_DIRS" ] && exit 0
else
    SCOPED_DIRS=$(find "$REPORTS_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
fi

BLOCKED_TASKS=""
CLEANUP_MISSING=""

for TASK_DIR_RAW in $SCOPED_DIRS; do
    TASK_DIR="${TASK_DIR_RAW%/}/"
    [ -d "$TASK_DIR" ] || continue

    TASK_ID=$(basename "$TASK_DIR")

    # PLAN.md + EVIDENCE.md 가 모두 있으면 implement 이상 진행된 태스크
    if [ -f "${TASK_DIR}PLAN.md" ] && [ -f "${TASK_DIR}EVIDENCE.md" ]; then
        MISSING=""

        if [ ! -f "${TASK_DIR}VERIFY.md" ]; then
            MISSING="${MISSING} VERIFY.md"
        fi

        if [ ! -f "${TASK_DIR}REVIEW.md" ]; then
            MISSING="${MISSING} REVIEW.md"
        fi

        if [ -n "$MISSING" ]; then
            BLOCKED_TASKS="${BLOCKED_TASKS}  - ${TASK_ID}: 누락=${MISSING}\n"
        fi

        # cleanup assessment 점검 — 리뷰 전 단계(REVIEW.md 없음)에서만 검사
        # 예외: 신규 기능 또는 ops-layer task인 경우 skip
        if [ ! -f "${TASK_DIR}REVIEW.md" ]; then
            TASK_FILE=".ai/tasks/${TASK_ID}.md"
            SKIP_CLEANUP=0

            # 신규 기능 여부 확인 (.ai/tasks/<taskId>.md에서 type: new-feature 또는 type: NEW 검색)
            if [ -f "$TASK_FILE" ]; then
                if grep -qi "type:.*new" "$TASK_FILE" 2>/dev/null; then
                    SKIP_CLEANUP=1
                fi
            fi

            # EVIDENCE.md에서 신규 구현 또는 new feature 확인
            if grep -qi "신규 구현\|new feature" "${TASK_DIR}EVIDENCE.md" 2>/dev/null; then
                SKIP_CLEANUP=1
            fi

            # cleanup assessment 검사 (신규 기능이 아닌 경우만)
            if [ $SKIP_CLEANUP -eq 0 ]; then
                if ! grep -qi "cleanup assessment" "${TASK_DIR}EVIDENCE.md" 2>/dev/null; then
                    CLEANUP_MISSING="${CLEANUP_MISSING}  - ${TASK_ID}: EVIDENCE.md에 '## Cleanup Assessment' 섹션 없음\n"
                fi
            fi
        fi
    fi
done

# auto-memory incident-log append helper (Cycle 16)
# blocking 시 .auto-memory/incident-log.md 에 record append
append_incident() {
    INCIDENT_LOG=".auto-memory/incident-log.md"
    [ -f "$INCIDENT_LOG" ] || return 0
    TS=$(date '+%Y-%m-%dT%H:%M:%S%z')
    {
        echo ""
        echo "## $TS"
        echo "- type: $1"
        printf "%b" "$2" | sed 's/^/- /'
    } >> "$INCIDENT_LOG"
}

if [ -n "$BLOCKED_TASKS" ]; then
    echo "" >&2
    echo "[STOP-GATE] implement 단계 태스크에 VERIFY 또는 REVIEW 미완료:" >&2
    printf "%b" "$BLOCKED_TASKS" >&2
    echo "" >&2
    echo "  /verify 와 /review 단계를 완료하거나" >&2
    echo "  BLOCKED/STOP 사유를 VERIFY.md에 기록하세요." >&2
    echo "  규칙: docs/rules/verification-and-review.md" >&2
    echo "" >&2
    append_incident "blocked-tasks" "$BLOCKED_TASKS"
    exit 2
fi

if [ -n "$CLEANUP_MISSING" ]; then
    echo "" >&2
    echo "[STOP-GATE:CLEANUP] Cleanup Assessment 누락 (리뷰 전 implement task):" >&2
    printf "%b" "$CLEANUP_MISSING" >&2
    echo "" >&2
    echo "  EVIDENCE.md 에 '## Cleanup Assessment' 섹션을 추가하세요." >&2
    echo "  code-level task: 실제 cleanup 점검 결과를 기록하세요." >&2
    echo "  ops-layer task: 'N/A (ops-layer task)' 로 명시하세요." >&2
    echo "  규칙: docs/rules/legacy-cleanup-governance.md" >&2
    echo "" >&2
    append_incident "cleanup-missing" "$CLEANUP_MISSING"
    exit 2
fi

exit 0
