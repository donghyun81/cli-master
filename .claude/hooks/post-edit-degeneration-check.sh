#!/usr/bin/env bash
# .claude/hooks/post-edit-degeneration-check.sh
# PostToolUse hook — matcher: Edit|Write
# Enforces text-degeneration-prevention policy (n-gram token frequency metric).
#
# Mode (env var DEGEN_ENFORCE):
#   warn    (default) — stderr warning only, always exit 0
#   enforce          — exit 2 on violation (Cycle 2+ upgrade candidate)
#
# Self-test:
#   bash .claude/hooks/post-edit-degeneration-check.sh <relative-or-absolute-path>
#
# Policy SoT: docs/rules/text-degeneration-prevention.md
# Whitelist additionally pulls from: docs/rules/abbreviation-policy.md (§3 allowed acronym list)
#   (직전 allowed-acronyms.md 본문 흡수 default · MASTER-CLI-CLEANUP-7CYCLE-001 마감)
#
# macOS bash 3.x compatible. python3 required (already required by other hooks).

set -uo pipefail

: "${DEGEN_ENFORCE:=warn}"

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
ALLOWED_ACRONYMS_PATH="$REPO_ROOT/docs/rules/abbreviation-policy.md"

# --- Input resolution: stdin JSON (PostToolUse) OR positional argument (self-test) ---
INPUT=""
SELF_TEST_PATH=""
if [ -t 0 ] && [ $# -ge 1 ]; then
    # Interactive shell + positional arg = self-test mode
    SELF_TEST_PATH="$1"
elif [ $# -ge 1 ] && [ -e "$1" ]; then
    # Positional arg refers to an existing path (test runner / CI)
    SELF_TEST_PATH="$1"
else
    INPUT="$(cat 2>/dev/null || echo '')"
fi

# If self-test path given, synthesize a minimal JSON envelope.
if [ -n "$SELF_TEST_PATH" ]; then
    INPUT=$(SELF_TEST_PATH_ENV="$SELF_TEST_PATH" python3 - <<'PYEOF'
import os, json, sys
p = os.environ.get("SELF_TEST_PATH_ENV", "")
print(json.dumps({"tool_name": "Write", "tool_input": {"file_path": os.path.abspath(p)}}))
PYEOF
)
fi

[ -z "$INPUT" ] && exit 0

ANALYSIS=$(DEGEN_INPUT="$INPUT" DEGEN_ALLOWED="$ALLOWED_ACRONYMS_PATH" python3 - << 'PYEOF'
import os, json, re, sys, math
from collections import Counter

raw = os.environ.get("DEGEN_INPUT", "")
if not raw:
    sys.exit(0)

try:
    data = json.loads(raw)
except Exception:
    sys.exit(0)

tool_input = data.get("tool_input", {}) or {}
file_path = tool_input.get("file_path") or tool_input.get("path") or ""
if not file_path:
    sys.exit(0)

TARGET_EXTS = {".md", ".txt"}
import os.path as osp
ext = osp.splitext(file_path.lower())[1]
if ext not in TARGET_EXTS:
    sys.exit(0)

SKIP_SEGS = (
    "/build/", "/.gradle/", "/generated/", "/.git/",
    "/.ai/reports/", "/node_modules/", "/archive/",
    "/propagation-reports/", "/dist/",
)
norm = file_path if file_path.startswith("/") else "/" + file_path
if any(seg in norm for seg in SKIP_SEGS):
    sys.exit(0)

try:
    with open(file_path, "r", encoding="utf-8", errors="ignore") as fh:
        content = fh.read()
except Exception:
    sys.exit(0)

content = content[:200000]

# --- Whitelist ---
WHITELIST_BASE = {
    # domain SoT
    "repository", "repo", "master", "cycle", "commit", "propagation", "propagate",
    "file", "sha", "baseline", "hook", "agent", "schema", "cli", "infra", "build",
    "claude", "code", "anthropic", "supabase", "pencil", "compose", "kotlin",
    "verify", "review", "plan", "evidence", "todo", "mode", "compound", "lint",
    "auth", "billing", "data", "perf", "api", "sdk", "sot", "ssot",
    "json", "http", "https", "url", "uuid", "sql", "html", "css", "xml",
    "yaml", "toml", "gradle", "docs", "scripts", "rules", "agents", "hooks",
    "settings", "skills", "commands", "auto", "memory", "task", "tasks",
    "ai", "ml", "ui", "ux", "id", "os", "fs", "db", "ec", "md",
    "name", "type", "value", "true", "false", "null", "default",
    "tool", "input", "output", "matcher", "post", "pre", "use", "user",
    "the", "a", "of", "to", "and", "in", "is", "for", "with", "on", "by",
    "or", "an", "be", "as", "at", "it", "if", "we", "from", "this",
    "that", "are", "not", "no", "yes", "use", "used", "via", "see",
    # common Korean function words / connectives
    "그리고", "또는", "그러나", "그래서", "따라서", "한편",
    "예", "예시", "참고", "결과", "근거", "정의", "신규",
    # mitigation policy artifacts
    "scan", "metric", "token", "tokens", "stop", "warn", "enforce",
    "degen", "degeneration", "ngram", "stddev", "zscore",
}

# Optional: pull abbreviation-policy.md §3 allowed acronym tokens (lowercased, alpha-only)
allowed_path = os.environ.get("DEGEN_ALLOWED", "")
ACRONYM_EXTRA = set()
if allowed_path and os.path.exists(allowed_path):
    try:
        with open(allowed_path, "r", encoding="utf-8", errors="ignore") as fh:
            atext = fh.read()
        for m in re.findall(r"\b[A-Z][A-Za-z0-9]{1,12}\b", atext):
            ACRONYM_EXTRA.add(m.lower())
    except Exception:
        pass

WHITELIST = WHITELIST_BASE | ACRONYM_EXTRA

# --- Strip non-text noise from content for tokenization ---
_BT = chr(96)  # backtick (avoided literally to keep bash 3.x heredoc happy)
_FENCE = re.compile(_BT + _BT + _BT + r"[\s\S]*?" + _BT + _BT + _BT)
_INLINE = re.compile(_BT + r"[^" + _BT + r"\n]*" + _BT)

def strip_noise(text):
    text = _FENCE.sub(" ", text)                       # fenced code blocks
    text = _INLINE.sub(" ", text)                      # inline code
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)   # markdown links → keep label
    text = re.sub(r"https?://\S+", " ", text)          # raw urls
    # Strip full markdown table rows BEFORE prefix glyph stripping
    # (otherwise '|' is removed and the row no longer matches the table pattern).
    text = re.sub(r"^\s*\|.*\|\s*$", " ", text, flags=re.MULTILINE)  # entire table rows
    text = re.sub(r"^[#>*\-+|]+", " ", text, flags=re.MULTILINE)  # remaining md prefix glyphs
    return text

def tokenize(text):
    text = strip_noise(text).lower()
    # Token = run of Hangul OR run of Latin/digit
    raw = re.findall(r"[가-힣]+|[a-z][a-z0-9]+", text)
    out = []
    for t in raw:
        if t in WHITELIST:
            continue
        if t.isdigit():
            continue
        # filter very short tokens (likely particles / noise)
        if re.match(r"^[가-힣]+$", t):
            if len(t) < 2:
                continue
        else:
            if len(t) < 3:
                continue
        out.append(t)
    return out

def split_sentences(text):
    text = strip_noise(text)
    return [s for s in re.split(r"[.!?。．！？\n]+", text) if s.strip()]

def split_paragraphs(text):
    text = strip_noise(text)
    return [p for p in re.split(r"\n\s*\n", text) if p.strip()]

violations_m1 = []  # per-sentence
violations_m2 = []  # per-paragraph
violations_m3 = []  # file-wide

# M1
for s in split_sentences(content):
    toks = tokenize(s)
    if len(toks) < 4:
        continue
    c = Counter(toks)
    for tok, n in c.most_common(3):
        if n > 3:
            sample = re.sub(r"\s+", " ", s).strip()[:80]
            violations_m1.append((tok, n, sample))

# M2
for p in split_paragraphs(content):
    toks = tokenize(p)
    if len(toks) < 10:
        continue
    c = Counter(toks)
    for tok, n in c.most_common(5):
        if n > 5:
            sample = re.sub(r"\s+", " ", p).strip()[:80]
            violations_m2.append((tok, n, sample))

# M3 — extreme outlier only (z-multiplier=4, absolute floor=10)
# Tuned so natural domain-heavy prose does not trigger; only true degeneration
# (e.g., one token taking >5% of total content) lands here.
all_toks = tokenize(content)
if len(all_toks) >= 200:
    c = Counter(all_toks)
    counts = list(c.values())
    if len(counts) >= 20:
        mean = sum(counts) / len(counts)
        var = sum((x - mean) ** 2 for x in counts) / len(counts)
        std = math.sqrt(var)
        thr = mean + 4 * std
        total = len(all_toks)
        for tok, n in c.most_common(20):
            if n >= 10 and n > thr:
                violations_m3.append((tok, n, f"mean={mean:.2f} std={std:.2f} thr={thr:.2f} share={100*n/total:.1f}%"))

# Dedupe M1 / M2 by (metric, token)
def dedupe(rows):
    seen, out = set(), []
    for r in rows:
        k = r[0]
        if k in seen:
            continue
        seen.add(k)
        out.append(r)
    return out

m1 = dedupe(violations_m1)
m2 = dedupe(violations_m2)
m3 = violations_m3

if not (m1 or m2 or m3):
    sys.exit(0)

print("[HOOK:DEGENERATION-CHECK] " + file_path, file=sys.stderr)
for tok, n, sample in m1[:5]:
    print("  [M1 sentence] '%s' x%d  · %s" % (tok, n, sample), file=sys.stderr)
for tok, n, sample in m2[:5]:
    print("  [M2 paragraph] '%s' x%d  · %s" % (tok, n, sample), file=sys.stderr)
for tok, n, info in m3[:5]:
    print("  [M3 file] '%s' x%d  · %s" % (tok, n, info), file=sys.stderr)

print("  policy: docs/rules/text-degeneration-prevention.md  (mode=%s)" % os.environ.get("DEGEN_ENFORCE", "warn"), file=sys.stderr)

if os.environ.get("DEGEN_ENFORCE", "warn") == "enforce":
    sys.exit(2)
sys.exit(0)
PYEOF
)
PY_STATUS=$?

if [ $PY_STATUS -eq 2 ] && [ "$DEGEN_ENFORCE" = "enforce" ]; then
    exit 2
fi
exit 0
