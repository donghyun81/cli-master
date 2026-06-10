---
name: pencil-cli
description: Use when invoking @pencil.dev/cli headless mode for batch screen generation, Save As modal avoidance, or CI/CD design refresh. Covers Node.js 18+ runtime, interactive login + CI/CD key auth, agent mode, interactive shell, batch tasks.json, save() invocation, model selection (opus/sonnet/haiku), and CI/CD integration paradigm. Counterpart to pencil-pen-save skill (desktop app stdio paradigm).
paths: docs/design/pencil-sot/**, **/*.pen
allowed-tools: Bash, Read
---

# Pencil CLI Headless Mode

> **단일 목적**: `@pencil.dev/cli` (npm) 측 headless 진입점 — Save As 모달 회피 + batch 다중 screen 신설 + CI/CD 통합 paradigm 통합.
> **신설**: MASTER-CLI-PENCIL-OPTIMIZATION-001 (2026-05-19).
> **공식 근거**: pencil.dev `/for-developers/pencil-cli` (2026-04-03 last updated).
> **연관 paradigm**:
> - `.claude/skills/pencil-pen-save/SKILL.md` — 본 skill 측 §13 (desktop vs headless 분기 표) 정합
> - `.claude/rules/pencil-uiux-workflow.md` §9 — Pencil CLI binding 진입점
> - `.claude/rules/pencil-mcp-tools-reference.md` — headless shell 안에서도 동일 tool surface 호출

---

## 1. Pencil CLI 본질

- npm package: `@pencil.dev/cli`
- 설치: `npm install -g @pencil.dev/cli`
- 런타임 의무: **Node.js 18+** (`node -v` 측정 의무)
- 위치: Pencil desktop app 과 분리된 별도 진입점. desktop app 미실행 환경에서도 작동.
- 공식 doc: https://docs.pencil.dev/for-developers/pencil-cli

본 패키지 cli infra 측 본 skill = **선언적 reference** 영역. 실 `npm install -g` 진입은 사용자 직접 단계로 분리 (= cli infra cycle scope 외).

---

## 2. 인증 방식 (2 종)

### 2.1 Interactive login (개발 환경 default)

```bash
pencil login
# → 브라우저 OAuth 흐름 → token 저장 위치: ~/.pencil/session-cli.json
```

저장 후 추가 명령 = token 자동 재사용.

### 2.2 CI/CD key (자동화 환경 default)

```bash
export PENCIL_CLI_KEY="pencil_cli_<...>"
# → 우선순위: PENCIL_CLI_KEY > ~/.pencil/session-cli.json
```

CI/CD pipeline 측 환경변수 주입. `safety-and-secrets.md` 측 시크릿 기록 금지 정합 (값 평문 파일 commit 금지 · 변수명만 허용).

### 2.3 환경변수 표

| 변수 | 용도 | 기본값 |
|---|---|---|
| `PENCIL_CLI_KEY` | CI/CD 인증 (우선) | — |
| `ANTHROPIC_API_KEY` | Claude 모델 호출 | — |
| `PENCIL_API_BASE` | 백엔드 endpoint | `https://api.pencil.dev` |
| `DEBUG` | 상세 로그 | (미설정) |

---

## 3. Agent mode (단일 호출 prompt-driven)

```bash
pencil \
  --in input.pen \
  --out output.pen \
  --prompt "Add a sidebar with 4 navigation items: Home / History / Settings / Profile" \
  --model claude-opus-4-6 \
  --export hero.png \
  --export-scale 2 \
  --export-type png
```

특징:
- 1 회 invocation = 1 prompt = 1 output `.pen`
- export 옵션 (`--export <path>` + `--export-scale` + `--export-type`) 으로 visual 검증 자산 동시 산출
- model 선택은 §8 참조

---

## 4. Interactive mode (headless shell · 본 skill 핵심)

GUI 없이 shell 안에서 도구 직접 호출. Save As 모달 발생 없음.

### 4.1 신규 빈 canvas 신설

```bash
pencil interactive -o output.pen
```

shell 진입 후 (`pencil>` prompt):
```
> batch_design({ root: "I('document', {...})" })
> set_variables({ ... })
> snapshot_layout({ problemsOnly: true })
> save()
> exit()
```

`save()` → output.pen disk 기록. desktop app 측 Save As 다이얼로그 발생하지 않음.

