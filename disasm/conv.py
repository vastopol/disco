#!/usr/bin/python3

# LC-3 bin/hex converter
# takes [0,1] as binary
# takes [0-9][a-f][A-F] as hex

# Modules
import sys

# global
tables = [
    ["0","0000"], ["1","0001"], ["2","0010"], ["3","0011"],
    ["4","0100"], ["5","0101"], ["6","0110"], ["7","0111"],
    ["8","1000"], ["9","1001"], ["A","1010"], ["B","1011"],
    ["C","1100"], ["D","1101"], ["E","1110"], ["F","1111"]
]

#========================================

# 0 is bin2hex, 1 is hex2bin
def main(file,flag):
    print("converting: ", file)
    in_file = open(file,"r")
    #out_file = open(file+".out","w")
    for line in in_file:
        if flag == 0:
            new_str = bin2hex(line)
        else:
            new_str = hex2bin(line)
        # write new to out_file

def bin2hex(line):
    global tables
    # check if ( # of chars in line % 4 == 0 and each char is either "1" or "0")
    return


def hex2bin(line):
    global tables
    # toupper each char in the file
    # check if [0-9] or [A-F] as valid hex
    return

#========================================

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./conv.py [flag] <file>")
        sys.exit(1)
    elif sys.argv[1] == "-h":
        if not len(sys.argv) >= 3 :
            print("Error: Missing File Arguments")
            print("Usage: $ ./conv.py -h <file>")
            sys.exit(1)
        else:
            flag = 1
            files = sys.argv[2:]
    else:
        flag = 0
        files = sys.argv[1:]
    for file in files:
        main(file,flag)
