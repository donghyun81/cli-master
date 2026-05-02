# C4-PROPAGATE-TO-CHILDREN-001-PROPAGATE · 결과

> 작성: 2026-05-02 · scope: master → GB/GD/GT 단방향 propagation + cross-verify
> 상태: sandbox cp + 마이그레이션 + Nested 박음 완료 · git stage / commit 만 Coin 손 작업 분리

---

## 1. cp 결과

| 자식 repo | cp 파일 수 |
|---|---|
| GentlyBreath | 109 |
| GentlyDay | 109 |
| GentlyTable | 109 |
| **합계** | **327 파일** |

cp 에러: **0**

---

## 2. cross-verify (verify-sync.sh)

```
[verify-sync] 3-repo sha 동기 검증
  master:  /Users/yundonghyeon/AndroidStudioProjects/gently-master
  targets: GentlyBreath GentlyDay GentlyTable
  files:   109 (전체)

[verify-sync] 요약
  PASS:  109 파일
  DRIFT: 0
  MISS:  0

[verify-sync] PASS — 모든 sha 일치
exit: 0
```

→ **ALL ✓ MATCH PASS**.

---

## 3. ui-spec.json 마이그레이션 (44 파일)

| 자식 | 마이그레이션 |
|---|---|
| GB | 16 / 16 |
| GD | 13 / 13 |
| GT | 15 / 15 |

각 ui-spec.json 에 다음 박음:
- `lastSyncedDesignToolStateHash` 신설 (값 = `lastSyncedPencilStateHash` alias 보존)
- `designTool: "pencil"` 신설

기존 `lastSyncedPencilStateHash` = v0.3 deprecated alias 로 유지.

---

## 4. Nested CLAUDE.md 박음 (3 자식)

각 자식 CLAUDE.md 첫 5~10 줄 박음:
```markdown
> **이 repo 는 multi-repo 자식**. cli infra + 보호 파일 + 공통 가이드 = master (claude-cli-master) SoT 단방향 propagation.
> **공통 SoT 진입 의무 reading order**:
>   1. ../claude-cli-master/CLAUDE.md
>   2. ../claude-cli-master/docs/guides/app-implementation-guide.md
>   3. ../claude-cli-master/docs/agent/architecture/COMMON_ARCHITECTURE.md
>   4. **본 CLAUDE.md**
> **자식 cli infra 직접 수정 금지** — drift 발견 시 즉시 STOP + master 정정 cycle 신설.
> **신규 도메인 작성** = master `docs/templates/<type>.template.md` cp 후 채움.
```

---

## 5. Coin 손 작업 (sandbox 한계 → macOS 환경 의무)

### Step 0: 자식 stale .git/index.lock rm (sandbox rm 권한 X)

```bash
rm -f ~/AndroidStudioProjects/GentlyBreath/.git/index.lock
rm -f ~/AndroidStudioProjects/GentlyDay/.git/index.lock
rm -f ~/AndroidStudioProjects/GentlyTable/.git/index.lock
```

### Step 1: launchd 데몬 install (1회 · 영구 mitigation · C10 박힘)

```bash
bash ~/AndroidStudioProjects/claude-cli-master/scripts/install-git-lock-daemon.sh
```

→ install 후 자식 lock 사고 자동 5초 안 정리.

### Step 2: 자식 repo 별 git add + commit (3 회 또는 한 번에)

```bash
for repo in GentlyBreath GentlyDay GentlyTable; do
  cd ~/AndroidStudioProjects/$repo
  git add -A
  git commit -m "$(cat <<'COMMIT'
chore(cli-infra): C4-PROPAGATE-TO-CHILDREN-001 master cli infra propagation 적용

[Goal] master (claude-cli-master) → 본 repo 단방향 propagation · 109 파일 sha 일치 + ui-spec.json 16/13/15 마이그레이션 + Nested CLAUDE.md 박음
[Diff] +/~109 cli infra (rules + agents + commands + hooks + skills + settings + docs/{agent,design,schemas,guides,templates,backend} + scripts/agent + root 5) + ui-spec.json 마이그레이션 + CLAUDE.md 첫 5줄 Nested 박음
[Sha]  보호 5종 sha = master baseline byte-identical:
       5aa52b23 ui-spec.schema.json v0.3
       1f871447 uiux-sot-refresh.md
       e5e3fe16 design-sot-policy.md
       6297080a pencil-uiux-workflow.md
       96de2f5d pencil-sot-policy.md
[EC]   verify-sync.sh exit 0 · 109 파일 PASS · drift 0 · miss 0
[Next] 자식 repo 의 본 작업 cycle (Pencil → Compose 파이프라인) 진행 시 본 cli infra 따름
[Refs] master cycle: C4-PROPAGATE-TO-CHILDREN-001 · cli infra 직접 수정 금지 (drift 시 master 정정 cycle 의무)
COMMIT
)"
done
```

### Step 3: master audit commit

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
git add -A && \
git commit -m "$(cat <<'COMMIT'
chore(master): C4-PROPAGATE-TO-CHILDREN-001 audit (3 자식 propagation 마감)

[Goal] master → GB/GD/GT 단방향 propagation cycle 마감 audit
[Diff] propagation-status.md (보호 5종 ALL MATCH) + propagation-reports/C4-...-PROPAGATE/REPORT.md + .ai/reports/C4-...-PROPAGATE-TO-CHILDREN-001/REPORT.md + decision-log/CLAUDE.md §15
[Sha]  보호 5종 변동 0 (C2.5 baseline 보존)
[EC]   verify-sync.sh exit 0 · 109 파일 PASS · 자식 ui-spec.json 44 마이그레이션 + Nested CLAUDE.md 박음
[Next] 자식 repo 의 도메인 cycle 진행 시 master cli infra 자동 적용
[Refs] task: C4-PROPAGATE-TO-CHILDREN-001 · 자식 commit hash: <fill in after step 2>
COMMIT
)"
```

---

## 6. 마감 신호

- ✓ master → 3 자식 cp 327 파일 (에러 0)
- ✓ verify-sync.sh exit 0 (PASS 109 / DRIFT 0 / MISS 0)
- ✓ ui-spec.json 마이그레이션 44 파일 (alias + designTool 신설)
- ✓ 자식 CLAUDE.md Nested 박음 (3 자식)
- ⏳ 자식 stale lock rm + commit + audit (Coin Step 0~3 의무)

→ Coin Step 0~3 완료 후 = master ↔ 자식 단방향 정합 100%.
