# MASTER-CLI-SOTMAP-REGISTER-001 — Propagation Report

> 생성: 2026-07-13T12:13:35+0900 (KST) · master content HEAD: ab937ed · contract: cc-paste-MASTER-SOTMAP-REGISTER-001 (authored-by cowork · 2026-07-12)

---

## 1. Cycle 메타

- cycle ID: MASTER-CLI-SOTMAP-REGISTER-001
- 마감일: 2026-07-13 (KST)
- Mode: M5 cli-infra-ops · production 0 LOC · doc(rule) 1 file · 비보호 · additive-only +7/−0
- 변경 파일: `docs/rules/sot-code-name-map.md` (§3 GD 표 6-row 삽입 + §8 dated note 1-bullet)
- 본질: GD 신설 화면(reply / daily-journal / return-notes feature) SoT↔code 매핑 등재 — map §7 갱신 trigger 정상 이행 · 전면 재매핑 X(§6-3 · STALENESS 배너 유지 · 기존 rows 무접촉).

## 2. §0 baseline gate (진입 cli 재측정 · 박제 금지)

| 항목 | 측정값 | 판정 |
|---|---|---|
| map 6-repo sha256 (진입) | `3aa71c62a038ae48…` 전량 일치 | STOP#4 미발동 ✓ |
| 6-repo HEAD | master 9e8a5e5 / FND 4a86f83 / GD eae5f60 = baseline 일치 · GB ba8d3b4 / GT ff5b76c / PDOCS 136ba98 = 전진 | §9 "GB/GT 자식 세션 마감 후 합류점" 정합 (drift 아님) ✓ |
| pending 6 rows (master map) | grep 0 hit | clean additive ✓ |

## 3. T1 disk 실측 확정 (A5 · row 사실 = 실측 인용)

| SoT 화면명 | 코드 화면명 | 카테고리 | 라우트 | disk 근거 |
|---|---|---|---|---|
| return-notes | ReturnNotesScreen.kt | 1:1 직매핑 | `Destination.ReturnNotes` | shared/settings · GDrn1 · enum App.kt:432 · 진입 back=Settings · label "돌아온 날의 기록"(ReturnNotesScreen.kt:40) |
| reply (shelf) | ReplyShelfScreen.kt | 1:1 명명 차이 | `Destination.ReplyShelf` | shared/reply · GDrs1 · App.kt:345 |
| reply (detail) | ReplyDetailScreen.kt | 1:1 명명 차이 | `Destination.ReplyDetail` | shared/reply · GDrd1 · App.kt:354 · back dynamic(replyDetailBackTarget :356) |
| reply (compose) | ReplyComposeSheet.kt | 1:1 명명 차이 | (시트 · 라우트 X) | shared/reply · GDrc1 · App.kt:361 overlay(Destination 부재) · composeOrigin=Shelf/JournalDetail |
| daily-journal (shelf) | JournalShelfScreen.kt | 1:1 명명 차이 | `Destination.Shelf` | shared/daily · GDsh1 · App.kt:439/276 |
| daily-journal (detail) | JournalDetailScreen.kt | 1:1 명명 차이 | `Destination.JournalDetail` | shared/daily · GDde1 · App.kt:438/260 |

**§8 dated note (등재 보류 · §2 T1 pending-4-외 · additive)**:
- `GDdj1` — 적기 바텀시트 [TARGET] · design-debt/L4 = 기존 `DailyJournalScreen.kt`(shared/daily · ModalBottomSheet) 의 design→code follow 대상 (daily-journal.ui-spec.json 명시).
- `GDrx1` — SourcesSheet · "참고한 기록" 소스 시트 · 전용 코드 화면 부재.
- 매핑 확정 = 별 판단.

## 4. T3 propagation 결과

- `propagate.sh docs/rules/sot-code-name-map.md --targets all` → **ok=5 / fail=0** (blanket --prune 미사용)
- map sha256 (hex64) 6-repo byte-identical:

| repo | HEAD (post-commit) | dirty | map sha256 |
|---|---|---|---|
| claude-cli-master | ab937ed | 0 | `98a3904fc58580fe5085abbc2aab661a4393ddeb33b6300c10687ecb46da1770` |
| app-foundation | 0aa8ef8 | 0 | `98a3904f…1770` |
| GentlyBreath | b2558f1 | 104 (WIP 무혼입) | `98a3904f…1770` |
| GentlyDay | 311909d | 68 (WIP 무혼입) | `98a3904f…1770` |
| GentlyTable | fcf7eae | 68 (WIP 무혼입) | `98a3904f…1770` |
| gently-product-docs | 9900d7e | 0 | `98a3904f…1770` |

- **unique sha count = 1** ✓ · 자식 path-limited commit name-only = `docs/rules/sot-code-name-map.md` 단일 (WIP 무혼입 실측)

## 5. verify-sync

- `verify-sync.sh` → **164 PASS / 0 DRIFT / MISS 5**
- MISS 5 = `docs/ops/production-cli-access-tokens.md` (master-only runbook · supabase-handling §3.1 의도적 6-repo 제외 · 본 cycle 무관 pre-existing · 자율 해소 X · exit 1 = MISS 한정 비차단)
- map file = 164 PASS 집합 소속 (DRIFT 0 = byte-identity 확증)

## 6. 검증 요약 (contract §3 / §7)

- additive-only: **+7 / −0** (git numstat 실측 · content commit "1 file changed, 7 insertions(+)" · 삭제 0)
- 보호 5 file sha drift 0 (edit-set ∩ 보호 = ∅ · `sot-code-name-map` ∉ protected-5 · manifest line 109 = 2026-05-10 BILLING-DOMAIN-ACTIVATE-001 history 서술 참조일 뿐)
- production / EF / DB / Money / 도메인 0 LOC
- T2 무접촉: §5 패턴 집계 재계수 X · STALENESS 배너 X · 기존 GD 13-row(Routes.* stale 포함) X

## 7. Negative Space Line

기존 rows 0 변경 · STALENESS 배너 무접촉 · §5 집계 무접촉 · production 0 · 자식 도메인 파일 0 · Money/EF/DB 0 · blanket --prune 미사용. 고려했으나 hot 제외: GDdj1/GDrx1 등재(§2 T1 pending-4-외 = §8 보류) · GD 기존 Routes.* stale row 정정(§6-3 rule-architecture 프로그램 소관).

## 8. 후속 (scope 외)

- GDdj1 / GDrx1 매핑 확정 = 별 판단 (§8 note)
- verify-sync stale-ref 5 (abbreviation-policy · code-principles · design-to-code-sync · domain-roles · workflow-core · = DIET-2-003 docs/rules 이동 후 .auto-memory 서술 미갱신 · pre-existing non-blocking)
- propagate.sh docs/ops exclude
- §15 hot 16 > 10 = **S15-HOT-DEMOTE-005** advisory (measure-gsm-cycle.sh Stop hook 자동 surface · 판정·이전 수동)
