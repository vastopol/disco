; just to see as a test

; notice that a BR will be decoded as a BRnzp by the disassembler,
; this means that finding a BR in the instructions means that is a piece of data

.ORIG x3000

    AND R0, R0, x0
    AND R0, R0, x0
    BR L1
    AND R0, R0, x0
    AND R0, R0, x0
L0:
    ADD R0, R0, x1
    ADD R0, R0, x1
    BR L2
    ADD R0, R0, x1
    ADD R0, R0, x1
L1:
    AND R0, R0, x2
    AND R0, R0, x2
    BR L0
    AND R0, R0, x2
    AND R0, R0, x2
L2:
    HALT

NEWL  .FILL     x000A
SAVE  .BLKW     1
WORD  .STRINGZ  "Halting the machine."

.END
