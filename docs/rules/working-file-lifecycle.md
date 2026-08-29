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
- `~/AndroidStudioProjects/toward-product-docs/archive/` (PDOCS)
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

## 9. 변경·수정·폐기의 유지보수 (= 만드는 규약은 있고 없애는 규약이 없었다)

> **신설**: `MASTER-ENGINEERING-BASELINE-001` (2026-08-29). §1~§8 = **만드는·옮기는·되살리는** 규약(= archive / restore)이고, **퇴역시키는 쪽**의 규약이 비어 있었다. 본 §은 file 뿐 아니라 **불변식 · 회부 · 코드 · 판 · 이름** 의 폐기를 다룬다 (= working file 의 archive 절차는 §1~§7 그대로).

- **ⓐ 불변식을 퇴역시킬 때 대체 자를 *같은 판에서* 세운다.** 게이트에서 어떤 수를 「불변」으로 지키다가 그 불변식이 더는 옳지 않게 되면, **그 판 안에서** 대체 자를 세우고 게이트 문면을 **「불변」이 아니라 「퇴역 확인」**으로 바꾼다. 자를 그냥 빼면 **다음 판은 그 축이 있었다는 사실 자체를 모른다.**
- **ⓑ 회부를 실물 없이 마감할 때는 「해소」가 아니라 「실물 없이 섰다」로 적는다.** 원장 항목이 「더 볼 필요 없음」으로 닫히는 것과 「고쳐서 닫힘」은 **다른 사건**이다. 둘을 같은 칸에 적으면 다음 사람이 **고쳐진 줄 안다.** 구 문면은 **존치**하고 판정만 덧붙인다(= 소급 정정 금지 · additive-ledger).
- **ⓒ 죽은 코드를 지우기 전에 「다른 소비처가 없는지」 census 를 돌린다.** 자 = **경계형**(심볼 정의 + 호출 + 문자열 참조를 분리) · **주석 제외** · ★**전수 트리**(= [`code-principles.md`](./code-principles.md) §2 「부재는 전수 트리에서만」 · subset 위의 「안 쓰인다」는 무효). 소비처 census 없는 삭제 = **비가역**(= STOP #3).
- **ⓓ 판 취소 = 「근거 census + 원장 정정 + 축 재판정」까지가 한 판이다.** 취소만 하고 끝내면 **같은 판이 다음 회차에 다시 열린다**(취소 근거가 어디에도 안 남으므로). 취소 사유(= 병이 실물에 없었다 / 이미 착지했다 / 경계가 틀렸다)를 원장에 적고, 그 판이 담당하던 **목표 축을 누가 가져가는지**를 재판정한다 (= [`cycle-discipline.md`](./cycle-discipline.md) §32-ⓒ).
- **ⓔ 이름이 둘인 한 기계는 「본문 중복 census」 로 잡는다.** 같은 규칙·같은 절차가 두 이름으로 살아 있으면 **한쪽만 고쳐지고 다른 쪽이 조용히 낡는다.** 자 = 이름 grep 이 아니라 **본문 문자열 중복** 측정(이름이 다르므로 이름으로는 안 잡힌다). 발견 시 = 한쪽을 **본문 SoT**, 다른 쪽을 **thin pointer** 로 눕힌다(삭제 0).
- **ⓕ 발주서 실물 ↔ 원장 문면을 정기 대조한다.** 원장이 「집행 대기」로 든 발주서가 **실물로 있는지** 주기적으로 확인한다 — 발견 지점 = [`stale-artifact-tracking.md`](./stale-artifact-tracking.md) §3 「발주·회부 대조」 행.
