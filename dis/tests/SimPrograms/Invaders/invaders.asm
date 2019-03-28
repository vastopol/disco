;--------------------------------------------------------------------------
;
; Program: invaders.asm
; Name: Adithya Balaji
; Date: 29 Nov 2017
; Version: 1.0
;
; Description: A rendition of the classic space invaders game coded using the 
;              LC3 ISA 
; Note: The laser width was chagned from instructions to be more visually
;       pleasing
;--------------------------------------------------------------------------

.ORIG x3000

AND R0, R0 #0
AND R1, R1 #0
AND R2, R2 #0
AND R3, R3 #0
AND R4, R4 #0
AND R5, R5 #0
AND R6, R6 #0

MAIN	JSR		CLEAR_SCREEN
		JSR		SETUP_DATA
		JSR		REDRAW_SCREEN
		JSR		GAME_LOOP
		LEA		R0, QUIT_STR
		PUTS
		HALT
QUIT_STR	.STRINGZ "Quit\n"

;; SETUP_DATA
; Initializes the starting game positions.
; Takes no input.
SETUP_DATA	ST		R0, SD_R0
			ST		R0, SD_R1
			ST		R0, SD_R2
			ST		R0, SD_R3
			ST		R0, SD_R4
			ST		R7, SD_R7
			LEA		R0, ALIEN0			; Setup alien values
			LD		R1, ALIEN_START
			LD		R2, SD_BLUE
			LD		R3, ALIEN_OFFSET
			AND		R4, R4 #0
			ADD		R4, R4 #4			; counter
INIT_ALIENS	STR		R2, R0 #0			; set alien color
			ADD		R0, R0 #1			; increment pointer
			STR		R1, R0 #0			; set alien pos
			ADD		R1, R1, R3			; increment pos by offset
			ADD		R0, R0 #1			; increment pointer
			ADD		R4, R4 #-1			; decrement counter
			BRp		INIT_ALIENS
			LEA		R0, SHIP
			LD		R1, SHIP_START
			LD		R2, SD_RED
			STR		R2, R0 #0			; store ship color
			ADD		R0, R0 #1			; increment pointer
			STR		R1, R0 #0			; store initial ship pos
			LEA		R0, LASER
			AND		R1, R1 #0
			STR		R1, R0 #0			; set laser to inactive
			ADD		R0, R0 #1
			ADD		R1, R1 #1
			STR		R1, R0 #0			; init laser to no pos
			LD		R0, SD_R0
			LD		R0, SD_R1
			LD		R0, SD_R2
			LD		R0, SD_R3
			LD		R0, SD_R4
			LD		R7, SD_R7
			RET
SD_R0			.BLKW 1
SD_R1			.BLKW 1
SD_R2			.BLKW 1
SD_R3			.BLKW 1
SD_R4			.BLKW 1
SD_R7			.BLKW 1
ALIEN_START		.FILL xC18A
SHIP_START		.FILL xF3B3
ALIEN_OFFSET	.FILL #30
SD_BLUE			.FILL x001F
SD_RED			.FILL x7C00

;; DRAW_SHIP
; Draws/updates a ship sized block given specified inputs
; INPUT: R1: start address
;		 R2: color
DRAW_SHIP	ST		R0, DSH_R0
			ST		R3, DSH_R3
			ST		R4, DSH_R4
			ST		R7, DSH_R7
			AND		R4, R4 #0		; clear R4
			ADD		R4, R2 #0		; set R4 to R2
			LD		R2, SHIP_WIDTH
			LD		R3, SHIP_LENGTH
			JSR		DRAW_SQUARE		; draw new ship position (R1 is set by input)
			LD		R0, DSH_R0
			LD		R3, DSH_R3
			LD		R4, DSH_R4
			LD		R7, DSH_R7
			RET
