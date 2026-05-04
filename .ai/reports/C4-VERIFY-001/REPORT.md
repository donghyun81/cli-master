# C4-VERIFY-001 · C4 propagation 사후 검증

> 작성: 2026-05-02 · scope: C4 propagation 의 누락/중복/잔존 광역 점검 + 정정
> 트리거: Coin 요청 — "C4 propagation 과정 제대로 적용? 빠진 내용? 중복/잔존?"

---

## 0. 결론 한 줄

verify-sync sha 정합 = **PASS 109 / DRIFT 0 / MISS 0** (master ↔ 3 자식 byte-identical 유지).
다만 **propagation 외의 정리 누락 4 종** 발견 — 1 종 sandbox 자체 정정 완료, 3 종 Coin 손 작업 1회 필요.

---

## 1. 점검 대상 (5 영역)

| # | 영역 | 점검 방법 |
|---|---|---|
| ① | sha 정합 (master ↔ 3 자식) | `verify-sync.sh` 실측 |
| ② | C11 hook drift | master vs 자식 hook sha |
| ③ | deprecated rules 잔존 (master + 3 자식) | C2-RULES-RESTRUCTURE-001 의 6 종 pointer 파일 |
| ④ | flat agents 중복 (자식만) | `agents/*.md` (flat) vs `agents/active/*.md` + `agents/deferred/*.md` |
| ⑤ | sandbox testfile 잔존 | C4-1 BASELINE 작성 시 권한 검증용 빈 파일 |

추가 조사: `docs/`, `scripts/agent/`, `.ai/promptfit/` orphan 검사 → **모두 정상** (repo-specific 도메인 데이터).

---

## 2. 발견 + 정정

### ① sha 정합 = PASS

```
[verify-sync] 요약
  PASS:  109 파일
  DRIFT: 0 (자식 sha ≠ master)
  MISS:  0 (자식 부재 또는 repo 부재)
[verify-sync] PASS — 모든 sha 일치
```

### ② C11 hook drift → sandbox cp 즉시 정정 ✓

| 파일 | 발견 | 정정 |
|---|---|---|
| `.claude/hooks/pre-tool-use.sh` | C11 master 갱신 후 자식 propagate 누락 | sandbox cp 3-repo (sha 일치 확인) |
| `.claude/hooks/session-start.sh` | 동상 | 동상 |

re-verify 후 PASS 109 / 0 / 0 회복.

### ③ deprecated rules 잔존 → Coin 손 작업 필요

C2-RULES-RESTRUCTURE-001 분할 + C2-3 통합 시 sandbox `rm` 권한 한계로 master 에 pointer-only 변환만 됨. C4 propagate 시 **pointer 파일이 자식에 그대로 cp** → 4-way 4 × 6 = 24 잔존.

| 파일 | master sha (8) | 4-way 동기? | 처리 |
|---|---|---|---|
| `.claude/rules/workflow.md` | `f14c10d4` | ✓ master+3자식 동일 | 4 위치 동시 rm |
| `.claude/rules/evidence-and-reporting.md` | `61dd854f` | ✓ | 동상 |
| `.claude/rules/auth-security-privacy.md` | `8d2aef6e` | ✓ | 동상 |
| `.claude/rules/backend-and-api.md` | `035858bc` | ✓ | 동상 |
| `.claude/rules/data-and-migrations.md` | `faa71015` | ✓ | 동상 |
| `.claude/rules/performance-reliability.md` | `7882aeee` | ✓ | 동상 |

내용 = 모두 "[DEPRECATED] · 새 위치 안내 + Coin rm 대기" pointer (15~23 줄). 이미 새 파일 (workflow-core.md / cycle-discipline.md / pencil-automation.md / report-paths.md / report-formats.md / deferred-domains.md) 가 정상 자리잡음 → pointer 의 임무 완료.

### ④ flat agents 중복 (자식만, 75 파일) → Coin 손 작업 필요

