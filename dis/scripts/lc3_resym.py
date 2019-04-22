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

    start = orig_str.split("x")[1]

    # get the body, but remove .END
    body = []
    for line in in_file:
        body.append(line)
    body.pop()

    # symbolize labelst and data
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
        print(); print(hex(pc),"\t",block)
        pc += 1

        # variables
        if block[0] == "LEA" or block[0] == "LDI" or block[0] == "LD" or block[0] == "STI" or block[0] == "ST":
            off = int(block[2].split("x")[1],16)
            loc = pc + off
            vars[hex(loc)] = "var" + str(vcnt)
            vcnt += 1
            print("\t", hex(loc))

        # labels
        if block[0][:2] == "BR":
            off = int(block[1].split("x")[1],16)
            if off > 255:
                off = off - 512
            loc = pc + off
            lbls[hex(loc)] = "lbl" + str(lcnt)
            lcnt += 1
            print("\t", hex(loc))

    print()
    print("variables:")
    for k in vars:
        print(k,vars[k])
    print()
    print("labels:")
    for k in lbls:
        print(k,lbls[k])
    print()

    pc = int(start,16)

    # reprocess and insert names
    for inst in body:
        block = inst.strip().split(" ")
        fin = ""

        if hex(pc) in lbls:
            code.append(lbls[hex(pc)] + ":\n")
        elif hex(pc) in vars:
            code.append(vars[hex(pc)] + ":\n")
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

        # else

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
