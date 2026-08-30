# Legacy Cleanup Governance

> code-level 구현/수정 task에서 항상 실행되는 legacy/미사용 코드 점검·제거 governance.
> "항상 실행"은 cleanup 후보를 항상 점검한다는 뜻이다. shell/script가 제품 코드를 자동 삭제하는 뜻이 아니다.
> SOT: `CLAUDE.md` | 관련: `docs/rules/workflow-core.md` (단계 흐름) / `docs/rules/cycle-discipline.md` (cycle 정책), `.claude/rules/safety-and-secrets.md`
> **자매 rule**: [`stale-artifact-tracking.md`](./stale-artifact-tracking.md) — 본 rule 이 다루지 않는 **낡은 문면**(주석·SoT 문서·rule 문면이 실물과 갈림)을 전담한다. 본 rule = **코드 제거**, 자매 = **문면 drift 등재**. 아래 「적용 범위」에서 본 rule 이 제외하는 문서형·조사형·ops-layer task 가 그 자매의 영역이다 (= `MASTER-STALE-TRACKING-001` 2026-08-17 · 본 rule 본문 무변).

---

## 적용 범위

| 대상 | 적용 여부 |
|---|---|
| code-level 구현/수정 task | **항상 적용** |
| 조사형 task (survey, analysis) | 적용 안 함 (선택적) |
| 문서형 task (DocSync, Drift Audit) | 적용 안 함 (선택적) |
| ops-layer task (CLAUDE.md, rules, hooks, skills) | 적용 안 함 — EVIDENCE.md에 `N/A (ops-layer task)` 명시 |

task 유형 분류: `docs/agent/process/DOC_TASK_TYPES.md` 참조.
불명확 시 UNKNOWN으로 표기하고 cleanup assessment 섹션을 작성한다.

---

## code removal vs file deletion STOP 충돌 해소

**핵심 원칙**: "코드 제거"와 기존 "비가역 변경/파일 삭제 STOP"은 다른 규칙이다. 혼용하지 않는다.

| 변경 유형 | 허용 여부 | 기준 |
|---|---|---|
| line/block/function 제거 (Edit tool) | 허용 — 근거 충분 시 | 아래 제거 허용 근거 충족 시 |
| 파일 내용 전체 제거 후 신규 내용 (Write tool) | 허용 — 근거 충분 시 | 아래 제거 허용 근거 충족 시 |
| whole-file deletion (rm 명령) | **금지** — deny 목록 (`Bash(rm:*)`) | 기존 절대 금지 유지 |
| whole-file 제거 (git rm, Edit to empty) | **STOP 검토** — 저위험 명백 후보로 자동 분류 금지 | 별도 근거 + task-level review |
| package-level deletion | **STOP 검토** — 범위 확장 위험 | 별도 task 분리 검토 |
| wiring 제거 (DI, manifest, navigation root) | **task-level STOP** | 아래 STOP 대상 참조 |

`rm` 명령은 기존 deny 목록으로 차단된다 — 이 규칙이 별도로 다루지 않는다.
whole-file 제거가 필요하면: (1) PLAN에 명시, (2) 충분한 근거 기록, (3) reviewer 판정 필요.

---

## cleanup STOP vs task-level STOP 구분

### 기본값 (cleanup STOP)

근거 부족 시:
- **제거만 보류한다**
- 현재 구현 요구사항 작업은 **계속 수행한다**
- `TODO.md` 에 `deferred` 또는 `follow-up` 으로 남긴다

```
TODO.md 기록 형식:
## Deferred Cleanup
- [ ] [파일:라인] — 이유 (미사용 추정이나 근거 부족) — follow-up
```

### task-level STOP 승격 조건

제거 대상이 현재 변경 경로의 **정합성·안전성·요구사항 충족에 직접 영향**을 주는 경우:
- auth / payment / privacy 관련 경로
- DB migration 관련
- manifest / resource linkage
- DI 등록 / reflection / serialization / annotation processor / generated code
- navigation root wiring
- public API / shared/commonMain 경계
- 공용 design system / shared UI 기반층
- 필수 analytics / observability wiring
- live SoT상 별도 STOP 기본 정책이 걸린 경로

이 경우 cleanup 보류가 아니라 **task-level STOP**으로 승격하고 사용자에게 보고한다.

---

## 기본 제거 시점

**기본**: 구현 완료 후, verify 전 최종 cleanup pass
- 이유: 새 구현이 자리 잡은 뒤 대체 경로와 dead code 여부를 더 정확히 판정할 수 있음

**예외 허용** (구현 전 또는 구현 중 즉시 제거):
- 현재 변경 범위와 직접 인접
- 저위험 (low risk)
- 미사용이 명백한 후보

**예외 불허 대상** (저위험 명백 후보로 자동 분류 금지):
- whole-file deletion
- package-level deletion
- wiring 제거 (DI, manifest, navigation root)
- public/shared/commonMain API

---

## 제거 허용 근거 (모두 충족 필요)

