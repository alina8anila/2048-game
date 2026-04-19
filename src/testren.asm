.MODEL SMALL
.STACK 100h

.DATA
    row         DB 0,0,0,0,0   ;для релізації ігрової логіки (процедур зсування)
    board       DB 2, 2, 1, 1, 0
                DB 1, 3, 3, 1, 1
                DB 1, 1, 1, 1, 2
                DB 3, 0, 0, 0, 0
                DB 0, 0, 0, 0, 0
    saveboard   DB 25 DUP(0) ;для check_game_over, щоб не змінювати оригінальну дошку
    prevboard   DB 25 DUP(0)
    board_type  EQU 4
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
    game_title  DB "2 0 4 8$"
    TITLE_LEN   EQU $-game_title
    g_over      DB "G A M E   O V E R$"
    g_win       DB "Y O U   W O N$"
    hint_0      DB "Arrow keys: move tiles     R: restart     ESC: quit$"
    HINT_0_LEN  EQU $-hint_0
    hint_1      DB "Press C to continue, R to restart or ESC to quit$"
    HINT_1_LEN  EQU $-hint_1
    hint_2      DB "Press R to restart or ESC to quit$"
    HINT_2_LEN  EQU $-hint_2
    hint_table  DW offset hint_0, offset hint_1, offset hint_2 ; таблиця повідомлень з підказками щодо клавіш
    HINT_LENS   DW offset HINT_0_LEN, offset HINT_1_LEN, offset HINT_2_LEN
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
    mov di, 0

    ; - - - - - - - TEST COLORS - - - - - - - -
    mov ax, 1003h   ; function 10h, AH=10h, AL=03h
    mov bl, 0        ; 0 = disable blinking
    int 10h
    ; ; Clear screen: fill with spaces, white on black
    ; xor di, di
    ; mov cx, 80 * 25
    ; mov ax, 0720h  
    ; @cls:
    ; mov es:[di], ax
    ; add di, 2
    ; loop @cls

    ; xor di, di
    ; mov si, offset tile_colors
    ; mov cx, 12
    ; print_loop1:
    ; mov al, 219
    ; mov ah, [si]
    ; mov es:[di], ax
    ; add di, 2

    ; mov al, '2'
    ; mov bl, [si]
    ; shl bl, 4
    ; mov ah, bl
    ; mov es:[di], ax
    ; add di, 2

    ; mov al, 219
    ; mov ah, [si]
    ; mov es:[di], ax
    ; add di, 2
    ; inc si
    ; loop print_loop1

    ; - - - - - - - TEST print_line - - - - - - - -
    ; push 03h
    ; push 2
    ; push 1
    ; push offset line
    ; call print_line
    ; add sp, 8

    ; - - - - - - - TEST num_to_str - - - - - - - -
    ; mov ax, 256
    ; push ax
    ; call num_to_str
    ; add sp, 2

    ; push 1Fh
    ; push 3
    ; push 3
    ; push offset buffer
    ; call print_line
    ; add sp, 8

    ; - - - - - - - TEST draw_column - - - - - - - -
    ; push 1
    ; push 0
    ; call draw_tile
    ; add sp, 4
    call draw_board
    call print_help_texts
    call draw_score
    ; вивести усі 16 клітинок різними кольорами

    ; call draw_game_over
    ; call draw_win

    mov ah, 4Ch
    int 21h

    INCLUDE render.asm
end start