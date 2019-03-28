;--------------------------------------------------------------------------
;
; Program: addodd.asm
; Name: Adithya Balaji
; Date: 31 Oct 2017
; Version: 1.0
;
; Description: A simple adder of all values between
;              two user input values created using LC-3.
;
;--------------------------------------------------------------------------

.ORIG x3000

MAIN
	; clear necessary registers and memory
	AND R0, R0 #0 ; general string register
	AND R1, R1 #0 ; used for branching
	AND R2, R2 #0 ; used as a general counter; (Also pass through value)
	AND R3, R3 #0 ; used as a memory address counter; (Also store output)
	AND R4, R4 #0 ; used to hold digits; (Also to store #1)
	AND R5, R5 #0 ; used to hold counter address; (Also to store #2)
	AND R6, R6 #0 ; used as an input/compute/output status counter

	LEA R3, NUM_ONE ; memory address to store values

	LEA R0, OUT1
	PUTS ; print first output
	BRnzp INPUT
	EXIT_INPUT_ONE

	LEA R0, NEWLINE
	PUTS

	ADD R6, R6 #1 ; increment input counter

	LEA R3, NUM_TWO ; memory address to store values
	AND R2, R2 #0 ; clear general digit counter

	LEA R0, OUT2
	PUTS ; print first output
	BRnzp INPUT
	EXIT_INPUT_TWO

	LEA R0, NEWLINE
	PUTS
	
	AND R6, R6 #0 ; reset input/compute/output counter

	LEA R0, NUM_ONE ; load array memory address into R0
	BRnzp COMPUTE ; result goes to R3
	EXIT_COMPUTE_ONE

	ADD R6, R6 #1 ; increment output counter

	AND R4, R4 #0 ; clear R4
	ADD R4, R3 #0 ; Move R3 to R4

	LEA R0, NUM_TWO ; load array memory address into R0
	BRnzp COMPUTE ; result goes to R3
	EXIT_COMPUTE_TWO

	AND R6, R6 #0 ; reset input/compute/output counter

	AND R5, R5 #0 ; clear R5
	ADD R5, R3 #0 ; Move R3 to R5

	AND R2, R2 #0 ; clear R2
	NOT R2, R5 ; get two's complement of R5
	ADD R2, R2 #1
	ADD R1, R4, R2 ; see if R5 is smaller than R4
	BRp ERROR

	; final output
	LEA R0, OUT3
	PUTS
	AND R2, R2 #0 ; clear R2
	ADD R2, R4 #0 ; set R2 to R4's value
	BRnzp PRINT_NUM
	EXIT_OUTPUT_ONE

	ADD R6, R6 #1 ; increment output counter

	LEA R0, OUT4
	PUTS
	AND R2, R2 #0 ; clear R2
	ADD R2, R5 #0 ; set R2 to R5's value
	BRnzp PRINT_NUM
	EXIT_OUTPUT_TWO

	ADD R6, R6 #-2 ; decrement output counter

	LEA R0, OUT5
	PUTS
	
	AND R3, R3 #0 ; clear R3, R0, determine output
	AND R0, R0 #0
	ADD R0, R0, R4

	COMPUTE_LOOP
	ADD R0, R0 #1 ; increment R0 (R4)

	NOT R2, R0
	ADD R2, R2 #1
	ADD R1, R5, R2
	BRnz END_COMPUTE

	AND R1, R0, x0001
	BRnz COMPUTE_LOOP
	ADD R3, R3, R0 ; add R0 to R3
	BRnzp COMPUTE_LOOP

	END_COMPUTE
	AND R2, R2 #0 ; clear R2
	ADD R2, R3 #0 ; set R2 to R3's value
	BRnzp PRINT_NUM
	EXIT_OUTPUT_RSLT

	HALT ; end of program halt

ERROR
	LEA R0, ERROR_LABEL
	PUTS
	HALT

OUTPUT_ROUTER
	ADD R6, R6 #0
	BRz EXIT_OUTPUT_ONE
	BRp EXIT_OUTPUT_TWO
	BRn EXIT_OUTPUT_RSLT

COMPUTE_ROUTER
	ADD R6, R6 #0
	BRz EXIT_COMPUTE_ONE
	BRnp EXIT_COMPUTE_TWO

