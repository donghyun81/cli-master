#!/usr/bin/env bash
# .claude/hooks/instructions-loaded-baseline-verify.sh
# InstructionsLoaded hook — A1 anchor (Baseline drift detection) deterministic enforcement layer.
#
# Purpose:
#   When CLAUDE.md / .claude/rules/*.md files load into context, verify that
#   the protected 5 files (sha-256) match the baseline captured by baseline-snapshot.sh
#   (.ai/baseline-snapshot/latest.json). On drift, surface a warning so cli session
#   becomes aware before acting on a stale baseline assumption.
#
# Mode (env var INSTRUCTIONS_LOADED_VERIFY_ENFORCE):
#   warn    (default) — warn to stderr, always exit 0
#   enforce — drift detected → exit 1 (InstructionsLoaded is advisory · exit 2 block not used)
#
# Baseline SoT:
#   .ai/baseline-snapshot/latest.json (captured by .claude/hooks/baseline-snapshot.sh on SessionStart)
#   Absence → graceful fallback (warn + exit 0) — baseline-snapshot.sh 미발화 sessions OK.
#
# Reference SoT:
#   - .claude/rules/anchor-list.md §2 A1 (Baseline drift detection)
#   - .claude/rules/anchor-list.md §2 A2 (Protected file integrity guard)
#   - .auto-memory/protected-file-hashes.md (보호 5 file sha-256 baseline reference)
#   - .claude/rules/automation-policy.md §3 row 3 (Hook 발화 = Transport OK)
#   - .claude/hooks/baseline-snapshot.sh (baseline capture SoT · SessionStart event)
#
# macOS bash 3.x 호환 (associative array X / ${var,,} X).
# Neutralization: master-only — child repos byte-identical via propagation.

set -uo pipefail

: "${INSTRUCTIONS_LOADED_VERIFY_ENFORCE:=warn}"

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
BASELINE_FILE="$PROJECT_DIR/.ai/baseline-snapshot/latest.json"

INPUT="$(cat 2>/dev/null || echo '')"

# Optional: filter on matcher (parse stdin JSON for event/matcher diagnostics).
# We do not gate execution on matcher; settings.json registration handles that.
# But we still parse to skip unrelated events safely if invoked manually.
if [ -n "$INPUT" ]; then
    EVENT_NAME=$(ILV_INPUT="$INPUT" python3 - << 'PYEOF' 2>/dev/null
import os, json, sys
raw = os.environ.get("ILV_INPUT", "")
if not raw:
    sys.exit(0)
try:
    data = json.loads(raw)
except Exception:
    sys.exit(0)
print(data.get("hook_event_name", ""))
PYEOF
)
    # If invoked manually without JSON, EVENT_NAME stays empty — proceed anyway.
fi

# Graceful fallback: baseline file absent → SessionStart hook 미발화 or first-run.
if [ ! -f "$BASELINE_FILE" ]; then
    printf '[instructions-loaded-verify] WARN: baseline file absent (%s) — run SessionStart (baseline-snapshot.sh) first.\n' "$BASELINE_FILE" >&2
    exit 0
fi

# Parse baseline + measure current → emit drift report via python.
DRIFT=$(ILV_BASELINE="$BASELINE_FILE" ILV_PROJECT="$PROJECT_DIR" python3 - << 'PYEOF'
import json, os, subprocess, sys

baseline_path = os.environ.get("ILV_BASELINE", "")
project_dir = os.environ.get("ILV_PROJECT", "")

if not baseline_path or not project_dir:
    sys.exit(0)

try:
    with open(baseline_path, "r", encoding="utf-8") as fh:
        baseline = json.load(fh)
except Exception as exc:
    print("BASELINE_READ_ERROR:{}".format(exc))
    sys.exit(0)

# baseline json shape (baseline-snapshot.sh):
#   { repos: { "claude-cli-master": { protectedFiles: { "<path>": "<sha-256>" } } } }
repos = baseline.get("repos", {})
master = repos.get("claude-cli-master", {})
protected = master.get("protectedFiles", {}) or {}

if not protected:
    print("BASELINE_EMPTY")
    sys.exit(0)

drifts = []
for rel_path, baseline_sha in protected.items():
    if baseline_sha in ("MISSING", "", None):
        continue
    abs_path = os.path.join(project_dir, rel_path)
    if not os.path.isfile(abs_path):
        drifts.append("MISSING:{}".format(rel_path))
        continue
    try:
        result = subprocess.run(
            ["shasum", "-a", "256", abs_path],
            capture_output=True, text=True, timeout=5,
        )
    except Exception:
        continue
    if result.returncode != 0:
        continue
    current_sha = result.stdout.split()[0] if result.stdout else ""
    if current_sha and current_sha != baseline_sha:
        drifts.append("DRIFT:{}:{}:{}".format(rel_path, baseline_sha[:12], current_sha[:12]))

for line in drifts:
    print(line)
PYEOF
)

PY_EC=$?

# Python error with no analysis → let through (do not block on tool failure).
if [ "$PY_EC" -ne 0 ] && [ -z "$DRIFT" ]; then
    exit 0
fi

# No drifts → silent pass.
if [ -z "$DRIFT" ]; then
    exit 0
fi

# BASELINE_EMPTY / BASELINE_READ_ERROR → advisory only.
if echo "$DRIFT" | grep -qE '^(BASELINE_EMPTY|BASELINE_READ_ERROR)'; then
    REASON=$(echo "$DRIFT" | head -1)
    printf '[instructions-loaded-verify] WARN: %s — baseline-snapshot.sh re-run advised.\n' "$REASON" >&2
    exit 0
fi

# Drift detected → emit warn or enforce.
DRIFT_COUNT=$(echo "$DRIFT" | wc -l | tr -d ' ')

BLOCK_MSG="[instructions-loaded-verify] Protected file baseline drift detected (${DRIFT_COUNT} file(s))
$DRIFT
→ Reference: .claude/rules/anchor-list.md §2 A1+A2 (baseline drift + protected file integrity)
→ Baseline:  .ai/baseline-snapshot/latest.json (captured by .claude/hooks/baseline-snapshot.sh)
→ Hashes SoT: .auto-memory/protected-file-hashes.md
→ Action: re-measure (shasum -a 256 <file>) · if intentional, update protected-file-hashes.md via master cycle"

if [ "$INSTRUCTIONS_LOADED_VERIFY_ENFORCE" = "enforce" ]; then
    printf '%s\n' "$BLOCK_MSG" >&2
    exit 1
else
    printf '[instructions-loaded-verify:WARN] (mode=warn) baseline drift detected (%s file(s))\n' "$DRIFT_COUNT" >&2
    printf '%s\n' "$DRIFT" >&2
    printf '  → Anchor: .claude/rules/anchor-list.md §2 A1+A2\n' >&2
    printf '  → SoT:    .auto-memory/protected-file-hashes.md\n' >&2
    printf '  (upgrade to enforce: export INSTRUCTIONS_LOADED_VERIFY_ENFORCE=enforce)\n' >&2
fi

exit 0
