#!/bin/bash

WORKSPACE=$(pwd)
SERV=$WORKSPACE/fusesoc_libraries/serv

# install virtual Python environment
pipenv install

# install fusesoc and SERV
if [ ! -d "fusesoc_libraries" ] 
then
pipenv run fusesoc library add fusesoc_cores https://github.com/fusesoc/fusesoc-cores
pipenv run fusesoc library add serv https://github.com/olofk/serv
fi

if ! command -v verilator &> /dev/null
then
    echo "verilator could not be found"
    exit
fi

if ! command -v riscv32-unknown-elf-gcc --version &> /dev/null
then
    echo "RISC-V toolchain could not be found"
    exit
fi


# clone compliance tests
if [ ! -d "riscv-compliance" ] 
then
    git clone https://github.com/riscv/riscv-compliance --branch 1.0
    # build servant core
    pipenv run fusesoc run --target=verilator_tb --build servant --vcd
fi

# build and run compliance tests once, how can I activate vcd dumps here?
cd riscv-compliance && make TARGETDIR=$SERV/riscv-target RISCV_TARGET=serv RISCV_DEVICE=rv32i RISCV_ISA=rv32i RISCV_PREFIX=riscv32-unknown-elf- TARGET_SIM=$WORKSPACE/build/servant_1.1.0/verilator_tb-verilator/Vservant_sim
cd ..

echo "Setup done"
