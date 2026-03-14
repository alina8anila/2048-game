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
    score       DW 0         ;current score     
    game_phase  DB 0         ;0-game is going, 1-win, 2-lose

.CODE
start:
    mov ax, @data
    mov ds, ax

    ;code) 

    mov ah, 4Ch
    int 21h

    INCLUDE render.asm
    INCLUDE logic.asm

end start