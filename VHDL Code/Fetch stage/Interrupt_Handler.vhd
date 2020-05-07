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
    DFF1: entity work.REG(BEHAVIOURAL) generic map (N=>1) port map (interrupt_signal,'0',CLK,'1',D12);
    DFF2: entity work.REG(BEHAVIOURAL) generic map (N=>1) port map (D12,RST,CLK,'1',D13);
    DFF3: entity work.REG(BEHAVIOURAL) generic map (N=>1) port map (D23,RST,CLK,'1',D34);
    DFF4: entity work.REG(BEHAVIOURAL) generic map (N=>1) port map (D34,RST,CLK,'1',D4);
END ARCHITECTURE;	


