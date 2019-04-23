#!/usr/bin/python3

# remove comments ';'

import sys

def main(file):
    in_file = open(file,"r")
    out_file = open(file+".out","w")
    print("Strip: "+file)
    for line in in_file:
        stripper = line.split(";")
        stripo = stripper[0].strip()
        if stripo != "" and stripo != "\n":
            out_file.write(stripo+"\n")

#----------------------------------------

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./lc3_patch.py <file>")
        sys.exit(1)
    files = sys.argv[1:]
    for file in files:
        main(file)
