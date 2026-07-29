# pencil-cli — 멀티-repo umbrella caveat + 이력

> 본 file = [`../SKILL.md`](../SKILL.md) 분할물 (= 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` · **verbatim 이전 · 삭제 0**).
> headless 호출 자체엔 필요 없고, 멀티-repo 일괄 갱신/버전업 시점에만 여는 층.

---

### 7.3 멀티-repo umbrella caveat (= headless 필수 · 버전업 = delta-aware · pre-scan) — `MASTER-CLI-PENCIL-MULTIREPO-HEADLESS-001` (2026-06-24)

본 패키지 = 7-repo umbrella (= 4-active + 3 동결) · **활성 `.pen` 보유 = Selfward** (실측 2026-07-29: SW 14 · 동결 GB 13 / GD 11 / GT 11 = 읽기 인용만 · 쓰기 0). desktop-stdio MCP 는 **single active workspace** (= 관측상 GT) 에 anchored (= `pencil-mcp-tools-reference.md §0.2`). 따라서 (= SSOT 6-rule 중 본 skill 소관 = 2·4·5·6):

2. **멀티-repo `.pen` = headless 필수**: 자기 active-workspace 가 아닌 repo 의 `.pen` 작업 = headless 경로만 — ① 평문-JSON disk read/write (= `pencil-uiux-workflow.md §2.5` 기본) 또는 ② `pencil interactive -i/-o <path>` (= 파일 경로 동작 · §4.2). desktop-stdio MCP active-editor 의존 금지 (= 타 repo 측 GT file 반환·오염 risk). desktop MCP active-editor 진입 (= §7.1 desktop 행) = Coin 본인 단일 repo 실시간 시각 검증 한정.

4. **버전업 마이그 ≠ `save()` 재직렬화**: cross-version schema 마이그 (= 예 2.11→2.13 · delta canonical = `pencil-pen-format-schema.md §1.1a`) 는 `pencil interactive -i/-o` 측 `save()` 로 불가. CLI (= 관측 0.2.6) 측 입력 `.pen` 을 target schema 로 검증 → 입력 측 target-invalid (legacy) construct 잔존 시 load 실패 → `save()` 가 0 byte 출력 (= 실 file 파괴 risk). `save()` = 동일-version 재직렬화 한정. 버전업 = delta-aware 변환만 (= desktop app lenient auto-migrate semantic 재매핑 또는 전-delta surgical 평문-JSON 변환).

5. **마이그 전 pre-scan 의무 (= §1.1a delta 전수 · 예시 한정 금지)**: 버전업 전 대상 `.pen` 측 target-invalid construct 를 **§1.1a delta 1~10 전수** 점검 (= 특정 예시 토큰 [`stretch`/`note`/`line`/`icon_font`] 에 **한정 금지** · canonical = `pencil-pen-format-schema.md §1.1a`). delta 분기:
   - **mechanical delta** (= #1 `line` 제거 · #2 `icon_font`→`icon` rename [`iconFontName`/`iconFontFamily`→`icon`/`library`] · #3 `script` 신규 · #4 raw→typed variable · #5 **stroke flatten** [nested `thickness`→flat `strokeWidth`] · #6 `shader` fill · #7 TextContent array→scalar · #8 Group width/height 상실): delta-aware 변환 적용 (= 누락 시 version label 만 2.13 + construct 는 2.11-form 잔존 = **inconsistent 2.13**).
   - **content/layout-affecting delta** (= #9 `alignItems:"stretch"` 제거 [cross-axis 채움 layout semantic] · #10 inline `note` property 제거): **STOP + Coin 본심** (= visual parity / layout semantic · 임의 치환 금지).
   - 실측 선례: HOME-PEN-2.13 (= GB home.pen 2.11-era `alignItems:stretch`×1 + inline note×2 → CLI `save()` 0 byte) · ONBOARDING-2.13 (= GB onboarding.pen nested stroke `thickness`×7 미flatten [#5] → version 만 2.13 = **inconsistent 2.13** · GD/GT onboarding = 2.11-form 전수 0 정상 대조군).

6. **마이그 후 post-check assert (= 2.11-form 잔존 = 0 게이트)**: 버전업 변환 후 version `"2.13"` 선언 · dual-sha resync · commit **전**, 대상 `.pen` 측 **모든 2.11-form construct grep = 0 assert** (= rule 5 pre-scan 의 사후 대칭 게이트). 최소 점검 set:
   - `"thickness"` (= #5 nested stroke 미flatten) · `icon_font`/`iconFontName`/`iconFontFamily` (= #2 미rename) · `"type": "line"` (= #1 미제거) · `"alignItems": "stretch"` (= #9) · inline `"note":` node property (= #10) · (+ §1.1a 추가 form).
   - 결과 ≠ 0 = **미완 (inconsistent 2.13)** → mechanical delta 면 보강 후 재check · content/layout-affecting (#9/#10) 면 **STOP + Coin 본심**.
   - ★ `json.loads`/`json.load` 통과 = **syntax-valid 일 뿐 2.13-schema-valid 아님** (= 평문-JSON parse PASS 가 schema 정합을 보증하지 않음 · grep=0 assert 가 schema-form 게이트). 보충: #3 `script` / #6 `shader` = 2.13-신규 (= 2.11-form 부재 · post-check N/A) · #4 raw→typed var / #7 TextContent array / #8 Group width-height = form-shape delta (= 단순 grep 어려움 · rule 5 delta-aware pass 에서 manual 점검).

> 본 §7.3 = 멀티-repo headless + 버전업 delta-aware + pre-scan 전수 + post-check 본문 canonical (= rule 2/4/5/6) · rule 1 (MCP single workspace) + rule 3 (cross-verify disk) = `pencil-mcp-tools-reference.md §0.2` 단일. 본문 복제 X.

---

---

## 12. 명시 cycle 이력

- 2026-05-19 · `MASTER-CLI-PENCIL-OPTIMIZATION-001` · 직전 rule (`docs/rules/pencil-cli-headless.md`) 신설 + 5-repo byte-identical propagation
- 2026-05-26 · `MASTER-CLI-SKILLS-MIGRATION-PHASE-1-001` · 본 skill 신설 default (= 직전 rule 본문 본질 보존 default · skill paradigm 정합 default · trigger 시점 lazy load default · `docs/rules/pencil-cli-headless.md` 측 thin pointer 갱신 default)
- 2026-06-24 · `MASTER-CLI-PENCIL-MULTIREPO-HEADLESS-001` · §7.3 멀티-repo umbrella caveat 신설 (= rule 2 멀티-repo `.pen` = headless 필수[평문-JSON 또는 `pencil interactive -i/-o`] · desktop-stdio MCP active-editor 의존 금지[GT anchored] · rule 4 버전업 마이그 = delta-aware only[`save()` cross-version 불가 · CLI 0.2.6 target-schema 검증 → 0 byte] · rule 5 마이그 전 target-invalid token pre-scan 의무 · content/layout-affecting 시 STOP+Coin) + §7.1 분기표 2-row 추가 (멀티-repo `.pen` / cross-version 마이그) · rule 1/3 본문 canonical = `pencil-mcp-tools-reference.md §0.2`. pointer only (= add-only) · 6-repo byte-identical propagation. HOME-PEN-2.13 혼선 근본 mitigation.
- 2026-06-24 · `MASTER-CLI-PENCIL-PRESCAN-EXHAUSTIVE-001` · §7.3 rule 5 pre-scan 전수화 + rule 6 post-check assert 신설 (= ONBOARDING-2.13 GB onboarding.pen `thickness`×7 미flatten[#5] → version 만 2.13 = inconsistent 2.13 재발 근본 차단). rule 5 = target-invalid 점검을 §1.1a delta 1~10 **전수**로 강화 (= 예시 토큰 [`stretch`/`note`/`line`/`icon_font`] 한정 금지 · mechanical delta[#1~#8] delta-aware 적용 / content-affecting [#9/#10] STOP+Coin). rule 6 = 마이그 후 version `"2.13"` 선언·dual-sha resync·commit 전 모든 2.11-form construct grep=0 assert (= 최소 set `thickness`/`icon_font`·`iconFontName`·`iconFontFamily`/`"type":"line"`/`alignItems:"stretch"`/inline `"note":` · ≠0 = inconsistent 2.13 · `json.load` 통과 = syntax-valid ≠ schema-valid 명시). 헤더 SSOT 6-rule(소관 2·4·5·6) + footer canonical rule 2/4/5/6 + §7.1 cross-version row post-check 반영. mcp-tools §0.2 = rule 4 말미 post-check pointer 1줄 (= 상호 pointer · 본문 canonical = 본 §7.3). 기존 rule 1~5 의미 무변경(5 강화 + 6 신설) · §1.1a 본문 무편집(참조만) · add-only · pointer only · 6-repo byte-identical propagation.
