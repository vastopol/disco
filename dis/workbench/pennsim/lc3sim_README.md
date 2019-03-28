# LC-3 without running a VM

## Core Files
- LC3sim.jar is the LC-3 simulator, this requires [Java VM](https://java.com/en/download/) to be installed
- lc3os.asm is the LC-3 OS file

These files are provided by the University of Pennsylvania for free

## Terminology
- **asm** is the assembly code, in this case its for the LC-3 processor
- **obj** is the machine language of the assembly file

## Console Commands
- `as <file>` assembles your code into machine language (think binary)
- `load <file>` loads your assembed file into the simulator
- `set <register> <value>` changes the value of a register to a value i.e. `set R5 #30`
- `reset` resets the values on the registers
- `break set <memory location>` sets a memory location as a break. This means the simulator will pause at the instruction at the memory locaton. i.e. `break set x5000`
- `break clear <memory location>` removes the break point. i.e. `break clear x5000`

## Simulator Controls
- **Next** goes to the next line disregarding function calls and jumps
- **Step** goes to the next line but will follow function calls and jumps
- **Continue** runs the entirety of your code
- **Stop** stops the execution of your code

## Assembling .asm to .obj
- Run LC3.sim
- Type `as lc3os.asm` into the console to assemble the code
- You will now have a file called lc3os.obj, this is your assembled code
- Type `load lc3os.obj` to load your assembled code, notice how the registers have changed
- To run your code completely, click ==continue==. If you'd like to go line by line, click ==step==.
