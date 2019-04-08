LC3 Subroutine Libraies:
--------------------------
- I/O     -> {BIN_IN, BIN_OUT, DEC_IN, DEC_OUT}
- Bitwise -> {OR, XOR, NOR, XNOR}
- Math    -> {SUB, MUL, DIV, MOD}
- Trap    -> {IN, OUT, PUTS, HALT}

Locations in memory space:
--------------------------
* I/O  x4000 to x4300
* Bits x5000 to x5300
* Math x6000 to x6300
* Trap x4500 to x4900 (x4600 is empty)

====================================================

INPUT/OUTPUT SUBROUTINE SYNTAX:
------------------------------
R1: SUBROUTINE POINTER
R2: VALUE

What this means:
- The expected input value will be returned in R2
- output value must be in R2 before subroutine call

BIN_IN  = input a string of binary upto 16 bits
BIN_OUT = print a string of binary 16 bits
DEC_IN  = input signed 5 digit number
DEC_OUT = print a signed 5 digit number

=====================================================

BITWISE && MATH SUBROUTINE SYNTAX:
---------------------
R1: SUBROUTINE POINTER
R2: VARIABLE A
R3: VARIABLE B
R4: RESULT

What this means:
- "Return values" are to be expected in register R4
- computation will happen mostly in registers R4, R5, and R6
- register R7 is used for return address only
- for math routines numbers are 16 bit 2's compliment integers

===========================================================

TRAP SUBROUTINES

Trap x20 GETC - read a single character (no echo)
Trap x21 OUT  - output a character to the monitor
Trap x22 PUTS - write a string to the console
Trap x23 IN   - print prompt to console, read and echo character from keyboard
Trap x25 HALT - halt the program

Not officially done yet, need to finish, clean up, and document
Have not implemented GETC, probably will not implement PUTSP

===========================================================

*** IMPORTANT ***
- These libraries are probably not portable to different assemblers.
- Don't expect any values to be preserved in their registers
- Currently most of the routines don't backup anything except the return address
- can't expect error checking
- the input capture routines most likely append the newline... (probably fix later if need)

Fix Later:
the addressing is all over the place, it would be good to go through and adjust all of the libraries.
in simpl since lowest execution happens at x3000, libraries should start there: trap, i/o, bitwise, math
the spacing of subroutines can be compacted for max efficiency to try and fit in x3000 to x3FFF
then user applications could start at x4000 if wanting to use the libraries
if the space is adjusted would need to also change the program bin_manip.asm
