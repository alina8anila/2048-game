.MODEL small
.STACK 100h
locals @@

.DATA
    board   DB 2, 2, 1, 1 
            DB 1, 3, 3, 1
            DB 1, 1, 1, 1
            DB 1, 1, 2, 2

    saveboard DB 16 DUP(0)
    prevboard DB 16 DUP(0)
    game_phase  DB 0         ;0-game is going, 1-win, 2-lose
    row  db 1, 0, 1, 2
    curr_score  DW 0
    win_triger db 0
    best_score dw 1

.CODE
start:
    mov ax, @data
    mov ds, ax

    call check_win

    mov dl, game_phase
    add dl, '0'
    mov ah, 02h
    int 21h

    ;push curr_score
    ;call print_score
    ;add sp, 2

    ;call slide_right
    ;push offset board
    ;call print
    ;add sp, 2
    ;mov dl, 10      ; Line Feed
    ;int 21h

    ;call slide_up
    ;push offset board
    ;call print
    ;add sp, 2
    ;mov dl, 10      ; Line Feed
    ;int 21h

    ;call slide_down
    ;push offset board
    ;call print
    ;add sp, 2


    mov ah, 4Ch
    int 21h

    print PROC
        push bp
        mov bp, sp
        push si
        push cx
        push ax
        push dx
    
        mov si, [bp+4] ;offset of the board
        mov cx, 4

        mov ah, 02h
        for:
            mov ah, 02h
            mov dl, [si]
            add dl, '0'
            int 21h
            inc si
            mov dl, [si]
            add dl, '0'
            int 21h
            inc si
            mov dl, [si]
            add dl, '0'
            int 21h
            inc si
            mov dl, [si]
            add dl, '0'
            int 21h
            mov dl, 13      ; Carriage Return
            int 21h
            mov dl, 10      ; Line Feed
            int 21h
            inc si
            loop for

        pop dx
        pop ax
        pop cx
        pop si
        pop bp
        ret
    print ENDP

    print_score PROC
        push ax
        push bx
        push cx
        push dx

        mov ax, [curr_score] 
        mov bx, 10           
        xor cx, cx           

    @@divide_loop:
        xor dx, dx           
        div bx               
        push dx             
        inc cx               
        test ax, ax          
        jnz @@divide_loop   

    @@display_loop:
        pop dx              
        add dl, '0'         
        mov ah, 02h         
        int 21h
        loop @@display_loop  

        pop dx
        pop cx
        pop bx
        pop ax
        ret
    print_score ENDP

    INCLUDE logic.asm
end start