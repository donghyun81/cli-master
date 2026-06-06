---
정리위치: archive/
정리trigger: 본 cycle paste-back 마감 또는 mtime 14일
정리주체: cowork 자율
agent-commit: yes
---

# cc-paste-MASTER-S15-PRELAUNCH-EXEC2-A-001 — master §15 entry 일괄 append (Q-A 묶음 마감)

> **Mode = M5 cli-infra-ops** · docs-only (CLAUDE.md §15 append + 절차상 .auto-memory 갱신만) · propagation 불요 (§15 = master 고유 영역).

## §0. BASELINE

- repo = `/Users/yundonghyeon/AndroidStudioProjects/claude-cli-master` · HEAD `f05323f` (dirty 1 = .auto-memory/incident-log — 무접촉) · 보호 5종 PASS

## §1. WHAT — §15 entry 3건 일괄 append (2026-06-05 · PRELAUNCH-EXEC2 chat · Q-A 묶음)

1. **FND-BILLING-SEAM-001** (M3 · FND `9edd495`+`06b414b`): core/billing Mock-first seam 신설 — billing-rules §4 signature byte 정합 · typed 2-param Result = core/billing 내 (사용자 옵션 A · shared/domain 승격 후보 = 2nd consumer 시점) · production guard = 구조적 DI 분리 (NoOp aggregate / Mock opt-in) · test 8.
2. **GB-BILLING-CLIENT-001** (M3 · GB `5991c30`): 실 BillingClient 6.2.1 + verify-purchase typed-body EF wiring + EncryptedPrefs cache + mock debug opt-in · test 17 · paste 측 drift 3 건 cli A1 catch (4-field contract / androidMain 배치 / design doc stale) → 사용자 회수 후 진행 · E2E = Play 후행.
3. **FND-DOCSYNC-HOUSEKEEPING-001** (M1 · FND `ba1257a`): core/CLAUDE.md 8 active+3 dormant 정정 · FND-GRADLE-BASELINE-001 STOP→DONE (사유 소멸 실측) · FND-T03 →DONE.

부수 기록 (entry 말미 1줄 또는 .auto-memory 후보 누적 — cli 판단): Money finding = verify-purchase ticketCount 서버 미검증 (inflation 가능 · GB-EF-HARDENING-001 로 즉시 후속 진행 중) · check-abbreviation.sh §3.8 framework whitelist 부재 (Play SDK 타입명 false-block) · core/CLAUDE.md "6-repo ecosystem" ↔ A12 anchor 어휘 혼선 (5-repo 통일 후보).

## §2~§8 (압축)

scope = master `CLAUDE.md §15` append (+ 절차상 .auto-memory) 한정 · 타 file/보호/자식 무접촉. FREEDOM = entry 문구 압축/형식 (기존 §15 entry 형식 follow). STOP = §15 외 본문 변경 필요 발견 · propagation 필요 판단. paste-back = commit sha + diff 요약 + Negative Space Line.
