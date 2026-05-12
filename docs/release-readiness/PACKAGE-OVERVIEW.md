# 패키지 출시 거시 현황 — 4-repo + app-foundation

> **단일 목적**: 부모 패키지 (master + foundation + 자식 3) 의 거시 출시 SoT.
> **운영 책임 분리**:
> - `claude-cli-master` = cli infra + 보호 파일 + 거시 propagation SoT
> - `app-foundation` (미신설) = 앱 구현 코드 SSOT (KMP/CMP scaffold + Supabase + billing + observability)
> - `GentlyBreath` / `GentlyDay` / `GentlyTable` = 도메인 (호흡 / 일상 / 식단)
> **갱신 trigger**: 자식 cycle REVIEW PASS · 보호 파일 sha 변동 · foundation feature 마감.

---

## 1. baseline + progress (2026-05-11 14:39 KST 실측)

| repo | HEAD | 단계 | P0 progress | 출시 |
|---|---|---|---|---|
| claude-cli-master | `67eb0c2` | 운영 (T01/T02/T03/T04/T05 ✓ · T06~T08 진행 대기) | 5/8 (63%) | — |
| app-foundation | `f1f40f4` | scaffold + cli infra 정합 마감 · core/ 실 wrapper = FND-T02~T10 별 cycle | 1/12 (8%) | — |
| GentlyBreath | `0552529` | Phase 2 Auth ACTIVE + upgrade-account-screen Pencil SoT 마감 | 2/25 (8%) | ✓ |
| GentlyDay | `4d867cc` | Phase 1 마감 / Phase 2 진입 대기 (Auth UNKNOWN) | 1/22 (5%) | ✓ |
| GentlyTable | `d90c19e` | Phase 3 SoT 진행 (daily-prescription ✓) | 1/26 (4%) | ✓ |

> progress 카운트 = P0 task 마감 / 전체. CLI cleanup pass 자동 갱신 영역.

---

## 2. 보호 파일 5 종 (4-repo byte-identical · git blob sha 16자)

| 파일 | sha | 분류 |
|---|---|---|
| `docs/schemas/ui-spec.schema.json` | `5b84cd9e4bc36165` | 도구 무관 |
| `.claude/rules/uiux-sot-refresh.md` | `d3a0b57390bd0414` | 도구 무관 |
| `docs/design/design-sot-policy.md` | `e580b6d7ca9a88ae` | 도구 무관 |
| `.claude/rules/pencil-uiux-workflow.md` | `3a703b30553e0d09` | Pencil 바인딩 |
| `docs/design/pencil-sot-policy.md` | `b27fbe16edb68821` | Pencil 바인딩 |

검증: `bash scripts/verify-sync.sh` (master → 자식 cp propagation).

---

## 3. master 측 task (출시 전)

**critical path**: `MASTER-T01 → T02 → T03` (T04~T08 병렬 가능)

