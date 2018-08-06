#!/usr/bin/python3

# obj/bin/hex converter

# Usage: $ ./conv.py [flag] <file>

# flags:
# none = binary to hex
# -h = hex to binary
# -o = obj to binary

# files:
# I/O ascii values:
# bin =  [0,1]
# hex =  [0-9][a-f][A-F]
# obj = ?

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

# 0 is bin2hex, 1 is hex2bin, 2 is obj2bin
def main(file,flag):
    print("converting: ", file)
    in_file = open(file,"r")
    out_file = open(file+".out","w")
    for text in in_file:
        line = text.strip()
        if flag == 0:
            new_str = bin2hex(line)
        elif flag == 1:
            new_str = hex2bin(line)
        else:
            new_str = obj2bin(line)
        out_file.write(new_str+"\n")
    out_file.close()

#--------------------

def bin2hex(line):
    global tables
    hex_str = "xxxx"
    if ( len(line) % 4 ) != 0:
        print("Error: malformed instruction, length")
        return hex_str
    for c in line:
        if c == "0" or c == "1":
            continue
        else:
            print("Error: invalid character encountered")
            return hex_str
    tmp_hex = ""
    chunks = [ line[i:i+4] for i in range(0, len(line), 4) ]
    for x in chunks:
        if x in tables[0]:
            place = tables[0].index(x)
            tmp_hex += str(tables[1][place])
        else:
            print("Error: unknown hex value")
            return hex_str
    return tmp_hex

#--------------------

def hex2bin(line):
    global tables
    bin_str = "xxxxxxxxxxxxxxxx"
    # toupper each char in the line
    # check if [0-9] or [A-F] as valid hex
    print("FIXME")
    return bin_str

#--------------------

def obj2bin(line):
    global tables
    bin_str = "xxxxxxxxxxxxxxxx"
    # take the actual raw object binary and convert to ascii
    print("FIXME")
    return bin_str

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
    elif sys.argv[1] == "-o":
        if not len(sys.argv) >= 3 :
            print("Error: Missing File Arguments")
            print("Usage: $ ./conv.py -o <file>")
            sys.exit(1)
        else:
            flag = 2
            files = sys.argv[2:]
    else:
        flag = 0
        files = sys.argv[1:]
    for file in files:
        main(file,flag)
