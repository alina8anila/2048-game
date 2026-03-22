; ===========================================
; logic.asm - процедури ігрової логіки
; ===========================================

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
    push bp
    mov bp, sp
    
    ; для 4 рядків викликати:
    ;  1. compress_row
    ;  2. merge_row
    ;  3. compress_row

    pop bp
    ret
    slide_left ENDP

slide_right PROC ; КТ-4
; зсув праворуч
    push bp
    mov bp, sp
    
    ; адаптувати під slide_left

    pop bp
    ret
    slide_right ENDP

slide_up PROC ; КТ-4
; зсув вверх
    push bp
    mov bp, sp
    
    ; адаптувати під slide_left

    pop bp
    ret
    slide_up ENDP

slide_down PROC ; КТ-4
; намалювати ігрове поле (рамку)
    push bp
    mov bp, sp
    
    ; адаптувати під slide_left

    pop bp
    ret
    slide_down ENDP

spawn_tile PROC ; КТ-4
; в рандомному пустому місці ставить плитку 2 або 4
    push bp
    mov bp, sp
    
    ; порахувати кількість пустих клітинок (n)
    ; визначити з PRNG число від 0 до n-1 (відповідає одній з наявних пустих клітинок)
    ; визначити з PRNG число 2 (90%) або 4 (10%)
    ; записати у відповідну комірку відповідне число

    pop bp
    ret
    spawn_tile ENDP

check_game_over PROC ; КТ-5
; перевірка сусідніх рівних плиток
    push bp
    mov bp, sp
    
    ; пройтись по всім плиткам, перевірити:
    ;  1. всі заповнені (не 0)
    ;  2. сусідні не однакові
    ; -> game over

    pop bp
    ret
    check_game_over ENDP

check_win PROC ; КТ-5
; пошук плитки 2048
    push bp
    mov bp, sp
    
    ; якщо є плитка 2024 -> win

    pop bp
    ret
    check_win ENDP