#!/usr/bin/env bash
# .claude/hooks/pre-protected-file-edit-sha-verify.sh
# PreToolUse hook — matcher: Edit|Write
# A2 anchor (Protected file integrity guard) deterministic enforcement layer.
#
# Purpose:
#   Before Edit/Write touches one of the 5 protected files (cli infra byte-identical
#   invariants across 6-repo), surface a warning so cli session escalates to a
#   master cycle (per .claude/rules/cycle-discipline.md §3 + §10) rather than
#   editing in-place. In enforce mode, block the tool call with structured JSON
#   deny output.
#
# Mode (env var PROTECTED_FILE_EDIT_ENFORCE):
#   warn    (default) — warn to stderr, always exit 0
#   enforce — protected file edit detected → exit 2 + JSON deny (per Anthropic Hooks docs)
#
# Protected file list (explicit · matches .auto-memory/protected-file-hashes.md SoT):
#   - docs/schemas/ui-spec.schema.json
#   - .claude/rules/pencil-uiux-workflow.md
#   - docs/design/pencil-sot-policy.md
#   - .claude/rules/uiux-sot-refresh.md
#   - docs/design/design-sot-policy.md
#
# Reference SoT:
#   - .claude/rules/anchor-list.md §2 A2 (Protected file integrity guard)
#   - .auto-memory/protected-file-hashes.md (보호 5 file sha-256 baseline SoT)
#   - .claude/rules/cycle-discipline.md §3 (3-repo byte-identical 강제 범위) + §10 (보호 file 변경 의무)
#   - .claude/rules/safety-and-secrets.md (시크릿 + 비가역 변경 STOP)
#
# Precedent:
#   - .claude/hooks/pre-screen-edit-pen-check.sh (matcher=Edit|Write · path-based check · bash+python heredoc)
#
# macOS bash 3.x 호환 (associative array X / ${var,,} X).

set -uo pipefail

: "${PROTECTED_FILE_EDIT_ENFORCE:=warn}"

INPUT="$(cat 2>/dev/null || echo '')"
[ -z "$INPUT" ] && exit 0

ANALYSIS=$(PFE_INPUT="$INPUT" python3 - << 'PYEOF'
import os, json, sys

raw = os.environ.get("PFE_INPUT", "")
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

# Protected files — match on path suffix (handles both absolute and relative paths).
PROTECTED = [
    "docs/schemas/ui-spec.schema.json",
    ".claude/rules/pencil-uiux-workflow.md",
    "docs/design/pencil-sot-policy.md",
    ".claude/rules/uiux-sot-refresh.md",
    "docs/design/design-sot-policy.md",
]

# Normalize: strip leading "./" if present.
norm = file_path
if norm.startswith("./"):
    norm = norm[2:]

matched = None
for protected in PROTECTED:
    # Suffix match — covers both /Users/.../<protected> (absolute) and <protected> (relative).
    if norm == protected or norm.endswith("/" + protected):
        matched = protected
        break

if not matched:
    sys.exit(0)

print("PROTECTED:{}:{}".format(matched, file_path))
PYEOF
)

PY_EC=$?

# Python error with no analysis → let through (do not block on tool failure).
if [ "$PY_EC" -ne 0 ] && [ -z "$ANALYSIS" ]; then
    exit 0
fi

# No match → silent pass.
if [ -z "$ANALYSIS" ]; then
    exit 0
fi

# Match → emit warn or enforce.
SUMMARY=$(echo "$ANALYSIS" | grep "^PROTECTED:" | head -1)
PROTECTED_REL=$(echo "$SUMMARY" | cut -d: -f2)
FILE_PATH=$(echo "$SUMMARY" | cut -d: -f3-)

BLOCK_REASON="Protected file edit blocked: ${PROTECTED_REL}. Protected files require a master cycle (see .claude/rules/cycle-discipline.md §3 + §10) — direct edit bypasses 6-repo byte-identical invariants."

BLOCK_MSG="[pre-protected-file-edit] Protected file edit attempted
File:      ${FILE_PATH}
Protected: ${PROTECTED_REL}
→ Anchor:  .claude/rules/anchor-list.md §2 A2 (Protected file integrity guard)
→ Policy:  .claude/rules/cycle-discipline.md §3 (byte-identical 강제 범위) + §10 (보호 file 변경 의무)
→ SoT:     .auto-memory/protected-file-hashes.md (보호 5 file sha-256 baseline)
→ Action:  master cycle 신설 → propagate.sh → verify-sync.sh PASS → commit body [Sha] 새 sha 명시"

if [ "$PROTECTED_FILE_EDIT_ENFORCE" = "enforce" ]; then
    printf '%s\n' "$BLOCK_MSG" >&2
    # Anthropic Hooks docs §3.1 #6: JSON deny output for PreToolUse.
    cat << JSON_DENY
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "${BLOCK_REASON}"
  }
}
JSON_DENY
    exit 2
else
    printf '[pre-protected-file-edit:WARN] (mode=warn) protected file edit attempted: %s\n' "$PROTECTED_REL" >&2
    printf '  File: %s\n' "$FILE_PATH" >&2
    printf '  → Anchor: .claude/rules/anchor-list.md §2 A2\n' >&2
    printf '  → Policy: .claude/rules/cycle-discipline.md §3 + §10 (master cycle required)\n' >&2
    printf '  → SoT:    .auto-memory/protected-file-hashes.md\n' >&2
    printf '  (upgrade to enforce: export PROTECTED_FILE_EDIT_ENFORCE=enforce)\n' >&2
fi

exit 0
