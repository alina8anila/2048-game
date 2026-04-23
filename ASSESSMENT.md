# project-ladies-of-logic — Y05 2048 🟡

- **Репо:** [project-ladies-of-logic](https://github.com/ukma-fin-csa-2026/project-ladies-of-logic)
- **Тема:** Y05 — 2048 (2048)
- **Тип:** пара | **Викладач:** Богдан

| Роль | Ім'я | GitHub |
|------|------|--------|
| A — Ігрова логіка | Паращій Аліна | [alina8anila](https://github.com/alina8anila) |
| B — Рендеринг та ввід | Сахарова Юлія | [Juli-s07](https://github.com/Juli-s07) |

---

## Звіт: Оцінка

### Рекомендована оцінка: 16/20

| Критерій | Бали | Коментар |
|----------|:----:|----------|
| Наявність обов'язкових секцій (§5.2) | 3/4 | Присутні: «Опис проєкту», «Аналіз підходів (A проти Б)», «Схема організації пам'яті», «Ретроспектива», «План роботи» (розподіл). Окремої секції «Використані концепції» немає — концепції (регістри, стек, .DATA/.STACK/.CODE, DB/DW, EQU, offset, стекові фрейми, таблиці пошуку) розкидані по «Схемі пам'яті» та A/B-аналізу. 5/6. |
| Опис + концепції + схема пам'яті | 3/4 | Опис детальний (механіка, керування R/ESC/Z/C, умови win/lose, динамічний розмір 3x3/5x5). Схема пам'яті зразкова: таблиця зсувів 0000h..01B0h для всіх 23 змінних + діаграма стекового фрейму ([bp+6]/[bp+4]/[bp+2]/[bp+0]/[bp-2]) + опис основних змінних (board, tile_colors, hint_table, curr_score, game_phase). Концепції зачеплено побіжно — немає окремого розгорнутого розділу про регістри/переривання/відеопам'ять. |
| Підхід A vs B (якість) | 4/4 | Три окремі порівняння: (1) значення плиток як числа vs показники степеня — обрано B через економію пам'яті (DB vs DW) та прямий індекс у tile_colors; (2) перетворення в рядок: ділення на 10 vs таблиця пошуку — обрано A через масштабування на рахунок 0..65535; (3) алгоритм зсуву: compress→merge→compress vs merge-during-slide — обрано A через уникнення подвійного злиття та легкість відлагодження. Кожне порівняння має «Чому?» та «Зауваження» з контраргументом. |
| Ретроспектива | 2/4 | Присутня детальна ретроспектива Юлії (PR workflow, витік пам'яті через забутий pop, динамічний рендеринг через формули рамки, незавершена анімація зсуву, планування часу). Частини Аліни немає — порушено «для пар: по одній на кожну». |
| Розподіл роботи (пара/соло) | 2/2 | «План роботи» у README іменно розподіляє: Паращій Аліна → Ігрова логіка (compress/merge/slide, spawn_tile, check_game_over/win, Undo, INT 21h); Сахарова Юлія → Рендеринг та ввід (draw_board/draw_tile, кольори, обробник клавіатури, draw_score). |
| Стиль / мова / коміти | 2/2 | Чиста українська, структуровані заголовки, код-фрагменти (board[row*board_type+column], [bp+6], 0000h..01B0h) доречно вписані. Conventional Commits ≥95% підтверджено у КТ-7 секції нижче (feat/fix/refactor/docs/test). |

**Залишилось до повного звіту (остання перевірка у пʼятницю 24 квітня вранці. Пишіть самостійно! ШІ-згенеровані звіти будуть дискваліфіковані):** виділити окрему секцію «Використані концепції» (регістри AX/BX/CX/DX/SI/DI/BP/SP, стек і виклики процедур, переривання INT 10h/16h/21h, відеопам'ять B800h, сегменти .STACK/.DATA/.CODE — як саме застосовано); додати ретроспективу від Аліни (що було складним, що зробила б інакше).

## Звіт: Перевірка на ШІ

- Модель: Multi Language
- AI: 1.8% / Original: 98.2%
- [Звіт Originality.ai](https://app.originality.ai/share/toyhzsxblnp5dice)

**Вердикт:** ✅ Самостійна робота

_Попередня перевірка (2026-04-20): AI 100.0%, [Originality.ai](https://app.originality.ai/share/3tla0u9sdpv81fq7)._

---

## КТ-7 (2026-04-19) — ✅ Усі вимоги виконані

### Рекомендовані оцінки

📹 Обидва індивідуальні відео записані:
- [Loom — Юлія](https://www.loom.com/share/64da946b5e0e4ffa81320c15b6a770a7) (~3 хв)
- [Loom — Аліна](https://www.loom.com/share/76a5e26254844d5d8574152f69a1ebd7) (~3 хв)

Баланс відео: Аліна 3 / Юлія 4 → обидві виконали вимогу КТ-7 про окремі відео

📊 Прогрес: ~100% — **проєкт фактично завершено**. Гра повністю грабельна: меню → динамічне поле (3x3/4x4/5x5) → ігровий цикл → скасування ходу (Z) → win/over екрани → restart (R) / continue (C). Закрито всі переноси з КТ-6: фіналізовано аналіз «Алгоритм зсуву A vs B» з текстом під «Чому?» та «Зауваження» (Аліна), доповнено діаграму пам'яті точними зсувами/довжинами та додано діаграму стекового фрейму (Юлія), переклад коментарів на англійську в `logic.asm` і `render.asm`. Плюс два розширення теми: **динамічний розмір поля** (`board_type` EQU, board стало 25 байт для підтримки 5x5) та **скасування останнього ходу** (Ctrl+Z через `prevboard`/`Zboard`/`prevscore`/`prevbscore`)

| Студент | Відео (0/5) | Код (0–5) | Коментар |
|---------|:-----------:|:---------:|----------|
| Паращій Аліна | 5 | 5 | Проєкт завершено. Реалізовано Undo через Ctrl+Z. На захисті поясніть, чому два знімки поля (prevboard vs Zboard). Деталі в ASSESSMENT.md у репо |
| Сахарова Юлія | 5 | 5 | Проєкт з вашого боку завершено. Додано динамічний розмір поля 3x3/4x4/5x5. На захисті поясніть центрування draw_board. Деталі в ASSESSMENT.md у репо |

### Детальні коментарі

**Паращій Аліна** — Сильне завершення проєкту. Закрили перенос КТ-6 (фінальний блок «Чому?» та «Зауваження» для аналізу алгоритму зсуву у README) + реалізували повноцінне додаткове розширення **Undo** (ctrZ PROC у `logic.asm:660`): зберігання `prevboard`/`prevscore`/`prevbscore` у `prevboard_eq_board` перед кожним ходом, окремий знімок `Zboard` (оновлюється тільки після НЕпустого ходу — це ключова тонкість), відкат через `ctrZ`. Плюс рефакторинг під динамічне поле (board_type з EQU), фікс `cx` у slide (d6e60a4). Відео на ~3 хв — послідовний walkthrough своєї частини: compress з двома вказівниками, merge з inc і скоринг, slides як цикли, spawn_tile з двома random_range (підрахунок нулів → вибір 0..count-1 → потім 0..9 для вибору 2/4), check_game_over через copy→slide×4→find0→restore, check_win з `win_triger`, і нарешті ctrZ з `prevboard` та окремим `Zboard`. **На захисті будьте готові** пояснити, чому саме ДВА знімки поля потрібні (prevboard vs Zboard) і що трапиться, якщо запускати Z двічі поспіль

**Сахарова Юлія** — Основні пункти КТ-6 закрили: діаграму пам'яті доведено до фінального вигляду з точними зсувами (0000h..01B0h) і довжинами, додано діаграму стекового фрейму `[bp+...]`/локальні змінні, додано секцію ретроспективи. Переклад коментарів у `render.asm` на англійську (d899078). Плюс адаптація рендеру під динамічний board_type — це нетривіальний реф: `draw_board` тепер обчислює старт-позиції через `find_start_row`/`find_start_col` за формулою `(25 - board_type*(TILE_HEIGHT+1) + 1) / 2`, межі та кути рамки обираються через modulo на `TILE_WIDTH+1` / `TILE_HEIGHT+1`, `draw_tile` бере індекс за `row*board_type+column` — все масштабується на 3x3/4x4/5x5. Плюс фікс `draw_win` з виведенням current_score, фікс зачистки рядка з hint при R, зміна тексту hint_0 (додано `Z: cancel last move`). Відео на ~3 хв — проходить по UI-процедурах: диспетчеризація `print_help_texts` (game_phase×2 → зсув у hint_table/msg_table), `draw_board` в три етапи (горизонталі → вертикалі → кути), `draw_tile` з паддінгом через `num_to_str`, `draw_scores`, `draw_win`/`draw_game_over` з прямокутником та центрованим текстом, демо з переключенням на 3x3. **На захисті будьте готові** пояснити, як саме формула `start_row = (25 - board_type*(TILE_HEIGHT+1) + 1) / 2` адаптує центрування, і чому для 5x5 усе ще влізає в 80×25

### Аналіз Loom-відео

**Записано:** Сахарова Юлія (~3 хв)

| Критерій | Оцінка | Деталі |
|----------|:------:|--------|
| Технічне розуміння | ✅ Високе | Проходить по UI-процедурах своєї частини: `print_help_texts` як єдина точка диспетчеризації (game_phase × 2 → індекс у `hint_table`/`msg_table`, різні кольори 0Eh/07h для title, 0Fh/0Ch/0Ah для hint). `draw_board` у три етапи — горизонтальні, вертикальні, кути (розділення на прохід + modulo на TILE_WIDTH+1 / TILE_HEIGHT+1 для вибору ═/─/╤/╧). `draw_tile` з індексом `row*board_type+column`, обчисленням позиції (TILE_WIDTH+1)*col, центруванням через `num_to_str`. `draw_scores` з лівим/правим текстом і паддінгом. Демо з переключенням на 3x3 підтверджує, що адаптація під board_type працює |
| Ownership та залученість | ✅ Висока | Презентація цілком про свою частину (роль B — рендер, UI, меню), що правильно для КТ-7. Про partner-частину не розповідає, але це за задумом індивідуального відео |
| Когерентність з кодом | ✅ Повна | Усі згадані процедури звірено з `render.asm`: `print_help_texts` (`render.asm:299`), `draw_board` (`render.asm:5`), `draw_tile` (`render.asm:483`), `draw_score` (`render.asm:652`), `draw_game_over` (`render.asm:726`), `draw_win` (`render.asm:889`). Демонстрація 3x3 у відео підтверджує реальне перемикання board_type |
| Якість комунікації | ✅ Добра | Структура: зміни на тижні → диспетчеризація hint/msg → draw_board у три етапи → draw_tile → scores → екрани win/over → демо 3x3. Природний темп, конкретні деталі. Майже без «е-е-е» (пара обмовок на початку). Хороше темпове відео для КТ-7 |
| 🚩 Червоні прапорці | ✅ Немає | Самостійне пояснення своєї частини з числовими деталями (modulo TILE_WIDTH+1, TILE_HEIGHT+1, кольори 0Eh/0Fh/0Ch, позиція 23x7 для win/over) — ознака власного коду |

**Записано:** Паращій Аліна (~3 хв)

| Критерій | Оцінка | Деталі |
|----------|:------:|--------|
| Технічне розуміння | ✅ Високе | Систематичний walkthrough логіки: `compress_row` з двома вказівниками (один на перший нуль, другий шукає ненульовий елемент → swap через 0), `merge_row` з `inc byte ptr [si]` (це інкремент показника степеня у Підході B = подвоєння значення!) і додаванням `get_num(pow)` до `curr_score`. Slides як цикли: set_row → compress → merge → compress → set_board. `spawn_tile` з двома random_range (підрахунок нулів → вибір 0..count-1 → потім 0..9 для вибору 2/4). `check_game_over` через copy→slide_up/down/left/right→find0→restore. `check_win` з `win_triger`, що робить повідомлення одноразовим. `ctrZ` з `prevboard` (копія перед кожним ходом) та `Zboard` (копія тільки після НЕпустого ходу) + `prevscore`/`prevbscore`. Усе відповідає `logic.asm` |
| Ownership та залученість | ✅ Висока | Презентація про свою частину (роль A — логіка). Чітке розмежування що зроблено Аліною. Partner-частина не розкривалася, як і за задумом КТ-7 |
| Когерентність з кодом | ✅ Повна | Усі згадані процедури звірено: `compress_row` (`logic.asm:30`), `merge_row` (`logic.asm:78`), `slide_left`/etc (`logic.asm:128`), `spawn_tile` (`logic.asm:390`), `random_range` (`logic.asm:455`), `check_game_over` (`logic.asm:482`), `check_win` (`logic.asm:524`), `copy_boards` (`logic.asm:550`), `compare_boards` (`logic.asm:576`), `prevboard_eq_board` (`logic.asm:610`), `Zboard_eq_prevboard` (`logic.asm:627`), `reset_gamelog` (`logic.asm:635`), `ctrZ` (`logic.asm:660`) |
| Якість комунікації | ⚠️ З паузами | Багато «е-е-е», побудова речень на ходу, місцями плутанина («тригер, він тригер, він один», «2024» замість «2048» — двічі). Але зміст повний і технічно точний. Наприкінці не встигла запустити демо («це вийде в мене за цей час? Ну, воно все так»). Для КТ-7 зміст важливіший за формат — зміст є |
| 🚩 Червоні прапорці | ✅ Немає | Вільне пояснення своєї частини з числовими деталями (25173 множник PRNG, 13849 offset, підхід «copy → slide × 4 → find0 → restore»). Одна обмовка «2024» замість «2048» не є red flag — явно помилка у словесному виразі, в коді `cmp [si], byte ptr 11` (2^11=2048) вірно |

### Ключові спостереження

- **Усі переноси з КТ-6 закриті:** Аліна дописала «Чому?» та «Зауваження» для аналізу алгоритму зсуву у README (чистота логіки, легкість відлагодження, три проходи по рядку vs один — `e32dcc7`). Юлія завершила діаграму пам'яті з точними зсувами 0000h..01B0h та розмірами (`5b25dc8`) + додала діаграму стекового фрейму з `[bp+6]`/`[bp+4]`/локальні змінні. Переклад коментарів на англійську в `logic.asm` (Аліна, `34a1201`) і `render.asm` (Юлія, `a781135`, `d899078`)
- **Два додаткових розширення з плану теми реалізовано:**
  - **Динамічний розмір поля (3x3 / 4x4 / 5x5)** — масив `board DB 25 DUP(0)`, константа `board_type EQU 4` (Аліна, `4fa5566`, `ed99103`, `60bdd0b`). Рендер адаптовано через формулу `start_row = (25 - board_type*(TILE_HEIGHT+1) + 1) / 2` і аналогічну для col (Юлія, `59ea4e7`). Демо у відео Юлії підтверджує перемикання
  - **Скасування ходу (Ctrl+Z)** — додано `Zboard DB 25 DUP(0)`, `prevscore DW 0`, `prevbscore DW 0` (`logic.asm:9-12` main). Процедура `ctrZ` (`logic.asm:660`) + `Zboard_eq_prevboard` (`logic.asm:627`). Ключова тонкість: `prevboard` оновлюється ПЕРЕД кожним ходом (у `prevboard_eq_board`), а `Zboard` оновлюється ТІЛЬКИ після НЕпустого ходу (`main.asm:179` — `if (board==prevboard) skip Zboard_eq_prevboard`). Це правильне проектне рішення — інакше Z після порожнього ходу ламав би відкат. Плюс відповідний фікс `curr_score`/`best_score` також відкочується через `prevscore`/`prevbscore` (`4e0ca09`)
- **Робота через PR / feature branch:** Юлія продовжує роботу через `feature/render` branch + PR (PR #4/#5/#6/#7/#8/#9 — 6 PR на цьому тижні). Аліна працює напряму в main. Обидва підходи припустимі, але PR-workflow від Юлії — зразкова практика
- **Ретроспектива у README неповна** — є тільки розділ Юлії («Складнощі: регістри, динамічність, PR workflow»; «Що б зробила інакше: розподіл часу, частіше pull, завжди з гілки»). Розділу від Аліни немає. На захисті можна спитати, що вона б зробила інакше

### Чеклист

| | Перевірка | Статус |
|---|-----------|--------|
| 📋 | README з посиланням на Issue теми | ✅ `README.md:6` — `Тема: [Y05](https://github.com/ukma-fin-csa-2026/projects/issues/13)` (додано на КТ-5, стабільно) |
| 📋 | checkpoints.md + секція КТ-7 з двома Loom-посиланнями | ✅ Обидва індивідуальні URL записані (Юлія + Аліна) |
| 📋 | Індивідуальні Loom-відео від обох | ✅ Юлія (64da946b…) + Аліна (76a5e262…) |
| 🔧 | Фінальне тестування всіх напрямків зсуву та граничних сценаріїв (Аліна) | ✅ Тестовий файл `testlog.asm` з print-процедурою, перевіркою `[2,2,2,2]→[4,4,0,0]`, slide_left/up/down/right + ctrZ |
| 🔧 | Завершити аналіз алгоритму зсуву A vs B у README (Аліна, перенос з КТ-6) | ✅ `README.md:66-73` — «Чому?»: чистота логіки, легкість відлагодження; «Зауваження»: три проходи vs один |
| 🔧 | Фінальне тестування візуального відображення (Юлія) | ✅ Демо у відео Юлії з переключенням на 3x3 + `testren.asm` з hardcoded board |
| 🔧 | Діаграма пам'яті у README (Юлія, перенос з КТ-6) | ✅ `README.md:108-133` — таблиця зсувів 0000h..01B0h з точними розмірами всіх 23 змінних + діаграма стекового фрейму |
| 🔧 | Переклад коментарів на англійську | ✅ `logic.asm` (Аліна `34a1201`) + `render.asm` (Юлія `a781135`+`d899078`). Залишились локальні коментарі українською у `main.asm:10-12` для Zboard/prevscore/prevbscore — дрібничка |
| 🔧 | Стретч: динамічний розмір поля (обидві) | ✅ `board_type EQU 4` (змінюється на 3 або 5), адаптація `draw_board`/`draw_tile`/всіх сleeps через `find_start_row`/`find_start_col`. Код проходить на 3x3, 4x4, 5x5 |
| 🔧 | Стретч: скасування ходу Ctrl+Z (Аліна) | ✅ `ctrZ`/`Zboard_eq_prevboard`/`prevscore`/`prevbscore`, hint_0 оновлено (`Z: cancel last move`), коректна обробка порожнього ходу |
| 📋 | Ретроспектива у README | ⚠️ Є тільки розділ Юлії, від Аліни немає |
| 🔒 | Тег КТ-7 підписано | ✅ 43 студентських коміти у вікні (16 Аліна, 27 Юлія з 6 PR merges) |

### Внесок по комітах

**Паращій Аліна** (alina8anila) — 16 комітів (12 feat/fix/refactor/docs + 2 merges + 2 early board_type refactors), ~100 рядків нового коду + docs:

- 15 квіт. 09:13 — `feat: made board bigger, add board_type` — `board` 16→25 байт, додано `board_type DB 4` у .DATA (перша ітерація)
- 16 квіт. 23:19 — `feat: wrote board_type instead of const` — заміна hardcoded 4 на `board_type` у циклах
- 19 квіт. 12:16 — `refactor: change board_type to const` — `board_type DB 4` → `board_type EQU 4` (compile-time constant, не займає пам'ять)
- 19 квіт. 15:47 — `fix: cx in silide` — фікс регістра CX у slide (перезаписувався у циклі)
- 19 квіт. 17:33 — `feat: add ctrZ PROC` (`main.asm:141`+`logic.asm:660`) — обробник клавіші Z + процедура відкату
- 19 квіт. 17:54 — `feat: prevscores для ctrZ` — додано `prevscore DB` і збереження перед кожним ходом
- 19 квіт. 18:02 — `fix: prevscores DB->DW` — рахунки мусять бути DW, не DB (інакше обрізалося до 255)
- 19 квіт. 18:55 — `feat: Zboard_eq_prevboard PROC` — окрема процедура для Zboard (викликається тільки після НЕпустого ходу)
- 19 квіт. 18:56 — `fix: not count empty move for ctrZ` (`main.asm:179`) — `if (board==prevboard) skip Zboard_eq_prevboard` + skip_spawn
- 19 квіт. 19:05 — `feat: update score after ctrZ` — додано відкат `curr_score`/`best_score` у `ctrZ`
- 19 квіт. 20:22 — `docs: translate all comments to English` (`logic.asm`) — переклад усіх коментарів
- 19 квіт. 20:31 — `docs: AB approach analysis` (`README.md:66-73`) — «Чому?» та «Зауваження» для аналізу алгоритму зсуву (перенос з КТ-6)
- 19 квіт. 20:55/20:58 — `docs: add checkpoint 7 (Alina)` + `docs: add more in chekpoint 7 (Alina)` (`checkpoints.md`) — секція КТ-7 з Loom-посиланням та описом зробленого

**Сахарова Юлія** (Juli-s07 / Julia Sakharova) — 27 комітів (15 feat/fix/docs/test + 12 merges з PR через `feature/render`), ~200 рядків нового коду + docs + PR workflow:

- 19 квіт. 13:31 — Merge branch feature/render
- 19 квіт. 13:35 — `feature: make board size dynamic` (`render.asm`) — адаптація `draw_board`/`draw_tile`/`draw_score` під board_type (через `find_start_row`/`find_start_col` з формулою центрування)
- 19 квіт. 13:40 — Merge branch 'main' into feature/render + Merge PR #4
- 19 квіт. 13:47 — `test: add tests for drawing dynamic board` (`testren.asm`) — тестовий файл з hardcoded board для візуальної перевірки
- 19 квіт. 13:53/13:55 — Merge and update changes + `fix: delete unnecessary code`
- 19 квіт. 14:07 — `fix: change row when cleaning hint` (`render.asm`) — зачистка рядка 23 при перемальовуванні
- 19 квіт. 15:59 — `fix: jump to start when restarting game` (`main.asm:139`) — після `reset_gamelog` робити `jmp start`, щоб спавнити перші дві плитки наново
- 19 квіт. 16:02/16:54 — Merge branch 'feature/render' + `docs: translate all comments to English` (`render.asm`) — переклад коментарів
- 19 квіт. 17:01/17:22 — Merge branch 'feature/render' + `feat: print current score in draw_win` (`render.asm:1017-1042`) — додано вивід curr_score у екрані win (як у game_over)
- 19 квіт. 17:22 — Merge branch 'feature/render'
- 19 квіт. 17:45 — `feat: add hint for canceling last move` (`main.asm:33`) — hint_0 оновлено з `Z: cancel last move`
- 19 квіт. 17:47 — Merge PR #5
- 19 квіт. 18:24 — `docs: add memory and stack frame diagram` (`README.md:81-133`) — діаграма стекового фрейму + фіналізована таблиця зсувів 0000h..01B0h з точними розмірами
- 19 квіт. 18:31/18:32 — Merge branch 'main' + Merge PR #6
- 19 квіт. 18:50 — `docs: add restrospective` (`README.md:139-148`) — розділ ретроспективи (тільки Юлія)
- 19 квіт. 18:51 — Merge PR #7
- 19 квіт. 19:04 — `docs: translate all comments to English` (повторний пас)
- 19 квіт. 19:06 — Merge PR #8
- 19 квіт. 20:42 — `docs: add checkpoint 7` (`checkpoints.md`) — секція КТ-7 з Loom-посиланням та описом своєї частини
- 19 квіт. 20:44 — Merge PR #9

**Баланс:** комітів 16/27, код ~100/200 рядків (Юлія має більше через адаптацію `draw_board` під динамічний розмір — нетривіальний реф, плюс `testren.asm` з hardcoded полем) — ✅ збалансовано на КТ-7. Обидві закрили переноси КТ-6 і додали по одному додатковому розширенню (Аліна — Undo, Юлія — динамічний розмір)

### Якість комітів

✅ **Відповідає вимогам**

- **Conventional Commits:** 95%+ з префіксом (`feat:`, `fix:`, `refactor:`, `docs:`, `feature:`, `test:`). Дрібне зауваження: Юлія продовжує чергувати `feat:` і `feature:` — допустима варіація. Аліна змішує англійську та українську в повідомленнях (`feat: prevscores для ctrZ`, `feat: Zboard_eq_prevboard PROC` ок, але `docs: add more in chekpoint 7 (Alina)` має помилку `chekpoint`)
- **Imperative mood:** ✅ ("add", "make", "fix", "change", "implement", "update")
- **Мова:** переважно англійська, пара повідомлень з українськими словами (`для ctrZ`) — припустимо
- **Гранулярність:** ✅ відмінна — кожен фікс/feature у своєму коміті (DB→DW окремо, Zboard_eq_prevboard окремо від ctrZ, окремо hint update, окремо score update). Зразкова практика
- **GitHub Issues / PR:** ✅ **6 PR у цьому вікні (Юлія)** — `feature/render` branch з merge PR #4-9. Issues закриваються через PR. Це найкраща практика серед усіх проєктів цього тижня
- **Структура репо:** ✅ `src/` з 5 модулями, `README.md`, `checkpoints.md`, `.gitignore`. Без dev-артефактів

---

## КТ-6 (2026-04-12) — ✅ Усі вимоги виконані

### Рекомендовані оцінки

📹 [Loom](https://www.loom.com/share/6248c9cfb5314c8c9424245f81e4b02e) (Юлія, ~1.5 хв) — баланс відео: Аліна 3 / Юлія 3 → вирівняно. На КТ-7 план теми вимагає ІНДИВІДУАЛЬНИХ відео від кожної

📊 Прогрес: ~95% (очікувано ~86% на КТ-6) — **проєкт фактично завершено**. Гра повністю грабельна: ініціалізація → ігровий цикл → win/over екрани → restart (R) / continue (C). Усі основні пункти КТ-6 виконано

**Залишилось до 100% (КТ-7):**
- Завершити аналіз алгоритму зсуву A vs B у README (Аліна) — розділ «стиснення-потім-злиття vs злиття-під-час-зсуву» є у README з чернетки, але без тексту під «Чому?» та «Зауваження»
- Доповнити README діаграмою пам'яті (Юлія) — чернетка вже є (board/tile_colors/msg_table/hint_table/curr_score/best_score/game_phase), уточнити зсуви/довжини і довести до фінального вигляду
- Фінальне тестування граничних випадків: `[2,2,2,2]→[4,4,0,0]`, переповнення рахунку (DW → 65535), restart/continue через усі game_phase
- Закрити вивід інструкції `Q: quit` або узгодити з фактичними клавішами (ESC vs Q) — `hint_0`/`hint_1`/`hint_2` пишуть `ESC: quit`, але в темі згадується ESC/R — перевірити консистентність
- Фінальне полірування README: текст під «Чому?» для підходу 3, англомовні коментарі (частина коментарів у `logic.asm`/`main.asm` — укр)

> ⚠️ **КТ-7 відео — потрібні ДВА окремі індивідуальні Loom-відео**, по одному від кожної студентки (це вимога плану теми на тиждень 14). Одне спільне відео НЕ зараховується:
> - **Аліна** — пояснює свою частину: `check_win` з `win_triger` (продовження гри після 2048), `check_game_over` (copy → slide × 4 → find0 → restore), `reset_gamelog` (скидання board/prevboard/curr_score/game_phase/win_triger), `compress_row`/`merge_row`, `compare_boards`/`prevboard_eq_board` для порожнього ходу, підрахунок `curr_score`/`best_score`
> - **Юлія** — пояснює свою частину: `print_help_texts` з диспетчеризацією title/msg/hint через `game_phase` і `msg_table`/`hint_table`, `draw_board`/`draw_tile` у B800h, `draw_score`, `draw_win`/`draw_game_over`, обробка R (restart) та C (continue) у `win_loop`/`over_loop`

| Студент | Відео (0/5) | Код (0–5) | Коментар |
|---------|:-----------:|:---------:|----------|
| Паращій Аліна | 5 | 5 | Чудова робота. На КТ-7 обов'язково запишіть СВОЄ окреме відео. Деталі в ASSESSMENT.md у репо |
| Сахарова Юлія | 5 | 5 | Відмінна робота на КТ-6. На КТ-7 обов'язково запишіть СВОЄ окреме відео. Деталі в ASSESSMENT.md у репо |

### Детальні коментарі

**Паращій Аліна** — Чудова робота. Рефакторинг check_win зі зрозумілим `win_triger`, фікс циклу після перемоги, reset_gamelog. Гра тепер повністю грабельна, можна продовжити після 2048. Додана чернетка аналізу алгоритму зсуву у README. **На КТ-7 обов'язково запишіть СВОЄ окреме відео**: check_win/win_triger, reset_gamelog, check_game_over

**Сахарова Юлія** — Відмінна робота на КТ-6. print_help_texts з диспетчеризацією title/msg/hint через game_phase + таблиці, обробка R/C для restart/continue, опис пам'яті та діаграма даних у README. Запис відео, баланс вирівняно 3/3. **На КТ-7 обов'язково запишіть СВОЄ окреме відео**: print_help_texts, win_loop/over_loop, draw_win/draw_game_over

### Аналіз Loom-відео

**Записано:** Сахарова Юлія (~1.5 хв)

| Критерій | Оцінка | Деталі |
|----------|:------:|--------|
| Технічне розуміння | ✅ Добре | Пояснено `print_help_texts` (title/hint/message через таблиці), обробку R/C у очікуванні клавіш для restart/continue, фікс Аліни у `reset_gamelog` (win зациклювалось через невідновлення `win_triger`). Живе демо: досягнення плитки 2048 → зелене повідомлення → C → продовження гри → game over → червоне повідомлення |
| Ownership та залученість | ✅ Обидві залучені | Юлія чітко розмежовує свою частину (`print_help_texts`, очікування клавіш) та роботу Аліни (фікс `reset_gamelog`, аналіз алгоритму зсуву в README). Знає, що саме партнерка виправила і чому |
| Когерентність з кодом | ✅ Повна | Усе підтверджується: `print_help_texts` у `render.asm:290` з диспетчеризацією по `game_phase`, `win_loop`/`over_loop` у `main.asm:104-126` з обробкою R/C/ESC, `reset_gamelog` у `logic.asm:578` скидає `win_triger`, live demo win→continue→game over |
| Якість комунікації | ✅ Добра | Коротке але щільне відео (~1.5 хв), логічна структура: що нового → фікс партнерки → демо win/continue/over → README. По суті, без філерів |
| 🚩 Червоні прапорці | ✅ Немає | Коротке відео виправдане — КТ-6 це полірування вже готової гри. Обидві студентки активні, код відповідає опису |

### Ключові спостереження

- **Проєкт фактично завершено на КТ-6:** гра повністю грабельна — ініціалізація → main_loop → check_win/check_game_over → win_loop (R/C/ESC) / over_loop (R/ESC) → restart через `reset_gamelog` → jmp start. Continue після перемоги через `win_triger` працює коректно
- **Юлія — `print_help_texts` як єдина точка виведення UI-текстів:** `render.asm:290` — диспетчеризація title/msg/hint за `game_phase` через `msg_table`/`hint_table` (DW offsets), різні кольори для кожної фази (0Eh/07h title, 0Fh/0Ch/0Ah hint). Елегантно — замість дублювання в кожному loop
- **Аліна — фікс логіки перемоги:** `check_win` тепер використовує `win_triger DB 0` (`main.asm:48`), що дозволяє продовжити гру після досягнення 2048 (continue в `win_loop` → `game_phase=0`, але `win_triger=1` запобігає повторному виклику win screen). `reset_gamelog` скидає і `win_triger`, і `curr_score`, і обидва `board`/`prevboard`
- **README: чернетки аналізу A-vs-B та діаграми пам'яті є, але не завершені:** розділ «Алгоритм зсуву» має A/B опис, але порожні «Чому?» та «Зауваження». Діаграма даних є (board/tile_colors/msg_table/hint_table/curr/best_score/game_phase), треба фіналізувати до КТ-7
- **Issues використовуються:** PR #2 (key waiting) і PR #3 (print_help_texts) через feature branch + merge, закриті. Це зразкова практика — перший раз бачимо PR у цьому проєкті

### Чеклист

| | Перевірка | Статус |
|---|-----------|--------|
| 📋 | checkpoints.md + секція КТ-6 | ✅ Записано з Loom-посиланням |
| 📋 | Loom-відео | ✅ Записано Юлія (~1.5 хв). Баланс: Аліна 3 / Юлія 3 → вирівняно |
| 🔧 | Граничні випадки `[2,2,2,2]→[4,4,0,0]` | ⚠️ `compress_row`+`merge_row` логіка є, окремий тест у `testlog.asm` не додано на КТ-6, фінальне тестування на КТ-7 |
| 🔧 | Перезапуск гри (скидання board та score) — Аліна | ✅ `reset_gamelog` у `logic.asm:578` скидає `curr_score`, `game_phase`, `win_triger`, `board`, `prevboard` |
| 🔧 | Чернетка аналізу A-vs-B (алгоритм зсуву) — Аліна | ⚠️ Розділ «Алгоритм зсуву: стиснення-потім-злиття проти злиття-під-час-зсуву» є в README, але «Чому?» та «Зауваження» порожні |
| 🔧 | Обробка R/C для restart/continue — Юлія | ✅ `main.asm:104-137` — `win_loop` (R=restart, C=continue), `over_loop` (R=restart), `@continue_game` скидає `game_phase=0` але зберігає `win_triger=1` |
| 🔧 | `print_help_texts` для всіх фаз — Юлія | ✅ `render.asm:290` — title/msg/hint через `game_phase` + таблиці `msg_table`/`hint_table` |
| 🔧 | Діаграма пам'яті у README — Юлія | ✅ Чернетка додана (board, tile_colors, msg_table/hint_table, curr/best_score, game_phase), фіналізувати на КТ-7 |
| 🔒 | Тег КТ-6 підписано | ✅ 13 студентських комітів у вікні (1 зовнішній — sergemedvid КТ-5 assessment) |

### Внесок по комітах

**Паращій Аліна** (alina8anila) — 6 комітів (4 feat/fix/refactor + 1 docs + 1 merge), ~50 рядків нового коду:

- 6 квіт. 00:50 — `feat: implement reset_gamelog PROC` (`logic.asm` +25/-2, `main.asm` +0/-1) — скидання board/prevboard/curr_score/game_phase/win_triger
- 7 квіт. 00:50 — Merge branch 'main' (ASSESSMENT.md +100) — мерж попереднього асесменту
- 11 квіт. 16:48 — `refactor: made check_win more simple` (`logic.asm` +8/-29) — спрощення `check_win` через `win_triger`
- 11 квіт. 16:49 — `feat: add win_triger to main` (`logic.asm` +0/-1, `main.asm` +1/-0) — додано прапорець до `.DATA`
- 11 квіт. 16:51 — `fix: win_triger in reset_gamelog` (`logic.asm` +1/-0, `testlog.asm` +8/-10) — фікс циклу win
- 12 квіт. 22:00 — `docs: add draft of slides analysis` (`README.md` +7/-0) — чернетка аналізу алгоритму зсуву

**Сахарова Юлія** (Juli-s07 / Julia Sakharova) — 6 комітів (3 feat + 2 docs + 2 merge, 1 merge перекривається), ~155 рядків нового коду:

- 11 квіт. 17:15 — `feature: add key waiting to restart and continue` (`main.asm` +21/-4) — R/C обробка в `win_loop`/`over_loop` (через feature/render branch)
- 11 квіт. 17:24 — Merge PR #2 from feature/render (`main.asm` +21/-4)
- 12 квіт. 17:21 — `feature: implement print_help_texts PROC for all game phases and add variables in main` (`main.asm` +11/-1, `render.asm` +93/-0) — `print_help_texts` з таблицями
- 12 квіт. 17:32 — Merge PR #3 from feature/render (`main.asm` +11/-1, `render.asm` +93/-0)
- 12 квіт. 21:16 — `docs: add memory diagram draft` (`README.md` +22/-1) — діаграма даних
- 12 квіт. 21:33 — `docs: add memory description` (`README.md` +7/-1) — опис організації пам'яті
- 12 квіт. 22:28 — `docs: add checkpoint 6` (`checkpoints.md` +6/-1) — секція КТ-6 з Loom

**Баланс:** комітів 6/6, нового коду ~50/~155 рядків — ✅ збалансовано за кількістю комітів. Юлія додала більше рядків через велику процедуру `print_help_texts` (+93) та розширений README. Обидві виконали свої частини плану КТ-6. Відеобаланс 3/3 — вирівняно

### Якість комітів

✅ **Відповідає вимогам**

- **Conventional Commits:** 100% з префіксом (`feat:`, `fix:`, `refactor:`, `docs:`, `feature:`). Дрібне зауваження: Юлія використала `feature:` замість канонічного `feat:` — допустима варіація, але варто уніфікувати
- **Imperative mood:** ✅ ("implement", "add", "made", "fix")
- **Мова:** англійська ✅ (повідомлення комітів)
- **Гранулярність:** ✅ добра — кожен коміт один логічний крок (окремо `reset_gamelog`, окремо `win_triger`, окремо фікс, окремо `print_help_texts`, окремо docs)
- **GitHub Issues / PR:** ✅ **Вперше використано PR** — PR #2 (key waiting), PR #3 (print_help_texts) через `feature/render` branch. Це зразкова практика на КТ-6, раніше було лише direct push
- **Структура репо:** ✅ `src/` з 5 модулями (`main.asm`/`logic.asm`/`render.asm`/`testlog.asm`/`testren.asm`), `README.md`, `checkpoints.md`. Без dev-артефактів

---

## КТ-5 (2026-04-05) — ✅ Усі вимоги виконані

### Рекомендовані оцінки

📹 [Loom](https://www.loom.com/share/d58735479fb341ffb5b542c2f728a912) (Аліна) — баланс відео: Аліна 3 / Юлія 2 → на КТ-6 записує Юлія

📊 Прогрес: ~71% (очікувано ~71% на КТ-5) — на графіку

| Студент | Відео (0/5) | Код (0–5) | Коментар |
|---------|:-----------:|:---------:|----------|
| Паращій Аліна | 5 | 5 | Стабільно на висоті! check_game_over, check_win, порожній хід, рахунок — повністю за планом КТ-5. Розумна реалізація через копію дошки та перевірку після всіх 4 зсувів |
| Сахарова Юлія | 5 | 5 | Знову чудово! draw_game_over та draw_win з рамками, кольорами та текстом, README з аналізом підходів, параметризований draw_board — вище плану КТ-5 |

### Аналіз Loom-відео

**Записано:** Аліна (~3 хв)

| Критерій | Оцінка | Деталі |
|----------|:------:|--------|
| Технічне розуміння | ✅ Високе | Пояснено алгоритм check_win (нова плитка: порівняння prevboard vs board), check_game_over (копія дошки → всі 4 зсуви → перевірка наявності нуля → відновлення), порожній хід (compare_boards), підрахунок рахунку в merge_row |
| Ownership та залученість | ✅ Обидва залучені | Аліна детально описує свою роботу (логіка), згадує draw_win та draw_game_over Юлії. Показано спільну роботу: main_loop обробляє game_phase, win_loop/over_loop викликають render-процедури |
| Когерентність з кодом | ✅ Повна | Усе описане підтверджується кодом: check_game_over в logic.asm, draw_win/draw_game_over в render.asm, main_loop з win_loop/over_loop в main.asm. Показано живе демо програш і виграш |
| Якість комунікації | ⚠️ Лаконічна | Структурована і зрозуміла, є демо, але багато філерів "е-е-е". Пояснення технічні й конкретні |
| 🚩 Червоні прапорці | ✅ Немає | Обидві студентки демонструють розуміння своїх частин, жива гра підтверджує коректність |

### Ключові спостереження

- **Повна відповідність плану КТ-5:** Аліна реалізувала check_game_over, check_win, порожній хід та підрахунок рахунку (план Student A); Юлія реалізувала draw_game_over, draw_win, README аналіз підходів та параметризований draw_board (план Student B + понад план)
- **33 студентські коміти у вікні КТ-5** (Аліна ~18, Юлія ~11 з мержами) — активний тиждень, обидві студентки завершили основний функціонал
- **Гра повністю функціональна:** ігровий цикл → зсуви → spawn → check_win → check_game_over → win/over screens. Залишається перезапуск та фінальне полірування
- **check_win з продовженням гри:** реалізовано правильно — перемога спрацьовує лише якщо плитка 2048 нова (є в поточній дошці, але не в попередній)

### Чеклист

| | Перевірка | Статус |
|---|-----------|--------|
| 📋 | README з планом + emails | ✅ README з аналізом підходів A/B |
| 📋 | checkpoints.md + секція КТ-5 | ✅ Секція КТ-5 з Loom-посиланням |
| 📋 | Loom-відео | ✅ Записано Аліна (баланс: Аліна 3 / Юлія 2 → на КТ-6 записує Юлія) |
| 📋 | Тема зареєстрована в Issue | ✅ |
| 🔧 | check_game_over (перевірка сусідніх рівних плиток) | ✅ logic.asm — copy_boards → slide всі 4 напрямки → пошук 0 → відновлення дошки; збереження/відновлення score (~40 рядків) |
| 🔧 | check_win (пошук плитки 2048, підтримка продовження гри) | ✅ logic.asm — check_if_have_2024 для prevboard і board; win тільки якщо плитка нова (~30 рядків) |
| 🔧 | Визначення порожнього ходу (порівняння поля до/після зсуву) | ✅ main.asm — prevboard_eq_board → slide → compare_boards → умовний spawn_tile |
| 🔧 | draw_game_over та draw_win | ✅ render.asm — червоне вікно 23x7 "GAME OVER" зі score; зелене 23x7 "YOU WON" (~260 рядків) |
| 🔧 | Підрахунок рахунку (curr_score, best_score) | ✅ logic.asm — merge_row: get_num → add curr_score; cmp → update best_score. draw_score викликається після кожного ходу |
| 🔧 | README: опис проєкту та аналіз підходів | ✅ README.md — опис гри + аналіз 2 пар підходів (зберігання степеня vs числа; ділення vs таблиця) |
| 🔒 | Тег КТ-5 підписано | ✅ |

### Внесок по комітах

**Паращій Аліна** (alina8anila) — 18 комітів (з них 1 merge), ~311 рядків коду:

- 4 квіт. 13:09 (3947552) — `feat:implement check_win` — logic.asm: check_win перевірка плитки 11 (2048) (+18/-3)
- 4 квіт. 13:26 (e6fcc7ee) — `feat: made copy_boards PROC` — logic.asm: copy_boards з параметрами через стек (+27/-1)
- 4 квіт. 13:45 (729e882) — `feat: made compare_boards PROC` — logic.asm: compare_boards (+35/-1); testlog.asm (+28/-8)
- 4 квіт. 18:14–18:17 (9679635, 52bcbde) — `feat:implement check_game_over PROC` + merge — logic.asm: check_game_over (copy → slide × 4 → find0 → restore) (+32/-9); merge render.asm (+257/-1)
- 4 квіт. 18:57 (65aaa72) — `feat: add another check_win` — logic.asm: check_if_have_2024, оновлений check_win з prevboard (+34/-9)
- 4 квіт. 19:01 (4bd6daef) — `feat: add saveboard for check_game_over` — main.asm (+1/-0)
- 4 квіт. 19:13 (2f969af) — `feat: add prevboard_eq_board to make main smaller` — logic.asm (+9/-1)
- 4 квіт. 19:29 (d041706) — `fix: compare_boards` — logic.asm (+1/-1)
- 4 квіт. 19:33 (35a06d4) — `feat: add empty moves` — main.asm: prevboard → slide → compare → spawn (+12/-0)
- 5 квіт. 10:01 (04b2f55) — `feat: add score counting` — logic.asm: merge_row з get_num та curr_score/best_score (+31/-0)
- 5 квіт. 10:06 (02b64b5) — `test: score` — testlog.asm тести рахунку (+46/-31)
- 5 квіт. 10:09 (839423d) — `feat: call draw_score` — main.asm (+2/-0)
- 5 квіт. 10:46 (9e95301) — `feat:add best_score counting` — logic.asm: best_score update (+6/-0)
- 5 квіт. 11:37 (be650eb) — `fix: not change scores in check_game_over` — logic.asm: save/restore score (+6/-0)
- 5 квіт. 11:47 (4dd457b) — `fix: not to set 0 to game_phase in checks` — logic.asm (+0/-4)
- 5 квіт. 11:50–11:51 (cff3c12, 6985dde merge) — `feat: add win/lose to the main_loop` — main.asm: win_loop/over_loop (+16/-0)
- 5 квіт. 12:23 (b6ba81c) — `fix:remove unnecessary code` — main.asm (-16)
- 5 квіт. 23:13 (13177d0) — `docs: add checkpoint 5` — checkpoints.md (+6/-1)

**Сахарова Юлія** (Julia Sakharova) — 11 комітів (з них 2 merge, 1 test, 2 docs, 3 refactor):

- 3 квіт. 17:57 (9865a2b) — `refactor: make tile positioning dynamic, implement find_start_row and find_start_col PROCS` — render.asm: find_start_row, find_start_col (+48/-7)
- 3 квіт. 20:14 (c0da2f1) — `refactor: dynamically center text in tiles with padding on both sides` — render.asm (+15/-13)
- 3 квіт. 22:18 (f8701a1) — `refactor: make draw_board parametrized` — render.asm (+61/-40)
- 4 квіт. 13:00 (a331e5d) — `feat: implement draw_game_over and draw_win PROCS` — render.asm: два вікна 23x7 (+257/-1)
- 5 квіт. 10:38 (8691b81) — `fix: change the order of variables for score output` — main.asm (+10/-3)
- 5 квіт. 10:42 (21252861) — `feat: spawn 2 tiles and add variables` — main.asm (+4/-0)
- 5 квіт. 10:38–11:41 (48ba291 merge) — Merge branch 'main' — logic.asm (+6/-0)
- 5 квіт. 10:41 (eddc826) — `test: add tests for draw_game_over and draw_win` — testren.asm (+6/-2)
- 5 квіт. 11:51 (9ebcc08) — `feat: check game phases` — main.asm: win_loop/over_loop (+30/-3)
- 5 квіт. 16:04 (8ab8920) — `docs: add analysis of approaches to storing and converting tile values` — README.md (+27/-1)
- 5 квіт. 17:27 (c5e0c1d) — `docs: add short game description` — README.md (+4/-2)

**Баланс:** Аліна ~18 комітів / ~311 рядків (логіка: check_win, check_game_over, порожній хід, рахунок), Юлія ~11 комітів / ~490 рядків (рендеринг: draw_game_over, draw_win, рефакторинг draw_board + README) — ⚠️ легкий дисбаланс за кількістю комітів, але рядків коду близько; Юлія додала більше рядків через великі процедури draw_game_over/draw_win та рефакторинг

### Якість комітів

✅ **Відповідає вимогам**

- **Conventional Commits:** ~85% — `feat:`, `fix:`, `refactor:`, `docs:`, `test:` використовуються. Кілька merge без префікса (нормально). Аліна пропускає пробіл після двокрапки в деяких комітах (`feat:implement`, `feat:add`)
- **Imperative mood:** ✅ "implement", "add", "make", "change"
- **Мова:** ✅ англійська
- **Гранулярність:** ✅ одна процедура = один коміт: check_win, copy_boards, compare_boards, check_game_over, draw_game_over окремо. Дрібні fix-коміти теж атомарні
- **GitHub Issues:** ❌ лише Issue #1 (КТ-1), PR workflow відсутній (зауваження з попередніх КТ без змін)
- **Структура репо:** ✅ src/, .gitignore наявний, бінарні файли відсутні

---

## КТ-4 (2026-03-29) — ✅ Усі вимоги виконані

### Рекомендовані оцінки

📹 [Loom](https://www.loom.com/share/d44fdc3a9ce9413788b794a3d76fa940) (Юлія) — баланс відео: Аліна 2 / Юлія 2 → збалансовано

📊 Прогрес: ~57% (очікувано ~57% на КТ-4) — на графіку

| Студент       | Відео (0/5) | Код (0–5) | Коментар                                                                                                                                 |
| ------------- | :---------: | :-------: | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Паращій Аліна |      5      |     5     | Гарно! Усі 4 зсуви (slide_left/right/up/down з reverse та writeback), spawn_tile з PRNG та random_range. Повністю за планом КТ-4         |
| Сахарова Юлія |      5      |     5     | Чудово! draw_board з рамкою та рендерингом 16 клітинок, draw_score, обробник клавіатури та ігровий цикл в main. Повноцінно грабельна гра |

### Аналіз Loom-відео

**Записано:** Юлія (~3 хв)

| Критерій | Оцінка | Деталі |
|----------|:------:|--------|
| Технічне розуміння | ✅ Високе | Пояснено slide у всі 4 сторони (compress+merge+compress+writeback, reverse для right, крок по колонках для up/down). Описано spawn_tile з random_range та ймовірність 2 vs 4. Розуміє код партнерки |
| Ownership та залученість | ✅ Обидва залучені | Юлія починає з роботи Аліни (зсуви, spawn_tile), потім описує свою (draw_board, draw_score, main_loop). Обидві активні |
| Когерентність з кодом | ✅ Повна | Зсуви, draw_board з рамкою, draw_score, main loop з клавішами стрілок, демо через TD підтверджується кодом та скріншотами |
| Якість комунікації | ✅ Добра | Структуроване: логіка → рендеринг → main → демо. Є "е-е", але пояснення зрозумілі. Показано і тести, і реальну гру |
| 🚩 Червоні прапорці | ✅ Немає | Обидві студентки демонструють розуміння свого та чужого коду, робоча гра |

### Ключові спостереження

- **Повна відповідність плану КТ-4:** Аліною реалізовано slide_left/right/up/down + spawn_tile (план Student A), Юлією реалізовано draw_board + draw_score + обробник клавіатури (план Student B). Ігровий цикл працює від початку до кінця
- **17 студентських комітів у вікні КТ-4** (Аліна 8, Юлія 9 з merge) — збалансована активність, обидві працювали кілька днів
- **Гра вже грабельна:** клавіші стрілок → slide → spawn → перемальовування працює. Залишається check_game_over, check_win, анімація
- **Зауваження з КТ-3 виправлено:** checkpoints.md тепер має правильну нумерацію секції КТ-4

### Чеклист

| | Перевірка | Статус |
|---|-----------|--------|
| 📋 | README з планом + emails | ✅ |
| 📋 | checkpoints.md + секція КТ-4 | ✅ Секція КТ-4 з Loom-посиланням |
| 📋 | Loom-відео | ✅ Записано Юлія (баланс: Аліна 2 / Юлія 2 → збалансовано) |
| 📋 | Тема зареєстрована в Issue | ✅ |
| 🔧 | slide_left (compress+merge+compress+writeback) | ✅ logic.asm — slide_left з compress_row, merge_row, compress_row та writeback у board (~50 рядків) |
| 🔧 | slide_right/up/down (реверс, транспозиція) | ✅ logic.asm — slide_right з reverse, slide_up/slide_down з кроком по колонках. Усі 4 напрямки реалізовано |
| 🔧 | spawn_tile з PRNG | ✅ logic.asm — spawn_tile: random_range для пошуку порожньої клітинки, ймовірність ступеня 1 (плитка 2) або 2 (плитка 4) (~112 рядків) |
| 🔧 | draw_board (цикл по 16 клітинках) | ✅ render.asm — draw_board: очищення екрана, рамка (вертикальні/горизонтальні лінії, кути), цикл рендерингу 16 клітинок через draw_tile (~236 рядків) |
| 🔧 | draw_score | ✅ render.asm — draw_score: заповнення кольором та вивід "Current Score" і "Best Score" (~62 рядки) |
| 🔧 | Обробник клавіатури (INT 16h для стрілок) | ✅ main.asm — main_loop: INT 16h AH=00h, перевірка scan-кодів 48h/50h/4Bh/4Dh, виклик slide_*/spawn_tile/draw_board |
| 🔒 | Верифікація push | ✅ 25 пушів до дедлайну, 0 після |

### Внесок по комітах

**Паращій Аліна** (alina8anila) — 8 комітів (з них 1 merge, 1 fix), ~372 рядки коду:

- 28 берез. 10:31 (1579493) — `feat: implement slide_left PROC` — logic.asm: slide_left з compress_row, merge_row, compress_row та writeback (+50/-7)
- 28 берез. 10:50 (89f558c) — `feat:imprement slide_right PROC` — logic.asm: slide_right з reverse (+59/-11)
- 28 берез. 18:08 (1b0abba) — `feat: implement slide_up PROC` — logic.asm: slide_up з кроком по колонках (+61/-28); testlog.asm тести (+11/-24)
- 28 берез. 18:13 (3639dc2) — `feat: implement slide_down PROC` — logic.asm: slide_down (+56/-9)
- 28 берез. 18:22 (1b62807) — `feat: add "row" to .Data and "locals @@"` — main.asm: row DW, locals @@ (+2/-0)
- 28 берез. 18:28 (1e80aa6) — `test: slides` — testlog.asm: тести для 4 зсувів (+32/-5)
- 29 берез. 04:14 (2e6f3e6) — `feat: implement spawn_tile PROC` — logic.asm: spawn_tile з random_range, ймовірність 2/4 (+80/-6); testlog.asm (+32/-29)
- 23 берез. 22:53 (db641bb) — merge (ASSESSMENT.md)

**Сахарова Юлія** (Julia Sakharova) — 9 комітів (з них 1 merge, 1 test, 1 docs):

- 28 берез. 20:29 (21f8442) — `feat: add separate current and best scores` — main.asm (+1/-1)
- 28 берез. 20:30 (5d6eb2c) — `feat: implement draw_score PROC` — render.asm: draw_score з кольоровим рядком (+62/-1)
- 29 берез. 19:04 (512de78) — merge з main (logic.asm +284/-26, main.asm +2, testlog.asm +39/-22)
- 29 берез. 19:57 (38a57c6) — `feat: implement (not parameterized) draw_board PROC` — render.asm: draw_board з рамкою та рендерингом клітинок (+236/-2)
- 29 берез. 19:58 (e2e16b8) — `test: add variables and test draw_board, draw_score` — testren.asm: тести draw_board та draw_score (+27/-9)
- 29 берез. 21:01 (8a50b43) — `feat: draw tiles inside draw_board PROC` — render.asm: рендеринг 16 клітинок через draw_tile (+18/-0)
- 29 берез. 21:02 (9b23e92) — `feat: add variables and main_loop` — main.asm: ігровий цикл з обробкою клавіш стрілок, виклик slide_*/spawn_tile/draw_board (+48/-2)
- 29 берез. 21:09 (51fbdeb) — `test: delete unecessary code` — testren.asm очищення (+1/-33)
- 29 берез. 21:27 (cf2f10e) — `docs: add checkpoint 4` — checkpoints.md (+6/-1)

**Баланс:** Аліна 8 комітів / ~372 рядки (зсуви, spawn_tile), Юлія 9 комітів / ~394 рядки (draw_board, draw_score, main_loop) — ✅ збалансовано

### Якість комітів

✅ **Відповідає вимогам**

- **Conventional Commits:** ~90% — `feat:`, `test:`, `fix:`, `docs:`, `refactor:` використовуються. Merge без префікса
- **Imperative mood:** ✅ "implement", "add", "delete"
- **Мова:** ✅ англійська
- **Гранулярність:** ✅ один коміт = одна процедура (slide_left, slide_right, slide_up, slide_down, spawn_tile, draw_board, draw_score). Зразкова гранулярність
- **GitHub Issues:** ❌ лише Issue #1 (КТ-1), PR workflow відсутній
- **Структура репо:** ✅ src/, .gitignore наявний

### Верифікація (theme plan cross-check)

**Студент A (Аліна) — план КТ-4:** «Реалізувати slide_left повністю (compress+merge+compress+writeback). Адаптувати для slide_right (реверс), slide_up/slide_down (транспозиція). Додати spawn_tile з PRNG. Перша інтеграція: main.asm викликає логіку та рендеринг — ігровий цикл працює від початку до кінця.»

- slide_left: ✅
- slide_right (реверс): ✅
- slide_up/slide_down (транспозиція): ✅ (крок по колонках)
- spawn_tile з PRNG: ✅ (random_range, ймовірність 2/4)
- Перша інтеграція: ✅ (main_loop у main.asm)
- Відповідність: 5/5 → оцінка 5 обґрунтована

**Студент B (Юлія) — план КТ-4:** «Реалізувати draw_board (цикл по 16 клітинках), draw_score. Підключити обробник клавіатури (INT 16h для стрілок). Інтеграція: клавіатура → виклик slide_* → перемалювання поля.»

- draw_board: ✅
- draw_score: ✅
- Обробник клавіатури: ✅ (INT 16h, стрілки 48h/50h/4Bh/4Dh)
- Інтеграція: ✅
- Відповідність: 4/4 → оцінка 5 обґрунтована

---

## КТ-3 (2026-03-22) — ⚠️ Частково виконано

### Рекомендовані оцінки

📹 [Loom](https://www.loom.com/share/87c8a4cc3c714359877c44ebbc324c19) (Аліна) — баланс відео: Аліна 2 / Юлія 1 → на КТ-4 записує Юлія

📊 Прогрес: ~43% (очікувано ~43% на КТ-3) — на графіку

| Студент | Відео (0/5) | Код (0–5) | Коментар |
|---------|:-----------:|:---------:|----------|
| Паращій Аліна | 5 | 5 | Стабільно на висоті! compress_row з двома вказівниками та merge_row зі злиттям через inc, саме те що очікувалось на КТ-3. Тестування slide_left (compress+merge+compress) через testlog.asm підтверджує правильність алгоритму |
| Сахарова Юлія | 5 | 5 | Стабільно на висоті! draw_tile з обчисленням позиції, кольором з tile_colors, рамкою 7x3 та центрованим числом через num_to_str. Повністю відповідає плану КТ-3 |

### Ключові спостереження

- **12 студентських комітів у вікні КТ-3** (Аліна 6, Юлія 6) — збалансована активність, обидві студентки працювали
- **Повна відповідність плану КТ-3:** Аліна реалізувала compress_row та merge_row (план Студента A), Юлія реалізувала draw_tile та num_to_str (план Студента B). Обидві частини виконано повністю
- **Тестування обома:** testlog.asm тестує compress+merge+compress на 4 рядках з виводом через INT 21h, testren.asm тестує draw_tile з 16 плитками у B800h. Зрілий підхід до розробки зберігається з КТ-2
- **checkpoints.md: секція КТ-3 помилково озаглавлена як "КТ-2"** — зміст правильний (Loom, опис роботи), але заголовок "КТ-2 (Тиждень 9)" замість "КТ-3 (Тиждень 10)". Автоматичний звіт позначив як відсутню секцію

### Чеклист

| | Перевірка | Статус |
|---|-----------|--------|
| 📋 | checkpoints.md + секція КТ-3 | ⚠️ Зміст є, але секція помилково озаглавлена "КТ-2" замість "КТ-3". Loom-посилання присутнє |
| 📋 | Loom-відео КТ-3 | ✅ Записано Аліна (баланс: Аліна 2, Юлія 1 → на КТ-4 записує Юлія) |
| 🔧 | compress_row: збір ненульових плиток до одного краю | ✅ logic.asm — реалізовано з двома вказівниками (si/di), пошук першого ненульового елемента, переміщення, обнуління оригіналу (~29 рядків) |
| 🔧 | merge_row: злиття сусідніх рівних | ✅ logic.asm — порівняння сусідніх елементів, злиття через inc (показник степеня +1 = подвоєння), обнуління правого (~25 рядків) |
| 🔧 | Тестування логіки через INT 21h з жорстко заданим полем | ✅ testlog.asm — дошка [1,1,0,2 / 0,1,0,1 / 1,1,1,1 / 0,3,2,2], цикл compress+merge+compress для 4 рядків, вивід через print PROC |
| 🔧 | draw_tile(row, col, value): запис у B800h з рамкою та кольором | ✅ render.asm — обчислення позиції (row=5+(TILE_HEIGHT+1)*grid_row, col=23+(TILE_WIDTH+1)*grid_col), кольоровий прямокутник 7x3 символами 219, центроване число через num_to_str та print_line (~109 рядків) |
| 🔧 | num_to_str: перетворення числа в рядок через ділення на 10 | ✅ render.asm — класичний алгоритм з push залишків у стек та зворотнім записом, повертає довжину в CX (~36 рядків) |
| 🔧 | Тестування рендерингу жорстко заданого поля | ✅ testren.asm — заповнення board[] степенями 0-11, виклик draw_tile для всіх 16 клітинок у вкладеному циклі rows/columns |
| 🔒 | Верифікація push | ✅ 18 пушів до дедлайну, 0 після (звіт КТ-3) |

### Внесок по комітах

**Паращій Аліна** (alina8anila) — 6 комітів, ~161 рядків:

- 22 берез. 00:14 — testlog.asm: файл тестування логіки з print PROC та жорстко заданою дошкою (+60)
- 22 берез. 18:33 — compress_row: реалізація збору ненульових плиток з двома вказівниками si/di (+29/-3)
- 22 берез. 19:11 — fix: збереження регістрів (push/pop bx, si, di, ax) у compress_row (+9)
- 22 берез. 20:18 — merge_row: злиття сусідніх рівних через inc з перевіркою меж (+25/-4)
- 22 берез. 20:19 — testlog.asm: тест slide_left (compress+merge+compress) для 4 рядків, виправлення print PROC (+32/-7)
- 22 берез. 22:09 — checkpoints.md: секція КТ-3 (помилково озаглавлена "КТ-2") з Loom (+6/-1)

**Сахарова Юлія** (Juli-s07) — 6 комітів, ~247 рядків:

- 17 берез. 15:21 — виправлення друкарської помилки "attrbiute" → "attribute" у render.asm (+1/-1)
- 22 берез. 01:16 — рефакторинг: заміна 0-terminated рядків на $-terminated у main.asm, render.asm, testren.asm (+9/-9)
- 22 берез. 01:17 — TILE_WIDTH EQU 7, TILE_HEIGHT EQU 3, buffer DB 8 DUP(0) у main.asm (+3)
- 22 берез. 01:19 — num_to_str: ділення на 10, запис цифр у buffer, повернення довжини в CX (+36/-3)
- 22 берез. 01:21 — draw_tile: обчислення позиції клітинки, кольоровий прямокутник, центрування числа через num_to_str та print_line (+109/-3)
- 22 берез. 01:22 — testren.asm: тест draw_tile з 16 плитками різних кольорів у вкладеному циклі (+89/-38)

**Баланс:** комітів 6/6, рядків ~161/247 — ✅ збалансовано (обидві студентки зробили приблизно рівний обсяг роботи, різниця пояснюється більшим розміром draw_tile)

### Якість комітів

✅ **Відповідає вимогам**

- **Conventional Commits:** 100% — `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:` використовуються коректно у всіх 12 комітах
- **Imperative mood:** ✅ "add compress_row PROC", "implement num_to_str procedure", "add tile sizes and buffer"
- **Мова:** ✅ Англійська послідовно
- **Гранулярність:** ✅ Логічні атомарні коміти: compress_row окремо, merge_row окремо, num_to_str окремо, draw_tile окремо, тести окремо, рефакторинг рядків окремо. Дрібна зауваження: "test: compress, marge" — одруківка "marge" замість "merge"
- **GitHub Issues:** ✅ Issue #1 для теми
- **Структура репо:** ✅ src/ папка, .gitignore на місці, 5 .asm файлів (main, logic, render, testlog, testren)

### Аналіз коду

**compress_row** (logic.asm):

- Двовказівниковий алгоритм: si сканує зліва, якщо знайдено 0, di шукає перший ненульовий праворуч
- Правильно переміщує значення та обнулює джерело: `mov al, [di]` → `mov [si], al` → `mov byte ptr [di], 0`
- Зберігає регістри (push/pop bx, si, di, ax)
- Параметр через стек: `[bp+4]` — offset рядка в board

**merge_row** (logic.asm):

- Ітерація зліва направо з перевіркою `[si] == [si+1]`
- Злиття через `inc byte ptr [si]` (показник степеня +1 = подвоєння значення) — правильно для Підходу B
- Обнулення правого елемента та пропуск на наступну позицію після злиття запобігає подвійному злиттю
- Межа `add bx, 3` правильна (перевіряємо до передостаннього елемента)
- Зауваження: не оновлює score при злитті (буде потрібно на КТ-4)

**draw_tile** (render.asm):

- Обчислює індекс у board: `row*4+col`, зчитує показник степеня `board[di]`
- Обчислює екранну позицію: `row=5+(TILE_HEIGHT+1)*grid_row`, `col=23+(TILE_WIDTH+1)*grid_col`
- Малює кольоровий прямокутник TILE_HEIGHT x TILE_WIDTH символами 219 з кольором з tile_colors[si]
- Для ненульових плиток: обчислює `2^power` через `shl bx, cl`, викликає num_to_str, обчислює padding для центрування: `(TILE_WIDTH - length) / 2`
- Для порожніх плиток (power=0): пропускає число, малює лише прямокутник
- Текст числа виводиться інвертованим кольором (`shl dx, 4`) через print_line
- Складна процедура (~109 рядків) з правильним збереженням регістрів

**num_to_str** (render.asm):

- Класичний алгоритм: ділення на 10, залишок у стек, зворотній запис у buffer
- Повертає довжину рядка в CX — використовується draw_tile для центрування
- $-terminated рядок

---

## КТ-2 (2026-03-15) — ✅ Усі вимоги виконані

### Рекомендовані оцінки

📹 [Loom](https://www.loom.com/share/3f08f1a2af8f4e049f13942887ec447b) (Юлія) — баланс відео: Аліна 1 / Юлія 1

📊 Прогрес: ~33% (очікувано ~29% на КТ-2) — на графіку

| Студент | Відео (0/5) | Код (0–5) | Коментар |
|---------|:-----------:|:---------:|----------|
| Паращій Аліна | 5 | 5 | Порожні процедури в logic.asm з коментарями-планом для кожної. Структура правильна, алгоритм slide описано вірно (compress+merge+compress). На КТ-3 чекаємо реалізацію compress_row та merge_row |
| Сахарова Юлія | 5 | 5 | Значний прогрес: tile_colors, текстові таблиці, працююча print_line з записом у B800h та testren.asm для тестування. Проактивне створення тестового файлу показує зрілий підхід. На КТ-3 очікуємо працюючі draw_tile та num_to_str |

### Ключові спостереження

- **8 нових студентських комітів** після КТ-1 (Юлія 7, Аліна 1) — вимога виконана
- **Юлією зроблено значний прогрес:** з 1 коміту (лише README) на КТ-1 до 7 комітів з реальним кодом (print_line, тести, таблиці). Це позитивна динаміка, хоча draw_tile та num_to_str досі порожні
- **Аліна мінімально присутня на КТ-2:** 1 коміт з порожніми процедурами в logic.asm. Але це відповідає плану (logic заповнюється на КТ-3-4), і каркас добре структурований
- **Якість комітів суттєво покращилась:** Conventional Commits, англійська мова, гранулярність
- **Правильна модульна архітектура:** main.asm (дані + entry), render.asm (рендеринг), logic.asm (логіка), testren.asm (тестування) -- чіткий розподіл відповідальності
- **Проактивне тестування:** testren.asm -- рідкість на цьому етапі, демонструє зрілий підхід до розробки
- **Кількість файлів:** 4 .asm файли, що відповідає рекомендованому обсягу (3-5 для пари)



### Чеклист

| | Перевірка | Статус |
|---|-----------|--------|
| 📋 | checkpoints.md + секція КТ-2 | ✅ Заповнено з Loom-посиланням, записано Юлія |
| 📋 | Loom-відео КТ-2 | ✅ Записано Юлія (баланс вирівняний: Аліна 1, Юлія 1) |
| 🔧 | logic.asm: порожні PROC/ENDP (slide_left/right/up/down, spawn_tile, check_game_over, check_win) | ✅ 8 процедур з push bp/mov bp,sp каркасом та коментарями-планом для кожної |
| 🔧 | render.asm: порожні PROC/ENDP (draw_board, draw_tile, num_to_str, draw_score, draw_game_over, draw_win) | ✅ 8 процедур; print_line реалізована повністю, animate_tile додана як бонусне розширення |
| 🔧 | tile_colors DB таблиця (12 записів) | ✅ В main.asm, 12 кольорів від 00h (порожня) до 0Ah (2048) |
| 🔧 | .gitignore | ✅ Додано (f324a43) |
| 🔧 | Тестовий файл | ✅ testren.asm -- тести кольорів та виклик print_line |
| 🔒 | Верифікація push | ✅ 11 пушів до дедлайну, 0 після; останній 2026-03-15 20:18 EET (~1г40хв до дедлайну) |

### Внесок по комітах

**Сахарова Юлія** (Juli-s07) — 7 комітів, ~244 рядки:

- 11 берез. 17:44 — .gitignore для скомпільованих файлів (+13)
- 14 берез. 12:37 — таблиця tile_colors в main.asm (+12)
- 14 берез. 14:42 — текстові таблиці (title, hint_table, msg_table), best_score, налаштування відеопам'яті в main.asm (+14)
- 14 берез. 15:40 — порожні процедури в render.asm: draw_board, draw_tile, animate_tile, num_to_str, draw_score, draw_game_over, draw_win (+92)
- 14 берез. 15:44 — реалізація print_line: вивід рядка у відеопам'ять через lodsb з кольоровим атрибутом (+31)
- 14 берез. 15:49 — testren.asm: тест кольорів (цикл по tile_colors) та виклик print_line через стек (+76)
- 15 берез. 20:15 — checkpoints.md: секція КТ-2 з Loom (+6)

**Паращій Аліна** (alina8anila) — 1 коміт, ~114 рядків:

- 15 берез. 19:13 — порожні процедури в logic.asm: compress_row, merge_row, slide_left/right/up/down, spawn_tile, check_game_over, check_win (+114)

**Баланс:** комітів 7/1, рядків ~244/114 — ✅ Юлія значно активніша на КТ-2 (виправлення дисбалансу з КТ-1). Але більшість рядків Аліни -- це теж порожні каркаси процедур. Реальний код: print_line Юлії (~30 рядків) vs 0 рядків реалізації у Аліни

### Якість комітів

✅ **Значне покращення** порівняно з КТ-1

- **Conventional Commits:** ~86% — `docs:`, `chore:`, `feat:`, `test:` використовуються коректно (6/7 нових комітів Юлії з префіксами; 1 коміт Аліни також з `chore:`)
- **Imperative mood:** ✅ "add empty procedures", "add tile color table", "implement print_line"
- **Мова:** ✅ Англійська послідовно (виправлено змішаність з КТ-1)
- **Гранулярність:** ✅ Логічні атомарні коміти: .gitignore окремо, кольори окремо, таблиці окремо, процедури окремо, тест окремо
- **.gitignore:** ✅ Додано (було відсутнє на КТ-1)

### Аналіз коду

**print_line** (render.asm) — єдина реалізована процедура:

- Правильно обчислює позицію у відеопам'яті: `(row * 80 + col) * 2`
- Параметри через стек (4 параметри: offset, column, row, color) -- відповідає конвенції caller-cleanup
- Використовує `lodsb` + `mov es:[di], ax` для запису символ+атрибут у B800h
- Зберігає регістри (push/pop ax, bx, di, si) -- коректна конвенція
- Є друкарська помилка в коментарі: "attrbiute" замість "attribute"

**testren.asm** — корисний тестовий файл:

- Вимикає мерехтіння (`INT 10h, AX=1003h, BL=0`) для повного діапазону кольорів
- Очищає екран через цикл по відеопам'яті
- Тестує всі 12 кольорів з tile_colors візуально (блоки 219 + цифра)
- Демонструє виклик print_line через стек з caller-cleanup (`add sp, 8`)
- Показує, що Юлія розуміє роботу з відеопам'яттю та конвенцію виклику процедур

**logic.asm** — каркас:

- 8 порожніх процедур з правильними push bp/mov bp,sp/pop bp/ret
- Коментарі описують алгоритми (compress+merge+compress для slide_left)
- Дрібна помилка: slide_down має коментар "намалювати ігрове поле (рамку)" -- скопійовано з draw_board
- Дрібна помилка: check_win шукає "плитку 2024" замість 2048

### Аналіз Loom-відео

**Записано:** Юлія (~2 хв)

| Критерій | Оцінка | Деталі |
|----------|:------:|--------|
| Технічне розуміння | ✅ Добре | Описує процедури обох модулів: compress_row, merge_row, slide в 4 сторони, spawn_tile, check_game_over/win (Аліна); draw_board, print_line з позицією та атрибутом кольору, draw_tile, num_to_str, draw_score, animate_tile (свої). Пояснює stack frame та caller-cleanup. Розуміє tile_colors, hint/msg таблиці з індексацією за станом гри |
| Ownership та залученість | ✅ Обидві залучені | Чітко розмежовує: Аліна -- logic.asm (алгоритми зсуву, compress+merge+compress), Юлія -- render.asm (рендеринг, print_line). Описує тестовий файл testren.asm для перевірки кольорів |
| Когерентність з кодом | ✅ Повна | Порожні процедури з stack frame у logic.asm, реалізована print_line, таблиці tile_colors та text у main.asm, testren.asm -- все підтверджується комітами 14-15 березня |
| Якість комунікації | ✅ Добра | Структуроване: ігрова логіка Аліни -> рендеринг свій -> main.asm -> плани. Послідовне пояснення з конкретними деталями. Невеликі запинки, але загалом впевнений виклад |
| 🚩 Червоні прапорці | ✅ Немає | Демонструє розуміння обох модулів. Самостійно додано print_line (не в переліку вимог) та тестовий файл -- ознака проактивного підходу |

---

## КТ-1 (2026-03-08) — ✅ Усі вимоги виконані

### Рекомендовані оцінки

📹 [Loom](https://www.loom.com/share/cd83150e1b2a44189f18d17ee836960d) (Аліна) — баланс відео: Аліна 1 / Юлія 0 → на КТ-2 записує Юлія

| Студент | Відео (0/5) | Код (0–5) | Коментар |
|---------|:-----------:|:---------:|----------|
| Паращій Аліна | 5 | 5 | Гарна робота! Каркас main.asm, розподіл на модулі, правильний вибір Підходу B, видно архітектурне мислення) |
| Сахарова Юлія | 5 | 3 | Добре, що план є, але поки лише README без коду в .asm файлах. На КТ-2 чекаємо draw_tile, num_to_str, tile_colors, це ваша роль |

### Чеклист

| | Перевірка | Статус |
|---|-----------|--------|
| 📋 | README з планом + emails | ✅ Повний план, розподіл ролей, emails |
| 📋 | checkpoints.md + секція КТ-1 | ✅ Заповнено з описом прогресу та Loom |
| 📋 | Loom-відео | ✅ |
| 📋 | Тема зареєстрована в Issue | ✅ Issue #1 |
| 🔧 | Скелет main.asm із сегментами | ✅ `main.asm` (384B) — `.MODEL`, `.STACK`, `.DATA`, `.CODE`, `INT 21h` вихід |
| 🔧 | Формат поля узгоджено (board, score, game_phase) | ✅ `board DB 16 DUP(0)` (Підхід B — показники степеня), `score DW 0`, `game_phase DB 0` |
| 🔧 | Модулі logic.asm та render.asm створені | ⚠️ Файли створені (0B) — порожні заглушки, INCLUDE в main.asm |
| 🔒 | Верифікація push | ✅ 4 пуші до дедлайну |

### Внесок по комітах

**Паращій Аліна** (alina8anila) — 3 комітів, ~37 рядків:

- 7 берез. 03:26 — план до README (2/2) (+11)
- 8 берез. 18:29 — каркас main.asm зі спільними змінними .DATA, створила logic.asm та render.asm (+22)
- 8 берез. 19:01 — checkpoints.md з КТ-1 секцією та Loom-посиланням (+4)

**Сахарова Юлія** (Juli-s07) — 1 коміт, ~24 рядки:

- 6 берез. 20:12 — план до README (1/2) (+24)

**Баланс:** комітів 3/1, коду ~37/24 рядків — ⚠️ легкий дисбаланс (Аліна написала весь код .asm та документацію КТ-1; Юлія — лише план у README)

### Якість комітів

⚠️ **Частково відповідає вимогам** (Project.md §7.4)

- **Conventional Commits:** 0% — жоден коміт не має префіксу (`feat:`, `docs:` тощо). Приклади: "Add plan to README (1/2)", "Написала каркас в main.asm, створила render.asm, logic.asm"
- **Imperative mood:** ⚠️ "Написала каркас" (минулий час, має бути "add skeleton"); "Add plan" ✅
- **Мова:** ⚠️ змішана — один коміт українською ("Написала каркас..."), решта англійською
- **Гранулярність:** ⚠️ "Написала каркас в main.asm, створила render.asm, logic.asm" — поєднує створення трьох файлів в одному коміті
- **GitHub Issues:** ✅ Issue #1 створено для теми
- **Структура репо:** ⚠️ є `src/` (§7.2); `.gitignore` відсутній до дедлайну

### Аналіз Loom-відео

**Записала:** Аліна (~3 хв)

| Критерій | Оцінка | Деталі |
|----------|:------:|--------|
| Технічне розуміння | ✅ Високе | Чітко пояснює Підхід B (показники степеня замість значень), різницю між DB і DW для board/score, значення game_phase (0/1/2), модульну структуру з INCLUDE |
| Ownership та залученість | ⚠️ Часткова | Аліна впевнено описує свою частину (logic) і план Юлії (render, кольори, клавіатура), але говорить від себе — Юлія не присутня і не підтверджує свою обізнаність |
| Когерентність з кодом | ✅ Повна | Опис board DB 16 DUP(0), score DW, game_phase DB, INCLUDE render/logic — точно відповідає коду в main.asm |
| Якість комунікації | ✅ Добра | Структуроване пояснення: план → розподіл ролей → data segment → code segment → include; впевнений тон, конкретні деталі |
| 🚩 Червоні прапорці | ✅ Немає | Демонструє розуміння власного коду, коректно пояснює архітектурні рішення |

### Ключові спостереження

- **4 студентських комітів до дедлайну** — мінімальна але достатня активність для КТ-1
- **Правильна архітектура:** обрано Підхід B (показники степеня), модульна структура з окремими logic.asm та render.asm, спільні змінні в main.asm — відповідає рекомендаціям теми
- **Дисбаланс вкладу:** Аліна зробила 3/4 студентських комітів, включаючи весь код та checkpoints.md; Юлія — лише план у README. На КТ-2 варто перевірити вирівнювання

---
