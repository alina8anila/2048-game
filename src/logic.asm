; ===========================================
; logic.asm - процедури ігрової логіки
; ===========================================

compress_row PROC ; КТ-3
; збір ненульових плиток (для slide_left)
    push bp
    mov bp, sp
    
    ; зсунути всі ненульові значення на початок
    ; заповнити решту нулями

    pop bp
    ret
    compress_row ENDP

merge_row PROC ; КТ-3
; злиття сусідніх рівних (для slide_left)
    push bp
    mov bp, sp
    
    ; пройти зліва направо
    ; якщо два сусідніх елементи рівні то подвоїти лівий
    ; обнулити правий

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