DSH_R0			.FILL 1
DSH_R3			.FILL 1
DSH_R4			.FILL 1
DSH_R7			.FILL 1
SHIP_WIDTH		.FILL #24
SHIP_LENGTH		.FILL #12

;; DRAW_ALIENS
; Draws/updates the aliens based on the colors in their arrays
; Takes no input.
DRAW_ALIENS		ST		R0, DA_R0
				ST		R1, DA_R1
				ST		R2, DA_R2
				ST		R3, DA_R3
				ST		R4, DA_R4
				ST		R5, DA_R5
				ST		R7, DA_R7
				AND		R0, R0 #0		; clear R0
				ADD		R0, R0 #4		; set R0 to be counter
				LEA		R5, ALIEN0		; get pos of first alien
DRAW_ALIEN		LDR		R4, R5 #0		; load specified color into R4
				ADD 	R5, R5 #1		; increment pointer
				LDR 	R1, R5 #0		; load alien start address into R1
				LD		R2, ALIEN_DIM	; load alien width
				LD		R3, ALIEN_DIM	; load alien height
				JSR		DRAW_SQUARE		; draw first alien
				ADD		R5, R5 #1		; increment pointer
				ADD		R0, R0 #-1		; decrement count
				BRp		DRAW_ALIEN
				LD		R0, DA_R0
				LD		R1, DA_R1
				LD		R2, DA_R2
				LD		R3, DA_R3
				LD		R4, DA_R4
				LD		R5, DA_R5
				LD		R7, DA_R7
				RET
DA_R0		.BLKW 1
DA_R1		.BLKW 1
DA_R2		.BLKW 1
DA_R3		.BLKW 1
DA_R4		.BLKW 1
DA_R5		.BLKW 1
DA_R7		.BLKW 1
ALIEN_DIM	.FILL #14

;; DRAW_LASER
; Draws/updates a laser based on inputs
; INPUT: R1: start addres
;		 R2: color
DRAW_LASER	ST		R3, DL_R3
			ST		R4, DL_R4
			ST		R7, DL_R7
			AND		R4, R4 #0
			ADD		R4, R2 #0
			LD		R2, LASER_WIDTH
			LD		R3, LASER_LENGTH
			JSR		DRAW_SQUARE		; draw laser square (R1 is in input)
			LD		R3, DL_R3
			LD		R4, DL_R4
			LD		R7, DL_R7
			RET
LASER_WIDTH		.FILL #2
LASER_LENGTH	.FILL #12
DL_R3			.BLKW 1
DL_R4			.BLKW 1
DL_R7			.BLKW 1

;; DRAW_SCREEN
; Sets up the screen using the arrays prescribing the status of game objects.
; Takes no input.
REDRAW_SCREEN	ST		R0, SS_R0
				ST		R1, SS_R1
				ST		R2, SS_R2
				ST		R3, SS_R3
				ST		R4, SS_R4
				ST		R5, SS_R5
				ST		R7, SS_R7
				JSR		CLEAR_SCREEN	; clear screen
				JSR		DRAW_ALIENS
				LEA		R5, SHIP
				LDR		R2, R5 #0		; set color to draw for ship
				ADD		R5, R5 #1		; increment ship pointer
				LDR 	R1, R5 #0		; set address of ship to draw
				JSR		DRAW_SHIP		; draw initial ship
				LD		R0, SS_R0
				LD		R1, SS_R1
				LD		R2, SS_R2
				LD		R3, SS_R3
				LD		R4, SS_R4
				LD		R5, SS_R5
				LD		R7, SS_R7
				RET
SS_R0				.BLKW 1
SS_R1				.BLKW 1
SS_R2				.BLKW 1
SS_R3				.BLKW 1
SS_R4				.BLKW 1
SS_R5				.BLKW 1
SS_R7				.BLKW 1

