section .data
    prompt db "Enter a number: ", 0
    pos_msg db "POSITIVE", 0
    neg_msg db "NEGATIVE", 0
    zero_msg db "ZERO", 0
    input db 0, 0, 0, 0, 0   ; Buffer to store user input

section .bss
    num resb 4              ; Reserve space for the number

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, prompt         ; address of prompt message
    mov edx, 15             ; length of message
    int 0x80                ; invoke syscall

    ; Read input
    mov eax, 3              ; syscall: read
    mov ebx, 0              ; file descriptor: stdin
    mov ecx, input          ; address of input buffer
    mov edx, 5              ; number of bytes to read
    int 0x80                ; invoke syscall

    ; Convert input to integer
    mov ecx, input          ; pointer to input
    call atoi               ; call subroutine to convert input to integer
    mov [num], eax          ; store the converted number

    ; Check if number is zero
    cmp eax, 0
    je zero_case            ; jump to zero_case if eax == 0

    ; Check if number is positive
    cmp eax, 0
    jg positive_case        ; jump to positive_case if eax > 0

    ; Otherwise, it's negative
    jmp negative_case       ; unconditional jump to negative_case

zero_case:
    ; Print "ZERO"
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, zero_msg       ; address of zero_msg
    mov edx, 4              ; length of message
    int 0x80                ; invoke syscall
    jmp end_program         ; end program

positive_case:
    ; Print "POSITIVE"
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, pos_msg        ; address of pos_msg
    mov edx, 8              ; length of message
    int 0x80                ; invoke syscall
    jmp end_program         ; end program

negative_case:
    ; Print "NEGATIVE"
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, neg_msg        ; address of neg_msg
    mov edx, 8              ; length of message
    int 0x80                ; invoke syscall

end_program:
    ; Exit the program
    mov eax, 1              ; syscall: exit
    xor ebx, ebx            ; exit code: 0
    int 0x80                ; invoke syscall

; Subroutine to convert string to integer
atoi:
    xor eax, eax            ; clear eax (result)
    xor ebx, ebx            ; clear ebx (temporary)
atoi_loop:
    mov bl, byte [ecx]      ; get current character
    cmp bl, 0xA             ; check if newline
    je atoi_done            ; if newline, we're done
    sub bl, '0'             ; convert ASCII to digit
    imul eax, eax, 10       ; multiply result by 10
    add eax, ebx            ; add current digit
    inc ecx                 ; move to the next character
    jmp atoi_loop           ; repeat the loop
atoi_done:
    ret
