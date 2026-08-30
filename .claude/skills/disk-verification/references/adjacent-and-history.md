# disk-verification — 인접 paradigm 정합 + cycle 이력 (verbatim)

> 본 file = [`../SKILL.md`](../SKILL.md) §8 분할물.
> 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` 분할 · 구 `disk-verification §9`·`§11` + 구 `paste-source-authoring §9`·`§11`·`§12` **verbatim 이전** (= 삭제 0).

---

## §1 인접 paradigm 정합

### §1.1 구 `disk-verification §9` (verbatim)

| 인접 entry | 본질 |
|---|---|
| `docs/rules/cycle-discipline.md` §17 BASELINE 실측 표준 (= filename + content 동시 grep 의무) | 본 paradigm 측 의무 ① 측정 명령 영역 정합 default (= filename find 1차 + container 내부 content grep 2차) |
| `docs/rules/cycle-discipline.md` §23 (= 본 skill 측 pointer default · 신 § 신설 default) | 본 paradigm 본질 명시 영역 default · cycle scope 결정 영역 default |
| `.claude/skills/paste-source-authoring/SKILL.md` | 동족 paradigm default · cowork chat 측 paste source authoring 측 disk 실측 의무 default · 본 skill 측 §3 + §4.3 정합 default |
| `docs/rules/workflow-core.md` §implement Testability Seams | 동족 paradigm default (= 변동성 경계 측 인터페이스 측정 본질 정합 default) |
| `docs/rules/code-principles.md` §2 YAGNI | "나중에 쓸 것 으로 추가하지 않음" 정합 default · 본 paradigm 측 표면 후보 추측 차단 본질 정합 default |

> ⚠ 위 표 3행의 `.claude/skills/paste-source-authoring/SKILL.md` = **2026-07-29 본 skill 로 통합 · file 폐지**. 그 순환 참조(`disk-verification §3` ↔ `paste-source-authoring §8`)가 통합 사유였다. 행 자체는 이력이라 보존.

### §1.2 구 `paste-source-authoring §9` (verbatim)

| 인접 entry | 본질 |
|---|---|
| `docs/rules/cycle-discipline.md` §23 (= Recommended option disk verification paradigm pointer) | 동족 paradigm default · cli session 측 disk 측정 의무 paradigm default · 본 skill = cowork chat 측 paste source authoring paradigm default · 별 file 분리 paradigm default |
| `docs/rules/cycle-discipline.md` §25 (= INITIATIVES auto-sync paradigm pointer) | format precedent default · self-contained 12 section format 차용 default |
| `docs/rules/cycle-discipline.md` §17 (= BASELINE 실측 표준) | 본 skill 측 §3.1 의무 1 본문 정합 default (= filename + content 동시 grep 의무 default) |
| `docs/rules/cycle-discipline.md` §7 (= commit body 6-section 표준) | 본 skill 측 §4.1 paste-back `[EC]` 섹션 정합 default |
| `.claude/skills/disk-verification/SKILL.md` | 동족 paradigm 본질 default · 본 skill 측 §8 자기 정합 paradigm 본질 정합 default + §3 의무 영역 본문 정합 default |
| `.claude/skills/initiatives-sync/SKILL.md` | format precedent default · self-contained 12 section default · 본 skill format 차용 default |
| `cowork-project-instructions v14 §B-1` | cowork chat 측 paste source 발행 책임 default · 본 skill paradigm 정합 default |
| `cowork-project-instructions v14 §B-2` | 책임 분리 paradigm default · cli session 측 paste-back verify 책임 default · 본 skill §1.2 정합 default |
| `cowork-project-instructions v14 §E-1` | prompt authoring cross-verify default · 본 skill paradigm 본질 정합 default |

---

## §2 cycle 이력 (verbatim)

### §2.1 구 `disk-verification §11`

- 2026-05-21 · `MASTER-CLI-RECOMMENDED-OPTION-DISK-VERIFICATION-PARADIGM-001` · 직전 rule (`docs/rules/recommended-option-disk-verification.md`) 신설 (= paradigm 본질 + 4 의무 영역 + paste source authoring ⑤ 자기 정합 paradigm + 예시 case 3 + 위반 mitigation cycle + 적용 영역 + 인접 paradigm 정합 default) + cycle-discipline.md §23 신설 default + 5-repo byte-identical propagation
- 2026-05-26 · `MASTER-CLI-SKILLS-MIGRATION-PHASE-1-001` · 본 skill 신설 default (= 직전 rule 본문 본질 보존 default · skill paradigm 정합 default · trigger 시점 lazy load default · `docs/rules/recommended-option-disk-verification.md` 측 thin pointer 갱신 default)

### §2.2 구 `paste-source-authoring §11`

- 2026-05-22 · `MASTER-CLI-PASTE-AUTHORING-DISK-VERIFICATION-PARADIGM-001` · 직전 rule (`docs/rules/paste-authoring-disk-verification.md`) 신설 (= paradigm 본질 + trigger 조건 + 3 의무 영역 + paste-back verify 의무 본문 + cli session 자율 paradigm + STOP 조건 + 적용 영역 + 자기 정합 paradigm 본질 + 인접 paradigm 정합 default) + `cycle-discipline.md` §26 pointer 추가 default + CLAUDE.md §15 entry append default + 5-repo byte-identical propagation default
- 2026-05-26 · `MASTER-CLI-SKILLS-MIGRATION-PHASE-1-001` · 본 skill 신설 default (= 직전 rule 본문 본질 보존 default · skill paradigm 정합 default · trigger 시점 lazy load default · `docs/rules/paste-authoring-disk-verification.md` 측 thin pointer 갱신 default)
- 2026-07-26 · `MASTER-CLI-RULES-SETTLE-001` · **§4.5 커밋 file 집합 대조 의무**(= D-6 · `git show --name-only <sha>` vs paste §2 scope · "내 diff 는 깨끗하다" = diff 에 참 · **커밋에 거짓 가능** · 근거 = file 겹침 0 인 3 cycle 동시 진행의 커밋 오염 9건) + **§4.6 수치 인용 = 산출 명령 + 환경 동반**(= A-5′ · aggregate 해시 = 정체성 아닌 **drift 검출기** · 재현 대상 = "한 실행 안에서 N-repo 동일" 불변식 · 근거 = 환경 차이 3회 반복) 신설. 기존 §1~§4.4 · §5~§12 무접촉. 4-repo byte-identical propagation.
- precedent: `MASTER-CLI-LAUNCH-STATUS-AUTO-SYNC-PARADIGM-001` (= H35 마감 default · self-contained 12 section format default · 본 skill format 차용 default) + `MASTER-CLI-RECOMMENDED-OPTION-DISK-VERIFICATION-PARADIGM-001` (= H29 마감 default · 동족 paradigm 본질 default · cli session 측 disk 측정 의무 paradigm default · 본 skill = cowork chat 측 paste source authoring paradigm default · 별 file 분리 paradigm default)
- trigger baseline: H36 chat 측 3REPO-CRITICAL-PATH-PROGRESS-001 cycle GB scope 재 정의 사고 default (= paste source umbrella 측 `BreathSessionRepository.kt` + `BreathSessionDao.kt` 명시 default · 실 disk 부재 default · 실 disk = `MeditationSessionsListRepository.kt` 정합 default · cli session 측 자율 scope 재 정의 마감 default · 본 사고 재발 risk 회피 default)

### §2.3 통합 cycle

- 2026-07-29 · `MASTER-CLI-CONTEXT-DIET-3-001` · `paste-source-authoring` + `disk-verification` **통합** (= 구 `paste-source-authoring §12` 통합 후보 집행 · 조건 "책임 분리 영역 단일 SoT 유지" 준수 → 통합본 `§2 책임 분리`). 원칙 + 의무 ①~⑤ + gotcha = `SKILL.md` 본문 · 사례/인접표/이력 = 본 `references/` 분할. `paste-source-authoring/SKILL.md` file 폐지 (= 본문 전량 통합본 + 본 references 로 이전 · 삭제 0). skill 내 STOP 표 = canonical 3 항(보호 sha / HIGH RISK / 본심 분기) 재복제 제거 → `.claude/rules/stop-canonical.md` pointer · **skill 고유 2 항만 잔류**. 4-repo byte-identical propagation.

### §2.4 자 규율 층 (= 2026-08-29~ · `verification-and-review.md §0` 연동)

> **소급 경계** = `SKILL.md §10` 이력 절 신설 시점 기준 **직전 2 판 + 본 판**. 그 앞은 **회부** (= 등재 의무 = 2026-08-29 `rule-footer-common.md:10` 신설 · 무한 소급 아님).

- 2026-08-29 · `MASTER-TASK-PURPOSE-CONTRACT-001` · `SKILL.md` §4 ⑥ 세부 **K-155 신설** (= 발주는 「무엇을 하라」와 함께 「**무엇을 위한 것인지**」를 넘기고 집행자에게 **되짚게** 한다 · ★「읽었나」는 검증 불가 · 「되짚었나」는 **검증 가능** · 집행 측 = 자기 말 1 문단 재진술[목적 · ⓑ 좌표 지목 · 아닌 것] · ★verbatim 복붙 = 미이행 · 접수 측 자 2 = 좌표 round-trip + 할루시 검출점 · **게이트 계수로 세우지 않는다**). 자 = `git log -S'K-155'` → `9591b7d`.
- 2026-08-30 · `MASTER-MEASURE-DISCIPLINE-001` · `SKILL.md` §4 ⑥ **자 규율 SoT pointer 신설** (= 자를 고르는 규율의 본문 SoT = `verification-and-review.md §0` · §0.1 도구 범위 / §0.3 자기 제외·행별 칸 수·단위 병기 / §0.6 명제의 자) + 세부4 「유지보수 부채」에 **「남긴 부채」 옆 자** 1 구. 자 = `git show --numstat b3a8857` → **2 추가 / 1 삭제**.
- 2026-08-30 · `MASTER-DOC-MANIFEST-SWEEP-002` · `SKILL.md` **§10 「명시 cycle 이력」 절 신설** (= **pointer-only** · 본 §2 가 이력 단일 SoT 로 유지 · 착지 판정 근거 = §4 ⑥ 세부5 **K-147** 자기 적용 + `cross-repo-parallel-exec.md §8` / `anchor-list.md §7` 선례) + **본 §2.4 신설**. ★발주는 본 skill 을 「이력 절 부재」로 분류했으나 실물은 **「부재」가 아니라 「분할」**이었다 — 신설된 것은 이력이 아니라 **그 입구**다.

---

## §3 후속 cycle 후보 (= 구 `paste-source-authoring §12` verbatim · 통합 항은 소진)

- enforce hook 신설 후보 default (= cowork chat 측 paste source authoring 측 disk 실측 자동 verify hook default · 본 skill 측 §6 STOP #2 정합 default · 누적 3 회 위반 발화 시점 mitigation cycle 진입 default)
- ~~`.claude/skills/disk-verification/SKILL.md` + 본 skill 통합 paradigm 후보 default~~ → **2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` 집행 완료** (= §2.3)
- 본 skill 측 자기 정합 paradigm 본질 후속 사례 누적 default (= 후속 cycle 측 본 skill 본질 적용 default · 누적 통계 measurement default)