;; GAME_LOOP
; Main loop for game execution
; Takes no inputs.
GAME_LOOP	ST		R7, GL_R7
GAME		JSR		TIMED_INPUT
			LD		R1, N114
			ADD		R1, R0, R1
			BRnp	SKIP_RED
			LD		R1, RED
			JSR		SET_SHIP_COLOR	; set ship to red
SKIP_RED	LD		R1, N103
			ADD		R1, R0, R1
			BRnp	SKIP_GREEN
			LD		R1, GREEN
			JSR		SET_SHIP_COLOR	; set ship to green
SKIP_GREEN	LD		R1, N98
			ADD		R1, R0, R1
			BRnp	SKIP_BLUE
			LD		R1, BLUE
			JSR		SET_SHIP_COLOR	; set ship to blue
SKIP_BLUE	LD		R1, N121
			ADD		R1, R0, R1
			BRnp	SKIP_YELLOW
			LD		R1, YELLOW
			JSR		SET_SHIP_COLOR	; set ship to yellow
SKIP_YELLOW	LD		R1, N119
			ADD		R1, R0, R1
			BRnp	SKIP_WHITE
			LD		R1, WHITE
			JSR		SET_SHIP_COLOR	; set ship to white
SKIP_WHITE	LD		R1, N97
			ADD		R1, R0, R1
			BRnp	SKIP_LEFT
			AND		R0, R0 #0
			ADD		R1, R1 #-4
			JSR		MOVE_SHIP		; move left
SKIP_LEFT	LD		R1, N100
			ADD		R1, R0, R1	
			BRnp	SKIP_RIGHT
			AND		R0, R0 #0
			ADD		R1, R1 #4	
			JSR		MOVE_SHIP		; move right
SKIP_RIGHT	LD		R1, N32
			ADD		R1, R0, R1
			BRnp	SKIP_SHOOT	
			JSR		SHOOT			; shoot laser
SKIP_SHOOT	LD		R1, N113
			ADD		R1, R0, R1	
			BRnp	SKIP_QUIT
			BRnzp	QUIT			; quit game
			; PROCESS INPUT
			; ROUTE and ACT upon INPUT
			; Update laser status
			; Check for ship destruction
			; CHECK FOR END OF GAME
SKIP_QUIT	JSR ANIMATE_LASER
			JSR GAMEOVER_CHECK
			BRnzp	GAME
QUIT		LD		R7, GL_R7
			RET
N114		.FILL #-114	; r
N103		.FILL #-103	; g
N98			.FILL #-98	; b
N121		.FILL #-121	; y
N119		.FILL #-119	; w
N97			.FILL #-97	; a
N100		.FILL #-100	; d
N32			.FILL #-32	; space
N113		.FILL #-113	; q
GL_R7		.BLKW 1
RED		.FILL x7C00
GREEN	.FILL x03E0
BLUE	.FILL x001F
YELLOW	.FILL xFFE0
WHITE	.FILL xFFFF
BLACK	.FILL x0000

; Game objects
ALIEN0	.BLKW 2	; color, address
ALIEN1	.BLKW 2
ALIEN2	.BLKW 2
ALIEN3	.BLKW 2
SHIP	.BLKW 2 ; color, address
LASER	.BLKW 2 ; visible, address

;; GAMEOVER
; Check if game is over
; Takes no inputs
GAMEOVER_CHECK	ST		R0, G_R0
				ST		R1, G_R1
				ST		R2, G_R2
				ST		R3, G_R3
				ST		R4, G_R4
				ST		R7, G_R7
				LD		R2, COLOR_CHECK
				AND		R4, R4 #0
				ADD		R4, R4 #4
				LEA		R0, ALIEN0
CHECK_ALIEN		LDR		R1, R0 #0
				ADD		R3, R1, R2
				BRnp	CONTINUE
				ADD		R0, R0 #2
				ADD		R4, R4 #-1
				BRp		CHECK_ALIEN
				LEA		R0, GAMEOVER_STR
				PUTS
				HALT
