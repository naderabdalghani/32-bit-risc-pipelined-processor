library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity hazarddetection is port (
LOAD:out std_logic;
DEC_EX_MemRead:in std_logic;
F_DEC_src1,F_DEC_src2,DEC_EX_dest:in std_logic_vector(2 downto 0) 
);
end hazarddetection ;
architecture Behavioral of hazarddetection is
begin
LOAD <= '1' 
when ( (F_DEC_src1 = DEC_EX_dest or F_DEC_src2 = DEC_EX_dest) and DEC_EX_MemRead = '1' )
else '0';



end Behavioral ;
