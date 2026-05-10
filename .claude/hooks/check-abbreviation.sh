#!/usr/bin/env bash
# .claude/hooks/check-abbreviation.sh
# PreToolUse hook — matcher: Edit|Write
# Enforces no-abbreviation policy on source code files.
#
# Mode (env var NO_ABBREV_ENFORCE):
#   warn    (default, Cycle 1~3) — warn to stderr, always exit 0
#   enforce (Cycle 4+ upgrade)   — block with exit 2 on violation
#
# Policy SoT: .claude/rules/no-abbreviation-policy.md
# Forbidden:  .claude/rules/forbidden-abbreviations.md
# Allowed:    .claude/rules/allowed-acronyms.md
#
# macOS bash 3.x compatible — no associative arrays, no ${var,,}

set -uo pipefail

: "${NO_ABBREV_ENFORCE:=warn}"

INPUT="$(cat 2>/dev/null || echo '')"
[ -z "$INPUT" ] && exit 0

# --- Python3 analysis (camelCase-aware forbidden check) ---
ANALYSIS=$(ABBREV_INPUT="$INPUT" python3 - << 'PYEOF'
import os, json, re, sys

raw = os.environ.get("ABBREV_INPUT", "")
if not raw:
    sys.exit(0)

try:
    data = json.loads(raw)
except Exception:
    sys.exit(0)

tool_name = data.get("tool_name", "")
tool_input = data.get("tool_input", {})

if tool_name == "Write":
    content = tool_input.get("content", "")
    file_path = tool_input.get("file_path", "")
elif tool_name == "Edit":
    content = tool_input.get("new_string", "")
    file_path = tool_input.get("file_path", "")
else:
    sys.exit(0)

if not content or not file_path:
    sys.exit(0)

# Only check source code files
CODE_EXTS = {
    '.kt', '.java', '.py', '.swift', '.ts', '.tsx',
    '.js', '.jsx', '.cpp', '.c', '.h', '.go', '.rs'
}
import os.path as osp
_, ext = osp.splitext(file_path.lower())
if ext not in CODE_EXTS:
    sys.exit(0)

# Forbidden token list (subset of seed list — excludes clear language keywords).
# Language keywords (val, var, fun, fn, init, func) are excluded here
# because they appear structurally in Kotlin/Swift/Go/Rust as syntax.
# See forbidden-abbreviations.md §3 for full exclusion rationale.
FORBIDDEN_CHECK = [
    "btn", "msg", "cfg", "idx", "ctx", "cnt", "tmp", "usr", "pwd",
    "fnc", "mgr", "svc", "ctrl", "hdlr", "obj", "arr", "lst",
    "prev", "curr", "nxt", "prv", "req", "resp",
    "attr", "attrs", "prop", "props", "opts", "conf",
    "calc", "proc", "hlpr", "vm", "vw", "frag", "srv",
    # Context-dependent (may produce false positives — reviewed in Cycle 2-4):
    "err", "ret", "res", "num", "str", "args", "params",
    "info", "gen", "util", "utils", "helper", "repo", "db", "dict", "act",
]

# Limit content size to avoid performance issues on large files
content = content[:50000]

hits = []
for lineno, line in enumerate(content.split('\n'), 1):
    stripped = line.strip()
    if not stripped:
        continue
    # Skip comment lines
    if any(stripped.startswith(prefix) for prefix in ('//', '#', '*', '/*', '<!--', '*/')):
        continue

    for token in FORBIDDEN_CHECK:
        title = token[0].upper() + token[1:]
        # Pattern 1: standalone / camelCase prefix
        #   e.g., 'btn' in 'val btn', 'val btnClick'
        #   (?<![A-Za-z0-9_]) = not preceded by word char
        #   (?![a-z0-9_])     = not followed by lowercase/digit/underscore
        # Pattern 2: camelCase middle/end
        #   e.g., 'Msg' in 'userMsg'
        #   (?<=[a-z]) = preceded by lowercase letter
        #   (?![a-z])  = not followed by lowercase
        pattern = (
            r'(?<![A-Za-z0-9_])' + re.escape(token) + r'(?![a-z0-9_])'
            + r'|(?<=[a-z])' + re.escape(title) + r'(?![a-z])'
        )
        if re.search(pattern, line):
            hits.append((lineno, token, stripped[:80]))
            break  # one hit per line is sufficient

if hits:
    total = len(hits)
    # Output structured result: first line is summary, rest are details
    print("FORBIDDEN:{}:{}".format(total, file_path))
    for lineno, token, preview in hits[:5]:
        print("  L{}:'{}': {}".format(lineno, token, preview))
    if total > 5:
        print("  ...and {} more".format(total - 5))

PYEOF
)

PYTHON_EC=$?

# Python error → let through
if [ $PYTHON_EC -ne 0 ] && [ -z "$ANALYSIS" ]; then
    exit 0
fi

# Check if violations were found
if echo "$ANALYSIS" | grep -q "^FORBIDDEN:"; then
    SUMMARY_LINE=$(echo "$ANALYSIS" | grep "^FORBIDDEN:" | head -1)
    COUNT=$(echo "$SUMMARY_LINE" | cut -d: -f2)
    FILE_PATH=$(echo "$SUMMARY_LINE" | cut -d: -f3-)
    DETAILS=$(echo "$ANALYSIS" | grep -v "^FORBIDDEN:")

    BLOCK_MSG="[NO-ABBREV] ${COUNT} forbidden abbreviation(s) in ${FILE_PATH}
${DETAILS}
→ Policy: .claude/rules/no-abbreviation-policy.md
→ Seed:   .claude/rules/forbidden-abbreviations.md
→ Action: use full descriptive names instead of abbreviations"

    if [ "$NO_ABBREV_ENFORCE" = "enforce" ]; then
        printf '%s\n' "$BLOCK_MSG" >&2
        exit 2
    else
        # warn mode: print warning, allow the operation
        printf '[NO-ABBREV:WARN] (mode=warn) %s hit(s) in %s\n' "$COUNT" "$FILE_PATH" >&2
        printf '%s\n' "$DETAILS" | head -5 >&2
        printf '  (upgrade to enforce: export NO_ABBREV_ENFORCE=enforce)\n' >&2
    fi
fi

exit 0
