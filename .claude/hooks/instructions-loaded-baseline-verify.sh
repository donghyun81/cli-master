#!/usr/bin/env bash
# .claude/hooks/instructions-loaded-baseline-verify.sh
# InstructionsLoaded hook — A1 anchor (Baseline drift detection) + always-fresh baseline 표면화 (H3).
#
# Purpose:
#   진입(InstructionsLoaded) 시점에
#     (1) 현재 6-repo HEAD + 보호 5 file sha 를 live 측정해 AI-readable 1-블록으로 표면화하고
#         (= additionalContext · latest.json 신선도와 무관하게 매 진입 live 측정 →
#            stale HEAD 인용 환각 vector 차단 · H3),
#     (2) 보호 5 file sha 가 baseline(.ai/baseline-snapshot/latest.json)과 drift 하면 warn 한다 (A1/A2).
#
# Mode (env var INSTRUCTIONS_LOADED_VERIFY_ENFORCE):
#   warn    (default) — 표면화 emit + drift 시 stderr warn · 항상 exit 0
#   enforce — drift 시 exit 1 (InstructionsLoaded advisory · exit 2 block 미사용)
#
# Output channel:
#   stdout = hookSpecificOutput.additionalContext (= AI 가 인용 가능한 baseline 1-블록 · noise 최소)
#   stderr = drift warn (= 사용자 escalation · warn-only paradigm 보존)
#
# Baseline SoT:
#   .ai/baseline-snapshot/latest.json (= SessionStart baseline-snapshot.sh 산출 · 보호 sha drift 비교 기준)
#   부재/stale 시 = live HEAD/sha 는 그대로 표면화 + drift 비교만 "baseline absent" graceful fallback.
#
# Reference SoT:
#   - .claude/rules/anchor-list.md §2 A1 (Baseline drift detection) + A2 (Protected file integrity guard)
#   - .auto-memory/protected-file-hashes.md (보호 5 file sha-256 baseline reference)
#   - .claude/rules/automation-policy.md §3 row 3 (Hook 발화 = Transport OK)
#   - .claude/hooks/baseline-snapshot.sh (baseline capture SoT · SessionStart event)
#   - 부모 mount root CLAUDE.md §3 (자식 단독 §3.1 vs 부모 mount §3.2 진입 paradigm)
#
# 신설: MASTER-CLI-INSTRUCTIONS-LOADED-PROTECTED-FILE-HOOK-INSTALL-001 (2026-05-26)
# 갱신: MASTER-CLI-CONTEXT-OPT-PHASE2-BASELINE-SURFACE-001 (2026-06-01 · always-fresh 표면화 emit + mount root robust 탐지)
#
# macOS bash 3.x 호환. self-test: bash .claude/hooks/instructions-loaded-baseline-verify.sh
# Neutralization: master-only — child repos byte-identical via propagation.

set -uo pipefail

: "${INSTRUCTIONS_LOADED_VERIFY_ENFORCE:=warn}"

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
BASELINE_FILE="$PROJECT_DIR/.ai/baseline-snapshot/latest.json"

# mount root (= 6-repo 가 직접 놓인 디렉터리) robust 탐지 (baseline-snapshot.sh 와 동일 분기).
#   §3.1 자식 단독 진입 → 6-repo = dirname(PROJECT_DIR) 하위
#   §3.2 부모 mount 진입 → 6-repo = PROJECT_DIR 하위
if [ -d "$PROJECT_DIR/claude-cli-master/.git" ]; then
  MOUNT_ROOT="$PROJECT_DIR"
else
  MOUNT_ROOT="$(dirname "$PROJECT_DIR")"
fi

# stdin (hook event JSON) 소비 + 폐기 (gate 안 함 · settings.json matcher 가 담당).
cat >/dev/null 2>&1 || true

# live 측정(6-repo HEAD + 보호 5 sha) + baseline drift 비교 + additionalContext emit.
ILV_PROJECT="$PROJECT_DIR" ILV_MOUNT="$MOUNT_ROOT" ILV_BASELINE="$BASELINE_FILE" python3 - << 'PYEOF'
import json, os, subprocess, sys

