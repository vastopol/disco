; every asm instruction

.ORIG x0000

;--------------------

; rti

RTI

;--------------------

; trap

TRAP x20
GETC

TRAP x21
OUT

TRAP x22
PUTS

TRAP x23
IN

TRAP x24
PUTSP

TRAP x25
HALT

;--------------------

; jmp

JMP R0

JMP R1

JMP R2

JMP R3

JMP R4

JMP R5

JMP R6

JMP R7    ; RET
RET

;--------------------

; br

BR  x0
BRn  x0
BRz  x0
BRp  x0
BRnz  x0
BRnp  x0
BRzp  x0
BRnzp  x0

;--------------------

; not

NOT R0, R0
NOT R0, R1
NOT R0, R2
NOT R0, R3
NOT R0, R4
NOT R0, R5
NOT R0, R6
NOT R0, R7

NOT R1, R0
NOT R1, R1
NOT R1, R2
NOT R1, R3
NOT R1, R4
NOT R1, R5
NOT R1, R6
NOT R1, R7

NOT R2, R0
NOT R2, R1
NOT R2, R2
NOT R2, R3
NOT R2, R4
NOT R2, R5
NOT R2, R6
NOT R2, R7

NOT R3, R0
NOT R3, R1
NOT R3, R2
NOT R3, R3
NOT R3, R4
NOT R3, R5
NOT R3, R6
NOT R3, R7

NOT R4, R0
NOT R4, R1
NOT R4, R2
NOT R4, R3
NOT R4, R4
NOT R4, R5
NOT R4, R6
NOT R4, R7

NOT R5, R0
NOT R5, R1
NOT R5, R2
NOT R5, R3
NOT R5, R4
NOT R5, R5
NOT R5, R6
NOT R5, R7

NOT R6, R0
NOT R6, R1
NOT R6, R2
NOT R6, R3
NOT R6, R4
NOT R6, R5
NOT R6, R6
NOT R6, R7

NOT R7, R0
NOT R7, R1
NOT R7, R2
NOT R7, R3
NOT R7, R4
NOT R7, R5
NOT R7, R6
NOT R7, R7

;--------------------

; and

;--------------------

; add

;--------------------

; lea

;--------------------

; ld

;--------------------

; st

;--------------------

; ldi

;--------------------

; sti

;--------------------

; ldr

;--------------------

; str

;--------------------

; jsr

;--------------------

; jsrr

;--------------------

.END