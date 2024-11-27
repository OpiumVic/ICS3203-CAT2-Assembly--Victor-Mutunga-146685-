section .data
    msg_input db "Enter 5 integers (separated by space): ", 0
    msg_output db "Reversed array: ", 0
    newline db 10, 0
    size equ 5                       ; Number of integers expected

section .bss
    input_buffer resb 50            ; Buffer for user input (up to 50 characters)
    array resd 5                    ; Array for 5 integers (each 4 bytes)

section .text
    global _start

_start:
    ; Prompt the user for input
    mov eax, 4                      ; syscall: write
    mov ebx, 1                      ; stdout
    mov ecx, msg_input              ; Message address
    mov edx, 37                     ; Message length
    int 0x80                        ; Kernel call

    ; Read user input
    mov eax, 3                      ; syscall: read
    mov ebx, 0                      ; stdin
    mov ecx, input_buffer           ; Buffer to store input
    mov edx, 50                     ; Max buffer size
    int 0x80                        ; Kernel call

    ; Parse the input buffer into integers
    mov esi, input_buffer           ; Point to input buffer
    xor edi, edi                    ; Array index
    xor edx, edx                    ; Integer accumulator

parse_input:
    mov al, [esi]                   ; Load current character
    cmp al, 0                       ; Check for end of input
    je reverse_array                ; End parsing if null character
    cmp al, 32                      ; Check for space
    je save_integer                 ; Save integer on space
    cmp al, 10                      ; Check for newline
    je save_integer                 ; Save integer on newline

    ; Convert ASCII digit to integer
    sub al, '0'                     ; Convert ASCII to numeric
    imul edx, edx, 10               ; Multiply current result by 10
    add edx, eax                    ; Add new digit to result
    inc esi                         ; Move to the next character
    jmp parse_input                 ; Continue parsing

save_integer:
    cmp edi, 4                      ; Check if array index exceeds 4
    jg reverse_array                ; Stop parsing if array is full
    mov [array + edi*4], edx        ; Store integer in array
    xor edx, edx                    ; Reset integer accumulator
    inc edi                         ; Increment array index
    inc esi                         ; Skip space or newline
    jmp parse_input                 ; Continue parsing

reverse_array:
    ; Reverse the array in place
    xor ebx, ebx                    ; Left index
    mov ecx, 4                      ; Right index (size - 1)

reverse_loop:
    cmp ebx, ecx                    ; Check if pointers meet or cross
    jge print_output                ; If done, proceed to print

    ; Swap elements
    mov eax, [array + ebx*4]        ; Load left element
    mov edx, [array + ecx*4]        ; Load right element
    mov [array + ebx*4], edx        ; Store right element in left
    mov [array + ecx*4], eax        ; Store left element in right

    inc ebx                         ; Move left index
    dec ecx                         ; Move right index
    jmp reverse_loop                ; Repeat

print_output:
    ; Print the reversed array
    mov eax, 4                      ; syscall: write
    mov ebx, 1                      ; stdout
    mov ecx, msg_output             ; Output message address
    mov edx, 17                     ; Message length
    int 0x80                        ; Kernel call

    mov esi, array                  ; Point to array
    mov ecx, 5                      ; Number of elements to print

print_loop:
    mov eax, [esi]                  ; Load current element
    call print_integer              ; Print the integer
    add esi, 4                      ; Move to the next integer
    loop print_loop                 ; Continue until all are printed

    ; Exit program
    mov eax, 1                      ; syscall: exit
    xor ebx, ebx                    ; Exit code 0
    int 0x80

print_integer:
    ; Print integer in EAX
    push eax                        ; Save original value
    xor ecx, ecx                    ; Reset digit counter

convert_loop:
    xor edx, edx                    ; Clear remainder
    mov ebx, 10                     ; Base 10
    div ebx                         ; EAX /= 10, remainder in EDX
    add dl, '0'                     ; Convert remainder to ASCII
    push dx                         ; Save digit
    inc ecx                         ; Increment digit count
    test eax, eax                   ; Check if EAX is zero
    jnz convert_loop                ; Repeat if not zero

print_digits:
    pop eax                         ; Retrieve digit
    mov edx, 1                      ; Length of one character
    mov ebx, 1                      ; stdout
    mov ecx, eax                    ; Character to print
    mov eax, 4                      ; syscall: write
    int 0x80
    loop print_digits               ; Continue until all digits are printed

    ; Print space after each number
    mov eax, 4                      ; syscall: write
    mov ebx, 1                      ; stdout
    mov ecx, newline                ; Address of newline
    mov edx, 1                      ; Length of newline
    int 0x80

    pop eax                         ; Restore original value
    ret
