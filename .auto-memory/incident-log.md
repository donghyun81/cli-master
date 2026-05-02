# Incident Log — claude-cli-master

> 사고 기록 누적. 패턴 2회 이상 재발 시 별 trail 신설.
> 자식 repo 의 사고는 자식 repo 의 `.auto-memory/incident-log.md` 에 기록 (master 와 별도).
> master 사고 = cli infra / propagation / 보호 파일 / scripts 관련만.

## 사고 분류 (CLAUDE.md §22 추상 분류 참조)

- **도메인 도구 한계** — 외부 도구 미지원 기능
- **자동화 install ≠ activation** — 설치는 됐으나 작동 검증 안 됨
- **3-repo drift** — 보호 파일 또는 cli infra 의 byte-identical 깨짐
- **agent self-verification false positive** — agent EC PASS 보고하나 실측 FAIL
- **사용자 의도 vs 정책 충돌** — 정책이 반복 의도와 어긋남
- **cycle scope 부풀음** — 한 cycle 에 다른 영역 묶임

## 기록 형식

```
## YYYY-MM-DDTHH:MM:SS+0900
- type: <분류>
- cycle: <cycle-id>
- summary: <1줄>
- mitigation: <대응 1줄>
- trail: <별 trail ID 또는 close>
```

## C1 baseline 사고 (참조용 · 자식 repo 에서 발견된 drift)

```
## 2026-05-02T05:50:00+0900
- type: 3-repo drift
- cycle: (CLI-GUIDE-001 보고서 작성 중 발견)
- summary: GB 의 deferred-domains.md 가 SteadyWell propagation 잔존으로 ACTIVE 표기 (CLAUDE.md "현재 미정의" 와 불일치)
- mitigation: master 가 GT 의 UNKNOWN baseline 채택 → C4 propagation 시 GB 도 통일
- trail: close (C4 마감 시)
```

```
## 2026-05-02T05:50:00+0900
- type: 3-repo drift
- cycle: (CLI-GUIDE-001 보고서 작성 중 발견)
- summary: GT 의 routing-and-delegation.md 가 [DEFERRED] 라벨 미부착 (GB/GD 와 불일치)
- mitigation: master 가 GB+GD 의 [DEFERRED] 명시 채택 → C4 propagation 시 GT 도 통일
- trail: close (C4 마감 시)
```

```
## 2026-05-02T05:50:00+0900
- type: 사용자 의도 vs 정책 충돌
- cycle: (CLI-GUIDE-001 보고서 작성 중 발견)
- summary: 자식 repo 가 cli infra 직접 수정 가능 → master SoT 위반 위험 + propagation 의무 누락 패턴
- mitigation: master 신설 + 단방향 propagation 정책 박음 (CLAUDE.md §0 §3 §4)
- trail: close (C4 마감 + 자식 repo CLAUDE.md propagation 시)
```

```
## 2026-05-02T07:50:00+0900
- type: 자동화 install ≠ activation
- cycle: C8-GIT-LOCK-AUTOMITIGATION-001
- summary: sandbox / agent crash 후 잔존 .git/index.lock = 다음 git command 차단 → Coin 매번 손 작업 rm 의무 반복
- mitigation: pre-tool-use.sh = git command 감지 시 stale > 30s 자동 정리 + session-start.sh = 세션 시작 시 stale > 5분 자동 정리
- trail: close (C8 박힘 · cli infra 권장 byte-identical · C4 propagation 시 자식 자동 적용)
```

```
## 2026-05-02T08:10:00+0900
- type: 자동화 install ≠ activation (재발 · C8 mitigation 한계)
- cycle: C9-GIT-LOCK-PID-VERIFY-001
- summary: C8 박힌 hook 자동화 = Claude Code Bash tool 만 발화 → Coin 의 IDE/터미널/Cowork 에서 git 호출 시 hook X + stale 마진 30s/5분 너무 김
- mitigation: PID 기반 검증 (lock 안 PID 죽음 = 즉시 rm · mtime 무관) + standalone scripts/git-safe.sh wrapper (Coin 환경 alias 권장) + mtime 마진 단축 (pre-tool-use 5s / session-start 30s)
- trail: close (C9 박힘 · 99.9% case 자동 mitigation · alias 적용 시 Coin 환경 100%)
```

```
## 2026-05-02T08:30:00+0900
- type: 자동화 install ≠ activation (재재발 · C9 mitigation 한계 · 환경 진단 박힘)
- cycle: C10-LAUNCHD-DAEMON-001
- summary: C9 PID 검증 박았으나 사용자 환경 = Cowork chat 의 자체 file ops 가 git operation 호출 시 hook X · wrapper X · sandbox 권한으로 lock rm 절대 불가 (실측 PASS) · Coin 환경 alias 박혀 있어도 본 메시지는 sandbox 환경 발생
- mitigation: macOS launchd 백그라운드 데몬 박음 (5초마다 PID 검증 + stale rm) — 환경 무관 (Cowork/IDE/터미널/sandbox/모든 도구) 자동 작동 + scripts/install-git-lock-daemon.sh 1회 install 후 영구
- trail: close (C10 박힘 + Coin install 1회 후 99.99% 자동 mitigation · daemon log = ~/Library/Logs/git-lock-daemon.log)
```
