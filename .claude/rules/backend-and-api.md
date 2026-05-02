# [DEPRECATED] backend-and-api.md — C2-RULES-RESTRUCTURE-001 통합

> 본 파일은 **2026-05-02 · C2-RULES-RESTRUCTURE-001** 에서 `deferred-domains.md` 로 통합되었다.
> sandbox rm 권한 한계로 본 파일은 pointer-only (rm 은 Coin 손 작업).

## 통합 위치

`deferred-domains.md` §1 공통 STOP 조건 표 + §2 현재 상태 + §4 활성화 절차.

## Coin 손 작업 (master rm 4 종 묶음)

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
rm .claude/rules/auth-security-privacy.md \
   .claude/rules/backend-and-api.md \
   .claude/rules/data-and-migrations.md \
   .claude/rules/performance-reliability.md && \
git add -A
```
