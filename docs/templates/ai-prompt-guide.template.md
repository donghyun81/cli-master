# AI Prompt Guide — `<RepoName>`

> **template 출처**: master `docs/templates/ai-prompt-guide.template.md`.
> **단일 목적**: 본 repo 가 사용하는 LLM (Claude / GPT 등) prompt + 도메인 정책.
> **활성 조건**: AI 기능 도입 cycle 진입 시 (이전엔 stub).

## 1. 사용 LLM + version

- provider: `<예: Anthropic Claude Sonnet 4.6>`
- API: `<예: claude-sonnet-4-6 · max_tokens=4096 · temperature=0.7>`
- 보안: API key = `<NEVER hardcode · settings.local.json 또는 BuildConfig 주입>`

## 2. system prompt 표준

```
You are <role>. Follow:
- <constraint 1>
- <constraint 2>
Output format: <JSON schema 또는 자연어>
```

## 3. user prompt template

각 task 별 prompt 형식 박음.

## 4. 응답 검증

- JSON schema validation 의무
- 도메인 invariant 위반 → 거부 + retry (max 3)

## 5. 비용 가드

- token budget 박음
- 사용자 quota 박음
- 알림: API 응답 latency > 5s = warning
