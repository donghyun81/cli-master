## Requirements Source

- 원문 = `.ai/tasks/MASTER-RELEASE-CHECKLIST-TEMPLATE-001.md`
- master ledger row `MASTER-T03` = `docs/release-readiness/PACKAGE-OVERVIEW.md` line 48
- Requirement chain: master `MASTER-T03` ☐ → 본 cycle 후 ✓ + sha + 본심
- Authority boundary: master single-repo scope (자식 propagation X)

## Intake Normalization

| Field | Value |
|---|---|
| Work Type | docs / template (ops-layer · master template 신설) |
| Reading Mode | 정책-계획 점검형 |
| Requirement Source | `.ai/tasks/MASTER-RELEASE-CHECKLIST-TEMPLATE-001.md` + PACKAGE-OVERVIEW.md §3 |
| Info Gap | RESOLVABLE_IN_REPO (3 자식 LAUNCH-STATUS §7~§9 reading 완료) |
| STOP Risk | 없음 (DBMig No · MoneyAuth No · 비가역 변경 X · 범위 확장 X) |
| Read-Only Fan-Out | 본 cycle 부재 (intake 직접 적용) |
| Implementer Entry | Allowed (pre-EVIDENCE 계약 명시 완료) |

## Pre-EVIDENCE Contract

- **Read evidence**:
  - master HEAD `74d9ee5` 검증 (baseline 일치)
  - `docs/templates/` = 7 templates 보유 (release-checklist.template.md 부재 확인)
  - `docs/templates/billing.template.md` = 헤더 patterns 인용 source
  - `.ai/tasks/MASTER-GB-AUTH-ACTIVATE-001.md` = task doc patterns 인용 source
  - `.auto-memory/decision-log.md` = entry append patterns 인용 source
  - 3 자식 `LAUNCH-STATUS.md` §7~§9 reading 완료 (Reading Order Step 0-5 PASS)
- **Remaining gaps**: 없음
- **Chosen path**: Plan → Implement (release-checklist.template.md 신설 + PACKAGE-OVERVIEW edit + decision-log append) → Verify → Review → Commit
- **Hold / Stop reasons**: 없음
- **Implement entry conditions**: 본 EVIDENCE.md + PLAN.md 작성 완료 후 진입

## Collect Results

### 3 자식 LAUNCH-STATUS §7~§9 공통 추출

**공통 §7 (Play Console · 8 항목)**:
- 앱 이름 / 설명 ko + en
- 스크린샷 5~8
- Feature graphic
- IARC 등급
- 데이터 안전 폼
- 가격대 / 가용 지역
- 카테고리
- 베타 테스트 (closed track)

**도메인 별 §7 (3 자식 차이)**:
- GB: 호흡 / 명상 스크린샷 + 광고 / 정부 ID 명시
- GD: 일상 / health data 스크린샷
- GT: 사진 / 영양 / 처방 스크린샷 + IAP only (한입 티켓)

**공통 §8 (컴플라이언스 + 권한 · 5 항목)**:
- Privacy Policy + Terms of Service URL 공개
- GDPR (휴대권 + 삭제권)
- KISA 개인정보 처리방침
- POST_NOTIFICATIONS 권한 + UX flow
- 데이터 안전 폼 정합 (Play Console + iOS 동일)

**도메인 별 §8 (3 자식 차이 = placeholder `<domain-permissions>`)**:
- GB: USE_EXACT_ALARM + WAKE_LOCK + VIBRATE
- GD: Health Connect (Android) + HealthKit (iOS) + ACTIVITY_RECOGNITION
- GT: CAMERA + READ_MEDIA_IMAGES + AI 결정권 + 의료 X 책임 한계 + Supabase region 명시

**공통 §9 (성능 budget · 3 항목 + 도메인 별 latency)**:
- cold start ≤ 1500 ms (universal)
- APK 크기 도메인 별 (placeholder `<apk-budget>`)
- 메모리 peak 도메인 별 (placeholder `<memory-budget>`)
- 도메인 latency placeholder (`<domain-latency>`)

**도메인 별 §9 (3 자식 차이)**:
- GB: APK ≤ 25 MB · 메모리 ≤ 150 MB · 배터리 ≤ 0.5%
- GD: APK ≤ 30 MB · 메모리 chart ≤ 200 MB · 일지 저장 ≤ 500 ms
- GT: APK ≤ 35 MB · 사진 업로드 1MB ≤ 3초 · 영양 Edge Function ≤ 1초 · 메모리 사진+chart ≤ 250 MB

### template 헤더 patterns (`docs/templates/billing.template.md` 인용)

- 첫 줄: `# <Title> — \`<RepoName>\``
- 둘째: `> **template 출처**: master \`...\`.`
- 셋째: `> **활성 조건**: ...`
- 넷째: `> **STOP 의무**: ...`
- 섹션: `## N. <섹션명>` (1~9)
- placeholder: `<RepoName>` · `<예: ...>` (자식 cp 시 치환)

### 0 Matches (부재 증거)

- `find docs/templates -name "release-checklist*"` → 0 (신설 대상 부재 확인)
- 보호 파일 5종 sha = baseline (5b84cd9e · 3a703b30 · b27fbe16 · d3a0b573 · e580b6d7) unchanged 예상

## Key Findings

1. master `docs/templates/` 측 = 7 templates 보유 (ai-prompt-guide / api-spec / billing / data-model / pencil-dev-prompt / screen-flow / setup-guide).
2. release-checklist 영역 = master 측 명시된 placeholder template 부재 → 자식 P4 진입 시 매번 손 작성 사고 위험 (권한 / Privacy / ASO 누락).
3. 본 cycle 으로 9 섹션 template 신설 → 자식 P4 cp 표준 확보 + 도메인 placeholder (`<RepoName>` · `<domain-permissions>` · `<apk-budget>` · `<memory-budget>` · `<domain-latency>` · `<domain-kpi>` · `<domain-special-disclosure>`) 치환 의무.
4. master single-repo scope (자식 propagation X) — 자식 P4 진입 시 propagation 발화.

## Cleanup Assessment

N/A (ops-layer task — 제품 코드 미변경)
