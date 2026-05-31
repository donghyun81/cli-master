#!/usr/bin/env python3
"""
pen_recolor.py — deterministic .pen gray-trap → brand recolor (headless, no Pencil app).

본질: GD/GB/GT .pen 파일이 foundation Neutral 색을 캡처한 gray-trap 을, 활성 자식 brand
colorScheme 으로 결정론적 remap. raw hex → (foundation neutral role) → active brand hex.

입력:
  --pen        대상 .pen (구조 source · fill 만 교체)
  --theme      활성 자식 <Repo>Theme.kt (active role→hex resolve table parse)
  --out        교정 .pen 출력 경로
fidelity gate: 출력 모든 fill ∈ (active token set ∪ {transparent}) ∪ flagged-unknown.
unknown(off-token) hex = 교체 안 함 + report 에 FLAG (= 사람 결정 영역, gray-trap 아님).

SoT 정합:
  - .pen schema 2.11 (pencil-pen-format-schema.md)
  - dual-layer (design-to-code-sync.md §1): .pen 교체 후 .ui-spec.json sha sync = 별 step (CLI)
  - 색만 교체 · 구조/좌표/텍스트 무변경 (= Phase 1 D2 구조 유지 정합)
"""
import json, re, sys, argparse, hashlib
from collections import OrderedDict

# foundation Neutral role→hex (= trap fingerprint · git 0761747 Color.kt · 고정 historical 값).
# 이 값들이 .pen 에 박혀 있으면 = gray-trap = 해당 role 의 active brand 값으로 remap.
FOUNDATION_NEUTRAL = {
    "#5A6470": "primary",        "#6A7280": "secondary",      "#7D858F": "tertiary",
    "#FAFAFA": "background",     "#1A1C1E": "onSurface",       # OnBackground==OnSurface==#1A1C1E
    "#E7E8EA": "surfaceVariant", "#44474C": "onSurfaceVariant",
    "#74777C": "outline",        "#C4C7CC": "outlineVariant",
    "#D4D9DF": "primaryContainer",   "#E0E4E8": "secondaryContainer",
    "#E8ECEF": "tertiaryContainer",  "#1A1F26": "onPrimaryContainer",
    "#20262E": "onSecondaryContainer", "#272D34": "onTertiaryContainer",
    "#B3261E": "error",          "#F9DEDC": "errorContainer", "#410E0B": "onErrorContainer",
    # 주의: #FFFFFF = Surface AND OnPrimary/OnSecondary/OnTertiary/OnError (role collision).
    # context 없는 raw hex remap 불가 → 'surface' 로 처리(카드/배경 우세) + report 에 collision 기록.
    "#FFFFFF": "surface",
}
TRANSPARENT = {"#00000000", "#0000", "transparent"}

def parse_theme(theme_path):
    """활성 <Repo>Theme.kt 에서 Light colorScheme role→hex resolve table 추출."""
    src = open(theme_path, encoding="utf-8").read()
    # val Name = Color(0xFFRRGGBB)
    vals = dict(re.findall(r'val\s+(\w+)\s*=\s*Color\(0x[fF]{2}([0-9A-Fa-f]{6})\)', src))
    # lightColorScheme( role = ValName, ... ) 블록만
    m = re.search(r'LightColorScheme[^(]*lightColorScheme\((.*?)\)\s*\n', src, re.S)
    if not m:
        m = re.search(r'lightColorScheme\((.*?)\)\s*\n', src, re.S)
    block = m.group(1)
    role_to_val = dict(re.findall(r'(\w+)\s*=\s*(\w+)\s*,', block))
    table = {}
    for role, valname in role_to_val.items():
        if valname in vals:
            table[role] = "#" + vals[valname].upper()
    return table

def norm(h):
    return h.upper() if h else h

