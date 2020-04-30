import re

comment_re = re.compile(r"""^(?P<instr>[^#]*)(?P<comment>#.*)?$""")
no_operand_re = re.compile(r'''^(?P<op>(NOP|RET|RTI))$''', re.IGNORECASE)
one_operand_re = re.compile(r'''^(?P<op>(NOT|INC|DEC|OUT|IN|PUSH|POP|JZ|JMP|CALL))\s+(?P<rd>R[0-7])$''',
                            re.IGNORECASE)
two_operand_re = re.compile(r'''^(?P<op>(SWAP))\s+(?P<rs>R[0-7])+(\s*,\s*)+(?P<rd>R[0-7])$''', re.IGNORECASE)
three_operand_re = re.compile(
    r'''^(?P<op>(ADD|OR|SUB|AND))\s+(?P<rs1>R[0-7])+(\s*,\s*)+(?P<rs2>R[0-7])+(\s*,\s*)+(?P<rd>R[0-7])$''',
    re.IGNORECASE)
three_operand_immediate_re = re.compile(
    r'''^(?P<op>(IADD))\s+(?P<rs1>R[0-7])+(\s*,\s*)+(?P<rd>R[0-7])+(\s*,\s*)+(?P<imm>[0-9a-fA-F]{1,4})$''',
    re.IGNORECASE)
two_operand_immediate_re = re.compile(
    r'''^(?P<op>(SHL|SHR|LDM))\s+(?P<r>R[0-7])+(\s*,\s*)+(?P<imm>[0-9a-fA-F]{1,4})$''', re.IGNORECASE)
two_operand_effective_re = re.compile(
    r'''^(?P<op>(LDD|STD))\s+(?P<r>R[0-7])+(\s*,\s*)+(?P<eff>[0-9a-fA-F]{1,5})$''', re.IGNORECASE)
org_re = re.compile(r'''^(?P<op>(.ORG)\s+(?P<val>[0-9a-fA-F]{1,8}))$''', re.IGNORECASE)
address_value_re = re.compile(r'''^(\s*)([0-9a-fA-F]{1,4})(\s*)$''', re.IGNORECASE)
