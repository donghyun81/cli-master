#!/usr/bin/env bash
# .claude/hooks/libs-versions-cross-verify.sh
# PostToolUse hook — matcher: Edit|Write
# Enforces libs-versions-cross-verify policy (3-source matrix · versions ↔ libraries ↔ source imports).
#
# Mode (env var LIBS_VERSIONS_ENFORCE):
#   warn    (default) — stderr warning only, always exit 0
#   enforce          — exit 2 on violation
#
# Self-test:
#   bash .claude/hooks/libs-versions-cross-verify.sh
#   bash .claude/hooks/libs-versions-cross-verify.sh gradle/libs.versions.toml
#
# Policy SoT: .claude/rules/libs-versions-cross-verify.md
#
# macOS bash 3.x compatible. python3 required.

set -uo pipefail

: "${LIBS_VERSIONS_ENFORCE:=warn}"

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
TOML_PATH="$REPO_ROOT/gradle/libs.versions.toml"

# --- Input resolution: stdin JSON (PostToolUse) OR positional argument (self-test) ---
INPUT=""
TRIGGER_PATH=""
if [ -t 0 ] && [ $# -ge 1 ]; then
    TRIGGER_PATH="$1"
elif [ $# -ge 1 ] && [ -e "$1" ]; then
    TRIGGER_PATH="$1"
else
    INPUT="$(cat 2>/dev/null || echo '')"
fi

if [ -z "$TRIGGER_PATH" ] && [ -n "$INPUT" ]; then
    TRIGGER_PATH=$(printf '%s' "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin) if sys.stdin.isatty()==False else {}; ti=(d.get('tool_input') or {}); print(ti.get('file_path') or '')" 2>/dev/null || echo "")
fi

# Self-test fallback — when run with no input + no arg, target = toml only.
if [ -z "$TRIGGER_PATH" ]; then
    TRIGGER_PATH="$TOML_PATH"
fi

# --- Trigger filter: only run when relevant file changed ---
case "$TRIGGER_PATH" in
    */gradle/libs.versions.toml|*/libs.versions.toml)
        : ;; # always evaluate
    *.kt)
        # Only evaluate Kotlin under src directory.
        case "$TRIGGER_PATH" in
            */src/*|*/app/src/*) : ;;
            *) exit 0 ;;
        esac
        ;;
    *)
        exit 0 ;;
esac

# --- toml absence = nothing to check ---
if [ ! -f "$TOML_PATH" ]; then
    exit 0
fi

# --- Run python check ---
ANALYSIS=$(LIBSVCV_REPO="$REPO_ROOT" LIBSVCV_TOML="$TOML_PATH" LIBSVCV_TRIGGER="$TRIGGER_PATH" python3 - <<'PYEOF'
import os, re, sys, glob

repo_root = os.environ.get("LIBSVCV_REPO", ".")
toml_path = os.environ.get("LIBSVCV_TOML", "")
trigger = os.environ.get("LIBSVCV_TRIGGER", "")

if not toml_path or not os.path.isfile(toml_path):
    sys.exit(0)

with open(toml_path, "r", encoding="utf-8") as fh:
    toml_lines = fh.readlines()

# --- naive section parser (sufficient for libs.versions.toml shape) ---
section = None
versions = {}
libraries = {}  # alias -> { module: str, version_ref: str|None, version_inline: str|None }

key_value_re = re.compile(r'^([A-Za-z0-9_\-]+)\s*=\s*"([^"]+)"\s*$')
lib_re = re.compile(r'^([A-Za-z0-9_\-]+)\s*=\s*\{(.+)\}\s*$')

for raw in toml_lines:
    line = raw.strip()
    if not line or line.startswith("#"):
        continue
    if line.startswith("["):
        section = line.strip("[]").strip()
        continue
    if section == "versions":
        m = key_value_re.match(line)
        if m:
            versions[m.group(1)] = m.group(2)
    elif section == "libraries":
        m = lib_re.match(line)
        if not m:
            continue
        alias = m.group(1)
        body = m.group(2)
        module_m = re.search(r'module\s*=\s*"([^"]+)"', body)
        vref_m = re.search(r'version\.ref\s*=\s*"([^"]+)"', body)
        vinline_m = re.search(r'version\s*=\s*"([^"]+)"', body)
        libraries[alias] = {
            "module": module_m.group(1) if module_m else "",
            "version_ref": vref_m.group(1) if vref_m else None,
            "version_inline": vinline_m.group(1) if vinline_m else None,
        }

# --- Scan source imports (Kotlin) ---
def gather_imports():
    patterns = [
        os.path.join(repo_root, "src/**/*.kt"),
        os.path.join(repo_root, "app/src/**/*.kt"),
        os.path.join(repo_root, "core/**/src/**/*.kt"),
        os.path.join(repo_root, "shared/**/src/**/*.kt"),
        os.path.join(repo_root, "composeApp/**/src/**/*.kt"),
        os.path.join(repo_root, "iosApp/**/src/**/*.kt"),
    ]
    found = set()
    for pat in patterns:
        for path in glob.glob(pat, recursive=True):
            try:
                with open(path, "r", encoding="utf-8") as fh:
                    for ln in fh:
                        ln = ln.strip()
                        if ln.startswith("import "):
                            found.add(ln[len("import "):].rstrip(";"))
                        elif ln and not ln.startswith("//") and not ln.startswith("package "):
                            # Stop scanning past import block heuristically.
                            if ln.startswith("import "):
                                continue
            except Exception:
                continue
    return found

