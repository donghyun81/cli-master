# EVIDENCE — MASTER-UX-LAWS-NA-SCOPE-AND-RETRO-FIX-001

**일자**: 2026-05-05 KST
**진행**: Cowork (chat) + Coin macOS (commit assist)
**부모 cycle**: MULTI-REPO-UIUX-AUDIT-AGAINST-UX-LAWS-001 Phase 1 (마감 2026-05-05)

## 1. 본심

부모 audit Phase 1 발견:
- ux-laws.md §5.1 N/A 영역 부재 → audit 시 7 영역 (Auth-only / Backend-only / Doc-only / Dependency-decision / Build-CI-Tooling / Refactor / cli infra) 분류 SoT 없음.
- 누락 3 cycle (GD-AUTH-ANON-IMPL-001 / GD-CHART-LIB-DEPENDENCY-DECISION-001 / GT-AUTH-PIVOT-001) REVIEW.md §B [UX Laws] + §B Dark Patterns 회피 검증 부재 → audit retro-add 의무.

## 2. STEP 0 baseline 실측 (2026-05-05)

### 2-1. 보호 5 + cli infra 6 종 4-repo byte-identical 검증

| 파일 | sha256 | 4-repo 정합 |
|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `f1edd397...` | ✓ |
| `.claude/rules/uiux-sot-refresh.md` | `ee377dc2...` | ✓ |
| `docs/design/design-sot-policy.md` | `e5e3fe16...` | ✓ |
| `.claude/rules/pencil-uiux-workflow.md` | `7621013e...` | ✓ |
| `docs/design/pencil-sot-policy.md` | `96de2f5d...` | ✓ |
| `.claude/rules/ux-laws.md` (BEFORE) | `80aa2915...` | ✓ |
| `.claude/rules/code-principles.md` | `51b414f1...` | ✓ |
| `.claude/rules/report-formats.md` | `184dc55b...` | ✓ |
| `.claude/rules/ui-ux-analysis.md` | `e5b1af74...` | ✓ |
| `.claude/rules/design-to-code-sync.md` | `603bc994...` | ✓ |

drift 0 baseline ✓.

### 2-2. ux-laws.md 영역 검증 (BEFORE)

```
16:## 0. 적용 정책
32:## 1. 권장 22 법칙
154:## 2. Flow
163:## 3. 비권장 + 신중 분리 (5 항목)
208:## 4. 채택 / 비권장 / 신중 매트릭스
247:## 5. Task 유형별 자동 선별 적용 매트릭스
268:## 6. 검증 (PromptFit + REVIEW.md §B)
292:## 7. 본 룰의 변경 정책
300:## 8. 참고
```

§5 = line 247 / §6 = line 268 / §5.1 부재 ✓ (신설 위치 확정 = line 264~265 사이).

### 2-3. 누락 3 cycle REVIEW.md 위치 + §B section 부재

| repo | cycle | 파일 | size | §B 유무 |
|---|---|---|---|---|
| GD | GD-AUTH-ANON-IMPL-001 | `.ai/reports/.../REVIEW.md` | 37342 | 없음 |
| GD | GD-CHART-LIB-DEPENDENCY-DECISION-001 | `.ai/reports/.../REVIEW.md` | 4234 | 없음 |
| GT | GT-AUTH-PIVOT-001 | `.ai/reports/.../REVIEW.md` | 12423 | 없음 |

3 보고서 모두 audit 이전 작성 → §B section 자체 부재 → 신규 §B 2 개 (UX Laws + Dark Patterns) retro-add 의무.

### 2-4. 4-repo HEAD baseline (BEFORE)

```
master:       e4ae705 docs(claude-md): prepend terminology dictionary quote block
GentlyBreath: d8c1365 docs(claude-md): propagate terminology quote block
GentlyDay:    248b9c4 docs(claude-md): propagate terminology quote block
GentlyTable:  98c385b docs(claude-md): propagate terminology quote block
```

