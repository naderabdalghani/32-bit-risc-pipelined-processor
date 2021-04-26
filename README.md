<br />
<p align="center">
  <a href="https://github.com/naderabdalghani/hippohippogo-search-engine">
    <img src="Assets/cpu.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">32-bit Pipelined Processor Implementation</h3>

  <p align="center">
    Implementation of a simple 5-stage 32-bit pipelined RISC processor and its assembler using VHDL and Python
  </p>
</p>

## Table of Contents

* [About the Project](#about-the-project)
  * [Assembler](#assembler)
  * [Common Circuitry](#common-circuitry)
  * [Fetching Stage](#fetching-stage)
  * [Decoding Stage](#decoding-stage)
  * [Execution Stage](#execution-stage)
  * [Memory Stage](#memory-stage)
  * [Write Back Stage](#write-back-stage)
  * [Built With](#built-with)
* [Contributors](#contributors)

## About The Project

The processor in this project has a RISC-like instruction set architecture. There are eight 4-byte general purpose registers, R​0​, till R7. Another two general purpose registers, one works as program counter (PC) and the other works as a stack pointer (SP), and hence, points to the top of the stack. The initial value of SP is (​2^11-1​). The memory address space is ​4 KB of 16-bit ​width and is word addressable. The bus between memory and the processor is 16-bit widths for instruction cache and 32-bit widths for data cache. When an interrupt occurs, the processor finishes the currently fetched instructions (instructions that have already entered the pipeline), then the address of the next instruction (in PC) is saved on top of the stack, and PC is loaded from address [2-3] of the memory (the address takes two words). To return from an interrupt, an RTI instruction loads PC from the top of stack, and the flow of the program resumes from the instruction after the interrupted instruction.

### Assembler

A program written in Python that compiles [sample assembly programs](https://github.com/naderabdalghani/32-bit-risc-pipelined-processor/tree/master/Assembler/test%20cases) and generate the equivalent machine code [hex files](https://github.com/naderabdalghani/32-bit-risc-pipelined-processor/tree/master/Assembler/memory%20files) to be loaded into the CPU memory.

**Running:**

Open a terminal in the `Assembler` directory, then write the following command:

```bash
./assembler.exe "<.asm file relative path>"
```

Example:

```bash
./assembler.exe "test cases/Branch.asm"
```

### Common Circuitry

The [`Common`](https://github.com/naderabdalghani/32-bit-risc-pipelined-processor/tree/master/VHDL%20Code/Common) directory contains components that are used in most if not all the processor stages.

**Data Hazard Detection Unit:**

![data-hazard-detection-unit][data-hazard-detection-unit]

### Fetching Stage

**Dynamic Branch Fetching:**

![dynamic-branch-fetch][dynamic-branch-fetch]

**Register Fetching:**

![fetching-reg-fetch][fetching-reg-fetch]

**Interrupt Fetching:**

![interrupt-fetch][interrupt-fetch]

**PC Fetching:**

![pc-fetch][pc-fetch]

### Decoding Stage

**Control Unit Decoder:**

![control-unit-decode][control-unit-decode]

**Register File Decoder:**

![reg-file-decode][reg-file-decode]

### Execution Stage

**ALU Execution:**

![alu-execute][alu-execute]

**Branch Detection Unit:**

![branch-detection][branch-detection]

### Memory Stage

![sp-memory][sp-memory]

### Write Back Stage

![write-back][write-back]

### Built With

* [ModelSim PE Student Edition](https://www.mentor.com/company/higher_ed/modelsim-student-edition)
* [PyCharm](https://www.jetbrains.com/pycharm/)

[data-hazard-detection-unit]: Assets/data_hazard_detection.png
[dynamic-branch-fetch]: Assets/dynamic_branch_fetch.png
[fetching-reg-fetch]: Assets/fetching_reg_fetch.png
[interrupt-fetch]: Assets/interrupt_fetch.png
[pc-fetch]: Assets/pc_fetch.png
[control-unit-decode]: Assets/control_unit_decode.png
[reg-file-decode]: Assets/reg_file_decode.png
[alu-execute]: Assets/alu_execute.png
[branch-detection]: Assets/branch_detection.png
[sp-memory]: Assets/sp_memory.png
[write-back]: Assets/write_back.png

## Contributors

* [Sarah Ra'fat](https://github.com/sarahRaafat15)
* [Mahmoud Mohamad](https://github.com/mmmacmp)
* [Muhanad Atef](https://github.com/MuhanadAtef)
* [Nader AbdAlGhani](https://github.com/naderabdalghani)
