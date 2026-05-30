# Plugin policy (= 전면 회피 → 조건부 허용 전환 default)

> 본 file = 5-repo 측 plugin(= Cowork / Claude Code plugins + marketplaces) 정책 영구 단일 SoT default · 판단 기준 유일 본문 default
> 위치 = `claude-cli-master/.claude/rules/plugin-policy.md`
> 신설: `MASTER-CLI-PLUGIN-POLICY-CONDITIONAL-001` · 2026-05-30
> 본질: 기존 "Plugins paradigm 회피" 무근거 한 줄 → 조건부 정책 + 판단 기준 L1-3/L1-4 명문화

---

## §1. 본질 (= 전면 회피 → 조건부 전환 default)

기존 A/B body 측 plugin 정책 = "Plugins paradigm 회피" 한 줄(= 근거 0 · 조건 분기 0)이 유일 본문이었다. 본 file은 이를 **조건부 정책**으로 전환한다.

- 전면 회피 폐기 default — plugin 도입 자체는 금지 영역이 아니다.
- 단 무조건 허용도 아니다 — §2 판단 기준 충족 영역에 한해 허용.
- plugin 실체 = Cowork + Claude Code 측 공식 지원 기능 default (= MCP/skills/tools 번들 + marketplaces · official / community / custom marketplace 3종). 조건부 허용의 대상이 실재한다.

---

## §2. 판단 기준 (= L1-3 polyrepo + L1-4 단일 SoT 정합 default)

plugin 도입 가부는 아래 2 분기로 판정한다. 본 §2가 판단 기준의 유일 본문 default (= A/B body + 자식 측은 본 file pointer만 보유).

| 분기 | 조건 | 판정 |
|---|---|---|
| **회피** | 자식별 차별화 / 커스텀이 필요한 영역 | 회피 default (= L1-3 polyrepo 의식적 선택 · 자식 도메인 발산 영역) |
| **허용** | 공식·공신력 plugin이면서 커스텀 불필요로 판단되는 영역 | 허용 default |

기준 해설:

- **자식별 차별화 필요** = GB/GD/GT 측 도메인별로 다른 plugin 구성·설정이 요구되는 영역. polyrepo는 자식 도메인 발산을 의식적으로 선택한 구조이므로(= L1-3), 차별화가 필요한 plugin은 그 발산을 plugin layer로 끌어들인다 → 회피.
- **커스텀 불필요 + 공식·공신력** = official marketplace(Anthropic 큐레이션) 또는 검증 통과 community plugin이면서, 5-repo 전부 동일 구성으로 충분한 영역 → 허용.
- 경계 판정이 모호한 영역 = 회피 측으로 분류(= 보수 default). 허용은 "공식 + 커스텀 불필요" 두 조건 동시 충족 시에만.

---

## §3. 단일 SoT 정합 (= L1-4 default)

- 본 file = plugin 판단 기준 유일 본문 default.
- A/B body(`cowork-project-instructions*.md`) + 4-자식 측 = 본 file pointer만 보유 default (= 판단 기준 본문 중복 금지). 기존 "Plugins paradigm 회피" 한 줄은 "조건부 회피 + plugin-policy.md pointer"로 정정 → cowork-role follow-up 영역 default (= 본 cycle scope 외 · cli 무접촉).
- 기준 변경 시 = 본 file 단일 변경 + 5-repo byte-identical propagation default (= 자식 측 본문 보유 X이므로 pointer 무변경).

---

## §4. subscription 정합 경계 (= A6 요금 폭탄 차단 default)

plugin 도입은 `cross-repo-parallel-exec.md §2.4` Subscription-aware paradigm을 깨지 않아야 한다.

- 허용 대상 plugin이 **영역 3**(= `claude -p` sub-process spawn / Agent SDK credit pool)을 유발하면 = 허용 불가 default (= 2026-06-15 Anthropic billing split 측 별 monthly credit pool + full API rate + roll over X · 요금 폭탄 risk).
- plugin이 interactive pool(= 영역 1 + 영역 2) 내에서 동작 = 정합 ✓.
- 판단 시점 = plugin이 자체적으로 sub-process spawn / 별 credit pool 호출을 트리거하는지 가용성 재확인 step(§5)에서 측정.

---

## §5. 발행·도입 전 절차 (= 가용성 재확인 + scope 경계 default)

1. **공식 가용성 재확인** = 도입 후보 plugin 선정 시점, official / community marketplace 측 실재 + 검증·안전 스크리닝 통과 여부 재측정 default (= `/plugin` Discover 탭 또는 claude.com/plugins 카탈로그 · 구체 marketplace/plugin 목록은 product 변동 영역이므로 발행 직전 재측정 권장).
2. **byte-identical 정합 측정**(§6) = 후보 plugin이 5-repo 동일 구성으로 충분한지 판정.
3. **subscription 경계 측정**(§4) = 영역 3 유발 여부 판정.
4. 3 측정 통과 시에만 허용 분류.

scope 경계 default: 본 file은 **정책 명문화 한정** default. "구체 plugin 실 도입/설치" 결정은 별 본심 영역 default (= 어떤 plugin을 실제 허용/도입할지는 사용자 본심 회수 의무 · §STOP 본심 분기 정합).

---

## §6. propagation 정합 (= 5-repo byte-identical 보존 default)

- cli infra(= `.claude/`)는 master 단방향 propagation + 5-repo byte-identical default (= master `CLAUDE.md §3` + `cross-repo-parallel-exec.md §4.3`).
- **자식별 차별화 plugin = byte-identical 위반** → §2 회피 측 분류 default. (자식마다 다른 plugin 구성은 `.claude/` byte-identical scope를 깨므로, 도입 자체가 propagation 단방향 원칙 위반.)
- 허용 plugin이 `.claude/settings.json` 등 propagation 대상 file을 변경하면 = master 변경 + propagate 경유 default (= 자식 직접 수정 금지 · master `CLAUDE.md §4`).

---

## §7. 인접 paradigm 정합

- master `CLAUDE.md §3 + §4` (= 단방향 propagation + 자식 직접 수정 금지 default)
- `cross-repo-parallel-exec.md §2.4` (= subscription-aware · 영역 3 회피 · A6 정합 default)
- `automation-policy.md` (= 동급 policy paradigm rule default)
- `mode-system.md` (= 동급 policy paradigm rule default)
- `anchor-list.md` (= L1-1 OPS 신설 예외 · L1-3 polyrepo · L1-4 단일 SoT · A6 subscription 정합 default)

---

## §8. cycle 이력

- 2026-05-30 · `MASTER-CLI-PLUGIN-POLICY-CONDITIONAL-001` · 본 file 신설 (= 전면 회피 → 조건부 전환 + 판단 기준 L1-3/L1-4 명문화) + 5-repo byte-identical propagation default