CONTINUE		LD		R0, G_R0
				LD		R1, G_R1
				LD		R2, G_R2
				LD		R3, G_R3
				LD		R4, G_R4
				LD		R7, G_R7
				RET
G_R0			.BLKW 1
G_R1			.BLKW 1
G_R2			.BLKW 1
G_R3			.BLKW 1
G_R4			.BLKW 1
G_R7			.BLKW 1
COLOR_CHECK		.FILL #-31744
GAMEOVER_STR	.STRINGZ "GAMEOVER"


;; SET_SHIP_COLOR
; Changes and sets the default color of the ship. Takes color input from R1. Uses 
; move ship to redraw the ship.
; INPUT: R1: hex color to set ship
SET_SHIP_COLOR	ST		R0, SSC_R0
				ST		R1, SSC_R1
				ST		R2, SSC_R2
				ST		R7, SSC_R7
				LEA		R0, SHIP
				STR		R1, R0 #0		; save new color of ship to memory
				AND		R2, R2 #0		; clear R2
				ADD		R2, R1 #0		; set R2 to R1 (new color of ship)
				ADD		R0, R0 #1		; increment pointer of ship
				LDR		R1, R0 #0		; set position of ship
				JSR		DRAW_SHIP		; redraw ship with new color
				LD		R0, SSC_R0
				LD		R1, SSC_R1
				LD		R2, SSC_R2
				LD		R7, SSC_R7
				RET
SSC_R0			.BLKW 1
SSC_R1			.BLKW 1
SSC_R2			.BLKW 1
SSC_R7			.BLKW 1

;; MOVE_SHIP
; Changes the position of the ship and redraws the ship in the specified location.
; INPUTS: R1: offset (-4 or +4)
MOVE_SHIP	ST		R0, MS_R0
			ST		R2, MS_R2
			ST		R3, MS_R3
			ST		R4, MS_R4
			ST		R5, MS_R5
			ST		R7, MS_R7
			LEA		R0, SHIP
			ADD		R0, R0 #1		; increment to ship address
			LDR		R4, R0 #0		; load ship pos to R4
			ADD		R5, R1, R4		; compute offset to R5
			LD		R3, SHIP_MIN
			ADD		R3, R5, R3		; check if trying to move past screen (left)
			BRn		NO_MOVE
			LD		R3, SHIP_MAX
			ADD		R3, R5, R3		; check if trying to move past screen (right)
			BRp		NO_MOVE
			STR		R5, R0 #0		; store new position
			AND		R1, R1 #0		; clear R1
			ADD		R1, R4 #0		; set R1 to R4
			LD		R2, MS_BLACK	; set draw color to black
			JSR		DRAW_SHIP
			AND		R1, R1 #0		; clear R1
			ADD		R1, R5 #0		; set R1 to R5
			ADD		R0, R0 #-1		; decrement ship pointer
			LDR		R2, R0 #0		; set ship draw color
			JSR		DRAW_SHIP
NO_MOVE		LD		R0, MS_R0
			LD		R2, MS_R2
			LD		R3, MS_R3
			LD		R4, MS_R4
			LD		R5, MS_R5
			LD		R7, MS_R7
			RET
MS_R0			.BLKW 1
MS_R2			.BLKW 1
MS_R3			.BLKW 1
MS_R4			.BLKW 1
MS_R5			.BLKW 1
MS_R7			.BLKW 1
SHIP_MAX		.FILL x0C19 ; two's complement of xF3E7
SHIP_MIN		.FILL x0C7D ; two's complement of x0C7D
MS_BLACK		.FILL x0000

