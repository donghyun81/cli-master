---
name: pencil-recolor
description: Use when remapping a .pen file's foundation-Neutral gray-trap fills to an active child brand colorScheme via the headless deterministic generator (pen_recolor.py). Covers code→.pen recolor (gray-trap fix), foundation Neutral role→hex fingerprint, fidelity gate (true-leak / role-gap / off-token WARN), and dual-layer ui-spec.json sha sync. No Pencil app required — pure JSON read/write.
paths: docs/design/pencil-sot/**, **/*.pen
allowed-tools: Bash, Read
---

# Pencil Recolor — headless gray-trap → brand 결정론 remap

> **단일 목적**: 자식 `.pen` 파일이 foundation Neutral 색을 캡처한 gray-trap 을, 활성 자식 brand colorScheme 으로 결정론 remap 하는 headless generator (`pen_recolor.py`) 의 호출 + fidelity gate + dual-layer sha sync paradigm.
> **신설**: MASTER-CLI-PENCIL-RECOLOR-GENERATOR-001 (2026-05-31).
> **공식 근거**: foundation Color.kt @ git `0761747` (= Phase 1 삭제 전 Neutral 값) · cowork sandbox 실증 (GD 10 screen · true-leak 0 + role-gap 0).
> **연관 파일**:
> - `pencil-uiux-workflow.md` §9 (보호) — recolor sub-flow 진입점 (headless 경로)
> - `pencil-pen-format-schema.md` §1.1 — `.pen` version `"2.11"` Document + raw hex fill
> - `design-to-code-sync.md` §1 + §4 — dual-layer SoT + Output Checklist (P1~P3 sha sync)
> - `pencil-cli/SKILL.md` — desktop app vs headless 분기 (본 skill = pure JSON headless · Pencil app 무관)
> SOT: `CLAUDE.md`

---

## 1. 본질 (= gray-trap remap)

자식 `.pen` 의 fill / stroke 중 foundation Neutral hex (= Phase 1 삭제 전 `Color.kt` 의 neutral role) 로 박힌 영역을 활성 자식 brand colorScheme 의 동일 role 값으로 결정론 치환한다.

```
raw hex  →  (foundation Neutral role 역추적)  →  active brand hex (동일 role)
```

- gray-trap = foundation Neutral 색이 자식 brand 색 자리에 박혀 있는 상태 (= 자식 brand identity 미반영).
- 색만 교체 · 구조 / 좌표 / 텍스트 무변경 (= Phase 1 D2 구조 유지 정합).
- off-token (= 하드코딩 일러스트 색 등) = 교체 안 함 + report 에 WARN (= 사람 / 디자인 결정 영역).

---

## 2. 호출 (= headless · Pencil app 무관)

```bash
python3 .claude/skills/pencil-recolor/pen_recolor.py \
  --pen  docs/design/pencil-sot/<screen>/<screen>.pen \
  --theme <repo>/.../shared/ui/theme/<Repo>Theme.kt \
  --out  docs/design/pencil-sot/<screen>/<screen>.pen
```

| 인자 | 본질 |
|---|---|
| `--pen` | 대상 `.pen` (= 구조 source · fill / stroke 만 교체) |
| `--theme` | 활성 자식 `<Repo>Theme.kt` (= `lightColorScheme(role = ValName, ...)` + `val ValName = Color(0xFFRRGGBB)` parse → role→hex resolve table) |
| `--out` | 교정 `.pen` 출력 (= in-place 시 `--pen` 과 동일 경로 · 자율) |

`.pen` 은 JSON 직렬 (= MCP encryption 영역 아님 · `version: "2.11"` raw hex). generator 는 `json.load` 로 직접 read · MCP tool 불요.

---

## 3. foundation Neutral fingerprint (= 내장 dict)

`pen_recolor.py` 내 `FOUNDATION_NEUTRAL` dict = git `0761747` `Color.kt` Neutral role→hex 고정 historical 값. 주요 entry:

