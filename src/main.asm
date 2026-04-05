.MODEL small
.STACK 100h
locals @@

.DATA
    row         DB 0,0,0,0   ;для релізації ігрової логіки (процедур зсування)
    board       DB 16 DUP(0) ;Підхід B: Зберігати показник степеня
    saveboard   DB 16 DUP(0) ;для check_game_over, щоб не змінювати оригінальну дошку
    prevboard   DB 16 DUP(0)
    TILE_WIDTH  EQU 7
    TILE_HEIGHT EQU 3
    tile_colors DB 00h  ; чорний            пуста клітинка
                DB 08h  ; темно-сірий       2¹=2
                DB 07h  ; світло-сірий      2²=4
                DB 06h  ; коричневий
                DB 0Eh  ; жовтий
                DB 0Ch  ; яскраво-червоний
                DB 04h  ; червоний
                DB 05h  ; пурпуровий
                DB 09h  ; яскраво-синій
                DB 03h  ; блакитний
                DB 02h  ; зелений
                DB 0Ah  ; яскраво-зелений   2¹¹=2048
    buffer      DB 8 DUP(0)       ; для збереження рядка
    title       DB "2048$"
    g_over      DB "G A M E   O V E R$"
    g_win       DB "Y O U   W O N$"
    hint_0      DB "Arrow keys: move tiles     R: restart     ESC: quit$"
    hint_1      DB "Press C to continue, R to restart or ESC to quit$"
    hint_2      DB "Press R to restart or ESC to quit$"
    hint_table  DW offset hint_0, offset hint_1, offset hint_2 ; таблиця повідомлень з підказками щодо клавіш
    msg_0       DB "Join equal numbers and get to the 2048 tile!$"
    msg_1       DB "You've reached 2048!$"
    msg_2       DB "No more moves!$"
    msg_table   DW offset msg_0, offset msg_1, offset msg_2 ; таблиця коментарів для нижньої лінії
    curr_score  DW 0    ; current score
    curr_msg    DB "Current score: $"
    CURR_LEN    EQU $-curr_msg-1
    best_score  DW 0    ; best score 
    best_msg    DB "Best score: $"    
    BEST_LEN    EQU $-best_msg-1
    game_phase  DB 0         ;0-game is going, 1-win, 2-lose
.CODE
start:
    mov ax, @data
    mov ds, ax

    mov ax, 0B800h
    mov es, ax

    mov ax, 1003h   ; function 10h, AH=10h, AL=03h
    mov bl, 0        ; 0 = disable blinking
    int 10h

    call spawn_tile
    call spawn_tile
    call draw_board
    call draw_score
    jmp main_loop

main_loop:
    ; перевірка стану гри
    call check_win
    cmp game_phase, 1
    je win_loop

    call check_game_over
    cmp game_phase, 2
    je over_loop

    mov ah, 00h
    int 16h     ; чекати на клавішу

    cmp ah, 48h
    je move_up

    cmp ah, 50h
    je move_down

    cmp ah, 4Bh
    je move_left

    cmp ah, 4Dh
    je move_right

    cmp ah, 01h ; ESC
    je @end
jmp main_loop

    @end:
    mov ah, 4Ch
    int 21h

    win_loop:
    call draw_win
    mov ah, 00h
    int 16h
    cmp ah, 01h ; ESC
    je @end
    ; обробити R
    ; обробити С 
    jmp win_loop

    over_loop:
    call draw_game_over
    mov ah, 00h
    int 16h
    cmp ah, 01h ; ESC
    je @end
    ; обробити R
    jmp over_loop

    move_up:
    call prevboard_eq_board
    call slide_up
    jmp update_board

    move_down:
    call prevboard_eq_board
    call slide_down
    jmp update_board

    move_left:
    call prevboard_eq_board
    call slide_left
    jmp update_board

    move_right:
    call prevboard_eq_board
    call slide_right
    jmp update_board

    update_board:
    push offset board
    push offset prevboard
    call compare_boards ;if(board==prevboard) ax=1 else ax=0
    add sp, 4
    cmp ax, 1           ;if(board==prevboard) don't spawn tile
    je skip_spawn
    call spawn_tile
    skip_spawn:
    call draw_board
    call draw_score
    jmp main_loop

    mov ah, 4Ch
    int 21h

    INCLUDE render.asm
    INCLUDE logic.asm

end start