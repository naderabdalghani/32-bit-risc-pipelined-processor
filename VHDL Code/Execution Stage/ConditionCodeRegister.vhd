library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY ConditionCodeRegister IS
 PORT ( clock, reset,writeEnable : IN STD_LOGIC;
 CCRIN : IN STD_LOGIC_VECTOR (3 downto 0);
 CCROUT : OUT STD_LOGIC_VECTOR (3 downto 0) );
END ConditionCodeRegister; 

ARCHITECTURE behaviour OF ConditionCodeRegister IS
 BEGIN
 PROCESS (clock, reset)
 BEGIN
IF (reset = '1') THEN
CCROUT <= (OTHERS=>'0');
ELSIF (rising_edge(clock)and writeEnable='1') THEN
CCROUT <= CCRIN;
END IF;
END PROCESS;
END behaviour; 