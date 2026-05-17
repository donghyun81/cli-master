# Cowork project_instructions §20 정정안 — 영구 baseline (2026-05-17)

> 본 file = `BLOG-RECOMMENDATION-A-B-TRAIL-HANDOFF-001` cowork chat #5 mitigation cycle (= cowork prep baseline anchor 자동 추적 mechanism + handoff active 자동 갱신 절차 표준) 측 §20 정정안 영구 baseline.
> 본 정정안 = cowork-side project_instructions 영역 = cowork UI 측 사용자 본인 직접 paste 의무 (= cli 측 변경 능력 X).
> 본 file = master repo 측 영구 baseline 정착 + 사용자 본인 후속 cowork UI 측 paste 단계 retrieve source default.

## 기존 §20 (4 항)

```
## §20. 진입 시 추출할 핵심 정보

매 chat 시작 시 다음 4 항목 추출 + 보고:
1. 부모 패키지 정의
    * 본 작업 (디자인 → SoT → 검증 → 구현 → 배포 등) 5 단계 또는 N 단계
    * repo N 개 명단 + 각 repo 의 도메인
2. 보호 파일 list (강제 byte-identical)
    * 추출 위치: .auto-memory/protected-file-hashes.md 또는 .claude/rules/<workflow 또는 sot-policy>.md 본문
    * 현 sha (3-repo 정합 검증)
3. cli infra list (권장 byte-identical)
    * 추출 위치: .claude/rules/workflow.md (Cycle Discipline 섹션)
    * 현 sha + drift 여부
4. 진행 중 cycle 상태
    * 추출 위치: .ai/reports/ 의 최근 task ID 디렉터리
    * 미완 STEP / TODO 항목
```

## 신 §20 (5 항 · 5 항 신설 · = 2026-05-17 baseline_ingest_stale 40 회차 누적 mitigation cycle)

```
## §20. 진입 시 추출할 핵심 정보

매 chat 시작 시 다음 5 항목 추출 + 보고:
1. 부모 패키지 정의
    * 본 작업 (디자인 → SoT → 검증 → 구현 → 배포 등) 5 단계 또는 N 단계
    * repo N 개 명단 + 각 repo 의 도메인
2. 보호 파일 list (강제 byte-identical)
    * 추출 위치: .auto-memory/protected-file-hashes.md 또는 .claude/rules/<workflow 또는 sot-policy>.md 본문
    * 현 sha (3-repo 정합 검증)
3. cli infra list (권장 byte-identical)
    * 추출 위치: .claude/rules/workflow.md (Cycle Discipline 섹션)
    * 현 sha + drift 여부
4. 진행 중 cycle 상태
    * 추출 위치: .ai/reports/ 의 최근 task ID 디렉터리
    * 미완 STEP / TODO 항목
5. baseline anchor 자동 추적 + handoff active 자동 갱신 (= 2026-05-17 신설 · baseline_ingest_stale 40 회차 누적 mitigation)
    * 매 chat 진입 첫 turn 의무 = 5-repo HEAD + 보호 N + cli infra + 진행 cycle 신설 file 일괄 disk 측정 mandatory (= `git rev-parse HEAD` + `git hash-object` direct)
    * §0 진입 anchor (= 직전 chat 마감 시점 흡수) vs 본 chat 진입 실측 사이 drift 발견 시 = 사고 단정 X · `git log <anchor>..HEAD --oneline` 측정으로 commit 추적 + 사용자 본심 확인 의뢰 default (= memory baseline_ingest_stale paradigm "scope 외 commit 발견 시 사고 단정 X · 사용자 병렬 의뢰 가능성 우선 확인 의무" 정합)
    * 사용자 본심 = "별 cli session 자율 마감 정상" → handoff active §A 자동 갱신 (= 새 HEAD sha + commit subject 인용 + sub-section append) + memory baseline_ingest_stale_pattern.md 회피 마감 entry append (= 1 줄 인용 default)
    * 사용자 본심 = "예상 외 drift" → RCA cycle 진입 default (= baseline anchor 갱신 X)
    * handoff active 갱신 절차 표준 = (a) 진입 시 §A 5-repo HEAD 갱신 + 새 chat sub-section 신설 (b) cycle 마감 시 마감 sha + finding append (c) chat 마감 시 다음 chat 진입 baseline 명시 (= `handoff_architecture_v2_paradigm.md` 정합)
    * 본 절차 정착 trigger = baseline_ingest_stale 5 회차 연속 누적 mitigation cycle 의무 (= H17 + 본 chat #40 누적 도달)
```

## 사용자 본인 후속 단계 (= cli 측 진행 X · 사용자 본인 잔존)

1. 본 file 본문 측 신 §20 (5 항) 영역 copy
2. cowork UI 측 project_instructions 편집 진입 (= AndroidStudioProjects 프로젝트 측 instructions 편집 영역)
3. 기존 §20 (4 항) 영역 측 신 §20 (5 항) 영역 paste replace
4. 저장 + 차회 cowork chat 진입 시 §5 항 자동 적용 검증

본 후속 단계 = cowork-side instruction 변경 영역 (= cli 측 변경 능력 0). cowork UI 측 사용자 본인 직접 진행 default.
