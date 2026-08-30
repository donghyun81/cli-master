# Verification and Review Rules

> /verify 와 /review 단계의 상세 규칙.
> SOT: `CLAUDE.md` | 관련: `workflow-core.md`, `cycle-discipline.md`

---

## 0. 자(尺) 규율 — 재기 전에 자를 검사한다 (= /verify · /review 공통 선행)

> **한 줄**: 틀린 자로 잰 값은 **틀린 줄도 모른 채 통과한다.** 아래는 실측에서 반복 발현한 자 결함만 모았다 — 재기 전에 이 절을 먼저 통과시킨다.
> **신설**: `MASTER-ENGINEERING-BASELINE-001` (2026-08-29). 규율의 출처 = 그 트랙의 ㉣ 자 규율 K-133 · K-136~K-141.

### 0.1 범위의 자

- ★**K-141 — 부분 적용은 전면 적용의 알리바이가 아니다.** 「일부 고쳤다」가 「전부 고쳤다」의 근거로 쓰이는 순간 나머지는 **영영 안 잡힌다**. 분모는 **구조 경계**(file · 절 · 트리 · 심볼 집합)로 잡는다 — ★**임의 행 창(`NR>=100 && NR<=200` · `head -50` · 스크롤에 보인 만큼)은 분모가 아니다.** 분모를 못 잡으면 「전면」이라 쓰지 않는다.
- **K-140 — 금지 문면의 목적어를 본다.** 금지 규칙을 인용하기 전에 **그 금지가 무엇을 금지하는지** 확인한다(대상 · 예외 · 적용 층). ★**선례가 정본이다** — 같은 자리에서 이미 어떻게 했는지가 문면 해석보다 강하다. 문면과 선례가 갈리면 선례를 따르고 **그 사실을 보고한다**(문면 정정은 별 판).
- **부재 판정** = 전수 트리에서만 (= [`code-principles.md`](./code-principles.md) §2). subset 위의 「없다」는 **무효**다.
- ★**도구가 잡는 범위를 판정하려는 범위로 쓰지 않는다.** 자를 lint · 포매터 · IDE · 컴파일러에 위임할 때는 **그 도구가 재는 축**을 먼저 적고 **판정 명제의 축과 대조**한다. 두 축이 다르면 도구는 **자기 축에서 옳고 판정에서 틀린다** — 에러도 0 도 안 나므로 **양성 대조군에 안 걸린다**(= 「깨끗함」과 「안 쟀음」이 같은 출력을 낸다).
  - **실측** = 「UI 직접 소비처 0」(**사용 축**)을 ktlint `no-unused-imports`(**import 축**)로 재서 **일부만 잡고 22 를 남겼다** (자 = 사용 축 census · `App.kt` · 2026-08-30 · 단위 = 획득 건). ★**그 rule 은 침묵이 옳았다** — `val x = koinInject<T>()` 는 `T` 를 **타입 인자로 참조**하므로 `T` 의 import 는 **살아 있다**. 도구가 고장난 게 아니라 **다른 축에 겨눠져 있었다.** 덧붙여 그 ruleset 에는 사용 축 rule 자체가 없고(`.editorconfig` `ktlint_standard` 단독 · 빌드 주석 「추가 룰 0」), 게이트도 `ignoreFailures=true` **warn** 이었다 — **자도 채널도 판정 축이 아니었다.**
  - ★**「자가 했다」를 신뢰의 근거로 적지 않는다.** 「**무엇으로 쟀나**」 옆에 「**그 자가 무슨 축을 재나**」를 **함께** 적는다. 앞만 적힌 보고는 자를 **검사받지 않은 채** 통과시키고, 그 통과가 다음 사람의 분모가 된다.

### 0.2 좌표의 자

