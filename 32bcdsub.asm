.MODEL SMALL
.DATA
    ; Split the two 32-bit BCD values into four 16-bit variables
    n1_low DW 5678h  ; BCD value 5678
    n1_high DW 1234h  ; BCD value 1234
    n2_low DW 2222h  ; BCD value 2222
    n2_high DW 1111h  ; BCD value 1111
    result_low DW ?
    result_high DW ?
    borrow DW 0
    temp DW ?

.CODE
.STARTUP
    ; Initialize result variables
    MOV result_low, 0
    MOV result_high, 0

    ; Perform BCD subtraction for the low parts
    CALL bcd_sub_low

    ; Handle borrow for the high part
    MOV AX, 0
    SBB AX, 0  ; Check if the low part caused a borrow
    SUB result_high, AX

    ; Perform BCD subtraction for the high parts with borrow
    CALL bcd_sub_high

    CALL disp
    MOV AH, 4Ch
    INT 21h

bcd_sub_low PROC NEAR
    ; Initialize loop counter
    MOV CX, 4

up_low:
    ; Load the BCD digits from n1_low and n2_low
    MOV AX, n1_low
    ROL AX, 4
    MOV temp, AX  ; Store a copy in temp

    MOV AX, n2_low
    ROL AX, 4
    SUB AX, temp  ; Perform BCD subtraction
    SBB AL, 0     ; Subtract borrow if present

    ; Store the result in result_low
    ROR AX, 4
    MOV result_low, AX

    ; Decrement the counter and continue
    DEC CX
    JNZ up_low

    RET
bcd_sub_low ENDP

bcd_sub_high PROC NEAR
    ; Initialize loop counter
    MOV CX, 4

up_high:
    ; Load the BCD digits from n1_high and n2_high
    MOV AX, n1_high
    ROL AX, 4
    MOV temp, AX  ; Store a copy in temp

    MOV AX, n2_high
    ROL AX, 4
    SUB AX, temp  ; Perform BCD subtraction
    SBB AL, 0     ; Subtract borrow if present

    ; Store the result in result_high
    ROR AX, 4
    MOV result_high, AX

    ; Decrement the counter and continue
    DEC CX
    JNZ up_high

    RET
bcd_sub_high ENDP

disp PROC NEAR
    ; Display result_high
    MOV AX, result_high
    CALL display_digit

    ; Display result_low
    MOV AX, result_low
    CALL display_digit

    RET

display_digit PROC NEAR
    PUSH CX
    MOV CX, 4  ; Display 4 digits

up_disp:
    ; Load and display the least significant digit
    MOV DL, '0'
    ADD DL, AL
    MOV AH, 02h
    INT 21h

    ; Shift to the next digit
    ROL AX, 4

    ; Decrement the counter and continue
    DEC CX
    JNZ up_disp

    POP CX
    RET
display_digit ENDP

MOV AX, 4C00h
INT 21h

END
