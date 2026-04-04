.MODEL small
.STACK 100h
locals @@

.DATA
    board   DB 1, 1, 1, 1 
            DB 1, 1, 1, 1
            DB 1, 1, 6, 1
            DB 1, 10, 12, 1

    board2 DB 16 DUP(0)
    
    row  db 1, 0, 1, 2

.CODE
start:
    mov ax, @data
    mov ds, ax

    push offset board  ;to
    push offset board2 ;form
    call compare_boards
    add sp, 4
    mov ah, 02h
    mov dl, al
    add dl, '0'
    int 21h

    push offset board  ;to
    push offset board2 ;form
    call copy_boards
    add sp, 4

    push offset board
    call print
    add sp, 2

    push offset board  ;to
    push offset board2 ;form
    call compare_boards
    add sp, 4
    mov ah, 02h
    mov dl, al
    add dl, '0'
    int 21h

    ;call slide_left
    ;push offset board
    ;call print
    ;add sp, 2
    ;mov dl, 10      ; Line Feed
    ;int 21h

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

    INCLUDE logic.asm
end start