- ★**K-136 — `grep -rn` 출력의 *파일명* 을 읽어라.** 재귀 grep 의 출력은 `path:line:본문` 이다. **행 번호만 옮기면 파일이 바뀐다** — 다른 file 의 행 번호를 원하는 file 의 좌표로 인용하는 사고가 여기서 난다. **좌표 인용 = `path` | `line` | `anchor` 3칸 전량**을 적고, 인용 전에 **round-trip**(그 좌표를 다시 열어 anchor 문자열이 그 행에 있는지) 한다.
- ★**K-138 — 필터 창 좌표 금지.** 필터를 건 출력(`grep … | head` · `awk '/x/'` · `--include` 로 좁힌 결과)의 **행 번호를 좌표로 쓰지 않는다.** 필터 출력의 번호는 **원본 좌표가 아니거나**(재번호) **원본의 일부만 반영**한다. 좌표는 **원본 재조회로만** 확정한다.
- **행 번호는 움직인다**: 편집을 한 번이라도 했으면 **재측값만** 인용한다(편집 후 재 `grep -n`).
- ★**K-136-⑵ — 좌표는 rev 를 동반한다** (= 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-002`). 좌표의 완전형은 `path` | `line` | `anchor` 에 **rev 를 더한** `<rev>:<path>:<line>` 이다. **다른 rev 에서 뽑은 행 번호를 현 rev 의 좌표로 적는** 사고가 여기서 난다 — `git show <sha>:<path>` · `git log -p` · 리뷰 diff 는 **전부 다른 rev** 이고, 그 출력의 행 번호는 **HEAD 의 것이 아니다**. **실측** = `git show 85fcaf5:App.kt` 의 `:371`·`:444` 를 HEAD 좌표로 적었으나 HEAD 실물은 `:373`·`:446` 이었다(= 선행 판이 파일을 `1599 → 1604` 로 밀었다) — ★**round-trip 이 잡았다**. ⟹ **rev 없는 좌표는 「지금」으로 읽힌다**. 지금이 아니면 rev 를 적고, 적을 수 없으면 **현 rev 로 재측해서** 적는다. (= §0.4 K-139 「정정은 자까지 내려간다」 정합 — 좌표를 고치는 게 아니라 **좌표를 뽑은 rev 를 고친다**.)
- ★**출력 형태를 가정하고 필터를 짜지 않는다.** `grep -rn` 출력이 `path:line:본문` 인지 `line:본문` 인지는 **고정이 아니다** — **구현**과 **대상(단일 file / 디렉터리)** 에 따라 갈린다. **실측**(2026-08-30 · 단위 = 관측) = 같은 명령이 저작 환경(GNU grep)에서는 단일 file 에 접두를 **안 붙였고**, 집행 환경에서는 **붙였다**(`ugrep` shim · `/usr/bin/grep` = BSD grep 2.6.0 · **둘 다 접두 O**). ⟹ `sed 's/^[^:]*:[0-9]*://'` 류의 **경로 제거 필터가 통째로 불발**하고, 뒤따르는 주석 제외가 **아무것도 못 거른 채 통과**한다 — ★**계수는 그대로인데 「걸렀다」로 읽힌다.**
  - **처방** ⑴ ★**형태를 강제한다** — 접두가 필요하면 **`-H`**, 불필요하면 **`-h`** 를 **명시**한다(구현 기본값에 맡기지 않는다). ⑵ ★**양성대조** — 필터 전/후 수가 **같으면** 「걸릴 게 없었다」가 아니라 **필터가 안 걸린 것부터** 의심한다(= §0.6 양성대조 의무 동형). ⑶ 본 항은 **§0.7 환경의 자**의 **좌표 축 instance** 다 — 자가 아니라 **자를 돌리는 환경**이 값을 바꾼 경우.

### 0.3 계수의 자

- ★**K-133 — 리터럴 계수는 사용처가 아니다.** `grep -c <심볼>` 은 **주석 · KDoc · 설명문 · 이력 블록**까지 문다. 「N 곳에서 쓴다」를 그 수로 말하면 틀린다 — **구조를 지시하기 전에 뿌리(정의)와 KDoc 근거를 읽는다.** 사용처를 세려면 정의 · 호출 · 문자열 언급을 **분리해서** 센다.
- **주석 제외 census 가 기본값**: 코드 축 계수는 주석/문자열을 제외하고 센다(제외하지 않았으면 **그 사실을 적는다**). 문서 축 계수는 **헤더 · 구분행 포함 여부를 자가 스스로 말한다** — 「표 4행」이 헤더 포함인지 아닌지 안 적으면 다음 사람이 다른 수를 얻는다. ★**단위를 병기한다** — `행` / `출현` / `file` / `T` / `hit` / `바이트` 중 무엇인지 수 옆에 적는다. 실측 = 「10 행」과 「11 출현」이 **다른 수**였고(한 행에 2 출현), 「399B」는 **개행 제외** 바이트였다(`wc -c` = 400). **단위 없는 수는 재현되지 않는다.**
- **K-137 — `git diff` 3 함정** (범위형 rev 를 **명기**한다):
  1. 인자 없는 `git diff` 는 **unstaged 만** 본다 — staged 변경이 안 보인다(→ `--cached` 또는 `git diff HEAD`).
  2. `git diff HEAD` 는 **untracked file 을 못 본다** — 신설 file 이 census 에서 통째로 빠진다(→ `git status --porcelain` 병행 · `--no-optional-locks`).
  3. `A..B` 와 `A...B` 는 **다른 것을 잰다** — 세 점은 **merge-base 기준**이라 갈린 뒤 대상 쪽에 들어온 변경을 뺀다. 어느 쪽을 썼는지 적지 않은 diff 수치는 재현 불가다.
  - 커밋 file 집합 대조는 diff 가 아니라 **`git show --name-only <sha>`** 로 한다 (= `disk-verification` skill §5 · diff 기준 자기 점검은 커밋 오염을 못 잡는다).
- ★**자기 제외 — 자를 문면에 적어 넣는 순간 그 file 이 자기 hit 를 낸다.** 규약 file 에 자를 병기하면 계수가 **1 늘어난다**(실측 = 자 병기 직후 `15 → 16` · `23 → 24` · 단위 = file). 문면에 적는 자에는 **자기 제외**(`grep -v '<본 file>'`)를 넣고, **왜 뺐는지**를 같은 자리에 적는다 — 뺀 사실이 안 적히면 다음 사람이 **다른 분모**를 얻는다. ★**게이트 블록은 verbatim 실행 대상**이라 같은 규칙을 적용하지 않는다(거기서 자기 제외를 넣으면 게이트가 문면과 갈린다) — **두 자리는 따로 판단한다.**
- ★**표를 만지는 계약에는 「헤더 파이프 수 ↔ 각 데이터행 파이프 수」 대조를 건다** (= **행별 칸 수** 자). 행 수 · 글리프 · 문자열 계수는 **칸이 덮여도 안 변한다** — 실측 = 의존 칸 6 행이 덮였는데 게이트 10 항이 **전량 green** 이었다.
  - ★**한계 2 를 병기한다**(둘 다 **위양성**): ⑴ **코드 스팬(백틱) 안의 파이프** ⑵ **이스케이프 파이프**(`\|`). 실측 = 선재 4 행 + 이 자의 **첫 실행**이 `reporting.md` §15.1 축 3 행에서 `\|` 2 개를 물어 `4 → 6` 으로 셌다. ⟹ **제거 후 계수**가 정본이다. 병기하지 않으면 다음 판이 **위양성을 결함으로 오판**한다.
  - ★**음성 대조군을 동반한다** — 칸을 하나 일부러 지워 자가 **FAIL 을 내는지** 확인한 흔적. 통과만 기록된 자는 **안 돈 자와 구별되지 않는다**(= `/verify` §기본 원칙 음성 대조 정합).

### 0.4 정정의 자

- ★**K-139 — 정정은 자까지 내려간다.** 수치가 틀렸으면 **문면만 고치지 말고 그 수치를 낸 명령을 고친다.** 명령을 안 고치면 **다음 회차에 같은 틀린 수가 다시 나온다**(= 정정이 아니라 임시 봉합). 정정 보고에는 **① 틀린 값 ② 옳은 값 ③ 자를 어떻게 고쳤나** 셋을 적는다.
- ★**자 대조표 의무**: **수치를 인용하는 보고는 「자의 이름 ↔ 자를 낸 명령」 표를 동반한다.** (= [`reporting.md`](./reporting.md) §8.1 「수치 인용 = 산출 명령 + 환경 동반」의 **형식화** · 본문 SoT 는 그쪽 · 여기서 재복제하지 않는다.) 명령 없는 수치 = **재현 불가 = 근거 아님.**

### 0.5 순서·정렬의 자

- ★**K-154 — 표의 정렬 방향은 표가 말하지 않는다.** 「최신 / 최고령 / 우선순위 / 다음 차례」를 표에서 읽을 때, **행의 물리적 순서에 의미가 있는지와 그 방향은 표 자신이 안 적는다.** 날짜 열이 있어도 **같은 날짜면 안 갈린다**.
  - **판정 절차** = ⑴ 그 표를 **마지막으로 만진 commit 을 연다** (`git log -p -1 -- <file>` 또는 `git log -S<식별자>`) ⑵ **무엇을 어디서 빼고 어디에 넣었는지**를 본다 ⑶ 그것이 정본이다 (= §0.1 「**선례가 정본**」[K-140] 의 정렬 축).
  - **실측** = master `CLAUDE.md` §15 hot 3 행이 **마감일 전부 동일**해 날짜로 안 갈리는데, 어느 발주가 「마지막 행 = 최고령」으로 **가정**해 **최신을 demote 하라고 지시**했다. 선례 commit 은 **맨 위 행**을 내리고 신 entry 를 **맨 아래**에 붙인다 — 지시대로였으면 헌법 §15 「최근 3 entry 만」을 **정면으로** 깼다.
- ★**K-154-⑵ — 게이트에는 판정 결과를 「이름」이 아니라 「계약 축」으로 넣는다.** 게이트가 **특정 식별자를 하드코딩**하면, 집행자가 **옳게** 집행해도 게이트가 FAIL 을 낸다 (= **게이트 결함이지 집행 결함이 아니다**).
  - **처방** = 「그 이름이 있나」가 아니라 **「계약이 성립하나」**를 잰다. 예: 「`X` 가 COLD 에 있나」(이름) → **「진입 집합에서 사라진 항이 COLD 에 있나 · 없어진 것 중 유실 = 0 인가」**(집합 차).
  - **실측** = `MASTER-ENGINEERING-BASELINE-001` 의 G19 둘째 칸이 entry 이름을 박아, cli 가 **정확히 옳게** demote 했는데 `0` 이 나왔다. ★**이것이 같은 판이 심은 「파일 무접촉 ≠ 계약 무접촉」(K-131 · 본문 = [`disk-verification/SKILL.md`](../../.claude/skills/disk-verification/SKILL.md) §4 ⑥ 세부)의 실증이다.**

### 0.6 명제의 자

- ★**전칭 명제에는 전칭 자.** 명제가 「**…이 0 이다**」 · 「**전량**」 · 「**불변**」이면 자도 **전수**여야 한다. **게이트가 명제보다 좁으면 PASS 는 명제의 통과가 아니라 자의 통과**다 — 그 PASS 를 근거로 쓰는 순간 **안 잰 부분이 「참」으로 승격**한다. 전수 자를 못 붙이면 **명제를 한정형으로 다시 쓴다**(「미등재가 0」 → 「ID 3 개가 등재됐다」).
  - **실측 2** (= 둘 다 **전칭**을 좁은 자로 잰 것): ⑴ 명제 「§12 에 미등재 cycle ID 가 **0**」 ↔ 게이트는 **ID 3 개만** 셌다 ⟹ 접수 후 **잔여 2** 가 드러났다. ⑵ 명제 「총 **130 불변**(신설 0 · 삭제 0)」 ↔ 게이트는 **행 수만** 셌다 ⟹ **칸이 덮여도 130**.
- ★**명제 ↔ 게이트 대응표를 적는다.** 명제마다 **그 명제를 재는 게이트 항**을 적고, ★**명제보다 좁은 자에는 그 사실을 적는다**(「G2 는 P2 의 부분집합을 잰다」). 대응이 안 적힌 게이트는 **무엇을 지키는지 모르는 채** 돌고, 읽는 사람이 **자를 명제로 착각**한다.
  - ★**가장 흔한 어긋남 = 절을 지정한 명제를 file 전체 grep 으로 재는 것.** 「§0.1 **에** X 가 있다」를 `grep -c X <file>` 로 재면 **X 가 어느 절에 있든 통과**한다 — **필요조건이지 충분조건이 아니다.** 절에 묶인 명제는 자도 절에 묶는다.
  - ★★**K-163 — 절 결속 자의 종료 앵커는 「다음 절 번호」가 아니라 「형제 이상 깊이의 헤딩」이다** (= 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-002` 신설). **구 문면** = ~~``awk '/^### 0\.1 /{f=1;next} f&&/^### 0\.2 /{exit} f'``~~ (= 병기 보존 · 삭제 0). ★**다음 절 번호를 못 박으면 그 절이 file 의 마지막 절일 때 다음 번호가 없어 awk 가 EOF 까지 먹는다** ⟹ **footer · 이력 줄이 절 본문으로 들어온다.** 자가 죽은 게 아니라 **범위가 조용히 넓어진다** — 에러도 0 도 안 나므로 안 걸린다.
    - **교정형** (= `###` 절) = `awk '/^### 0.1 /{f=1;next} f&&/^#{2,3} /{exit} f'`.
    - ★**종료 깊이는 앵커 깊이에 맞춘다 — 고정 문자열이 아니다.** 종료 앵커 = **앵커 깊이 이하**의 헤딩. `###` 앵커 → `^#{1,3} `(실용형 `^#{2,3} `) · `##` 앵커 → `^#{1,2} `. ★**`##` 앵커에 `^#{2,3} ` 를 쓰면 첫 하위 절에서 끊겨 이번엔 반대로 너무 좁게 잰다**: 실측 = 본 file `## 0.` 를 `^#{2,3} ` 로 결속하면 **4 행**(= 머리말만 · `### 0.1` 에서 끊김)이라 「K-133 이 §0 에 있다」가 **1**, 깊이 정합형 `^#{1,2} ` 는 **57 행 · 2**, file 전체도 **2**. ⟹ ★**한 명제에 또 세 값**이다. **넓은 자와 좁은 자는 같은 병의 양끝**이고, 고르는 기준은 **앵커의 깊이** 하나다.
    - ★**양성대조 의무 1 줄** — 절 결속 자에는 **절 본문 행수**를 **같이** 낸다. **0 이면 자가 죽은 것부터 의심**한다 (= 「깨끗함」과 「안 쟀음」이 같은 출력을 낸다 · §0.1 마지막 bullet 정합).
    - **실증** (= 2026-08-30 · `cycle-discipline.md` · 명제 = 「`### 33)` **절이** 「지시·판단」을 담는다」 · 단위 = 행):

