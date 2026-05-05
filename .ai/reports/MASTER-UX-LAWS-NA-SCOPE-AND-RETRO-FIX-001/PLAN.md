# PLAN — MASTER-UX-LAWS-NA-SCOPE-AND-RETRO-FIX-001

**일자**: 2026-05-05 KST
**부모 cycle**: MULTI-REPO-UIUX-AUDIT-AGAINST-UX-LAWS-001 Phase 1 (마감 2026-05-05 · 후속 보강)
**결정 주체**: Coin (a) default 결정 (2026-05-05)

## 1. cycle 본심

부모 audit Phase 1 의 두 발견:
1. ux-laws.md §5.1 N/A 영역 부재 → 7 영역 정식화 의무.
2. 누락 3 cycle (GD-AUTH-ANON-IMPL / GD-CHART-LIB / GT-AUTH-PIVOT) REVIEW.md §B [UX Laws] + §B Dark Patterns 회피 검증 부재 → §5.1 신설 sha 인용 retro-add 의무.

## 2. scope (multi-repo)

| 영역 | 강제 등급 | 작업 |
|---|---|---|
| master `.claude/rules/ux-laws.md` | cli infra (권장 byte-identical) | §5.1 신설 (line 266~283) |
| GB/GD/GT `.claude/rules/ux-laws.md` | cli infra (권장 byte-identical) | byte-identical propagation |
| GD `.ai/reports/GD-AUTH-ANON-IMPL-001/REVIEW.md` | repo-specific | §B retro-add 1 줄 (Auth-only) |
| GD `.ai/reports/GD-CHART-LIB-DEPENDENCY-DECISION-001/REVIEW.md` | repo-specific | §B retro-add 1 줄 (Dependency-decision) |
| GT `.ai/reports/GT-AUTH-PIVOT-001/REVIEW.md` | repo-specific | §B retro-add 1 줄 (Auth-only) |
| master `.auto-memory/decision-log.md` | repo-specific | 본 cycle entry append |
| master `.auto-memory/protected-file-hashes.md` | repo-specific | Recent updates 1 줄 add |
| Coin `MEMORY.md` | host-side | description 1 줄 갱신 |
| master `.ai/reports/MASTER-UX-LAWS-NA-SCOPE-AND-RETRO-FIX-001/` | repo-specific | EVIDENCE / PLAN / REVIEW 신설 |

## 3. STEP

### STEP 0. baseline 추출 (Cowork)
- 보호 5 + cli infra 6 종 4-repo byte-identical 검증 (drift = STOP)
- ux-laws.md §5 / §6 영역 line 확인 (신설 위치 결정)
- 누락 3 REVIEW.md 위치 + §B section 유무 확인
- 4-repo HEAD baseline + working tree 더러움 확인

### STEP 1. §5.1 wording 결정 (Coin)
- 옵션 (a) default · (b) 우선순위 1 줄 보강 · (c) UI 부분 등장 case 1 줄 보강
- 본 cycle 결정 = (a) default

### STEP 2. master §5.1 신설 + commit (Cowork plumbing 우회)
- ux-laws.md line 264~265 사이 §5.1 본문 (18 line) 삽입
- write-tree → commit-tree → update-ref 우회 (sandbox lock 차단 mitigation)
- master commit `3c48df5`

### STEP 3. 4-repo propagation + 검증 (Cowork)
- cp master → GB/GD/GT
- 자식 add + plumbing commit (GB 성공 → `a8d985e`)
- 4-repo sha 일괄 검증 (`0f63f399...` byte-identical)

### STEP 4. 누락 3 REVIEW.md §B retro-add (Cowork)
- 각 REVIEW.md 끝부분 + §B 2 section + master `3c48df5` 인용
- GD 2 file + GT 1 file 변경 (working tree)

### STEP 5. GD/GT commit (Coin macOS 의뢰)
- GD/GT lock 잔재로 plumbing 우회 fatal → Coin macOS `git add` + `git commit` 1 set
- GD `dd4d6f0` + GT `25d2358`

### STEP 6. memory + 보고서 갱신 (Cowork)
- multi_repo_uiux_audit_phase1.md 본문 갱신 (lazy 마감 + ux-laws.md sha 갱신)
- MEMORY.md 인덱스 description 1 줄 갱신
- master `.auto-memory/decision-log.md` + `protected-file-hashes.md` entry append (별 cycle 의 미커밋 변경에 추가 누적 — 별 commit 분리 의무)
- `.ai/reports/MASTER-UX-LAWS-NA-SCOPE-AND-RETRO-FIX-001/` EVIDENCE + PLAN + REVIEW 신설

### STEP 7. self-verification (Cowork)
- 금지 어휘 grep 0 회 검증
- 모름 / 추측 명시 (실측 안 한 영역)
- 부분 성공 명시 (4-repo HEAD 마감 / 보고서 + memory commit 별 cycle 분리)

## 4. STOP 조건

1. 보호 파일 5 종 sha 변동 시도 = STOP (본 cycle 변동 0 ✓)
2. ux-laws.md §5.1 외 다른 section 갱신 시도 = STOP (변동 0 ✓)
3. 4-repo propagation 실패 = mitigation cycle 신설 (불필요 ✓)
4. 누락 3 cycle 외 cycle 의 REVIEW.md 갱신 시도 = STOP (변동 0 ✓)
5. §5.1 wording default 외 의도 명시 영역 = Coin 결정 (단계 STEP 1 마감 ✓)

## 5. 산출물 위치

- master commit: `claude-cli-master` HEAD `3c48df5`
- 자식 commit: GB `a8d985e` / GD `dd4d6f0` / GT `25d2358`
- 보고서: `claude-cli-master/.ai/reports/MASTER-UX-LAWS-NA-SCOPE-AND-RETRO-FIX-001/` (EVIDENCE + PLAN + REVIEW)

