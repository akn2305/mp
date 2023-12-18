.model small
.data
    array1  db 5 DUP(?)  ; Array to store the first input
    array2  db 5 DUP(?)  ; Array to store the second input
    result  db 5 DUP(?)  ; Array to store the result in decimal format
    array_size db 5
    result_prompt db 13, 10, 'Result Array in Decimal: $'
    input_prompt db 13, 10, 'Enter 5 elements for the array (e.g., 1 2 3 4 5): $'
.code
.startup
    ; Prompt the user to enter the first array
    mov ah, 09h
    lea dx, input_prompt
    int 21h

    ; Read the first array from the user
    mov cx, 5
    lea di, array1
    call read_array

    ; Prompt the user to enter the second array
    mov ah, 09h
    lea dx, input_prompt
    int 21h

    ; Read the second array from the user
    mov cx, 5
    lea di, array2
    call read_array

    ; Add the two arrays and store the result in the 'result' array
    mov cx, 5
    lea si, array1
    lea di, array2
    lea bx, result
add_arrays:
    mov al, [si]
    add al, [di]
    mov [bx], al
    inc si
    inc di
    inc bx
    loop add_arrays

    ; Print the result array in decimal format
    mov ah, 09h
    lea dx, result_prompt
    int 21h
    mov cx, 5
    lea bx, result
    call print_result

exit:
    int 20h

read_array:
    mov ah, 01h
    int 21h
    mov dl, al
    sub dl, 30h
    mov [di], dl
    inc di
    loop read_array
    ret

print_result:
    mov cx, 5
    mov ah, 02h
print_loop:
    add dl, 30h   ; Convert to ASCII character
    int 21h
    inc bx
    loop print_loop
    ret
