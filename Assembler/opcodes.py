opcodes = {
    # ONE-OPERAND
    'NOP': '0000000',
    'NOT': '0000001',
    'INC': '0000010',
    'DEC': '0000011',
    'OUT': '0000100',
    'IN': '0000101',
    # BRANCHING
    'JZ': '0100000',
    'JMP': '0100001',
    'CALL': '0100010',
    'RET': '0100111',
    'RTI': '0100101',
    # TWO-OPERAND REGISTER
    'SWAP': '1000000',
    'ADD': '1000001',
    'OR': '1000010',
    'SUB': '1000011',
    'AND': '1000100',
    # TWO-OPERAND IMMEDIATE VALUE
    'IADD': '1001101',
    'SHL': '1001110',
    'SHR': '1001111',
    # MEMORY REGISTER
    'PUSH': '1100000',
    'POP': '1100001',
    # MEMORY IMMEDIATE VALUE
    'LDM': '1101010',
    'LDD': '1110101',
    'STD': '1110110'
}
