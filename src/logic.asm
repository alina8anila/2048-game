; ===========================================
; logic.asm - процедури ігрової логіки
; ===========================================

get_num PROC
    ;ax=pow(2, [bp+4])
    push bp
    mov bp, sp
    push cx
    push bx

    mov ax, 1
    mov bx, 2
    xor cx, cx
    mov cl, [bp+4]

    cmp cx, 0
    je end_getnum ;if([bp+4]==0) return 1
    for_getnum:
        mul bx
        loop for_getnum
    end_getnum:

    pop bx
    pop cx
    pop bp
    ret
    get_num ENDP

compress_row PROC ; КТ-3
; збір ненульових плиток (для slide_left)
    push bp
    mov bp, sp
    push bx
    push si
    push di
    push ax
    
    mov si, [bp+4]   ;board offset
    mov bx, si
    add bx, 4        ;bx-end

    go_si:
        cmp [si], byte ptr 0
        jne inc_si   ;if([si]!=0) inc_si

        mov di, si   ;di-second pointer
        find_not0:
            inc di
            cmp di, bx
            je endgo_si   ;if([dx]==bx(end)) endgo_si

            cmp byte ptr [di], 0
            jne set_num   ;if([dx]!=0) set_num
            jmp find_not0 ;else find_not0

        set_num:
            mov al, [di]
            mov [si], al
            mov byte ptr [di], 0

        inc_si:
            inc si
            cmp si, bx 
            jne go_si  ;while([si]!=bx(end))
    
    endgo_si:
    pop ax
    pop di
    pop si
    pop bx
    pop bp
    ret
    compress_row ENDP

merge_row PROC ; КТ-3
; злиття сусідніх рівних (для slide_left)
    push bp
    mov bp, sp
    push bx
    push si
    push ax
    
    mov si, [bp+4]   ;board offset
    mov bx, si
    add bx, 3        ;bx-end, 3 because we have to be able to get to [si+1]

    formerge:
        cmp [si], byte ptr 0
        je inc_si_merge    ;if([si]==0) inc_si_merge
        mov al, [si]
        cmp al, [si+1]
        je merge_2blocks   ;if([si]==[si+1]) merge_2blocks
        jmp inc_si_merge   ;else inc_si_merge
        
        merge_2blocks:
            inc byte ptr [si]      ;left++

            push [si]
            call get_num
            add sp, 2
            add curr_score, ax

            mov ax, curr_score
            cmp ax, best_score
            jle not_set_best_score
            mov best_score, ax
            not_set_best_score:

            mov [si+1], byte ptr 0 ;right=0
            inc si
        inc_si_merge:
            inc si
            cmp si, bx
            jl formerge   ;if(si<bx) formerge 
    pop ax
    pop si
    pop bx
    pop bp
    ret
    merge_row ENDP

slide_left PROC ; КТ-4
; зсув ліворуч (Підхід A)
    push si
    push cx
    push bx
    push ax

    mov bx, offset board
    mov si, offset row
    mov cx, 4
    @@for_sl:
        ;set row from board
        push cx ;save cx for for_sl
        push si ;save offset of row
        push bx ;save offset of board
        mov cx, 4
        @@set_row:
            mov al, [bx]
            mov [si], al
            inc si
            inc bx
        loop @@set_row
        pop bx  ;restore offset of board
        pop si  ;restore offset of row
        pop cx  ;restore cx for for_sl

        push si
        call compress_row
        call merge_row
        call compress_row
        add sp, 2

        ;set board from row
        push cx ;save cx for for_sl
        push si ;save offset of row
        push bx ;save offset of board 
        mov cx, 4
        @@set_board:
        mov al, [si]
            mov [bx], al
            inc si
            inc bx
        loop @@set_board
        pop bx  ;restore offset of board
        pop si  ;restore offset of row
        pop cx  ;restore cx for for_sl
    
        add bx, 4 ;go to next row in board
    loop @@for_sl

    pop ax
    pop bx
    pop cx
    pop si
    ret
    slide_left ENDP

