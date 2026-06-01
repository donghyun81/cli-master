# Mode 시스템 (= AI 행동 layer · Phase 와 orthogonal default)

> 본 file = 5-repo 측 Mode 시스템 영구 SoT default · Mode = AI 행동 layer default · Phase A/B/C/D/F = 작업 lifecycle 위치 layer default
> 위치 = `claude-cli-master/.claude/rules/mode-system.md`
> Cold storage = `claude-cli-master/.auto-memory/mode-bundle-COLD.md` (= Cycle 4b 신설 default · master only default · propagation X default)
> 신설: `MASTER-CLI-CYCLE-4A-MODE-SYSTEM-HOT-INSTALL-001` · 2026-05-22

---

## §1. 본질 (= L1-2 정합 default)

- Mode = AI 행동 layer default · Phase A/B/C/D/F = 작업 lifecycle 위치 layer default · 두 layer = orthogonal default · 동시 활성 default
- 자산 본문 측 mode + Phase 명시 의무 default (= paste source umbrella + REVIEW.md + commit body 본문 default)
- Mode picker = 본인 한 단어 + cowork 추천 + 본인 confirm 1 초 default

---

## §2. Mode bundle (= 3 mode hot default)

### M1 — production-graduated (= 현 default mode default)

- **Purpose**: production 안정성 목표 + 도메인별 준비도 기반 단계적 활성화 default
- **Method defaults**: TDD + Clean Arch + SOLID + DependencyDecision 8 + Fake first + Repository pattern + UseCase boundary default
- **Verification policy**: Risk 별 차등 default (= `workflow-core.md §implement` SoftBudget(Risk별 LOC budget) + Risk 기반 산출물 경량화 표 정합 default · Low/Medium/High 별 LOC·섹션·독립 reviewer 본문 = `workflow-core.md` 단일 SoT)
- **적용 trigger**: 구현 상태 = production-ready 진입 + 도메인 = ACTIVE (= Auth + Billing default) + Pencil → Compose 파이프라인 영역 default
- **Anti-pattern**: "빠른 hack default" + "테스트 skip default" + "Fake 우회 default" + "DependencyDecision skip default" 발견 시 mode 재선택 signal default

### M3 — migration-safe (= 비가역 영역 default)

- **Purpose**: 비가역 영역 (= DB schema + Auth + Money default) 변경 default — 안전성 우선 + 가역성 보장 + 광범위 verify default
- **Method defaults**: TDD 강화 + Fake first + 광범위 verify + DependencyDecision 8 의무 + RLS verify + rollback path 명시 + production push X default
- **Verification policy**: High Risk default (= ≤ 60 LOC + PLAN 10-section + REVIEW 12-section + 독립 reviewer + PromptFit 필수 default) + STOP 조건 1 자동 발화 default + 사용자 본심 회수 의무 default
- **적용 trigger**: DB migration / Auth 변경 / Billing 변경 / Secret 접촉 / 보호 file 변경 default · master `CLAUDE.md §5` 1번 STOP 정합 default
- **Anti-pattern**: "fake 우회 default" + "verify skip default" + "production push 직접 default" + "rollback 영역 미명시 default" 발견 시 즉시 STOP default

### M5 — cli-infra-ops (= cli infra propagation default)

- **Purpose**: cli infra (= `.claude/` + `docs/schemas/` + 보호 file + `scripts/` default) 변경 + 5-repo byte-identical propagation default — production code 무접촉 + 단방향 propagation 정합 default
- **Method defaults**: master 측 단방향 source default + scripts/propagate.sh + scripts/verify-sync.sh + 5-repo cross-verify + propagation-reports/<cycle-id>/REPORT.md 자동 생성 + production code touch 0 LOC 의무 default
- **Verification policy**: Lightweight 4 file default (= `cycle-discipline.md §11` default · PLAN.md + VERIFY.md + REVIEW.md + TODO.md default) + cross-repo sha 정합 표 의무 + 보호 5 file sha 변동 0 verify 의무 default
- **적용 trigger**: cli infra 변경 + 보호 file 변경 + propagation cycle 진입 + master cycle 신설 default · `cycle-discipline.md §15` 패턴 1 정합 default
- **Anti-pattern**: "production code touch default" + "자식 repo cli infra 직접 수정 default" + "propagation skip default" + "보호 5 file sha drift default" 발견 시 즉시 STOP default

