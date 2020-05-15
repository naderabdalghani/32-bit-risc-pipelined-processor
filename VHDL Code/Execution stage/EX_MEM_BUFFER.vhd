library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY EX_MEM_BUFFER IS
 PORT ( clock, reset,writeEnable : IN STD_LOGIC;
 REG_IN : IN STD_LOGIC_VECTOR (127 downto 0);
 REG_OUT : OUT STD_LOGIC_VECTOR (127 downto 0) );
END EX_MEM_BUFFER; 

ARCHITECTURE behaviour OF EX_MEM_BUFFER IS
 BEGIN
 PROCESS (clock, reset)
 BEGIN
IF (reset = '1' ) THEN
REG_OUT <= (OTHERS=>'0');
ELSIF (rising_edge(clock)and writeEnable='1') THEN
REG_OUT <= REG_IN;
END IF;
END PROCESS;
END behaviour; 
