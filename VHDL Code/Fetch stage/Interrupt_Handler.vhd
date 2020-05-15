LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY INT_Handler IS
PORT (interrupt_signal, RTI_signal_from_all_stages, INTERRUPT1, clk, RST : in std_logic;
      INT_to_mem_stage, reset_fetching_and_stall_pc : out std_logic);
END ENTITY;

ARCHITECTURE arch OF INT_Handler IS
signal D12,D23,D34,D4 : std_logic;
BEGIN
    reset_fetching_and_stall_pc <= D12 or D23 or D34 or D4 or RTI_signal_from_all_stages or INTERRUPT1;
    INT_to_mem_stage <= D4;

    -- Port map DFF
    DFF1: entity work.DFF(BEHAVIOURAL) port map (interrupt_signal,RST,CLK,D12);
    DFF2: entity work.DFF(BEHAVIOURAL) port map (D12,RST,CLK,D23);
    DFF3: entity work.DFF(BEHAVIOURAL) port map (D23,RST,CLK,D34);
    DFF4: entity work.DFF(BEHAVIOURAL) port map (D34,RST,CLK,D4);
END ARCHITECTURE;	


