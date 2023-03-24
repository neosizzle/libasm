# libasm

## Notice 
⚠️⚠️ If you are on macOS, please switch to mac branch and compile from there ⚠️⚠️

## Description
some libC function implementations using NASM x86 Assembly language, fully compatible with C 
as a static library

## Compile
`make` to compile library

`make bonus` to compile library with bonus features

`make clean` to clean objects

`make fclean` to clean objects and remove library

`make re` recompile library

`make test` compiles library and run unit test

`make test_bonus` compiles library with bonus and run unit test


## Writeup

Hey alls, I just finished libasm recently, and I decided to give a more concise writeup towards this project, and assembly as a whole to those who are interested.

**What is assembly**
For the uninitiated, assembly is like any other programming language where you write code to compile a binary program, and you let your machine run said program. The language itself is a low level programming language with a very strong correspondence (almost identical) to the machine instructions based on your CPU architecture. For every line / statement of the code, it will translate to a 1:1 equivalent of a machine instruction (opcode).

Much like in C where you have control over abstracted memory and system resources, you can control over much low level things such as registers and memory locations in assembly.

To run assembly code, you will need an assembler like `nasm`  or `gcc` (yes gcc can also assemble asm files) to convert your hand written asm instructions to a long string binary opcodes (your executable). Unlike compilers which are made to be compatible across different CPU architectures, your asm code might need to be assembled / changed based on your target CPU since the opcodes that they recognize are different across the different processors. 

