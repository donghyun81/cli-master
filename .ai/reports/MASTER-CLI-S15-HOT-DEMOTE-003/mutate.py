#!/usr/bin/env python3
# MASTER-CLI-S15-HOT-DEMOTE-003 — §15 hot 13 → cold 7회차 재이전 (8 demote · 5 retain + 1 new = 6 hot)
# validate-then-write: 기존 row 는 list-slice 로 이동(verbatim 보장) · NEW 문자열만 신규 타이핑.
import sys

CLAUDE = 'CLAUDE.md'
COLD   = '.auto-memory/master-cycle-history-COLD.md'
CH     = '.auto-memory/context-health-metrics.md'

EXPECT_DEMOTE = [
    'MASTER-CLI-P2-MECHANISM-001',
    'MASTER-CLI-P2-RENAME-A-001',
    'MASTER-CLI-PENCIL-SELFTEST-GATE-RECALIBRATE-001',
    'MASTER-CLI-PENCIL-TOOLSET-REMOVAL-STALE-SWEEP-001',
    'MASTER-CLI-25-2-DEDUP-PRUNE-EXCLUDE-LAND-001',
    'MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001',
    'MASTER-CLI-DEAD-REF-SWEEP-001',
    'MASTER-CLI-PROTECTED-STALE-PATH-FIX-001',
]
EXPECT_RETAIN = [
    'MASTER-CLI-COMPOUND-LINT-DEPRECATE-001',
    'MASTER-CLI-REPO-COUNT-VOCAB-SWEEP-001',
    'MASTER-CLI-PENCIL-PHASE-B-PROTECTED-001',
    'MASTER-CLI-CC-VERSION-UPDATE-NATIVE-EVAL-001',
    'MASTER-CLI-INFRA-SMALL-BATCH-001',
]

NEW_ENTRY = (
    '| MASTER-CLI-S15-HOT-DEMOTE-003 | 2026-06-11 | §15 hot 13행 → cold 7회차 재이전 '
    '(Mode M5 cli-infra-ops · production 무접촉 · GSM-S15-HOT advisory 3 cycle 연속 발화 + audit-P2 O2 후속 · '
    'COLD-002 + AUTO-DEMOTE-CONTEXT-DIET 전례 동형). **본질**: §15 hot 13 entry 중 오래된 8 '
    '(`MASTER-CLI-P2-MECHANISM-001`~`MASTER-CLI-PROTECTED-STALE-PATH-FIX-001`) = '
    '`.auto-memory/master-cycle-history-COLD.md` verbatim append (LOSS NONE · 이전 8행 = cold 신규 8 entry '
    'exact-string 대칭 검증) → cold 103→111 · hot 잔존 = 최근 5 '
    '(`MASTER-CLI-COMPOUND-LINT-DEPRECATE-001`~`MASTER-CLI-INFRA-SMALL-BATCH-001`) + 본 entry = 6. '
    '**동반**: §15 table-split 빈 줄 1 제거 (valid 표 복귀) · cold §1 heading stale 94→111 reconcile '
    '(= 직전 AUTO-DEMOTE +9 누락분 동반 정정) · `context-health-metrics.md` §2 갱신 '
    '(hot entry desc + cold pointer 103→111 + master char 재측정). **검증**: hot 13→6 '
    '(`measure-gsm-cycle.sh` awk 실측) · GSM-S15-HOT advisory 재실행 무발화 (6 ≤ 10) · 무손실 대칭 8 = 8 '
    'exact-string · 보호 5 sha drift 0 (edit-set ∩ 보호 = ∅) · production/도메인 0 LOC · 자식 5 repo 무접촉. '
    '**후속(scope 외)**: 다음 hot > 10 도달 시 8회차 재이전 (= advisory). | '
    '**master-only** (master 본 commit · §15 / cold / context-health-metrics = master-only · '
    '자식 5 repo 무접촉 · propagation 불요) |'
)

def cid(row):
    return row.split('|')[1].strip()

def must_replace_once(text, old, new, label):
    n = text.count(old)
    if n != 1:
        sys.exit(f'ABORT: {label} expected 1 occurrence, found {n}')
    return text.replace(old, new)

# ---------- CLAUDE.md ----------
claude = open(CLAUDE, encoding='utf-8').read()
lines = claude.split('\n')
start = next(i for i, l in enumerate(lines) if l.startswith('## 15.'))
end   = next(i for i in range(start + 1, len(lines)) if lines[i].startswith('## '))
sep_idx     = next(i for i in range(start, end) if lines[i].startswith('|---'))
coldptr_idx = next(i for i in range(start, end) if lines[i].startswith('> **§15 cold'))
data_idx  = [i for i in range(sep_idx + 1, coldptr_idx) if lines[i].startswith('| ')]
data_rows = [lines[i] for i in data_idx]

if len(data_rows) != 13:
    sys.exit(f'ABORT: expected 13 §15 data rows, found {len(data_rows)}')
ids = [cid(r) for r in data_rows]
if ids[:8] != EXPECT_DEMOTE:
    sys.exit(f'ABORT: demote IDs mismatch: {ids[:8]}')
