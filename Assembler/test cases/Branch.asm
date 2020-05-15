# all numbers in hex format
# we always start by reset signal
#if you don't handle hazards add 3 NOPs
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10
in R1     #R1=30
in R2     #R2=50
in R3     #R3=100
in R4     #R4=300
in R6     #R6=FFFFFFFF 
in R7     #R7=FFFFFFFF   
Push R4   #sp=7FC, M[7FE, 7FF]=300
JMP R1 
INC R7	  # this statement shouldn't be executed,
 
#check flag forwarding  
.ORG 30
AND R1,R5,R5   #R5=0 , Z = 1
            #try interrupt here
JZ  R2      #Jump taken, Z = 0
INC R7      #this statement shouldn't be executed

#check on flag updated on jump
.ORG 50
JZ R3      #Jump Not taken

#check destination forwarding
NOT R5     #R5=FFFFFFFF, Z= 0, C--> not change, N=1
INC R5     #R5=0, Z=1, C=1, N=0
in  R6     #R6=200, flag no change
JZ  R6     #jump taken, Z = 0
INC R1   #this statement shouldn't be executed

.ORG 100
ADD R0,R0,R0    #N=0,Z=1,C=0
out R6
rti

#check on load use
.ORG 200
POP R6     #R6=300, SP=7FE
Call R6    #SP=7FC, M[7FF]=half next PC,M[7FE]=other half next PC
          #try interrupt here
INC R6	  #R6=401, this statement shouldn't be executed till call returns, C--> 0, N-->0,Z-->0
NOP
NOP


.ORG 300
Add R3,R6,R6 #R6=400
Add R1,R2,R1 #R1=80, C->0,N=0, Z=0
ret
INC R7           #this should not be executed

.ORG 500
NOP
NOP