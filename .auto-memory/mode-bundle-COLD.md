# Mode bundle COLD storage (= 5 mode 영구 누적 + cold 영역 default)

> 본 file = mode bundle cold storage default · hot 영역 = `.claude/rules/mode-system.md §2` default · 재발 시점 hot 복귀 default
> 위치 = `claude-cli-master/.auto-memory/mode-bundle-COLD.md` (= master only default · propagation X default)
> 신설: `MASTER-CLI-CYCLE-4B-MODE-BUNDLE-COLD-INSTALL-001` · 2026-05-22
> lifecycle: 매 5 cycle 또는 분기 review default (= `cycle-discipline.md §18` 정합 default)

---

## §1. 5 mode 영구 누적 (= Phase 2 본문 default)

### Hot 영역 (= `.claude/rules/mode-system.md` 측 hot default · Cycle 4a 마감 default · 본인 confirm 3 default)

- M1 production-graduated (= 현 default mode default)
- M3 migration-safe (= 비가역 영역 default)
- M5 cli-infra-ops (= cli infra propagation default)

### Cold 영역 (= hot 제외 영역 default · 재발 시점 hot 복귀 default · 본 cycle 신설 default)

#### M2 — mvp-exploration (= cold default)

- **Purpose**: 신 도메인 활성화 + 가설 검증 default — 속도 우선 + 최소 abstraction + 가역성 보장 default
- **Method defaults**: Direct 구현 우선 + Hardcoded stub + TODO(user-prep) 광범위 + 단일 Screen + ViewModel + Repository 추상 회피 default
- **Verification policy**: Low Risk default (= ≤ 200 LOC + PLAN/REVIEW 3-section default) · 단 변동성 경계 발견 시 M1 측 mode 전환 의무 default (= B-10 정합 default)
- **적용 trigger**: 구현 상태 = exploration + 도메인 = UNKNOWN (= Data + Backend + Perf default · `deferred-domains.md §2` 정합 default) + 신 화면 1 개 prototype default
- **Anti-pattern**: "DependencyDecision 진입 default" + "Repository interface 신설 default" + "다중 Screen 묶음 default" + "테스트 skip 영구 default" 등 발견 시 M1 전환 signal default
- **cold 본질**: 현 5-repo 측 신 도메인 활성화 frequency 낮음 default (= Auth + Billing = ACTIVE default · Data + Backend + Perf = UNKNOWN default · 활성화 trigger 시점 hot 복귀 default · `deferred-domains.md §6` history 참조 default)

#### M4 — refactor-preserve (= cold default)

- **Purpose**: 구조 개선 + 테스트 보존 default — 행위 보존 + 추상화 정합 + Layer Boundaries 강화 default
- **Method defaults**: 기존 테스트 보존 의무 + SOLID/DRY/KISS/YAGNI 강화 (= `code-principles.md §1` + §2 정합 default) + DependencyDecision 8 (= 신 의존성 0 default) + Layer Boundaries verify default
- **Verification policy**: Medium Risk default (= ≤ 120 LOC + PLAN 10-section + REVIEW 12-section default) + 모든 기존 테스트 PASS 의무 + Compose @Preview 정합 verify + Roborazzi snapshot 정합 default
- **적용 trigger**: 행위 변경 X + 구조 개선 + Layer Boundaries 위반 정정 + dead code 제거 + 중복 영역 통합 default
- **Anti-pattern**: "행위 변경 default" + "테스트 변경 default" + "스키마 변경 default" + "신 의존성 default" 등 발견 시 즉시 M1 또는 M3 측 mode 전환 default
- **cold 본질**: 5-repo 측 refactor 영역 frequency 낮음 default (= cli infra ops + production feature 영역 default · refactor trigger 시점 hot 복귀 default · `MASTER-CLI-CLEANUP-7CYCLE-001` precedent default · 매 quarter 1 회 frequency default)

---

## §2. hot 복귀 trigger

- 본 cold mode 영역 적용 trigger frequency ↑ 측정 시점 default (= 매 5 cycle 측정 default · `cycle-discipline.md §18` 분기 review cadence 정합 default)
- 사용자 본심 명시 default
- 자식별 mode 발산 cycle (= L1-6 protocol default · `mode-system.md §4` 정합 default) 진입 시점 default
- hot 복귀 cycle = 별 master cycle default (= `MASTER-CLI-MODE-HOT-PROMOTE-NNN` 가칭 default · 5-repo byte-identical propagation 의무 default)

---

## §3. cycle 이력

- 2026-05-22 · `MASTER-CLI-CYCLE-4B-MODE-BUNDLE-COLD-INSTALL-001` · 본 file 신설 default · master only default · propagation X default
