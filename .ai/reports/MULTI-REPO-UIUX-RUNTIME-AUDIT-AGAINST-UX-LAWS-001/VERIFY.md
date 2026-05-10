---
정리위치: archive/
정리trigger: 본 task REVIEW.md PASS 또는 mtime 7일 경과
정리주체: cowork 자율 (또는 사용자 직접)
---

# VERIFY — MULTI-REPO-UIUX-RUNTIME-AUDIT-AGAINST-UX-LAWS-001

## Verify Commands

| 명령 | Exit Code | 결과 |
|---|---|---|
| `./gradlew :app:assembleDebug` (GentlyBreath) | 0 | PASS — APK 산출 |
| `./gradlew :app:assembleDebug` (GentlyDay) | 0 | PASS |
| `./gradlew :app:assembleDebug` (GentlyTable) | 0 | PASS |
| `adb install -r app/build/outputs/apk/debug/app-debug.apk` (3 repo 각각) | 0 | PASS — 패키지 활성 |
| `adb shell am start -W <pkg>/<launcher>` cold launch (3 repo) | 0 | PASS — TotalTime: GB 714 / GD 669 / GT 916 ms |
| `adb exec-out screencap -p > <png>` × 46 | 0 | PASS — 모두 비-zero size |
| `adb shell uiautomator dump /sdcard/ui.xml` + `adb pull` × 46 | 0 | PASS |
| `grep -oE 'text="[^"]*"' <xml>` text 인용 + bounds extraction (per-step tap target 좌표 산출) | 0 | PASS |
| `adb shell pm list packages com.example.gently...` 패키지 검증 (3 repo) | 0 | PASS |

## Verification Summary

- 진입 가능한 28+ 화면 모두 light + dark 양태 capture (총 46 PNG + 46 XML).
- §5 매트릭스 row 적용 및 §3 비권장 5 + Dark Patterns 5 detection 결과 = `matrix-results.csv` 에 row-단위 기록.
- Findings 13건 (F1~F13) 중 dark pattern 위반 0건 · borderline 1건 (F2 ACCEPTABLE) · regression risk 2건 (F3 / F12 affordance 단절) · BLOCKED 1건 (F7→F8 GD anon auth cascade).

## UNKNOWN (검증 불가 항목)

| 항목 | 사유 | 위치 |
|---|---|---|
| GD main · sleep · habits · reports · settings · ticket | 익명 부트스트랩 실패 (Supabase 익명 signup 응답 X) → 진입 차단 | `09_auth_light.xml` |
| Locale ko-KR | `adb shell su 0 setprop persist.sys.locale ko-KR` → "su not found" (rooted 권한 거부) | (UI 문구 자체는 한국어 strings.xml — 검증 영향 X) |
| AVD 모델 정합 | 사용자 의도 `Medium_Phone_API_36.1` 명시 + "신규 boot X" → 현 emulator-5554 = `Pixel_9_Pro` 사용 (해상도 1080×2400 동급) | (px 좌표 산출 영향 X) |

## LOG

```
[LOG] 2026-05-05 18:47 KST
CMD: ./gradlew :app:assembleDebug (3-repo parallel)
EXIT: 0 / 0 / 0
STDOUT: BUILD SUCCESSFUL · APK at app/build/outputs/apk/debug/app-debug.apk

CMD: adb -s emulator-5554 install -r <apk> (3-repo)
EXIT: 0 / 0 / 0
STDOUT: Success

CMD: adb -s emulator-5554 shell am start -W <pkg>/<launcher>
EXIT: 0 / 0 / 0
STDOUT: TotalTime: 714 (GB) / 669 (GD) / 916 (GT) ms

CMD: bash scripts/cap.sh <repo> <screen> <state>  (× 46)
EXIT: 0 (모두)
STDOUT: <png-size>B + <xml-size>B (모두 non-zero)

CMD: adb shell uiautomator dump /sdcard/ui.xml ; adb pull /sdcard/ui.xml <out>
EXIT: 0 (× 46)

CMD: grep -oE 'text="[^"]*"' <xml> | sort -u  (per-screen text 인용 추출)
EXIT: 0
STDOUT: EVIDENCE.md "핵심 텍스트 인용" 섹션 참조

CMD: adb -s emulator-5554 shell su 0 setprop persist.sys.locale ko-KR
EXIT: 1
STDERR: /system/bin/sh: su: not found  → UNKNOWN(rooted 권한 거부 · UI strings.xml 한국어 → 검증 영향 X)
```
