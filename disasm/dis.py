#!/usr/bin/python3

# LC-3 Dissassembler
# Takes in a binary file, emits an assembly file

# Modules
import sys

#========================================

def main(argv):
    pass

#========================================

if __name__ == '__main__':
    if len(sys.argv) == 1:
        print("Error: Missing File Arguments")
        print("Usage: $ ./das.py <file>")
    else:
        for i in sys.argv[1:]:
            print("processing: ", i)
            main(i)
