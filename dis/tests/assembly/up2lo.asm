; B.3 An Example 563
; uppercase: converts lower- to uppercase
.ORIG x3000
LEA R6, STACK
MAIN ADD R1, R6, #3
READCHAR IN ; read in input string: scanf
OUT
STR R0, R1, #0
ADD R1, R1, #1
ADD R2, R0, x-A
BRnp READCHAR
ADD R1, R1, #-1
STR R2, R1, #0 ; put in NULL char to mark the "end"
ADD R1, R6, #3 ; get the starting address of the string
STR R1, R6, #14 ; pass the parameter
STR R6, R6, #13
ADD R6, R6, #11
JSR UPPERCASE
HALT
UPPERCASE STR R7, R6, #1
AND R1, R1, #0
STR R1, R6, #4
LDR R2, R6, #3
CONVERT ADD R3, R1, R2 ; add index to starting addr of string
LDR R4, R3, #0
BRz DONE ; Done if NULL char reached
LD R5, a
ADD R5, R5, R4 ; ’a’ <= input string
BRn NEXT
LD R5, z
ADD R5, R4, R5 ; input string <= ’z’
BRp NEXT
LD R5, asubA ; convert to uppercase
ADD R4, R4, R5
STR R4, R3, #0
NEXT ADD R1, R1, #1 ; increment the array index, i
STR R1, R6, #4
BRnzp CONVERT
DONE LDR R7, R6, #1
LDR R6, R6, #2
RET
a .FILL #-97
z .FILL #-122
asubA .FILL #-32
STACK .BLKW 100
.END
