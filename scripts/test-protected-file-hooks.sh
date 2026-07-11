#!/usr/bin/env bash
# scripts/test-protected-file-hooks.sh
# Self-contained 5-fixture test runner for the protected-file hooks installed by
# MASTER-CLI-INSTRUCTIONS-LOADED-PROTECTED-FILE-HOOK-INSTALL-001.
#
# Hooks under test:
#   1. .claude/hooks/instructions-loaded-baseline-verify.sh  (InstructionsLoaded · A1 anchor)
#   2. .claude/hooks/pre-protected-file-edit-sha-verify.sh   (PreToolUse Edit|Write · A2 anchor)
#
# Fixtures:
#   #1 — InstructionsLoaded · baseline matches current  → instructions-loaded PASS (silent)
#   #2 — InstructionsLoaded · baseline drift simulated  → instructions-loaded WARN (exit 0 in warn mode)
#   #3 — PreToolUse · Edit on protected file            → pre-protected WARN (exit 0 in warn mode)
#   #4 — PreToolUse · Edit on non-protected file        → pre-protected PASS (silent)
#   #5 — PreToolUse · invalid JSON input                → pre-protected graceful (exit 0)
#
# This script is master-only (no propagation). Precedent: check-abbreviation.sh 7-fixture self-test.
#
# Usage:
#   bash scripts/test-protected-file-hooks.sh
#   PROTECTED_FILE_EDIT_ENFORCE=enforce bash scripts/test-protected-file-hooks.sh  (optional)

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

HOOK_ILV="$REPO_ROOT/.claude/hooks/instructions-loaded-baseline-verify.sh"
HOOK_PFE="$REPO_ROOT/.claude/hooks/pre-protected-file-edit-sha-verify.sh"

# Sanity: hooks must exist.
for hook in "$HOOK_ILV" "$HOOK_PFE"; do
    if [ ! -f "$hook" ]; then
        printf '[test-runner] FAIL: hook missing: %s\n' "$hook" >&2
        exit 1
    fi
    if [ ! -x "$hook" ]; then
        printf '[test-runner] FAIL: hook not executable: %s\n' "$hook" >&2
        exit 1
    fi
done

PASS_COUNT=0
FAIL_COUNT=0
FAIL_NOTES=""

note_fail() {
    FAIL_COUNT=$((FAIL_COUNT+1))
    FAIL_NOTES="${FAIL_NOTES}
  - $1"
}

# Build a sandbox directory mimicking the master repo layout, so the hook can find
# .ai/baseline-snapshot/latest.json and the 5 protected files.
SANDBOX="$(mktemp -d)"
trap 'rm -rf "$SANDBOX"' EXIT

mkdir -p "$SANDBOX/.ai/baseline-snapshot"
mkdir -p "$SANDBOX/docs/schemas"
mkdir -p "$SANDBOX/docs/design"
mkdir -p "$SANDBOX/docs/rules"
mkdir -p "$SANDBOX/.claude/rules"

# Copy 5 protected files into sandbox so shasum yields identical hashes.
for rel in docs/schemas/ui-spec.schema.json docs/rules/pencil-uiux-workflow.md docs/design/pencil-sot-policy.md docs/rules/uiux-sot-refresh.md docs/design/design-sot-policy.md; do
    src="$REPO_ROOT/$rel"
    dst="$SANDBOX/$rel"
    if [ -f "$src" ]; then
        cp "$src" "$dst"
    fi
done

# Build baseline json that matches sandbox files (drift = 0).
SANDBOX_PATH="$SANDBOX" python3 - << 'PYEOF' > "$SANDBOX/.ai/baseline-snapshot/latest.json"
import json, os, subprocess, sys
sandbox = os.environ["SANDBOX_PATH"]
PROTECTED = [
    "docs/schemas/ui-spec.schema.json",
    "docs/rules/pencil-uiux-workflow.md",
    "docs/design/pencil-sot-policy.md",
    "docs/rules/uiux-sot-refresh.md",
    "docs/design/design-sot-policy.md",
]
pf = {}
for rel in PROTECTED:
    abs_p = os.path.join(sandbox, rel)
    if not os.path.isfile(abs_p):
        continue
    res = subprocess.run(["shasum", "-a", "256", abs_p], capture_output=True, text=True)
    if res.returncode == 0:
        pf[rel] = res.stdout.split()[0]
data = {
    "timestamp": "self-test",
    "projectDir": sandbox,
    "repos": {
        "claude-cli-master": {
            "path": sandbox,
            "protectedFiles": pf,
        }
    },
}
print(json.dumps(data, indent=2))
PYEOF

# ─────────────────────────────────────────────────────────────
# Fixture #1 — InstructionsLoaded · baseline matches current
# Expected: exit 0, stderr empty (no drift)
# ─────────────────────────────────────────────────────────────
F1_INPUT='{"hook_event_name":"InstructionsLoaded","matcher":"session_start"}'
F1_STDERR=$(mktemp)
F1_EXIT=$(CLAUDE_PROJECT_DIR="$SANDBOX" INSTRUCTIONS_LOADED_VERIFY_ENFORCE=warn \
    bash -c "echo '$F1_INPUT' | bash '$HOOK_ILV' 2>'$F1_STDERR'; echo \$?")
F1_STDERR_CONTENT=$(cat "$F1_STDERR")
rm -f "$F1_STDERR"

if [ "$F1_EXIT" = "0" ] && [ -z "$F1_STDERR_CONTENT" ]; then
    PASS_COUNT=$((PASS_COUNT+1))
    printf '[test] fixture #1 InstructionsLoaded (no drift)                  PASS\n'