| 자 | 값 | 판정 |
|---|---|---|
| `grep -c '지시·판단' <file>` | **2** | file 전체 = **명제보다 넓다** |
| 구 문면형 `f&&/^### 34/{exit}` | **1** | ★**거짓** — `### 34)` 부재(`grep -c '^### 34)'` = **0**)라 EOF(= 189 행)까지 먹어 **footer `:186`** 을 셌다 |
| 교정형 `f&&/^#{2,3} /{exit}` | **0** | ★**참** — 절 본문(`:172` 이하 **10 행**)에 0 |
| 양성대조 = 절 본문 행수 | **10** | 자 생존 (= 0 이 아니므로 「안 쟀음」 아님) |
- **인접 — 재복제하지 않는다**: 「게이트를 **어떻게 쓰나**」의 본문 SoT 는 §0.5 **K-154-⑵**(계약 축) + [`disk-verification/SKILL.md`](../../.claude/skills/disk-verification/SKILL.md) §4 ⑥ **K-131 · K-143 · K-152** 다. 본 §은 「**명제와 게이트를 어떻게 잇나**」만 소유한다.

### 0.7 환경의 자

> **신설**: 2026-08-30 `MASTER-DOC-MANIFEST-SWEEP-002` (= ㉣ **K-162**). 근거 = 발주 게이트가 **저작자 환경에서만** 검증된 채 발행된 실사고.

