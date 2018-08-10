#!/usr/bin/python3

# obj/bin/hex converter

# Usage: $ ./conv.py <mode> <file>

# modes:
# 0 = bin to hex
# 1 = hex to bin
# 2 = bin to obj (fix)
# 3 = obj to bin (fix)

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
        elif flag == 2:
            new_str = bin2obj(line)
        else:
            new_str = obj2bin(line)
        out_file.write(new_str+"\n")
    out_file.close()

#--------------------

def bin2hex(line):
    global tables
    hex_str = "xxxx"
    if ( len(line) % 4 ) != 0:
        print("Error: malformed instruction, length%4 != 0")
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
            tmp_hex += tables[1][place]
        else:
            print("Error: unknown bin value")
            return hex_str

    return tmp_hex

#--------------------

def hex2bin(line):
    global tables
    bin_str = "xxxxxxxxxxxxxxxx"
    line1 = str.upper(line)
    for c in line1:
        if c in tables[1]:
            continue
        else:
            print("Error: invalid character encountered")
            return bin_str

    tmp_bin = ""
    hexes = [ x for x in line1 ]
    for y in hexes:
        if y in tables[1]:
            place = tables[1].index(y)
            tmp_bin += tables[0][place]
        else:
            print("Error: unknown hex value")
            return bin_str

    return tmp_bin

#--------------------

def bin2obj(line):
    global tables
    obj_str = "xxxxxxxxxxxxxxxx"
    # take the ascii and convert to actual raw object
    print("FIXME")
    return obj_str

#--------------------

def obj2bin(line):
    global tables
    bin_str = "xxxxxxxxxxxxxxxx"
    # take the actual raw object binary and convert to ascii
    print("FIXME")
    return bin_str

#========================================

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Error: Missing argument")
        print("Usage: $ ./conv.py <mode> <file>")
        sys.exit(1)
    if not str.isdigit(sys.argv[1]):
        print("Error: Incorrect mode, nondigit")
        print("Usage: $ ./conv.py <mode> <file>")
        sys.exit(1)
    if not (0 <= int(sys.argv[1])) or not (int(sys.argv[1]) <= 3):
        print("Error: Incorrect mode, bounds")
        print("Usage: $ ./conv.py <mode> <file>")
        sys.exit(1)

    flag = int(sys.argv[1])
    files = sys.argv[2:]
    for file in files:
        main(file,flag)