else
    note_fail "fixture #1: exit=$F1_EXIT stderr=$F1_STDERR_CONTENT"
    printf '[test] fixture #1 InstructionsLoaded (no drift)                  FAIL\n' >&2
fi

# ─────────────────────────────────────────────────────────────
# Fixture #2 — InstructionsLoaded · baseline drift simulated
# Expected: exit 0 (warn mode), stderr contains "drift"
# ─────────────────────────────────────────────────────────────
# Mutate one protected file in sandbox to introduce drift.
echo "/* drift simulated */" >> "$SANDBOX/docs/schemas/ui-spec.schema.json"

F2_INPUT='{"hook_event_name":"InstructionsLoaded","matcher":"session_start"}'
F2_STDERR=$(mktemp)
F2_EXIT=$(CLAUDE_PROJECT_DIR="$SANDBOX" INSTRUCTIONS_LOADED_VERIFY_ENFORCE=warn \
    bash -c "echo '$F2_INPUT' | bash '$HOOK_ILV' 2>'$F2_STDERR'; echo \$?")
F2_STDERR_CONTENT=$(cat "$F2_STDERR")
rm -f "$F2_STDERR"

if [ "$F2_EXIT" = "0" ] && echo "$F2_STDERR_CONTENT" | grep -qi "drift"; then
    PASS_COUNT=$((PASS_COUNT+1))
    printf '[test] fixture #2 InstructionsLoaded (drift simulated · warn)    PASS\n'
else
    note_fail "fixture #2: exit=$F2_EXIT stderr=$F2_STDERR_CONTENT"
    printf '[test] fixture #2 InstructionsLoaded (drift simulated · warn)    FAIL\n' >&2
fi

# ─────────────────────────────────────────────────────────────
# Fixture #3 — PreToolUse · Edit on protected file
# Expected: exit 0 (warn mode), stderr contains "protected"
# ─────────────────────────────────────────────────────────────
F3_INPUT='{"tool_name":"Edit","tool_input":{"file_path":"/Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/docs/rules/pencil-uiux-workflow.md"}}'
F3_STDERR=$(mktemp)
F3_EXIT=$(PROTECTED_FILE_EDIT_ENFORCE=warn \
    bash -c "echo '$F3_INPUT' | bash '$HOOK_PFE' 2>'$F3_STDERR'; echo \$?")
F3_STDERR_CONTENT=$(cat "$F3_STDERR")
rm -f "$F3_STDERR"

if [ "$F3_EXIT" = "0" ] && echo "$F3_STDERR_CONTENT" | grep -qi "protected"; then
    PASS_COUNT=$((PASS_COUNT+1))
    printf '[test] fixture #3 PreToolUse Edit on protected file (warn)       PASS\n'
else
    note_fail "fixture #3: exit=$F3_EXIT stderr=$F3_STDERR_CONTENT"
    printf '[test] fixture #3 PreToolUse Edit on protected file (warn)       FAIL\n' >&2
fi

# ─────────────────────────────────────────────────────────────
# Fixture #4 — PreToolUse · Edit on non-protected file
# Expected: exit 0, stderr empty
# ─────────────────────────────────────────────────────────────
F4_INPUT='{"tool_name":"Edit","tool_input":{"file_path":"/Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/docs/rules/code-principles.md"}}'
F4_STDERR=$(mktemp)
F4_EXIT=$(PROTECTED_FILE_EDIT_ENFORCE=warn \
    bash -c "echo '$F4_INPUT' | bash '$HOOK_PFE' 2>'$F4_STDERR'; echo \$?")
F4_STDERR_CONTENT=$(cat "$F4_STDERR")
rm -f "$F4_STDERR"

if [ "$F4_EXIT" = "0" ] && [ -z "$F4_STDERR_CONTENT" ]; then
    PASS_COUNT=$((PASS_COUNT+1))
    printf '[test] fixture #4 PreToolUse Edit on non-protected (silent)      PASS\n'
else
    note_fail "fixture #4: exit=$F4_EXIT stderr=$F4_STDERR_CONTENT"
    printf '[test] fixture #4 PreToolUse Edit on non-protected (silent)      FAIL\n' >&2
fi

# ─────────────────────────────────────────────────────────────
# Fixture #5 — PreToolUse · invalid JSON input
# Expected: exit 0 (graceful fallback · python json.loads except → sys.exit(0))
# ─────────────────────────────────────────────────────────────
F5_INPUT='not valid json {{{'
F5_STDERR=$(mktemp)
F5_EXIT=$(PROTECTED_FILE_EDIT_ENFORCE=warn \
    bash -c "echo '$F5_INPUT' | bash '$HOOK_PFE' 2>'$F5_STDERR'; echo \$?")
F5_STDERR_CONTENT=$(cat "$F5_STDERR")
rm -f "$F5_STDERR"

if [ "$F5_EXIT" = "0" ]; then
    PASS_COUNT=$((PASS_COUNT+1))
    printf '[test] fixture #5 PreToolUse invalid JSON (graceful)             PASS\n'
else
    note_fail "fixture #5: exit=$F5_EXIT stderr=$F5_STDERR_CONTENT"
    printf '[test] fixture #5 PreToolUse invalid JSON (graceful)             FAIL\n' >&2
fi

# ─────────────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────────────
printf '\n'
printf '═══════════════════════════════════════════════════════\n'
printf '[test-runner] Summary: %d PASS / %d FAIL (5 total)\n' "$PASS_COUNT" "$FAIL_COUNT"
printf '═══════════════════════════════════════════════════════\n'

if [ "$FAIL_COUNT" -gt 0 ]; then
    printf '\nFailures:%s\n' "$FAIL_NOTES" >&2
    exit 1
fi

exit 0
