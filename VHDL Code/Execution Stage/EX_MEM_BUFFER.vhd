LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY EX_MEM_BUFFER IS
 PORT ( CLOCK, RESET,WRITEENABLE : IN STD_LOGIC;
 REG_IN : IN STD_LOGIC_VECTOR (112 DOWNTO 0);
 REG_OUT : OUT STD_LOGIC_VECTOR (112 DOWNTO 0)
  );
END EX_MEM_BUFFER; 

ARCHITECTURE BEHAVIOUR OF EX_MEM_BUFFER IS
 BEGIN
 PROCESS (CLOCK, RESET)
 BEGIN
IF (RESET = '1' ) THEN
REG_OUT <= (OTHERS=>'0');
ELSIF (RISING_EDGE(CLOCK)AND WRITEENABLE='1') THEN
REG_OUT <= REG_IN;
END IF;
END PROCESS;
END BEHAVIOUR; 
