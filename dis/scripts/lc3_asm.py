#!/usr/bin/python3

# LC-3 Assembler (fix)
# Takes in asm file, emits .obj file and .sym file
# shuld probably do a multipass style
# strip comments, then make symbol table, then desymbolize asm, then emit object file

# Modules
import sys

#========================================

def main(file):
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

    # sym
    for b in body:
        out_file1.write("//  "+b+"\n")

    # obj
    for b in body:
        out_file2.write(b+"\n")

    out_file1.close()
    out_file2.close()

#--------------------

def ass(text):    # <------------- FIXME
    print(text)
    return text

#========================================

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./lc3_asm.py <file>")
        sys.exit(1)
    files = sys.argv[1:]
    for file in files:
        main(file)
