# C11-LOCK-WIDE-COVERAGE-001 · .git/**/*.lock 광역 mitigation

> 작성: 2026-05-02 · scope: C10 한계 RCA + 4 layer 광역 강화

---

## 0. RCA — git lock 종류 다양

C10 박힌 mitigation (daemon + 2 hooks + wrapper) = `.git/index.lock` **만** 처리.

git 의 lock 종류:
| lock 파일 | 발생 시점 |
|---|---|
| `.git/index.lock` | `git add` / index 갱신 |
| **`.git/HEAD.lock`** | **`git commit` / `git checkout` / HEAD ref 갱신** |
| `.git/packed-refs.lock` | `git pack-refs` |
| `.git/config.lock` | `git config <key>` |
| `.git/refs/heads/<branch>.lock` | branch ref 갱신 |
| `.git/refs/tags/<tag>.lock` | tag 생성 |
| `.git/refs/remotes/<remote>/<branch>.lock` | remote ref 갱신 |

→ **GT commit 시 HEAD.lock 박힘 + sandbox crash + stale 잔존 = commit 차단** (사용자 보고 사고).

---

## 1. C11 mitigation = 4 layer 광역 강화

모든 4 layer 가 동일 PID 검증 patterns 으로 **모든 .git/**/*.lock** 처리:

```
1. .git/index.lock
2. .git/HEAD.lock
3. .git/packed-refs.lock
4. .git/config.lock
5. find .git/refs -name "*.lock" -type f
6. .git/*.lock (catch-all · ORIG_HEAD.lock 등)
```

각 lock 별 **PID 죽음 = 즉시 rm / 살아있음 = 보호 / PID 박힘 X = mtime 보조**.

---

## 2. 산출물 inventory (C11 · 4 강화 + 4 doc)

| 파일 | 변경 |
|---|---|
| `scripts/git-lock-daemon.sh` | ~ 광역 (index + HEAD + packed-refs + config + refs/**/*.lock + misc) |
| `.claude/hooks/pre-tool-use.sh` | ~ 광역 (git command 감지 시) |
| `.claude/hooks/session-start.sh` | ~ 광역 (세션 시작 시) |
| `scripts/git-safe.sh` | ~ 광역 (wrapper 호출 시) |
| `.auto-memory/incident-log.md` | + C11 entry |
| `.auto-memory/decision-log.md` | + C11 entry |
| `CLAUDE.md` §15 | + C11 row |
| `.ai/reports/C11-...` | ★ 신설 본 파일 |

---

## 3. Coin 손 작업 (즉시 사고 해결 + 영구 mitigation)

### Step 0: 즉시 사고 해결 (현 GT commit 차단 정리)

```bash
# 모든 자식 repo + master 의 광역 stale lock 정리
rm -f ~/AndroidStudioProjects/*/.git/index.lock
rm -f ~/AndroidStudioProjects/*/.git/HEAD.lock
rm -f ~/AndroidStudioProjects/*/.git/packed-refs.lock
rm -f ~/AndroidStudioProjects/*/.git/config.lock
find ~/AndroidStudioProjects/*/.git/refs -name "*.lock" -type f -delete 2>/dev/null
```

### Step 1: GT commit 재시도

```bash
cd ~/AndroidStudioProjects/GentlyTable && git commit -m "ops: ..."
```

### Step 2: launchd daemon 재 install (C11 광역 적용)

```bash
bash ~/AndroidStudioProjects/claude-cli-master/scripts/install-git-lock-daemon.sh
# 재 install 시 기존 daemon unload + 새 daemon load (plist 변경 X · script 만 update)
```

→ 이후 모든 git lock 종류 자동 mitigation. 본 사고 영구 종결.

---

## 4. 다음 cycle

- C11 commit 후 = 모든 git lock 종류 (index/HEAD/refs/config/packed-refs) 자동 처리
- 자식 repo 도 daemon cover (master daemon 이 `~/AndroidStudioProjects/*/.git/**/*.lock` 광역)
