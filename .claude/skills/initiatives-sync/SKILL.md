---
name: initiatives-sync
description: Use after a child cycle REVIEW PASS to sync docs/release-readiness/INITIATIVES.md + .ai/tasks/INDEX.md + .ai/tasks/<CYCLE-ID>.md before paste-back emission. Enforces the 3-file update obligation. Trigger-based paradigm — not invoked every cycle, only on child cycle REVIEW PASS or catch-up cycle entry.
paths: docs/release-readiness/INITIATIVES.md, .ai/tasks/**
allowed-tools: Bash, Read, Edit, Write
---

# INITIATIVES + INDEX + Task file Auto-Sync Paradigm

> **단일 목적**: 활성 도메인 자식 (= Selfward) 측 cycle REVIEW PASS 시점 cli session 측 `docs/release-readiness/INITIATIVES.md` + `.ai/tasks/INDEX.md` + `.ai/tasks/<CYCLE-ID>.md` 3 file 갱신 의무 paradigm. trigger 기반 paradigm default (= 자식 cycle 마감 시점 진입 default · paste-back 본문 발행 직전 시점 default · 매 cycle 마감 시점 catch-up drift 회피 default).
> **신설**: MASTER-CLI-LAUNCH-STATUS-AUTO-SYNC-PARADIGM-001 (2026-05-22).
> **precedent**: `MASTER-CLI-RUNTIME-CRASH-MITIGATION-PROCESS-PARADIGM-001` (= H32 마감 default · self-contained 11 section format default · 본 skill format 차용 default).
> **trigger 본질**: 직전 H32-H34 마감 사이클 측 INITIATIVES HEAD drift 누적 default (= GB 14 commits / GD 18 commits / GT 12 commits drift default) + `.ai/tasks/INDEX.md` 갱신 drift (= GD 4 days 누락 / GT 6 days 누락 default) + 신 task file 누락 (= GB 2 / GD 0 / GT 1 default) baseline default.
> **연관 paradigm**:
> - `docs/rules/cycle-discipline.md` §5 v2 line 75 ([agent-commit: yes] 묵시 동의 paradigm default)
> - `docs/rules/cycle-discipline.md` §7 (commit body 6-section 표준 default)
> - `docs/rules/cycle-discipline.md` §15 패턴 1 (master 측 cli infra 단방향 propagation default)
> - `docs/rules/cycle-discipline.md` §20 (DocSync 단계 본문 default · 자식 출시 docs 영역 명시 default)
> - `docs/rules/cycle-discipline.md` §25 (= 본 skill 측 pointer default)
> - `.claude/skills/disk-verification/SKILL.md` (disk 측정 의무 paradigm default · 본 paradigm 측 baseline 측정 영역 정합 default)
> - `docs/rules/workflow-core.md` §단계 흐름 (DocSync bullet default · 본 paradigm 측 trigger 시점 정합 default)

---

## §1 본 paradigm 본질

### §1.1 trigger 기반 paradigm default

매 cycle 마감 시점 강제 갱신 X default · 자식 cycle REVIEW PASS 시점 default · paste-back 본문 발행 직전 시점 진입 default. catch-up drift 누적 회피 default · 사고 patterns (= H32-H34 마감 사이클 측 누락 누적 default) mitigation 단일 default.

본 paradigm 진입 trigger:

| trigger | 본질 |
|---|---|
| 자식 cycle REVIEW PASS 시점 default ⭐ | cli session 측 cycle 마감 시점 default · paste-back 본문 발행 직전 default · 의무 영역 default |
| 자식 propagation cycle 마감 시점 | propagation cycle 측 마감 시점 default · 본 paradigm 측 INITIATIVES 갱신 lazy 가능 default · 자율 default |
| catch-up cycle 진입 시점 | INITIATIVES HEAD drift 누적 발견 시점 default (= 사용자 본심 회수 default · 별 cycle 진입 default) |

### §1.2 책임 분리 (= `cowork-project-instructions v14 §B-2` 정합)

| 영역 | 책임 |
|---|---|
| cowork chat | paste source umbrella 발행 default + paste-back 회수 + cross-verify default |
| **cli session** ⭐ | **INITIATIVES + INDEX + task file 3 file 갱신 의무 default + paste-back `[EC]` 섹션 측 verify 본문 명시 default + `[Diff]` 섹션 측 갱신 file list 명시 default** |
| 사용자 본인 | terminal 진입 + paste 운반 + cleanup pass 결정 (= 자율 default) |

본 paradigm 핵심 = **갱신 영역 본질 = cli session 단일 default** · cowork chat 측 sandbox 측 영역 X default.

---

## §2 trigger 조건

### §2.1 자식 cycle REVIEW PASS 시점 default (= 의무 영역)

- `/review` 또는 `/review-task` 실행 후 REVIEW.md PASS 판정 default
- paste-back 본문 발행 직전 default (= cycle 마감 step default)
- cli session 측 본 paradigm §3 5 의무 영역 진입 default

### §2.2 자식 propagation cycle 마감 시점 (= lazy 가능 영역)

- master 측 cli infra 변경 propagation cycle 측 마감 시점 default
- 자식 측 staged commit 마감 시점 default
- 본 paradigm 측 INITIATIVES 갱신 영역 = lazy 가능 default (= 자식 도메인 코드 변경 X default · 자율 default)

### §2.3 catch-up cycle 진입 시점 (= 별 cycle default)

- INITIATIVES HEAD drift 누적 발견 시점 default (= 사용자 본심 회수 default)
- catch-up 영역 = 본 paradigm 정착 cycle 마감 후 별 cycle default (= scope expansion 회피 default)

---

## §3 5 의무 영역 (= 3 file 갱신 ①~③ + 2 검증 gate ④~⑤)

본 paradigm 핵심 의무 영역 default. cli session 측 cycle 마감 시점 다음 5 의무 영역(= 3 file 갱신 ①~③ + 2 검증 gate ④~⑤) 진입 의무:

| # | 영역 | 본질 | 위치 |
|---|---|---|---|
| 1 | **INITIATIVES 갱신 의무 default** ⭐ | task 상태 ☐ → ✓ default · §1 baseline HEAD sha 갱신 default · 신 cycle ID + 마감 sha 인용 default | `docs/release-readiness/INITIATIVES.md` |
| 2 | **`.ai/tasks/INDEX.md` 갱신 의무 default** | 신 task entry append default · cycle ID + 마감 sha + mtime 명시 default | `.ai/tasks/INDEX.md` |
| 3 | **`.ai/tasks/<CYCLE-ID>.md` 신 task file 생성 의무 default** | 본 cycle outcome + scope + 결정 paradigm + paste-back 본문 default · INDEX 측 인용 default | `.ai/tasks/<CYCLE-ID>.md` |
| 4 | **④ KR 귀속 검증 gate default** | §3 active initiative 전수 KR 태그 1+ default (= 고아 0 의무 · `[—] (future-phase · no Q3 KR)` 예외 허용) · 고아 발견 = 등재 거부 / 표면화 default | `docs/release-readiness/INITIATIVES.md` §3 |
| 5 | **⑤ 완료분 always-fresh default** | cycle 마감 시 완료 task ☐ → ✓ 정정 default + 신규 완료분 등재 default (= STALE 재발 방지 · audit #3 보강) | `docs/release-readiness/INITIATIVES.md` §3 |

### §3.1 INITIATIVES 갱신 본질

- 본 cycle 마감 task 영역 측 상태 표기 ☐ → ✓ default
- baseline HEAD sha 영역 갱신 default (= 본 cycle commit sha 인용 default)
- 신 cycle ID + 마감 sha + 마감 date 영역 명시 default
- 자식 도메인 task 영역 default (= cli infra cycle 영역 = 자식 측 본 file 측 lazy default · 자율 default)

### §3.2 `.ai/tasks/INDEX.md` 갱신 본질

- 신 task entry append default (= INDEX 상단 또는 정합 영역 default · 자율 default)
- cycle ID + 마감 sha + mtime + 상태 (= DONE / STOP / BLOCKED) default
- 본 cycle outcome 1-line 명시 default

### §3.3 `.ai/tasks/<CYCLE-ID>.md` 신 task file 생성 본질

- 본 cycle outcome 본문 default
- scope (= 변경 영역 + 무접촉 영역) default
- 결정 paradigm (= cli session 자율 영역 default + 사용자 본심 정합 default) default
- paste-back 본문 default (= 6 섹션 default · `cycle-discipline.md §7` 정합 default)
- INDEX 측 인용 default

### §3.4 ④ KR 귀속 검증 gate 본질

- §3 active initiative 전수 KR(OKR Key Result · `OKR.md`) 귀속 태그 1+ default (= 고아 initiative 0 의무)
- 예외 허용 = `[—] (future-phase · no Q3 KR)` 명시 future-phase initiative (= 현 분기 KR 미귀속 정당 영역 default)
- 고아 발견(= KR 태그 부재 + future-phase 예외 미명시) = 등재 거부 또는 표면화 default (= audit #4 류 = KR 미귀속 출시 task 차단)
- KR ↔ initiative 귀속 = 제품 SoT `OKR.md`(전략 하위 live 분기 운영 층 · `../gently-product-docs/docs/`) 단일 SoT 참조 default (= 본 gate = 귀속 *검증*만 · OKR 본문 편집 아님 default)

### §3.5 ⑤ 완료분 always-fresh 본질

- cycle 마감 시점 §3 측 완료 task 상태 ☐ → ✓ 정정 default (= STALE = 완료분이 ☐ 잔존하는 drift 재발 방지)
- 신규 완료분 등재 default (= 본 cycle 마감 deliverable 가 §3 미등재면 등재 + ✓)
- §A upstream 등재(plan)와 짝 default = upstream 등재(신규 식별) + downstream always-fresh(완료) 양단 차단 (= `workflow-core.md` §신규 출시 deliverable 등재 정합)

---

## §4 verify 의무 본문

본 paradigm 핵심 의무 영역 default. 자식 cycle 마감 시점 paste-back 본문 측 다음 verify 영역 의무:

### §4.1 paste-back `[EC]` 섹션 측 갱신 verify 본문 명시 default

```
[EC]   <기존 verify 본문> · INITIATIVES 갱신 ✓ (= task <ID> 상태 ☐ → ✓ + baseline HEAD <sha> 갱신) · INDEX append ✓ (= 신 entry <cycle-id>) · task file 생성 ✓ (= .ai/tasks/<cycle-id>.md)
```

### §4.2 paste-back `[Diff]` 섹션 측 갱신 file list 명시 default

```
[Diff] <기존 변경 file list> · docs/release-readiness/INITIATIVES.md (+N LOC) · .ai/tasks/INDEX.md (+N LOC) · .ai/tasks/<cycle-id>.md 신설 (+N LOC)
```

### §4.3 self-consistent 의무 default

본 paradigm 본질 = self-consistent default · 본 skill 진입 cycle 측 paste-back 자체 = 본 paradigm 측 사례 default.

단 master cli infra cycle = INITIATIVES file 부재 default + `.ai/tasks/` 영역 부재 default (= 자식 도메인 영역 default) → master cycle 측 5 의무 영역 진입 X default (= 자식 도메인 cycle 측 본 paradigm 본질 사례 default).

### §4.4 `cycle-discipline.md` §20 DocSync 정합 default

본 paradigm = `cycle-discipline.md §20` DocSync 단계 안 자식 출시 docs 영역 갱신 paradigm 본질 default. §20.1 갱신 대상 영역 측 "자식 출시 docs" 영역 (= `docs/release-readiness/INITIATIVES.md` + `docs/CLAUDE.md` 또는 자식 root `CLAUDE.md` + `docs/setup/*`) 측 INITIATIVES file 갱신 의무 본문 단일 default.

---

## §5 cli session 자율 paradigm

본 paradigm 측 cli session 자율 결정 영역 default:

| 영역 | 자율 본질 |
|---|---|
| 갱신 본문 본질 | cleanup pass paradigm 정합 default · 자식별 default 또는 통합 default · 자율 default |
| 갱신 commit 분할 paradigm | cycle commit 측 inline default 또는 별 cleanup commit default · 자율 default (= `cycle-discipline.md §5 v2` 자동 허용 카테고리 정합 default) |
| 갱신 lazy 영역 | propagation cycle 측 lazy 가능 default · 자식 IMPL cycle 측 의무 default |
| INITIATIVES 영역 본문 영역 | 자식 본문 format 정합 default · 자율 default (= 자식별 format 차이 default) |
| INDEX 측 entry 영역 본질 | 자식 INDEX format 정합 default · 자율 default |
| 신 task file 본문 본질 | precedent task file format 정합 default · 자율 default · self-contained 의무 default |
| catch-up paradigm | 본 paradigm 정착 cycle 측 무접촉 default (= 별 cycle default · scope expansion 회피 default) |

---

## §6 STOP 조건

| # | trigger | mitigation |
|---|---|---|
| 1 | 보호 5 file sha drift 발견 | 즉시 STOP + 사용자 회수 default (= `cycle-discipline.md §10` 정합) |
| 2 | INITIATIVES file 부재 발견 (= 자식 측 file 부재 default · 신설 X 영역 default) | STOP + 사용자 회수 default (= 본 paradigm 측 신설 영역 X default · 별 cycle default) |
| 3 | `.ai/tasks/` 디렉터리 부재 발견 (= 자식 측 dir 부재 default) | STOP + 사용자 회수 default (= 본 paradigm 측 신설 영역 X default · 별 cycle default) |
| 4 | catch-up drift 영역 발견 시점 본 cycle scope expansion 의도 default | STOP + scope 재 정의 default (= 본 cycle 측 정착 영역 단일 default · catch-up = 별 cycle default) |
| 5 | 사용자 본심 분기 의제 본질 발견 (= 갱신 paradigm 본질 결정 default · 자식별 vs 통합 default 등) | AskUserQuestion 회수 default |

---

## §7 적용 영역

| 영역 | 적용 |
|---|---|
| 활성 도메인 자식 (= Selfward) 측 cycle REVIEW PASS 시점 default | 의무 default ⭐ |
| 동결 3 (= GB / GD / GT) 측 | **해당 X** (= 2026-07-17 T6 · 쓰기 0 · 본 skill 진입 자체가 STOP) |
| 자식 repo 측 propagation cycle 마감 시점 | lazy 가능 default (= 자율 default) |
| app-foundation 측 cycle REVIEW PASS 시점 | 의무 default (= 자식 측 동족 paradigm 차용 default · INITIATIVES 영역 정합 default) |
| master cli infra cycle 영역 | 적용 X default (= INITIATIVES file 부재 default + `.ai/tasks/` 영역 부재 default · cli infra rule 영역 default) |
| catch-up cycle 영역 | 별 cycle default (= 본 paradigm 정착 cycle 측 무접촉 default) |

---

## §8 paste source umbrella authoring 영역

본 paradigm 진입 paste source 측 권장 구조 (= precedent `MASTER-CLI-RUNTIME-CRASH-MITIGATION-PROCESS-PARADIGM-001` 측 실증 default):

| section | 본질 |
|---|---|
| §0 Baseline | 4-active HEAD sha + 보호 5 file sha + drift 영역 측정 결과 default |
| §0.3 사고 영역 disk 측정 | INITIATIVES HEAD drift + INDEX 갱신 drift + 신 task file 누락 영역 disk 측정 결과 인용 default (= `.claude/skills/disk-verification/SKILL.md` §3 정합) |
| §1 Cycle 본질 | outcome + cli session 자율 paradigm + 사용자 본심 정합 default |
| §2 Scope | 변경 영역 + 무접촉 영역 default |
| §4 변경 step | cli session 자율 step paradigm default |
| §5 §FREEDOM | cli session 자율 결정 영역 default |
| §6 STOP 조건 | 본 paradigm §6 정합 default |
| §7 paste-back 규약 | 6 섹션 default + cross-verify 의무 영역 + `[EC]` 섹션 측 본 paradigm 본질 사례 명시 의무 default |

---

## §9 commit body 본문 (= `cycle-discipline.md §7` 정합)

자식별 cycle 마감 commit body 6-section default (= 본 paradigm 적용 시점):

```
[Goal]   <자식 cycle outcome 본문>
[Diff]   <변경 file 영역> · docs/release-readiness/INITIATIVES.md (+N LOC) · .ai/tasks/INDEX.md (+N LOC) · .ai/tasks/<cycle-id>.md 신설 (+N LOC)
[Sha]    <보호 file sha 변경 영역 또는 (불변)>
[EC]     <기존 verify 본문> · INITIATIVES 갱신 ✓ · INDEX append ✓ · task file 생성 ✓
[Next]   <후속 cycle trigger 1줄>
[Refs]   parent <8자 sha> · cycle <TaskId> · paradigm MASTER-CLI-LAUNCH-STATUS-AUTO-SYNC-PARADIGM-001
```

---

## §10 인접 paradigm 정합

| 인접 entry | 본질 |
|---|---|
| `docs/rules/cycle-discipline.md` §5 v2 line 75 | [agent-commit: yes] 묵시 동의 paradigm default · 본 paradigm 측 commit step 정합 default |
| `docs/rules/cycle-discipline.md` §7 | commit body 6-section 표준 default · 본 paradigm 측 §9 정합 default |
| `docs/rules/cycle-discipline.md` §15 패턴 1 | master 측 cli infra 단방향 propagation default · 본 SoT 측 propagation 영역 정합 default |
| `docs/rules/cycle-discipline.md` §20 | DocSync 단계 본문 default · 자식 출시 docs 영역 명시 default · 본 paradigm 측 INITIATIVES 갱신 의무 본문 정합 default |
| `.claude/skills/disk-verification/SKILL.md` | Recommended option disk verification paradigm default · 본 paradigm 측 baseline 측정 영역 정합 default |
| `.claude/skills/runtime-crash-mitigation/SKILL.md` | Runtime crash mitigation process paradigm default · 본 paradigm 측 동족 trigger 기반 paradigm 정합 default |
| `docs/rules/workflow-core.md` §단계 흐름 | DocSync bullet default · 본 paradigm 측 trigger 시점 정합 default |

---

## §11 본 skill 의 변경 정책

- cli infra 권장 byte-identical (= 4-repo · master + app-foundation + gently-product-docs + Selfward)
- 변경 시 master cycle 신설 + 4-repo propagation 의무 (= `cycle-discipline.md` §15 패턴 1 정합)
- 자식 repo 측 직접 수정 금지

---

## §12 명시 cycle 이력

- 2026-05-22 · `MASTER-CLI-LAUNCH-STATUS-AUTO-SYNC-PARADIGM-001` · 직전 rule (`docs/rules/initiatives-auto-sync.md`) 신설 (= paradigm 본질 + trigger 조건 + 3 의무 영역 + verify 의무 본문 + cli session 자율 paradigm + STOP 조건 + 적용 영역 + paste source authoring 영역 + commit body 본문 + 인접 paradigm 정합 default) + `cycle-discipline.md` §25 pointer 추가 default + CLAUDE.md §15 entry append default + 5-repo byte-identical propagation default
- 2026-05-26 · `MASTER-CLI-SKILLS-MIGRATION-PHASE-1-001` · 본 skill 신설 default (= 직전 rule 본문 본질 보존 default · skill paradigm 정합 default · trigger 시점 lazy load default · `docs/rules/initiatives-auto-sync.md` 측 thin pointer 갱신 default)
- 2026-06-09 · `MASTER-CLI-P2-MECHANISM-001` · §C 의무 3 → 5 확장 (= ④ KR 귀속 검증 gate + ⑤ 완료분 always-fresh 추가 · §3 header + §2.1/§4.3 count 정합 + §3.4/§3.5 subsection 신설). Delivery Layer 재설계 Phase 2 (= 추적 2-세계 분리 차단 메커니즘 3 중 §C). 동반 (별 file): `workflow-core.md` §A(upstream 등재) + `rule-routing-index.md` §B(SoT→task drift trigger) + `cycle-discipline.md` §25.2 mirror 5 정합. 6-repo byte-identical propagation.
- precedent: `MASTER-CLI-RUNTIME-CRASH-MITIGATION-PROCESS-PARADIGM-001` (2026-05-22 H32 마감 default · self-contained 11 section format default · 본 skill format 차용 default)
- trigger baseline: H32-H34 마감 사이클 측 INITIATIVES HEAD drift 누적 default (= GB 14 commits / GD 18 commits / GT 12 commits drift default) + INDEX 갱신 drift (= GD 4 days 누락 / GT 6 days 누락 default) + 신 task file 누락 (= GB 2 / GD 0 / GT 1 default)
