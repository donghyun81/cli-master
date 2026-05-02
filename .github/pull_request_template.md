<!--
이 PR 템플릿은 multi-repo propagation 대상이며 byte-identical 로 복사된다.
repo 고유 정보 (링크, 이슈 트래커 등) 는 여기에 적지 않는다.
-->

## Summary

<!-- 변경의 의도와 결과를 1~3줄로 요약한다. 사용자에게 보이는 영향이 있으면 먼저 명시한다. -->

## Change Type

<!-- 해당 항목 체크 -->

- [ ] feat (새 기능)
- [ ] fix (버그 수정)
- [ ] refactor (동작 변화 없음)
- [ ] perf (성능 개선)
- [ ] docs (문서)
- [ ] build (빌드 스크립트/의존성)
- [ ] ci (CI/릴리즈 파이프라인)
- [ ] test (테스트)
- [ ] chore (기타)
- [ ] ops (운영 레이어 — `.claude/`, `scripts/agent/`, `.ai/`, `docs/agent/`)

> Commit 메시지 규칙: `docs/agent/process/COMMIT_CONVENTION.md`

## Scope

<!-- 건드린 모듈/디렉터리 요약. 광범위 변경이면 PR 분할 여부를 먼저 검토한다. -->

- Modules:
- Risk: Low / Medium / High
- DBMig: Yes / No
- MoneyAuth: Yes / No

## Related Task / Issue

<!-- `.ai/tasks/<taskId>.md` 또는 외부 이슈 링크 -->

- TaskId:
- Linked:

## Verification

<!-- 실제 실행한 검증 명령과 결과를 기록한다. "실행 안 함" 은 허용되지 않는다. -->

| 명령 | Exit Code | 결과 |
|---|---|---|
|  |  |  |

- [ ] `compound-lint` (해당 시) PASS
- [ ] 단위/통합 테스트 관련 범위 통과
- [ ] 수동 smoke (UI 변경 시 화면 확인)
- [ ] UNKNOWN 또는 BLOCKED 항목 명시

## Screenshots / Recordings

<!-- UI/UX 변경 시 before/after. 없으면 "N/A" 명시. -->

## Rollback Plan

<!-- 롤백 지점·조건·복구 경로. 문서 전용 변경이면 "git revert <commit>" 명시 가능. -->

- Rollback point:
- Trigger condition:
- Recovery path:

## Checklist

- [ ] 최소 변경 원칙 준수 (요청 범위를 넘지 않음)
- [ ] 새 의존성이 있으면 `DependencyDecision` 8개 항목 기술 (`docs/agent/architecture/DEPENDENCY_DECISION_CHECKLIST.md`)
- [ ] 시크릿/PII 를 코드·로그·PR 본문에 기록하지 않음
- [ ] 문서-구현 드리프트 없음 (DocSync 완료 또는 불필요)
- [ ] 비가역 변경 (파일 삭제·스키마 변경·auth/money path) 여부 확인 및 사용자 승인
- [ ] 본 PR 은 단일 관심사만 다룬다 (여러 주제면 분할)

## Notes

<!-- 리뷰어가 먼저 알아야 할 주의사항, 알려진 한계, 후속 작업 링크 -->
