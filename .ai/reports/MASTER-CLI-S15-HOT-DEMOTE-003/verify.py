#!/usr/bin/env python3
# Independent symmetry + structure verification.
# "before" = git HEAD:CLAUDE.md (immutable baseline) · "after" = working tree.
import subprocess, sys

def cid(r): return r.split('|')[1].strip()

def s15_rows(text):
    lines = text.split('\n')
    start = next(i for i, l in enumerate(lines) if l.startswith('## 15.'))
    end   = next(i for i in range(start + 1, len(lines)) if lines[i].startswith('## '))
    sep   = next(i for i in range(start, end) if lines[i].startswith('|---'))
    cptr  = next(i for i in range(start, end) if lines[i].startswith('> **§15 cold'))
    return [lines[i] for i in range(sep + 1, cptr) if lines[i].startswith('| ')]

base = subprocess.check_output(['git', 'show', 'HEAD:CLAUDE.md']).decode('utf-8')
work_claude = open('CLAUDE.md', encoding='utf-8').read()
work_cold   = open('.auto-memory/master-cycle-history-COLD.md', encoding='utf-8').read()

base_rows = s15_rows(base)
demoted   = base_rows[:8]      # the 8 that must move, byte-exact from baseline
retained  = base_rows[8:]
after_rows = s15_rows(work_claude)

fails = []

# 1) baseline had 13
if len(base_rows) != 13: fails.append(f'baseline §15 rows = {len(base_rows)} (≠13)')

# 2) symmetry: each demoted row appears exactly once in COLD, verbatim
for r in demoted:
    c = work_cold.count(r)
    if c != 1: fails.append(f'COLD count for {cid(r)} = {c} (≠1)')
    if r in work_claude: fails.append(f'demoted row still in CLAUDE.md: {cid(r)}')

# 3) retained 5 still present verbatim in §15
for r in retained:
    if r not in work_claude: fails.append(f'retained row missing from CLAUDE.md: {cid(r)}')

# 4) §15 after = 6 rows = retained(5) + new(1), retained IDs first in order
after_ids = [cid(r) for r in after_rows]
if len(after_rows) != 6: fails.append(f'§15 after rows = {len(after_rows)} (≠6)')
if after_ids[:5] != [cid(r) for r in retained]: fails.append(f'retain order changed: {after_ids[:5]}')
if after_ids[5:] != ['MASTER-CLI-S15-HOT-DEMOTE-003']: fails.append(f'new entry id = {after_ids[5:]}')

# 5) no blank line inside §15 table (separator immediately followed by first data row)
wl = work_claude.split('\n')
s = next(i for i, l in enumerate(wl) if l.startswith('## 15.'))
e = next(i for i in range(s + 1, len(wl)) if wl[i].startswith('## '))
sep = next(i for i in range(s, e) if wl[i].startswith('|---'))
cptr = next(i for i in range(s, e) if wl[i].startswith('> **§15 cold'))
gap = [i for i in range(sep + 1, cptr) if wl[i].strip() == '']
# allow exactly one blank: the one before the cold-pointer blockquote
if wl[sep + 1].strip() == '': fails.append('blank line immediately after separator (table split)')
if gap != [cptr - 1]: fails.append(f'unexpected blank line positions in §15 body: {gap} (expect only [{cptr-1}])')

# 6) symmetry counts
print(f'symmetry: demoted={len(demoted)}  appended-to-COLD={sum(work_cold.count(r) for r in demoted)}  '
      f'(exact-string 8=8 → {"OK" if all(work_cold.count(r)==1 for r in demoted) else "FAIL"})')
print(f'§15 hot: before={len(base_rows)}  after={len(after_rows)} (retain {len(retained)} + new 1)')
print('after IDs:', after_ids)

if fails:
    print('\n=== FAIL ===')
    for f in fails: print(' -', f)
    sys.exit(1)
print('\nALL STRUCTURE/SYMMETRY CHECKS PASS')
