AND 010010100000
LD R3, 000010000
TRAP 0x23
LDR 001011000000
ADD 100001111100
BRz 000001000
NOT 001001111111
ADD 001001100001
ADD 001001000000
BRnp 000000001
ADD 010010100001
ADD 011011100001
LDR 001011000000
BRnzp 111110110
LD R0, 000000100
ADD 000000000010
TRAP 0x21
TRAP 0x25
BR 000110000

AND 010010100000
ADD 010010000100
ADD 101101111111
BRzp 111111101
TRAP 0x25

AND 001001100000
AND 100100100000
ADD 100100101010
LD R2, 011111100
LDR 011010000000
ADD 010010100001
ADD 001001000011
ADD 100100111111
BRp 111111011
TRAP 0x25

AND 000000100000
ADD 000000100001
AND 001001100000
ADD 001001111011
AND 011011100000
ADD 011011101010
LD R4, 000001001
LDR 010100000000
ADD 010010000001
BRz 000000101
ADD 100100100001
ADD 011011111111
LDR 010100000000
BRp 111111010
AND 000000100000
TRAP 0x25
ST R0, 100000000

AND 001001100000
ADD 001001101111
LDI R2, 000000110
BRn 000000100
ADD 001001111111
ADD 010010000010
BRn 000000001
BRnzp 111111100
TRAP 0x25
ST R0, 100000000
