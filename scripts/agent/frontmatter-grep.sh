#!/bin/bash
# scripts/agent/frontmatter-grep.sh <pattern> <file-glob>
#
# Grep a pattern against only the YAML frontmatter region of markdown files,
# ignoring any identical-looking strings inside code blocks or body text.
# "Frontmatter" = text between the FIRST `---` line (line 1) and the
# SECOND `---` line. Files without a leading `---` are skipped.
#
# macOS bash 3.x compatible. Uses sed + grep (no pyyaml).
#
# Args:
#   $1  regex pattern (ERE — passed to grep -E)
#   $2  file glob (shell-expanded by caller; pass already-expanded or quoted)
#
# Exit:
#   0  no matches across any file (silent)
#   1  at least one file has a match (matches printed to stdout as path:line:content)
#   2  internal error (usage / missing args)
#
# Usage:
#   bash scripts/agent/frontmatter-grep.sh '^tools: \[' '.claude/agents/*.md'

PATTERN="${1:-}"
GLOB="${2:-}"

if [ -z "$PATTERN" ] || [ -z "$GLOB" ]; then
    echo "frontmatter-grep: usage: $0 <pattern> <file-glob>" >&2
    exit 2
fi

FOUND=0
for f in $GLOB; do
    [ -f "$f" ] || continue
    # Skip files that do not start with `---` on line 1
    head -n 1 "$f" 2>/dev/null | grep -q '^---$' || continue
    # Extract lines 2..(next `---`) — the frontmatter body.
    FRONT=$(sed -n '2,/^---$/{/^---$/q;p;}' "$f" 2>/dev/null)
    [ -z "$FRONT" ] && continue
    HIT=$(printf '%s\n' "$FRONT" | grep -nE "$PATTERN" 2>/dev/null)
    if [ -n "$HIT" ]; then
        FOUND=1
        printf '%s\n' "$HIT" | while IFS= read -r line; do
            printf '%s:%s\n' "$f" "$line"
        done
    fi
done

[ "$FOUND" = "0" ] && exit 0
exit 1
