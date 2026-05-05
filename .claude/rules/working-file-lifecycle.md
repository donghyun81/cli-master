# working file lifecycle 정책 (단일 SoT)

> **흡수 영역**: 이전 MASTER-PROMPTS-LIFECYCLE-POLICY-001 의 .ai/prompts/ 영역도 본 정책에 통합. archive 위치 단일.

## 1. working file 카테고리

다음 패턴 파일은 마감 시 자동 archive 대상:
- 부모 root + 4 자식 repo: `cycle-prompt-*.md`
- 부모 root + 4 자식 repo: `cc-paste-*.md`
- 부모 root + 4 자식 repo: `*_addendum*.md` / `*-addendum-*.md`
- 부모 root + 4 자식 repo: `*.bak`
- 자식 repo: `.ai/prompts/*.md` (이전 prompts policy 흡수 — handoff / pivot / activate / entry / verification 등 모든 working file)

**제외 (자동 archive X)**:
- `.ai/reports/` 안 내용 일체 (cycle 산출물 — 영구 자료)
- `.claude/rules/` / `.claude/hooks/` / `scripts/` (cli infra)
- 도메인 코드 / 디자인 SoT (`docs/` 안 등)
- README.md / CLAUDE.md / .gitignore (repo-specific 또는 보호)

## 2. frontmatter 3 키 (working file 모두 의무)

```yaml
---
정리위치: archive/
정리trigger: 대응 task  REVIEW.md PASS 또는 mtime 7일 경과
정리주체: cowork 자율 (또는 사용자 직접)
---
```

frontmatter 부재 시: mtime 7일 경과 fallback 적용 (warn-only, 자동 archive).

## 3. archive 위치 (5 위치 단일 SoT)

5 위치 모두 동일 구조 운영:
- `~/AndroidStudioProjects/archive/` (부모 root)
- `~/AndroidStudioProjects/claude-cli-master/archive/`
- `~/AndroidStudioProjects/GentlyBreath/archive/`
- `~/AndroidStudioProjects/GentlyDay/archive/`
- `~/AndroidStudioProjects/GentlyTable/archive/`

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

trigger 종류 = `REVIEW.md PASS` / `mtime 경과` / `수동`.

## 5. trigger mechanism

- (a) **frontmatter mtime fallback**: file 의 mtime 이 7 일 경과 + frontmatter 3 키 명시 → 자동 archive
- (b) **REVIEW.md PASS 매칭**: frontmatter 의 `정리trigger` 안 명시한 task ID 의 REVIEW.md 가 PASS 상태 → 자동 archive

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
