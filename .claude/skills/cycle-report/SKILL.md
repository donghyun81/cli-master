---
name: cycle-report
description: Use in the master repo only to run the propagation cycle (propagate + verify-sync + report-gen). STOP if invoked from a child repo. Generates propagation-reports/<cycle-id>-PROPAGATE/ and updates .auto-memory/propagation-status.md.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
disable-model-invocation: true
---

# /cycle-report — propagation cycle 자동 진입

> master 안에서만 사용. 자식 repo 안에서 호출 시 STOP.

## 사용

```
/cycle-report propagate <relative-path> [<path> ...]   # 단일/다수 파일 propagation cycle
/cycle-report propagate --all                          # 전체 cli infra propagation
/cycle-report status                                   # 현 propagation-status.md 출력
/cycle-report drift                                    # drift 만 표시
/cycle-report verify                                   # verify-sync.sh 만 실행 (보고서 X)
```

## 자동 흐름 (propagate sub-command)

1. **BASELINE 검증** — master 의 `.git status` clean 확인 + `.auto-memory/protected-file-hashes.md` 와 실 sha 일치 확인
2. **변경 식별** — git log 의 직전 commit 대비 변경 파일 list
3. **propagate** — `bash scripts/propagate.sh <files> --targets all`
4. **verify-sync** — `bash scripts/verify-sync.sh`
5. **report-gen** — `bash scripts/report-gen.sh <cycle-id>-PROPAGATE` (cycle-id 는 master commit body 의 task ID)
6. **자식 repo commit 안내** — Coin 에 자식 repo 별 commit 명령 1줄 출력 (master commit body 인용)
7. **Coin 검증 1줄 의무** — "각 자식 repo 의 commit 후 다시 호출: `/cycle-report verify`"

## 자동 산출물

- `propagation-reports/<cycle-id>-PROPAGATE/REPORT.md`
- `propagation-reports/<cycle-id>-PROPAGATE/DIFF.md`
- `propagation-reports/<cycle-id>-PROPAGATE/VERIFY.md`
- `.auto-memory/propagation-status.md` 갱신 (verify-sync.sh 자동)

## 제약

- master 안에서만 작동 (자식 repo 에서 호출 시 STOP)
- 보호 파일 sha 변경 cycle 시 추가 의무 발화 (commit body `[Sha]` 새 sha 명시 확인)
- propagation 중 자식 repo 가 dirty 이면 STOP + Coin 결정 의무