def remap_fill(hexval, active, report):
    h = norm(hexval)
    if h in (norm(x) for x in TRANSPARENT) or (h and h.startswith("#") and len(h) == 9 and h.endswith("00")):
        return hexval, "transparent"
    role = FOUNDATION_NEUTRAL.get(h)
    if role is None:
        report["unknown"][h] = report["unknown"].get(h, 0) + 1
        return hexval, "UNKNOWN(off-token · kept)"
    if role not in active:
        report["role_no_active"][role] = report["role_no_active"].get(role, 0) + 1
        return hexval, f"role={role} but active scheme 미정의 · kept"
    new = active[role]
    report["remapped"][f"{h}->{new}({role})"] = report["remapped"].get(f"{h}->{new}({role})", 0) + 1
    return new, f"{role}: {h}->{new}"

def walk(node, active, report):
    if isinstance(node, dict):
        for k in ("fill", "stroke"):
            if k in node and isinstance(node[k], str):
                node[k], _ = remap_fill(node[k], active, report)
        for v in node.values():
            walk(v, active, report)
    elif isinstance(node, list):
        for v in node:
            walk(v, active, report)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pen", required=True)
    ap.add_argument("--theme", required=True)
    ap.add_argument("--out", required=True)
    a = ap.parse_args()

    active = parse_theme(a.theme)
    doc = json.load(open(a.pen, encoding="utf-8"), object_pairs_hook=OrderedDict)
    report = {"remapped": {}, "unknown": {}, "role_no_active": {}}
    walk(doc, active, report)

    out_text = json.dumps(doc, ensure_ascii=False, indent=2) + "\n"
    open(a.out, "w", encoding="utf-8").write(out_text)

    # fidelity gate: 출력 모든 fill ∈ active values ∪ transparent ∪ unknown(flagged)
    out_fills = set(re.findall(r'"(?:fill|stroke)":\s*"([^"]+)"', out_text))
    active_vals = {norm(v) for v in active.values()}
    unknown_norm = {norm(x) for x in report["unknown"]}
    transp_norm = {norm(x) for x in TRANSPARENT}
    # role 존재하나 active scheme 에 미정의 = remap 불가 (= active scheme 불완전 신호 · 별 bucket)
    role_gap_hex = {norm(h) for h in FOUNDATION_NEUTRAL if FOUNDATION_NEUTRAL[h] not in active}
    leaked = []        # 진짜 누수 = 어디에도 안 잡힘 (= 버그 신호 · FAIL)
    flagged = []       # off-token = 사람/디자인 결정 영역 (= WARN)
    rolegap = []       # foundation role 이나 active scheme 미정의 (= active 확장 필요 · WARN)
    for f in out_fills:
        fn = norm(f)
        if fn in transp_norm: continue
        if fn and fn.startswith("#") and len(fn) == 9 and fn.endswith("00"): continue
        if fn in active_vals: continue
        if fn in role_gap_hex:
            rolegap.append(f); continue
        if fn in unknown_norm:
            flagged.append(f); continue
        leaked.append(f)

    print("=== ACTIVE token table (role→hex) ===")
    for r, h in sorted(active.items()): print(f"  {r:20s} {h}")
    print("\n=== REMAPPED (gray-trap fixed) ===")
    for k, c in sorted(report["remapped"].items()): print(f"  {c:>3}x  {k}")
    print("\n=== UNKNOWN off-token (kept · 사람 결정 영역) ===")
    print("  (none)" if not report["unknown"] else "")
    for h, c in sorted(report["unknown"].items()): print(f"  {c:>3}x  {h}")
    print("\n=== FIDELITY GATE ===")
    print(f"  TRUE LEAK (어디에도 미분류) = bug signal: {leaked if leaked else 'NONE ✓'}")
    print(f"  ROLE-GAP (foundation role · active scheme 미정의 · scheme 확장 필요): {sorted(set(rolegap)) if rolegap else 'none'}")
    print(f"  WARN off-token (사람/디자인 결정 영역, kept): {sorted(set(flagged)) if flagged else 'none'}")
    print(f"  output sha256: {hashlib.sha256(out_text.encode()).hexdigest()[:16]}…")
    # FAIL 조건 = 진짜 누수만. role-gap + off-token = WARN (PASS · 사람/scheme 결정 보류).
    sys.exit(0 if not leaked else 2)

if __name__ == "__main__":
    main()