imports = gather_imports()

# --- Rule set (extensible) ---
violations = []  # tuples of (rule_id, severity, message)

# R1 — supabase-kt naming ↔ version major
sb_version = versions.get("supabase", "")
sb_major = ""
if sb_version:
    parts = sb_version.split(".")
    if parts and parts[0].isdigit():
        sb_major = parts[0]

# Look at every supabase library alias.
sb_libs = {alias: lib for alias, lib in libraries.items() if "io.github.jan-tennert.supabase" in (lib.get("module") or "")}
sb_artifacts = set()
for alias, lib in sb_libs.items():
    module = lib.get("module") or ""
    if ":" in module:
        sb_artifacts.add(module.split(":", 1)[1])

# R1a — versions vs libraries
if sb_major == "3":
    if "gotrue-kt" in sb_artifacts:
        violations.append((
            "R1a",
            "FAIL",
            f"[versions] supabase = \"{sb_version}\" (3.x) ↔ [libraries] uses legacy artifact 'gotrue-kt'. 3.x renamed to 'auth-kt'.",
        ))
elif sb_major == "2":
    if "auth-kt" in sb_artifacts:
        violations.append((
            "R1a",
            "FAIL",
            f"[versions] supabase = \"{sb_version}\" (2.x) ↔ [libraries] uses 3.x artifact 'auth-kt'. 2.x naming = 'gotrue-kt'.",
        ))

# R1b — versions vs source imports
has_auth_import = any(imp.startswith("io.github.jan.supabase.auth.") or imp == "io.github.jan.supabase.auth" for imp in imports)
has_gotrue_import = any(imp.startswith("io.github.jan.supabase.gotrue.") or imp == "io.github.jan.supabase.gotrue" for imp in imports)

if sb_major == "2" and has_auth_import:
    violations.append((
        "R1b",
        "FAIL",
        f"source imports 'io.github.jan.supabase.auth.*' (3.x convention) but [versions] supabase = \"{sb_version}\" (2.x).",
    ))
if sb_major == "3" and has_gotrue_import:
    violations.append((
        "R1b",
        "FAIL",
        f"source imports 'io.github.jan.supabase.gotrue.*' (2.x convention) but [versions] supabase = \"{sb_version}\" (3.x).",
    ))

# R1c — libraries artifact vs source imports
if "auth-kt" in sb_artifacts and has_gotrue_import:
    violations.append((
        "R1c",
        "FAIL",
        "[libraries] declares 'auth-kt' but source still imports 'io.github.jan.supabase.gotrue.*'.",
    ))
if "gotrue-kt" in sb_artifacts and has_auth_import:
    violations.append((
        "R1c",
        "FAIL",
        "[libraries] declares 'gotrue-kt' but source already imports 'io.github.jan.supabase.auth.*'.",
    ))

# --- Output ---
if not violations:
    sys.exit(0)

print("[libs-versions-cross-verify] mismatches detected:", file=sys.stderr)
for rule_id, severity, msg in violations:
    print(f"  [{rule_id}] {severity}: {msg}", file=sys.stderr)
print(f"  trigger file: {trigger}", file=sys.stderr)
print(f"  policy SoT: .claude/rules/libs-versions-cross-verify.md §3 (R1)", file=sys.stderr)

# Signal violation via exit code 1; bash wrapper decides warn vs enforce.
sys.exit(1)
PYEOF
)
PY_EXIT=$?

if [ "$PY_EXIT" -ne 0 ]; then
    if [ "$LIBS_VERSIONS_ENFORCE" = "enforce" ]; then
        exit 2
    fi
fi

exit 0