slide_right PROC ; КТ-4
; зсув праворуч
    push si
    push cx
    push bx
    push ax
    
    mov bx, offset board
    mov si, offset row
    mov cx, 4
    @@for_sl:
        ;set row from board
        push cx ;save cx for for_sl
        push si ;save offset of row
        push bx ;save offset of board
        add bx, 3 ;bx-end of row in board
        mov cx, 4
        @@set_row:
            mov al, [bx]
            mov [si], al
            inc si
            dec bx
        loop @@set_row
        pop bx  ;restore offset of board
        pop si  ;restore offset of row
        pop cx  ;restore cx for for_sl

        push si
        call compress_row
        call merge_row
        call compress_row
        add sp, 2

        ;set board from row
        push cx ;save cx for for_sl
        push si ;save offset of row
        push bx ;save offset of board 
        add bx, 3 ;bx-end of row in board
        mov cx, 4
        @@set_board:
        mov al, [si]
            mov [bx], al
            inc si
            dec bx
        loop @@set_board
        pop bx  ;restore offset of board
        pop si  ;restore offset of row
        pop cx  ;restore cx for for_sl
    
        add bx, 4 ;go to next row in board
    loop @@for_sl

    pop ax
    pop bx
    pop cx
    pop si
    ret
    slide_right ENDP

slide_up PROC ; КТ-4
; зсув вверх
    push si
    push cx
    push bx
    push ax
    
    mov bx, offset board
    mov si, offset row
    mov cx, 4
    @@for_sl:
        ;set row from board
        push cx ;save cx for for_sl
        push si ;save offset of row
        push bx ;save offset of board
        mov cx, 4
        @@set_row:
            mov al, [bx]
            mov [si], al
            inc si
            add bx, 4 ;jump to next row in board
        loop @@set_row
        pop bx  ;restore offset of board
        pop si  ;restore offset of row
        pop cx  ;restore cx for for_sl

        push si
        call compress_row
        call merge_row
        call compress_row
        add sp, 2

        ;set board from row
        push cx ;save cx for for_sl
        push si ;save offset of row
        push bx ;save offset of board 
        mov cx, 4
        @@set_board:
        mov al, [si]
            mov [bx], al
            inc si
            add bx, 4 ;jump to next row in board
        loop @@set_board
        pop bx  ;restore offset of board
        pop si  ;restore offset of row
        pop cx  ;restore cx for for_sl
    
        inc bx  ;go to next column in board
    loop @@for_sl

    pop ax
    pop bx
    pop cx
    pop si
    ret
    slide_up ENDP

slide_down PROC ; КТ-4
push si
    push cx
    push bx
    push ax
    
    mov bx, offset board
    mov si, offset row
    mov cx, 4
    @@for_sl:
        ;set row from board
        push cx ;save cx for for_sl
        push si ;save offset of row
        push bx ;save offset of board
        add bx, 12 ;go to last row on board
        mov cx, 4
        @@set_row:
            mov al, [bx]
            mov [si], al
            inc si
            sub bx, 4 ;jump to next row in board
        loop @@set_row
        pop bx  ;restore offset of board
        pop si  ;restore offset of row
        pop cx  ;restore cx for for_sl

        push si
        call compress_row
        call merge_row
        call compress_row
        add sp, 2

        ;set board from row
        push cx ;save cx for for_sl
        push si ;save offset of row
        push bx ;save offset of board
        add bx, 12 ;go to last row on board
        mov cx, 4
        @@set_board:
        mov al, [si]
            mov [bx], al
            inc si
            sub bx, 4 ;jump to next row in board
        loop @@set_board
        pop bx  ;restore offset of board
        pop si  ;restore offset of row
        pop cx  ;restore cx for for_sl
    
        inc bx  ;go to next column in board
    loop @@for_sl

    pop ax
    pop bx
    pop cx
    pop si
    ret
    slide_down ENDP

spawn_tile PROC ; КТ-4
; в рандомному пустому місці ставить плитку 2 або 4
    push cx
    push bx
    push si
    push dx
    push ax

    xor bx, bx
    mov cx, 16
    mov si, offset board

    push si ;save offset of board
    for_count0:
        cmp [si], byte ptr 0
        jne @@skip
        inc bx
        @@skip:
        inc si
        loop for_count0
    pop si ;restore offset of board
    
    push bx
    call random_range 
    add sp, 2
    mov bx, ax      ;bx=випадкове число 0..bx-1

    mov ax, 10
    push ax
    call random_range ;ax=випадкове число 0..9
    add sp, 2

    cmp ax, 0
    je set_ax2
    mov ax, 1
    jmp notset_ax2
    set_ax2:
    mov ax, 2
    notset_ax2:

    inc bx
    mov cx, 16
    for_count02:
        cmp [si], byte ptr 0
        jne @@skip2
        dec bx
        jz set_al_to_board
        @@skip2:
        inc si
        loop for_count02
    set_al_to_board:
    mov [si], al
    
    pop ax
    pop dx
    pop si
    pop bx
    pop cx
    ret
    spawn_tile ENDP

