.MODEL SMALL
.STACK 100h

.DATA
    board       DB 16 DUP(0) ;Підхід B: Зберігати показник степеня
    TILE_WIDTH  EQU 7
    TILE_HEIGHT EQU 3
    tile_colors DB 00h
                DB 08h  ; темно-сірий
                DB 07h  ; світло-сірий
                DB 06h  ; коричневий
                DB 0Eh  ; жовтий
                DB 0Ch  ; яскраво-червоний
                DB 04h  ; червоний
                DB 05h  ; пурпуровий
                DB 09h  ; яскраво-синій
                DB 03h  ; блакитний
                DB 02h  ; зелений
                DB 0Ah  ; яскраво-зелений
    buffer      DB 8 DUP(0)
    line        DB "2048$"
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
    ; Clear screen: fill with spaces, white on black
    xor di, di
    mov cx, 80 * 25
    mov ax, 0720h  
    @cls:
    mov es:[di], ax
    add di, 2
    loop @cls

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
    ; вивести усі 16 клітинок різними кольорами
    mov cx, 16
    xor si, si
    xor dx, dx
    fill_board:     ; встановити степені
    mov board[si], dl
    inc si
    cmp dx, 11
    jne not_out_of_index
    mov dx, 4       ; якщо всі степені вичерпалися, то почати знову з 4 (жовтий колір)
    jmp next
    not_out_of_index:
    inc dx
    next:
    loop fill_board

    mov cx, 4
    xor ax, ax
    rows:
    push cx
    mov cx, 4
    xor bx, bx
        columns:
        push ax
        push bx
        call draw_tile
        add sp, 4

        inc bx
        loop columns
    pop cx
    inc ax
    loop rows

    mov ah, 4Ch
    int 21h

    INCLUDE render.asm
end start