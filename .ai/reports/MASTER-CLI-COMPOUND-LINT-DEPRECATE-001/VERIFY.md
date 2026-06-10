# VERIFY — MASTER-CLI-COMPOUND-LINT-DEPRECATE-001

## Verify Commands
| 명령 | Exit Code | 결과 |
|---|---|---|
| `find <6-repo> -name "compound-lint*" -not -path "*/.git/*"` | 0 | 출력 0 — 도구 전 6-repo 부재 (phantom 확정) |
| `git grep -in 'compound[-_ ]lint'` (master 진입 시점) | 0 | 115 줄 (-i 117) — 81/107 reconcile 입력 |
| `python3 -c "json.load(open('docs/schemas/ui-spec.schema.json'))"` (편집 직후 + 마감 재검) | 0 | PASS ×2 — JSON 구조 무결 |
| `git grep … 운영-live 비라벨 잔존` (master 마감) | 0 | **0** (기대 충족 — 잔존 = deprecate 라벨분 + 역사 이력행) |
| `bash scripts/propagate.sh <29 file> --targets all` | 0 | ok=145 fail=0 (29 × 5 자식) |
| `bash scripts/verify-sync.sh` | 0 | **PASS 160 / DRIFT 0 / MISS 0** (직전 cycle 동일 — 무회귀) |
| 자식 5-repo 운영-live 비라벨 잔존 grep | 0 | rule-routing-index:190(§F 역사행 · byte-identical) ×5 + GT docs/decisions 역사 1 — 전부 역사 분류 |
| `shasum -a 256 <보호 5>` (GB spot) | 0 | master 신 sha 5/5 일치 (8502c014 · e3b9891d · 4c566615 · 2ec100bf · ae20a79c) |

## 보호 5 신 sha 양층 (algorithm 라벨 명시 · 교차 금지)
| file | sha-256 (manifest layer) | git-sha1 (§14a layer) |
|---|---|---|
| docs/schemas/ui-spec.schema.json | `8502c01428fbc16fdcec55721951d6945d1e52e20fa10ceb13c230e37ea14eb0` | `8b46bb4952be03a7631b66096ba2b47e27a1c72a` |
| .claude/rules/uiux-sot-refresh.md | `e3b9891d4be592196a9dd713692407ff3bfb6b92248d981e80bda3dc823db959` | `d2c62265ceb0dfe934bb703f3a7c604c3c896f0f` |
| docs/design/design-sot-policy.md | `4c5666152f09009b16530009eff18ac789fa5f250785e35ed2a4fc997416f403` | `69649a36c75a221e1995a5f8437b2694db17fc42` |
| .claude/rules/pencil-uiux-workflow.md | `2ec100bfc601d8f5b28f4559e972cb850a4d7a1e667d9029f2b1a4a851669b9b` | `22570f97b7cabd4584feae323c1cfffc9896ae36` |
| docs/design/pencil-sot-policy.md | `ae20a79c42dcb59fee52dcabfa9a0285bb4727a3a4945098f622653b6b1ba7cf` | `acf88d95875094f415280e84345078bea5604fdc` |

## UNKNOWN
(없음)

## LOG
```
[LOG] 2026-06-10 KST
CMD: bash scripts/verify-sync.sh
EXIT: 0
STDOUT: PASS: 160 파일 · DRIFT: 0 · MISS: 0 — 모든 sha 일치
```
```
[LOG] 2026-06-10 KST
CMD: python3 -c "import json; json.load(open('docs/schemas/ui-spec.schema.json')); print('PASS')"
EXIT: 0
STDOUT: PASS
```
