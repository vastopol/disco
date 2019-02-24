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
    out_file1 = open(file+".obj","w")
    out_file2 = open(file+".sym","w")
    for line in in_file:
        new_str = ass(line.strip())
        out_file1.write(new_str+"\n")
        out_file2.write(new_str+"\n")
    out_file.close()

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
    for file in files:
        main(file)
