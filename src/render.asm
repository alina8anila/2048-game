; ===========================================
; render.asm - процедури рендерингу та вводу
; ===========================================

draw_board PROC ; КТ-4
; draw game board (with frame and tiles)
    push bp
    mov bp, sp
    push di
    push dx
    push ax
    push bx
    push cx
    
    ; screen cleaning
    xor di, di
    mov cx, 80 * 25
    mov ax, 0720h  
    @cls:
    mov es:[di], ax
    add di, 2
    loop @cls

    ; print frame
    ; from draw_tile: row = start_row + (tile_height + 1) * grid_row,   column = start_col + (tile_width + 1) * grid_column 
    ; Upper frame border: (start_row - 1, start_col - 1) - кут
    ; Lower frame border: (start_row - 1 + 4*(TILE_HEIGHT+1), start_col - 1 + 4*(TILE_WIDTH+1))

    ; Outer frame:
    ; ASCII: ║ 186, ═ 205, ╟ 199, ╢ 182, ╧ 207, ╤ 209, ╔ 201, ╗ 187, ╚ 200, ╝ 188
    ; Inner frame: 
    ; ASCII: │ 179, ─ 196, ┼ 197

    ; ------- Horizontal lines -------
    ; How many columns need to be passed (without corner ones)
    mov ax, TILE_WIDTH
    inc ax
    mov bx, board_type
    mul bx
    dec ax
    mov cx, ax

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
    div dl  ; ah - remainder
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
    mov dx, ax  ; offset by rows
    add di, dx  ; move to the next horizontal line
    
    mov cx, board_type
    dec cx
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
    add di, dx  ; move to the next horizontal line
    
    mov cx, board_type
    dec cx
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

    ; ------- Vertical lines -------
    ; How many rows need to be passed (without corner ones)
    mov ax, TILE_HEIGHT
    inc ax
    mov bx, board_type
    mul bx
    dec ax
    mov cx, ax

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
    div dl  ; ah - remainder
    cmp ah, TILE_HEIGHT
    je @on_vert_boundary

    mov ah, 0Fh
    mov al, 186     ; ║ 186
    mov es:[di], ax

    mov dx, TILE_WIDTH
    inc dx      
    shl dx, 1   ; offset by columns
    add di, dx  ; move to the next vertical line
    
    mov cx, BOARD_TYPE
    dec cx
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
    mov dx, board_type
    mul dx
    shl ax, 1
    mov dx, ax
    add di, dx  ; move to the last vertical line

    mov ah, 0Fh
    mov al, 182     ; ╢ 182
    mov es:[di], ax

    @next_row:
    pop di
    add di, 160

    inc si
    pop cx
    loop vertical

    ; ------- Corners -------
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
    mov bx, board_type
    mul bx
    shl ax, 1
    mov cx, ax  ; move to the last vertical line
    add di, cx
    
    mov ah, 0Fh
    mov al, 187     ; ╗ 187
    mov es:[di], ax

    pop di
    mov ax, TILE_HEIGHT
    inc ax
    mov bx, board_type
    mul bx
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

        mov cx, board_type
        xor ax, ax
        rows:
        push cx
        mov cx, board_type
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

print_help_texts PROC
    push bp
    mov bp, sp
    push ax
    push di
    push cx

    ; fill the line with blue colour for msg
    mov di, 24*80
    shl di, 1
    mov cx, 80
    @fill_loop:
    mov ah, 03h
    mov al, 219
    mov es:[di], ax
    add di, 2
    loop @fill_loop

    ; clean line for hint
    mov di, 23*80
    shl di, 1
    mov cx, 80
    @clean_loop:
    mov ax, 0120h
    mov es:[di], ax
    add di, 2
    loop @clean_loop

    ; title
    cmp game_phase, byte ptr 0
    je @title_continues
    push 07h
    jmp @print_title
    @title_continues:
    push 0Eh
    @print_title:
    push 1
    mov ax, 80
    sub ax, TITLE_LEN
    shr ax, 1
    push ax     ; (80-TITLE_LEN)/2
    push offset game_title
    call print_line
    add sp, 8

    ; msg
    xor ax, ax
    mov al, game_phase
    shl ax, 1
    mov si, offset msg_table
    add si, ax
    push 30h
    push 24
    push 1
    push [si]
    call print_line
    add sp, 8

    ; hint
    xor ax, ax
    mov al, game_phase
    shl ax, 1
    mov si, offset hint_table
    add si, ax
    mov di, offset HINT_LENS
    add di, ax
    cmp game_phase, byte ptr 0
    je @hint_continues
    cmp game_phase, byte ptr 1
    je @hint_win
    push 0Ch
    jmp @print_hint
    @hint_continues:
    push 0Fh
    jmp @print_hint
    @hint_win:
    push 0Ah
    @print_hint:
    push 23
    mov ax, 80
    sub ax, [di]
    shr ax, 1
    push ax
    push [si]
    call print_line
    add sp, 8

    pop cx
    pop di
    pop ax
    pop bp
    ret
print_help_texts ENDP
print_line PROC
; print null-terminated text line by position
    push bp
    mov bp, sp
    push ax
    push bx
    push di
    push si

    ; [bp+10] - color attribute, [bp+8] - row, [bp+6] - column, [bp+4] - offset
    ; di = (row * 80 + column) * 2
    mov ax, [bp+8]
    mov bx, 80
    mul bx
    add ax, [bp+6]
    shl ax, 1
    mov di, ax
    ; si - offset
    mov si, [bp+4]
    ; ah - color attribute
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
    push ax
    push bx
    push cx
    ; start_row = (25 - (board_type * (TILE_HEIGHT + 1) - 1)) / 2
    ; return value to dx

    mov cx, 25
    mov ax, TILE_HEIGHT
    inc ax
    mov bx, board_type
    mul bx
    dec ax
    sub cx, ax
    shr cx, 1
    mov dx, cx

    pop cx
    pop bx
    pop ax
    pop bp
    ret
