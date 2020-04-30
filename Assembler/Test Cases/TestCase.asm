# all numbers in hex format
# we always start by reset signal
# this is a commented line
.ORG 0  # this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  # this is the interrupt address
100

.ORG 10
NOP              # NO OPERATION   0000000XXXXXXXXX
INC R2           # INCREMENT R2   0000010010XXXXXX
# DEC    R3      # DECREMENT R3   0000011011XXXXXX
JMP      R5      # JUMP R5        0100001101XXXXXX
# NOT R3         # NOT R3
# CALL R7        # CALL R7
# RET            # RETURN
SWAP R1,R4       # SWAP R1,R4     1000000100001XXX
ADD R1,R3,R2     # R2= R1+R3      1000001010001011
# AND R2,R7,R5   # R5=R2 AND R7
IADD R1,R2,5     # R2=R1+5        1001101010001XXX
#                                 0000000000000101
SHL R6,5         # SHL R6,5       1001110XXX110XXX
#                                 0000000000000101
PUSH R4          # PUSH R4        1100000010XXXXXX
# POP R4         
LDM R1,69        # LDM            1101010001XXXXXX
#                                 0000000001101001 
LDD R5,555       #                1110101101XX0101
#                                 0000000001010101
