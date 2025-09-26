# VHDL-MIPS-CPU 
## 📓 Description
This project is a hardware implementation of a MIPS processor written in VHDL. It presents two types of architectures: single-cycle and pipeline. Fundamental CPU concepts are illustrated, including ALU operations, instruction decoding, and memory access.<br><br>

## Instruction set
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
5. WB – Write-Back