### 4.2 기존 `.pen` 편집

```bash
pencil interactive -i input.pen -o output.pen
```

### 4.3 실행 중 desktop app 연결

```bash
pencil interactive -a desktop -i my-design.pen
```

desktop app 측 viewport 측 실시간 시각 검증 의무 시 진입. Coin 본인 측 시각 확인 필요할 때만 사용.

### 4.4 shell 명령 reference

| 명령 | 의미 |
|---|---|
| `tool_name({ key: value })` | MCP tool 호출 (`mcp__pencil__*` namespace 동일) |
| `save()` | 현재 canvas → disk 저장 (Save As 모달 회피의 핵심) |
| `exit()` | shell 종료 |

---

## 5. Batch tasks.json (다중 screen 일괄 신설)

다중 화면 cycle 안 권장 진입점.

### 5.1 tasks.json 형식

```json
{
  "tasks": [
    {
      "out": "screens/home.pen",
      "prompt": "Create a home screen with status card and 3 action buttons"
    },
    {
      "out": "screens/settings.pen",
      "prompt": "Create a settings screen with toggle switches and account section"
    }
  ]
}
```

### 5.2 실행

```bash
pencil --tasks batch.json
```

순차 처리. 각 task 마감 후 다음 task 진입. token 한도 초과 또는 model rate-limit 발화 시 해당 task 만 FAIL, 후속 task 미진행 → STOP + Coin 재진입 의뢰.

### 5.3 본 패키지 적용 사례

- feature 도메인 진입 시 5~10 screen 한꺼번에 신설 (Phase F-N sub-cycle)
- nightly baseline refresh (CI/CD scheduled)
- design system v2 도입 시 inherit 적용 screen 일괄 재 export

---

## 6. Save As 모달 회피 paradigm

`.claude/skills/pencil-pen-save/SKILL.md` 측 baseline 사고:
- (구) desktop app + `mcp__pencil__open_document(filePathOrTemplate="new")` 호출 → in-memory canvas 생성 → 첫 Cmd+S 시 macOS Save As 다이얼로그 활성 → Coin 1회 GUI 클릭 의무. (`open_document` MCP = Pencil v1.1.62 제거 · `pencil-mcp-tools-reference.md §0.1` · 현 desktop 신규 doc = 앱 UI 수동 생성 또는 `open -a Pencil <abspath>` · 이로써 headless-primary 강화.)

headless interactive mode 의 mitigation:
- `pencil interactive -o <path>` → shell 안 `save()` 명령 → 지정 path 에 직접 기록.
- macOS Save As 다이얼로그 자체 미발생 → Coin GUI 클릭 0.

agent 안 자동화 sequence 예:
1. `pencil interactive -o docs/design/pencil-sot/<screen>/<screen>.pen` 진입
2. `batch_design({...})` + `set_variables({...})` + `snapshot_layout({problemsOnly:true})`
3. `save()` 후 `exit()`
4. shell 측 `shasum -a 256 <screen>.pen` 측정 → ui-spec.json `lastSyncedDesignToolStateHash` 갱신

위 sequence = `.claude/skills/pencil-pen-save/SKILL.md` 측 신규 .pen 신설 11-step 흐름 측 step 3~7 영역 (Save As 모달 + Coin 안내 + Coin GUI 클릭) 완전 회피.

---

## 7. desktop stdio (MCP) vs CLI headless 분기 결정

본 패키지는 두 진입점 병행 활용:

| 진입점 | 호출 방식 | 의무 환경 | 시각 검증 |
|---|---|---|---|
| **desktop stdio MCP** (`.mcp.json` 안 등록) | Claude Code 안 `mcp__pencil__*` tool 호출 | Pencil app 실행 중 (macOS) | viewport 실시간 |
| **CLI headless** (`@pencil.dev/cli` npm) | shell `pencil interactive` 또는 `pencil --tasks` | Node.js 18+ (OS 무관) | `--export` PNG / `get_screenshot` |

### 7.1 권장 분기

| 시나리오 | 권장 |
|---|---|
| Coin 본인 측 design 의도 직접 검증 의무 + screen 1~2개 | desktop stdio MCP |
| screen 5+ 한꺼번에 신설 / batch | CLI headless `--tasks` |
| Save As 모달 회피 의무 (Coin 클릭 0) | CLI headless interactive |
| CI/CD nightly refresh | CLI headless `--tasks` |
| macOS 외 환경 (Linux CI runner) | CLI headless 단일 |
| design drift 정정 + 시각 검증 동시 | desktop stdio MCP |

