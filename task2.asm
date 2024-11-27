section .data
    prompt db "Enter 5 integers separated by spaces: ", 0
    arr db 5, 0              ; Reserve space for 5 integers (initially zero)
    newline db 0x0A, 0       ; Newline character for printing
    msg db "Reversed array: ", 0

section .bss
    input resb 10            ; Buffer to store user input (max 10 chars)

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, prompt         ; address of prompt message
    mov edx, 33             ; length of message
    int 0x80                ; invoke syscall

    ; Read input (space-separated integers)
    mov eax, 3              ; syscall: read
    mov ebx, 0              ; file descriptor: stdin
    mov ecx, input          ; buffer to store input
    mov edx, 10             ; number of bytes to read (up to 10 characters)
    int 0x80                ; invoke syscall

    ; Convert input string to integers and store in arr
    mov ecx, input          ; pointer to input buffer
    mov ebx, 0              ; array index
convert_input:
    movzx edx, byte [ecx]   ; get current byte (character)
    cmp dl, 0x0A            ; check if it's a newline character
    je done_input           ; if newline, we're done
    sub dl, '0'             ; convert ASCII to integer (0-9)
    mov [arr + ebx], dl     ; store the number in arr
    inc ecx                 ; move to the next character
    inc ebx                 ; move to the next array index
    cmp ebx, 5              ; check if we've filled 5 integers
    jl convert_input        ; if not, continue converting

done_input:
    ; Print "Reversed array: "
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, msg            ; address of msg
    mov edx, 17             ; length of message
    int 0x80                ; invoke syscall

    ; Reverse the array in place
    mov ecx, 0              ; start index (i = 0)
    mov edx, 4              ; end index (j = 4)
reverse_loop:
    mov al, [arr + ecx]     ; load arr[i] into al
    mov bl, [arr + edx]     ; load arr[j] into bl
    mov [arr + ecx], bl     ; store arr[j] into arr[i]
    mov [arr + edx], al     ; store arr[i] into arr[j]
    inc ecx                 ; increment i
    dec edx                 ; decrement j
    cmp ecx, edx            ; check if i >= j
    jl reverse_loop         ; if not, repeat loop

    ; Print the reversed array
    mov ecx, 0              ; reset index
print_array:
    movzx eax, byte [arr + ecx]  ; load current number from arr
    add al, '0'             ; convert integer to ASCII
    mov [input], al         ; store ASCII character in input buffer
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov edx, 1              ; write 1 byte (the character)
    int 0x80                ; invoke syscall
    inc ecx                 ; move to next element
    cmp ecx, 5              ; check if we've printed 5 numbers
    jl print_array          ; if not, continue

    ; Print newline
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, newline        ; address of newline
    mov edx, 1              ; length of message
    int 0x80                ; invoke syscall

    ; Exit program
    mov eax, 1              ; syscall: exit
    xor ebx, ebx            ; exit code 0
    int 0x80                ; invoke syscall
