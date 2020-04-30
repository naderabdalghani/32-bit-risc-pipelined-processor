import sys
from regex import *
from pathlib import Path
from opcodes import opcodes


class AssemblerError(Exception):
    pass


class AssemblerSyntaxError(AssemblerError):
    def __init__(self, line, reason):
        self.line = line
        self.reason = reason

    def __str__(self):
        return "Syntax error on line %d: %s" % (self.line, self.reason)


def assemble_instructions(input_file):
    line_number = 1
    instructions = ["0000000000000000" for _ in range(4)]
    read_reset_address = False
    read_interrupt_address = False
    line = input_file.readline()
    # Set reset and interrupt addresses first
    while (not read_reset_address or not read_interrupt_address) and line != "":
        match = comment_re.match(line)
        if not match:
            raise AssemblerSyntaxError(line_number, "Invalid line: %s" % line)
        line = match.group('instr').strip()  # Get rid of comments
        if line:
            match = org_re.match(line)
            if not match:
                raise AssemblerSyntaxError(line_number, "Missing .ORG instruction(s): %s" % line)
            address = int(match.group('val'), 16)
            line = input_file.readline()
            line_number += 1
            while line != "":
                match = comment_re.match(line)
                if not match:
                    raise AssemblerSyntaxError(line_number, "Invalid line: %s" % line)
                line = match.group('instr').strip()
                if line:
                    match = address_value_re.match(line)
                    if not match:
                        raise AssemblerSyntaxError(line_number, "Missing .ORG instruction address: %s" % line)
                    instructions[address] = str(bin(int(match.string, 16))).lstrip("0b")
                    instructions[address] = "0" * (16 - len(instructions[address])) + instructions[address]
                    if address == 0 or address == 1:
                        read_reset_address = True
                        break
                    if address == 2 or address == 3:
                        read_interrupt_address = True
                        break
                line = input_file.readline()
                line_number += 1
        line = input_file.readline()
        line_number += 1
    else:
        if line == "" and (not read_interrupt_address) or (not read_reset_address):
            raise AssemblerSyntaxError(line_number, "Missing .ORG instruction(s): %s" % line)
    for line in input_file:
        line_number += 1
        match = comment_re.match(line)
        if not match:
            raise AssemblerSyntaxError(line_number, "Invalid line: %s" % line)
        line = match.group('instr').strip()
        if line:
            org_match = org_re.match(line)
            if org_match:
                address = int(org_match.group('val'), 16)
                instructions_count = len(instructions)
                for i in range(address - instructions_count):
                    instructions.append("0000000000000000")
                line_number += 1
                line = input_file.readline()
                match = comment_re.match(line)
                if not match:
                    raise AssemblerSyntaxError(line_number, "Invalid line: %s" % line)
                line = match.group('instr').strip()
            no_operand_match = no_operand_re.match(line)
            one_operand_match = one_operand_re.match(line)
            two_operand_match = two_operand_re.match(line)
            three_operand_match = three_operand_re.match(line)
            three_operand_immediate_match = three_operand_immediate_re.match(line)
            two_operand_immediate_match = two_operand_immediate_re.match(line)
            two_operand_effective_match = two_operand_effective_re.match(line)
            if no_operand_match:
                instruction = opcodes[no_operand_match.group('op').upper()] + "000000000"
            elif one_operand_match:
                rd = str(bin(int(one_operand_match.group('rd')[1]))).lstrip("0b")
                rd = "0" * (3 - len(rd)) + rd
                instruction = opcodes[one_operand_match.group('op').upper()] + rd + "000000"
            elif two_operand_match:
                rd = str(bin(int(two_operand_match.group('rd')[1]))).lstrip("0b")
                rs = str(bin(int(two_operand_match.group('rs')[1]))).lstrip("0b")
                rd = "0" * (3 - len(rd)) + rd
                rs = "0" * (3 - len(rs)) + rs
                instruction = opcodes[two_operand_match.group('op').upper()] + rd + rs + "000"
            elif three_operand_match:
                rd = str(bin(int(three_operand_match.group('rd')[1]))).lstrip("0b")
                rs1 = str(bin(int(three_operand_match.group('rs1')[1]))).lstrip("0b")
                rs2 = str(bin(int(three_operand_match.group('rs2')[1]))).lstrip("0b")
                rd = "0" * (3 - len(rd)) + rd
                rs1 = "0" * (3 - len(rs1)) + rs1
                rs2 = "0" * (3 - len(rs2)) + rs2
                instruction = opcodes[three_operand_match.group('op').upper()] + rd + rs1 + rs2
            elif three_operand_immediate_match:
                rd = str(bin(int(three_operand_immediate_match.group('rd')[1]))).lstrip("0b")
                rs1 = str(bin(int(three_operand_immediate_match.group('rs1')[1]))).lstrip("0b")
                imm = str(bin(int(three_operand_immediate_match.group('imm'), 16))).lstrip("0b")
                rd = "0" * (3 - len(rd)) + rd
                rs1 = "0" * (3 - len(rs1)) + rs1
                imm = "0" * (16 - len(imm)) + imm
                instruction = opcodes[three_operand_immediate_match.group('op').upper()] + rd + rs1 + "000"
                instructions.append(instruction)
                instruction = imm
            elif two_operand_immediate_match:
                r = str(bin(int(two_operand_immediate_match.group('r')[1]))).lstrip("0b")
                imm = str(bin(int(two_operand_immediate_match.group('imm'), 16))).lstrip("0b")
                r = "0" * (3 - len(r)) + r
                imm = "0" * (16 - len(imm)) + imm
                if two_operand_immediate_match.group('op').upper() == "LDM":
                    instruction = opcodes[two_operand_immediate_match.group('op').upper()] + r + "000000"
                else:
                    instruction = opcodes[two_operand_immediate_match.group('op').upper()] + "000" + r + "000"
                instructions.append(instruction)
                instruction = imm
            elif two_operand_effective_match:
                r = str(bin(int(two_operand_effective_match.group('r')[1]))).lstrip("0b")
                eff = str(bin(int(two_operand_effective_match.group('eff'), 16))).lstrip("0b")
                r = "0" * (3 - len(r)) + r
                eff = "0" * (20 - len(eff)) + eff
                eff_msp = eff[0:16]
                eff_lsp = eff[16:20]
                instruction = opcodes[two_operand_effective_match.group('op').upper()] + r + "00" + eff_lsp
                instructions.append(instruction)
                instruction = eff_msp
            else:
                raise AssemblerSyntaxError(line_number, "Invalid line: %s" % line)
            instructions.append(instruction)
    return instructions


def write_instructions(instructions, output_file):
    for instruction in instructions:
        output_file.write(instruction + "\n")


def main(file_name):

    ########################## READ & ASSEMBLE INPUT FILE  ###########################

    try:
        input_file = open(file_name)
        instructions = assemble_instructions(input_file)
        input_file.close()
    except IOError:
        sys.stderr.write('ERROR: Unable to open input file "' + file_name + '"\n')
        sys.exit(1)

    ############################## WRITE TO OUTPUT FILE ##############################

    output_file_name = Path(file_name).stem + ".out"
    try:
        output_file = open(output_file_name, 'w')
        write_instructions(instructions, output_file)
        output_file.close()
    except IOError:
        sys.stderr.write('ERROR: Unable to write to output file "' + output_file_name + '"\n')
        sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) > 2:
        sys.stderr.write('ERROR: Too many input arguments\n')
        sys.exit(1)
    elif len(sys.argv) < 2:
        sys.stderr.write('ERROR: Please enter the input file name as an input argument\n')
        sys.exit(1)
    main(sys.argv[1])
    print("SUCCESS: Assembly finished...")
    sys.exit()
