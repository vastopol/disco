#!/usr/bin/python3

# LC-3 Assembler
# Takes in asm file, emits  bin file

# Modules
import sys

#========================================

def main(file):
    print("assembling: ", file)
    in_file = open(file,"r")
    out_file = open(file+".bin","w")
    for line in in_file:
        new_str = ass(line.strip())
        out_file.write(new_str+"\n")
    out_file.close()

def ass(text):
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
