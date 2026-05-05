#!/usr/bin/env python3
"""SoT inventory + §5 row mapping + N/A classification (Phase 1)."""
import json
import os
from pathlib import Path

HOME = Path.home()
REPOS = {
    "GB": HOME / "AndroidStudioProjects" / "GentlyBreath",
    "GD": HOME / "AndroidStudioProjects" / "GentlyDay",
    "GT": HOME / "AndroidStudioProjects" / "GentlyTable",
}

ROW_MAP = [
    (("paywall", "ticket", "ticketshop", "upgrade", "subscription"), "결제/가입"),
    (("auth",), "Auth-only (N/A 후보)"),
    (("onboarding",), "multi-step Form / Onboarding"),
    (("settings",), "Form / Navigation"),
    (("home",), "Navigation / list"),
    (("report", "history", "habit-tracking", "meal-recommend"), "list / 카탈로그"),
    (("diary", "condition-input", "meal-reaction", "routine-item-add"), "Form (입력)"),
    (("splash", "splash-landing", "darkmode", "design-tokens",
      "breathing", "sleep", "exercise", "ai-disclaimer", "meal-detail",
      "morning-routine-progress", "night-routine-empty",
      "night-routine-progress"), "신규 화면 (UI)"),
]

NA_MAP = {"auth": "Auth-only (로그인/회원가입 — UI 표시 외 도메인)"}


def map_row(screen_stem: str) -> str:
    s = screen_stem.lower()
    for keys, row in ROW_MAP:
        for k in keys:
            if k in s:
                return row
    return "(미분류)"


def na_class(screen_stem: str) -> str:
    s = screen_stem.lower()
    for k, v in NA_MAP.items():
        if k in s:
            return v
    return ""


def extract_meta(spec_path: Path):
    try:
        data = json.loads(spec_path.read_text(encoding="utf-8"))
    except Exception as e:
        return {"error": str(e)}
    meta = data.get("meta", {}) if isinstance(data, dict) else {}
    captured = meta.get("capturedAt") or data.get("capturedAt") or "-"
    lifecycle = meta.get("lifecycle") or data.get("lifecycle") or "-"
    components = data.get("components") or data.get("nodes") or []
    component_count = len(components) if isinstance(components, list) else "-"
    return {
        "capturedAt": captured,
        "lifecycle": lifecycle,
        "componentCount": component_count,
    }


def collect(repo_key: str, repo_path: Path):
    sot = repo_path / "docs" / "design" / "pencil-sot"
    if not sot.exists():
        return []
    rows = []
    stems = set()
    for p in sot.iterdir():
        if p.suffix in (".pen", ".json") and "ui-spec" in p.name:
            stems.add(p.name.replace(".ui-spec.json", ""))
        elif p.suffix == ".pen":
            stems.add(p.stem)
    for stem in sorted(stems):
        pen = sot / f"{stem}.pen"
        spec = sot / f"{stem}.ui-spec.json"
        meta = extract_meta(spec) if spec.exists() else {}
        rows.append({
            "repo": repo_key,
            "screen": stem,
            "pen": "Y" if pen.exists() else "N",
            "spec": "Y" if spec.exists() else "N",
            "capturedAt": meta.get("capturedAt", "-"),
            "lifecycle": meta.get("lifecycle", "-"),
            "componentCount": meta.get("componentCount", "-"),
            "row": map_row(stem),
            "na": na_class(stem),
        })
    return rows


def main():
    out_lines = []
    for repo_key, repo_path in REPOS.items():
        out_lines.append(f"### {repo_key} ({repo_path.name})")
        out_lines.append(
            "| 화면 | .pen | .ui-spec.json | capturedAt | lifecycle | components | §5 row | N/A 사유 |"
        )
        out_lines.append("|---|---|---|---|---|---|---|---|")
        for r in collect(repo_key, repo_path):
            out_lines.append(
                f"| {r['screen']} | {r['pen']} | {r['spec']} | {r['capturedAt']} | "
                f"{r['lifecycle']} | {r['componentCount']} | {r['row']} | {r['na'] or '-'} |"
            )
        out_lines.append("")
    print("\n".join(out_lines))


if __name__ == "__main__":
    main()