;; SHOOT
; Sets off the chain reaction of laser shooting
; Takes no input.
SHOOT	ST		R0, S_R0
		ST		R1, S_R1
		ST		R2, S_R2
		ST		R3, S_R3
		ST		R4, S_R4
		ST		R7, S_R7
		LEA		R0, LASER
		LDR		R1, R0 #0 ; get status of laser
		BRp		NOSHOOT
		AND		R1, R1 #0
		ADD		R1, R1 #1
		STR		R1, R0 #0	; set laser to active
		LEA		R2, SHIP
		LDR		R2, R2 #1	; get position of ship
		ADD		R2, R2 #11	; x offset
		LD		R3, NLASER_Y
		ADD		R2, R2, R3	; computed init pos of laser
		AND		R1, R1 #0
		ADD		R1, R2 #0	; store computed pos into R1
		STR		R1, R0 #1	; store computed pos into laser storage
		LD		R2, S_GREEN
		JSR		DRAW_LASER
NOSHOOT	LD		R0, S_R0
		LD		R1, S_R1
		LD		R2, S_R2
		LD		R3, S_R3
		LD		R4, S_R4
		LD		R7, S_R7
		RET
S_R0		.BLKW 1
S_R1		.BLKW 1
S_R2		.BLKW 1
S_R3		.BLKW 1
S_R4		.BLKW 1
S_R7		.BLKW 1
NLASER_Y	.FILL xFA00 ; y offset negated for ease of use (-128*12)
S_GREEN		.FILL x03E0

;; CHECK_SHIP_HIT
; Checks if laser has hit a ship and updates its color respectively
; INPUTS: R3: x pos of laser
;		  R4; y pos of laser --> OUTPUTS: R5: HIT or NO HIT
CHECK_SHIP_HIT	ST		R0, CSH_R0
				ST		R1, CSH_R1
				ST		R2, CSH_R2
				ST		R3, CSH_R3
				ST		R4, CSH_R4
				ST		R6, CSH_R6
				ST		R7, CSH_R7
				LD		R6, NALIEN
				AND		R5, R5 #0
				ADD		R6, R4, R6
				BRzp	END_CHECK
				AND		R5, R5 #0
				LEA		R0, ALIEN0
				LEA		R1, NSHIP0_0	; load the first check value
				AND		R2, R2 #0
				ADD		R2, R2 #4
CHECK_SHIP		LDR		R6, R1 #0		; load the value of min
				ADD		R6, R3, R6		; check if x pos is greater than min
				BRn		NO_HIT
				LDR		R6, R1 #1		; load the value of max
				ADD		R6, R3, R6		; check if x pos is less than max
				BRp		NO_HIT
				LD		R6, CSH_RED
				STR		R6, R0 #0		; store hit color into ship
				ADD		R1, R1 #1		; set HIT value to true
				ADD		R5, R5 #1		; set return value to true
				BRnzp	UPDATE_ALIENS
NO_HIT			ADD		R0, R0 #2		; increment ship memory pointer
				ADD		R1, R1 #2		; increment value pointer
				ADD		R2, R2 #-1		; decrement counter
				BRp		CHECK_SHIP
				BRnzp	END_CHECK
UPDATE_ALIENS	JSR		DRAW_ALIENS
END_CHECK		LD		R0, CSH_R0
				LD		R1, CSH_R1
				LD		R2, CSH_R2
				LD		R3, CSH_R3
				LD		R4, CSH_R4
				LD		R6, CSH_R6
				LD		R7, CSH_R7
				RET
CSH_R0			.BLKW 1
CSH_R1			.BLKW 1
CSH_R2			.BLKW 1
CSH_R3			.BLKW 1
CSH_R4			.BLKW 1
CSH_R6			.BLKW 1
CSH_R7			.BLKW 1
NALIEN			.FILL #-17	; position of ship
NSHIP0_0		.FILL #-9	; compsensated x pos for laser (same below)
NSHIP0_1		.FILL #-24	; uncompensated x pos for laser (same below)
NSHIP1_0		.FILL #-39	
NSHIP1_1		.FILL #-54	
NSHIP2_0		.FILL #-69	
NSHIP2_1		.FILL #-84	
NSHIP3_0		.FILL #-99	
NSHIP3_1		.FILL #-114
CSH_RED			.FILL x7C00

