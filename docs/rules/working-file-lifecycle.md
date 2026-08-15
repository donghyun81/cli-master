# working file lifecycle 정책 (단일 SoT)

> **흡수 영역**: 이전 MASTER-PROMPTS-LIFECYCLE-POLICY-001 의 .ai/prompts/ 영역도 본 정책에 통합. archive 위치 단일.

## 1. working file 카테고리

> ★**패턴 정본 = script 상수** (= 본 절 = 발췌 · 열거 재복제 금지): 자동 archive 대상 패턴의 단일 SoT = [`scripts/working-file-archiver.sh`](../../scripts/working-file-archiver.sh) `sweep_candidates()` 의 `for pattern in …` 목록 (= **root 9 패턴** + `.ai/prompts/*.md`). 본 절이 그 목록을 다시 세면 두 번째 열거처가 곧 drift 원이 된다 — 신규 패턴 추가는 **script 를 고치고 본 발췌는 그대로 두거나 함께 갱신**한다.

sweep 위치(= §3 5 위치) 의 repo root 에서 다음 패턴이 마감 시 자동 archive 대상 (= 2026-08-15 실측 발췌):

- `cycle-prompt-*.md` · `cc-paste-*.md` · `*_addendum*.md` / `*-addendum-*.md` · `*.bak`
- `cowork-handoff-*ENTRY*.md` · `cowork-chat-entry-*.md` · `ENTRY-PROMPT-*.md` · `cc-audit-*.md`
- 자식 repo 한정: `.ai/prompts/*.md` (이전 prompts policy 흡수 — handoff / pivot / activate / entry / verification 등 모든 working file · 부모 root `.ai/` 는 대상 밖)

**제외 (자동 archive X)**:
- `.ai/reports/` 안 내용 일체 (cycle 산출물 — 영구 자료)
- `.claude/rules/` / `.claude/hooks/` / `scripts/` (cli infra)
- 도메인 코드 / 디자인 SoT (`docs/` 안 등)
- README.md / CLAUDE.md / .gitignore (repo-specific 또는 보호)
- `cowork-handoff-architecture.md` (영구 SoT) / `cowork-handoff-active.md` (append SoT · `handoff-active-rotate.sh` 관할) — 정본 = script `is_excluded()`

## 2. frontmatter 3 키 (working file 모두 의무)

> ★**일수 SoT** (= 본 file 전역 적용 · §2 / §5 문면 공통): 아래 「7일」 = **인용값** · 정본 = [`scripts/working-file-archiver.sh`](../../scripts/working-file-archiver.sh) `MTIME_THRESHOLD_DAYS` 상수. 일수 변경 = **script 상수를 고치고 본 문면 + `reporting.md §1` 인용을 함께 갱신**한다 (= 문면만 고치면 무효).

```yaml
---
정리위치: archive/
정리trigger: 대응 task  REVIEW.md PASS 또는 mtime 7일 경과
정리주체: cowork 자율 (또는 사용자 직접)
---
```

frontmatter 부재 시: mtime 7일 경과 fallback 적용 (warn-only, 자동 archive).

## 3. archive 위치 (5 위치 단일 SoT)

> ★**4-active 정합** (= 2026-08-15 `MASTER-LIFECYCLE-4ACTIVE-REALIGN-001` 정정): 구 판은 **동결 3 (GentlyBreath / GentlyDay / GentlyTable)** 을 열거해 2026-07-17 `MASTER-T6-REPO-REALIGN-001` 재편을 반영하지 못했다 (= 동결 3 = 전파 대상 X · 쓰기 0 · master `CLAUDE.md §1.3`). 위치 정본 = launchd plist [`scripts/com.coin.working-file-archiver.plist`](../../scripts/com.coin.working-file-archiver.plist) 의 `for r in …` 5 경로 · 아래 목록 = 그 실물과 문자열 정합.

5 위치 모두 동일 구조 운영 (= 부모 root + 4-active):
- `~/AndroidStudioProjects/archive/` (부모 root · git 밖)
- `~/AndroidStudioProjects/claude-cli-master/archive/` (master)
- `~/AndroidStudioProjects/app-foundation/archive/` (FND)
- `~/AndroidStudioProjects/gently-product-docs/archive/` (PDOCS)
- `~/AndroidStudioProjects/Selfward/archive/` (SW)

각 위치 안 구조:
````
archive/
├── INDEX.md           # 5-column 메타
├── 2026-05/           # YYYY-MM 별 디렉터리
│   ├── <file>.md
│   └── ...
└── 2026-06/
    └── ...
````

**§17 단일 repo 폴더 이동 시 끊김 없음 보장** — 그 repo 의 archive 자체 운영 + restore.sh 자체 호출.

## 4. INDEX.md 5-column 형식

```markdown
# Archive INDEX

| 시각 KST | 파일 | 출처 폴더 | 마감 cycle | trigger 종류 |
|---|---|---|---|---|
| 2026-05-04 17:47 | cycle-prompt-XXX.md | (parent root) | XXX | mtime 경과 |
```

trigger 종류 = `REVIEW.md PASS` / `REPORT.md PASS` / `mtime 경과` / `수동` (= script 가 실제 매칭된 판정 file 명을 그대로 기록).

## 5. trigger mechanism

- (a) **frontmatter mtime fallback**: file 의 mtime 이 7 일 경과 + frontmatter 3 키 명시 → 자동 archive
- (b) **REVIEW.md·REPORT.md PASS 매칭**: frontmatter 의 `정리trigger` 안 명시한 task ID 의 `.ai/reports/<taskId>/` 아래 **`REVIEW.md` 또는 `REPORT.md`** 가 PASS 상태 → 자동 archive. ★**REPORT.md 인정** = 2026-08-15 `MASTER-LIFECYCLE-4ACTIVE-REALIGN-001` 신설 — master cycle 산출물은 `REPORT.md` 뿐(= master `CLAUDE.md §11`)이라 REVIEW.md 만 조회하던 구 판에서는 조기-archive 경로가 **사문화**돼 있었다. **task ID 요건 · PASS 판정 함수는 무변** (= 인정 file 집합만 `{REVIEW.md}` → `{REVIEW.md, REPORT.md}`)

위 2 trigger 중 하나 만족 = archive 대상.

## 6. mechanism

- launchd daemon `com.coin.working-file-archiver`: 매일 03:00 5 위치 모두 1 회 sweep
- session-start hook (`.claude/hooks/session-start.sh`): chat 진입 시 1 회 sweep (warn-only — 차단 X)

turn 차단 mechanism 일체 사용 X.

## 7. 복원 (restore)

`scripts/restore.sh <filename-partial>`:
1. 현 위치 archive/INDEX.md 검색
2. 매칭 list 사용자 confirm (y/n)
3. mv archive/<YYYY-MM>/<file> ./<file>

## 8. 운영 원칙

- mv only — rm 사용 금지 (복원 가능성 보장)
- macOS bash 3.x 호환 (associative array X / ${var,,} X)
- log path = .ai/hooks/working-file-*.log