if ids[8:] != EXPECT_RETAIN:
    sys.exit(f'ABORT: retain IDs mismatch: {ids[8:]}')

demoted  = data_rows[:8]
retained = data_rows[8:]

# cold-pointer line update (count-anchored on its own string)
cp = lines[coldptr_idx]
cp = must_replace_once(
    cp,
    '`MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001` 2026-06-10 6회차):',
    '`MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001` 2026-06-10 6회차 + `MASTER-CLI-S15-HOT-DEMOTE-003` 2026-06-11 7회차):',
    'CLAUDE coldptr lineage')
cp = must_replace_once(
    cp,
    'master cycle **103 entry 전체 이력** (= `C1-MASTER-BOOTSTRAP-001` ~ `MASTER-PRINCIPLES-OKR-ROUTING-001`)',
    'master cycle **111 entry 전체 이력** (= `C1-MASTER-BOOTSTRAP-001` ~ `MASTER-CLI-PROTECTED-STALE-PATH-FIX-001`)',
    'CLAUDE coldptr count+range')

new_lines = (lines[:sep_idx + 1] + retained + [NEW_ENTRY] + [''] + [cp] + lines[coldptr_idx + 1:])
new_claude = '\n'.join(new_lines)
new_master_char = len(new_claude)

# ---------- COLD ----------
cl = open(COLD, encoding='utf-8').read().split('\n')
cidx = next(i for i, l in enumerate(cl) if l.startswith('| MASTER-PRINCIPLES-OKR-ROUTING-001'))
new_cl = cl[:cidx + 1] + demoted + cl[cidx + 1:]
cold = '\n'.join(new_cl)
cold = must_replace_once(cold, '(= 103 entry 영구 누적', '(= 111 entry 영구 누적', 'COLD title')
cold = must_replace_once(
    cold,
    '## §1. master §15 cycle 진행 이력 (= 94 entry verbatim · Phase 1 65 + COLD-002 +19 + EXEC2-B +2 + EXEC3 +4 + EXEC3-002 +4 재배치)',
    '## §1. master §15 cycle 진행 이력 (= 111 entry verbatim · Phase 1 65 + COLD-002 +19 + EXEC2-B +2 + EXEC3 +4 + EXEC3-002 +4 + AUTO-DEMOTE +9 + S15-HOT-DEMOTE-003 +8 재배치)',
    'COLD §1 heading')
cold = must_replace_once(cold, '측 103 entry 전체 **verbatim 이전**', '측 111 entry 전체 **verbatim 이전**', 'COLD blockquote count')
cold = must_replace_once(
    cold,
    '· 2026-06-10 `MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001` 6회차). hot §15',
    '· 2026-06-10 `MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001` 6회차 + S15-HOT-DEMOTE-003 +8 = `MASTER-CLI-P2-MECHANISM-001`~`MASTER-CLI-PROTECTED-STALE-PATH-FIX-001` · 2026-06-11 `MASTER-CLI-S15-HOT-DEMOTE-003` 7회차). hot §15',
    'COLD blockquote lineage')

# ---------- context-health-metrics ----------
ch = open(CH, encoding='utf-8').read()
kk = round(new_master_char / 1000)
old56 = '| master CLAUDE.md (FULL) | ~26K (2026-06-10 재측정 · 23,716 + 본 cycle entry) | §15 = hot 최근 5 + 본 cycle entry + cold pointer(전체 이력 = `master-cycle-history-COLD.md` 103 entry) |'
new56 = f'| master CLAUDE.md (FULL) | ~{kk}K (2026-06-11 재측정 · {new_master_char} · S15-HOT-DEMOTE-003 hot 13→6 · 직전 "~26K/23,716" = §15 비대 누적분 미반영 stale) | §15 = hot 최근 5 + 본 cycle entry + cold pointer(전체 이력 = `master-cycle-history-COLD.md` 111 entry) |'
ch = must_replace_once(ch, old56, new56, 'CH line56 master char')
old66 = '6회차 cold 재이전(MASTER-CLI-AUTO-DEMOTE-CONTEXT-DIET-001 · 2026-06-10 · hot 14→5+본 cycle) 후'
new66 = '7회차 cold 재이전(MASTER-CLI-S15-HOT-DEMOTE-003 · 2026-06-11 · hot 13→5+본 cycle · 직전 6회차 = AUTO-DEMOTE-CONTEXT-DIET-001 2026-06-10) 후'
ch = must_replace_once(ch, old66, new66, 'CH line66 hot entry desc')

# ---------- write all (validated) ----------
open(CLAUDE, 'w', encoding='utf-8').write(new_claude)
open(COLD,   'w', encoding='utf-8').write(cold)
open(CH,     'w', encoding='utf-8').write(ch)

# sidecar: exact demoted rows (for symmetry record)
open('.ai/reports/MASTER-CLI-S15-HOT-DEMOTE-003/demoted-8.txt', 'w', encoding='utf-8').write('\n'.join(demoted) + '\n')

print('OK demote=8 retain=5 new=1 hot_after=6')
print('master_char:', 40464, '->', new_master_char, f'(~{kk}K)')
print('demoted IDs:', [cid(r) for r in demoted])
print('retained IDs:', [cid(r) for r in retained])