find_start_row ENDP

find_start_col PROC
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    ; start_col = (80 - (board_type * (TILE_WIDTH + 1) - 1)) / 2
    ; return value to dx

    mov cx, 80
    mov ax, TILE_WIDTH
    inc ax
    mov bx, board_type
    mul bx
    dec ax
    sub cx, ax
    shr cx, 1
    mov dx, cx

    pop cx
    pop bx
    pop ax
    pop bp
    ret
find_start_col ENDP

draw_tile PROC ; КТ-3
; draw a tile with its value
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    push di
    push dx

    ; [bp+6] - grid_row, [bp+4] - grid_column
    ; calculate the index to take the value: row*board_type+column
    mov ax, [bp+6]
    mov bx, board_type
    mul bx
    add ax, [bp+4]
    mov di, ax    
        ; save index
        mov cx, di
    mov al, board[di]
    xor ah, ah   
    mov si, ax     ; si - power of 2

    ; row = start_row + (tile_height+1) * grid_row,   column = start_col + (tile_width+1) * grid_column 
    ; with spaces between edges and for frame borders between tiles
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

        ; save column, row and index
        push bx
        push ax
        push cx

    ; draw a rectangle
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
        mov ah, tile_colors[si] ; colour
        mov al, 219             ; symbol
        mov es:[di], ax

        add di, 2
        loop @col_loop
    pop ax
    pop bx
    inc ax
    pop cx
    loop @row_loop

        ; return saved index
        pop di
    xor cx, cx
    mov cl, board[di]
    cmp cx, 0
    jne @continue
    add sp, 4       ; delete saved row and column from stack
    jmp @done_drawing
    @continue:
    mov bx, 1
    shl bx, cl         ; multiply by 2 cl times (raise to a power of cl)

    ; padding_row = (TILE_HEIGHT - 1) / 2
    mov ax, TILE_HEIGHT
    dec ax
    shr ax, 1
    mov cx, ax ; cx = padding_row
        pop ax ; return saved row
    add ax, cx

    push bx             ; tile value
    call num_to_str     ; line in a buffer, length in cx
    add sp, 2
    ; padding_col = (TILE_WIDTH - string_length) / 2
    mov bx, TILE_WIDTH
    sub bx, cx
    shr bx, 1
    mov cx, bx ; cx = padding_col
        pop bx ; return saved column
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

num_to_str PROC ; КТ-3
; dispplay number into a string and find its length
    push bp
    mov bp, sp
    push ax
    push bx
    push dx
    push di

    ; return line in buffer, length in cx
    ; [bp+4] - tile value
    mov ax, [bp+4]
    xor cx, cx
    mov bx, 10

    mov di, offset buffer

    convert:
    xor dx, dx
    div bx          ; ax - quotient, dx - remainder
    push dx
    inc cx
    cmp ax, 0
    jne convert

    mov bx, cx      ; save length

    write:
    pop dx
    add dl, '0'
    mov [di], dl
    inc di
    loop write
    mov byte ptr [di], '$'

    mov cx, bx      ; return saved length

    pop di
    pop dx
    pop bx
    pop ax
    pop bp
    ret
    num_to_str ENDP

draw_score PROC ; КТ-4
; print current and best scores
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push di

    ; fill the line with blue colour
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
    ; update curr_score
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

    ; update best_score
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
; print GAME OVER
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push di

    ; permanent position
    ; window 23x7
    ; row=(25-7)/2=9, column=(80-21)/2=28
    
    ; frame:
    ; ASCII: ║ 186, ═ 205, ╔ 201, ╗ 187, ╚ 200, ╝ 188
    ; ------- Horizontal lines -------
    mov ax, 9
    mov bx, 29
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax

    mov cx, 21  ; 23-2=21 because of corners
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

    ; ------- Vertical lines -------
    mov ax, 10
    mov bx, 28
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax

    mov cx, 5   ; 7-2=5 because of corners
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

    ; ------- Corners -------
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

    ; window
    mov ax, 9
    inc ax
    mov bx, 28
    inc bx
    mov cx, 5   ; 7-2=5 because of frame
    @rows:
    push cx
    push bx
    push ax
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax
    mov cx, 21  ; 23-2=21 because of frame
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
; print WIN
        push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push di

    ; permanent position
    ; window 23x7
    ; row=(25-7)/2=9, column=(80-21)/2=28
    
    ; рамка
    ; ASCII: ║ 186, ═ 205, ╔ 201, ╗ 187, ╚ 200, ╝ 188
    ; ------- Horizontal lines -------
    mov ax, 9
    mov bx, 29
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax

    mov cx, 21  ; 23-2=21 because of corners
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

    ; ------- Vertical lines -------
    mov ax, 10
    mov bx, 28
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax

    mov cx, 5   ; 7-2=5 because of corners
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

    ; ------- Corners -------
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
    mov cx, 5   ; 7-2=5 because of frame
    @@rows:
    push cx
    push bx
    push ax
    mov dx, 80
    mul dx
    add ax, bx
    shl ax, 1
    mov di, ax
    mov cx, 21  ; 23-2=21 because of frame
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
    push 11
    push 33
    push offset g_win
    call print_line
    add sp, 8

    ; 28+(23-CURR_LEN)/2
    mov bx, 23
    sub bx, CURR_LEN
    shr bx, 1
    add bx, 28
    push 2Eh
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
    push 2Eh
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
    draw_win ENDP