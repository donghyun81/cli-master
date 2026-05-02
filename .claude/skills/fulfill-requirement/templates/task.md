# Task Template — .ai/tasks/<taskId>.md

> 이 파일은 신규 태스크 생성 시 사용하는 템플릿이다.
> intake-router 또는 사용자가 직접 복사해 사용한다.
> 생성 후 원문 요구사항은 절대 수정하지 않는다 (불변 문서).

---

```markdown
## Meta

| 항목 | 값 |
|---|---|
| TaskId | <PREFIX>-<DOMAIN>-NNN |
| Created (KST) | YYYY-MM-DD HH:MM |
| Status | COLLECT |
| Risk | UNKNOWN |
| DBMig | UNKNOWN |
| MoneyAuth | UNKNOWN |
| Report | .ai/reports/<taskId>/ |

## 원문 요구사항

[사용자가 제시한 원문 그대로. 수정 금지.]

## 분해된 문제 진술

[requirements-analyst가 채운다]

### 성공 조건

[measurable success criteria]
- [ ]
- [ ]

### Measurable Exit Criteria

_verifier가 각 항목을 실행하여 PASS/FAIL을 판정한다. 기계 검증 가능한 형태로 작성._
_자연어 성공 조건과 1:1 대응하되, 여기에는 실행 가능한 검증 명령이나 grep 패턴을 기술한다._

- [ ] `<검증 명령 또는 grep 패턴>` — <기대 결과>
- [ ] `<검증 명령 또는 grep 패턴>` — <기대 결과>

### 비기능 요구사항

[non-functional requirements]
- 성능:
- 보안:
- 호환성:

### 범위 경계

**IN scope:**
-

**OUT of scope:**
-

### 불확실성 (UNKNOWN)

| 항목 | 확인 위치 |
|---|---|
| UNKNOWN: | |

## 도메인 태그

[intake-router가 채운다]

선택된 도메인:
- [ ] product
- [ ] domain-policy
- [ ] ui-ux
- [ ] app-architecture
- [ ] backend-api
- [ ] server
- [ ] data
- [ ] auth-security
- [ ] privacy
- [ ] billing-payments
- [ ] sync-offline
- [ ] performance-reliability
- [ ] testing
- [ ] observability
- [ ] release
- [ ] docs
```

---

## 파일 생성 규칙

1. `taskId`를 결정한다: `.ai/tasks/INDEX.md` 마지막 번호 + 1
2. 이 템플릿을 복사해 `.ai/tasks/<taskId>.md` 로 저장
3. Meta + 원문 요구사항 섹션을 채운다
4. 나머지는 각 역할이 단계별로 채운다
5. `.ai/tasks/INDEX.md` 에 Active Tasks 행을 추가한다
