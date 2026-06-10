#!/usr/bin/env python3
# MASTER-CLI-REPO-COUNT-VOCAB-SWEEP-001 — 건별 판정 치환 테이블 집행기
# blanket sed 아님: (file, line, [(old,new)...]) 전수 단언 후 적용. 단언 1건 실패 = 전체 미적용.
import sys, os

M = "/Users/yundonghyeon/AndroidStudioProjects/claude-cli-master/"
P = "/Users/yundonghyeon/AndroidStudioProjects/"
R = M + ".claude/rules/"
A = M + ".claude/agents/active/"
S = M + ".claude/skills/"
H = M + ".claude/hooks/"

PROP = ("5-repo propagation", "6-repo propagation")
BI   = ("5-repo byte-identical", "6-repo byte-identical")
M4   = ("(5-repo · master + 4 자식)", "(6-repo · master + 5 자식)")
E1   = ("(= 5-repo · master + app-foundation + GentlyBreath + GentlyDay + GentlyTable)",
        "(= 6-repo · master + app-foundation + GentlyBreath + GentlyDay + GentlyTable + gently-product-docs)")
E2   = ("(5-repo · master + app-foundation + GentlyBreath + GentlyDay + GentlyTable)",
        "(6-repo · master + app-foundation + GentlyBreath + GentlyDay + GentlyTable + gently-product-docs)")
E3   = ("5-repo · master + app-foundation + GentlyBreath + GentlyDay + GentlyTable ·",
        "6-repo · master + app-foundation + GentlyBreath + GentlyDay + GentlyTable + gently-product-docs ·")
GBGD = ("(= 5-repo · master + app-foundation + GB + GD + GT)",
        "(= 6-repo · master + app-foundation + GB + GD + GT + gently-product-docs)")
RC   = ("scripts/agent/repo-config.sh", "scripts/repo-config.sh")

