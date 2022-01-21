from riscvmodel import code
from riscvmodel.variant import Variant

variant = Variant('RV32IZicsr')

def decode(instr):
    try:
        inst = code.decode(instr, variant)
        op = str(inst).split()[0]
    except Exception:
        op = str(instr)
    return op
