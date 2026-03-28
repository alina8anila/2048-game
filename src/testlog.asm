.MODEL small
.STACK 100h
locals @@

.DATA
    board   DB 1, 3, 0, 2
            DB 0, 3, 0, 1
            DB 0, 1, 0, 1
            DB 1, 3, 2, 2
    
    row  db 1, 0, 1, 2

.CODE
start:
    mov ax, @data
    mov ds, ax

    call slide_up

    push offset board
    call print
    add sp, 2

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