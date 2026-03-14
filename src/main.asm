.MODEL small
.STACK 100h

.DATA
    board       DB 16 DUP(0) ;Підхід B: Зберігати показник степеня
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
    title       DB "2048", 0
    hint_0      DB "Arrow keys: move tiles     R: restart     ESC: quit", 0
    hint_1      DB "Press C to continue, R to restart or ESC to quit", 0
    hint_2      DB "Press R to restart or ESC to quit", 0
    hint_table  DW offset hint_0, offset hint_1, offset hint_2 ; таблиця повідомлень з підказками щодо клавіш
    msg_0       DB "Join equal numbers and get to the 2048 tile!", 0
    msg_1       DB "You've reached 2048!", 0
    msg_2       DB "No more moves!", 0
    msg_table   DW offset msg_0, offset msg_1, offset msg_2 ; таблиця коментарів для нижньої лінії
    score       DW 0    ; current score
    best_score  DW 0    ; best score     
    game_phase  DB 0         ;0-game is going, 1-win, 2-lose

.CODE
start:
    mov ax, @data
    mov ds, ax

    mov ax, 0B800h
    mov es, ax

    ;code) 

    mov ah, 4Ch
    int 21h

    INCLUDE render.asm
    INCLUDE logic.asm

end start