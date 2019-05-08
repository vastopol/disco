#!/usr/bin/python3

# this would be used with the output of the disassembler
# it looks at the relative pc offsets for some of the instructions

# Modules
import sys

#========================================

def main(file):
    print("resymbolize: ", file)
    in_file = open(file,"r")
    out_file = open(file+".asm","w")

    # get the .ORIG start address
    orig_str = in_file.readline().strip()
    out_file.write(orig_str+"\n")

    # get the body and remove .END
    body = []
    for line in in_file:
        body.append(line)
    body.pop()

    # symbolize labels and data
    start = orig_str.split("x")[1]
    new_body = resym(start,body)

    # re-write body
    for x in new_body:
        out_file.write(x)

    # re-insert the end marker
    end=".END"
    out_file.write(end)
    out_file.close()

#--------------------

def resym(start,body):
    vcnt = 0
    lcnt = 0
    lbls = {}   # dict - addr : name
    vars = {}   # dict - addr : name
    code = []   # fixed instructions

    pc = int(start,16)

    # locate labels and variables
    for inst in body:
        block = inst.strip().split(" ")
        # print(); print(hex(pc),"\t",block)
        pc += 1

        # variables
        if block[0] == "LEA" or block[0] == "LDI" or block[0] == "LD" or block[0] == "STI" or block[0] == "ST":
            off = int(block[2].split("x")[1],16)
            loc = pc + off
            vars[hex(loc)] = "var" + str(vcnt)
            vcnt += 1
            # print("\t", hex(loc))

        # labels
        if block[0][:2] == "BR":
            off = int(block[1].split("x")[1],16)
            if off > 255:
                off = off - 512
            loc = pc + off
            lbls[hex(loc)] = "lbl" + str(lcnt)
            lcnt += 1
            # print("\t", hex(loc))

        if block[0] == "JSR":
            off = int(block[1].split("x")[1],16)
            if off > 511:
                off = off - 1024
            loc = pc + off
            lbls[hex(loc)] = "lbl" + str(lcnt)
            lcnt += 1
            # print("\t", hex(loc))

    # print()
    # print("variables:")
    # for k in vars:
    #     print(k,vars[k])
    # print()
    # print("labels:")
    # for k in lbls:
    #     print(k,lbls[k])
    # print()

    pc = int(start,16)

    # reprocess and insert names
    # has many different if/else branching with continues
    for inst in body:
        block = inst.strip().split(" ")
        fin = ""

        if hex(pc) in lbls:
            code.append(lbls[hex(pc)] + "\n")
        elif hex(pc) in vars:
            code.append(vars[hex(pc)] + "\n")
        pc += 1

        # variables
        if block[0] == "LEA" or block[0] == "LDI" or block[0] == "LD" or block[0] == "STI" or block[0] == "ST":
            off = int(block[2].split("x")[1],16)
            loc = pc + off
            if hex(loc) in vars:
                code.append("\t"+ block[0] + " " + block[1] + " " + vars[hex(loc)] + "\n")
                continue

        # labels
        if block[0][:2] == "BR":
            off = int(block[1].split("x")[1],16)
            if off > 255:
                off = off - 512
            loc = pc + off
            if hex(loc) in lbls:
                code.append("\t"+ block[0] + " " + lbls[hex(loc)] + "\n")
                continue

        # labels
        if block[0] == "JSR":
            off = int(block[1].split("x")[1],16)
            if off > 511:
                off = off - 1024
            loc = pc + off
            if hex(loc) in lbls:
                code.append("\t"+ block[0] + " " + lbls[hex(loc)] + "\n")
                continue

        # immediate signed 5-bit
        if block[0] == "ADD" or block[0] == "AND" or block[0] == "LDR" or block[0] == "STR":
            if block[3][0] == "x":
                off = int(block[3].split("x")[1],16)
                if off > 15:
                    off = off - 32
                code.append("\t"+ block[0] + " " +  block[1] + " " + block[2] + " #" + str(off) + "\n")
                continue

        # trap/ret
        if   block[0] == "GETC":
            code.append("\t" + block[0] + "    ; TRAP x20\n")
            continue
        elif block[0] == "OUT":
            code.append("\t" + block[0] + "    ; TRAP x21\n")
            continue
        elif block[0] == "PUTS":
            code.append("\t" + block[0] + "    ; TRAP x22\n")
            continue
        elif block[0] == "IN":
            code.append("\t" + block[0] + "    ; TRAP x23\n")
            continue
        elif block[0] == "PUTSP":
            code.append("\t" + block[0] + "    ; TRAP x24\n")
            continue
        elif block[0] == "HALT":
            code.append("\t" + block[0] + "    ; TRAP x25\n")
            continue
        elif block[0] == "RET":
            code.append("\t" + block[0] + "    ; JMP R7\n")
            continue

        # special data
        if block[0] == ".FILL":
            off = int(block[1].split("x")[1],16)
            if (off > 31 and off < 127): # ascii value
                cmt_str = "    ;  '" + str(chr(off)) + "'"
                code.append("\t" + block[0] + " " + block[1] + cmt_str + "\n")
                continue
            if off == 10: # newline
                cmt_str = "    ;  '\\n'"
                code.append("\t" + block[0] + " " + block[1] + cmt_str + "\n")
                continue
            if off == 65024: # KBSR xFE00
                cmt_str = "    ;  KBSR"
                code.append("\t" + block[0] + " " + block[1] + cmt_str + "\n")
                continue
            if off == 65026: # KBDR xFE02
                cmt_str = "    ;  KBDR"
                code.append("\t" + block[0] + " " + block[1] + cmt_str + "\n")
                continue
            if off == 65028: # DSR xFE04
                cmt_str = "    ;  DSR"
                code.append("\t" + block[0] + " " + block[1] + cmt_str + "\n")
                continue
            if off == 65030: # DDR xFE06
                cmt_str = "    ;  DDR"
                code.append("\t" + block[0] + " " + block[1] + cmt_str + "\n")
                continue

        # catch all...
        code.append("\t"+inst)

    return code

#========================================

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./lc3_resym.py <file>")
        sys.exit(1)
    files = sys.argv[1:]
    for file in files:
        main(file)
