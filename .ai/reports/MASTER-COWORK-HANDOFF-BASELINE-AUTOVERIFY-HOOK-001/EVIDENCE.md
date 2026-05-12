## Requirements Source

- 사용자 통합 prompt Task 2 영역 ("[TASK: MASTER-COWORK-HANDOFF-BASELINE-AUTOVERIFY-HOOK-001 · 이전 turn 의 단일 통합 prompt Task 2 영역 그대로 진입]")
- scope: cli-master + Gently 3 = 4-repo (byte-identical propagation)
- 의도: Cowork ↔ CLI baseline mismatch 5회차+ 누적 (COWORK-PREP-BASELINE-MISMATCH-001~007 ledger) 자동화 mitigation
- 의무 elements 5 종:
  1. SessionStart hook 신설 — 7-repo HEAD + cycle-discipline.md sha + 보호 파일 5 종 sha + settings.json sha 캡처
  2. 출력 `.ai/baseline-snapshot/<timestamp>.json`
  3. cross-check logic (placement decision required)
  4. settings.json hook 등록
  5. Gently 4-repo byte-identical propagation
- 산출물 4 종: `.ai/reports/MASTER-COWORK-HANDOFF-BASELINE-AUTOVERIFY-HOOK-001/{PLAN,EVIDENCE,VERIFY,REVIEW}.md`
- paste-back: HEAD + commit shas + 새 shas + 산출물 shas + PASS/FAIL

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | 운영 레이어 변경 (cli infra · SessionStart hook 신설 + settings.json 등록 + 4-repo propagation) |
| Reading Mode | CLI 운영 레이어형 |
| Requirement Source | 사용자 통합 prompt Task 2 영역 (충족 · 5 elements 명시) |
| Info Gap | RESOLVABLE_IN_REPO (사용자 prompt baseline anchor 측 mismatch 가 mitigation 의 대상 자체 · 실측 baseline 으로 진행) |
| STOP Risk | None (Low Risk · 보호 파일 5 종 sha 변동 0 · 비차단 hook · exit 0 default) |
| Read-Only Fan-Out | N/A (ops-layer · 도메인 영역 X) |
| Implementer Entry | Allowed (pre-EVIDENCE 계약 본 EVIDENCE.md 안 고정) |

## Pre-EVIDENCE Contract

- **Read evidence**:
  - `cycle-discipline.md` §14a (Cowork prep ↔ CLI baseline 동기화 6 의무 절차) — 본 hook 의 자동화 대상
  - `.auto-memory/incident-log.md` — COWORK-PREP-BASELINE-MISMATCH-001~007 ledger 누적 영역
  - `.claude/settings.json` line 92-102 — SessionStart 배열 등록 위치
  - 7-repo 실측 baseline (disk truth):
    - HEAD: cli-master `2f6755eb` · GB `7a8eb78e` · GD `5154bbd2` · GT `284a06b9` · PB `9805361c` · PD `f266338c` · PT `3d96668f`
    - cycle-discipline.md sha (7-repo 동일): `732017a7cdd589d496140156c019ab9b79439d4bb37a300e1d1c548d8948258d`
    - settings.json sha (Gently 4-repo 동일 · pre-cycle): `f8bace35dbfa74086074e80726b3bef9bca8af0000247854f532521afc2aea5a`
    - settings.json sha (Proto 3-repo 동일): `60e79766...` (본 cycle scope 외)
- **Remaining gaps**:
  - 사용자 prompt 의 baseline anchor (cycle-discipline `0e4a7d01...` · settings `73d95a33...`) = pre-PROTO cycle stale anchor (cycle-discipline.md = CLI-VERSION-UNPIN-PROPAGATION-001 단계 sha · 직전 PROTO-CLI-VERSION-UNPIN-PROPAGATION-001 + MASTER-DEGENERATION-PREVENTION-POLICY-001 이후 갱신 영역). 실측 baseline 으로 진행 명시 ("Before recommending from memory" 정합 · §14a 6 절차 정합)
- **Chosen path**:
  - hook 측 cross-check logic = passive snapshot + inline drift detection (cli-master cycle-discipline sha vs Gently 3 child) 채택. 차단 X · stderr warn-only · 비교 JSON 은 intake-router 또는 사용자 측 §14a 6 절차 의무 검증 시점에 직접 query.
  - 7-repo capture scope (drift 감지 영역 = 7-repo 전체) · propagation scope = 4-repo (Gently + master) · Proto 3 무접촉.
- **Hold / Stop reasons**: None
- **Implement entry conditions**: 위 4 항목 모두 명시됨 → implementer 진입 가능

## Collect Results

### 매칭 파일 / 패턴

- `.claude/hooks/baseline-snapshot.sh` — 본 cycle 신설 (이 EVIDENCE 작성 시점 기준 디스크 존재 · 7-repo capture + drift detection inline · macOS bash 3.x 호환 · 비차단 default)
- `.claude/settings.json` — line 92-104 SessionStart 배열 (본 cycle 안 hook 추가 등록)
- `.ai/baseline-snapshot/latest.json` — hook self-test 산출물 (6823 byte · 7-repo 모두 sha `732017a7...` 일치 · drift 0)
- `.auto-memory/incident-log.md` — COWORK-PREP-BASELINE-MISMATCH-001~007 ledger 누적 영역 (본 cycle 마감 entry append 의무)
- `cycle-discipline.md` §14a — Cowork prep ↔ CLI baseline 동기화 6 의무 절차 (본 hook 의 자동화 대상)

### 0 Matches (부재 증거)

- `.ai/baseline-snapshot/` 디렉터리 = 본 cycle 신설 이전 부재 (hook 자동 mkdir 채택)
- 7-repo cycle-discipline sha drift = 0 (모두 `732017a7...` 동일 · drift logic 비활성 출력 = expected)
- 보호 파일 5 종 sha 변동 = 0 (본 cycle scope 외)

## Key Findings

1. 7-repo baseline 실측 확인: cli-master + Gently 3 + Proto 3 모두 cycle-discipline sha `732017a7...` byte-identical (직전 PROTO-CLI-VERSION-UNPIN-PROPAGATION-001 마감 영역 보존).
2. 사용자 prompt 의 baseline anchor 측 stale 영역 확인: cycle-discipline `0e4a7d01...` (CLI-VERSION-UNPIN-PROPAGATION-001 단계) · settings `73d95a33...` (재초기 영역). 디스크 실측 truth = mitigation 의 대상 patterns 자체.
3. hook self-test PASS: JSON 6823 byte · python3 parse valid · 7-repo capture 모두 명시 · drift 0.
4. settings.json 등록 patterns 검증: 기존 `session-start.sh` 와 묶음 배치 (SessionStart 배열 안 단일 group 의 hooks list 측 append).

## Cleanup Assessment

N/A (ops-layer task — 제품 코드 미변경)
