#!/usr/bin/python3

# LC-3 Dissassembler
# Takes in a text/binary file, emits an assembly file

# Modules
import sys

#========================================

# for now if flag is unset it assumes text,
# if flag is set then it is raw binary and needs to be converted to ascii
def main(file,flag):
    print("disassembling: ", file)
    in_file = open(file,"r")
    out_file = open(file+".asm","w")

    # cant think of a good way to handle this so it is kindof messy
    # basically this is baecuse loop assums name asc_file, since disasm() needs ascii input
    # so weirdness on renaming or converting a file before dissassembly
    if flag == 0:
        in_file.close()
        asc_file = open(file,"r")
    else:
        asc_file = open(file+".bin","w")
        for btext in in_file:
            asc_str = bin2ascii(btext)
            print(asc_str)
            asc_file.write(asc_str)
        asc_file.close()
        asc_file = open(file+".bin","r")

    # convert bin to asm
    for text in asc_file:
        line = text.strip()
        new_str = disass(line)
        out_file.write(new_str+"\n")
    out_file.close()

def disass(text):
    print(text)
    return text

def bin2ascii(bin):
    print(bin)
    return bin

#========================================

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./dis.py [flag] <file>")
        sys.exit(1)
    elif sys.argv[1] == "-b":
        if not len(sys.argv) >= 3 :
            print("Error: Missing File Arguments")
            print("Usage: $ ./dis.py -b <file>")
            sys.exit(1)
        else:
            flag = 1
            files = sys.argv[2:]
    else:
        flag = 0
        files = sys.argv[1:]
    for file in files:
        main(file,flag)