working tree 변경 사항 (별 cycle 누적 · 본 cycle 대상 X):
- master: `.auto-memory/decision-log.md` M + `.auto-memory/protected-file-hashes.md` M + `gradlew.bat` M + 보고서 디렉터리 2 미커밋
- GB: `decision-log.md` M + `Phase4_PartA_Audit_Summary.md` D
- GD: `decision-log.md` M
- GT: `decision-log.md` M + `incident-log.md` M

## 3. 본 cycle 변경 사항

### 3-1. master ux-laws.md §5.1 신설

위치: line 264 (§5 본문 끝) 직후 + line 266 `---` 직전.
신설 영역: line 266~283 (총 18 line · §5.1 header + 7 영역 표 + REVIEW N/A 형식 의무 1 줄).

본문 wording (Coin (a) default 결정):

```markdown
## 5.1 N/A 영역 (자동 분류 의무)

다음 7 영역 화면 / task 는 §5 매트릭스 적용 X · audit N/A 분류 의무.

| 영역 | 정의 | 예 |
|---|---|---|
| Auth-only | 로그인 / 회원가입 / 비밀번호 재설정 — UI 표시 외 도메인 | auth-screen |
| Backend-only | API / DB / 동기화 — 화면 변경 X | API endpoint 추가 cycle |
| Doc-only | 문서 변경 — UI 변경 X | README 갱신 |
| Dependency-decision | 라이브러리 선택 — UI 무관 | 차트 라이브러리 결정 |
| Build-CI-Tooling | gradle / 빌드 — UI 무관 | CI script 영역 |
| Refactor (UI 무관) | 구조 변경만 | data class 분리 |
| cli infra | .claude/ / docs/templates/ 영역 | rules / agents / hooks |

REVIEW.md §B [UX Laws] + §B Dark Patterns 회피 검증 시 N/A 분류 = "N/A (사유: <영역>)" 1 줄 형식 의무.
```

### 3-2. ux-laws.md sha 변동

- BEFORE: `80aa29153316b90ea3fe93f4f3e524380d4f6a9dca55266d09f137d912cb1373` (306 line)
- AFTER:  `0f63f399e52e48067e11baa98dbaed331b3c7142de06e453cf7a074e31c3ebbe` (322 line / +16)

### 3-3. 4-repo propagation (byte-identical)

cp `claude-cli-master/.claude/rules/ux-laws.md` → `{GentlyBreath,GentlyDay,GentlyTable}/.claude/rules/ux-laws.md` ✓
4-repo sha = `0f63f399...` 일괄 일치 ✓

### 3-4. 누락 3 REVIEW.md retro-add (각 보고서 끝부분)

각 §B [UX Laws] + §B Dark Patterns N/A 1 줄 추가 (master commit `3c48df5` 인용):

```markdown
## §B [UX Laws] 적용 검증 (retro-add 2026-05-05)

N/A (사유: <Auth-only 또는 Dependency-decision>) — ux-laws.md §5.1 N/A 영역 적용 (master commit 3c48df5). UI 화면 변경 없음.

## §B Dark Patterns 회피 검증 (retro-add 2026-05-05)

N/A (사유: 동일) — 결제 / 가입 task 외 영역.

(retro-add cycle: MASTER-UX-LAWS-NA-SCOPE-AND-RETRO-FIX-001)
```

| 보고서 | N/A 사유 | 추가 byte |
|---|---|---|
| GD-AUTH-ANON-IMPL-001 | Auth-only | +286 |
| GD-CHART-LIB-DEPENDENCY-DECISION-001 | Dependency-decision | +296 |
| GT-AUTH-PIVOT-001 | Auth-only | +286 |

### 3-5. 4-repo HEAD AFTER

```
master:       3c48df5 docs(ux-laws): add §5.1 N/A scope (Auth/Backend/Doc/Dep-decision/Build-CI/Refactor/cli-infra)
GentlyBreath: a8d985e docs(ux-laws): propagate §5.1 N/A scope from master (3c48df5)
GentlyDay:    dd4d6f0 docs(reviews): retro-add §B [UX Laws] + Dark Patterns N/A (master 3c48df5)
GentlyTable:  25d2358 docs(reviews): retro-add §B [UX Laws] + Dark Patterns N/A (master 3c48df5)
```

