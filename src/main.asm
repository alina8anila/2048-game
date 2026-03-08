.MODEL small
.STACK 100h

.DATA
    board       DB 16 DUP(0) ;Підхід B: Зберігати показник степеня
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