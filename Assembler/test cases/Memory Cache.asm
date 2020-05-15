# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10 
in R0 #R0 = 118, Instr cache read miss
in R1 #R1 = 18
in R2 #R2 = 2
in R3 #R3 = 30
JMP R1 #jump to 18

.ORG 18 #Loop A
SUB R2,R4,R7 #check if R4 = R2, Instr cache read miss will occur with each loop iteration
JZ R3 #jump to 30 if R4 = R2
CALL R0 #Instr cache read miss for block starting with 118 each time we call. Data cache write miss for the first iteration in loop for block starting with 7F8.
OUT R5
INC R4
JMP R1 #jump to 18


.ORG 30
in R1 #R1 = 38
in R3 #R3 = 50
in R4 #R4 = 0
STD R1,210 #M[210, 211]=38, Data cache write miss, replaced block is dirty
JMP R1 #jump to 38

.ORG 38 #Loop B
SUB R2,R4,R7 #check if R4 = R2, Instr cache read miss will occur for first loop iteration
JZ R3 #jump to 50 if R4 = R2
CALL R0#Instr cache read miss for block starting with 118 for first loop iteration.
LDD R1,210 #R1 = 38, Data cache read miss with each iteration, replaced block is dirty
OUT R5
INC R4
JMP R1 #jump to 38


.ORG 50
STD R6,212 #M[212, 213]=R6

.ORG 118
ADD R4,R4,R6 # R6=R4 * 2
STD R6,312 #M[312, 313]=R6, Data cache write miss (once in loop A, with each iteration in loop b), replaced block is not dirty (first time in B, block will be dirty as a result of STD R1,210
LDM R7,0FF #R7=0FF 
AND R6,R6,R7
LDM R5,1 #R5=1
OR R5,R5,R6
LDD R6,312 #R6=M[312, 313]
ret
