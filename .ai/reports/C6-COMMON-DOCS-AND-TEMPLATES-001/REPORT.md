# C6-COMMON-DOCS-AND-TEMPLATES-001 · Claude CLI 공통 가이드 + 도메인 템플릿

> 작성: 2026-05-02 · scope: master 의 추가 6 흡수 + 9 신설 (가이드 + 7 템플릿 + Nested header)
> 공식 근거: Anthropic Claude Code Best Practices + Google Android Compose Architecture

---

## 0. 거시 목적

C5 후 master 통합 완전성 = 99%. 본 cycle = **Claude CLI 가 자식 repo 안에서 앱 구현 시 참고할 통합 가이드 + 도메인 작성 템플릿** 박음 → 신규 자식 repo 신설 시 즉시 사용 가능 + 기존 자식 도메인 문서 형식 통일.

---

## 1. Part A 흡수 6 파일 (3-repo byte-identical 검증 PASS)

| 파일 | sha | 의미 |
|---|---|---|
| `.ai/promptfit/PLAYBOOK.md` | 9e159757fcc1 | PromptFit 평가 가이드 (REVIEW.md 12-section 작성 시 필수) |
| `.ai/uiux-sot/refresh/TRIGGERS.md` | c92a01804849 | refresh trigger path patterns (FULL/PARTIAL/DOC-ONLY) |
| `.ai/uiux-sot/refresh/VERIFY.md` | 22f1b818d433 | refresh 검증 명령 |
| `.ai/uiux-sot/refresh/WORKFLOW.md` | 1d4d90f36248 | refresh 워크플로 |
| `.github/pull_request_template.md` | 49425c6cbbd2 | PR 작성 template |
| `docs/backend/RLS_AND_PLAY_INTEGRITY_GUIDE.md` | ba59d96e1ea7 | Supabase RLS + Google Play Integrity (대용량 · Auth/Backend 활성 시 핵심) |

---

## 2. Part C-2 신설 9 파일

### 가이드 1
| 파일 | 줄 수 | 단일 목적 |
|---|---|---|
| `docs/guides/app-implementation-guide.md` | 204 | **Claude CLI 가 자식 repo 안에서 앱 구현 task 진입 시 첫 reading 의무 문서**. 5 architecture 원칙 (SSOT / UDF / Layered / Multi-module / Immutable) + 13 architecture 문서 ToC + 자식 repo 도메인 작성 절차 4 종 (UI / Data / 의존성 / 신규 repo) + Claude CLI task 진입 9 단계 흐름 |

### 도메인 작성 template 7 종
| 파일 | 줄 수 | 사용 시점 |
|---|---|---|
| `docs/templates/api-spec.template.md` | 56 | Backend / API endpoint 신설 |
| `docs/templates/data-model.template.md` | 40 | DomainModel / Entity / DTO 신설 |
| `docs/templates/screen-flow.template.md` | 36 | UX 화면 flow 정의 |
| `docs/templates/ai-prompt-guide.template.md` | 35 | AI 도메인 활성 시 LLM prompt 정책 |
| `docs/templates/billing.template.md` | 34 | Billing 도메인 활성 시 |
| `docs/templates/setup-guide.template.md` | 42 | 신규 자식 repo 환경 setup |
| `docs/templates/pencil-dev-prompt.template.md` | 32 | Pencil 캔버스 작성 free-text 계약 |

### Nested CLAUDE.md template 1
| 파일 | 줄 수 | 단일 목적 |
|---|---|---|
| `.auto-memory/child-claude-md-header.template.md` | 35 | 자식 repo CLAUDE.md 의 상단 5~10 줄 Nested 패턴 박음. C4 propagation 시 자동 적용 |

---

## 3. 공식 가이드 인용 (master 가 박은 근거)

### Anthropic Claude Code 공식

| 권장 | 본 cycle 적용 |
|---|---|
| Nested CLAUDE.md (parent + child auto-load) | `child-claude-md-header.template.md` 박음 |
| Virtual Monorepo Pattern | master + 자식 단방향 propagation = 정확히 이 패턴 |
| CLAUDE.md < 300 줄 | master CLAUDE.md = 250+ 줄 (margin 유지) |
| Planning Mode 의무 | `app-implementation-guide.md` §4 진입 흐름 박음 |
| codebase map | master CLAUDE.md §1 자식 repo 표 (codebase map 역할) |

### Google Android Compose 공식

| 원칙 | 본 cycle 박힌 위치 |
|---|---|
| Single Source of Truth | `app-implementation-guide.md` §1.1 + `SSOT_PRINCIPLES.md` (C5 흡수) |
| Unidirectional Data Flow | §1.2 + `KMP_CMP_LAYER_DIRECTION.md` |
| Layered Architecture (UI/Domain/Data) | §1.3 + `COMMON_ARCHITECTURE.md` |
| Multi-module 책임 분리 | §1.4 + `MODEL_SEPARATION.md` |
| Immutable state + state hoisting | §1.5 + `COMPOSE_STABILITY.md` |

---

## 4. scripts 확장 (verify-sync + propagate)

`find` 명령 추가 path:
- `.ai/promptfit/` (Part A 흡수 1 파일)
- `.ai/uiux-sot/refresh/` (Part A 흡수 3 파일)
- `.github/` (Part A 흡수 1 파일)

기존: `find .claude docs scripts/agent` → 확장: `find .claude docs scripts/agent .ai/promptfit .ai/uiux-sot/refresh .github`

