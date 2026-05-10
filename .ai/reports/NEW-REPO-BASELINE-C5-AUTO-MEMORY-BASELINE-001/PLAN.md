## GATESv2

| Field | Value |
|---|---|
| TaskId | NEW-REPO-BASELINE-C5-AUTO-MEMORY-BASELINE-001 |
| Mode | ops-layer / cycle / lightweight (cycle-discipline §11) |
| Workflow | Plan → Implement → Verify → Review |
| Requirements Source | C5 cycle 재정의 (gradlew.bat false-positive STOP 후 영역 단일화) |
| Risk | Low |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 9 (3 자식 × 3 파일 신설) |
| Modules | child `.auto-memory/` baseline 만 |
| Risk | Low |
| DBMig | No |
| MoneyAuth | No |
| 보호 파일 변동 | 0 (5종 byte-identical 유지) |

## 2. Cycle 영역 재정의

**원래 C5 정의** (`...AND-GRADLEW-BAT-FIX-001`):
1. Area 1 — child `.auto-memory/` baseline 신설
2. Area 2 — gradlew.bat drift 정정

**재정의 (현 task ID)**:
- Area 1 만 유지
- **Area 2 폐기** — gradlew.bat 의 "drift" 는 git core.autocrlf=input 환경의 정상 EOL 정규화 (WT CRLF 디스크 sha vs HEAD blob LF git internal sha 차이). false-positive STOP 으로 분류. 별 mitigation cycle 불필요.

## 3. Plan (6 step)

1. 9 파일 self-authored 생성 (master cp 금지 · cycle-discipline §3 정합)
   - 3 × `protected-file-hashes.md` — 5 보호 파일 sha baseline + cli infra 6 sha 명시
   - 3 × `incident-log.md` — 본 cycle 의 false-positive STOP 사고 박힘 + GB SteadyWell drift 잔존 명시 (해당 시)
   - 3 × `decision-log.md` — C0 / C1+C2 / C3+C4 / C5 = 4 cycle 결정 박힘
2. 자식 repo 별 단일 commit: `chore: .auto-memory/ baseline (cycle 0~5)` (6 섹션 commit body)
3. 사후 검증: `bash $MASTER/scripts/verify-sync.sh --quick` exit 0
4. 5 보호 파일 4-way (master + 3 자식) sha byte-identical 재확인
5. working tree clean 확인 (3 자식)
6. 3 보고서 lightweight 작성 (PLAN/VERIFY/REVIEW)

## 4. STOP 조건

- 보호 파일 5종 sha 변동 (`scripts/verify-sync.sh --quick` PASS 24 미달)
- 자식 repo 의 `.auto-memory/` 외 영역 변경 감지
- master cli infra 변경 감지
- commit subject / body 6-section drift

## 5. VerificationPlan

| 명령 | 기대 |
|---|---|
| `bash $MASTER/scripts/verify-sync.sh --quick` | exit 0 / PASS 24 / DRIFT 0 / MISS 0 |
| `git -C <repo> log --oneline -3` (3 자식) | C5 commit + skeleton commit 노출 |
| `git -C <repo> status --short` (3 자식) | 빈 출력 (working tree clean) |
| `shasum -a 256 <보호 5 × 4 repo>` | 4-way byte-identical |

## 6. RollbackStrategy

`git revert <C5-commit>` 로 즉시 복구 가능 (3 자식 각각). master 변경 X · propagation 무관.

## 7. Refs

- 본 cycle = child-side baseline cycle (master cli infra 미변경 · `cycle-discipline.md` §15 패턴 1/2 어디에도 해당 안 함 · self-authored)
- Cowork prep ↔ CLI baseline 동기화 (`§14a`) 정합 — 4 cycle (C0/C1+C2/C3+C4/C5) 명시됨
