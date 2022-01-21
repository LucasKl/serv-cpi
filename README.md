# serv-cpi
This project analyzes the Cycles Per Instruction (CPI) of the [SERV](https://github.com/olofk/serv) RISC-V core by Olof Kindgren. The analysis is performed using the [Waveform Analysis Language (WAL)](https://github.com/ics-jku/wal).

## Measurement
The lifecycle of an instruction in SERV starts when the i_ibus_ack signal rises indicating the arrival of the next instruction from memory. An instruction is assumed to be committed one clock cycle before the next i_ibus_ack rising edge, thus the CPI is calculated by measuring the number of cycles between both events (including the first i_ibus_ack, see figure below).ow).

<img align="left" src="https://svg.wavedrom.com/{signal%3A [%0A%20%20%20 { name%3A 'clk'%2C%0A%09%09wave%3A 'p......|......'}%2C%0A%09{ name%3A 'i_ibus_ack'%2C%0A%09%09wave%3A '0..10..|..10.'%2C%0A%20%20%20%20%20%20%20 node%3A '...a......b'%2C%0A%09%09data%3A '9 9 6 6 9 9 6 6 9 9 '}%2C%0A%20 %09{ name%3A 'i_ibus_rdt'%2C%0A%09%09wave%3A '0..30..|..30.'%2C%0A%09%09data%3A 'inst1 inst2'}%2C%0A%20 %0A]%2C%0A%20 edge%3A ['a~b CPI']%2C%0A%20 config%3A {%0A%20 %09hscale%3A 2%0A%20 }%2C%0A}%0A"/>

## Prerequisites
To run the analysis you must have a rv32i toolchain and Verilator on your path. Additionally, you need a Python installation with version < 3.10 and the `pipenv` package installed.

First, check out the `serv-cpi` repository.
```
git clone https://github.com/LucasKl/serv-cpi.git
cd serv-cpi
```

Now, we can set up the simulation environment by running `setup.sh`. This installs Fusesoc, SERV, and other Python dependencies and downloads and compiles the RISC-V compliance tests.

## Running the Analysis
The analysis is kicked off by running the `run.sh` bash file in the virtual Python environment. The CPI for each RV32I instruction is calculated by analyzing the waveforms generated by the compliance tests. After the analysis is done the results are written into `serv-cpi.txt`.