1. **참조 검색 결과 0** 또는 실질 미사용 근거 (`rg -n` 검색 결과 기록)
2. **변경 경로 인접**: 현재 task 변경 경로와 직접 인접하거나 동일 feature/module 문맥
3. **대체 경로 존재** (해당 시): 대체 구현 또는 신규 경로가 존재함을 확인
4. **public/shared/commonMain API 노출 아님**: 외부 노출 여부 확인
5. **특수 참조 없음**: reflection / serialization / DI 등록 / manifest / Gradle wiring / generated code / resource linkage에서 참조되지 않음
6. **빌드·테스트 통과**: 제거 후 빌드·lint·테스트 pass (exit code 0)
7. **UI/UX 변경 시**: 시각·동작 회귀 없음 확인
8. **근거 기록**: `path:line`, search 결과, exit code, diffhunk 형태로 EVIDENCE.md 또는 VERIFY.md에 기록

---

## 제거 우선 대상 (code-level task에서 항상 점검)

feature UI/UX leaf 영역에서 빠르게 누적되는 후보:
- 미사용 Composable / View / UiState field / UiEvent / Preview / sample / debug branch
- 교체 완료된 구 버전 mapper / ui model / adapter
- 연결이 끊어진 style/token mapping
- 죽은 navigation branch
- 사용 중지된 feature flag 분기
- out-of-scope 처리된 UI 정책의 레거시 참조

---

## 제거 금지 또는 task-level STOP 대상

아래는 agent 재량 자동 제거 금지. 감지되면 STOP 또는 TODO:
- 결제/빌링, 인증, 개인정보, DB migration 관련 경로
- manifest / resource linkage / navigation root wiring
- reflection / serialization / DI 등록 / annotation processor / generated code
- analytics / logging / observability 연결
- public API / shared/commonMain 경계 / design system 공용 토큰·컴포넌트
- 외부 설정값과 연결된 분기
- 접근성 관련 코드 (현재 정책상 무엇인지 불명확한 경우)
- 서버 연동 / 권한 / entitlement 진실 경로
- 삭제가 비가역적이거나 범위 확장을 유발하는 경우
- live SoT상 별도 STOP 규칙이 있는 경로

---

## UI/UX 특화 정책

- **feature UI/UX leaf**: 제거 우선
- **공용 UI 기반층** (shared design system, platform-owned UI integration, UiState 불변 원칙): 보호
- **고대비/텍스트 크기**: out-of-scope 제거 정책 대상 — 잔존 참조는 제거 후보
- **시스템 accessibility / platform behavior와 혼합된 흔적**: 근거 부족 시 STOP/TODO

---

## EVIDENCE.md 기록 규약 (Cleanup Assessment 섹션)

code-level task의 EVIDENCE.md는 반드시 `## Cleanup Assessment` 섹션을 포함한다.

```markdown
## Cleanup Assessment

_code-level task에서 필수. 제품 코드 미변경 ops-layer task는 `N/A (ops-layer task)` 명시._

### 발견된 후보

| 위치 | 설명 | 판정 |
|---|---|---|
| file:line | 설명 | 제거 예정 / TODO(deferred) / task-level STOP |

### 점검 명령

```
rg -n "검색어" --include="*.kt" .
```

### 판정 요약
- 즉시 제거: N건
- deferred (TODO): N건
- task-level STOP: N건
```

**ops-layer task인 경우**:
```markdown
## Cleanup Assessment

N/A (ops-layer task — 제품 코드 미변경)
```

---

## VERIFY.md 기록 규약 (실제 제거가 발생한 경우)

실제 코드 제거가 발생했을 때 VERIFY.md에 반드시 포함:

```markdown
## Cleanup Verification

| 제거 항목 | 참조 검색 결과 | Exit Code |
|---|---|---|
| file:line | `rg -n "symbol"` — 0 matches | 0 |

빌드/테스트 검증: (기존 VERIFY 명령으로 확인)
```

---

## 훅 / 강제 기제

| 강제 기제 | 종류 | 동작 |
|---|---|---|
| `post-policy-watch.sh` | PostToolUse, warn-only | 정책 파일 변경 경고 + 제품 코드 Edit/Write 시 cleanup 점검 reminder 출력 |
| `stop-gate.sh` | Stop, blocking | EVIDENCE.md에 `## Cleanup Assessment` 누락 시 차단 (리뷰 전 단계) |

실제 코드 제거 판단은 규칙 + 근거 + verify/review를 통해 agent가 수행한다.
shell hook이 제품 코드를 직접 자동수정/자동삭제하는 구조는 금지다.

---

## 명시 cycle 이력

> 판정 = **실질 개정 있음** (= 2026-08-30 `MASTER-RULE-HISTORY-SECTION-001` 소급 판정 · 축 = `rule-footer-common.md` 「실질 개정 ↔ 기계 치환」 · 판정표 29 행 = 그 판 REPORT). 소급 범위 = **판정 근거 한정**(= 무한 소급 금지 · 전 계보 열거 아님) · **기계 치환 commit 미등재**(= 축 자기 적용).

- 2026-05-02 · `C1-MASTER-BOOTSTRAP-001` · 본 rule 신설 (= 201 행 · `ff65723`).
- 2026-08-30 · `MASTER-RULE-HISTORY-SECTION-001` · **본 절 신설** (= 위 판정의 착지 · `rule-footer-common.md:10` 등재 의무 소급 이행 · 본문 절 무접촉).
