#!/bin/bash

WORKSPACE=$(pwd)
SERV=$WORKSPACE/fusesoc_libraries/serv

# run compliance tests again but dump vcd and rename it
for i in $(find $WORKSPACE/riscv-compliance/work/rv32i/ -name '*.hex'); do
    vcd_target=eval/traces/$(basename -s .hex $i).vcd
    if [ ! -f $vcd_target ]
    then
       $WORKSPACE/build/servant_1.1.0/verilator_tb-verilator/Vservant_sim +timeout=100000000 +signature=bla.signature.output +firmware=$i +vcd=1
       mv trace.vcd $vcd_target
    fi
done

cd eval && pipenv run ./eval-compliance.sh && cd ..