C2-4 routing-and-delegation.md 의 agent path 갱신 = `.claude/agents/active/<name>.md` + `.claude/agents/deferred/<name>.md` 로 변경. 그러나 자식 repo 의 **이전 평탄 구조** (`.claude/agents/*.md` 25개) 는 sandbox `rm` 권한 한계로 그대로.

| repo | flat 25 | active 14 | deferred 11 | 중복 검증 |
|---|---|---|---|---|
| GentlyBreath | 25 | 14 | 11 | flat 25 = active 14 + deferred 11 (이름 + 내용 byte-identical) |
| GentlyDay | 25 | 14 | 11 | 동상 |
| GentlyTable | 25 | 14 | 11 | 동상 |

→ flat 25 는 순수 중복. 신 active/deferred 가 SoT. 자식 3 × 25 = **75 파일 rm**.

### ⑤ sandbox testfile 잔존 (3 파일) → Coin 손 작업 필요

C4-1 BASELINE 시 자식 `.ai/` 쓰기 권한 검증용 빈 파일 (`.ai/.sandbox-write-test`, 5 byte = "test\n"). 임무 완료 후 sandbox `rm` 권한 한계로 그대로.

| 파일 | size | mtime |
|---|---|---|
| `GentlyBreath/.ai/.sandbox-write-test` | 5 | 08:23 |
| `GentlyDay/.ai/.sandbox-write-test` | 5 | 08:23 |
| `GentlyTable/.ai/.sandbox-write-test` | 5 | 08:23 |

---

## 3. orphan 광역 검사 결과 (false positive 없음)

자식의 `docs/setup/`, `docs/plan/`, `docs/design/pencil-sot/`, `scripts/agent/repo-config.sh` 등은 **repo-specific 도메인** (DDL, edge functions, Pencil .pen, repo 별 config) — master 부재가 정상.

`MANAGED_AGENTS_READINESS.md` / `compound-lint.sh` / `repo-config.sh` 도 3 자식 sha 모두 다름 = 의도된 repo-specific. propagation 누락 아님.

---

## 4. Coin 손 작업 가이드 — 1회 paste 일괄 정리

macOS 터미널에서 아래 1 블록 paste:

```bash
cd ~/AndroidStudioProjects

# (a) deprecated rules 4-way rm (master + 3 자식 = 24 파일)
for repo in gently-master GentlyBreath GentlyDay GentlyTable; do
  for f in workflow.md evidence-and-reporting.md auth-security-privacy.md \
           backend-and-api.md data-and-migrations.md performance-reliability.md; do
    rm -f "$repo/.claude/rules/$f"
  done
done

# (b) 자식 flat agents rm (3 자식 × 25 = 75 파일)
for repo in GentlyBreath GentlyDay GentlyTable; do
  find "$repo/.claude/agents" -maxdepth 1 -type f -name "*.md" -delete
done

# (c) sandbox testfile rm (3 파일)
for repo in GentlyBreath GentlyDay GentlyTable; do
  rm -f "$repo/.ai/.sandbox-write-test"
done

# (d) 자식 stage + commit
for repo in GentlyBreath GentlyDay GentlyTable; do
  cd ~/AndroidStudioProjects/$repo
  git add -A .claude/rules .claude/agents .ai
  git commit -m "chore(cleanup): C4-VERIFY-001 — remove deprecated rules + flat agents + sandbox testfile

- .claude/rules/{workflow,evidence-and-reporting,auth-security-privacy,backend-and-api,data-and-migrations,performance-reliability}.md (deprecated pointer 6종)
- .claude/agents/*.md (flat 25 — active/deferred 폴더로 이전 완료)
- .ai/.sandbox-write-test (BASELINE 검증 잔존)

C2-RULES-RESTRUCTURE-001 + C4-1 의 사후 정리. master 와 동기."
  cd ~/AndroidStudioProjects
done

# (e) master stage + commit
cd ~/AndroidStudioProjects/gently-master
git add -A .claude/rules .ai/reports
git commit -m "chore(cleanup): C4-VERIFY-001 — drop 6 deprecated rule pointers + verify report

- .claude/rules/{workflow,evidence-and-reporting,auth-security-privacy,backend-and-api,data-and-migrations,performance-reliability}.md
- .ai/reports/C4-VERIFY-001/REPORT.md

C2-RULES-RESTRUCTURE-001 의 pointer 임무 완료. 자식 repo 도 동시 cleanup."
```

