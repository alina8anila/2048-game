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
    ; з draw_tile: row = start_row + (tile_height + 1) * grid_row,   column = start_col + (tile_width + 1) * grid_column 
    ; Верхня границя рамки: (start_row - 1, start_col - 1) - кут
    ; Нижня границя рамки: (start_row - 1 + 4*(TILE_HEIGHT+1), start_col - 1 + 4*(TILE_WIDTH+1))

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

    call find_start_col
    mov bx, dx  ; start_col
    ; DI = (row * 80 + column) * 2
    call find_start_row
    mov ax, dx
    dec ax  ; start_row - 1
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax
    
    horizontal:
    push cx
    push di
    ; local_col = current_col - start_col,   bx = current_col
    ; offset = local_col % (WIDTH + 1)
    ; offset = 0 -> on_boarder

    mov ax, bx
    call find_start_col
    sub ax, dx  ; ax = local_col

    xor dx, dx
    mov dl, TILE_WIDTH
    inc dl
    div dl  ; ah - остача
    cmp ah, TILE_WIDTH
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
    mov dx, ax
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

    call find_start_row
    mov si, dx
    ; DI = (row * 80 + column) * 2
    mov ax, si
    mov dx, 80
    mul dx
    call find_start_col
    dec dx
    add ax, dx
    shl ax, 1
    mov di, ax

    vertical:
    push cx
    push di
    ; local_row = current_row - start_row,   si = current_row
    ; offset = local_row % (HEIGHT + 1)
    ; offset = 0 -> on_boarder

    mov ax, si
    call find_start_row
    sub ax, dx  ; ax = local_col

    xor dx, dx
    mov dl, TILE_HEIGHT
    inc dl
    div dl  ; ah - остача
    cmp ah, TILE_HEIGHT
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
    mov dx, ax
    add di, dx  ; перейти до найправішої вертикалі

    mov ah, 0Fh
    mov al, 182     ; ╢ 182
    mov es:[di], ax

    @next_row:
    pop di
    add di, 160

    inc si
    pop cx
    loop vertical

    ; ------- кути -------
    call find_start_row
    dec dx
    mov ax, dx
    mov dx, 80
    mul dx
    call find_start_col
    dec dx
    add ax, dx
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

find_start_row PROC
    push bp
    mov bp, sp
    push bx
    ; start_row = (25 - (4 * TILE_HEIGHT + 3)) / 2
    ; повернути в dx

    mov dx, 25
    mov bx, TILE_HEIGHT
    shl bx, 2
    add bx, 3
    sub dx, bx
    shr dx, 1

    pop bx
    pop bp
    ret
find_start_row ENDP

find_start_col PROC
    push bp
    mov bp, sp
    push bx
    ; start_col = (80 - (4 * TILE_WIDTH + 3)) / 2
    ; повернути в dx

    mov dx, 80
    mov bx, TILE_WIDTH
    shl bx, 2
    add bx, 3
    sub dx, bx
    shr dx, 1

    pop bx
    pop bp
    ret