- ★★**K-162 — 자의 생존은 환경에 상대적이다.** 저작 환경에서 산 자가 **집행 환경에서 죽는다.** 그리고 ★**죽은 자는 에러를 안 낸다 — `0` 을 낸다.** 그 `0` 이 계약의 **「후」값과 같으면 한 줄도 안 고쳐도 green** 이다 (= 「깨끗함」과 「안 쟀음」이 같은 출력을 낸다 · §0.1 마지막 bullet 의 **환경 축**).
- **분모는 집행자 환경이다.** 발주 게이트는 **집행자의 shell · grep · awk** 로 성립해야 한다. ★**발행 「전」 자기 실행은 이 축을 구조적으로 못 잡는다** — 그때 도는 것은 **저작 환경**이다. ⟹ 발행 **「후」 xverify 에 「환경 분모」 항**을 둔다.
- ★**측정 없이 flavor 를 단정하지 않는다.** 「macOS 니까 BSD grep 이고 GNU 확장은 죽는다」는 **가정**이다. **실측** (= 2026-08-30 · 본 repo 집행 환경 · 단위 = 관측):

| 축 | 실측 | 함의 |
|---|---|---|
| `uname -s` | `Darwin` | — |
| `grep` | ★**binary 가 아니라 shell function**(harness 주입) → `ugrep 7.5.0` `-G` + `--ignore-files --hidden -I --exclude-dir=.git` | ★**대상 집합이 바뀐다** — gitignore 된 file 이 **조용히 분모에서 빠진다** |
| `/usr/bin/grep` | `BSD grep 2.6.0-FreeBSD (GNU compatible)` | 「BSD = GNU 확장 없음」이 **거짓** |
| `\b` (단어 경계) | 두 grep **모두 동작**(`1`) | 저작 측 예측(「BSD 면 항상 0」) **반증** |
| `\|` (BRE 교대) | 두 grep **모두 동작**(`a`→`1` · `z`→`0`) | — |
| `awk` | `one-true-awk 20200816` · 구간식 `{2,3}` **동작** | §0.6 절 결속 자 **생존** |

