library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all; 
entity RegFile is port(
Readdata1,Readdata2:out std_logic_vector(31 downto 0);
Read_address_1,Read_address_2:out std_logic_vector(2 downto 0) ;
WRITE_DATA1,WRITE_DATA2:in std_logic_vector(31 downto 0);
 OP_GROUP:in std_logic_vector(1 downto 0);
OP_CODE:in std_logic_vector(2 downto 0);
Rdst,Rsrc1,Rsrc2:in std_logic_vector(2 downto 0);
 WRITE_REG1,WRITE_REG2:in std_logic_vector(2 downto 0);
WB1,WB2:in std_logic;
Clk,rst:in std_logic ;
address_3:in std_logic_vector(2 downto 0);
data_3:out std_logic_vector(2 downto 0)
);
end RegFile ;
architecture Behavioral of RegFile is
type reg_type is array (0 to 7 ) of std_logic_vector (31 downto 0);
signal Registers: reg_type;
signal READ_ADDRESS1,READ_ADDRESS2:std_logic_vector(2 downto 0);
begin

 process(clk,rst) 
 begin
 if(rst='1') then

		Registers(0) <= "00000000000000000000000000000000";

		Registers(1) <= "00000000000000000000000000000000";

		Registers(2) <= "00000000000000000000000000000000";

		Registers(3) <= "00000000000000000000000000000000";

		Registers(4) <= "00000000000000000000000000000000";

		Registers(5) <= "00000000000000000000000000000000";

		Registers(6) <= "00000000000000000000000000000000";
                
                Registers(7) <= "00000000000000000000000000000000";
		

elsif(rising_edge(clk)) then
if(WB1 ='1')then
Registers(to_integer(unsigned(WRITE_REG1))) <= WRITE_DATA1;
elsif(WB2 ='1') then
Registers(to_integer(unsigned(WRITE_REG2))) <= WRITE_DATA2;
end if ;
end if ;
end process ;


READ_ADDRESS1 <= Rsrc1 when (OP_GROUP(0) = '0' and OP_GROUP(1)='1')
else Rdst;

READ_ADDRESS2 <=Rdst when (OP_GROUP ="10" and OP_CODE ="000")-- caseof swap

else Rsrc2;


Readdata1 <= Registers(to_integer(unsigned(READ_ADDRESS1)));

Readdata2 <= Registers(to_integer(unsigned(READ_ADDRESS2)));

Read_address_1<=READ_ADDRESS1 ;
Read_address_2<=READ_ADDRESS2 ;

data_3 <= address_3;
end Behavioral ;
