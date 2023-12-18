.MODEL SMALL
.DATA
    ; Split the two 32-bit integers into four 16-bit variables
    n1_low DW 5678h
    n1_high DW 1234h
    n2_low DW 2222h
    n2_high DW 1111h
    n3_low DW ?
    n3_high DW ?
    carry DW 0

.CODE
.STARTUP
    ; Perform the 16-bit addition for the low parts
    MOV AX, n1_low
    ADD AX, n2_low
    MOV n3_low, AX

    ; Calculate carry from the low part addition
    ADC carry, 0

    ; Perform the 16-bit addition for the high parts with carry
    MOV AX, n1_high
    ADC AX, n2_high
    ADD AX, carry
    MOV n3_high, AX

    CALL disp
    MOV AH, 4Ch
    INT 21h

disp PROC NEAR
    MOV CX, 8

up:
    MOV AX, n3_high
    ROL AX, 4
    MOV n3_high, AX
    MOV AX, n3_low
    ROL AX, 4
    MOV n3_low, AX
    AND AL, 0Fh
    CMP AL, 0Ah
    JAE dl
    ADD AL, 7

dl:
    ADD AL, 30h
    MOV DL, AL
    MOV AH, 02h
    INT 21h
    DEC CX
    JNZ up
    RET

disp ENDP

MOV AX, 4C00h
INT 21h

END
