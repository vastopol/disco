#!/usr/bin/python3

# LC-3 Assembler (fix)
# Takes in asm file, emits .obj file and .sym file
# shuld probably do a multipass style
# strip comments, then make symbol table, then desymbolize asm, then emit object file

# Modules
import sys

# global
tables = [
    ["0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111",
     "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111"],
    ["0", "1", "2", "3", "4", "5", "6", "7",
     "8", "9", "A", "B", "C", "D", "E", "F"]
]

#========================================

def main(file):
    global tables
    print("assembling: ", file)
    in_file = open(file,"r")
    out_file1 = open(file+".sym","w")
    out_file2 = open(file+".obj","w")

    # generic symbol table header
    symtab_hd = '''// Symbol table
// Scope level 0:
//	Symbol Name       Page Address
//	----------------  ------------
'''
    out_file1.write(symtab_hd)

    body = []
    syms = {}  # map : name -> address

    # get the individual lines
    for line in in_file:
        new_str = line.strip()
        body.append(new_str)

    # get addr && rm first and last
    orig = body[0].split('x')[1]
    body = body[1:-1]

    addr = ""
    for i in orig:
        addr += tables[0][int(i)]

    # sym
    for b in body:
        out_file1.write("//  "+b+"\n")

    # obj (binary ascii output for now) fix later
    out_file2.write(addr+"\n")
    for b in body:
        out_file2.write(b+"\n")

    out_file1.close()
    out_file2.close()

#========================================

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./lc3_asm.py <file>")
        sys.exit(1)
    files = sys.argv[1:]
    for file in files:
        main(file)
