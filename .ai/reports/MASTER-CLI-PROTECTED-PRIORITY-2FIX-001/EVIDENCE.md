## Requirements Source

- 사용자 cycle prompt `MASTER-CLI-PROTECTED-PRIORITY-2FIX-001` 직 인용 (본 turn 진입 메시지)
- 2 사고 단일 cycle 묶음 mitigation:
  - δ (L2-#2): scripts/verify-sync.sh PROTECTED 배열 4종 → 5종 확장 (`docs/design/design-sot-policy.md` 누락 영역 정합)
  - ζ (L3-3): safety-and-secrets.md §절대 금지 명령 vs cycle-discipline.md §5 v2 우선순위 양방향 cross-ref 1-2 줄 명시
- Authority boundary: scripts/verify-sync.sh PROTECTED 배열 영역 + cycle-discipline §5 v2 + safety-and-secrets §절대 금지 명령 영역 cross-ref 영역만. 본문 본질 (deny list 표 / 자동 허용 카테고리 / Coin direct 강제 영역) 무접촉.

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | cli infra ops-layer (scripts + rules cross-ref · 정책 충돌 영역 우선순위 명시) |
| Reading Mode | cli 운영 레이어형 |
| Requirement Source | 사용자 cycle prompt (직 인용 + STOP 9 조건 명시됨 + BASELINE 정합) |
| Info Gap | RESOLVABLE_IN_REPO (reference 영역 모두 disk 측 read 마감) |
| STOP Risk | Low (보호 5종 sha 변동 X · 본문 본질 영역 변경 X · cross-ref 1-2 줄만) |
| Read-Only Fan-Out | N/A (단일 cycle · 3 file 영역만) |
| Implementer Entry | Allowed (pre-EVIDENCE 계약 본 file 로 고정) |

## Pre-EVIDENCE Contract

- Read evidence: scripts/verify-sync.sh L91-96 PROTECTED 배열 4종 (사전 baseline) · L97-118 CORE_CLI 배열 N종 · L120-121 `--quick` 모드 측 CHECK_FILES = PROTECTED + CORE_CLI 영역 · cycle-discipline.md L59-75 §5 v2 (자동 허용 + Coin direct 강제 + 분류 모호 + 묵시 동의 + v2 도입 근거) · safety-and-secrets.md L9-23 §절대 금지 명령 (enforcement 경계 + 표 7 영역 명령 deny · `git commit` 포함) · protected-file-hashes.md SoT 5종 명시 · CLAUDE.md §2 5종 명시 · cycle-discipline §3 5종 명시
- Remaining gaps: 없음
- Chosen path: STEP 0~7 workflow-core 9 단계 정합 · master 단일 commit (3 file) → propagate.sh (cycle-discipline + safety-and-secrets 만 cp · scripts/verify-sync.sh 영역 = 자식 측 부재 baseline 영역 별 처리) → 자식 3-repo single commit each → verify-sync
- Hold / Stop reasons: STOP 9 조건 (보호 5종 sha 변동 / safety-and-secrets 본질 변경 / cycle-discipline §5 v2 본질 변경 / verify-sync.sh PROTECTED 외 영역 변경 / scope 외 file 변경 / propagate mismatch / self-test FAIL / cycle scope 부풀음 / 무관 WT dirty stage 흡수)
- Implement entry conditions: 4-repo HEAD = `f6f1bdc/af21cd5/04afab8/6518d01` MATCH ✓ · 본 cycle 3 영역 file sha (`5db17df2 / 9c5021e5 / 7e9e35b4`) MATCH ✓ · 보호 5종 sha baseline MATCH ✓

## Collect Results

### 매칭 파일/패턴 (변경 대상 3 file)

- `claude-cli-master/scripts/verify-sync.sh` sha `5db17df23b9b156c…` — δ: L91-96 PROTECTED 배열 4종 → 5종 확장 (5번째 라인 `docs/design/design-sot-policy.md` 추가) · **자식 3-repo 측 부재** (scripts/ 직접 영역 = master 전용 영역 · propagate.sh L95 find scope `.claude docs scripts/agent ...` 안 `scripts/` 직접 영역 부재 정합)
- `claude-cli-master/.claude/rules/cycle-discipline.md` sha `9c5021e50834abb0…` (4-repo byte-identical) — ζ: §5 v2 본문 (L59-75) 안 양방향 cross-ref 1-2 줄 추가
- `claude-cli-master/.claude/rules/safety-and-secrets.md` sha `7e9e35b41ad65946…` (4-repo byte-identical) — ζ: §절대 금지 명령 본문 (L9-23) 안 양방향 cross-ref 1-2 줄 추가

### Reference 본문 영역 (read-only · 본문 작성 reference)

- `scripts/verify-sync.sh` L91-96 PROTECTED 배열 = δ 영역 정정 위치. 사전 baseline 4 line:
  ```
  PROTECTED=(
    docs/schemas/ui-spec.schema.json
    .claude/rules/pencil-uiux-workflow.md
    docs/design/pencil-sot-policy.md
    .claude/rules/uiux-sot-refresh.md
  )
  ```
  → 5번째 라인 `docs/design/design-sot-policy.md` 추가 의무 영역.
- `cycle-discipline.md` L59-75 §5 v2 = ζ 영역 cross-ref 추가 위치 (L60 본문 머리 또는 L75 영역 v2 도입 근거 단락 후).
- `safety-and-secrets.md` L9-23 §절대 금지 명령 = ζ 영역 cross-ref 추가 위치 (L11 enforcement 경계 quote 직후 또는 L23 표 직후).
- `.auto-memory/protected-file-hashes.md` SoT = 5종 명시 baseline (= δ 영역 SoT vs verify-sync.sh 4종 mismatch 영역 정합).
- propagate.sh L95 find scope `.claude docs scripts/agent .ai/promptfit .ai/uiux-sot/refresh .github` = `scripts/` 직접 영역 부재 baseline (= scripts/verify-sync.sh 자식 propagation 영역 검증 의무).

### 0 Matches (부재 증거)

- master scripts/verify-sync.sh L91-96 PROTECTED 배열 안 `docs/design/design-sot-policy.md` line = 부재 (= δ 사고 영역 정합)
- master cycle-discipline.md §5 v2 본문 안 `safety-and-secrets` 인용 / cross-ref 영역 = 부재 (= ζ 사고 영역 정합)
- master safety-and-secrets.md §절대 금지 명령 본문 안 `cycle-discipline §5 v2` 인용 / cross-ref 영역 = 부재 (= ζ 사고 영역 정합)
- 자식 3-repo scripts/verify-sync.sh = 모든 repo 부재 (= scripts/ 직접 영역 master 전용 baseline 정합)

### 추가 발견 (cycle scope 외 · 별 cycle 후보 영역)

- propagate.sh L232-247 측 hardcoded `EXPECTED_BASELINE` 영역 = 보호 4종 sha 명시 (= 5종 vs 4종 mismatch 영역 · δ 와 유사한 사고). cycle prompt 측 scope 명시 = `scripts/verify-sync.sh` PROTECTED 영역만 · propagate.sh 영역 = scope 외 (= 별 cycle 후보 영역).
- propagate.sh + verify-sync.sh 측 sha 영역 baseline (4 → 5 확장) = 추후 일관성 검사 영역 후보 영역 (= LOW 잔존 사고 영역 가능).

## Key Findings

### 사전 baseline 실측 결과

| 항목 | 실측값 | baseline expectation |
|---|---|---|
| 4-repo HEAD | `f6f1bdc/af21cd5/04afab8/6518d01` | prompt BASELINE 정합 100% ✓ |
| scripts/verify-sync.sh master sha | `5db17df23b9b156c…` | prompt baseline MATCH ✓ |
| .claude/rules/cycle-discipline.md sha (4-repo) | `9c5021e50834abb0…` | byte-identical MATCH ✓ |
| .claude/rules/safety-and-secrets.md sha (4-repo) | `7e9e35b41ad65946…` | byte-identical MATCH ✓ |
| 보호 5종 sha | `f1edd397/ee377dc2/e5e3fe16/7621013e/96de2f5d` | baseline MATCH ✓ |
| scripts/verify-sync.sh 자식 측 | **부재** × 3 | master 전용 영역 (= cycle scope 영향) |

### propagation 영역 영향 (scripts/verify-sync.sh 자식 측 부재)

cycle prompt 측 STEP 5 명시 = `propagate.sh scripts/verify-sync.sh ...` 명시 path 영역. propagate.sh 측 `--all` 모드 X · 명시 path 영역 cp 의무 영역. propagate.sh L155-302 측 명시 path cp 영역 = 자식 path 측 mkdir + cp 영역 (= 자식 측 부재 영역 cp 가능 영역 정합).

→ STEP 5 진입 시 propagate.sh 측 scripts/verify-sync.sh 자식 측 cp 영역 검증 의무 (= propagate 측 ok 영역 검증). 만약 propagate.sh 측 scripts/ 영역 cp 거부 시 = 별 처리 영역 (= 명시 cp + add 의무).

### Cleanup Assessment

ops-layer task (cli infra scripts + rules cross-ref) · 제품 코드 무접촉.

본 cycle scope = PROTECTED 5번째 라인 추가 + 양방향 cross-ref 1-2 줄 추가 만. legacy-cleanup-governance.md §code-level cleanup 영역 외 (cli infra cleanup 영역).

코드 측 cleanup assessment: N/A (ops-layer task — 제품 코드 미변경)
