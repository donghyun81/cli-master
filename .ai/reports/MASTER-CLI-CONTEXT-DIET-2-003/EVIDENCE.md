# EVIDENCE — MASTER-CLI-CONTEXT-DIET-2-003

## Requirements Source
- `cc-paste-MASTER-CONTEXT-DIET2-003.md` (전문 정독) — A안(44 rule → `docs/rules/` 이동) + 게이트(프로브 A). Coin 확정.
- Mode M5-cli-infra-ops · agent-commit: yes · production 0 LOC.

## Intake Normalization
| Field | Value |
|---|---|
| Work Type | 운영 레이어 변경 (cli infra 재배치) |
| Reading Mode | 6. CLI 운영 레이어형 (M5) |
| Requirement Source | 충족 (paste 계약) |
| Info Gap | RESOLVABLE_IN_REPO |
| STOP Risk | 프로브 A 미충족 / 보호 절차 실패 / rule 의미 변경 / 자식 surgical 범위 외 / baseline 전진분 접촉 / Money·EF·DB·production |
| Implementer Entry | Allowed (M5) |

## §0 게이트 — 프로브 A (PASS)
- 자기 관측: 본 세션 context 에 49 `.claude/rules/*.md` 전문 = "project instructions" 주입 확인.
- subagent 1회 spawn: `INJECTED_RULES_PRESENT=YES` · `cycle-discipline.md`(이동대상) + `safety-and-secrets.md`(잔존) 헤딩을 tool 없이 인용 = 주입 확증 · **subagent_tokens=288,612** (0 tool-use / 5줄 출력 = base ≈288K tok · 002 실측 242K corroborate).
- **판정: base 가 rules 주입을 강하게 뒷받침 (수만 tok급 아님) → STOP 미발동 · PROCEED.**

## baseline (A1/A2)
- 6-repo HEAD: master 4785c53 · FND 507f4d5 · GB d6ed1b3 · **GD 504da59**(frontmatter 7185b29 → 전진 · domain-only 실측 = STOP 미발동) · GT 6c0e200 · PDOCS 2a95840.
- GD 7185b29→504da59 · GT 5871e99→6c0e200 = `.claude/`/`docs/rules/` 무접촉 (git diff --name-only 실측) → forward-progress.
- 보호 5 manifest present · docs/rules/ 미존재(신설) · rules 49 file/485,045B · `paths:` frontmatter 0.

## Key Findings
- `.claude/rules/` 인용 = git grep 1092 지점 / 278 file (paste §10 386 = narrower 측정 · 대부분 history/task-artifact/잔존5 = sweep 제외).
- **machinery 하드코딩 = T3 열거보다 큼**: verify-sync.sh(11) · propagate.sh(2) · repo-config.sh(2) · activate-agent.sh(2) · test-protected-file-hooks.sh(6) · 3 hooks(pre-protected/instructions-loaded/baseline-snapshot). measure-gsm ch_l0 = 잔존 3 file → 무변동.
- 이동 후 broken-link 96 (`./→잔존` 36 · `../skills/` 13 · `./→other` 5 · `.claude/rules/<moved>` substr) → 전량 수복 (0 잔존).
- 3 unmoved 보호 file(ui-spec.schema/pencil-sot-policy/design-sot-policy) = moved-ref 0 → 무접촉 · sha 보존.
- 2 moved 보호 file = 경로문자열만 변경(pencil `../skills/` · uiux-sot 1 substr) → sha rebaseline.

## Cleanup Assessment
N/A (ops-layer task — 제품 코드 미변경)