The two most commonly heard processor types are x86 processors and ARM processors. x86 processors are familiar to many because this is the type of processor used in most [computer and server hardware](https://www.redhat.com/en/topics/cloud-computing/what-is-it-infrastructure) while ARM processors actually do not have a sperate component as a CPU, its processing unit is integrated with the other components of the system and its mainly found in raspberry pis, hard drives, remote controllers and single board computers.

This is important when building assembly code for those processors because they have different computing architectures. ARM uses [RISC](http://en.wikipedia.org/wiki/Reduced_instruction_set_computing)  while x86 adapts [CISC](http://en.wikipedia.org/wiki/Complex_instruction_set_computing). Both of them differs in terms of 
- Instruction complexity 
- Addressing modes
- Internal arithmetic procedures
- [And more](https://www.microcontrollertips.com/risc-vs-cisc-architectures-one-better/) 

The differences above will determine how should we write our assembly, what instructions we can use, how can we access components and etc.

**CPU Architecture**
Since assembly is a language that directly interacts and communicates with a CPU, having knowledge of how a CPU and its other components works would be fundamental  to constructing the logic for an assembly program.

Here are the main parts of your CPU, where your assembly code can manipulate / access
- Registers
- Arithmetic Logic Unit (ALU)
- Control Unit (CU)

The registers are temporary memory which is located close to the CPU chip itself, something like a mini RAM. Unlike the physical RAM on your machine that consists of capacitor cells, the registers are only composed of logic gates hence they cant store that much data compared to a RAM, but they can operate faster than a RAM does.

The information stored on these registers varies across CPU Architectures, roles of different registers include
- Accumulator  - Stores results of computations (return values)
- Instruction register - Stores the address of the current instruction the CU has executed
- Stack pointer - Stores the current address in the RAM to be worked on (RAM is a stack)
- General purpose - Scratch registers where programs can store whatever they like for intermediate processing
- Program counter - Stores the address of the next instruction to be executed

The ALU is responsible for doing arithmetic operations like computations, bitshifting and comparisons. 

The CU is responsible for carrying out the [fetch-decode-execute cycle](https://en.wikipedia.org/wiki/Instruction_cycle) which is a cycle that involves taking instructions from a program -> decodes it into an interpretation that its more understandable to the components -> executes the instructions by telling the components what to do -> repeat. Essentially running all the programs and instructions from the booting up of your computer until the shutdown.

Fun fact: there are two types of computer architectures, [Von Neumann architecture](https://en.wikipedia.org/wiki/Von_Neumann_architecture) and [Harvard architecture](https://en.wikipedia.org/wiki/Harvard_architecture). One big difference bewteen them is the way they store data and instructions. The former stores them both in a single physical address and the latter stores them separately. This looks like a catch from a cost standpoint but in return gives some implications that will be discussed later on.

For this project, you will be using `nasm`  to assemble x86 assembly to target an x86 CPU.

**Memory management**
The two types of memory : stack and heap are familiar with many, they reside on the RAM where they get persistent storage throughout a programs execution. If you are writing assembly, chances are you will need to be using memory to store data because n * 64 / 32 (n is the number of general purpose registers you have) bits of storage space on registers wont be enough for computations involving anything larger than a few bytes.

An empty ram looks looks like this
```
0xffffffffff -> top / end of RAM
...
...
0x0000000000 -> bottom / start of RAM
``` 
When you allocate an item in heap memory, lets say a character 'g', it will grow like so
```
0xffffffffff -> top / end of RAM
...
0x0000000001 -> 'g'
0x0000000000 -> bottom / start of RAM
```

When you allocate an item in stack memory, lets say a character 'a', it will grow like so
```
0xffffffffff -> top / end of RAM
0xfffffffffe -> 'a'
0x0000000001 -> 'g'
0x0000000000 -> bottom / start of RAM
```

Notice how the stack memory grows from *up to down* and vice-versa (*down to up*) for heap. It is designed this way so that the regions wont "bump" into each other. This is important to note when coding in assembly because you will be reading and writing into these addresses explicitly. E.g. if you want to append the character 't' after 'g', you will need to write 't' at address `0x0000000001 + 1` .  If you want to append the character 't' after 'a', you will need to write 't' at address `0xffffffffff - 1`. Both are doing the same operations (writing a character after another character) but since the direction of memory growth is different in nature, the positions where we write our character should also be reflecting that.

Also note that we also respect the size of the data types. When we write a character, we increment the address of last adjacent address by the size of a character, which is 1 (byte). The size of data types can be found [here](https://en.wikipedia.org/wiki/C_data_types)

Structures or `struct`s in C aggregate the storage of multiple data items, of potentially differing data types, into one memory block referenced by a single variable.
The following example declares the data type `struct birthday` which contains the name and birthday of a person.

```C
struct  birthday  {
  char  name[20];
  int  day;
  int  month;
  int  year;
};
```
The memory layout of a structure is a language implementation issue for each platform, with a few restrictions. The memory address of the first member must be the same as the address of structure itself.

If the beginning of the struct is `0xffffffffff` and its allocated on the **STACK**, the starting location of `name` will be `0xffffffffff - 0`. The starting location of `day` will be `0xffffffffff - 0 - sizeof(char *)`. The starting location of `month` will be `0xffffffffff - 0 - sizeof(char *) - sizeof(int)` and so on.

Please make your own conventions / abbreviations for the sake of not confusing yourself.

**Assembly language introduction**
This is not an asm tutorial, but I will share with you some assembly fundamentals to get started. We will be using the [intel syntax](https://web.mit.edu/rhel-doc/3/rhel-as-en-3/i386-syntax.html) for the project

Every line of instruction follows the following syntax in assembly : 
`INSTRUCTION arg1, arg2, ..... ; comment`

`INSTRUCTION` is a predefined instruction from a set of keywords that specify which instruction do you want. Some common instructions include 
- `MOV` - move data from a source to a destination
- `ADD` - adds two values
- `JMP` - jump to a label in your code
- `PUSH` - pushes a value to RAM
- `POP` - gets the value of the top item in RAM

`argN` The arguments for an instruction can consist of register names, arbitrary values and addresses.
The registers in assembly are represented by certain keywords so that we can refer to them in the code. For example, the accumulator in as is represented by the register `rax` , the stack pointer is represented with `rsp`  and the scratch registers are `rdx` and `rcx`(refer cheat sheep for the full list)

The memory address can be dereferenced using `[]`. For example `[rcx]`
 gives me the value pointed by the address in `rcx` .   `[rcx - 1]`
 gives me the value pointed by the address in `rcx - 1` .

Labels are also part of the assembly syntax, and it looks something like this 
```asm
LABELNAME :
	INSTRUCTION arg1, arg2, ..... ; comment
	INSTRUCTION arg1, arg2, ..... ; comment
```
`LABELNAME` provides a reference for instructions like `JMP` to jump to. It points to the first instruction after the declaration of the label. Since instructions are stored in the same medium as data, for our computer to execute a program or function, it just need a valid address to "jump" to.

Here are some example lines of assembly and what they mean.
`MOV 69, rax; Move the value 69 into rax register (accumulator)`
`PUSH rax; push the value at rax to the RAM`
`JMP labelname; jump the execution to a label called labelname`

[Cheat sheet here](https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html)

**Calling conventions**
Much like in our C projects where are are forbidden to *cough* assign on declaration *cough*, the assembly language also has its own calling conventions and safe practices. It does not bring a world-ending impact if they are not obeyed as modern system are strong enough to protect against the mistakes, however if those protections are not in place the results of the mistakes would to catastrophic.

Some of the many conventions include :
- preservation of registry values before return 
- restoration of stack pointer before return

Here is a more detailed list of calling conventions that you can look into, as I have already mentioned the 2 most important ones.
https://en.wikipedia.org/wiki/X86_calling_conventions#List_of_x86_calling_conventions

**Debugging and GDB**
There is no printf in assembly, so if you want to get information about your program during runtime, you will need to use one of many debuggers out there to inspect your program.

The `INT3` instruction is a one-byte-instruction defined for use by debuggers to temporarily replace an _instruction_ in a running program in order to set a code breakpoint, which is still used by modern debuggers till this day.

The debugger I used personally was GDB, because it was mainstream on linux. Here is how you get started with them.

in bash :  `> gdb program_name`
You will then be directed to a `gdb` shell.
`break label_name` -> to add a breakpoint to that label (pausing point)
`layout asm` -> to look at the current executing assembly code
`layout reg` -> to get information on all your registers
`start` -> to start your program in the debugger
`stepi` -> to execute the next instruction in your program
`step` -> to execute your program to the next breakpoint / return.
`x/10x addr` -> to e**x**amine the 10 units of memory in he**x**adecimal format starting with the address at `addr`
`exit` -> to enter

**Read world applications**
Unless you are still writing games for systems with 8-bit CPU chips and microscopic memories (2kB), there isnt any mainstream usage for knowing assembly in this day and age. 

But still, assembly is still used in places where low-level control for memory optimization and performance matters. 

It is used is some solidity contracts to optimize algorithms since computational power is valuable in the blockchain universe and having an optimized algorithm is crucial for decreasing loss due to gas fees.

Perhaps on things like [quantitative development](https://www.glassdoor.com/Career/quantitative-developer-career_KO0,22.htm) where performance differences up to milliseconds can be a matter of seizing a good market trade opportunity or losing it.

It is also used in certain computer security exploits or techniques, like [shellcode injection](https://en.wikipedia.org/wiki/Shellcode) and [reverse engineering](https://en.wikipedia.org/wiki/Reverse_engineering) where the information about a vulnerable program can be seen by translating its binary into assembly.

Since most computers are based on the **Von Neumann Architecture**, executable instructions exists in the same space as data. Therefore the computer wont be able to differentiate between the two, leading to the existence of the shellcode injection exploit.

Below is an example snippet code of a shellcode injection payload.
```
MOV rax, 59
LEA rdi, [rip + binsh]
MOV rsi, 0
MOV rdi, 0
SYSCALL
binsh:
	.string "/bin/sh"
```
The opcodes this code produces is equivalent to `exeve("/bin/sh", 0, 0)`  in C. A bad program which executes from a bad `scanf` or `gets` will execute the shellcode and will launch a shell for the attacker.

Thats all, here are some sources and good reads
https://byjus.com/gate/difference-between-von-neumann-and-harvard-architecture/
https://homepage.cs.uri.edu/faculty/wolfe/book/Readings/Reading04.htm
https://cboard.cprogramming.com/c-programming/114546-way-does-stack-go.html
https://www.quora.com/When-using-assembly-can-you-accidently-corrupt-your-OS-or-break-your-computer

Hope you have fun on the assembly journey.