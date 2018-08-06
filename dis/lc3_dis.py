#!/usr/bin/python3

# LC-3 Dissassembler
# Takes in a bin file, emits an asm file

# technically at this point the dissassembler handler ascii,
# if the lcc compiler works, after compilation you would have convert from obj to bin

# Modules
import sys

# global
tables = [
    ["0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111",
     "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111"],
    ["BR", "ADD", "LD", "ST", "JSR", "AND", "LDR", "STR",
     "RTI", "NOT", "LDI", "STI", "JMP", "XXX", "LEA", "TRAP"]
]

# jmp and ret have op = 1100, return is jmp r7
# jsr and jsrr have op = 0100
# opcode 14 is illegal instruction

# Trap x20 GETC
# Trap x21 OUT
# Trap x22 PUTS
# Trap x23 IN
# Trap X24 PUTSP
# Trap x25 HALT

#========================================

def main(file):
    print("disassembling: ", file)
    in_file = open(file,"r")
    out_file = open(file+".asm","w")
    for line in in_file:
        new_str = disass(line.strip())
        out_file.write(new_str+"\n")
    out_file.close()

#--------------------

def disass(line):
    global tables
    err_str = "xxxxxxxxxxxxxxxx"
    if ( len(line) % 4 ) != 0:
        print("Error: malformed instruction, length")
        return err_str
    for c in line:
        if c == "0" or c == "1":
            continue
        else:
            print("Error: invalid character encountered")
            return err_str

    op_str = ""
    body_str = ""
    op = line[0:4]
    body = line[4:]
    if op in tables[0]:
        place = tables[0].index(op)
        op_str = str(tables[1][place])
    else:
        print("Error: unknown opcode")
        return err_str

    if op_str == "XXX":
        print("Error: illegal opcode")
        return err_str
    if op_str == "TRAP":
        trapno = str(hex(int(body,2)))
        body_str += " "
        body_str += trapno


    asm_str = op_str + body_str
    return asm_str

#========================================

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./lc3_dis.py <file>")
        sys.exit(1)
    files = sys.argv[1:]
    for file in files:
        main(file)
