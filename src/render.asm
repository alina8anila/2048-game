; ===========================================
; render.asm - процедури рендерингу та вводу
; ===========================================

draw_board PROC ; КТ-4
; намалювати ігрове поле (рамку)
    push bp
    mov bp, sp
    push di
    push dx
    push ax
    push bx
    push cx
    
    ; очищення екрану
    xor di, di
    mov cx, 80 * 25
    mov ax, 0720h  
    @cls:
    mov es:[di], ax
    add di, 2
    loop @cls

    ; вивести рамку
    ; з draw_tile: row = 5 + (tile_height+1) * grid_row,   column = 25 + (tile_width+1) * grid_column 
    ; Верхня границя рамки: (4, 24) - кут
    ; Нижня границя рамки: (4+4*(TILE_HEIGHT+1), 24+4*(TILE_WIDTH+1))

    ; зовнішня рамка
    ; ASCII: ║ 186, ═ 205, ╟ 199, ╢ 182, ╧ 207, ╤ 209, ╔ 201, ╗ 187, ╚ 200, ╝ 188
    ; внутрішня рамка 
    ; ASCII: │ 179, ─ 196, ┼ 197

    ; ------- горизонтальні лінії -------
    ; скільки стовпців треба пройти (без кутових)
    
    mov cx, TILE_WIDTH
    inc cx
    shl cx, 2
    dec cx

    mov bx, 25
    horizontal:
    push cx
    ; DI = (row * 80 + column) * 2
    ; column % (WIDTH + 1) == 0 - на межі з клітинкою
    mov ax, 4   ; row
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax
    push di

    mov ax, bx
    xor dx, dx
    mov dl, TILE_WIDTH
    inc dl
    div dl  ; ah - остача
    cmp ah, 0
    je @on_hor_boundary

    mov ah, 0Fh
    mov al, 205     ; ═ 205
    mov es:[di], ax

    mov ax, 80
    mov dl, TILE_HEIGHT
    inc dl
    mul dl 
    shl ax, 1
    mov dx, ax  ; offset по рядкам
    add di, dx  ; перейти до наступного горизонтального рядка
    
    mov cx, 3
        @single_hor:
        mov ah, 0Fh
        mov al, 196     ; ─ 196
        mov es:[di], ax

        add di, dx
        loop @single_hor

    mov ah, 0Fh
    mov al, 205     ; ═ 205
    mov es:[di], ax
    jmp @next_column

    @on_hor_boundary:
    mov ah, 0Fh
    mov al, 209     ; ╤ 209
    mov es:[di], ax

    mov ax, 80
    mov dl, TILE_HEIGHT
    inc dl
    mul dl 
    shl ax, 1
    mov dx, ax  ; offset по рядкам
    add di, dx  ; перейти до наступного горизонтального рядка
    
    mov cx, 3
        @single_lines_b:
        mov ah, 0Fh
        mov al, 197     ; ┼ 197
        mov es:[di], ax

        add di, dx
        loop @single_lines_b

    mov ah, 0Fh
    mov al, 207     ; ╧ 207
    mov es:[di], ax

    @next_column:
    pop di
    add di, 2

    inc bx
    pop cx
    loop horizontal

    ; ------- вертикальні лінії -------
    ; скільки рядків треба пройти (без кутових)
    mov cx, TILE_HEIGHT
    inc cx
    shl cx, 2
    dec cx

    mov si, 5       ; рядок 5
    vertical:
    push cx
    ; DI = (row * 80 + column) * 2
    ; row % (HEIGHT + 1) == 0 - на межі з клітинкою
    mov ax, si
    mov dx, 80
    mul dx
    add ax, 24
    shl ax, 1
    mov di, ax
    push di

    mov ax, si
    xor dx, dx
    mov dl, TILE_HEIGHT
    inc dl
    div dl  ; ah - остача
    cmp ah, 0
    je @on_vert_boundary

    mov ah, 0Fh
    mov al, 186     ; ║ 186
    mov es:[di], ax

    mov dx, TILE_WIDTH
    inc dx      
    shl dx, 1   ; offset по стовпцям
    add di, dx  ; перейти до наступної вертикалі 
    
    mov cx, 3
        @single_vert:
        mov ah, 0Fh
        mov al, 179     ; │ 179
        mov es:[di], ax

        add di, dx
        loop @single_vert

    mov ah, 0Fh
    mov al, 186     ; ║ 186
    mov es:[di], ax
    jmp @next_row

    @on_vert_boundary:
    mov ah, 0Fh
    mov al, 199     ; ╟ 199
    mov es:[di], ax

    mov ax, TILE_WIDTH
    inc ax
    mov dx, 4
    mul dx
    shl ax, 1
    mov dx, ax  ; offset по рядкам
    add di, dx  ; перейти до найправішох вертикалі

    mov ah, 0Fh
    mov al, 182     ; ╢ 182
    mov es:[di], ax

    @next_row:
    pop di
    add di, 2

    inc si
    pop cx
    loop vertical

    ; ------- кути -------
    mov ax, 4
    mov dx, 80
    mul dx
    add ax, 24
    shl ax, 1
    mov di, ax
    push di

    mov ah, 0Fh
    mov al, 201     ; ╔ 201
    mov es:[di], ax

    mov ax, TILE_WIDTH
    inc ax
    shl ax, 2
    shl ax, 1
    mov cx, ax  ; крок крайніми стовпцями рамки
    add di, cx
    
    mov ah, 0Fh
    mov al, 187     ; ╗ 187
    mov es:[di], ax

    pop di
    mov ax, TILE_HEIGHT
    inc ax
    shl ax, 2
    mov bx, 80
    mul bx
    shl ax, 1
    add di, ax

    mov ah, 0Fh
    mov al, 200     ; ╚ 200
    mov es:[di], ax

    add di, cx

    mov ah, 0Fh
    mov al, 188     ; ╝ 188
    mov es:[di], ax

    pop cx
    pop bx
    pop ax
    pop dx
    pop di
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

    ; row = 5 + (tile_height+1) * grid_row,   column = 25 + (tile_width+1) * grid_column 
    ; з відступами від країв та місцями для рамки МІЖ клітинками
    mov ax, [bp+4]
    mov di, TILE_WIDTH
    inc di
    mul di
    add ax, 25
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