---

## §3. Mode 간 경계 + Mode picker 워크플로우

### §3.1 Mode 간 경계

| Mode | 경계 본질 |
|---|---|
| M1 vs M3 | M1 = production code 일반 변경 default · M3 = 비가역 영역 변경 default · trigger = master `CLAUDE.md §5` 1번 STOP 항 default |
| M1 vs M5 | M1 = 도메인 코드 영역 default · M5 = cli infra 영역 default · trigger = 변경 file path = `.claude/**` + `scripts/**` + 보호 file default |
| M3 vs M5 | M3 = 도메인 비가역 영역 default · M5 = cli infra 영역 default · trigger = 변경 file path default |

### §3.2 Mode picker 워크플로우 (= 사용자 본심 정합 default)

1. 본인 → 목적 한 단어 default (예: "production-quality" / "migration" / "cli-infra")
2. cowork → mode 추천 + 근거 + 대안 default (= 본 §2 mode bundle 본문 정합 default)
3. 본인 → confirm (1 초) default
4. cowork → paste source 발행 default (= mode + 목적 명시 default · paste source §1 본문 default)
5. cli session → mode 안에서 작동 default (= paste source §1 인용 default · REVIEW.md mode 명시 default · commit body mode 명시 default)

---

## §4. 현 단계 = 5-repo 동일 mode / 미래 = 자식별 발산 protocol (= L1-6 정합 default)

- 현 5-repo 측 default mode = M1 (= production-graduated default)
- 미래 자식별 mode 발산 = 본인 명시 결정 + migration cycle default
- 본 protocol 진입 시점 = 자식별 mode 본문 측 Why + How + B 14 항 침해 검증 + cold storage 측 누적 default
- migration cycle outcome = 자식별 `<repo>/.claude/CLAUDE.md` 측 mode 명시 default + master mode-system.md 측 발산 entry append default

---

## §5. Mode 잘못 결정 시 recovery (= L1-7 정합 default)

- Mode 잘못 결정 = STOP 조건 9 (= 사용자 본심 분기 의제 default · master `CLAUDE.md §5` canonical default · Cycle 1 결과 default) sub-case 흡수 default
- `verification-and-review.md §에러 유형별 복구 경로` 측 "REVIEW FAIL (블로커) → change-planner/system-architect 재계획" 정합 default
- 신 recovery 절차 신설 X default

---

## §6. STOP 조건 pointer (= Cycle 1 canonical SoT default)

본문 단일 SoT = master `CLAUDE.md §5` (= 9 STOP 항 default · Mode 잘못 결정 sub-case 흡수 default)

---

## §7. 인접 paradigm 정합

- master `CLAUDE.md §5` (= STOP canonical default · Cycle 1 결과 default)
- `workflow-core.md §단계 흐름` (= M1 baseline default)
- `workflow-core.md §implement` (= SoftBudget + Risk 기반 산출물 경량화 · Verification policy default · Risk-based default)
- `verification-and-review.md §에러 유형별 복구 경로` (= L1-7 recovery sub-case 흡수 default)
- `deferred-domains.md` (= M2 cold default · UNKNOWN → ACTIVE trigger default)
- `safety-and-secrets.md §비가역 변경 STOP 정책` (= M3 trigger default · Cycle 1 마감 후 pointer 영역 default)
- `automation-policy.md` (= Cycle 3 결과 default · M5 baseline default)
- `anchor-list.md` (= A8 paradigm autonomy 정합 default)
- `recommended-option-disk-verification.md` (= mode 측정 정합 default)
- **`.auto-memory/mode-bundle-COLD.md`** (= **Cycle 4b 신설 default · master only default · cold storage pointer default**)

---

## §8. cycle 이력

- 2026-05-22 · `MASTER-CLI-CYCLE-4A-MODE-SYSTEM-HOT-INSTALL-001` · 본 file 신설 + cycle-discipline.md §29 pointer 신설 + 5-repo byte-identical propagation default
- 2026-05-22 · `MASTER-CLI-CYCLE-4B-MODE-BUNDLE-COLD-INSTALL-001` · cold storage `mode-bundle-COLD.md` 신설 default (= master only default · 본 § 본문 X default · Cycle 4b 측 본문 default)
