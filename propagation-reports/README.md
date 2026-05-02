# Propagation Reports

> master → 자식 repo (GB/GD/GT) propagation cycle 결과 보고서.

## 위치 패턴

```
propagation-reports/
├── README.md                              # 본 파일
├── <cycle-id>/
│   ├── REPORT.md                          # cycle 별 propagation 결과
│   ├── DIFF.md                            # 변경 파일 sha before/after
│   └── VERIFY.md                          # cross-verify 결과 (3-repo sha 일치 확인)
```

## cycle ID 규약

- master cycle 자체 = `C<n>-<DOMAIN>-NNN` (`claude-cli-master/.ai/reports/`)
- propagation 결과 보고 = master cycle ID + `-PROPAGATE` suffix (`claude-cli-master/propagation-reports/`)
- 예: `C2-RULES-RESTRUCTURE-001` (master cycle) → `C2-RULES-RESTRUCTURE-001-PROPAGATE` (propagation 보고)

## 보고서 표준 구조

### REPORT.md

1. **Cycle 메타**: ID / 기간 / 영향 자식 repo / scope
2. **변경 파일 list**: master 의 변경 파일 + sha before / after
3. **propagation 명령**: 사용된 `scripts/propagate.sh` 호출 형태
4. **자식 repo 별 결과**: GB / GD / GT 각각의 cp 성공 여부 + commit hash
5. **cross-verify 결과**: 모든 sha 일치 확인 (`scripts/verify-sync.sh` 출력)
6. **incident**: propagation 중 발생 사고 (있으면)

### DIFF.md

각 변경 파일의 sha before / after 표 + diff 요약 (라인 수만 · 본문 X).

### VERIFY.md

`verify-sync.sh` 의 raw output 저장.

## 자동 생성

C3 cycle 완료 후 `bash scripts/report-gen.sh <cycle-id>` 호출 시 본 폴더 자동 생성.
