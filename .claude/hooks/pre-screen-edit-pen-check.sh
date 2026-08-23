#!/usr/bin/env bash
# .claude/hooks/pre-screen-edit-pen-check.sh
# PreToolUse hook — matcher: Edit|Write
# Enforces Pencil SoT entry gate: `*Screen.kt` Edit/Write requires `.pen` existence.
#
# Mode (env var PEN_CHECK_ENFORCE):
#   warn    (default) — warn to stderr, always exit 0
#   enforce — block with exit 2 on .pen absence
#
# Mapping paradigm (basename → screen-name):
#   `*Screen.kt` or `*Screens.kt` basename → strip "Screen(s)" suffix → PascalCase → kebab-case
#   Example: HomeScreen.kt → home / DailyPrescriptionScreen.kt → daily-prescription /
#            JournalScreens.kt → journal
#
# Path checked: `docs/design/pencil-sot/<screen>/<screen>.pen` (cwd-relative)
#
# Reference SoT:
#   - docs/design/pencil-sot-policy.md §1 (SoT 우선순위)
#   - docs/rules/pencil-uiux-workflow.md §3 (5-type IMPL 흐름 · Type 2 / Phase R)
#   - (구) 화면명 매핑표 = 2026-08-23 MASTER-AIDOC-RELEASE-REALIGN-001 은퇴 (동결 3 전용 · 활성 자식 섹션 0)
#     → 원문 = master .auto-memory/ COLD verbatim · 현행 명명 차이 판정 = docs/design/pencil-sot/ 직접 조회
#
# Neutralization:
#   - master repo (claude-cli-master) = cli infra source · `*Screen.kt` 무존재 default · matcher 자연 skip
#   - 매핑 mismatch 시 (예: BreathScreen.kt ↔ breathing-screen.pen) = warn default · 명명 차이 자체는 여전히 정상 (= 부재로 단정 금지)
#
# macOS bash 3.x 호환 (associative array X / ${var,,} X).

set -uo pipefail

: "${PEN_CHECK_ENFORCE:=warn}"

INPUT="$(cat 2>/dev/null || echo '')"
[ -z "$INPUT" ] && exit 0

ANALYSIS=$(PEN_CHECK_INPUT="$INPUT" python3 - << 'PYEOF'
import os, json, re, sys

raw = os.environ.get("PEN_CHECK_INPUT", "")
if not raw:
    sys.exit(0)

try:
    data = json.loads(raw)
except Exception:
    sys.exit(0)

tool_name = data.get("tool_name", "")
tool_input = data.get("tool_input", {})

if tool_name not in ("Edit", "Write"):
    sys.exit(0)

file_path = tool_input.get("file_path", "")
if not file_path:
    sys.exit(0)

import os.path as osp

# Match only `*Screen.kt` or `*Screens.kt` (singular or plural · 명명 차이 영역)
basename = osp.basename(file_path)
match = re.match(r'^([A-Z][A-Za-z0-9]*?)Screens?\.kt$', basename)
if not match:
    sys.exit(0)

# Skip build / generated / test paths
_SKIP_PATH_SEGS = ('build/', '.gradle/', 'generated/', '/test/', '/androidTest/', '/commonTest/')
if any(seg in file_path for seg in _SKIP_PATH_SEGS):
    sys.exit(0)

# Map: PascalCase basename (Screen[s] stripped) → kebab-case
# Example: "Home" → "home", "DailyPrescription" → "daily-prescription"
stem = match.group(1)
kebab = re.sub(r'(?<!^)(?=[A-Z])', '-', stem).lower()

# Resolve cwd-relative .pen candidate path
cwd = os.getcwd()
candidate = osp.join(cwd, "docs", "design", "pencil-sot", kebab, kebab + ".pen")

if osp.isfile(candidate):
    sys.exit(0)

# Output structured result: kebab screen-name + originating file_path + candidate
print("ABSENT:{}:{}".format(kebab, file_path))
print("  candidate: {}".format(candidate))

PYEOF
)

PYTHON_EC=$?

# Python error → let through
if [ $PYTHON_EC -ne 0 ] && [ -z "$ANALYSIS" ]; then
    exit 0
fi

# Check if .pen absence detected
if echo "$ANALYSIS" | grep -q "^ABSENT:"; then
    SUMMARY_LINE=$(echo "$ANALYSIS" | grep "^ABSENT:" | head -1)
    SCREEN_NAME=$(echo "$SUMMARY_LINE" | cut -d: -f2)
    FILE_PATH=$(echo "$SUMMARY_LINE" | cut -d: -f3-)
    DETAILS=$(echo "$ANALYSIS" | grep -v "^ABSENT:")

    BLOCK_MSG="[PEN-CHECK] Pencil SoT (.pen) absent for screen '${SCREEN_NAME}'
File: ${FILE_PATH}
${DETAILS}
→ Policy: docs/design/pencil-sot-policy.md §1 (SoT 우선순위)
→ Flow:   docs/rules/pencil-uiux-workflow.md §3 (Type 2 신규 또는 Phase R 역공학)
→ Action: 신 .pen 신설 (Type 2) 또는 역공학 (Phase R) 진입 후 Compose 변경 진행
→ Note:   SoT 화면명 ↔ 코드 file 명은 다를 수 있다 (예: breathing-screen.pen ↔ BreathScreen.kt).
            부재로 단정하기 전에 docs/design/pencil-sot/ 를 직접 훑어라."

    if [ "$PEN_CHECK_ENFORCE" = "enforce" ]; then
        printf '%s\n' "$BLOCK_MSG" >&2
        exit 2
    else
        printf '[PEN-CHECK:WARN] (mode=warn) .pen absent for %s\n' "$SCREEN_NAME" >&2
        printf '%s\n' "$DETAILS" >&2
        printf '  → Policy: docs/design/pencil-sot-policy.md §1\n' >&2
        printf '  → Flow:   docs/rules/pencil-uiux-workflow.md §3 (Type 2 / Phase R)\n' >&2
        printf '  → Map:    SoT 화면명 ↔ file 명 차이 가능 — docs/design/pencil-sot/ 직접 조회\n' >&2
        printf '  (upgrade to enforce: export PEN_CHECK_ENFORCE=enforce)\n' >&2
    fi
fi

exit 0
