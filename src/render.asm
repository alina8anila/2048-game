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

    ; отримати позицію клітинки
    ; визначити позицію її значення та колір
    ; використовує num_to_str

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
; відображення числа в рядок
    push bp
    mov bp, sp

    ; ділити на 10, записуючи залишок в стек
    ; витягувати, додаючи 30h ('0')

    pop bp
    ret
    num_to_str ENDP

draw_score PROC ; КТ-4
; вивести поточний і найкращий рахунок (порівняння best та current)
    push bp
    mov bp, sp

    ; використовує num_to_str та print_line

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