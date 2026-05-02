# Setup Guide — `<RepoName>`

> **template 출처**: master `docs/templates/setup-guide.template.md`.
> **단일 목적**: 신규 개발자 (또는 신규 환경) 의 본 repo 환경 setup 절차.

## 1. 사전 의무

- macOS (Pencil 도구 의존)
- Android Studio Hedgehog 이상
- JDK 17
- Claude Code 2.1.114 (`cycle-discipline.md` §13 박힘)

## 2. clone + 첫 build

```bash
git clone <repo-url>
cd <RepoName>
./gradlew :app:assembleDebug
```

## 3. local.properties 설정

```properties
sdk.dir=<Android SDK path>
SUPABASE_URL=<dev URL · 미연결 시 stub>
SUPABASE_ANON_KEY=<dev key>
```

## 4. master 의존성 확인

```bash
cd ~/AndroidStudioProjects/claude-cli-master
bash scripts/verify-sync.sh --target <RepoCode>
```

## 5. 첫 task 실행

```
/fulfill-requirement <한 줄 요구사항>
```

intake-router → master 의 `app-implementation-guide.md` 자동 reading 후 진행.
