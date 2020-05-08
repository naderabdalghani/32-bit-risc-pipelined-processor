LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Fetching_Circuit IS
PORT (instruction_memory: std_logic_vector(15 downto 0);
      PC: std_logic_vector(31 downto 0);
      RST, CLK, reset_fetching_and_stall_PC, reset_signal_from_execution_circuit_branch_detection, hazard_detection_LW, prediction_signal: in std_logic;
      FE_ID: out std_logic_vector(64 downto 0);
      two_fetches: out std_logic);
END ENTITY;

ARCHITECTURE arch OF Fetching_Circuit IS
signal reset_signal: std_logic; -- To reset fetching register
signal tri_state_enable: std_logic; -- Enables tri state to choose if it was the first fetch or the second one
signal TFF_input_signal,TFF_output_signal: std_logic; -- To connect DFF with inverter then connect to and gate
signal fetch_reg_31_16,fetch_reg_15_0: std_logic_vector(15 downto 0); -- For first and second fetch from instruction memory
signal fetch_reg_D: std_logic_vector(64 downto 0); -- Input to fetch reg
signal fetch_reg_Q: std_logic_vector(64 downto 0); -- Output of fetch reg
signal two_fetches_signal_before_DFF: std_logic; -- Two fetches before DFF
signal two_fetches_signal_after_DFF: std_logic; -- Two fetches after DFF
signal if_de_write_enable: std_logic; -- Write enable for IF/DE
signal TFF_reset: std_logic; -- To reset TFF
BEGIN
    reset_signal <= RST or reset_signal_from_execution_circuit_branch_detection or reset_fetching_and_stall_PC;
    fetch_reg_D <= prediction_signal & PC & fetch_reg_31_16 & fetch_reg_15_0;
    two_fetches_signal_before_DFF <= TFF_input_signal and (not TFF_output_signal);
    if_de_write_enable <= not hazard_detection_LW;
    TFF_input_signal <= fetch_reg_Q(29) or fetch_reg_Q(28);
    FE_ID <= fetch_reg_Q;
    two_fetches <= two_fetches_signal_after_DFF;
    TFF_reset <= RST or two_fetches_signal_after_DFF;
    
    -- Fetching first instruction
    with two_fetches_signal_before_DFF select fetch_reg_31_16 <=
    instruction_memory when '0',
    fetch_reg_31_16 when others;

    -- Fetching second instruction
    with two_fetches_signal_before_DFF select fetch_reg_15_0 <=
    instruction_memory when '1',
    fetch_reg_15_0 when others;

    -- Port map FE/ID buffer
    FE_ID_REG: entity work.REG(BEHAVIOURAL) generic map (N=>65) port map (D=>fetch_reg_D, RST=>reset_signal, CLK=>CLK, WR_ENABLE=> if_de_write_enable, Q=>fetch_reg_Q);
    -- Port map DFF
    DFF: entity work.DFF(BEHAVIOURAL) port map (two_fetches_signal_before_DFF,RST,CLK,two_fetches_signal_after_DFF);
    -- Port map DFF as TFF
    TFF: entity work.DFF(BEHAVIOURAL) port map (TFF_input_signal,TFF_reset,CLK,TFF_output_signal);
END ARCHITECTURE;