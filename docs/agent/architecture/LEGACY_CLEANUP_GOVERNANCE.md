# Legacy Cleanup Governance — Architecture Companion

> **목적**: `.claude/rules/legacy-cleanup-governance.md` 의 architecture-level 보충.
> **요약**: code-level task 마다 cleanup assessment 는 기본 절차다. 자동 삭제는 금지. EVIDENCE.md `## Cleanup Assessment` 섹션 누락 시 stop-gate 차단.

---

## 1. 적용 범위

| 대상 | cleanup assessment 의무 |
|---|---|
| code-level 구현/수정 task | **항상 적용** |
| 조사형 task (survey) | 적용 안 함 (선택) |
| 문서형 task (DocSync, Drift Audit) | 적용 안 함 (선택) |
| ops-layer task (CLAUDE.md, rules, hooks, skills, scripts/agent) | 적용 안 함 — `N/A (ops-layer task)` 명시 |

---

## 2. 핵심 원칙

1. **assessment 는 항상 — 삭제는 자동 아님**: 모든 code-level task 는 cleanup 후보를 점검하지만, shell/script 가 제품 코드를 자동 수정·삭제하지 않는다.
2. **code removal vs file deletion 구분**:
   - line/block/function 제거 (Edit tool): 근거 충분 시 허용
   - whole-file deletion (`rm` 명령): 기존 deny 목록으로 차단
   - whole-file 제거 (Edit to empty): PLAN 명시 + reviewer 판정 필요
   - package-level deletion: 별도 task 분리
3. **cleanup STOP vs task-level STOP**:
   - 기본: 근거 부족 → 제거 보류, 구현 계속, TODO.md `deferred`
   - 승격: auth/payment/DB/manifest/DI/public API/observability 경로 후보가 현재 변경 정합성에 직접 영향 → task-level STOP

---

## 3. 제거 허용 근거 (모두 충족)

1. 참조 검색 결과 0 또는 실질 미사용 근거 (`rg -n` 결과 기록)
2. 변경 경로 인접 (현재 task 변경 경로와 직접 인접)
3. 대체 경로 존재 (해당 시)
4. public/shared/commonMain API 노출 아님
5. 특수 참조 없음 (reflection / serialization / DI / manifest / generated code / resource linkage)
6. 빌드·테스트 통과 (exit code 0)
7. UI/UX 변경 시: 시각·동작 회귀 없음
8. 근거 기록 (path:line, search 결과, exit code, diffhunk)

---

## 4. 제거 우선 대상 (feature UI/UX leaf)

빠르게 누적되는 후보:
- 미사용 Composable / View / UiState field / UiEvent / Preview / sample / debug branch
- 교체 완료된 구 버전 mapper / ui model / adapter
- 연결이 끊어진 style/token mapping
- 죽은 navigation branch
- 사용 중지된 feature flag 분기
- out-of-scope 처리된 UI 정책의 레거시 참조

---

## 5. 제거 금지 또는 task-level STOP 대상

자동 제거 금지 — 감지 시 STOP 또는 TODO:
- 결제/빌링, 인증, 개인정보, DB migration 관련
- manifest / resource linkage / navigation root wiring
- reflection / serialization / DI 등록 / annotation processor / generated code
- analytics / logging / observability 연결
- public API / shared/commonMain 경계 / design system 공용 토큰·컴포넌트
- 외부 설정값과 연결된 분기
- 접근성 관련 코드 (정책 불명확 시)
- 서버 연동 / 권한 / entitlement 진실 경로
- 비가역 또는 범위 확장 유발

---

## 6. EVIDENCE.md 기록 규약

```markdown
## Cleanup Assessment

### 발견된 후보

| 위치 | 설명 | 판정 |
|---|---|---|
| app/src/.../UnusedComposable.kt:42 | 미사용 Composable | 제거 예정 |
| app/src/.../OldMapper.kt:1-30 | 교체된 구 mapper | TODO(deferred) |
| feature/billing/.../EntitlementCheck.kt:88 | 미사용 entitlement 분기 | task-level STOP |

### 점검 명령
`rg -n "UnusedComposable" --include="*.kt" .` — 0 matches

### 판정 요약
- 즉시 제거: 1건
- deferred: 1건
- task-level STOP: 1건
```

ops-layer task 인 경우:
```markdown
## Cleanup Assessment

N/A (ops-layer task — 제품 코드 미변경)
```

---

## 7. 강제 메커니즘

| 도구 | 종류 | 동작 |
|---|---|---|
| `post-policy-watch.sh` | PostToolUse, warn-only | 정책 파일 변경 경고 + 제품 코드 Edit/Write 시 cleanup reminder |
| `stop-gate.sh` | Stop, blocking | EVIDENCE.md `## Cleanup Assessment` 섹션 누락 시 차단 |

shell hook 이 제품 코드를 직접 자동수정/자동삭제하는 구조는 금지.

---

## 8. 관련 문서

- `.claude/rules/legacy-cleanup-governance.md` — 정식 운영 규칙
- `.claude/rules/workflow.md` — Cleanup Assessment 의무 항목
- `.claude/rules/safety-and-secrets.md` — `rm` deny + 비가역 변경 STOP
- `SSOT_PRINCIPLES.md` — 단일 출처 표시 규칙
