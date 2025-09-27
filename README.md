# VHDL-MIPS-CPU 
## 📓 Description
This project is a hardware implementation of a MIPS processor written in VHDL. It presents two types of architectures: single-cycle and pipeline. Fundamental CPU concepts are illustrated, including ALU operations, instruction decoding, and memory access.<br><br>

## Instruction Set
The processor can execute three types of instructions: **`Register`**, **`Immediate`** and **`Jump`**.

<div align="center">
  <img width="700" height="361" alt="image" src="https://github.com/user-attachments/assets/ba79f700-7654-40ba-931c-53ecca839df8" />
</div><br><br>

**`Register-type`** instructions:
* add - Addition
* sub - Subtraction
* sll - Shift Left Logical
* srl - Shift Right Logical
* and - Logical AND
* or - Logical OR
* xor - Logical XOR
* slt - Set on Less Than<br><br>

**`Immediate-type`** instructions:
* addi - Add Immediate
* lw - Load Word
* sw - Store Word
* beq - Branch on Equal
* andi - AND Immediate
* slti - Set on Less Than Immediate<br><br>

**`Jump-type`** instructions:
* j - Jump<br><br>

The execution of an instruction consists of the following five stages:
1. IF – Instruction Fetch
2. ID/OF – Instruction Decode / Operand Fetch
3. EX – Execute
4. MEM – Memory
5. WB – Write-Back<br><br>

## Main Components
The VHDL code for both MIPS implementations is written using a **structural architecture**. Each component corresponds to a stage of instruction execution and models the hardware units used (memories, multiplexers, register files, etc.).

The main elements of the 32-bit MIPS processor datapath are:
* **Program Counter (PC)** – 32-bit register with synchronous load  
* **Instruction Memory (ROM)** – asynchronous read  
* **Register File (RF)**  
* **Data Memory (RAM)**  
* **Sign/Zero Extension Unit (16 → 32 bits)**
  * if control signal `ExtOp = 1` → sign extension  
  * if control signal `ExtOp = 0` → zero extension  
* **Shift-left-2 unit** – aligns jump/branch addresses to multiples of 4 bytes  
* **Arithmetic Logic Unit (ALU)** – 32-bit operands and result  
  * operation specified by the control signal `ALUCtrl`

The Control Unit generates the signals that coordinate the functionality of the datapath components.<br><br>

## Test Program
The ASM test program computes the sum of all elements within the range [X, Y] from an array of N numbers starting at memory address 16. X, Y, and N are read from addresses 0, 4, and 8, and the result is stored at address 12.

To verify program execution on the Nexys A7 board, buttons, LEDs, switches, and 7-segment displays are used. Pressing a button simulates the execution of a single instruction, allowing observation of the resulting changes. Depending on the switches activated, different information is displayed, such as the current and next instruction addresses, the ALU result, or values read from data memory.

The test program is located in the file **`assembly_program.txt`**.

<div align="center">
  <img width="500" height="400" alt="image" src="https://github.com/user-attachments/assets/e50f685a-7a48-4583-8444-118b16c5142f" />
</div><br><br>

## MIPS Single-Cycle
In a single-cycle MIPS processor, all instructions execute in one clock cycle. The cycle time is determined by the instruction with the longest execution time, which is `Load Word` (lw), as it involves ALU address calculation, memory read, and writing back to a register. The overall architecture is shown in the image below. The VHDL code is located in the source file **`mips.vhd`**.

<div align="center">
    <img width="800" height="420" alt="image" src="https://github.com/user-attachments/assets/fcb70f99-a255-4a32-8cca-39fc76a18f18" />
</div><br><br>

## MIPS Pipeline
In the single-cycle implementation, execution is slow because the clock period must handle the longest signal path, which occurs with the **Load Word (LW)** instruction. This delay affects all instructions. A **`pipelined architecture`** reduces the clock period by inserting registers between execution stages. Pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB) store intermediate results for the next stage. This enables up to five instructions to be processed simultaneously, each in a different stage. After passing through the pipeline stages, instructions complete one by one, resulting in an average throughput of **one instruction per cycle** at a **`higher operating frequency`**.

Control signals are transmitted alongside the data through the pipeline registers, from one stage to the next, until they reach the stage where they take effect.

Due to the new architecture, certain components of the project had to be modified (see the source files **`ID_pipeline.vhd`** and **`EX_pipeline.vhd`**). Additionally, pipeline registers were added. The VHDL code is located in the source file **`mips_pipeline.vhd`**.<br><br>

<div align="center">
    <img width="800" height="426" alt="image" src="https://github.com/user-attachments/assets/65459caa-425c-4609-be76-35b2097a2d59" />
</div><br>

To eliminate **structural**, **data**, and **control** **hazards** in the pipelined implementation, a software-based solution was adopted: inserting **NoOp instructions** into the program. **`NoOp (No Operation)`** is a pseudo-instruction that does not affect the processor’s state elements (registers and memories), while the PC register increments normally. It is implemented using the instruction **`SLL $0, $0, 0`**. As a result, the test program was modified. The new program used for testing the pipelined architecture is located in the file **`assembly_program_pipeline.txt`**.  


