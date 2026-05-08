## GATESv2

| Field | Value |
|---|---|
| TaskId | NEW-REPO-BASELINE-GT-CLAUDE-MD-RCA-001 |
| Mode | repo-specific 정정 (자식 측 CLAUDE.md 본문 도메인 섹션 = 정합 강제 X · §2 표 인용) |
| Workflow | RCA(직전 turn) → Plan → Implement → Verify → Review |
| Requirements Source | Coin cowork chat (옵션 C 명시 채택) |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 1 (GentlyTable/CLAUDE.md 재작성) + 5 산출물 (PLAN/VERIFY/REVIEW/REPORT/incident-log entry) |
| Modules | repo-specific (자식 측 헌법 본문) |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |

## 2. DependencyDecision

N/A — `libs.versions.toml` 변경 없음.

## 3. ArchitectureImpact

N/A — 운영 헌법 본문 재작성. 새 인터페이스 / 추상화 없음. shared/domain 경계 영향 없음.

## 4. ModelBoundaryPlan

N/A — 코드 변경 없음.

## 5. ErrorPolicy

N/A — 코드 변경 없음.

## 6. UIStateFlowPlan

N/A — UI 변경 없음.

## 7. TestabilitySeams

N/A — 테스트 변경 없음.

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | (1) `shasum -a 256 GentlyTable/CLAUDE.md GentlyDay/CLAUDE.md GentlyBreath/CLAUDE.md` (2) `wc -l GentlyTable/CLAUDE.md` (3) `head -1 GentlyTable/CLAUDE.md` (4) `grep -c "Gently Master" GentlyTable/CLAUDE.md` = 0 (5) `grep -E "식단\|30 ?초\|티켓\|컨디션\|처방" GentlyTable/CLAUDE.md` ≥ 1 hit |

## 9. RollbackStrategy

- 롤백 가능 지점: master + GT 각 commit hash (본 cycle 산출물). `git revert <commit>` 으로 즉시 복구.
- 롤백 조건: 새 GT CLAUDE.md 가 Cowork chat project_instructions 와 충돌하거나 GD/GB 패턴과 비호환 발견 시.
- 복구 경로: revert 후 NEW-REPO-BASELINE-GT-CLAUDE-MD-RCA-002 신설 + 옵션 A/B 재선택.

## 10. ExternalPrep / DeferredItems

- GD/GB 측 도메인 섹션 추가 (호흡 / 일상) = 별 sub-cycle 후보 (lazy · 본 cycle 범위 외).
- GentlyClean seed `00-CLAUDE-헌법.md` 자체 정정 = 별 cycle (lazy · seed source 영역 정정 정책 결정 의무).

## Plan

1. master 측 `.ai/reports/NEW-REPO-BASELINE-GT-CLAUDE-MD-RCA-001/PLAN.md` 작성 (본 파일).
2. GT CLAUDE.md 재작성:
   - GD CLAUDE.md template 따름 (`# Claude Code 운영 헌법` + 용어 사전 + 자식 Nested 인용 + master reading order 4 항목 + 절대 금지 + STOP + 워크플로 + 진입 커맨드 + Repo-First Intake + Context Hygiene + 구현·설계 기본값 + 아키텍처 공통 SoT + 오케스트레이션 + 모델 비종속 + 산출물 규약 + UNKNOWN + 제품 컨텍스트 + UI/UX 규칙 하이라이트).
   - propagation: repo-only 블록 = `GentlyTable` / 패키지 = `com.example.gentlytable` / Task ID 예 = `GT-UI-001` / `GT-CLI-001` / `GT-DATA-001`.
   - GT 도메인 헌법 1 섹션 추가 (제품 컨텍스트 직후): 슬로건 + 핵심 가치 + 30 초 UX 루프 + 타겟 + 도메인 모듈 + 5 Phase 단계 + 외부 의존 + 절대 원칙 + reading 의무 + 사고 패턴.
3. VERIFY 5 명령 실행 + `.ai/reports/.../VERIFY.md` 작성.
4. REVIEW 12-section 작성 (Risk Low = §1 §2 §11 §13 의무).
5. `propagation-reports/NEW-REPO-BASELINE-GT-CLAUDE-MD-RCA-001/REPORT.md` 작성 (sha 비교 + line 비교 + 옵션 C 결정 인용).
6. `.auto-memory/incident-log.md` 영구 기록 (사고 source = GentlyClean seed 결함 + 본 cycle 정정 + 동족 사고 5 회 누적).
7. master 측 commit (subject = `fix(repo-specific): NEW-REPO-BASELINE-GT-CLAUDE-MD-RCA-001 GT CLAUDE.md 자식 Nested pattern + 도메인 섹션 정정` + body 6 섹션).
8. GT 측 commit (동일 subject + body 6 섹션).

## Notes

- CLAUDE.md §2 정합 강제 표 인용: `<repo>/CLAUDE.md` 본문 도메인 섹션 = repo-specific 자유 영역. master propagation 대상 아님.
- 본 cycle = GT-only 정정. GD/GB 자식 헌법 변경 없음.
- 동족 사고: COWORK-PREP-BASELINE-MISMATCH 4 회 + 본 사고 = 5 회 누적. 본 cycle 마감 시 incident-log 에 5 회 누적 패턴 영구 기록.