| hex | role | 비고 |
|---|---|---|
| `#5A6470` | primary | |
| `#1A1C1E` | onSurface | OnBackground == OnSurface |
| `#E7E8EA` | surfaceVariant | |
| `#44474C` | onSurfaceVariant | |
| `#FFFFFF` | surface | ⚠ role collision (Surface AND OnPrimary 등) → context 없는 raw hex 는 surface 처리 + report 기록 |

dict 갱신 = foundation Color.kt historical 값 재측정 후 본 generator 내 dict 정정 (= 별 cycle · 본 skill body 무접촉).

---

## 4. fidelity gate (= 출력 모든 fill 분류)

generator 가 출력 후 모든 fill / stroke 를 4 bucket 으로 분류 + exit code:

| bucket | 본질 | 판정 |
|---|---|---|
| **TRUE LEAK** | active token / transparent / role-gap / off-token 어디에도 안 잡힘 | **버그 신호 · FAIL (exit 2)** |
| ROLE-GAP | foundation role 이나 active scheme 미정의 (= scheme 확장 필요) | WARN (PASS) |
| WARN off-token | foundation Neutral 외 hex (= 사람 / 디자인 결정 영역 · kept) | WARN (PASS) |
| transparent / active | 정상 | PASS |

**TRUE LEAK ≠ 0 = STOP** (= remap 누락 신호 · fingerprint dict 재측정 의무). role-gap + off-token 은 PASS (= scheme 확장 / 사람 결정 보류).

full 24-role active scheme 기준 = role-gap 0 이 정상 (= minimal scheme 면 Container / outline 계열 role-gap 발생 가능).

---

## 5. dual-layer sha sync (= 별 step · CLI)

generator 는 `.pen` 만 교체. 후속 dual-layer 정합은 CLI 가 별 step 으로 수행 (`design-to-code-sync.md` §1 + §4 P1~P3 정합):

```bash
NEW_SHA=$(shasum -a 256 docs/design/pencil-sot/<screen>/<screen>.pen | cut -d' ' -f1)
# <screen>.ui-spec.json 의 lastSyncedDesignToolStateHash = $NEW_SHA (full 64자) 갱신
```

- P1: `.pen` 디스크 존재 + sha 갱신
- P2: `.ui-spec.json` `lastSyncedDesignToolStateHash` = full 64자 sha
- P3: 두 SoT sha 일치 (`verify-sync.sh` 자식 repo 안)

---

## 6. STOP 조건

| trigger | mitigation |
|---|---|
| TRUE LEAK ≠ 0 | 즉시 STOP + `FOUNDATION_NEUTRAL` fingerprint dict 재측정 (= remap 누락 신호) |
| generator 가 색 외 구조 / 좌표 / 텍스트 변경 징후 | STOP (= scope expansion · 본 generator = fill / stroke 한정) |
| `--theme` parse 결과 role→hex table 비어 있음 | STOP + `<Repo>Theme.kt` 측 `lightColorScheme(...)` 블록 형식 확인 (= `role = ValName,` + `val ValName = Color(0xFFRRGGBB)`) |
| `.pen` json.load FAIL (= encryption / 비-JSON) | STOP + MCP tool 경로 (`pencil-cli` skill) 재평가 |

---

## 7. 본 skill 의 변경 정책

- cli infra 권장 byte-identical (= 6-repo · master + 5 자식 · 보호 5 file 외)
- 변경 시 master cycle 신설 + 6-repo propagation (`cycle-discipline.md` §15 패턴 1)
- 자식 repo 직접 수정 금지

---

## 8. 명시 cycle 이력

- 2026-05-31 · MASTER-CLI-PENCIL-RECOLOR-GENERATOR-001 · 본 skill 신설 (= `pen_recolor.py` 검증된 generator + SKILL.md body · GD 10 screen sandbox 실증 true-leak 0 + role-gap 0) + 5-repo byte-identical propagation
