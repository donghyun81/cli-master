# Child CLAUDE.md Header — Nested 패턴 template

> **template 출처**: master `.auto-memory/child-claude-md-header.template.md` (cp 후 자식 CLAUDE.md 상단 5~10 줄 박음).
> **공식 근거**: Anthropic Claude Code Best Practices — Nested CLAUDE.md (parent/child 자동 로드 + Virtual Monorepo Pattern).

## 적용 위치

자식 repo 의 `<repo>/CLAUDE.md` 의 **첫 5~10 줄** (frontmatter 직후).

## template 본문 (자식 CLAUDE.md 상단에 박음)

```markdown
# <RepoName> CLAUDE.md

> **이 repo 는 multi-repo 자식**. cli infra + 보호 파일 + 공통 가이드 = master (claude-cli-master) SoT 단방향 propagation.
> **공통 SoT 진입 의무 reading order**:
>   1. `../claude-cli-master/CLAUDE.md` (master 헌법)
>   2. `../claude-cli-master/docs/guides/app-implementation-guide.md` (Claude CLI 진입 1차 가이드)
>   3. `../claude-cli-master/docs/agent/architecture/COMMON_ARCHITECTURE.md` (architecture)
>   4. **본 CLAUDE.md** (도메인 + repo-specific 정책)
> **자식 cli infra 직접 수정 금지** — drift 발견 시 즉시 STOP + master 정정 cycle 신설.
> **신규 도메인 작성** = master `docs/templates/<type>.template.md` cp 후 채움.
```

## 적용 절차 (C4 propagation 시 자동)

1. 자식 repo 의 기존 CLAUDE.md 본문 보존
2. 첫 5~10 줄 의 영역에 본 template 박음 (sed 또는 Coin 1회 검토)
3. 기존 본문 (도메인 정의 / 진입 커맨드 / Repo-First Intake 등) 그대로 유지
4. master propagation 시 본 template sha 만 검증

## 변경 정책

본 template = master 가 SoT 보유 (cli infra 권장 byte-identical).
변경 시 master cycle + 자식 repo 의 CLAUDE.md 첫 5~10 줄 갱신 propagation 의무.