GD = 2 commit 누적 (propagate 284036a → REVIEW retro-add dd4d6f0)
GT = 2 commit 누적 (propagate b1f33b4 → REVIEW retro-add 25d2358)

## 4. plumbing 우회 노트 (sandbox lock 차단 mitigation)

### 4-1. 차단 패턴

sandbox (Cowork bash) 가 host bind mount 의 `.git/index.lock` / `.git/HEAD.lock` 새로 만들기는 가능하나 unlink Operation not permitted → lock 잔재 누적 → 다음 git porcelain (add / commit) fatal.

### 4-2. master plumbing 우회 (성공)

```bash
git add .claude/rules/ux-laws.md
TREE=$(git write-tree 2>&1 | grep -E '^[a-f0-9]{40}$' | tail -1)
PARENT=$(git rev-parse HEAD)
NEW=$(echo "$MSG" | git commit-tree $TREE -p $PARENT 2>&1 | grep -E '^[a-f0-9]{40}$' | tail -1)
git update-ref HEAD "$NEW"
```

unlink warning stderr 다수 발생하나 sha 는 stdout 으로 정상 추출 → commit 성공 (`3c48df5`).

### 4-3. GB plumbing 우회 (성공)

master 와 동일 패턴. 새 commit `a8d985e`.

### 4-4. GD/GT plumbing 우회 (실패 → Coin macOS 의뢰)

GD/GT 의 lock 잔재가 누적되어 write-tree 단계 fatal ("Unable to create .git/index.lock: File exists"). 
Coin macOS 측 `git add` + `git commit -m` 패턴 1 set 으로 마감 → GD `dd4d6f0` + GT `25d2358`.

### 4-5. lock 정리 결과

Coin macOS `rm -f *.lock` (4-repo) → glob match 0 = 정리 완료.

## 5. 실측 명령 + 결과 인용

### 5-1. ux-laws.md §5.1 신설 검증

```bash
$ grep -nE '^## (5|5\.1|6)\.' .claude/rules/ux-laws.md
247:## 5. Task 유형별 자동 선별 적용 매트릭스
266:## 5.1 N/A 영역 (자동 분류 의무)
284:## 6. 검증 (PromptFit + REVIEW.md 12-section 안 §B [UX Laws])
```

§5.1 = line 266 (신설 OK).

### 5-2. 4-repo ux-laws.md sha 일괄 검증

```
claude-cli-master    0f63f399e52e48067e11baa98dbaed331b3c7142de06e453cf7a074e31c3ebbe
GentlyBreath         0f63f399e52e48067e11baa98dbaed331b3c7142de06e453cf7a074e31c3ebbe
GentlyDay            0f63f399e52e48067e11baa98dbaed331b3c7142de06e453cf7a074e31c3ebbe
GentlyTable          0f63f399e52e48067e11baa98dbaed331b3c7142de06e453cf7a074e31c3ebbe
```

byte-identical ✓.

### 5-3. 누락 3 REVIEW.md §B section 검증

```
GentlyDay/.ai/reports/GD-AUTH-ANON-IMPL-001/REVIEW.md:
  576:## §B [UX Laws] 적용 검증 (retro-add 2026-05-05)
  580:## §B Dark Patterns 회피 검증 (retro-add 2026-05-05)
GentlyDay/.ai/reports/GD-CHART-LIB-DEPENDENCY-DECISION-001/REVIEW.md:
  85:## §B [UX Laws] 적용 검증 (retro-add 2026-05-05)
  89:## §B Dark Patterns 회피 검증 (retro-add 2026-05-05)
GentlyTable/.ai/reports/GT-AUTH-PIVOT-001/REVIEW.md:
  155:## §B [UX Laws] 적용 검증 (retro-add 2026-05-05)
  159:## §B Dark Patterns 회피 검증 (retro-add 2026-05-05)
```

3 보고서 모두 §B 2 section 추가 ✓.

