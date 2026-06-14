# MASTER-CLI-DATA-SOT-ARCH-LANDING-001 — Propagation Report

> 수기 생성: 2026-06-15 KST · master content HEAD: b14b6f5 · Mode M5 cli-infra-ops

---

## 1. Cycle 메타

- cycle ID: MASTER-CLI-DATA-SOT-ARCH-LANDING-001
- master content commit: `b14b6f5` (`docs(arch): … COMMON_ARCHITECTURE §4 데이터 SoT(서버 authoritative) 명문화`)
- scope: `LOCK-DATA-SOT-SERVER-AUTHORITATIVE-001` (Coin 확정 2026-06-15) 데이터 SoT 결정을 6-repo 공통 헌법 `COMMON_ARCHITECTURE.md` 에 **1 절(§4)** 로 명문화 (앱-중립 계약만 · 앱 이름 미기재 · LOCK 포인터 · 4 bullet).
- 변경 파일: `docs/agent/architecture/COMMON_ARCHITECTURE.md` 단일 (**비보호** cli infra 권장 byte-identical doc · 6-repo).
- production code / `.kt` / Edge Function / DB schema·DDL·migration / 제품 SoT 본문 / 보호 5 file = **무접촉** (문서 한정).

## 2. 삽입 절 본문 (앱-중립 데이터 아키텍처 원칙)

- 배치: 현 §3(앱-고유 vs 앱-중립 구분) 직후 신규 `## 4. 사용자 데이터 source of truth` 삽입 → 현 §4 Propagation Discipline → §5 · 현 §5 관련 문서 → §6 재번호.
- 라인 범위: 신규 §4 = L69–82 (총 91→106 lines · +15).
- 4 bullet: ① source of truth = 서버(Supabase Postgres) · 로컬 단독 SoT 금지 ② Room = offline-first 캐시 + 서버 hydration(복원) 층 · Room 단독 SoT 금지 ③ 집계(곡선·통계·리포트) = 서버 Edge Function ④ durability 요건(재설치·기기 변경 생존 · 업로드 전용 sync = 미충족).
- 프레이밍: 도메인 정책 X · **persistence 아키텍처 원칙** (`SSOT_PRINCIPLES` · `MODEL_SEPARATION` 동족) → 데이터층 침투 가드(§1 L16 · §3 L65) 무저촉. 앱별 현 상태/gap = LOCK + 각 repo 데이터층 문서 추적 (절 본문 미기재).

## 3. 재번호 안전 (cross-ref grep · authoritative)

- 6-repo `COMMON_ARCHITECTURE … §4/§5` 인용 grep = **0** (라이브 cross-ref). 유일 sectioned 인용 = `rule-routing-index.md:203 §1` (6-repo · 무변경) + `app-implementation-guide.md:81` (섹션 번호 無). COLD-history 인용(L42 line-ref) = 불변 역사 기록. ⇒ §4→§5, §5→§6 재번호 **무파손**.

## 4. propagation 결과

- `bash scripts/propagate.sh docs/agent/architecture/COMMON_ARCHITECTURE.md --targets all`
- targets = GentlyBreath GentlyDay GentlyTable app-foundation gently-product-docs (5) + master = **6-repo byte-identical**.
- 결과: **ok=5 fail=0** · `--prune` 미사용 · .gitignore 신규 patch 0 / 이미 적용 5.

## 5. 6-repo HEAD + sha (직접 `shasum -a 256` 대조 = authoritative)

| repo | content commit | COMMON_ARCHITECTURE.md sha-256 (12) |
|---|---|---|
| claude-cli-master | `b14b6f5` | `09d1f17381f6` |
| app-foundation | `792be92` | `09d1f17381f6` |
| GentlyBreath | `2f7d4a5` | `09d1f17381f6` |
| GentlyDay | `847eb5c` | `09d1f17381f6` |
| GentlyTable | `58e1f18` | `09d1f17381f6` |
| gently-product-docs | `a843672` | `09d1f17381f6` |

> 6-repo 전부 sha-256 `09d1f17381f6b18976750b19fe8fd2af896f2f6ab02eff90209f66586ee2fbad` 동일. master pre-edit baseline = `d6b46a21…`.
> 자식 commit body = master `b14b6f5` 인용 · 각 path-limited (그 1 file만 · 자식 기존 WIP/ahead 무혼입).

## 6. cross-verify (`verify-sync.sh`)

- **PASS: 160 파일 · DRIFT 0 · MISS 0** → 6-repo byte-identical 확정.
- 보호 5 file sha drift = 0 (edit-set ∩ 보호 = ∅ · COMMON_ARCHITECTURE 보호 미등재 재확인 PASS).
- git-lock daemon 미활성 advisory = 직전 PENCIL-SCHEMA-UPDATE-001 §15 기록 패턴 (non-blocking · follow-up: launchctl load).

## 7. 무접촉 검증

- production code / `.kt` / Edge Function / DB DDL·migration = 0 LOC.
- 제품 SoT 본문(비전·원칙·전략·§4-bis) = 무변경 (비전 §1-3 anti-reset = 절 근거로 *인용*만 · cascade 0).
- 보호 5 file = 무변동 · `LOCK-DATA-SOT-SERVER-AUTHORITATIVE-001.md` = 인용만(편집 0).
- 직전 cycle 잔여 ahead (master+2 진입 → FND/GB/GD/GT/PDOCS) = forward-progress 무접촉.

## 8. audit

- `.auto-memory/propagation-status.md` = verify-sync 자동 갱신 (live 매트릭스 + footer).
- master `CLAUDE.md §15` entry append.
- master audit commit = 본 REPORT + propagation-status + §15 (master-only).
