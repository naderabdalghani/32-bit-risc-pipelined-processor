LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; 
ENTITY REGFILE IS PORT(
READDATA1,READDATA2:OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
READ_ADDRESS_1,READ_ADDRESS_2:OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
WRITE_DATA1,WRITE_DATA2:IN STD_LOGIC_VECTOR(31 DOWNTO 0);
 OP_GROUP:IN STD_LOGIC_VECTOR(1 DOWNTO 0);
OP_CODE:IN STD_LOGIC_VECTOR(2 DOWNTO 0);
RDST,RSRC1,RSRC2:IN STD_LOGIC_VECTOR(2 DOWNTO 0);
 WRITE_REG1,WRITE_REG2:IN STD_LOGIC_VECTOR(2 DOWNTO 0);
WB1,WB2:IN STD_LOGIC;
CLK,RST:IN STD_LOGIC ;
ADDRESS_3:IN STD_LOGIC_VECTOR(2 DOWNTO 0);
DATA_3:OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
REG0,REG1,REG2,REG3,REG4,REG5,REG6,REG7:OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END REGFILE ;
ARCHITECTURE BEHAVIORAL OF REGFILE IS
TYPE REG_TYPE IS ARRAY (0 TO 7 ) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL REGISTERS: REG_TYPE;
SIGNAL READ_ADDRESS1,READ_ADDRESS2:STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN

 PROCESS(CLK,RST) 
 BEGIN
 IF(RST='1') THEN

		REGISTERS(0) <= "00000000000000000000000000000000";

		REGISTERS(1) <= "00000000000000000000000000000000";

		REGISTERS(2) <= "00000000000000000000000000000000";

		REGISTERS(3) <= "00000000000000000000000000000000";

		REGISTERS(4) <= "00000000000000000000000000000000";

		REGISTERS(5) <= "00000000000000000000000000000000";

		REGISTERS(6) <= "00000000000000000000000000000000";
                
                REGISTERS(7) <= "00000000000000000000000000000000";
		

ELSIF(FALLING_EDGE(CLK)) THEN
IF(WB1 ='1')THEN
REGISTERS(TO_INTEGER(UNSIGNED(WRITE_REG1))) <= WRITE_DATA1;
END IF ;
IF(WB2 ='1') THEN
REGISTERS(TO_INTEGER(UNSIGNED(WRITE_REG2))) <= WRITE_DATA2;
END IF ;
END IF ;
END PROCESS ;


READ_ADDRESS1 <= RSRC1 WHEN (OP_GROUP(0) = '0' AND OP_GROUP(1)='1')
ELSE RDST;

READ_ADDRESS2 <=RDST WHEN (OP_GROUP ="10" AND OP_CODE ="000")-- CASEOF SWAP

ELSE RSRC2;


READDATA1 <= REGISTERS(TO_INTEGER(UNSIGNED(READ_ADDRESS1)));

READDATA2 <= REGISTERS(TO_INTEGER(UNSIGNED(READ_ADDRESS2)));

READ_ADDRESS_1<=READ_ADDRESS1 ;
READ_ADDRESS_2<=READ_ADDRESS2 ;

DATA_3 <= REGISTERS(TO_INTEGER(UNSIGNED(ADDRESS_3)));
REG0 <= REGISTERS(0);
REG1 <= REGISTERS(1);
REG2 <= REGISTERS(2);
REG3 <= REGISTERS(3);
REG4 <= REGISTERS(4);
REG5 <= REGISTERS(5);
REG6 <= REGISTERS(6);
REG7 <= REGISTERS(7);
END BEHAVIORAL ;
