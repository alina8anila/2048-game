.MODEL SMALL
.STACK 100h

.DATA
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
line        DB "2048", 0
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

    xor di, di
    mov si, offset tile_colors
    mov cx, 12
    print_loop1:
    mov al, 219
    mov ah, [si]
    mov es:[di], ax
    add di, 2

    mov al, '2'
    mov bl, [si]
    shl bl, 4
    mov ah, bl
    mov es:[di], ax
    add di, 2

    mov al, 219
    mov ah, [si]
    mov es:[di], ax
    add di, 2
    inc si
    loop print_loop1

    ; - - - - - - - TEST LINE PRINT - - - - - - - -
    push 03h
    push 2
    push 1
    push offset line
    call print_line
    add sp, 8


    mov ah, 4Ch
    int 21h

    INCLUDE render.asm
end start