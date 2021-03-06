#!/usr/bin/python3

# LC-3 Dissassembler
# Takes in a bin file, emits an asm file
# technically  the dissassembler reads ascii,
# this relies on lc3_conv.py to first conver the .obj file to a .bin file

#========================================

# Modules
import sys

# global
tables = [
    ["0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111",
     "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111"],
    ["BR", "ADD", "LD", "ST", "JSR", "AND", "LDR", "STR",
     "RTI", "NOT", "LDI", "STI", "JMP", "XXX", "LEA", "TRAP"]
]

#========================================

def main(file):
    print("disassembling: ", file)
    in_file = open(file,"r")
    out_file = open(file+".asm","w")

    first_line = in_file.readline().strip()  # get the .ORIG start address
    orig_str = ".ORIG x" +  str(format(int(first_line,2),"X"))
    out_file.write(orig_str+"\n")

    for line in in_file:                # disassemble body
        new_str = disass(line.strip())
        out_file.write(new_str+"\n")

    out_file.write(".END"+"\n")     # end of file
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
        # print("Error: illegal opcode")
        # return "ILLEGAL_OPCODE"
        op_str = ".FILL"
        body_str = " x" + format(int(line,2),"X")  # probably will be a .FILL in a well formed file

    elif op_str == "RTI":
        body_str = ""

    elif op_str == "TRAP":      # check for .FILL
        body_str += " x"
        body_str += format(int(body,2),"X")
        trapno = str(format(int(body,2),"X"))
        if   trapno == "20":
            body_str = ""
            op_str = "GETC"
        elif trapno == "21":
            body_str = ""
            op_str = "OUT"
        elif trapno == "22":
            body_str = ""
            op_str = "PUTS"
        elif trapno == "23":
            body_str = ""
            op_str = "IN"
        elif trapno == "24":
            body_str = ""
            op_str = "PUTSP"
        elif trapno == "25":
            body_str = ""
            op_str = "HALT"
        else:  # assume is .FILL pseudo op
            op_str = ".FILL"
            body_str = " x" + format(int(line,2),"X")

    elif op_str == "JMP":
        jreg = body[3:6]
        body_str += " R"
        body_str += str(int(jreg,2))
        if str(int(jreg,2)) == "7":  # JMP R7 is return from subroutine
            body_str = ""
            op_str = "RET"

    elif op_str == "BR":    # check for .FILL
        nzp = body[:3]
        br_offset = body[3:]
        if nzp[0] == "1":
            op_str += "n"
        if nzp[1] == "1":
            op_str += "z"
        if nzp[2] == "1":
            op_str += "p"
        body_str += " x"
        body_str += format(int(br_offset,2),"X")
        if int(nzp,2) == 0:  # assume is .FILL pseudo op, can't have no flags set
            op_str = ".FILL"
            body_str = " x" + format(int(line,2),"X")

    elif ( op_str == "LD" or op_str == "LDI" or op_str == "LEA" or  # check for .FILL
           op_str == "ST" or op_str == "STI" ):
        reg = body[:3]
        offset = body[3:]
        body_str += " R"
        body_str += str(int(reg,2))
        body_str += ", x"
        body_str += format(int(offset,2),"X")

    elif op_str == "NOT":
        reg1 = body[:3]
        reg2 = body[3:6]
        body_str += " R"
        body_str += str(int(reg1,2))
        body_str += ", R"
        body_str += str(int(reg2,2))

    elif op_str == "LDR" or op_str == "STR": # check for .FILL
        reg1 = body[:3]
        reg2 = body[3:6]
        offset = body[6:]
        body_str += " R"
        body_str += str(int(reg1,2))
        body_str += ", R"
        body_str += str(int(reg2,2))
        body_str += ", x"
        body_str += format(int(offset,2),"X")
        if int(offset,2)-32 > 15: # .FILL above 5 bit limit ???
            op_str = ".FILL " + hex(int(line,2))
            body_str = ""

    elif op_str == "ADD" or op_str == "AND":
        reg1 = body[:3]
        reg2 = body[3:6]
        flag = body[6]
        rest = body[7:]
        body_str += " R"
        body_str += str(int(reg1,2))
        body_str += ", R"
        body_str += str(int(reg2,2))
        body_str += ", "
        if flag == "0":
            body_str += "R"
            body_str += str(int(rest,2))
        elif int(rest,2)-32 > 15: # .FILL above 5 bit limit ???
            op_str = ".FILL " + hex(int(line,2))
        else:
            body_str += "x"
            body_str += format(int(rest,2),"X")

    elif op_str == "JSR":   # check for .FILL ?
        flag = body[0]
        if flag == "1":
            body_str += " x"
            body_str += format(int(body[1:],2),"X")
        else:
            op_str += "R"
            body_str += " R"
            body_str += str(int(body[3:6],2))

    else:
        body_str += " x"
        body_str += format(int(body,2),"X")

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
