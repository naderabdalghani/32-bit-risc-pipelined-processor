LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PC_CIRCUIT IS
PORT (DATA_EXE_STAGE, DATA_PREDICTION_CIRCUIT, DATA_DATA_MEMORY : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      CLK, RST, WRONG_DECISION, PREDICTION_SIGNAL, RESET_FETCHING_STALL_PC, LW_USE_CASE, INTERRUPT1, RETURN_INTERRUPT, RET: IN STD_LOGIC;
      PC: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY;

ARCHITECTURE ARCH OF PC_CIRCUIT IS
SIGNAL S,M,L : STD_LOGIC; -- MUXES SELECTORS
SIGNAL PC_D : STD_LOGIC_VECTOR(31 DOWNTO 0); -- DATA TO BE INPUT TO PC
SIGNAL INCREMENTD_PC : STD_LOGIC_VECTOR(31 DOWNTO 0); -- PC AFTER INCREMENT
SIGNAL MUX_12, MUX_23 : STD_LOGIC_VECTOR(31 DOWNTO 0); -- SIGNALS TO CONNECT MUXES
SIGNAL SEL_MUX2,SEL_MUX3 : STD_LOGIC_VECTOR(1 DOWNTO 0); -- MUX2 AND MUX3 SELECTORS
SIGNAL PC_SIGNAL : STD_LOGIC_VECTOR(31 DOWNTO 0); -- PC SIGNAL CONNECTED WITH PC REGISTER
BEGIN
    S <= WRONG_DECISION OR PREDICTION_SIGNAL;
    M <= RESET_FETCHING_STALL_PC OR LW_USE_CASE;
    L <= INTERRUPT1 OR RETURN_INTERRUPT OR RET;
    SEL_MUX2 <= L & S;
    SEL_MUX3 <= RST & M;
    PC <= PC_SIGNAL;
    INCREMENTD_PC <= STD_LOGIC_VECTOR(UNSIGNED(PC_SIGNAL) + 1);

    -- MUX #1
    WITH WRONG_DECISION SELECT MUX_12 <=
    DATA_EXE_STAGE WHEN '1',
    DATA_PREDICTION_CIRCUIT WHEN OTHERS;

    -- MUX #2
    WITH SEL_MUX2 SELECT MUX_23 <=
    DATA_DATA_MEMORY WHEN "10" | "11",
    MUX_12 WHEN "01",
    INCREMENTD_PC WHEN OTHERS;

    -- MUX #3
    WITH SEL_MUX3 SELECT PC_D <=
    DATA_DATA_MEMORY WHEN "10" | "11" | "1U" | "1X",  -- AS SIGNALS AREN'T INITIALIZED AT FIRST (AT FETCHING FIRST INSTRUCTION FROM DATA MEMORY) 
    PC_SIGNAL WHEN "01",
    MUX_23 WHEN OTHERS;

    -- PORT MAP PC REG
    PC_REG: ENTITY WORK.REG(BEHAVIOURAL) GENERIC MAP (N=>32) PORT MAP (PC_D,'0',CLK,'1',PC_SIGNAL);
END ARCHITECTURE;	


