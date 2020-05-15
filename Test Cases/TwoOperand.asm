# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10
in   R1       #add 5 in R1
in   R2       #add 19 in R2
in   R3       #FFFD
in   R4       #F320
IADD R3,R5,2  #R5 = FFFF , flags no change
ADD  R1,R4,R4    #R4= F325 , C-->0, N-->0, Z-->0
SUB  R5,R4,R6    #R4= 0CDA , C-->1, N-->0,Z-->0
AND  R7,R6,R6    #R6= 00000000 , C-->no change, N-->0, Z-->1
OR   R2,R1,R1    #R1=1D  , C--> no change, N-->0, Z--> 0
SHL  R2,2     #R2=64  , C--> 0, N -->0 , Z -->0
SHR  R2,3     #R2=0C  , C -->1, N-->0 , Z-->0
SWAP R2,R5    #R5=0C ,R2=FFFF  ,no change for flags
ADD  R5,R2,R2    #R2= 1000B (C,N,Z= 0)