;; ANIMATE_LASER
; Animates the laser until it hits the edge of screen or a ship
; Takes no input.
ANIMATE_LASER	ST		R0, AL_R0
				ST		R1, AL_R1
				ST		R2, AL_R2
				ST		R3, AL_R3
				ST		R4, AL_R4
				ST		R5, AL_R5
				ST		R7, AL_R7
				LEA		R0, LASER
				LDR		R1, R0 #0
				BRnz	END_ANIMATE			; check if laser is active
				LDR		R1, R0 #1			; load laser pos into R1 (Laser[1])
				LD		R2, NLASER_OFFSET
				ADD		R2, R1, R2			; compute offset 6 px in y direction
				JSR		CONVERT_TO_XY		; set R3 and R4 to x, y position of laser
				ADD		R4, R4 #0
				BRnz	CLEAR_LASER			; check if the laser is offscreen
				JSR		CHECK_SHIP_HIT
				ADD		R5, R5 #0			; load in the value of R5
				BRnz	ANIMATE
CLEAR_LASER		LD		R2, AL_BLACK
				JSR		DRAW_LASER
				AND		R1, R1 #0			; clear R1
				STR		R1, R0 #0			; set laser to inactive (Laser[0])
				BRnzp	END_ANIMATE
ANIMATE			AND		R6, R6 #0
				ADD		R6, R2 #0			; temp store R2 in R6
				LD		R2, AL_BLACK
				JSR		DRAW_LASER			; draw over the previous laser
				AND		R1, R1 #0			; clear R1
				ADD		R1, R6 #0			; load new pos into R1
				STR		R1, R0 #1			; store computed pos (Laser[1])
				LD		R2, AL_GREEN
				JSR		DRAW_LASER			; draw new laser position
END_ANIMATE		LD		R0, AL_R0
				LD		R1, AL_R1
				LD		R2, AL_R2
				LD		R3, AL_R3
				LD		R4, AL_R4
				LD		R5, AL_R5
				LD		R7, AL_R7
				RET
AL_R0			.BLKW 1
AL_R1			.BLKW 1
AL_R2			.BLKW 1
AL_R3			.BLKW 1
AL_R4			.BLKW 1
AL_R5			.BLKW 1
AL_R7			.BLKW 1
NLASER_OFFSET	.FILL #-768 ; y offset negated for ease of use (-128*6)
AL_BLACK		.FILL x0000
AL_GREEN		.FILL x03E0

;; CLEAR_SCREEN
; Clears the screen pixel by pixel with black
CLEAR_SCREEN	ST		R7, CS_R7
				LD		R0, PIXELS
				LD		R1, SCREEN_START
				LD		R2, CS_BLACK
CLEAR_LOOP		STR		R2, R1 #0
				ADD		R1, R1 #1
				ADD		R0, R0 #-1
				BRp		CLEAR_LOOP
				LD		R7, CS_R7
				RET
CS_BLACK		.FILL x0000
SCREEN_START	.FILL xC000
PIXELS			.FILL #15872
CS_R7			.BLKW 1


;; CONVERT_TO_XY
; Takes in memory address and outputs x and y coordinates
; INPUTS: R2: Memory address --> OUTPUTS: R3, R4 (x, y)
CONVERT_TO_XY	ST		R0, CTXY_R0
				ST		R1, CTXY_R1
				ST		R2, CTXY_R2
				ST		R5, CTXY_R5
				ST		R7, CTXY_R7
				LD		R3, PX_OFFSET
				ADD		R2, R2, R3
				AND		R3, R3 #0
				AND		R4, R4 #0
				LD		R0, N128
CONVERT_LOOP	ADD		R5, R2, R0
				BRn		END_CONVERT
				ADD		R4, R4 #1		; increment R4 (y) count
				ADD		R2, R2, R0
				BRnzp	CONVERT_LOOP
