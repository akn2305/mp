.model small
.data
input db 10,13,"Enter an 8-bit binary number: $"
output db 10,13,"The ASCII code is: $"
arr db ?
.code
.startup
    mov ah,09h
    mov dx,offset input
    int 21h

    mov bl,00h
    mov cl,08h

i1:
    mov ah,01h
    int 21h
    sub al,30h
    shl bl,1
    add bl,al
    loop i1

    mov ah,09h
    mov dx,offset output
    int 21h

    mov ah,02h
    mov dl,bl
    int 21h

    mov ah,4Ch
    int 21h

end