EDITS = [
 (R+"abbreviation-policy.md", [
   (3, [("5-repo 패키지 (claude-cli-master + app-foundation + GentlyBreath + GentlyDay + GentlyTable)",
         "6-repo 패키지 (claude-cli-master + app-foundation + GentlyBreath + GentlyDay + GentlyTable + gently-product-docs)")]),
   (107,[PROP]), (261,[PROP]), (366,[PROP]),
   (386,[("(= 5-repo ·","(= 6-repo ·")]), (387,[PROP])]),
 (R+"anchor-list.md", [
   (3,[("5-repo 측","6-repo 측")]), (32,[("5-repo HEAD","6-repo HEAD")]),
   (37,[("5-repo 측","6-repo 측")]), (46,[BI]), (78,[BI])]),
 (R+"architecture-foundation-link-policy.md", [
   (6,[PROP]),
   (47,[("5-repo 측 file 위치","6-repo 측 file 위치"),("(= 5-repo 동일 path)","(= 6-repo 동일 path)")]),
   (50,[("5-repo 모두 동일 표기","6-repo 모두 동일 표기")]),
   (51,[("claude-cli-master + GB + GD + GT + app-foundation 모두",
         "claude-cli-master + GB + GD + GT + app-foundation + gently-product-docs 모두")]),
   (121,[("(= 5-repo ·","(= 6-repo ·")]), (122,[PROP])]),
 (R+"auth-rules.md", [(88,[PROP])]),
 (R+"automation-policy.md", [(3,[("5-repo 측","6-repo 측")])]),
 (R+"billing-rules.md", [(97,[PROP])]),
 (R+"cross-repo-parallel-exec-detail.md", [
   (34,[("5-repo 측","6-repo 측")]), (36,[BI]),
   (162,[("5 file × 5-repo byte-identical","5 file × 6-repo byte-identical")]),
   (221,[("5-repo byte-identical 의무 (= master + 4 자식 측 동일 sha)",
          "6-repo byte-identical 의무 (= master + 5 자식 측 동일 sha)")]),
   (222,[("5-repo byte-identical 의무","6-repo byte-identical 의무")])]),
 (R+"cross-repo-parallel-exec.md", [
   (3,[GBGD]), (18,[("(= 5-repo)","(= 6-repo)")]), (31,[BI]),
   (83,[("`5-repo` / `3 자식`","`6-repo` / `5-repo` / `3 자식`")]),
   (85,[("`cli infra 5-repo` / `master + 4 자식`","`cli infra 6-repo` / `master + 5 자식`")]),
   (96,[("(= 5-repo · master + 4 자식)","(= 6-repo · master + 5 자식)")]), (97,[PROP])]),
 (R+"cycle-discipline.md", [
   (419,[("char(5-repo별","char(6-repo별")]), (480,[PROP]),
   (488,[("(= 5-repo · 2026-05-19 신설","(= 6-repo · 2026-05-19 신설")]),
   (490,[GBGD,("cli infra 5-repo byte-identical","cli infra 6-repo byte-identical")]),
   (494,[("= 5-repo (= master + app-foundation + GB + GD + GT)",
          "= 6-repo (= master + app-foundation + GB + GD + GT + gently-product-docs)")]),
   (498,[("cli infra 5-repo byte-identical","cli infra 6-repo byte-identical")]),
   (515,[("cli infra 5-repo byte-identical","cli infra 6-repo byte-identical")]),
   (527,[PROP]), (534,[("(= 5-repo HEAD sha","(= 6-repo HEAD sha")]),
   (545,[PROP]), (594,[PROP])]),
 (R+"deferred-domains.md", [
   (34,[("(5-repo 통합 baseline · master + app-foundation + GentlyBreath + GentlyDay + GentlyTable)",
         "(6-repo 통합 baseline · master + app-foundation + GentlyBreath + GentlyDay + GentlyTable + gently-product-docs)")]),
   (77,[("**5-repo propagation**","**6-repo propagation**")])]),
 (R+"design-prompting-paradigm.md", [(187,[M4]), (188,[PROP])]),
 (R+"design-to-code-sync.md", [
   (12,[("`design-sot-refresh.md` (보호 · refresh trigger 분류)",
         "`uiux-sot-refresh.md` (보호 · refresh trigger 분류 · 의미 = design-sot-refresh)")]),
   (87,[("`design-sot-refresh.md` (보호) 의","`uiux-sot-refresh.md` (보호 · 의미 = design-sot-refresh) 의")])]),
 (R+"domain-roles.md", [(54,[("generic(5-repo byte-identical)","generic(6-repo byte-identical)")])]),
 (R+"gsm-measurement.md", [
   (3,[("5-repo cli infra","6-repo cli infra")]), (42,[BI]),
   (54,[("| 5-repo byte-identical |","| 6-repo byte-identical |")]),
   (55,[("| 5-repo byte-identical |","| 6-repo byte-identical |")]),
   (82,[("| 5-repo byte-identical |","| 6-repo byte-identical |")]),
   (123,[("(5-repo · master + 4 자식 ·","(6-repo · master + 5 자식 ·")]), (124,[PROP])]),
 (R+"libs-versions-cross-verify.md", [
   (6,[PROP]), (68,[("5-repo propagate","6-repo propagate")]),
   (98,[("5-repo 마감 후","6-repo 마감 후")]), (139,[M4]), (140,[PROP])]),
 (R+"mode-system.md", [
   (3,[("5-repo 측","6-repo 측")]), (38,[BI]),
   (39,[("5-repo cross-verify","6-repo cross-verify")]),
   (66,[("현 단계 = 5-repo 동일 mode","현 단계 = 6-repo 동일 mode")]),
   (68,[("현 5-repo 측","현 6-repo 측")])]),
 (R+"pencil-component-paradigm.md", [(364,[M4]), (365,[PROP])]),
 (R+"pencil-mcp-tools-reference.md", [(272,[M4]), (273,[PROP])]),
 (R+"pencil-pen-format-schema.md", [(385,[PROP]), (394,[M4]), (395,[PROP])]),
 (R+"pencil-theme-multi-axis.md", [(342,[M4]), (343,[PROP])]),
 (R+"pencil-visual-primitives.md", [(443,[M4]), (444,[PROP])]),
 (R+"plugin-policy.md", [
   (3,[("5-repo 측","6-repo 측")]), (32,[("5-repo 전부","6-repo 전부")]),
   (41,[BI]), (58,[("5-repo 동일 구성","6-repo 동일 구성")]),
   (66,[("(= 5-repo byte-identical 보존","(= 6-repo byte-identical 보존")]), (68,[BI])]),
 (R+"reporting.md", [(454,[E3]), (455,[PROP])]),
 (R+"routing-and-delegation.md", [
   (162,[GBGD]),
   (177,[('키워드: "5-repo" /','키워드: "6-repo" / "5-repo" /')])]),
 (R+"rule-routing-index.md", [
   (41,[("5-repo 단방향","6-repo 단방향")]), (43,[("(5-repo umbrella)","(6-repo umbrella)")]),
   (155,[("5-repo","6-repo")]), (175,[("5-repo","6-repo")])]),
 (R+"safety-and-secrets.md", [(168,[PROP]), (194,[PROP])]),
 (R+"sot-code-name-map.md", [
   (1,[E3]), (11,[("5-repo 수기","6-repo 수기")]),
   (121,[("5-repo cp propagation","6-repo cp propagation")])]),
 (R+"supabase-handling.md", [
   (11,[PROP]), (177,[E2]), (178,[PROP]),
   (197,[("(= 5-repo byte-identical","(= 6-repo byte-identical"),
         ("`GentlyTable`):","`GentlyTable` + `gently-product-docs`):")]),
   (243,[("5-repo byte-identical propagation","6-repo byte-identical propagation"),
         ("본문 = 5-repo 동일","본문 = 6-repo 동일")])]),
 (R+"terminology.md", [(64,[("4. 5-repo propagation","4. 6-repo propagation")]), (71,[E2]), (72,[PROP])]),
 (R+"text-degeneration-prevention.md", [(6,[PROP]), (163,[M4]), (164,[PROP])]),
 (R+"workflow-core.md", [(6,[("(5-repo 정합","(6-repo 정합")])]),
 (R+"workflow-policy.md", [
   (3,[("5-repo 측","6-repo 측")]),
   (86,[("5-repo byte-identical propagation","6-repo byte-identical propagation")]),
   (102,[("(5-repo · master + 4 자식 ·","(6-repo · master + 5 자식 ·")]), (103,[PROP])]),
 (A+"cross-repo-orchestrator.md", [
   (3,[GBGD]), (11,[GBGD]),
   (18,[('"5-repo" /','"6-repo" / "5-repo" /')]),
   (20,[("cli infra 5-repo","cli infra 6-repo")]),
   (36,[("(= 5-repo 전체","(= 6-repo 전체")]), (46,[("(= 5-repo 전체","(= 6-repo 전체")]),
   (62,[("(= 5-repo umbrella","(= 6-repo umbrella")]), (66,[("(= 5-repo HEAD sha","(= 6-repo HEAD sha")]),
   (129,[("<5-repo /","<6-repo /")]),
   (152,[("(= 5-repo · master + 4 자식)","(= 6-repo · master + 5 자식)")]), (153,[PROP])]),
 (A+"layer-checker.md", [(10,[RC]), (49,[RC]), (52,[RC]), (60,[RC])]),
 (S+"check-layer/SKILL.md", [(15,[RC]), (21,[RC]), (24,[RC]), (32,[RC])]),
 (S+"disk-verification/SKILL.md", [
   (96,[("5-repo HEAD sha","6-repo HEAD sha")]), (113,[PROP]), (249,[E1]), (250,[PROP])]),
 (S+"initiatives-sync/SKILL.md", [
   (194,[("5-repo HEAD sha","6-repo HEAD sha")]), (236,[E1]), (237,[PROP])]),
 (S+"paste-source-authoring/SKILL.md", [(203,[E1]), (204,[PROP])]),
 (S+"pencil-cli/SKILL.md", [(262,[M4]), (263,[PROP])]),
 (S+"pencil-pen-save/SKILL.md", [
   (70,[("5-repo propagation 정책","6-repo propagation 정책"),
        ("모두 5-repo byte-identical","모두 6-repo byte-identical")])]),
 (S+"pencil-recolor/SKILL.md", [
   (116,[("(= 5-repo · master + 4 자식 ·","(= 6-repo · master + 5 자식 ·")]), (117,[PROP])]),
 (S+"run-master/SKILL.md", [(16,[("5-repo cli infra sha 정합","6-repo cli infra sha 정합")])]),
 (S+"runtime-crash-mitigation/SKILL.md", [
   (136,[("5-repo paradigm","6-repo paradigm")]),
   (158,[("5-repo HEAD sha","6-repo HEAD sha")]), (200,[E1]), (201,[PROP])]),
 (H+"baseline-snapshot.sh", [
   (3,[("5-repo (claude-cli-master + app-foundation + Gently 3)",
        "6-repo (claude-cli-master + app-foundation + Gently 3 + gently-product-docs)")]),
   (23,[("(= 5-repo 가","(= 6-repo 가")]),
   (25,[("5-repo = dirname","6-repo = dirname")]), (26,[("5-repo = PROJECT_DIR","6-repo = PROJECT_DIR")])]),
 (H+"pre-protected-file-edit-sha-verify.sh", [
   (8,[("across 5-repo","across 6-repo")]), (109,[("5-repo","6-repo")])]),
 (M+"scripts/verify-sync.sh", [
   (2,[("5-repo cli infra","6-repo cli infra")]), (161,[("5-repo sha 동기 검증","6-repo sha 동기 검증")])]),
 (M+"scripts/repo-config.sh", [(21,[PROP])]),
 (M+"scripts/propagate.sh", [
   (5,[("[--targets GB,GD,GT|all]","[--targets GB,GD,GT,FND|all]")]),
   (6,[("[--targets GB,GD,GT|all]","[--targets GB,GD,GT,FND|all]")])]),
 (M+"scripts/nightly-baseline-report.sh", [
   (67,[("측정 A — 5-repo HEAD","측정 A — 6-repo HEAD")]),
   (86,[("× 5-repo sha matrix","× 6-repo sha matrix")]),
   (222,[("### A. 5-repo HEAD","### A. 6-repo HEAD")]),
   (226,[("× 5-repo sha matrix","× 6-repo sha matrix")]),
   (259,[("## 2. 5-repo HEAD","## 2. 6-repo HEAD")]),
   (323,[("## A. 5-repo HEAD","## A. 6-repo HEAD")])]),
 (M+"CLAUDE.md", [
   (34,[("현 단계 = 5-repo 동일 mode","현 단계 = 6-repo 동일 mode"),
        ("현 5-repo 측 default mode","현 6-repo 측 default mode")]),
   (72,[("[--targets GB,GD,GT]","[--targets FND,GB,GD,GT|all]")]),
   (95,[("본 § = 5-repo 측","본 § = 6-repo 측")]),
   (107,[("| 5-repo 측 동시 영향","| 6-repo 측 동시 영향")])]),
 (P+"CLAUDE.md", [(42,[("(= 5-repo 공통 아키텍처)","(= 6-repo 공통 아키텍처)")])]),
]

# phase 1: 전수 단언
errors = []
plans = []
for path, lineedits in EDITS:
    if not os.path.isfile(path):
        errors.append(f"FILE MISSING: {path}"); continue
    with open(path, encoding="utf-8") as fh:
        lines = fh.readlines()
    for lineno, pairs in lineedits:
        if lineno > len(lines):
            errors.append(f"{path}:{lineno} 행 부재 (총 {len(lines)})"); continue
        text = lines[lineno-1]
        for old, new in pairs:
            if old not in text:
                errors.append(f"{path}:{lineno} 단언 실패 — '{old[:60]}' 부재")
    plans.append((path, lineedits, lines))

if errors:
    print("=== VALIDATION FAIL — 적용 0 ===")
    for e in errors: print(e)
    sys.exit(2)

# phase 2: 적용
applied = 0
files_changed = 0
for path, lineedits, lines in plans:
    for lineno, pairs in lineedits:
        for old, new in pairs:
            lines[lineno-1] = lines[lineno-1].replace(old, new)
            applied += 1
    with open(path, "w", encoding="utf-8") as fh:
        fh.writelines(lines)
    files_changed += 1

print(f"=== APPLY OK === files={files_changed} pair-applications={applied}")
