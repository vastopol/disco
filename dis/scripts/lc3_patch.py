#!/usr/bin/python3

# generate patch code
# single detour based patch

# Modules
import sys

#========================================

def main(file):
    print("patching: ", file)
    in_file = open(file,"r")
    out_file = open(file+".asm","w")

    # get the .ORIG start address
    orig_str = in_file.readline().strip()
    out_file.write(orig_str+"\n")

    # insert detour stub to patches here
    stub='''
    ; detour patch redirect
    JSR PATCHCODE
    '''
    out_file.write(stub+"\n")

    # write out the body, but remove .END
    body = []
    for line in in_file:
        body.append(line)
    body.pop()
    for x in body:
        out_file.write(x)

    # subroutine dispatch handler
    d1='''
    ; dispatcher handles patches then runs main program
    PATCHCODE:
    ST R7, startp
    '''

    d2=""
    num_patches=1
    for i in range(num_patches):
        d2+="JSR PATCH"+str(i+1)+"\n"

    d3='''
    LD R7, startp
    RET
    startp .BLKW 1
    '''

    dispatch = d1 + d2 + d3
    out_file.write(dispatch)

    # write out patches
    pcode = patch()
    out_file.write(pcode)

    # re-insert the end marker
    end=".END"
    out_file.write(end)

    out_file.close()

#--------------------

def patch():

    # header
    head='''
    ; patch subroutine 1
    ; prints "PATCHED", no side effects
    PATCH1:
    ; save regs
    ST R0, SaveR0
    ST R1, SaveR1
    ST R2, SaveR2
    ST R3, SaveR3
    ST R4, SaveR4
    ST R5, SaveR5
    ST R6, SaveR6
    ST R7, SaveR7
    '''

    code='''
    ;code
    LEA R0, pmsg
    PUTS
    '''

    ret='''
    ; restore regs
    LD R0, SaveR0
    LD R1, SaveR1
    LD R2, SaveR2
    LD R3, SaveR3
    LD R4, SaveR4
    LD R5, SaveR5
    LD R6, SaveR6
    LD R7, SaveR7
    RET
    '''

    data='''
    ; local data
    SaveR0 .BLKW 1
    SaveR1 .BLKW 1
    SaveR2 .BLKW 1
    SaveR3 .BLKW 1
    SaveR4 .BLKW 1
    SaveR5 .BLKW 1
    SaveR6 .BLKW 1
    SaveR7 .BLKW 1
    pmsg .STRINGZ \"PATCHED\\n\"
    '''

    text = head + code + ret + data

    return text

#========================================

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./lc3_patch.py <file>")
        sys.exit(1)
    files = sys.argv[1:]
    for file in files:
        main(file)
