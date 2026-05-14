# PLAN — MASTER-NIGHTLY-BASELINE-CRON-002

## GATESv2

| Field | Value |
|---|---|
| TaskId | MASTER-NIGHTLY-BASELINE-CRON-002 |
| Mode | ops-layer mini 정정 (1 파일 1 영역 · §4 정합) |
| Workflow | collect → plan → implement → verify → review |
| Requirements Source | 본 chat prompt + 직전 cycle 산출물 (`d904a4e`) |

## 1. ChangeBudget

| 항목 | 값 |
|---|---|
| FilesN | 1 정정 (`scripts/nightly-baseline-report.sh`) + 6 신설 (보고서 5 + 2026-05-14.md 갱신본) |
| Modules | scripts/ + .ai/reports/ + .ai/nightly-baseline/ |
| Risk | Low (mini 정정 · 보호 파일 무접촉 · 자식 repo read-only · 잡 본체 logic 무변경) |
| DBMig | No |
| MoneyAuth | No |

## 8. VerificationPlan

| 항목 | 값 |
|---|---|
| VerifyCmds | `grep -n 'mktemp\|/tmp\|TMPDIR\|PROMPT_FILE' scripts/nightly-baseline-report.sh` (위반 0 의무 · 정책 인용 주석 영역 제외) + `bash -n scripts/nightly-baseline-report.sh` (syntax PASS) + `bash scripts/nightly-baseline-report.sh` (잡 1 회 강제 실행 exit 0 + 출력 file 생성) + 보호 파일 5종 × 5-repo sha 변동 0 (READ-ONLY) + `bash scripts/verify-sync.sh --no-update --skip-daemon-check` 회귀 0 |

## Plan

1. **Edit 1** (L195-199 영역): `PROMPT_FILE="$(mktemp -t ...)"` 라인 제거 + trap 영역 (`rm -f "$PROMPT_FILE" "$OUT_FILE.tmp"` → `rm -f "$OUT_FILE.tmp"`) + heredoc 시작 line (`cat > "$PROMPT_FILE" <<PROMPT` → `PROMPT_BODY=$(cat <<PROMPT`) + 정책 인용 주석 3 줄 추가.
2. **Edit 2** (L290 영역): heredoc terminator `PROMPT` 다음에 closing `)` 1 줄 추가.
3. **Edit 3** (L308 영역): `< "$PROMPT_FILE"` → `<<< "$PROMPT_BODY"` here-string pipe.
4. **검증**:
   - `grep` 위반 0 (정책 인용 주석 영역만 잔존)
   - `bash -n` syntax PASS
   - self-test 재실행 (`bash scripts/nightly-baseline-report.sh`) exit 0 + 출력 file 생성 + claude_exit=0
   - 보호 파일 5종 × 5-repo sha 변동 0 (buffer 영역 = `.ai/reports/MASTER-NIGHTLY-BASELINE-CRON-002/.pre-*` = repo 안 = §4 정합)
   - 자식 4 repo git status POST = PRE
   - verify-sync 회귀 0
5. **buffer file 정리** (`.pre-baseline-sha.txt` + `.post-baseline-sha.txt` rm = 본 cycle 산출물 영역 외 박음 회피).
6. **보고서 5 file** (EVIDENCE / PLAN / VERIFY / REVIEW / TODO) + **commit 1 건** (script 정정 + 보고서 + 2026-05-14.md 갱신본 묶음 · §5 v2 자동 허용 카테고리 = chore/infra).

## 9. RollbackStrategy

- 롤백 지점: 직전 commit `d904a4e` (sha 명시)
- 롤백 조건: self-test FAIL · grep 위반 잔존 · READ-ONLY 변동 발생 · verify-sync 회귀
- 복구 경로: `git revert <cycle-commit>` (단일 commit 영역 · script 정정 영역만 revert · 잡 본체 logic 영향 0)

## 10. ExternalPrep / DeferredItems

- 외부 의존: Coin 손 작업 1 줄 = `bash scripts/install-nightly-baseline-report.sh` (= 본 cycle 정정 마감 후 install)
- Deferred: 직전 cycle 의 TODO 영역 그대로 (= 6/15 이후 Agent SDK 실 비용 측정 + claude binary path drift 진단 + app-foundation gradlew drift 2 정정)

## Notes

- 본 cycle 의 mitigation 본질 = §4 위반 정정 + agent self-verification 회로 개선 단서 (= 보고서 영역 안 미래 cycle 안 grep audit patterns 의무 박힘).
- here-string `<<<` 의 macOS bash 3.x 호환성 = bash 2.05b+ 영역 지원 (= 본 영역 안전).
- heredoc 변수 `PROMPT_BODY` 안 interpolation 영역 (`$HEAD_BLOCK`, `$PROTECTED_BLOCK` 등) = unquoted PROMPT terminator 로 interpolation 발화 의무 (= 기존 patterns 그대로 보존).
