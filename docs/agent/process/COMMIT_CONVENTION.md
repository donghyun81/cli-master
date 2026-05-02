# Commit Convention — Conventional Commits

> 이 문서는 multi-repo propagation 대상이며 byte-identical 로 복사된다.
> SOT: `docs/agent/process/COMMIT_CONVENTION.md`
> 관련: `.claude/rules/safety-and-secrets.md` (git commit/push 금지 정책), `.github/pull_request_template.md`

---

## 1. 목적

커밋 메시지는 변경의 **의도**와 **영향 범위**를 일관된 형식으로 전달한다.
사람과 도구(자동 changelog, release notes, bisect) 모두가 파싱할 수 있는
Conventional Commits 표준을 사용한다.

공식 스펙: https://www.conventionalcommits.org/en/v1.0.0/

---

## 2. Claude 와 사람의 역할 경계 (중요)

- **Claude Code 는 git commit / git push / git reset / git clean 을 실행하지 않는다**
  (`.claude/settings.json` deny list 로 차단됨)
- 이 문서는 **사용자가 수동으로 커밋을 만들 때 참고하는 가이드**다
- Claude 가 PR 을 대신 생성할 때는 사용자가 최종 문구를 검토·승인한다

---

## 3. 기본 형식

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 3.1 Header (1줄, 72자 이하)

| 컴포넌트 | 설명 |
|---|---|
| `type` | 아래 §4 type 표의 값 중 하나 (소문자) |
| `scope` | 선택. 변경이 집중된 모듈/영역 (소문자, kebab 또는 camelCase) |
| `subject` | 명령형 현재 시제. 끝에 마침표 없음. 첫 글자 소문자 또는 대문자 일관성 유지 |

### 3.2 Body (선택, 공백 한 줄 뒤)

- 변경의 **why** 와 **what** 을 설명한다 (**how** 는 diff 가 담당)
- 72자 줄바꿈 권장
- bullet 목록 허용

### 3.3 Footer (선택, 공백 한 줄 뒤)

- `BREAKING CHANGE: <설명>` — 하위 호환 파괴 시 필수
- `Refs: <taskId>` — 관련 task 링크
- `Co-authored-by: <name> <email>` — 다중 저자 (주의: PII 기록 정책과 충돌 없는 공개 commit 용 메타만)

---

## 4. type 허용 목록

| type | 언제 사용 |
|---|---|
| `feat` | 사용자에게 보이는 **새 기능** |
| `fix` | **버그 수정** (회귀 포함) |
| `docs` | 문서만 변경 (README, 가이드, 주석) |
| `style` | 포매팅/공백/세미콜론 등 동작 변화 없는 스타일 |
| `refactor` | 동작 변화 없는 구조 개선 (feat/fix 아님) |
| `perf` | 성능 개선 |
| `test` | 테스트 추가 또는 보정 |
| `build` | 빌드 시스템/외부 의존성 변경 (gradle, npm 등) |
| `ci` | CI 파이프라인, GitHub Actions, 릴리즈 자동화 |
| `chore` | 그 외 기타 (유지보수성, 자동 업그레이드) |
| `revert` | 이전 커밋 되돌림 (`revert: <reverted subject>` 형식) |
| `ops` | 운영 레이어 변경 — `.claude/`, `scripts/agent/`, `.ai/`, `docs/agent/` (repo ops 자산) |

> `ops` 는 Conventional Commits 표준 외 추가 확장이며 multi-repo 운영 자산 변경 식별용이다.

---

## 5. scope 예시

scope 는 repo 별로 달라지며 각 repo 는 자기 구조에 맞게 사용한다.
공통적으로 사용 가능한 app-neutral scope:

| scope | 의미 |
|---|---|
| `core` | 최상위 공용 모듈 |
| `shared` | KMP shared 계층 |
| `app` | 플랫폼 앱 shell |
| `data` | 데이터 레이어 |
| `domain` | 도메인 레이어 |
| `ui` | UI/UX 계층 |
| `infra` | 빌드/CI/스크립트 |
| `ops` | 운영 레이어 (claude rules, agents, hooks) |
| `deps` | 의존성 업데이트 |
| `release` | 릴리즈 준비 |

scope 가 불명확하면 생략한다 (`feat: ...`).

---

## 6. 예시

### 6.1 간단한 기능 추가
```
feat(ui): add empty-state view to list screen
```

### 6.2 버그 수정 + 원인 설명
```
fix(data): guard null payload before JSON decode

외부 서버 응답이 간헐적으로 payload 필드를 omit 한다.
client 가 즉시 crash 하던 경로를 typed Result 로 감싸고
caller 가 표시 전략을 선택하도록 한다.

Refs: <taskId>
```

### 6.3 BREAKING CHANGE
```
refactor(domain)!: replace callback API with suspend functions

기존 listener 기반 API 는 KMP common 으로 옮기기 어렵다.
suspend 기반으로 치환하며 caller 의 lifecycle 결합을
명시적으로 관리하도록 요구한다.

BREAKING CHANGE: Repository.observe(listener) 가 제거됐다.
caller 는 suspend fun fetch() 또는 Flow<...> 를 사용한다.
```

### 6.4 운영 레이어 변경
```
ops: add ADR template and commit convention

app-neutral ops assets 로 multi-repo propagation 대상.
```

### 6.5 문서 전용
```
docs: clarify DependencyDecision 8-item checklist usage
```

---

## 7. 금지 사항

- 한 커밋에 여러 관심사를 섞는다 (분할한다)
- `WIP`, `fix typo` 만 적은 공백 메시지 — PR 전에 squash
- 시크릿/토큰/PII 값을 body 또는 footer 에 기록
- 72자를 넘는 헤더
- 마침표로 끝나는 헤더 subject
- `--no-verify`, `--no-gpg-sign` 등 훅 우회 (사용자 명시 승인 없이)

---

## 8. PR 과의 관계

- PR 제목은 첫 커밋의 헤더를 재사용하거나 같은 형식으로 작성한다
- PR 본문은 `.github/pull_request_template.md` 를 따른다
- squash merge 시 최종 커밋 메시지가 PR 제목/본문과 일치해야 한다

---

## 9. 체크리스트 (사용자 수동 검토용)

커밋을 만들기 전 확인:

- [ ] type 이 §4 표의 값 중 하나인가
- [ ] header 가 72자 이하이며 명령형 현재 시제인가
- [ ] 관심사가 하나인가 (분할 필요 없는가)
- [ ] body 가 why 를 설명하는가
- [ ] BREAKING CHANGE 가 있으면 footer 또는 `!` 로 명시했는가
- [ ] 시크릿/PII 가 포함되지 않았는가
- [ ] 관련 task id 가 footer 에 들어갔는가 (선택)

---

## 10. 관련 문서

- `.github/pull_request_template.md` — PR 작성 템플릿
- `docs/agent/architecture/DEPENDENCY_DECISION_CHECKLIST.md` — 의존성 추가 시 커밋 body 에 8항목 요약 권장
- `.claude/rules/safety-and-secrets.md` — git 자동 실행 금지 정책
- `.claude/rules/workflow.md` — 최소 변경 원칙
