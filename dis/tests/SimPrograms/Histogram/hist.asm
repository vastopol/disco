;--------------------------------------------------------------------------
;
; Program: hist.asm
; Name: Adithya Balaji
; Date: 7 Nov 2017
; Version: 1.0
;
; Description: A histogram plotter for the PennSim application
;              that uses data loaded from x4000 and onwards
;
;--------------------------------------------------------------------------

.ORIG x3000

AND R0, R0 #0 ; general counter
AND R1, R1 #0 ; branching register
AND R2, R2 #0 ; local data memory address
AND R3, R3 #0 ; loaded data memory address; numerical data store
AND R4, R4 #0 ; numerical data store

MAIN
	JSR FILL_DATA
	JSR SCALE_DATA
	JSR CLR_SCREEN
	JSR DRAW_BARS
	HALT

FILL_DATA
	LD R3, FOUR_THOUSAND
	LDR R0, R3 #0 ; load the counter max value into R0
	ADD R3, R3 #1 ; increment loaded memory address pointer

	LOAD_LOOP
	LEA R2, DATA
	LDR R4, R3 #0 ; load value into R4
	ADD R2, R2, R4 ; increment R2 pointer to correct hist bin

	LDR R4, R2 #0 ; get value from hist bin (reuse R4)
	ADD R4, R4 #1 ; increment R4
	STR R4, R2 #0 ; store R4 into local data

	ADD R3, R3 #1 ; increment loaded memory address pointer
	ADD R0, R0 #-1 ; decrement value count
	BRp LOAD_LOOP

	RET

SCALE_DATA
	LD R0, ONE_28 ; set R0 to 128 (size of array)
	LEA R2, DATA
	AND R4, R4 #0 ; set max to zero

	MAX_LOOP
	LDR R3, R2 #0 ; load bin value to R3

	NOT R1, R3
	ADD R1, R1 #1 ; get two's comp and set to R1

	ADD R1, R4, R1 ; set R1 to curr_max - curr_val
	BRzp SKIP_SET
	AND R4, R4 #0 ; clear R4
	ADD R4, R3 #0 ; set max value to R4
	SKIP_SET
	ADD R2, R2 #1
	ADD R0, R0 #-1
	BRp MAX_LOOP

	LD R0, NSIXTY_TWO
	ADD R1, R4, R0 ; check if max is less than 62
	BRzp SKIP_SCALE

	AND R3, R3 #0 ; set multiply counter
	DOUBLE_LOOP
	ADD R3, R3 #1 ; increment multiply counter
	ADD R4, R4, R4 ; double R4
	ADD R1, R4, R0 ; check if it is still less than 62
	BRn DOUBLE_LOOP

	ST R3, MULT_COUNTER ; save multiply counter to memory

	LD R0, ONE_28 ; set R0 to 128 (size of array)
	LEA R2, DATA ; set initial data pointer

	DATA_LOOP
	LDR R3, R2 #0 ; load bin value to R3
	LD R5, MULT_COUNTER ; load multiply counter to R5
	DATA_DOUBLE
	ADD R3, R3, R3
	ADD R5, R5 #-1
	BRp DATA_DOUBLE
	STR R3, R2 #0 ; store bin value back to memory
	ADD R2, R2 #1 ; increment array memory pointer
	ADD R0, R0 #-1 ; decrement array status counter
	BRp DATA_LOOP

	SKIP_SCALE
	RET

CLR_SCREEN
	LD R0, PIXELS
	LD R1, SCREEN_START
	LD R2, BLACK

	CLEAR_LOOP
	STR R2, R1 #0
	ADD R1, R1 #1
	ADD R0, R0 #-1
	BRp CLEAR_LOOP

	RET

DRAW_BARS
	LEA R0, DATA
	LD R1, ONE_28
	LD R2, NSCREEN

	DATA_DRAW
	LD R3, SCREEN_POS
	LDR R4, R0 #0 ; load hist value from data
	BRz SKIP_DRAW

	BAR_DRAW
	AND R5, R3 x0001
	BRz COLOR_YELLOW

	LD R6, WHITE
	STR R6, R3 #0 ; color the pixel white
	BRnzp COLORED_PX

	COLOR_YELLOW
	LD R6, YELLOW
	STR R6, R3 #0 ; color the pixel yellow

	COLORED_PX
	LD R6, NSCREEN
	ADD R3, R3, R6 ; subtract row offset

	ADD R4, R4 #-1 ; decrement pixels left to draw in bar
	BRp BAR_DRAW

	SKIP_DRAW
	LD R3, SCREEN_POS ; reload screen pos
	ADD R3, R3 #1 ; increment screen pos (change col)
	ST R3, SCREEN_POS ; store change to mem
	ADD R0, R0 #1 ; increment hist pointer
	ADD R1, R1 #-1 ; decrement hist length count
	BRp DATA_DRAW

	RET

MULT_COUNTER .FILL #0
FOUR_THOUSAND .FILL x4000
ONE_28 .FILL #128
NSIXTY_TWO .FILL #-62
WHITE .FILL xFFFF
YELLOW .FILL xFFE0
BLACK .FILL x0000
SCREEN_START .FILL xC000
PIXELS .FILL #15872
SCREEN_POS .FILL xFD80
NSCREEN .FILL xFF80 ; - x0080
DATA .BLKW  #128

.END