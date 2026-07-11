# Automation policy (= Transport OK / Inspection X 원칙 default)

> 본 file = 6-repo 측 automation policy 영구 SoT default · 운반 자동화 OK + 검증 자동화 X 원칙 default
> 위치 = `claude-cli-master/docs/rules/automation-policy.md`
> 신설: `MASTER-CLI-CYCLE-3-AUTOMATION-POLICY-INSTALL-001` · 2026-05-22

---

## §1. 본질 (= 사용자 본심 정합 default)

### §1.1 원칙 1 — Transport 자동화 OK / Inspection 자동화 X

- **Transport** (= 운반 자동화 OK default) = propagation cycle + verify-sync 실행 + hook 발화 + sub-agent return 통합 + cli infra cp + sha 측정 명령 default · cli session 자율 default · 자동화 default
- **Inspection** (= 검증 자동화 X default) = disk 측 이미 구현 여부 측정 + paste source authoring disk verify + paste-back disk verify + runtime crash diagnosis + cross-repo cross-verify + REVIEW.md 12-section 판정 + Recommended option 최종 confirm default · 사용자 본심 회수 의무 또는 cowork chat 측 직접 disk read 의무 default

### §1.2 원칙 2 — 자동화 자리에 명시적 inspection checkpoint

자동화 영역 정착 시점 = 직후 calibration 강화 cycle 3~5 default (= `text-degeneration-prevention.md §3` + `cycle-discipline.md §19` Hooks self-improving loop paradigm 정합 default).

---

## §2. 영역 분류 표 (= 12 영역 default)

| # | 영역 | Transport (OK) | Inspection (X) | paradigm 본문 file |
|---|---|---|---|---|
| 1 | cli infra propagation | ✓ propagate.sh default | — | `cross-repo-parallel-exec-detail.md §4.3` + master `CLAUDE.md §3` |
| 2 | cli infra cross-verify | ✓ verify-sync.sh default | — | `cross-repo-parallel-exec-detail.md §4.2` |
| 3 | Hook 발화 | ✓ SessionStart/PreToolUse/PostToolUse/Stop default | — | `cycle-discipline.md §13 + §19` + `safety-and-secrets.md` |
| 4 | Sub-agent return 통합 | ✓ 4k token 압축 + 5-section schema default | — | `reporting.md §9` default |
| 5 | Disk 측 이미 구현 여부 측정 | — | ✓ 수동 의무 default | `recommended-option-disk-verification.md §2.1` |
| 6 | paste source authoring disk verify | — | ✓ cowork chat 측 수동 default | `paste-authoring-disk-verification.md §3` |
| 7 | paste-back disk verify | — | ✓ cli session 측 자율 default | `paste-authoring-disk-verification.md §4` |
| 8 | Runtime crash diagnosis | — | ✓ cli session 측 ADB + emulator + Logcat default | `runtime-crash-mitigation-process.md §3` |
| 9 | Cross-repo cross-verify | — | ✓ main agent 측 sub-agent verdict 비교 default | `cross-repo-parallel-exec-detail.md §4.1` |
| 10 | REVIEW.md 12-section 판정 | — | ✓ 수동 판정 default (= 블로커 1·2·3·4·6·9 default) | `reporting.md §7` |
| 11 | Recommended option 최종 confirm | — | ✓ 사용자 본심 회수 의무 default | `recommended-option-disk-verification.md §2.2` |
| 12 | git worktree 생성·정리 (= 영역 1.5 · 격리 대상/merge 판단 = Inspection 사람 영역) | ✓ worktree add / remove / list 명령 default | — | `cross-repo-parallel-exec-detail.md §2.1.5` |

---

## §3. Inspection cadence (= 4 cadence default)

| Cadence | 본문 |
|---|---|
| 매 cycle (= 진입 + 마감 default) | A1 baseline drift + A2 보호 file sha + A3 scope expansion + A5 disk verification default (= anchor-list.md 정합 default) |
| 매 5 cycle (= calibration 강화 default) | 자동화 신설 직후 3~5 cycle 측 false positive 측정 default |
| 분기 (= 1/6, 4/6, 7/6, 10/6 부근 첫 월요일 KST default) | `cycle-discipline.md §18` 정기 review cadence default |
| 변경 직후 (= 3~5 cycle 강화 default) | mode 시스템 신설 + anchor list 신설 + automation policy 신설 직후 default |

---

## §4. Sub-agent spawn 금지 (= B-5 정합 default)

본 automation paradigm 도입 시점 = sub-agent spawn 영역 신설 X 의무 default (= `cross-repo-parallel-exec-detail.md §3.4` Sub-agent token cost warning default · 49-subagent $8k~$15k / 23-subagent $47k/3d default). 신 sub-agent 신설 시점 = 본인 confirm 의무 default.

- 영역 1 (= 단일 cli session + sub-agent fan-out paradigm default) = 권장 sub-agent parallelism ≤ 3 default + chain unattended 회피 default + interactive pool 정합 default
- 영역 2 (= 다중 cli session 운영 default) = 권장 default · 사용자 본인 측 terminal × N 진입 default
- 영역 3 (= `claude -p` sub-process spawn default) = 회피 default · Bash deny list 정합 default

---

## §5. Cowork chat 측 disk 직접 read 의무 (= cli 자기 보고 우회 default)

본 paradigm 측 cowork chat 측 cli 자기 보고 우회 default (= `paste-back disk verify` 영역 default · `paste-authoring-disk-verification.md §3` 정합 default). cli session 측 paste-back PASS 보고 측 cowork chat 측 disk 직접 read + cross-verify 의무 default · 매 cycle 마감 default.

---

## §6. 인접 paradigm 정합

- `cross-repo-parallel-exec.md §2.4`(kernel) + `cross-repo-parallel-exec-detail.md §3.4` (= subscription-aware + sub-agent token cost warning default)
- `recommended-option-disk-verification.md` (= disk 측정 의무 default)
- `paste-authoring-disk-verification.md` (= paste source authoring disk verify default)
- `runtime-crash-mitigation-process.md` (= cli session 측 ADB + emulator + Logcat default)
- `reporting.md §7 + §9` (= REVIEW.md 12-section + Subagent Return Contract default)
- `anchor-list.md` (= A1 + A4 + A5 + A6 + A10 정합 default)

---

## §7. cycle 이력

- 2026-05-22 · `MASTER-CLI-CYCLE-3-AUTOMATION-POLICY-INSTALL-001` · 본 file 신설 + `cycle-discipline.md §28` pointer 신설 + 5-repo byte-identical propagation default
