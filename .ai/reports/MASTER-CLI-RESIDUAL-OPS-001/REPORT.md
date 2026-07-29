# MASTER-CLI-RESIDUAL-OPS-001 — REPORT

> Mode **M5** (CLI 운영 레이어형) · 2026-07-29 KST · contract = `cc-paste-MASTER-CLI-RESIDUAL-OPS-001.md`
> 본질 = DIET-3 마감 후 **잔여 운영 4건**(①PAT rotation 마무리 · ②archiver plist 실반영 · ⑤wrap 사본 정합 · ⑧nightly 실측) 일괄.
> production **0 LOC** · 보호 5 sha **불변** · 자식 3 파일·커밋 **0** · 동결 3 **무접촉** · cli infra(`.claude/**`) **무변경**.

---

## [EVIDENCE] §0 baseline (진입 재측정)

| 항목 | 기대 | 실측 | 판정 |
|---|---|---|---|
| master HEAD | `83eb2c60be92` | `83eb2c60be9244461aff306306391295b32d1189` | ✓ 일치 |
| ahead | 15 (push 대기) | `## main...origin/main [ahead 15]` | ✓ |
| 보호 5 git-sha1 | `8b46bb4952be`·`68c6c213b18e`·`ce9c0d3e5453`·`7e70e365bb30`·`0d265e0bbc6f` | 5/5 동일 | ✓ **drift 0** (STOP #5 미발동) |
| 진입 dirty | — | `.auto-memory/propagation-status.md` 1건 (timestamp 행 단독) | pre-existing 허용 노이즈 |

A1(baseline drift) · A2(보호 file integrity) 충족. 대상 실물 = **repo 밖 2** + Keychain slot 메타 + launchd 상태.

---

## ① PAT rotation 상태 실측 + 마무리 — **완료**

### 배경 (미결 인계)

`MASTER-CLI-STALE-SWEEP-4ACTIVE-001` §사고 1 = cli 측 검증 harness 가 `${n:-UNSET}` 을 써 마스킹 의도와 정반대로 값을 출력 → `SUPABASE_ACCESS_TOKEN_{SELFWARD,GB,GD,GT}` **4종 전량** 세션 transcript 노출. 디스크 기록 0 확증됨. 잔여 = **Coin rotation 회수**.

### mdat 4종 판정표 (값 무접촉 · `-w` 미사용 = 메타만)

| slot | 진입 시 cdat / mdat | 판정 | 조치 후 |
|---|---|---|---|
| `supabase-selfward-token` | 20260715053556Z / **20260715054629Z** | < 07-29 → 미완 | **mdat `20260729091350Z`** (cdat 07-15 유지 = `-U` update 정상) ✓ |
| `supabase-gb-token` | 20260518082702Z / 20260518082702Z | < 07-29 → 미완 | **MISS (slot 폐기)** ✓ |
| `supabase-gd-token` | 20260518082811Z / 20260518082811Z | < 07-29 → 미완 | **MISS (slot 폐기)** ✓ |
| `supabase-gt-token` | 20260518082820Z / 20260518082820Z | < 07-29 → 미완 | **MISS (slot 폐기)** ✓ |

진입 판정 = **0/4 rotation 미완** → paste §2①-3 (Coin 유도) 분기 발동.

### 범위 결정 (STOP #9 · 사용자 본심 회수)

paste 기본안은 4 slot 전량 재발급이었으나, 실측상 `.mcp.json` = `supabase-selfward` **단독 등록**(동결 3 = DIET-3 에서 등록 해제 = 미소비) + wrap = warn+skip(= slot 부재여도 기동 영향 0) 이었다. 4종 재발급 / 활성1+동결3폐기 / 활성1만 은 Coin 이 콘솔·터미널에서 하는 일이 서로 달라 AskUserQuestion 회수.

→ **Coin 확정 = 「활성 1 재발급 + 동결 3 revoke 폐기」**. wrap 주석의 문서화된 의도("slot 정리는 Coin 판단 · 재조회 필요 시 = Coin 회수")와 일치.

### 실행 (cli 는 대기 · 값 접촉 0)

- **Coin 브라우저**: Supabase 콘솔 Account → Access Tokens · selfward 구 토큰 revoke + 신규 발급 / GB·GD·GT 구 토큰 3종 revoke
- **Coin 별도 터미널**(이 세션 아님): `security add-generic-password -U -a "$USER" -s supabase-selfward-token -w` (값 인자 없이 = hidden prompt) + `security delete-generic-password -a "$USER" -s supabase-{gb,gd,gt}-token` ×3 + `pbcopy < /dev/null`

### 검증 (값 미출력)

```
SUPABASE_ACCESS_TOKEN="$(security find-generic-password -s supabase-selfward-token -a "$USER" -w 2>/dev/null)" \
  supabase projects list > /dev/null 2>&1; echo "exit=$?"
→ supabase projects list exit=0
```

**exit 0 = 신 토큰 유효 확정.** Keychain 직접 판독으로 검증 — 현 세션 env 는 wrap 기동 시점의 **구** 토큰을 들고 있어 그대로 쓰면 paste §2①-4 의 "구 토큰 사용 시도 금지"에 저촉되기 때문. 값 노출 경로: stdout/stderr 전량 억제 · 변수 echo 0 · `set -x` off · `${v:-UNSET}` 류 harness 0.

**노출 4종 = 전량 무효화 완료** (활성 1 = 교체 · 동결 3 = revoke + slot 폐기).

---

## ② archiver plist 실반영 — **완료** (유일한 실 변경)

미반영 확정 근거: 설치본 `1192B · May 5 13:57` vs repo SoT `1201B · Jul 29 15:31` (= STALE-SWEEP 이 repo 만 고치고 실반영이 빠져 있었음).

### [DIFF] 실사본 (1행)

```
-  for r in .../AndroidStudioProjects .../claude-cli-master .../GentlyBreath .../GentlyDay .../GentlyTable; do ...
+  for r in .../AndroidStudioProjects .../claude-cli-master .../app-foundation .../gently-product-docs .../Selfward; do ...
```

### 집행

`cp scripts/com.coin.working-file-archiver.plist ~/Library/LaunchAgents/` → `launchctl unload` (rc=0) → `launchctl load` (rc=0)

### 검증 수치

| 검증 | 기대 | 실측 |
|---|---|---|
| `launchctl list \| grep -c archiver` | 1 | **1** (`- 0 com.coin.working-file-archiver`) |
| 실사본 `grep -c 'GentlyBreath\|GentlyDay\|GentlyTable'` | 0 | **0** (이전 1) |
| 실사본 `grep -c Selfward` | 1 | **1** (이전 0) |
| 실사본 app-foundation / gently-product-docs | — | **1 / 1** (4-active 전량) |
| repo SoT 대비 byte parity | — | `diff` rc=0 **IDENTICAL** |
| 타 LaunchAgents 5종 mtime | 불변 | **전량 원본 유지 = 무접촉** (STOP B 준수) |

**효과: 매일 03:00 동결 3(GB/GD/GT) 쓰기가 오늘부로 정지.** 동결 = 쓰기 0 규약(master `CLAUDE.md §1.3` · `stop-canonical.md`)의 실행 층 정합 완료.

---

## ⑤ wrap 사본 이원화 — **DIET-3 가 이미 해소 · 검증만 (변경 0)**

### 실사용 판 확정 근거

- `~/.zshrc:17` = `alias claude="$HOME/bin/claude-wrap.sh"` → **실사용 판 = `~/bin/claude-wrap.sh`** (`-rwxr-xr-x` 3347B)
- `which claude-wrap.sh` = not found → 부모root 판(`~/AndroidStudioProjects/claude-wrap.sh` · `-rw-r--r--` 4221B)은 **PATH 밖 · 어떤 alias 도 미참조**
- `find ~/AndroidStudioProjects -maxdepth 3 -name 'claude-wrap*.sh'` = 1건 (부모root 단독) → 사본 총 2 확정

### diff 요약

`diff <(tail -n +15 부모root) <(tail -n +2 실사용)` → **rc=0 · BODY IDENTICAL**. 부모root = 실사용 판 = shebang(L1) + **13행 SoT 배너(L2-14)** 삽입뿐, 본문 divergence **0**.

배너가 `실사용 SoT = ~/bin/claude-wrap.sh` · `본 file = 사본 · 실행 대상 아님` · `수정 금지 — ~/bin 을 고치고 본 사본을 다시 찍는다` 를 명시 → paste §2⑤-2 의 헤더 요구 **충족**. 배너는 사본 측에만 있어야 옳고(SoT 본체에 "본 file = 사본" 이 붙으면 역전), 실측이 그 형태.

### paste §3 서술 stale 정정

paste §3 = "부모root `claude-wrap.sh` = 구판 실측(slot 3 · selfward 0 · `exit 1` fail-fast · 07-29 cowork 측정)". **실측상 stale** — cowork 측정 이후 `MASTER-CLI-CONTEXT-DIET-3-001` §2-I 가 부모root 를 이미 재생성했다(양쪽 mtime Jul 29 16:45 · 배너 L11 이 그 cycle 을 자칭).

| 지표 | 실사용 | 부모root |
|---|---|---|
| slot 선언 | 5 | 5 |
| selfward(ci) | 3 | 3 |
| 실코드 `exit 1` (주석 제외) | **0** | **0** (매치 2/3 = 전부 주석) |
| skip/warn | 7 | 7 |
| `${v:-UNSET}` 안티패턴 | **0** | **0** |
| 시크릿 패턴 hit | **0** | **0** |

→ 양쪽 모두 **4-slot · warn+skip 판**. ⑤ 는 검증 통과, **파일 변경 0**.

---

## ⑧ nightly-baseline-report.sh 실측 — **보고만 · 변경 0** (STOP C 준수)

| 항목 | 실측 |
|---|---|
| launchd 등재 | `com.coin.nightly-baseline-report` (`launchctl list` 확인) · plist `1646B · May 14 16:47` |
| 스케줄 | `StartCalendarInterval` Hour **4** / Minute 0 = **매일 04:00** |
| `claude -p` 호출부 | `scripts/nightly-baseline-report.sh:306-313` |
| 호출 flag | `-p` · `--setting-sources ""` · `--tools ""`(도구 전량 비활성) · `--no-session-persistence` · `--output-format text` · **`--max-budget-usd 0.50`** |
| 실행 이력 | 2026-05-14 ~ 2026-07-29 · dated report **77** · `nightly.log` done **80** = 사실상 매일 |
| **성공률** | `claude_exit=0` **44 / 80 (55%)** · `claude_exit=1` **36** · exit=127 **0** |
| **최근 열화** | 최근 30회 중 exit=0 = **7 (23%)** → 초기 정상 · 최근 **77% 실패** |
| 실패 원인 | `API Error: Connection closed mid-response.` = **예산 초과 아님 · 응답 중도 절단** |
| FALLBACK 산출물 | **36 / 77** (LLM 포맷팅 없이 raw 측정치 박제) |
| **월 상한 추정** | $0.50 × 30 = **$15.00/월** (실 소비는 절단 시점까지 과금) |

### 보고 3건 (결정 = Coin 본심 대기)

1. **A6 anchor 정합 긴장** — `claude -p` = 영역 3(Agent SDK credit pool · full API rate · roll over X · 회피 default). A6 의 측정 지표는 `claude -p` spawn `= 0` 인데 nightly 가 매일 1회 호출 중. 규정 위반이라기보다 **cli session 자율 spawn 금지**와 **Coin 이 세운 launchd 상시 작업**이 같은 표면을 공유하는 구조 — 어느 쪽으로 정리할지가 본심 영역. (※ A6 의 "2026-06-15 billing split" 근거는 `anchor-list.md` 주석대로 **UNVERIFIED**, 행동 규정만 불변.)
2. **최근 77% = 지불하되 부가가치 0** — 절단이어도 그 시점까지 토큰은 과금되고 산출물은 fallback. 비용 대비 효용이 최근 구간에서 무너져 있음.
3. **`verify_sync_exit=1` 전 이력 100% = 버그 아님** (본 cycle 확증) — 직접 실행 결과 `PASS 160 / DRIFT 2 / MISS 6` = pre-existing 미해소분(release-checklist P4-lazy DRIFT 2 + CHARTER·production-cli-access-tokens master-only MISS 6)을 FAIL 로 정확히 보고 중. **nightly 는 정상 동작**이며, 지워야 할 것은 pre-existing drift 쪽.

nightly 동작 **무변경** (STOP C = scope expansion 차단 준수).

---

## [LOG] 부수 검증

- **verify-sync**: `PASS 160 / DRIFT 2 / MISS 6` = `MASTER-T7` · `STALE-SWEEP` post-state 동일 → **신규 drift 0 · STOP #6 미발동 · A4 정합**. DRIFT 2 = `release-checklist.template.md` FND/PDOCS(P4-lazy 의도적 미전파 · Selfward=✓) · MISS 6 = master-only 2 file × 3 자식.
- **stale ref 6건** (`protected-file-hashes.md` 5 + `propagation-status.md` 1 = `check-abbreviation.sh` · `abbreviation-policy.md` · `code-principles.md` · `design-to-code-sync.md` · `domain-roles.md` · `workflow-core.md`) = `JUDGMENT-SHIFT-001` 제거분 + `DIET-2-003` 의 `docs/rules/` 이전 미반영 경로. **pre-existing · 본 cycle scope 밖 · 후속 회부**.
- **propagation**: cli infra(`.claude/**`)·`docs/schemas/**` 변경 **0** → propagate 미실행이 정상. edit-set = `.ai/reports/**` + `.auto-memory/**` = propagation scan set 밖.
- **dirty**: `.auto-memory/propagation-status.md` = verify-sync 가 timestamp 1행 갱신(pass/drift/miss 수치 불변).

## §15 미기입 판단 (투명 보고 · Coin 뒤집기 가능)

master `CLAUDE.md §16-1` 의 §15 entry 의무는 "**cli infra 변경**"에 걸린다. 본 cycle 은 `.claude/**` · `docs/schemas/**` · 보호 5 **전부 무변경**이고, 실 변경은 repo **밖**(launchd 실사본 · Keychain slot)이다. 또 `MASTER-CLI-CONTEXT-DIET-3-001` 이 §15 를 **hot 3 entry 상한**으로 조인 직후라, cli infra 0 변경 cycle 이 슬롯 하나를 태워 `STALE-SWEEP`(대형 cycle)을 COLD 로 밀어내는 것은 상한 규약의 취지에 역행한다.

→ **§15 미기입 · 이력은 본 REPORT + `.auto-memory/incident-log.md` 종결 entry 에 보존**(감사 추적 손실 0). Coin 이 기입을 원하면 demote 1건과 함께 별 cycle 로 처리.

## Negative Space Line

고려했으나 hot 제외 영역: ⑧ nightly 동작 변경(= STOP C · 보고만) · `Bash(*tmp*)` deny 완화(= 본심 대기 · 본 cycle 에서 scratchpad 경유 1회 차단 실측) · 상주 본문 추가 다이어트(= 본심 대기) · verify-sync stale ref 6 정정(= pre-existing 후속) · release-checklist DRIFT 2 / CHARTER MISS 6 reconcile(= P4-lazy 의도적) · `.mcp.json` 동결 3 재등록(= 동결 = 상시 배선 대상 아님) · §15 entry 기입(= 위 판단).
