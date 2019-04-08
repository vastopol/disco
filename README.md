# disco

The only custom disassembly framework for the LC-3 architecture.

This project targets the LC-3 assembly programming language from Patt and Patel's Introduction to Computing Systems.

## The Disassembler

`disco` is a linear sweep disassembler and tool-chain for the LC-3 assembly language

disassembler prototype 1 complete

currently working on completing a reassembling disassembler before starting the decompiler phase.

`disco` is integrated with the `lc3tools` and `lcc-1.3` C language compiler.

## The Project

LC-3 assembly coding projects and the LC-3 disassembler/decompiler project

* asm      = LC-3 assembly code
* dis       = disassembler suite
* toolbox   = notes, source, tools

## Goals

Research papers on disassembly, reassembly, binary analysis, etc... typically focuses on x86 assembly.
The idea is that eventually the work on `disco` could possibly be used for Risc architecture reverse engineering.
This could be applicable towards Mips, Risc V, Arm, and Thumb architectures in particular.