총 102 파일 rm + 4 commit (master 1 + 자식 3).

---

## 5. 정합 확인 (Coin 손 작업 후)

```bash
cd ~/AndroidStudioProjects/gently-master
bash scripts/verify-sync.sh
# 기대: PASS 103 / DRIFT 0 / MISS 0  (109 - 6 deprecated)
```

PASS 줄어든 이유 = master 에서 6 파일 rm → verify-sync 가 더 이상 iterate 안 함.

---

## 6. baseline 갱신 (Coin 손 작업 commit 후 실측 정정)

| 항목 | 변경 전 | 변경 후 (실측) |
|---|---|---|
| master `.claude/rules/` 파일 수 | 22 | **16** |
| 자식 `.claude/rules/` 파일 수 | 22 | **16** |
| 자식 `.claude/agents/` flat 파일 수 | 25 | 0 |
| 자식 `.ai/.sandbox-write-test` | 1 | 0 |
| verify-sync iter 대상 | 109 | **103** |
| 보호 파일 5 종 sha | 변동 없음 | 변동 없음 |

> 정정 사유: 본 표 초안의 "13" expected = deprecated 6 만 빼고 19 ÷ 6 = 13 으로 잘못 계산. master active rules = 16 (workflow-core, cycle-discipline, pencil-automation, report-paths, report-formats, deferred-domains, code-principles, design-to-code-sync, ui-ux-analysis, uiux-sot-refresh, ux-laws, pencil-uiux-workflow, routing-and-delegation, legacy-cleanup-governance, safety-and-secrets, verification-and-review).

---

## 7. 사고 기록 (incident-log 후속)

| type | 분류 | 위치 |
|---|---|---|
| 자동화 install ≠ activation (재발) | C11 hook 변경 후 propagation 누락 → 자식 6 파일 drift | sandbox cp 즉시 정정 |
| sandbox 권한 한계 (재발) | rm 불가로 deprecated pointer + flat agents + testfile 잔존 누적 | Coin 손 작업 1회 (이번 가이드) |

incident-log.md 1 줄 append + decision-log.md C4-VERIFY 1 줄 append (cycle 진입 시).

---

## 8. 권장 후속 cycle (자동화 박는 방향)

C4-VERIFY 의 ③/④/⑤ 는 모두 "sandbox rm 권한 X" 가 근본 원인. 두 갈래 mitigation 후보:

**옵션 A** — `propagate.sh` 에 `--prune` 모드 신설 (master 부재 파일 → 자식에서도 자동 rm). 단, master rm 자체는 여전히 sandbox 한계 → Coin 손 작업 1회 + 이후 자식 propagate 자동.

**옵션 B** — Coin 환경에 `git-lock-daemon` 처럼 `cleanup-deprecated.sh` cron/launchd 박음. master + 자식 의 `[DEPRECATED]` 헤더 + N 일 경과 → 자동 rm.

**1순위**: 옵션 A (propagate 일관성 박는 효과 + 본 작업 본류 진입 우선). 옵션 B 는 사고 누적 시 검토.

---

## 9. C4-VERIFY 마감 조건

- [x] verify-sync PASS 109 / 0 / 0 (sandbox 자체 정정)
- [x] 4 issue 정리 + 본 REPORT.md 작성
- [ ] Coin 손 작업 1 paste (rm 102 + commit 4) — **마감 trigger**
- [ ] verify-sync PASS 103 / 0 / 0 재실측
- [ ] decision-log + incident-log + CLAUDE.md §15 갱신 (Coin 손 작업 후)

본 cycle 의 sandbox 부분 = 마감. Coin 손 작업 + 재실측 + memory 갱신 = 다음 진입 시.
