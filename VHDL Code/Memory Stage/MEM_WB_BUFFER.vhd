LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MEM_WB_BUFFER IS
    PORT(
        CLK, RST, WRITE_ENABLE : IN STD_LOGIC;
        REG_IN : IN STD_LOGIC_VECTOR (72 DOWNTO 0);
        REG_OUT : OUT STD_LOGIC_VECTOR (72 DOWNTO 0));
END MEM_WB_BUFFER; 

ARCHITECTURE BEHAVIOURAL OF MEM_WB_BUFFER IS
BEGIN
    PROCESS (CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            REG_OUT <= (OTHERS => '0');
        ELSIF (RISING_EDGE(CLK) AND WRITE_ENABLE = '1') THEN
            REG_OUT <= REG_IN;
        END IF;
    END PROCESS;
END BEHAVIOURAL; 
