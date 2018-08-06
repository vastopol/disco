#!/usr/bin/python3

# LC-3 Dissassembler
# Takes in a bin file, emits an asm file
# technically  the dissassembler reads ascii,

# Modules
import sys

# global
tables = [
    ["0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111",
     "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111"],
    ["BR", "ADD", "LD", "ST", "JSR", "AND", "LDR", "STR",
     "RTI", "NOT", "LDI", "STI", "JMP", "XXX", "LEA", "TRAP"]
]

# Done: RTI, TRAP, JMP, BR, LD, LDI, LEA, ST, STI
# Todo: ADD, JSR, AND, LDR, STR, NOT

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
    err_str = ""
    if ( len(line) % 4 ) != 0:
        print("Error: malformed instruction, length")
        return err_str
    for c in line:
        if c == "0" or c == "1":
            continue
        else:
            print("Error: invalid character encountered")
            return err_str

    # get the opcode
    op_str = ""
    body_str = ""
    op = line[0:4]
    body = line[4:]
    if op in tables[0]:
        place = tables[0].index(op)
        op_str = str(tables[1][place])
    else:
        #print("Error: unknown opcode")
        return err_str

    # process body based on opcode
    if op_str == "XXX":
        print("Error: illegal opcode")
        return "ILLEGAL_OPCODE"
    elif op_str == "RTI":
        body_str = ""
    elif op_str == "TRAP":
        trapno = str(hex(int(body,2)))
        body_str += " "
        body_str += trapno
    elif op_str == "JMP":
        jreg = body[3:6]
        jregno = str(int(jreg,2))
        body_str += " R"
        body_str += jregno
    elif op_str == "BR":
        nzp = body[:3]
        br_offset = body[3:]
        if nzp[0] == "1":
            op_str += "n"
        if nzp[1] == "1":
            op_str += "z"
        if nzp[2] == "1":
            op_str += "p"
        body_str += " "
        body_str += br_offset
    elif ( op_str == "LD" or op_str == "LDI" or op_str == "LEA" or
           op_str == "ST" or op_str == "STI" ):
        reg = body[:3]
        offset = body[3:]
        regno = str(int(reg,2))
        body_str += " R"
        body_str += regno
        body_str += ", "
        body_str += offset
    else:
        body_str += " "
        body_str += body

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
