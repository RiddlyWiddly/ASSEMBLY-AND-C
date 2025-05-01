section .data
    prompt         db 'Enter number: ', 0
    result         db 'The sum is: ', 0
    final_result   db 'Final sum is: ', 0
    crlf           db 10, 0

section .bss
    num1           resq 1
    num2           resq 1
    sum            resq 1
    count          resq 1
    input_buffer   resb 20       ; buffer for reading input

section .text
    global _start

_start:
    mov     qword [sum], 0
    mov     qword [count], 3

game_loop:
    ; Prompt and read first number
    mov     rsi, prompt
    call    print_string
    call    read_number
    mov     [num1], rax

    ; Prompt and read second number
    mov     rsi, prompt
    call    print_string
    call    read_number
    mov     [num2], rax

    ; Add numbers to sum
    mov     rax, [num1]
    add     rax, [num2]
    add     [sum], rax

    ; Print partial result
    mov     rsi, result
    call    print_string
    mov     rax, [sum]
    call    print_number
    call    newline

    ; Loop control
    dec     qword [count]
    jnz     game_loop

    ; Final result
    mov     rsi, final_result
    call    print_string
    mov     rax, [sum]
    call    print_number
    call    newline

    ; Exit program
    mov     rax, 60
    xor     rdi, rdi
    syscall

; -----------------------------------
; print_string: Print null-terminated string in RSI
print_string:
    mov     rax, 1
    mov     rdi, 1
    mov     rdx, 0
find_len:
    cmp     byte [rsi + rdx], 0
    je      .write
    inc     rdx
    jmp     find_len
.write:
    syscall
    ret

; -----------------------------------
; print_number: Print number in RAX
print_number:
    mov     rbx, 10
    mov     rcx, 0
    mov     rdx, 0
    sub     rsp, 32             ; reserve space on stack
    mov     rsi, rsp            ; buffer pointer

.convert_loop:
    xor     rdx, rdx
    div     rbx                 ; RAX / 10, quotient in RAX, remainder in RDX
    add     dl, '0'
    dec     rsi
    mov     [rsi], dl
    inc     rcx
    test    rax, rax
    jnz     .convert_loop

.print_loop:
    mov     rax, 1
    mov     rdi, 1
    mov     rdx, rcx
    syscall
    add     rsp, 32             ; clean up stack
    ret

; -----------------------------------
; newline: Print newline character
newline:
    mov     rsi, crlf
    call    print_string
    ret

; -----------------------------------
; read_number: Read from stdin and return number in RAX
read_number:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, input_buffer
    mov     rdx, 20
    syscall

    xor     rax, rax
    xor     rbx, rbx
    mov     rcx, input_buffer

.convert:
    mov     bl, byte [rcx]
    cmp     bl, 10          ; newline?
    je      .done
    cmp     bl, 0
    je      .done
    sub     bl, '0'
    imul    rax, 10
    add     rax, rbx
    inc     rcx
    jmp     .convert
.done:
    ret
