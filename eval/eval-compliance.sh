#!/bin/bash

echo "Start analyzing CPI"

printf "SERV CPI on Compliance Tests\n\n" > ../serv-cpi.txt
echo "    Opcode       Avg.        Min        Max" >> ../serv-cpi.txt

single_ops="AUIPC LUI 
ADD ADDI SUB AND ANDI OR ORI XOR XORI
ECALL
SLT SLTI SLTU SLTIU
SLL SLLI SRA SRAI SRL SRLI"

for op in $single_ops; do
    printf "."
    wawk inst.wawk traces/I-$op-01.elf.vcd ${op,,} >> ../serv-cpi.txt
done
exit
branch_ops="JAL JALR BEQ BGE BGEU BLT BLTU BNE"
for op in $branch_ops; do
    printf "."    
    wawk inst.wawk traces/I-MISALIGN_JMP-01.elf.vcd ${op,,} >> ../serv-cpi.txt
done

memory_ops="LB LBU LH LHU LW SB SH SW"
for op in $memory_ops; do
    printf "."    
    wawk inst.wawk traces/I-MISALIGN_LDST-01.elf.vcd ${op,,} >> ../serv-cpi.txt
done
