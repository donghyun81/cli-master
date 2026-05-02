# Cycle Handoff Template — 자식 repo 의 진행 cycle 상태 추적

> **본 파일은 template**. master 가 SoT 로 보유 + 자식 repo 가 cp 받아서 채워 사용.
> 자식 repo 의 위치: `<repo>/.auto-memory/cycle-handoff.md` (각 repo 독립).
> 본 파일은 cycle 진척 추적용 (cross-repo 정합 대상 X · 각 repo 의 본 작업 cycle 진행 기록).

## 형식

```yaml
---
taskId: <REPO>-<DOMAIN>-NNN
status: COLLECT | PLAN | IMPLEMENT | VERIFY | REVIEW | DONE | STOP | BLOCKED
lastVerifiedStep: COLLECT | PLAN | IMPLEMENT | VERIFY | REVIEW
remainingSteps: <count>
blockers: [<keyword 또는 빈 배열>]
nextEntry: <agent-name 또는 user-action>
riskFlags:
  MoneyAuth: false
  DBMig: false
  scopeExpansion: false
  pencilModalIntercept: false
createdKST: "YYYY-MM-DD HH:MM"
updatedKST: "YYYY-MM-DD HH:MM"
---

## Current Status
<1~3 줄 — 지금 어디까지 됐고 다음 행동이 무엇인지>

## Last Verified State
<verifier 가 PASS 했던 마지막 단계 + exit code + 검증 명령 1~2줄>

## Remaining Work
- [ ] <남은 STEP 1>
- [ ] <남은 STEP 2>
- [ ] <남은 STEP 3>

## Next Entry Conditions
<재진입 시 첫 행동 + 필요 reading order>

## Known Risks
<현재 인식된 위험 1~3줄 + mitigation 후보>
```

## 사용 패턴

1. 자식 repo 의 task 진입 시 신설: `cp .auto-memory/cycle-handoff-template.md .ai/reports/<taskId>/HANDOFF.md`
2. 매 STEP 마감마다 `updatedKST` 갱신 + `lastVerifiedStep` 업데이트
3. cycle 완전 마감 (REVIEW PASS) 시 `status: DONE` + 본 파일 삭제 또는 archive

## 갱신 의무

- `status` 변경 시 즉시 갱신
- `blockers` 발견 시 즉시 갱신
- 매 verifier PASS 후 `lastVerifiedStep` 갱신
- chat reset / cowork 진입 시 본 파일이 첫 reading 대상

## propagation 정책

- 본 template 자체는 master ↔ 자식 byte-identical 권장 (cli infra 권장 등급)
- 자식 repo 의 `.ai/reports/<taskId>/HANDOFF.md` 는 task 별로 자유 채움 (정합 강제 X)
