# [DEPRECATED] workflow.md — C2-RULES-RESTRUCTURE-001 분할

> 본 파일은 **2026-05-02 · C2-RULES-RESTRUCTURE-001** 에서 3 분할되었다.
> sandbox rm 권한 한계로 본 파일은 pointer-only 로 변환 (rm 은 Coin 손 작업).

## 새 위치

| 기존 섹션 | 새 파일 |
|---|---|
| §단계 흐름 / Context Reset / Intake / /collect / /plan / implement / /verify / /review / COMPOUND / 완료 조건 | `workflow-core.md` |
| §Cycle Discipline §1~11 + §13 + §14 + §14a | `cycle-discipline.md` |
| §12 Pencil .pen 저장 자동화 | `pencil-automation.md` |

## Coin 손 작업 1줄 (master rm)

```bash
cd ~/AndroidStudioProjects/claude-cli-master && rm .claude/rules/workflow.md && git add -A
```

## 인용 정정 의무

- `routing-and-delegation.md` 등의 `workflow.md` 참조 → 위 표 매핑 사용해서 새 파일 인용으로 갱신 (C2-4 단계).
- `CLAUDE.md` 의 `workflow.md` 참조도 동일 갱신.