- ★**그러므로 규정은 「어느 flavor 인가」가 아니라 「무엇을 쟀나」로 쓴다**:
  1. ★**GNU 전용 구문은 선례 실증이 있는 것만.** `\b` 는 **POSIX 아님** — 대체 가능하면 **`grep -w`** 로 쓴다(= 이식 가능 · 실측 동일값 `1`). ★**「이 환경에서 됐다」는 다음 환경의 근거가 아니다.**
  2. ★**교대는 `-e A -e B` 를 기본값**으로 쓴다(= BRE `\|` 는 확장). 단 ★**「`\|` 금지」를 낱말로만 적으면 과잉 자가 된다** — `awk '/^\| cycle ID/'` 의 `\|` 는 **ERE 에서 파이프가 메타문자**라 **이스케이프가 정규 표기**다(POSIX). ⟹ 금지 대상은 **grep BRE 의 교대 `\|`** 이지 **awk 정규식의 리터럴 파이프**가 아니다 (= §0.6 「자가 명제보다 넓으면 고친다」의 **대칭**).
  3. ★**대상 집합도 환경이다.** 패턴 의미만이 아니라 ★**무엇이 검색되는가**가 환경에 따라 바뀐다(위 표 `--ignore-files`). ⟹ **전수 주장에는 쓴 grep 을 적는다** — `grep` / `/usr/bin/grep` / `git ls-files` 는 **서로 다른 분모**다.
  4. ★**음성대조로 확정한다.** 「이 구문이 이 환경에서 사나」는 **적는 것이 아니라 재는 것**이다 — **죽었을 때의 값을 모사**해(예: `\b` → literal `b`) 그 값이 **계약값과 같지 않은지** 본다. 실측 = `\bbar\b` → `1` · 모사 `bbarb` → **`0`** · `grep -w bar` → `1`. ★**모사값이 계약값과 같으면 그 게이트는 판정 불능**이다.
- ★**게이트 출력에 경고를 섞지 않는다.** `awk -v h="…\.…"` 처럼 **불필요한 이스케이프**를 넘기면 구현에 따라 `awk: warning: escape sequence '\.' treated as plain '.'` 가 **stdout 한가운데** 찍힌다. 리다이렉트로 지우는 것이 금지된 맥락에서는 **경고를 없애는 것이 유일한 해결**이다 ⟹ 동적 앵커에는 **백슬래시를 넣지 않는다**(`.` 는 임의 1 문자로 충분).

---

## /verify 규칙

### 기본 원칙
- **0 command 금지**: 검증 명령 없이 VERIFY.md만 만드는 것은 허용되지 않는다
- 최소 1개 검증 명령을 실행하고 exit code를 기록한다
- 검증 명령은 PLAN.md의 VerifyCmds에 명시된 것을 우선 사용
- **명령 흔적 필수**: VERIFY.md 에 백틱 래핑 명령(테이블) 또는 `CMD:` 패턴(LOG) 이 1개 이상 있어야 한다 — 부재 시 VERIFY 미통과 (reviewer 판정 블로커 · 구 compound-lint 3b 검사 = deprecated · 도구 부재)
- **production 바인딩 실체 검증 의무** (DI / seam / 조합 루트 변경 시): "production 조합의 X 가 **실제로 무엇인지**" 를 검증 항목으로 둔다. 형태 2 가지 **모두** 요구:
  - **① identity assertion** — `assertSame(기대 인스턴스, 해석 결과)`. **타입 assertion 은 부족하다**: `assertTrue(x is EntitlementRepository)` 는 NoOp 기본값 부활을 **못 잡는다**(NoOp 도 같은 타입 · `FND-BILLING-SEAMS-S1-001` 실증). "무엇이 아닌지"(`assertNotSame` / `assertFalse(x is NoOpX)`)까지 명시.
  - **② 음성 대조(negative control)** — 가드를 **일부러 깨보고 FAIL 하는지** 확인한 흔적. 통과만 기록된 테스트는 **공허한 테스트와 구분되지 않는다** (`SELFWARD-ENTITLEMENT-WIRE-S0-001` / `SELFWARD-COMPOSITION-ROOT-S2-001` 실증 = 음성 대조 3/3 FAIL 확인).
  - 근거 정합: `code-principles.md` §2 암묵 기본값 금지 · `billing-rules.md` §1 명시 조합 paradigm (도구는 *structural presence* 만 본다).
- **실 데이터 검증 의무 (빈 계정 금지)** — 사용자 데이터를 **입력으로 쓰는 경로**(특히 유료·생성·AI)는 **실 데이터가 있는 계정**으로 검증한다. 빈 데이터로 도는 검증은 **데이터 의존 결함을 구조적으로 못 잡는다**(입력이 없으면 그 코드가 실행되지 않는다). 검증용 **seed 계정을 자산으로 유지**한다(1회성 계정 금지 · 재현 가능해야 한다).
  - 실측 근거: **F2** — 기록 **0건** 계정은 `200`, **실 기록** 계정은 `502`. 빈 계정만 쓴 탓에 "AI 기능이 **한 번도 작동한 적 없다**"는 사실이 **몇 달간** 검출되지 않았다.
