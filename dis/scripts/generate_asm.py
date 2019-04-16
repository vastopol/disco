#!/usr/bin/python

# generate asm instructions
# also need to generate all possible offsets for some ?

print "; every asm instruction"

print ".ORIG x0000"

print ";--------------------"

print "; rti"

print "RTI"

print ";--------------------"

print "; jsr"

print "JSR x0"

print ";--------------------"

print "; jsrr"

for i in range(8):
    print "JSRR R"+str(i)

print ";--------------------"

print "; trap"

print "GETC"
print "TRAP x20"
print "OUT"
print "TRAP x21"
print "PUTS"
print "TRAP x22"
print "IN"
print "TRAP x23"
print "PUTSP"
print "TRAP x24"
print "HALT"
print "TRAP x25"

print ";--------------------"

print "; jmp"

for i in range(8):
    print "JMP R"+str(i)
print "RET"

print ";--------------------"

print "; br"

print "BR  x0"
print "BRn  x0"
print "BRz  x0"
print "BRp  x0"
print "BRnz  x0"
print "BRnp  x0"
print "BRzp  x0"
print "BRnzp  x0"

print ";--------------------"

print "; not"

for i in range(8):
    for j in range(8):
        print "NOT R"+str(i)+", R"+str(j)

print ";--------------------"

print "; and"

for i in range(8):
    for j in range(8):
        for k in range(8):
            print "AND R"+str(i)+", R"+str(j)+", R"+str(k)

print ";--------------------"

print "; add"

for i in range(8):
    for j in range(8):
        for k in range(8):
            print "ADD R"+str(i)+", R"+str(j)+", R"+str(k)

print ";--------------------"

print "; lea"

for i in range(8):
    print "LEA R"+str(i)+", x0"

print ";--------------------"

print "; ld"

for i in range(8):
    print "LD R"+str(i)+", x0"

print ";--------------------"

print "; st"

for i in range(8):
    print "ST R"+str(i)+", x0"

print ";--------------------"

print "; ldi"

print ";--------------------"

print "; sti"

print ";--------------------"

print "; ldr"

print ";--------------------"

print "; str"

print ";--------------------"

print ".END"