| ID | 항목 | P | 상태 | 의존 | 마감 sha · 본심 1 줄 |
|---|---|---|---|---|---|
| MASTER-T01 | `app-foundation` repo 신설 (git init + module 구조 scaffold) | P0 | ✓ | — | `cd6f418e2906` · (마감) MASTER-APP-FOUNDATION-SCAFFOLD-001 — KMP/CMP skeleton + libs.versions.toml SSOT + CLI infra cp + COMMON-SETUP-SSOT 이전 |
| MASTER-T02 | `propagate.sh` + `verify-sync.sh` 갱신 (5 → 6 repo · foundation 포함) | P0 | ✓ | T01 | (마감) MASTER-APP-FOUNDATION-SCAFFOLD-001 — TARGET_REPOS 6 확장 + FND case 추가 + release-readiness/* exclude (회수 1 흡수) |
| MASTER-T03 | `docs/templates/release-checklist.template.md` 신설 | P0 | ✓ | — | `3ad2d7f6af1e` · (마감) MASTER-RELEASE-CHECKLIST-TEMPLATE-001 — 9 섹션 placeholder template 신설 (3 자식 LAUNCH-STATUS §7~§9 공통 추출 + 7 placeholder · 자식 P4 진입 시 cp + 도메인 치환 의무) · 사고 = 초회 commit a30ad98 측 scripts/* 흡수 + decision-log T03 entry 부재 사고 → reset --soft HEAD~1 + clean state 재 commit (3ad2d7f) · 재 commit 측 decision-log T05 entry 동시 흡수 사고 = 별 trail open |
| MASTER-T04 | 13 architecture 문서 → foundation 인용 link 갱신 | P1 | ✓ | T01 | `990b58e` · (마감) MASTER-ARCHITECTURE-FOUNDATION-LINK-001 — 13 architecture 측 코드 path 인용 옆 markdown link 추가 (clickable · 자식 reading order 정합) + 신규 cli infra `.claude/rules/architecture-foundation-link-policy.md` 신설 (5-repo byte-identical · 추후 신설 시 자동 적용 baseline) + 5-repo propagation 56/56 PASS · 보호 5 sha 변동 X · 사전 DRIFT 2 영역 (cycle-discipline.md app-foundation + release-checklist.template.md 자식 4) 별 cycle 처리 trail |
| MASTER-T05 | `repo-config.sh` 의 `PROTECTED_FILES` / `CHILD_REPOS` 갱신 | P0 | ✓ | T01 | `b1b8ca552d48` · (마감) MASTER-REPO-CONFIG-SOT-001 — repo-config.sh single SoT 신설 (TARGET_REPOS 4-repo + PROTECTED_FILES 5종 + PARENT_DIR/MASTER_DIR · 40 line · git blob sha `b3027e52557f6ce3`) + 3 script source 통합 + ensure-child-gitignore drift 정정 (3→4 repo 흡수 · verify 4/0 PASS) |
| MASTER-T06 | COWORK-PREP-BASELINE-MISMATCH (12회 누적) mitigation hook | P1 | ☐ | — | (왜) cowork ↔ cli baseline 동기 사고 차단 · (예) prompt 발행 전 4-repo HEAD 자동 cross-check |
| MASTER-T07 | `docs/templates/launch-status.template.md` 신설 (자식 LAUNCH-STATUS 갱신 표준) | P1 | ☐ | T03 | (왜) 자식 LAUNCH-STATUS 갱신 표준 · (예) 새 도메인 task 추가 시 cp |
| MASTER-T08 | `docs/templates/foundation-fork.template.md` (자식 신규 앱 fork 절차) | P2 | ☐ | T01 | (왜) 미래 앱 (`FocusBites` 등) 신설 30 분 baseline · (예) `bash scripts/fork-from-foundation.sh <new-app>` |
| MASTER-T09 | text degeneration 본질 mitigation 정책 + post-edit hook | P1 | ✓ | — | (마감) MASTER-DEGENERATION-PREVENTION-POLICY-001 — `.claude/rules/text-degeneration-prevention.md` SoT 신설 (M1 sentence 3+ / M2 paragraph 5+ / M3 file z-score · paraphrase 의무 source 무관 · mental scan 3 step · session reset trigger) + `.claude/hooks/post-edit-degeneration-check.sh` (Python3 tokenizer · 화이트리스트 union allowed-acronyms · TARGET_EXTS .md/.txt · warn default · enforce mode env · positional argument fallback) + settings.json PostToolUse Edit\|Write matcher 등록 + 7 fixture self-test PASS · 5-repo byte-identical propagation |

---

## 4. propagation matrix (자식 영향도)

| 변경 영역 | 영향 repo | propagation 방식 |
|---|---|---|
| 보호 파일 5 종 sha 변동 | 모두 (4 + foundation) | `propagate.sh` byte-identical cp + `verify-sync.sh` |
| cli infra (`.claude/`) 갱신 | 권장 byte-identical (4 + foundation) | 권장 cp · drift 시 mitigation cycle |
| 13 architecture 문서 갱신 | 자식 reading order 갱신 | 자식 CLAUDE.md link 검증 |
| `app-foundation` feature 마감 | 자식 LAUNCH-STATUS 의존 task unblock | 자식 LAUNCH-STATUS §3 status 검증 |
| 자식 도메인 코드 | 자기 repo 만 | propagation X |

---

## 5. kill-switch 게이트

| 게이트 | 트리거 | 행동 |
|---|---|---|
| critical path 막힘 ≥ 7 일 | MASTER-T0X 상태 ⚠ 7 일 | 별 cycle 신설 + 의존 재검토 |
| 보호 파일 drift | `verify-sync.sh` exit 1 | 즉시 mitigation cycle (자식 cp) |
| COWORK-PREP-BASELINE-MISMATCH ≥ 15 회 | incident-log 카운트 | T06 hook 강화 cycle 즉시 진입 |
| 자식 P0 progress 정체 (2 주 0% 증가) | 자식 §1 progress | scope 축소 또는 외부 의뢰 결정 cycle |

---

## 6. 갱신 trigger

| trigger | 행동 |
|---|---|
| 자식 cycle REVIEW PASS | (1) 자식 LAUNCH-STATUS §3 status ✓ + sha + 본심 1 줄 (2) 본 §1 progress 카운트 갱신 — CLI cleanup pass 자동 |
| 보호 파일 sha 변동 | 본 §2 sha + propagation cycle |
| foundation feature 마감 | 자식 LAUNCH-STATUS COMMON-SETUP 인용 link 검증 |
| master task 마감 | 본 §3 status ✓ + sha + 본심 |

---

## 7. 한계 / 모름

- foundation propagation 메커니즘 (cp / submodule / Maven publish) = MASTER-T01 진입 시 결정 cycle.
- iOS 빌드 활성화 시점 = 자식 결정 (foundation `iosApp/` scaffold 후).
- 출시 마감일 = 미명시 (사용자 영역) → critical path 막힘 7 일 = kill-switch 트리거.
- 자식 도메인 task ID `<repo>-T<NN>` = Cowork 추천 명명. 사용자 변경 시 일괄 치환 cycle.