- **성공 경로 관측 가능성 선행 의무** — **성공을 관측할 수 없으면 그에 의존하는 변경은 검증 불가**다. 성공/실패를 **원장(로그·계측)으로 가를 수 있게 만든 뒤에** 그 경로를 바꾼다(관측 → 변경 순서 · 역순 금지).
  - 실측 근거: 관측 확보(①)를 변경(②)보다 **먼저** 한 순서의 근거. ②가 같은 3 시도를 **성공 1 · 실패 2** 로 실제로 갈랐다 — 관측이 없었다면 어느 쪽도 증명 못 한다.
- **외부 응답 검증 실패 경로 = 진단 가능 로그 의무** — 외부(모델·서드파티) 응답의 검증/파싱이 실패하는 경로는 **① 분기 식별자**(어느 검증에서 떨어졌나) + **② 원문 발췌(상한 명시)** + **③ 에러 메시지** 를 남긴다. "실패했다"만 남는 로그는 **다음 cycle 에도 같은 미지**를 남긴다.
  - **마스킹 의무**: 발췌 대상 = **모델 출력 한정**. **사용자 원문 · 키 · 토큰 = 제외**(= `safety-and-secrets.md` §시크릿 기록 금지 정합 · 로그도 파일이다).
  - 실측 근거: **A1 로그 1개**가 F2 의 미지를 **한 cycle 안에** 닫았다 (그 전까지는 재현 자체가 불가능했다). EF 측 정착 = `supabase-handling.md` §11.
- **native `/verify` bundled skill (2026-05-27 · MASTER-CLI-NATIVE-RUN-VERIFY-SANDBOX-INTEGRATION-001)**: Anthropic v2.1.145+ 의 `/verify` 는 build + 실 앱 실행으로 코드 변경을 확인한다(test/type-check fallback 회피). manual 검증 명령(`./gradlew ...` + `adb ...`) 또는 `/verify` bundled skill 양쪽 사용 가능 — cli session 자율 · 단 "0 command 금지" 정합. 자식별 launch recipe = `.claude/skills/run-<name>/SKILL.md`(`/run-skill-generator` capture) · staging flavor 한정

### 검증 명령 실행 불가 시
불가피한 이유가 있으면:
1. UNKNOWN(사유) 명시
2. 제품 파일 변경 없이 STOP
3. 사용자에게 직접 실행 방법 안내

### VERIFY.md 필수 항목
- 실행된 명령과 인수
- 각 명령의 exit code
- 명령 stdout/stderr 핵심 내용
- UNKNOWN 항목 (검증 불가 사유)

### 허용 검증 명령 유형

| 유형 | 예시 |
|---|---|
| 정적 파일 확인 | `git diff -- <file>`, `grep -n <pattern> <file>` |
| Lint | `./gradlew ktlintCheck` (자식 product-layer warn-gate) |
| Git ignore 확인 | `git check-ignore -v <path>` |
| 빌드 (제품 변경 없는) | `./gradlew assembleDebug` (설정 변경 없을 때만) |
| 단위 테스트 | `./gradlew test` |

### 산출물·시크릿 검증 (권장 · 구 Compound Lint = deprecated)

> 구 compound-lint 도구 = 4-repo 부재 (deprecated · MASTER-CLI-COMPOUND-LINT-DEPRECATE-001). 검증 의무는 아래 실존 명령으로 수행한다.

```bash
ls .ai/reports/<taskId>/        # 산출물 존재 확인 (형식 SoT = reporting.md §1 표 대조)
bash scripts/agent/secret-scan.sh .ai/reports/<taskId>/
```
시크릿 scan: **exit 0 = PASS · exit 1 = FAIL (시크릿 감지 — 즉시 STOP)**. 패턴 SoT = `safety-and-secrets.md` §시크릿 스캔 패턴 · **실행 진입점 = `scripts/agent/secret-scan.sh` 단일** (= 2026-07-29 `MASTER-CLI-CONTEXT-DIET-3-001` · 구 판은 같은 정규식이 4곳에 복제돼 이미 미세 발산[`AIza[0-9A-Za-z\-_]` vs `[0-9A-Za-z_-]`]이 있었다 — 보안 패턴이 갈라지면 한쪽만 못 잡는다).

---

## /review 규칙

### Risk 기반 리뷰 경량화
- **Low Risk**: VERIFY.md (빌드/테스트 통과 확인) + 3-section REVIEW (Requirements, Regression, Secrets). **UI 레이어 변경(Screen/ViewModel/UiState 신규·수정) 포함 시 §5 Model Separation 추가 필수** (= [`docs/agent/architecture/MODEL_SEPARATION.md`](../../docs/agent/architecture/MODEL_SEPARATION.md) 정합); **UI visible-state(FULL) 변경 포함 시 §14 Design SoT Sync 추가** (= `uiux-sot-refresh.md` "즉시 의무 vs Deferred" 분기 정합). PromptFit 선택.
- **Medium Risk**: 현행 12-section REVIEW + PromptFit 필수.
- **High Risk**: 12-section REVIEW + PromptFit + 독립 reviewer 실행 필수.

