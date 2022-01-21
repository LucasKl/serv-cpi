#!/bin/bash

rm -f res1 res2 res3

single_ops="AUIPC LUI 
ADD ADDI SUB AND ANDI OR ORI XOR XORI
ECALL
SLT SLTI SLTU SLTIU
SLL SLLI SRA SRAI SRL SRLI"

(for op in $single_ops; do
    wawk inst.wawk traces/I-$op-01.elf.vcd ${op,,} >> res1
 done) &
p1=$!

branch_ops="JAL JALR BEQ BGE BGEU BLT BLTU BNE"
(for op in $branch_ops; do
    wawk inst.wawk traces/I-MISALIGN_JMP-01.elf.vcd ${op,,} >> res2
 done) &
p2=$!

memory_ops="LB LBU LH LHU LW SB SH SW"
(for op in $memory_ops; do
    wawk inst.wawk traces/I-MISALIGN_LDST-01.elf.vcd ${op,,} >> res3
 done) &
p3=$!

wait $p1
wait $p2
wait $p3

printf "SERV CPI on Compliance Tests\n\n" > result
echo "    Opcode       Avg.        Min        Max" >> result
cat res1 res2 res3 >> ../serv-cpi.txt
rm -f res1 res2 res3
