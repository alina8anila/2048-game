; ===========================================
; render.asm - процедури рендерингу та вводу
; ===========================================

draw_board PROC ; КТ-4
; намалювати ігрове поле (рамку)
    push bp
    mov bp, sp
    
    ; очищення екрану
    ; вивести рамку

    pop bp
    ret
    draw_board ENDP

print_line PROC
; вивести null-terminated рядок тексту за позицією
    push bp
    mov bp, sp
    push ax
    push bx
    push di
    push si

    ; [bp+10] - color attribute, [bp+8] - row, [bp+6] - column, [bp+4] - offset
    ; DI = (row * 80 + column) * 2
    mov ax, [bp+8]
    mov bx, 80
    mul bx
    add ax, [bp+6]
    shl ax, 1
    mov di, ax
    ; SI - offset
    mov si, [bp+4]
    ; AH - color attribute
    mov ah, byte ptr [bp+10]

    @print_loop:
    lodsb
    cmp al, '$'
    je @done
    mov es:[di], ax
    add di, 2
    jmp @print_loop

    @done:
    pop si
    pop di
    pop bx
    pop ax
    pop bp
    ret
    print_line ENDP

draw_tile PROC ; КТ-3
; намалювати одну клітинку з її значенням
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    push di
    push dx

    ; [bp+6] - grid_row, [bp+4] - grid_column
    ; обчислити index для взяття значення: row*4+column
    mov ax, [bp+6]
    mov bx, 4
    mul bx
    add ax, [bp+4]
    mov di, ax    
        ; зберігаємо index
        mov cx, di
    mov al, board[di]
    xor ah, ah   
    mov si, ax     ; si - power of 2

    ; row = 5 + (tile_height+1) * grid_row,   column = 23 + (tile_width+1) * grid_column 
    ; з відступами від країв та місцями для рамки МІЖ клітинками
    mov ax, [bp+4]
    mov di, TILE_WIDTH
    inc di
    mul di
    add ax, 23
    mov bx, ax      ; bx - column
    mov ax, [bp+6]
    mov di, TILE_HEIGHT 
    inc di
    mul di          
    add ax, 5       ; ax - row

        ; зберегти колонку, рядок та index
        push bx
        push ax
        push cx

    ; намалювати прямокутник
    mov cx, TILE_HEIGHT
    @row_loop:
    push cx
    push bx
    push ax
    mov cx, TILE_WIDTH
    ; (row*80+column)*2
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax
        @col_loop:
        mov ah, tile_colors[si] ; колір
        mov al, 219             ; символ
        mov es:[di], ax

        add di, 2
        loop @col_loop
    pop ax
    pop bx
    inc ax
    pop cx
    loop @row_loop

        ; повернути збережений index
        pop di
    xor cx, cx
    mov cl, board[di]
    cmp cx, 0
    jne @continue
    add sp, 4       ; прибрати зайві значення ax та bx
    jmp @done_drawing
    @continue:
    mov bx, 1
    shl bx, cl         ; множення на 2 (піднесення в степінь)

    push bx             ; значення плитки
    call num_to_str     ; рядок у buffer, довжина у cx
    add sp, 2

    ; padding = (cell_width - string_length) / 2
    mov ax, TILE_WIDTH
    sub ax, cx
    shr ax, 1
    mov cx, ax

        ; повернути збережені рядок та колонку
        pop ax
        pop bx

    inc ax
    add bx, cx          ; add padding

    xor dx, dx
    mov dl, tile_colors[si]
    shl dx, 4
    push dx
    push ax
    push bx
    push offset buffer
    call print_line
    add sp, 8
    
    @done_drawing:
    pop dx
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret
    draw_tile ENDP

animate_tile PROC ; КТ-5-6
; зробити покадрову анімацію зсуву клітинки
    push bp
    mov bp, sp

    ; стерти стару позицію
    ; намалювати нову зсунуту позицію
    ; зробити маленьку затримку
    ; повторити 

    pop bp
    ret
    animate_tile ENDP

num_to_str PROC ; КТ-3
; відображення числа в рядок та знаходження довжини
    push bp
    mov bp, sp
    push ax
    push bx
    push dx
    push di

    ; повернути рядок в buffer, довжину в cx
    ; [bp+4] - значення плитки
    mov ax, [bp+4]
    xor cx, cx
    mov bx, 10

    mov di, offset buffer

    convert:
    xor dx, dx
    div bx          ; ax - частка, dx - остача
    push dx
    inc cx
    cmp ax, 0
    jne convert

    mov bx, cx      ; зберігти довжину

    write:
    pop dx
    add dl, '0'
    mov [di], dl
    inc di
    loop write
    mov byte ptr [di], '$'

    mov cx, bx      ; повертаємо довжину

    pop di
    pop dx
    pop bx
    pop ax
    pop bp
    ret
    num_to_str ENDP

draw_score PROC ; КТ-4
; вивести поточний і найкращий рахунок (порівняння best та current)
    push bp
    mov bp, sp
    push ax
    push bx
    push cx

    ; заповнити рядок синім кольором
    xor di, di
    @next:
    mov ah, 01h
    mov al, 219
    mov es:[di], ax
    cmp di, 158
    je @done_filling
    add di, 2
    jmp @next

    @done_filling:
    ; оновлення curr_score
    mov ax, curr_score
    push ax
    call num_to_str
    add sp, 2

    push 1Fh
    push 0
    push 1
    push offset curr_msg
    call print_line
    add sp, 8

    push 1Fh
    push 0
    push CURR_LEN+1
    push offset buffer
    call print_line
    add sp, 8

    ; оновлення best_score
    mov ax, best_score
    push ax
    call num_to_str
    add sp, 2

    mov bx, 79
    sub bx, cx
    sub bx, BEST_LEN

    push 1Fh
    push 0
    push bx
    push offset best_msg
    call print_line
    add sp, 8

    add bx, BEST_LEN
    push 1Fh
    push 0
    push bx
    push offset buffer
    call print_line
    add sp, 8

    pop cx
    pop bx
    pop ax
    pop bp
    ret
    draw_score ENDP

draw_game_over PROC ; КТ-5
; вивід повідомлення GAME OVER
    push bp
    mov bp, sp

    pop bp
    ret
    draw_game_over ENDP

draw_win PROC ; КТ-5
; вивід повідомлення WIN
    push bp
    mov bp, sp

    pop bp
    ret
    draw_win ENDP