END_CONVERT		ADD		R3, R2 #0		; set R3 (x) to remainder
				LD		R0, CTXY_R0
				LD		R1, CTXY_R1
				LD		R2, CTXY_R2
				LD		R5, CTXY_R5
				LD		R7, CTXY_R7
				RET
CTXY_R0		.BLKW 1
CTXY_R1		.BLKW 1
CTXY_R2		.BLKW 1
CTXY_R5		.BLKW 1
CTXY_R7		.BLKW 1
PX_OFFSET	.FILL #-49152
N128		.FILL #-128 ; screen offset

;; TIMED_INPUT
; A timed input method that only blocks for a preset number of milliseconds and exits
; Returns the value of keystroke in R0 if received in time else returns 0
TIMED_INPUT	ST		R1, TI_R0
			ST		R2, TI_R2
			ST		R3, TI_R3
			ST		R7, TI_R7
			AND		R0, R0 #0
			LD		R2, TICKS
			STI		R2, TMI
POLL		LDI		R3, TMR
			BRn		EXIT_INPUT
			LDI		R1, KBSR
			BRzp	POLL
			LDI		R0, KBDR
			LD		R1, TI_R0
			LD		R2, TI_R2
			LD		R3, TI_R3
			LD		R7, TI_R7
EXIT_INPUT	RET
TI_R0	.BLKW 1
TI_R2	.BLKW 1
TI_R3	.BLKW 1
TI_R7	.BLKW 1
KBSR	.FILL xFE00 ; keyboard status register; KBSR[15] is 1 when new char is recieved
KBDR	.FILL xFE02 ; value of recieved keypress
TMR		.FILL xFE08	; timer register; TMR[15] is one when the timer is up
TMI		.FILL xFE0A ; sets number milliseconds between ticks, 0 for timer off
TICKS	.FILL x00C8 ; 500 milliseconds between ticks

;; DRAW_SQUARE
; Takes a start address, a width, a length, and a color
; INPUT: R1: Start address
;		 R2: Width
;		 R3: Length
;		 R4: Color
DRAW_SQUARE	ST		R0, DS_R0
			ST		R5, DS_R5
			ST		R6, DS_R6
			ST		R7, DS_R7
			LD		R5, ROW_OFFSET
			NOT		R2, R2
			ADD		R2, R2 #1
			ST		R2, NWIDTH	; negate width and store
			NOT		R3, R3
			ADD		R3, R3 #1
			ST		R3, NLENGTH	; negate width and store
			AND 	R0, R0 #0
COL			ST		R0, DS_I
			LD		R3, NLENGTH
			ADD		R0, R0, R3	; check if outer loop complete
			BRzp	END_COL
			AND 	R0, R0 #0
ROW			ST		R0, DS_J
			LD		R3, NWIDTH
			ADD		R0, R0, R3	; check if inner loop complete
			BRzp	END_ROW
			LD		R0, DS_J
			AND		R6, R6 #0	; loop main body
			ADD		R6, R1, R0	; row offset + j
			STR		R4, R6 #0	; store the input color to address (end loop)
			ADD		R0, R0 #1	; increment j
			BR		ROW
END_ROW		ADD		R1, R1, R5	; increment offset
			LD		R0, DS_I
			ADD		R0, R0 #1	; increment i
			BR		COL
END_COL		LD		R0, DS_R0	; end for loo
			LD		R5, DS_R5
			LD		R6, DS_R6
			LD		R7, DS_R7
			RET
DS_R0		.FILL 1
DS_R5		.FILL 1
DS_R6		.FILL 1
DS_R7		.FILL 1
ROW_OFFSET	.FILL x0080
DS_I		.BLKW 1
DS_J		.BLKW 1
NWIDTH		.BLKW 1
NLENGTH		.BLKW 1

.END