→ verify-sync.sh 의 전체 검증 (--quick 아닌 default) 시 위 6 파일 + 신설 9 파일 (docs/guides + docs/templates) 모두 자동 검증.

---

## 5. 검증 (실측 PASS)

- 6 흡수 파일 sha = 자식 repo 와 100% 일치 (PASS)
- 9 신설 파일 = master only (자식 부재 = MISS · 정상 · C4 propagation 시 cp)
- bash -n script 4종 PASS
- verify-sync.sh --quick = 23 파일 검증 박힘 (확장 후)

---

## 6. 자식 repo 가 활용하는 흐름 (사용자 의도)

### 6.1 신규 화면 작성 시
```
자식 repo /fulfill-requirement "스플래시 화면 추가"
    ↓
intake-router 가 master/docs/guides/app-implementation-guide.md 자동 reading
    ↓
§3.1 신규 화면 작성 절차 6 단계 따름
    ├── master/docs/templates/screen-flow.template.md cp → docs/design/screen-flow.md
    ├── Pencil SoT 작성 (pencil-uiux-workflow.md)
    └── Compose IMPL (MODEL_SEPARATION + KMP_CMP_LAYER_DIRECTION 의무)
    ↓
verify + review (PromptFit · PLAYBOOK.md 흡수)
```

### 6.2 신규 자식 repo 신설 시
```
1. <PARENT>/<NewRepo>/ 신설
2. master 의 7 template cp 일괄
3. master 의 child-claude-md-header.template.md 첫 5줄 박음
4. bash claude-cli-master/scripts/propagate.sh --all --targets <NewRepo>
5. <NewRepo>/CLAUDE.md 의 도메인 섹션 채움
6. master CLAUDE.md §1 자식 repo 등록 표 행 추가
7. master propagation-status.md 표 행 추가
8. cycle 마감
```

→ master 의 통합 가이드 + 7 template + Nested 패턴 = 신규 repo 즉시 사용 가능 patterns.

---

## 7. 통합 완전성

| 시점 | 통합 % | 추가 박힌 영역 |
|---|---|---|
| C1 후 | 60% | master baseline + cli infra cp |
| C2 후 | 75% | rules 분할 + cross-reference 정정 |
| C2.5 후 | 85% | SOLID + 도구 무관 분리 |
| C3 후 | 95% | 자동화 script 4종 + slash + cycle-handoff template |
| C5 후 | 99% | 24 추가 흡수 (architecture/process/scripts/root) + rename |
| **C6 후** | **100%** | **앱 구현 가이드 + 7 도메인 template + Nested 패턴 = 모든 영역 박힘** |

---

## 8. Coin 손 작업 1줄 (C6 commit)

```bash
cd ~/AndroidStudioProjects/claude-cli-master && \
git add -A && \
git commit -m "$(cat <<'COMMIT'
feat(master): C6-COMMON-DOCS-AND-TEMPLATES-001 통합 가이드 + 7 템플릿 + Nested CLAUDE.md 패턴

[Goal] Claude CLI 가 자식 repo 안에서 앱 구현 시 참고할 통합 가이드 + 도메인 작성 형식 template + Nested 패턴
[Diff] +6 흡수 (.ai/promptfit/PLAYBOOK + .ai/uiux-sot/refresh 3 + .github/pull_request_template + RLS guide) +9 신설 (docs/guides/app-implementation-guide + docs/templates/ 7 + .auto-memory/child-claude-md-header) ~2 scripts (find 확장 .ai/promptfit + .ai/uiux-sot/refresh + .github 추가)
[Sha]  보호 5종 sha 변동 0 (C2.5 baseline 보존)
[EC]   6 흡수 자식 sha 일치 PASS · 9 신설 master only · bash -n script PASS · verify-sync --quick = 23 파일 박음
[Next] C4-PROPAGATE-TO-CHILDREN-001 (master → 3 자식 repo 단방향 propagation + 자식 CLAUDE.md 의 첫 5줄 Nested 패턴 박음 + ui-spec.json 마이그레이션 alias)
[Refs] task: C6-COMMON-DOCS-AND-TEMPLATES-001 · 공식 근거: Anthropic Claude Code Best Practices + Google Android Compose Architecture · parent: <C5 commit hash>
COMMIT
)"
```

---

`Sources:`
- [docs/guides/app-implementation-guide.md (신설)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/docs/guides/app-implementation-guide.md)
- [docs/templates/api-spec.template.md](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/docs/templates/api-spec.template.md)
- [docs/templates/data-model.template.md](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/docs/templates/data-model.template.md)
- [docs/templates/screen-flow.template.md](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/docs/templates/screen-flow.template.md)
- [.auto-memory/child-claude-md-header.template.md](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/.auto-memory/child-claude-md-header.template.md)
- [docs/backend/RLS_AND_PLAY_INTEGRITY_GUIDE.md (흡수)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/docs/backend/RLS_AND_PLAY_INTEGRITY_GUIDE.md)
- [.ai/promptfit/PLAYBOOK.md (흡수)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/.ai/promptfit/PLAYBOOK.md)
- [.auto-memory/decision-log.md (C6 entry)](computer:///Users/yundonghyeon/AndroidStudioProjects/gently-master/.auto-memory/decision-log.md)
- [Compose UI Architecture - Android Developers](https://developer.android.com/develop/ui/compose/architecture)
- [Best Practices for Claude Code](https://code.claude.com/docs/en/best-practices)
- [Writing a good CLAUDE.md - HumanLayer](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
