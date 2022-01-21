#!/bin/bash

WORKSPACE=$(pwd)
SERV=$WORKSPACE/fusesoc_libraries/serv

# install fusesoc and SERV
if [ ! -d "fusesoc_libraries" ] 
then
fusesoc library add fusesoc_cores https://github.com/fusesoc/fusesoc-cores
fusesoc library add serv https://github.com/olofk/serv
fi

if ! command -v verilator &> /dev/null
then
    echo "verilator could not be found"
    exit
fi

# clone compliance tests
if [ ! -d "riscv-compliance" ] 
then
    git clone https://github.com/riscv/riscv-compliance --branch 1.0
    # build servant core
    fusesoc run --target=verilator_tb --build servant --vcd
    # build and run compliance tests once, how can I activate vcd dumps here?
    cd riscv-compliance && make TARGETDIR=$SERV/riscv-target RISCV_TARGET=serv RISCV_DEVICE=rv32i RISCV_ISA=rv32i RISCV_PREFIX=riscv32-unknown-elf- TARGET_SIM=$WORKSPACE/build/servant_1.1.0/verilator_tb-verilator/Vservant_sim
    cd ..
fi

# run compliance tests again but dump vcd and rename it
for i in $(find $WORKSPACE/riscv-compliance/work/rv32i/ -name '*.hex'); do
    vcd_target=eval/traces/$(basename -s .hex $i).vcd
    if [ ! -f $vcd_target ]
    then
       $WORKSPACE/build/servant_1.1.0/verilator_tb-verilator/Vservant_sim +timeout=100000000 +signature=bla.signature.output +firmware=$i +vcd=1
       mv trace.vcd $vcd_target
    fi
done

cd eval && ./eval-compliance.sh && cd ..
cat serv-cpi.txt