random_range PROC
    push bp
    mov bp, sp
    push bx
    push cx
    push dx
    
    mov ah, 00h ; Отримуємо число з системного таймера (кількість тіків)
    int 1ah             ; cx:dx = кількість тіків з опівночі
    ; seed = (seed * 25173 + 13849) AND FFFFh
    mov ax, dx          ; dx-початкове seed
    mov cx, 25173
    mul cx              ; ax=seed*25173
    add ax, 13849       ; ax=seed*25173+13849
    
    mov bx, [bp+4]      ; діапазон
    xor dx, dx          
    div bx              ; ax/bx, остача в dx
    mov ax, dx          ; ax=випадкове число 0..bx-1
    
    pop dx
    pop cx
    pop bx
    pop bp
    ret
    random_range ENDP

check_game_over PROC ; КТ-5
; перевірка сусідніх рівних плиток
    push si
    push cx

    push offset saveboard
    push offset board
    call copy_boards ;saveboard=board
    add sp, 4

    call slide_up
    call slide_down
    call slide_left
    call slide_right

    mov si, offset board
    mov cx, 16
    find0:
        cmp [si], byte ptr 0
        je notover ;if([si]==0) -> notover
        inc si
        loop find0
    mov game_phase, byte ptr 2 ;game over=2
    jmp end_checkgo

    notover:
    mov game_phase, byte ptr 0 ;0=game is going
    push offset board
    push offset saveboard
    call copy_boards ;board=saveboard
    add sp, 4
    end_checkgo:
    pop cx
    pop si
    ret
    check_game_over ENDP

check_win PROC ; КТ-5
;якщо плитка 2048 нова -> win якщо її нема або вона вже була то гра продовжуєтося
    push ax

    push offset prevboard
    call check_if_have_2024
    add sp, 2
    cmp ax, 1 ;if prevboard have 2024 (ax==1) -> not win
    je notwin

    push offset board
    call check_if_have_2024
    add sp, 2
    cmp ax, 0
    je notwin;if board don't have 2024 (ax==0) -> not win

    mov game_phase, 1
    jmp end_checkwin
    notwin: 
    mov game_phase, 0
    end_checkwin:
    pop ax
    ret
    check_win ENDP

check_if_have_2024 PROC ; КТ-5
;якщо є плитка 2048, то ax=1, інакше ax=0. Подаємо offset board
    push bp
    mov bp, sp
    push si
    push cx

    mov si, [bp+4]   ;board offset
    mov cx, 16
    for_check2024:
        cmp [si], byte ptr 11 ;11-це 2048
        je have2024
        inc si
        loop for_check2024
    xor ax, ax
    jmp end_check2024
    have2024:
    mov ax, 1 

    end_check2024:
    pop cx
    pop si
    pop bp
    ret
    check_if_have_2024 ENDP

copy_boards PROC
    push bp
    mov bp, sp
    push si
    push di
    push cx
    push ax

    mov di, [bp+6] ;to this board
    mov si, [bp+4] ;form this board

    mov cx, 16
    for_copy:
        mov al, [si]
        mov [di], al
        inc si
        inc di
        loop for_copy
    pop ax
    pop cx
    pop di
    pop si
    pop bp
    ret
    copy_boards ENDP

compare_boards PROC
    ; set ax=1 if same, ax=0 otherwise
    push bp
    mov bp, sp
    push si
    push di
    push cx

    mov di, [bp+6] ;fir
    mov si, [bp+4] ;sec

    mov cx, 16
    for_compare:
        mov al, [si]
        cmp [di], al
        jne noteq
        inc si
        inc di
        loop for_compare
    
    mov ax, 1
    jmp end_compare
    noteq:
    mov ax, 0
    jmp end_compare

    end_compare:
    pop cx
    pop di
    pop si
    pop bp
    ret
    compare_boards ENDP

prevboard_eq_board PROC
    push offset prevboard
    push offset board
    call copy_boards
    add sp, 4
    ret
    prevboard_eq_board ENDP