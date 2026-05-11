# 패키지 출시 거시 현황 — 4-repo + app-foundation

> **단일 목적**: 부모 패키지 (master + foundation + 자식 3) 의 거시 출시 SoT.
> **운영 책임 분리**:
> - `claude-cli-master` = cli infra + 보호 파일 + 거시 propagation SoT
> - `app-foundation` (미신설) = 앱 구현 코드 SSOT (KMP/CMP scaffold + Supabase + billing + observability)
> - `GentlyBreath` / `GentlyDay` / `GentlyTable` = 도메인 (호흡 / 일상 / 식단)
> **갱신 trigger**: 자식 cycle REVIEW PASS · 보호 파일 sha 변동 · foundation feature 마감.

---

## 1. baseline + progress (2026-05-10 18:17 KST 실측)

| repo | HEAD | 단계 | P0 progress | 출시 |
|---|---|---|---|---|
| claude-cli-master | `21128f9` | 운영 (master 측 task 진행) | 0/8 | — |
| app-foundation | `923346b` | scaffold + cli infra 정합 마감 (Gradle wire-up + core/ 실 wire = 자식 cycle) | 1/12 (8%) | — |
| GentlyBreath | `1fd77aa` | Phase 2 Auth 진행 | 1/24 (4%) | ✓ |
| GentlyDay | `90f4a14` | Phase 1 마감 / Phase 2 진입 대기 | 1/22 (5%) | ✓ |
| GentlyTable | `aa78a5a` | Phase 3 SoT 진행 | 1/26 (4%) | ✓ |

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
| MASTER-T03 | `docs/templates/release-checklist.template.md` 신설 | P0 | ☐ | — | (왜) 자식 P4 진입 시 cp 표준 · (예) Play Console 빌드 시 권한·Privacy·ASO 누락 회피 |
| MASTER-T04 | 13 architecture 문서 → foundation 인용 link 갱신 | P1 | ☐ | T01 | (왜) 자식 reading order 정합 · (예) `KMP_CMP_LAYER_DIRECTION.md` 가 foundation `shared/` 가리키도록 |
| MASTER-T05 | `repo-config.sh` 의 `PROTECTED_FILES` / `CHILD_REPOS` 갱신 | P0 | ☐ | T01 | (왜) propagation 의 export 변수 SoT · (예) `CHILD_REPOS=GB GD GT FND` |
| MASTER-T06 | COWORK-PREP-BASELINE-MISMATCH (12회 누적) mitigation hook | P1 | ☐ | — | (왜) cowork ↔ cli baseline 동기 사고 차단 · (예) prompt 발행 전 4-repo HEAD 자동 cross-check |
| MASTER-T07 | `docs/templates/launch-status.template.md` 신설 (자식 LAUNCH-STATUS 갱신 표준) | P1 | ☐ | T03 | (왜) 자식 LAUNCH-STATUS 갱신 표준 · (예) 새 도메인 task 추가 시 cp |
| MASTER-T08 | `docs/templates/foundation-fork.template.md` (자식 신규 앱 fork 절차) | P2 | ☐ | T01 | (왜) 미래 앱 (`FocusBites` 등) 신설 30 분 baseline · (예) `bash scripts/fork-from-foundation.sh <new-app>` |

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