mount_root = os.environ.get("ILV_MOUNT", "")
baseline_path = os.environ.get("ILV_BASELINE", "")

REPOS = ["claude-cli-master", "app-foundation", "GentlyBreath", "GentlyDay", "GentlyTable", "gently-product-docs"]
PROTECTED = [
    "docs/schemas/ui-spec.schema.json",
    ".claude/rules/pencil-uiux-workflow.md",
    "docs/design/pencil-sot-policy.md",
    ".claude/rules/uiux-sot-refresh.md",
    "docs/design/design-sot-policy.md",
]

def run(cmd):
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
        if r.returncode == 0 and r.stdout:
            return r.stdout.strip()
    except Exception:
        pass
    return ""

# 1. live 6-repo HEAD (short)
head_parts = []
for repo in REPOS:
    path = os.path.join(mount_root, repo)
    head = ""
    if os.path.isdir(os.path.join(path, ".git")):
        head = run(["git", "-C", path, "rev-parse", "--short", "HEAD"])
    head_parts.append("{}={}".format(repo, head if head else "MISSING"))

# 2. baseline 보호 sha map (= latest.json · drift 비교 기준)
baseline_protected = {}
if baseline_path and os.path.isfile(baseline_path):
    try:
        with open(baseline_path, "r", encoding="utf-8") as fh:
            bdata = json.load(fh)
        baseline_protected = (bdata.get("repos", {})
                                   .get("claude-cli-master", {})
                                   .get("protectedFiles", {})) or {}
    except Exception:
        baseline_protected = {}

# 3. live 보호 5 sha (master) + drift
master_path = os.path.join(mount_root, "claude-cli-master")
sha_parts = []
drift = []
for rel in PROTECTED:
    abs_path = os.path.join(master_path, rel)
    cur = ""
    if os.path.isfile(abs_path):
        out = run(["shasum", "-a", "256", abs_path])
        cur = out.split()[0] if out else ""
    name = rel.split("/")[-1]
    sha_parts.append("{}={}".format(name, cur[:12] if cur else "MISSING"))
    base = baseline_protected.get(rel, "")
    if base and base != "MISSING" and cur and cur != base:
        drift.append("{}: baseline {} != current {}".format(rel, base[:12], cur[:12]))

drift_n = len(drift)
if not baseline_protected:
    drift_status = "baseline absent → SessionStart baseline-snapshot.sh 재실행 권장"
elif drift_n == 0:
    drift_status = "0 (보호 5 file = baseline 일치)"
else:
    drift_status = "{} DRIFT".format(drift_n)

# 4. always-fresh 1-블록 (= AI-readable baseline)
block = "\n".join([
    "[baseline:always-fresh] InstructionsLoaded live 측정 (mount={})".format(mount_root),
    "  6-repo HEAD: " + " · ".join(head_parts),
    "  보호5 sha(12): " + " · ".join(sha_parts),
    "  보호 sha drift: " + drift_status,
])

# 5. AI-readable additionalContext emit (stdout JSON · noise 최소 1 블록)
print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "InstructionsLoaded",
        "additionalContext": block,
    }
}))

# 6. drift → stderr warn (= warn-only paradigm 보존 · 사용자 escalation)
if drift_n > 0:
    sys.stderr.write("[instructions-loaded-verify:WARN] 보호 file baseline drift ({} file)\n".format(drift_n))
    for d in drift:
        sys.stderr.write("  - {}\n".format(d))
    sys.stderr.write("  -> Anchor: .claude/rules/anchor-list.md §2 A1+A2\n")
    sys.stderr.write("  -> SoT:    .auto-memory/protected-file-hashes.md\n")
    sys.stderr.write("  (enforce upgrade: export INSTRUCTIONS_LOADED_VERIFY_ENFORCE=enforce)\n")
    sys.exit(3)

sys.exit(0)
PYEOF
PY_EC=$?

# enforce mode + drift(=3) → exit 1 (advisory · warn-only default 보존).
if [ "$INSTRUCTIONS_LOADED_VERIFY_ENFORCE" = "enforce" ] && [ "$PY_EC" -eq 3 ]; then
    exit 1
fi

exit 0
