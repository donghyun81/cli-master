# MASTER-WORKING-FILE-LIFECYCLE-001 — PLAN

## 본 의도
working file 자동 archive + 복원 인프라 도입. 단일 SoT (이전 MASTER-PROMPTS-LIFECYCLE-POLICY-001 흡수). 5 위치 운영.

## scope
- 부모 root + 4 자식 repo
- 6 종 신규/수정 파일 + 자식 3 repo .gitignore append

## 분류
ops-layer task — 제품 코드 미변경.

## 사용자 본심 3 항목 정합
1. 자동 제거 — launchd 03:00 + session-start hook
2. 다시 꺼내기 — restore.sh + INDEX.md
3. 각 repo 자체 archive — 5 위치 단일 SoT
