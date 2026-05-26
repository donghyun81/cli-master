---
name: run-master
description: Recipe for /run and /verify in the claude-cli-master repo. This repo is the CLI infra master (no app, no productFlavor) — "running" means executing the cli infra self-tests, not launching an app. Run bash scripts/verify-sync.sh and bash scripts/test-protected-file-hooks.sh.
allowed-tools: Bash, Read
---

# run-master — claude-cli-master self-test recipe

> master = cli infra source-of-truth repo. 앱 build/launch 대상 아님 (gradle app module X · productFlavor X). `/run` + `/verify` 의 "실 앱 구동" 자리 = cli infra self-test 실행.
> 신설: MASTER-CLI-NATIVE-RUN-VERIFY-SANDBOX-INTEGRATION-001 (2026-05-27). master only · propagation 안 함 (L1-3 polyrepo 정합 · 자식별 차별화).

## 무엇을 실행하나

| # | command | PASS 조건 |
|---|---|---|
| 1 | `bash scripts/verify-sync.sh` | exit 0 · 5-repo cli infra sha 정합 (drift 0 / miss 0) |
| 2 | `bash scripts/test-protected-file-hooks.sh` | 5 fixture PASS (보호 5 file hook self-test) |

`verify-sync.sh` 가 launchd daemon 점검에서 멈추면 `bash scripts/verify-sync.sh --skip-daemon-check` 로 우회 가능.

## 환경

- cwd = `/Users/yundonghyeon/AndroidStudioProjects/claude-cli-master`
- 외부 prep 불필요 (네트워크 / DB / emulator 무관)
- macOS bash 3.x 호환 스크립트

## STOP

- `verify-sync.sh` 가 보호 5 file sha drift 보고 → 즉시 STOP (master `CLAUDE.md` §5 STOP #5)
- 자식 repo 로의 propagation 은 본 recipe 범위 밖 (별도 `scripts/propagate.sh` cycle)
