#!/usr/bin/python3

# generate patch code
# single detour bsed patch

# when patch should be applied steps:
# disassemble the original file
# resymbolize
# remov the last line .END
# append code patch
# change first lines of code to detour launch
# probably have to cout size of launc stub,
# so can redirect back to original program by address

# probably launch patches with a JSR to label

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

    body = []
    # write out the body, but remove .END
    for line in in_file:
        body.append(line)
    body.pop()
    for x in body:
        out_file.write(x)

    dispatch='''
    ; dispatcher subroutine
    ; handle patches then run main program
    PATCHCODE:
    ST R7, startp

    JSR PATCH1

    LD R7, startp
    RET
    startp .BLKW 1
    '''
    out_file.write(dispatch)

    # write out patches
    pcode = patch()
    out_file.write(pcode)

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

    # re-insert the end marker
    end=".END"

    text = head + code + ret + data + end

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
