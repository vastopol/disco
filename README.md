# disco

The only custom disassembly framework for the LC-3 architecture.

This project targets the LC-3 assembly programming language from Patt and Patel's Introduction to Computing Systems.

## The Disassembler

`disco` is a disassembly tool-chain for the LC-3 assembly language

prototype 1 complete:
* linear sweep disassembler
* resymbolizer
* patcher
* converter

`disco` is integrated with the `lc3tools` and `lcc-1.3` C language compiler.

prototype phase 2:
* complete all the functionalities to replace the lc3tools with open source python implementations.
    * bin2obj
    * hex2obj
    * assembler
    * simulator
* if possible fix lcc-1.3 compiler to actually output working assembly code.

## The Project

LC-3 assembly coding projects and the LC-3 disassembler/decompiler project

* asm      = LC-3 assembly code
* dis       = disassembler suite
* toolbox   = notes, source, tools

## Goals

Research papers on disassembly, reassembly, binary analysis, etc... typically focuses on x86 assembly.
The idea is that eventually the work on `disco` could possibly be used for Risc architecture reverse engineering.
This could be applicable towards Mips, Risc V, Arm, and Thumb architectures in particular.

