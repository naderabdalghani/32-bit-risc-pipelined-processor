library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity hazarddetection is port (
LOAD:out std_logic;
DEC_EX_MemRead:in std_logic;
F_DEC_src1,F_DEC_src2,DEC_EX_dest:in std_logic_vector(2 downto 0) ;
OP_CODE:IN STD_LOGIC_VECTOR(6 DOWNTO 0);
NO_OPERANDS,IGNORE_RSRC2:in std_logic
);
end hazarddetection ;
architecture Behavioral of hazarddetection is
    SIGNAL NO_OPERAND: STD_LOGIC;
begin
    WITH OP_CODE SELECT NO_OPERAND <=
    '1' WHEN "0000000" | "0100111" | "0100101",
    '0' WHEN OTHERS;

LOAD <= '1' 
when ( (
(F_DEC_src1 = DEC_EX_dest  and NO_OPERAND='0')
or (F_DEC_src2 = DEC_EX_dest  and NO_OPERAND='0' and IGNORE_RSRC2='0')
) 
and DEC_EX_MemRead = '1' )
else '0';



end Behavioral ;
