#!/usr/bin/python3

# https://stackoverflow.com/questions/43119744/python-generate-all-possible-strings-of-length-n

import string
import itertools

def generate_strings(str,len):
    for item in itertools.product(str, repeat=len):
        yield "".join(item)

#----------------------------------------

bins = "01"
bstr = generate_strings(bins,16)

for b in bstr:
    print(b)

print("")

hexs = "0123456789ABCDEF"
hstr = generate_strings(hexs,4)

for h in hstr:
    print(h)
