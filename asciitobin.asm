.model small
.data
input db 10,13,"Enter an ASCII character: $"
output db 10,13,"The binary value is: $"
binaryValue db 8 dup(?) ; To store the binary value
.code
.startup
    mov ah, 09h
    mov dx, offset input
    int 21h

    mov cx, 8 ; 8 bits for ASCII to binary conversion

    mov ah, 01h
    int 21h ; Read a character from the user

    ; Convert the ASCII character to binary
    sub al, 30h ; Subtract '0' to convert to a number (0-9)
    cmp al, 1
    jbe validInput ; Check if the input is a valid binary digit

invalidInput:
    ; Display an error message for invalid input
    mov ah, 09h
    mov dx, offset invalidMsg
    int 21h
    jmp endProgram

validInput:
    mov dl, al

convertLoop:
    test cx, 1 ; Check if we have processed 8 bits
    jz skipBit ; If yes, skip this bit
    mov al, 0 ; Clear AL to store the bit

saveBit:
    ; Store the bit in the binaryValue array
    shl byte ptr [binaryValue], 1
    or byte ptr [binaryValue], al

skipBit:
    shr cx, 1 ; Move to the next bit
    loop convertLoop

    mov ah, 09h
    mov dx, offset output
    int 21h

    ; Display the binary value
    mov ah, 09h
    lea dx, binaryValue
    int 21h

endProgram:
    mov ah, 4Ch
    int 21h

invalidMsg db 10,13,"Invalid input. Please enter a valid binary digit (0 or 1).$"
