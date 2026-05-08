# NEW-REPO-BASELINE-GT-CLAUDE-MD-RCA-001 — Propagation Report

> **본 cycle = repo-specific 정정 (GT-only)** · master ↔ 자식 byte-identical propagation 의무 없음 (CLAUDE.md §2 정합 강제 표 §3 등급 = repo-specific 자유 영역).

## 1. Coin 명시 옵션 결정

옵션 C 채택 (Coin Turn 3 명시): GT CLAUDE.md = GD/GB 자식 Nested pattern (master 4 항목 reading order 인용) + GT 도메인 1 섹션 추가.

옵션 A (도메인 only) / 옵션 B (master cp + 별 docs) 거부 사유는 IMPL 의 자식 Nested pattern 일관성 + 30 초 UX 도메인 인식 동시 만족 필요.

## 2. Sha 비교 (3 자식)

| 자식 | 마감 전 sha | 마감 후 sha | 변경 |
|---|---|---|---|
| GentlyTable | `8f2123ac...` (master SoT cp) | `0bc5cec0...` | **변경 (정정 완료)** |
| GentlyDay | `e64117d3...` | `e64117d3...` | 불변 |
| GentlyBreath | `e260bd26...` | `e260bd26...` | 불변 |

3 sha 상이는 정합 강제 §2 표 (CLAUDE.md 본문 도메인 섹션 = repo-specific 자유) 정합. byte-identical 의무 없음.

## 3. Line 수 비교

| 자식 | line 수 | 비고 |
|---|---|---|
| GT | 323 | 자식 Nested + GT 도메인 1 섹션 |
| GD | 245 | 자식 Nested 만 (도메인 섹션 미추가) |
| GB | (미확인 · 본 cycle 무관) | 자식 Nested baseline |

GT 가 GD 대비 +78 line = GT 도메인 헌법 1 섹션 (9 subsection) 추가분. 정합.

## 4. 검증 결과 요약 (VERIFY.md 인용)

- `head -1 GT/CLAUDE.md` = `# Claude Code 운영 헌법 (CLAUDE.md)` (자식 Nested title)
- `grep -c "Gently Master" GT/CLAUDE.md` = 0 (master cp title 잔존 없음)
- `grep -E "식단|30 ?초|티켓|컨디션|처방" GT/CLAUDE.md` = 16 hit (GT 도메인 인식)
- `wc -l GT/CLAUDE.md` = 323 (목표 310 ± 30 범위)
- 3 sha 비교 PASS (3 sha 상이 = 정상)

## 5. Propagation 행위 분류

- **master → GT**: 없음 (본 cycle 은 GT-only 정정 · master cli infra 변경 없음).
- **master → GD/GB**: 없음 (GD/GB 본문 불변).
- **GT → master**: incident-log entry 1 줄 + master 측 산출물 5 파일 (PLAN/VERIFY/REVIEW + 본 REPORT + incident entry).

## 6. 재발 방지

- 동족 사고 5 회 누적 (COWORK-PREP-BASELINE-MISMATCH-001~004 + 본 cycle) → `.auto-memory/incident-log.md` 영구 기록.
- 별 trail open: GentlyClean seed `GentlyTable/00-CLAUDE-헌법.md` 자체 정정 cycle (lazy · 자연 trigger = 다음 자식 repo 신설 시).
- 별 trail open: GD/GB 도메인 헌법 1 섹션 추가 cycle (lazy · 자연 trigger = GD/GB 본 작업 진입 시).

## 7. master cycle 진행 이력 갱신 후보

| cycle ID | 마감일 | 변경 요약 | 영향 자식 repo |
|---|---|---|---|
| NEW-REPO-BASELINE-GT-CLAUDE-MD-RCA-001 | 2026-05-09 | GT CLAUDE.md 재작성 (자식 Nested pattern + GT 도메인 1 섹션) · master cli infra 변경 없음 · 동족 사고 5 회 누적 영구 기록 | GT only |

> CLAUDE.md §15 표 갱신은 master cli infra 변경 cycle 만 반영 의무 (본 cycle 은 repo-specific 정정 · 미반영 가능).
