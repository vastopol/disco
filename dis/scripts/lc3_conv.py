#!/usr/bin/python3

# obj/bin/hex converter

# Usage: $ ./conv.py <mode> <file>

# modes:
# 0 = bin to hex
# 1 = hex to bin
# 2 = obj to bin
# 3 = bin to obj (fix)
# 4 = hex to obj (fix)

# files:
# I/O ascii values:
# bin =  [0,1]
# hex =  [0-9][a-f][A-F]
# obj = ?

#========================================

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
    out_file = open(file+".out","w")

    if flag == 2:   # obj file
        in_file = open(file,"rb")
        bytes_read = in_file.read()
        idx = 0
        for b in bytes_read:
            new_str = obj2bin(b)
            if idx == 0:
                out_file.write(new_str)
                idx = 1
            else:
                out_file.write(new_str+"\n") # every second byte
                idx = 0
    else: # bin or hex file
        in_file = open(file,"r")
        for text in in_file:
            line = text.strip()
            if flag == 0:
                new_str = bin2hex(line)
            elif flag == 1:
                new_str = hex2bin(line)
            elif flag == 3:
                new_str = bin2obj(line)
            elif flag == 4:
                new_str = hex2obj(line)
            else:
                print("ERROR")
                exit(1)
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

def obj2bin(line):
    global tables
    bin_str = ""

    # take the actual raw object binary and convert to ascii
    b1 = hex(line)
    b2 = b1[2:]      # remove the "0x" form hex string
    if len(b2) == 1: # make sure byte size
        b2 = "0" + b2

    b2 = b2.upper()

    for b in b2:
        place = tables[1].index(b)
        bin_str += tables[0][place]

    return bin_str

#--------------------

def bin2obj(line):  # <------------- FIXME
    global tables
    obj_str = "xxxxxxxxxxxxxxxx"
    # take the ascii and convert to actual raw object
    print("FIXME")
    return obj_str

#--------------------

def hex2obj(line):  # <------------- FIXME
    global tables
    obj_str = "xxxxxxxxxxxxxxxx"
    # take the ascii and convert to actual raw object
    print("FIXME")
    return obj_str

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
    if not (0 <= int(sys.argv[1])) or not (int(sys.argv[1]) <= 4):
        print("Error: Incorrect mode, bounds")
        print("Usage: $ ./conv.py <mode> <file>")
        sys.exit(1)

    flag = int(sys.argv[1])
    files = sys.argv[2:]
    for file in files:
        main(file,flag)