INPUT_ROUTER
	ADD R1, R2 #-1
	BRp SKIP_DIGIT_SHIFT

	STR R4, R3 #0 ; pad single digit input with zero
	ADD R3, R3 #-1
	AND R4, R4 #0
	STR R4, R3 #0

	SKIP_DIGIT_SHIFT
	ADD R6, R6 #0
	BRz EXIT_INPUT_ONE
	BRnp EXIT_INPUT_TWO

INPUT
	GETC

	; check if char is enter
	ADD R1, R0 #-10
	BRz INPUT_ROUTER

	; check char validity
	LD R1, NFORTY_EIGHT
	ADD R1, R0, R1; less than numeric range
	BRn INPUT
	LD R1, NFIFTY_SEVEN
	ADD R1, R0, R1 ; greater than numeric range
	BRp INPUT

	; this means input is valid
	OUT

	; iterate counter
	ADD R2, R2 #1

	; store char to memory as a number
	LD R1, NFORTY_EIGHT
	ADD R4, R0, R1
	STR R4, R3 #0 ; store input character into memory address from counter
	ADD R3, R3 #1 ; increment memory address counter

	BRnzp INPUT

PRINT_NUM
	AND R0, R0 #0 ; use as place counter
	AND R1, R1 #0 ; use as brancher
	AND R3, R3 #0 ; use to store subtracting value

	THOUSANDS_LOOP ; get thousand value
	LD R3, NONE_THOUSAND
	ADD R1, R2, R3
	BRn EXIT_THOUSANDS
	ADD R0, R0 #1
	ADD R2, R2, R3
	BRnzp THOUSANDS_LOOP

	EXIT_THOUSANDS
	LD R3, FORTY_EIGHT
	ADD R0, R0, R3
	OUT

	AND R0, R0 #0 ; clear digit storer

	HUNDREDS_LOOP ; get hundred value
	LD R3, NONE_HUNDRED
	ADD R1, R2, R3
	BRn EXIT_HUNDREDS
	ADD R0, R0 #1
	ADD R2, R2, R3
	BRnzp HUNDREDS_LOOP

	EXIT_HUNDREDS
	LD R3, FORTY_EIGHT
	ADD R0, R0, R3
	OUT

	AND R0, R0 #0 ; clear digit store

	TENS_LOOP ; get hundred value
	LD R3, NONE_TEN
	ADD R1, R2, R3
	BRn EXIT_TENS
	ADD R0, R0 #1
	ADD R2, R2, R3
	BRnzp TENS_LOOP

	EXIT_TENS
	LD R3, FORTY_EIGHT
	ADD R0, R0, R3
	OUT

	AND R0, R0 #0 ; clear digit store

	ADD R0, R2 #0 ; load R2 into R0
	LD R3, FORTY_EIGHT
	ADD R0, R0, R3
	OUT

	BRnzp OUTPUT_ROUTER

COMPUTE
	LDR R1, R0 #0 ; load the value from R0 into R1

	ADD R1, R1, R1 ; a = i + i = 2i
	ADD R2, R1, R1 ; b = a + a = 4i
	ADD R2, R2, R2 ; c = b + b = 8i
	ADD R3, R1, R2 ; d = a + c = 10i, load 10s value into R3

	ADD R0, R0 #1
	LDR R1, R0 #0 ; load the ones value into R0
	ADD R3, R3, R1 ; 
	BRnzp COMPUTE_ROUTER

HALT ; should not reach here

OUT1 .STRINGZ "Enter Start Number > " ; first output
OUT2 .STRINGZ "Enter End Number > " ; second output
OUT3 .STRINGZ "The sum of the odd numbers between " ; final output part 1
OUT4 .STRINGZ " and " ; final output part 2
OUT5 .STRINGZ " is " ; final output part 3
NEWLINE .STRINGZ "\n" ; newline
ERROR_LABEL .STRINGZ "ERROR! INVALID ENTRY!" ; invalid entry output

NUM_ONE .BLKW #2
NUM_TWO .BLKW #2

NFORTY_EIGHT .FILL #-48
NFIFTY_SEVEN .FILL #-57
FORTY_EIGHT .FILL #48

NONE_THOUSAND .FILL #-1000
NONE_HUNDRED .FILL #-100
NONE_TEN .FILL #-10

.END