find_start_col ENDP

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

    ; row = start_row + (tile_height+1) * grid_row,   column = start_col + (tile_width+1) * grid_column 
    ; з відступами від країв та місцями для рамки МІЖ клітинками
    mov ax, [bp+4]
    mov di, TILE_WIDTH
    inc di
    mul di
    call find_start_col ; dx = start_col
    add ax, dx
    mov bx, ax      ; bx - column

    mov ax, [bp+6]
    mov di, TILE_HEIGHT 
    inc di
    mul di    
    call find_start_row ; dx = start_row   
    add ax, dx      ; ax - row

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

    ; padding_row = (TILE_HEIGHT - 1) / 2
    mov ax, TILE_HEIGHT
    dec ax
    shr ax, 1
    mov cx, ax ; cx = padding_row
        pop ax ; повернути рядок
    add ax, cx

    push bx             ; значення плитки
    call num_to_str     ; рядок у buffer, довжина у cx
    add sp, 2
    ; padding_col = (TILE_WIDTH - string_length) / 2
    mov bx, TILE_WIDTH
    sub bx, cx
    shr bx, 1
    mov cx, bx ; cx = padding_col
        pop bx ; повернути стовпець
    add bx, cx

    xor dx, dx
    mov dl, tile_colors[si]
    shl dx, 4
    push dx
    push ax ; row
    push bx ; column
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
    push di

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

    pop di
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
    push ax
    push bx
    push cx
    push di

    ; стала позиція
    ; вікно 23x7
    ; row=(25-7)/2=9, column=(80-21)/2=28
    
    ; рамка
    ; ASCII: ║ 186, ═ 205, ╔ 201, ╗ 187, ╚ 200, ╝ 188
    ; ------- горизонтальні лінії -------
    mov ax, 9
    mov bx, 29
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax

    mov cx, 21  ; 23-2=21 через кути
    @hor:
    push di
    mov ah, 4Eh
    mov al, 205 ; ═ 205
    mov es:[di], ax
    add di, 160*6
    mov es:[di], ax
    pop di
    add di, 2
    loop @hor

    ; ------- вертикальні лінії -------
    mov ax, 10
    mov bx, 28
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax

    mov cx, 5   ; 7-2=5 через кути
    @vert:
    push di
    mov ah, 4Eh
    mov al, 186 ; ║ 186
    mov es:[di], ax
    add di, 22*2
    mov es:[di], ax
    pop di
    add di, 160
    loop @vert

    ; ------- кути -------
    mov ax, 9
    mov bx, 28
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax
    push di

    mov ah, 4Eh
    mov al, 201 ; ╔ 201
    mov es:[di], ax

    add di, 22*2

    mov ah, 4Eh
    mov al, 187 ; ╗ 187
    mov es:[di], ax

    pop di
    add di, 160*6

    mov ah, 4Eh
    mov al, 200 ; ╚ 200
    mov es:[di], ax

    add di, 22*2

    mov ah, 4Eh
    mov al, 188 ; ╝ 188
    mov es:[di], ax

    ; вікно
    mov ax, 9
    inc ax
    mov bx, 28
    inc bx
    mov cx, 5   ; 7-2=5 через рамку
    @rows:
    push cx
    push bx
    push ax
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax
    mov cx, 21  ; 23-2=21 через рамку
        @columns:
        mov ah, 04h
        mov al, 219
        mov es:[di], ax
        add di, 2
        loop @columns
    pop ax
    inc ax
    pop bx
    pop cx
    loop @rows

    ; text="G A M E   O V E R", length=17
    ; text_row=row+7/2=9+3=12, text_column=column+(23-length)/2=28+3=31

    push 4Eh
    push 11
    push 31
    push offset g_over
    call print_line
    add sp, 8

    ; 28+(23-CURR_LEN)/2
    mov bx, 23
    sub bx, CURR_LEN
    shr bx, 1
    add bx, 28
    push 4Eh
    push 13
    push bx
    push offset curr_msg
    call print_line
    add sp, 8

    push curr_score
    call num_to_str
    add sp, 2
    ; 28+(23-cx)/2
    mov bx, 23
    sub bx, cx
    shr bx, 1
    add bx, 28
    push 4Eh
    push 14
    push bx
    push offset buffer
    call print_line
    add sp, 8

    pop di
    pop cx
    pop bx
    pop ax
    pop bp
    ret
    draw_game_over ENDP

draw_win PROC ; КТ-5
; вивід повідомлення WIN
        push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push di

    ; стала позиція
    ; вікно 23x7
    ; row=(25-7)/2=9, column=(80-21)/2=28
    
    ; рамка
    ; ASCII: ║ 186, ═ 205, ╔ 201, ╗ 187, ╚ 200, ╝ 188
    ; ------- горизонтальні лінії -------
    mov ax, 9
    mov bx, 29
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax

    mov cx, 21  ; 23-2=21 через кути
    @@hor:
    push di
    mov ah, 2Eh
    mov al, 205 ; ═ 205
    mov es:[di], ax
    add di, 160*6
    mov es:[di], ax
    pop di
    add di, 2
    loop @@hor

    ; ------- вертикальні лінії -------
    mov ax, 10
    mov bx, 28
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax

    mov cx, 5   ; 7-2=5 через кути
    @@vert:
    push di
    mov ah, 2Eh
    mov al, 186 ; ║ 186
    mov es:[di], ax
    add di, 22*2
    mov es:[di], ax
    pop di
    add di, 160
    loop @@vert

    ; ------- кути -------
    mov ax, 9
    mov bx, 28
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax
    push di

    mov ah, 2Eh
    mov al, 201 ; ╔ 201
    mov es:[di], ax

    add di, 22*2

    mov ah, 2Eh
    mov al, 187 ; ╗ 187
    mov es:[di], ax

    pop di
    add di, 160*6

    mov ah, 2Eh
    mov al, 200 ; ╚ 200
    mov es:[di], ax

    add di, 22*2

    mov ah, 2Eh
    mov al, 188 ; ╝ 188
    mov es:[di], ax

    ; вікно
    mov ax, 9
    inc ax
    mov bx, 28
    inc bx
    mov cx, 5   ; 7-2=5 через рамку
    @@rows:
    push cx
    push bx
    push ax
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax
    mov cx, 21  ; 23-2=21 через рамку
        @@columns:
        mov ah, 02h
        mov al, 219
        mov es:[di], ax
        add di, 2
        loop @@columns
    pop ax
    inc ax
    pop bx
    pop cx
    loop @@rows

    ; text="Y O U   W O N", length=13
    ; text_row=row+7/2=9+3=12, text_column=column+(23-length)/2=28+5=33

    push 2Eh
    push 12
    push 33
    push offset g_win
    call print_line
    add sp, 8

    pop di
    pop cx
    pop bx
    pop ax
    pop bp
    ret
    draw_win ENDP