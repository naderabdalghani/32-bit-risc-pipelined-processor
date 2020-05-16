library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity forwardunit is port(
--R_src1,R_src2 are from ID/EX buffer 
ForwardA,ForwardB:out std_logic_vector(1 downto 0);
R_src1,R_src2,EX_MEM_rdest,MEM_WB_rdest:in std_logic_vector(2 downto 0);
 EX_MEM_WB1,EX_MEM_WB2,MEM_WB_WB1,MEM_WB_WB2,NO_OPERANDS,IGNORE_RSRC2:in std_logic );

end forwardunit ;



architecture Behavioral of forwardunit is
signal EX_MEM_WB ,MEM_WB_WB:std_logic;
begin 

EX_MEM_WB <=(EX_MEM_WB1 or EX_MEM_WB2);
MEM_WB_WB <=(MEM_WB_WB1 or MEM_WB_WB2);
ForwardA <="01" when (EX_MEM_WB = '1'
and EX_MEM_rdest = R_src1 and NO_OPERANDS='0') else
"10" when (MEM_WB_WB = '1'
and( MEM_WB_rdest = R_src1 and  NO_OPERANDS='0' )
and (EX_MEM_rdest /= R_src1 or EX_MEM_WB = '0')) else
"00" ;

ForwardB <= "01" when (EX_MEM_WB = '1'
and EX_MEM_rdest = R_src2 and NO_OPERANDS='0' and IGNORE_RSRC2='0' )
else "10" when  (MEM_WB_WB= '1'
and (MEM_WB_rdest = R_src2 and NO_OPERANDS='0' and IGNORE_RSRC2='0')
and (EX_MEM_rdest /=  R_src2 or EX_MEM_WB = '0'))else
"00" ;
 