### 기본 원칙
- 근거 없는 단정 금지 (CONFIRMED / INFERRED / UNKNOWN으로 분류)
- VERIFY PASS 없이는 review를 PASS로 판정하지 않는다
- REVIEW.md 는 12-section 정규 스키마로 작성 (형식: `docs/rules/reporting.md` §7)

### REVIEW.md 12-section 체크리스트

| 섹션 | 판정 기준 | 블로커 |
|---|---|---|
| 1. Requirements Coverage | `.ai/tasks/<taskId>.md` 성공조건과 대조 | 블로커 |
| 2. Regression Risk | 변경 파일 영향 범위 검토 | 블로커 |
| 3. Architecture Integrity — SOLID | 단일 책임 위반·과도한 추상화 없음; DTO·Entity·DomainModel·UiState 분리 유지; 오류 모델 선택 근거 명시 | 블로커 |
| 4. Architecture Integrity — Layer Boundaries | domain→data import 없음(I2 불변 원칙); 경계 매핑이 Repository·UseCase·ViewModel 에서만; UiState 가 DomainModel 과 분리됨; **app/feature/platform 레이어가 정책 계산을 새로 소유하지 않음**; **동일 UI 개념이 단일 출처 모델 또는 단일 포매터 경로를 사용함(단일 출처 표시 규칙)**; **서버 부재 경로가 live implementation으로 기술되지 않음(UNKNOWN/DEFERRED/contract-only만 허용)** | 블로커 |
| 5. Model Separation | UiState 분리; UI 단방향 흐름; 경계 매핑 변환 위치 (해당 task 에 적용될 때) | 블로커 |
| 6. Dependency Governance | libs.versions.toml 변경 시 PLAN DependencyDecision 8개 항목 존재 (없으면 FAIL) | 블로커 |
| 7. TDD Evidence & Testability Seams | 기존: FakeXxx 존재 또는 N/A 사유; StateFlow 테스트; 심(clock·dispatcher·identity·logger·uuid) 테스트 또는 연기 사유. **DI/seam/조합 루트 변경 시: production 바인딩이 identity assertion(`assertSame`)으로 고정되고 음성 대조(가드를 깨보고 FAIL 확인) 흔적이 있음 — 타입 assertion 단독 = 미충족**(`/verify` §기본 원칙 "production 바인딩 실체 검증 의무" 정합). 테스트 전략 확장: 변경분 ROI-coverage(고위험 Auth/Billing/Data/Backend 우선) · 여러 경우 완전성(happy+경계+에러+해당 시 empty/null/동시성) · 피라미드/test size 적정성 (SoT = `docs/agent/architecture/TESTING_STRATEGY.md` §5·§6·§3 · enforce=warn · follow-up TODO 권장 · blocking gate 신설 X) | 비블로커 |
| 8. Error / Result Policy | typed Result/sealed 오류 모델 사용 여부; 기존 전면 교체 없음 (해당 task에 적용될 때) | 비블로커 |
| 9. External Prep / Deferred Items | user-prep TODO 또는 stub 처리; 외부 의존으로 UI 불변 상태 침해 없음 | 비블로커 |
| 10. DocSync | 문서-구현 드리프트 없음 | 비블로커 |
| 11. Secrets Safety | 시크릿 패턴 grep 결과 (패턴 SoT = `safety-and-secrets.md` §시크릿 스캔 패턴 · 구 compound-lint = deprecated) | 블로커 |
| 12. Rollback Viability | 롤백 지점 실행 가능성; 비가역 변경 없음 | 비블로커 |
| 13. Cleanup Governance | code-level task: EVIDENCE.md에 `## Cleanup Assessment` 존재; 제거 근거 충분성; 핵심 경로 STOP 처리; code removal vs file deletion 구분 준수. ops-layer·조사형·문서형 task: N/A | 비블로커 |
| 14. Design SoT Sync | UI visible-state(FULL) 변경 시 해당 화면 `.pen`+`.ui-spec.json` 선행/동반 refresh OR `DESIGN-DEBT.md` 등재(`uiux-sot-refresh.md` "즉시 의무 vs Deferred" 분기 정합); 출시 후 net-new visual 선행 누락 = 위반. UI visible-state 변경 무 = N/A | 비블로커 (release cycle = 아래 backstop 으로 hard FAIL 승격) |

추가 항목 (reviewer 수동 검사 · 구 compound-lint 별도 검사 = deprecated):
- PromptFit 섹션 존재: `REVIEW.md` 내 PromptFitScore, PromptFitBreakdown, PromptFitNextActions
- `.ai/promptfit/INDEX.md` 갱신: 해당 task 한 줄 append 여부

> **Release backstop (§14 enforce)**: release / production-push REVIEW cycle 한정 — 출시 대상 화면의 `DESIGN-DEBT.md` OPEN row = 0 이어야 PASS, else **FAIL (release cycle 한정 blocker)**. 매 cycle §14 = 비블로커(warn) 이나 release 게이트에서만 hard FAIL 로 승격 (= `design-to-code-sync.md` §10.2 backstop 정합 · `uiux-sot-refresh.md` 출시 backstop 정합 · blocking gate 신설 X · enforce=warn default + release 한정 backstop).

### Verdict 판정

| Verdict | 조건 |
|---|---|
| PASS | 모든 체크리스트 통과, 블로커 없음 |
| PARTIAL | 미완 항목이 있으나 핵심 기능은 충족, TODO로 추적 가능 |
| FAIL | 성공조건 미충족, 아키텍처 위배, 시크릿 노출 등 블로커 존재 |

