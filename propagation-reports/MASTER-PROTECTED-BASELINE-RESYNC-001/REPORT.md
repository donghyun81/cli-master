# REPORT — MASTER-PROTECTED-BASELINE-RESYNC-001

- 마감일: 2026-05-03
- scope: 다중 (master → 4-repo)
- 변경 파일: 5 (master) + 1 (각 자식 × 3) = 8

## 본 cycle 의 목적

본부의 *공식 인증서* (`protected-file-hashes.md` + `propagation-status.md`) 가 후속 cycle 의 변경을 baseline 에 반영 못해 가짜 drift 알람을 만들고 있음. 새 sha 로 갱신하고, ui-spec.schema 의 enum 모순 (description 은 v0.3 인데 enum 은 0.2 까지만) 정상화.

## sha matrix (4-repo · cross-verify PASS)

| 파일 | master | GB | GD | GT |
|---|---|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `0a82b895` | ✓ MATCH | ✓ MATCH | ✓ MATCH |

### master 보호 파일 5종 새 baseline (full 64자)

| 파일 | 새 sha |
|---|---|
| `docs/schemas/ui-spec.schema.json` | `0a82b89575550fe92d9258e9b544b61ccaea96cfc04cd6fda309c3ff9a0da495` |
| `.claude/rules/uiux-sot-refresh.md` | `ee377dc2ac32357f61fa1b2bfc39690ab530b65102e31062bff91ab6b8b260d3` |
| `docs/design/design-sot-policy.md` | `e5e3fe165ec3a826b2843f0e9791d4e6f07fb4c226bcc53639868787da49af03` |
| `.claude/rules/pencil-uiux-workflow.md` | `7621013e7f2dc644f0d0028b0574e12949dc7462953b4d5465c8a1186d6f0c0f` |
| `docs/design/pencil-sot-policy.md` | `96de2f5d10a73af4aaa2608770f503dd3956304846c6db8a9b2cf2d05cba6559` |

## verify

| step | command | exit |
|---|---|---|
| schema enum v0.3 추가 | `grep -n '"0.3"' docs/schemas/ui-spec.schema.json` | 0 (line 16 hit) |
| 5종 sha baseline 갱신 | `shasum -a 256 ...` × 5 → `protected-file-hashes.md` 표 5행 | 0 (모두 일치) |
| propagation-status 갱신 | 8자 prefix 5행 + 1줄 추가 | 0 |
| 4-repo schema sha 일치 | `shasum -a 256 ...` × 4 (gently-master + GB + GD + GT) | 0 (4 줄 동일 sha = `0a82b895...`) |

## 변경 인벤토리

### master (5 파일)
- `docs/schemas/ui-spec.schema.json` — line 16 enum: `["0.1","0.2"]` → `["0.1","0.2","0.3"]` (description 무수정)
- `.auto-memory/protected-file-hashes.md` — 표 5행 sha 갱신 + 변동 컬럼 cycle ID 표기 + Recent updates 1줄
- `.auto-memory/propagation-status.md` — 보호 파일 매트릭스 5행 8자 prefix 갱신 + 1줄 추가
- `CLAUDE.md` — §15 cycle entry 1행 추가
- `propagation-reports/MASTER-PROTECTED-BASELINE-RESYNC-001/REPORT.md` — 본 파일 신설

### 자식 repo (각 1 파일)
- GB / GD / GT 의 `docs/schemas/ui-spec.schema.json` — master byte-identical cp (sha `0a82b895...`)

## 별 trail (open · 본 cycle scope 외)

- `MIGRATE-UISPEC-V03-001` — 자식 ui-spec.json `schemaVersion="0.3"` 마이그레이션 (별 cycle 권장)
- `MASTER-DOC-CITATION-FIX-001` — ui-spec.schema.json description 의 Pencil 잔존 어휘 정정 + 인용 정정 3 곳 (별 cycle 권장)
- `MASTER-CLI-DRIFT-MITIGATION-GB-001` — GB 의 ux-laws / design-to-code-sync drift 정정 (별 cycle 권장)
- `MASTER-PATH-REBIND-CLOSE-001` — `scripts/propagate.sh` default `claude-cli-master` → `gently-master` 갱신 (별 cycle 권장)
- ui-spec.schema.json 의 `pencilFrameCode` / `pencilInherits` / `migratedFrom` / `lastSyncedPencilStateHash` alias 처리 — 별 cycle 권장 (`MIGRATE-UISPEC-V03-001` 안 또는 별 cycle 검토)
- `<repo>-UIUX-SOT-LATEST-INIT-001` × 3 — 각 repo `.ai/uiux-sot/latest/` baseline 5 파일 신설 (각 repo 독립 · 병렬 가능)