### 7.2 도구 surface 일치성

두 진입점 모두 동일한 12 + 1 도구 surface 노출 (`pencil-mcp-tools-reference.md` 단일 SoT). 호출 형식만 차이:
- desktop stdio: `mcp__pencil__batch_design({...})`
- CLI headless shell: `batch_design({...})`

---

## 8. Model 선택 paradigm

공식 doc 명시 3 모델:

| 모델 | 특성 | 권장 사용처 |
|---|---|---|
| `claude-opus-4-6` (default) | 최고 능력 | 복잡 layout / multi-step prompt / design system 통합 |
| `claude-sonnet-4-6` | 빠른 응답 + 균형 | 단일 screen 정정 / 반복 batch task |
| `claude-haiku-4-5` | 최저 비용 + 가장 빠름 | 단순 token swap / 작은 정정 |

선택 기준:
- cycle 본질 측 복잡도 추정 → 단순 = haiku · 중간 = sonnet · 복잡 = opus
- batch tasks.json 안 task 별 모델 분리 가능 (cost / latency optimization)
- 본 패키지 default = `claude-opus-4-6` (cli infra rule body 작성 + design system 통합 우선)

---

## 9. STOP 조건

| trigger | mitigation |
|---|---|
| `node -v` < 18 | nvm 또는 Homebrew 측 Node 18+ 설치 후 재시도. 본 cycle = rule scope. |
| `pencil --version` 명령 미인식 | `npm install -g @pencil.dev/cli` 사용자 직접 실행 의뢰. |
| `~/.pencil/session-cli.json` 부재 + `PENCIL_CLI_KEY` 미설정 | `pencil login` 진입 의뢰 또는 CI/CD key 환경변수 주입 의뢰. |
| `pencil status` FAIL | 백엔드 connectivity 확인 (`PENCIL_API_BASE` 정합). |
| `pencil --tasks batch.json` 안 일부 task FAIL | 해당 task 격리 + 재시도 분리 cycle. 일괄 retry 금지 (rate limit 가속). |
| token 한도 초과 발화 | 작은 batch 분할 + 후속 cycle 진입. |

---

## 10. CI/CD 통합 paradigm (lazy default · 본 cycle scope = rule reference)

### 10.1 후보 통합 시나리오

- nightly: 모든 screen `.pen` ↔ `ui-spec.json` sha 검증 + drift 발견 시 mitigation cycle trigger
- on-PR: 변경된 `<screen>.ui-spec.json` 측 `.pen` 측 자동 refresh + export 갱신
- weekly: design token (`set_variables`) sync 검증

### 10.2 실 통합 진입 = 별 cycle 분리

본 §10 = paradigm 명시 영역 (rule SoT). 실 CI/CD action 추가 (예: `.github/workflows/pencil-nightly.yml`) = `MASTER-CLI-PENCIL-CI-INTEGRATION-NNN` 별 cycle 분리. lazy default · 자식 repo 측 trigger 시점 진입.

### 10.3 시크릿 처리

`PENCIL_CLI_KEY` + `ANTHROPIC_API_KEY` = GitHub Actions Secrets / Supabase Vault 등 외부 보관 (`safety-and-secrets.md` 정합). 평문 commit / log 출력 금지.

---

## 11. 본 skill 의 변경 정책

- cli infra 권장 byte-identical (5-repo · master + 4 자식)
- 변경 시 master cycle 신설 + 5-repo propagation (`cycle-discipline.md` §15 패턴 1)
- 자식 repo 직접 수정 금지

---

## 12. 명시 cycle 이력

- 2026-05-19 · `MASTER-CLI-PENCIL-OPTIMIZATION-001` · 직전 rule (`.claude/rules/pencil-cli-headless.md`) 신설 + 5-repo byte-identical propagation
- 2026-05-26 · `MASTER-CLI-SKILLS-MIGRATION-PHASE-1-001` · 본 skill 신설 default (= 직전 rule 본문 본질 보존 default · skill paradigm 정합 default · trigger 시점 lazy load default · `.claude/rules/pencil-cli-headless.md` 측 thin pointer 갱신 default)