FAIL / PARTIAL(블로커 있음) 시 → change-planner / system-architect 루프 재진입

---

## 루프 재진입 규칙

verifier 또는 reviewer가 reject 시:

1. reject 사유와 근거를 VERIFY.md 또는 REVIEW.md에 기록

### 에러 유형별 복구 경로

| 에러 유형 | 1차 복구 대상 | 최대 시도 | 초과 시 |
|---|---|---|---|
| 컴파일 실패 (빌드 에러) | implementer 즉시 수정 | 2 | STOP |
| 테스트 실패 (기존 테스트 깨짐) | change-planner 재계획 | 2 | STOP |
| 산출물 검증 FAIL (아티팩트 누락) | 누락 아티팩트 보충 후 재검증 | 1 | STOP |
| 시크릿 grep 매치 (시크릿 감지) | 즉시 STOP (재시도 없음) | 0 | STOP |
| REVIEW FAIL (블로커 항목) | change-planner / system-architect 루프 | 2 | STOP |
| REVIEW PARTIAL (비블로커 TODO) | TODO.md 기록 후 DONE 가능 | — | — |
| Context 고갈 (compaction 1회+) | HANDOFF.md 작성 → 새 세션 재진입 | 1 | STOP |
| 예상 외 파일 변경 발견 | 즉시 STOP (재시도 없음) | 0 | STOP |

- **컴파일 실패**: implementer가 에러 메시지 기반으로 직접 수정. change-planner 재호출 없이 빠른 수정.
- **테스트 실패**: 기존 테스트가 깨진 경우 회귀 위험이므로 change-planner가 영향 범위를 재평가.
- **아티팩트 누락**: 형식적 보충이므로 1회만 허용. 2회 누락이면 프로세스 문제로 STOP.
- **시크릿 감지 / 예상 외 변경**: 안전 위험이므로 자동 재시도 금지.

2. change-planner 또는 system-architect에게 위임 (intake-router 경유)
3. PLAN.md를 갱신하고 재구현
4. 재verify → 재review
5. 최대 2회 루프 후에도 FAIL이면 STOP → 사용자 판단 요청

---

## 검증 명령 LOG 형식

VERIFY.md 내 또는 `.ai/reports/<taskId>/LOG` 파일:

```
[LOG] 2026-MM-DD HH:MM KST
CMD: ls .ai/reports/SW-UI-001/
EXIT: 0
STDOUT: EVIDENCE.md PLAN.md VERIFY.md REVIEW.md TODO.md
```

---

## 명시 cycle 이력

> **착지 규약** (= K-147 자기 적용): 본 file 은 「변경 정책」 절을 **갖지 않는다** (= `rule-footer-common.md` 미소비 · 실측 `grep -c 'rule-footer-common'` = **0**). 형제 rule 의 관례(= 이력 절이 **file 말미**)를 따라 여기에 둔다 — 발주 문면은 「변경 정책 절 **앞**」이었으나 **본 repo 선례는 전량 「변경 정책 **다음**, 말미」**다(`reporting.md §12` · `pencil-mcp-tools-reference.md §12` · `cross-repo-parallel-exec.md §8` · `anchor-list.md §7`). ★**문면과 선례가 갈리면 선례를 따르고 그 사실을 보고한다** (= §0.1 K-140).
> **소급 경계** = **직전 판 + 본 판 2 판**까지. 그 앞(= `MASTER-ENGINEERING-BASELINE-001` §0 신설 · `MASTER-ENGINEERING-BASELINE-002` · `MASTER-CLI-CONTEXT-DIET-3-001` · `MASTER-CLI-RULES-SETTLE-001` 등)은 **회부** — 등재 의무는 **2026-08-29** 에 생겼고(= `rule-footer-common.md:10`) 무한 소급은 본 판의 계약이 아니다.

- 2026-08-30 · `MASTER-MEASURE-DISCIPLINE-001` · **§0.6 「명제의 자」 절 신설** (= 전칭 명제에는 전칭 자 · 명제 ↔ 게이트 대응표 의무 · 게이트가 명제보다 좁으면 PASS 는 **자의 통과**) + §0.1 「도구가 잡는 범위 ≠ 판정 범위」 · §0.3 「자기 제외 · 행별 칸 수 · 단위 병기」 강화. 자 = `git show --numstat c2ebe76` → **16 추가 / 1 삭제 · 헤더 +1**.
- 2026-08-30 · `MASTER-DOC-MANIFEST-SWEEP-002` · **§0.7 「환경의 자」 절 신설** (= K-162 · 자의 생존은 환경에 상대적 · ★죽은 자는 에러가 아니라 `0` 을 낸다 · 집행자 환경이 분모 · 대상 집합도 환경) + **§0.6 절 결속 자 종료 앵커 교정** (= K-163 · 「다음 절 번호」 → 「**형제 이상 깊이의 헤딩**」 · 마지막 절에서 EOF 까지 먹어 footer 를 절 본문으로 세던 결함 · 구 문면 병기 · 삭제 0) + **§0.2 보강 2** (= K-136-⑵ **rev 동반 좌표** · **출력 형태 가정 금지**) + **본 이력 절 신설**. 자 = 본 판 게이트 G5(`3 2 19`) · G6(`1 3`) · G7(`1 2 8`) · G11 둘·셋째 **불변**(`0 10` = 자기 교정이 자기 자를 죽이지 않았다).
