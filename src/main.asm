.MODEL small
.STACK 100h
locals @@

.DATA
    row         DB 0,0,0,0,0   ; for the implementation of game logic (sliding procedures)
    board       DB 25 DUP(0) ; approach B: save the exponent
    saveboard   DB 25 DUP(0) ; for check_game_over to not change the original board
    prevboard   DB 25 DUP(0)
    board_type  EQU 4
    TILE_WIDTH  EQU 7
    TILE_HEIGHT EQU 3
    tile_colors DB 00h  ; black             empty tile
                DB 08h  ; dark grey         2¹=2
                DB 07h  ; light grey        2²=4
                DB 06h  ; brown
                DB 0Eh  ; yellow
                DB 0Ch  ; bright red
                DB 04h  ; red
                DB 05h  ; purple
                DB 09h  ; bright blue
                DB 03h  ; blue
                DB 02h  ; green
                DB 0Ah  ; bt=right green    2¹¹=2048
    buffer      DB 8 DUP(0)       ; for saving string
    game_title  DB "2 0 4 8$"
    TITLE_LEN   EQU $-game_title
    g_over      DB "G A M E   O V E R$"
    g_win       DB "Y O U   W O N$"
    hint_0      DB "Arrow keys: move tiles     R: restart     ESC: quit     Z: cancel last move$"
    HINT_0_LEN  EQU $-hint_0
    hint_1      DB "Press C to continue, R to restart or ESC to quit$"
    HINT_1_LEN  EQU $-hint_1
    hint_2      DB "Press R to restart or ESC to quit$"
    HINT_2_LEN  EQU $-hint_2
    hint_table  DW offset hint_0, offset hint_1, offset hint_2 ; comment table with hints
    HINT_LENS   DW offset HINT_0_LEN, offset HINT_1_LEN, offset HINT_2_LEN
    msg_0       DB "Join equal numbers and get to the 2048 tile!$"
    msg_1       DB "You've reached 2048!$"
    msg_2       DB "No more moves!$"
    msg_table   DW offset msg_0, offset msg_1, offset msg_2 ; comment table for bottom line
    curr_score  DW 0        ; current score
    curr_msg    DB "Current score: $"
    CURR_LEN    EQU $-curr_msg-1
    best_score  DW 0        ; best score 
    best_msg    DB "Best score: $"    
    BEST_LEN    EQU $-best_msg-1
    game_phase  DB 0         ; 0-game is going, 1-win, 2-lose
    win_triger  DB 0         ; to continue playing after reaching 2048
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
    call print_help_texts
    call draw_score
    jmp main_loop

main_loop:
    ; check game_phase
    call check_win
    cmp game_phase, 1
    je win_loop

    call check_game_over
    cmp game_phase, 2
    je over_loop

    mov ah, 00h
    int 16h     ; waiting for key

    cmp ah, 48h
    je move_up

    cmp ah, 50h
    je move_down

    cmp ah, 4Bh
    je move_left

    cmp ah, 4Dh
    je move_right

    cmp ah, 13h ; R
    je @restart_game

    cmp ah, 01h ; ESC
    je @end
jmp main_loop

    @end:
    mov ah, 4Ch
    int 21h

    win_loop:
    call draw_win
    call print_help_texts
    mov ah, 00h
    int 16h
    cmp ah, 01h ; ESC
    je @end
    cmp ah, 13h ; R
    je @restart_game
    cmp ah, 2Eh ; C
    je @continue_game
    jmp win_loop

    over_loop:
    call draw_game_over
    call print_help_texts
    mov ah, 00h
    int 16h
    cmp ah, 01h ; ESC
    je @end
    cmp ah, 13h ; R
    je @restart_game
    jmp over_loop
    
    @restart_game:
    call reset_gamelog
    jmp start

    @continue_game:
    mov game_phase, 0
    call draw_board
    call print_help_texts
    call draw_score
    jmp main_loop

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
    call print_help_texts
    call draw_score
    jmp main_loop

    mov ah, 4Ch
    int 21h

    INCLUDE render.asm
    INCLUDE logic.asm

end start