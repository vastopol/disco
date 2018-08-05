; LC3 trap routines
;------------------------

; SERVICE ROUTINE: KEYBOARD INPUT (IN, TRAP x23) VERSION1
;--------------------------------------------------------------------------
.ORIG x4500

START	ST	R1, IN_SAVER1	; SAVE CURRENT REG VALS FOR RETURN LATER
	ST	R2, IN_SAVER2
	ST	R3, IN_SAVER3
	ST	R7, IN_SAVER7
;
	LD	R2, IN_NEWL
IN_L1	LDI	R3, IN_DSR	; CHECK IF DDR IS FREE
	BRzp	IN_L1
	STI	R2, IN_DDR	; MOVE CURSOR TO NEW CLEAN LINE
;
	LEA	R1, IN_PROMPT	; STARTING ADDRESS OF STRING
IN_LOOP	LDR	R0, R1, #0	; GET NEXT PROMPT CHARACTER
	BRz	IN_INPUT	; CHECK FOR END OF STRING
IN_L2	LDI 	R3, IN_DSR
	BRzp	IN_L2
	STI	R0, IN_DDR	; WRITE NEXT CHARACTER OF PROMPT STRING
	ADD	R1, R1, #1	; INCREMENT PROMPT POINTER
	BRnzp   IN_LOOP
;
IN_INPUT	LDI R3, IN_KBSR	; HAS CHARACTER BEEN TYPED?
	BRzp	IN_INPUT
	LDI	R0, IN_KBDR	; LOAD CHAR INTO R0
IN_L3	LDI	R3, IN_DSR
	BRzp	IN_L3
	STI	R0, IN_DDR	; ECHO INPUT TO MONITOR
;
IN_L4	LDI	R3, IN_DSR
	BRzp	IN_L4
	STI	R2, IN_DDR	; MOVE CURSOR TO NEW CLEAN LINE
	LD	R1, IN_SAVER1	; RESTORE REGS, ROUTINE DONE
	LD	R2, IN_SAVER2
	LD	R3, IN_SAVER3
	LD	R7, IN_SAVER7
	RET			; RETRUN FROM SUB
;
IN_SAVER1 .BLKW #1
IN_SAVER2 .BLKW #1
IN_SAVER3 .BLKW #1
IN_SAVER7 .BLKW #1
IN_DSR    .FILL xFE04
IN_DDR    .FILL xFE06
IN_KBSR   .FILL xFE00
IN_KBDR   .FILL xFE02
IN_NEWL   .FILL x000A
IN_PROMPT .STRINGZ "Input a character> "
;---------------------------------------------------------------------------


; SERVICE ROUTINE: GET CHARACTER  (GETC, TRAP x20)
;---------------------------------------------------------------------------
.ORIG x4600
;---------------------------------------------------------------------------


; SERVICE ROUTINE: OUTPUT CHARACTER  (OUT, TRAP x21)
;---------------------------------------------------------------------------
.ORIG x4700

ST R1, OUT_SAVER1  ; R1 USED TO POLL DSR
ST R7, OUT_SAVER7

; WRITE THE CHARACTER
TRYWRT  
  LDI R1, OUT_DSR  ; GET STATUS
  BRzp TRYWRT      ; IF BIT 15 ON, DISPLAY READY
  STI R0, OUT_DDR  ; WRITE CHAR

LD R1, OUT_SAVER1  ; RESTORE REGS
LD R7, OUT_SAVER7
RET		   ; RETURN

; DATA
OUT_SAVER1 .BLKW #1
OUT_SAVER7 .BLKW #1
OUT_DSR .FILL xFE04 ; ADRESS OF DISPLAY STATUS REGISTER
OUT_DDR .FILL xFE06 ; ADDRESS OF DISPLAY DATA REGISTER
;---------------------------------------------------------------------------


; SERVICE ROUTINE: OUTPUT STRING  (PUTS, TRAP x22)
;---------------------------------------------------------------------------
.ORIG x4800

ST R7, PUTS_SAVER7  ; SAVE REGS
ST R0, PUTS_SAVER0
ST R1, PUTS_SAVER1
ST R3, PUTS_SAVER3

; LOOP THROUGH EACH CHAR IN ARRAY
PUTS_LOOP
  LDR R1, R0, #0   ; RETREIVE CAHRACTER(S)
  BRz PUTS_RETURN  ; IF 0 DONE
PUTS_L2
  LDI R3, PUTS_DSR
  BRzp PUTS_L2
  STI R1, PUTS_DDR ; WRITE CHAR
  ADD R0, R0, #1   ; INCREMENT POINTER
  BR PUTS_LOOP     ; DO AGAIN

PUTS_RETURN
LD R7, PUTS_SAVER7  ; RESTORE REGS
LD R0, PUTS_SAVER0
LD R1, PUTS_SAVER1
LD R3, PUTS_SAVER3
RET		    ; RETURN

; DATA 
PUTS_DSR .FILL xFE04
PUTS_DDR .FILL xFE06
PUTS_SAVER7 .BLKW #1
PUTS_SAVER0 .BLKW #1
PUTS_SAVER1 .BLKW #1
PUTS_SAVER3 .BLKW #1
;---------------------------------------------------------------------------


; SERVICE ROUTINE: HALT, TRAP x25
;---------------------------------------------------------------------------
.ORIG x4900

ST R0, HALT_SAVER0 ; USED FOR WORKING SPACE
ST R1, HALT_SAVER1 ; USED AS TEMP FOR MC REGISTER
ST R7, HALT_SAVER7

; PRINT MESSAGE MACHINE IS HALTING
LD R0, ASCIINEWLINE
OUT  ; TRAP x21
LEA R0, MESSAGE
PUTS ; TRAP x22
LD R0, ASCIINEWLINE
OUT  ; TRAP x21

; CLEAR BIT 15 AT xFFFE TO STOP THE MACHINE
LDI R1, MCR	; LOAD MC REGISTER TO R1
LD R0, MASK	; R0 = x7FFF
AND R0, R1, R0  ; MASK CLEAR TOP BIT
STI R0, MCR	; STORE R0 INTO MCR

LD R0, HALT_SAVER0 ; RESTORE REGISTERS
LD R1, HALT_SAVER1 
LD R7, HALT_SAVER7
RET		; RETURN

ASCIINEWLINE .FILL x000A
HALT_SAVER0 .BLKW #1
HALT_SAVER1 .BLKW #1
HALT_SAVER7 .BLKW #1
MESSAGE .STRINGZ "Halting the Machine\n"
MCR  .FILL xFFFE ; ADDRESS OF MCR
MASK .FILL x7FFF ; MASK TO CLEAR TOP BIT
;---------------------------------------------------------------------------


.END
























