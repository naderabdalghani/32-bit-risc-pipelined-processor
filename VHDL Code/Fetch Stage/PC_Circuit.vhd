LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY PC_Circuit IS
PORT (data_exe_stage, data_prediction_circuit, data_data_memory : in std_logic_vector(31 downto 0);
      CLK, RST, wrong_decision, prediction_signal, reset_fetching_stall_PC, LW_use_case, interrupt1, return_interrupt, RET: in std_logic;
      PC: out std_logic_vector(31 downto 0));
END ENTITY;

ARCHITECTURE arch OF PC_Circuit IS
signal S,M,L : std_logic; -- Muxes selectors
signal PC_D : std_logic_vector(31 downto 0); -- Data to be input to PC
signal incrementd_PC : std_logic_vector(31 downto 0); -- PC after increment
signal mux_12, mux_23 : std_logic_vector(31 downto 0); -- Signals to connect muxes
signal sel_mux2,sel_mux3 : std_logic_vector(1 downto 0); -- Mux2 and Mux3 selectors
signal PC_signal : std_logic_vector(31 downto 0); -- PC signal connected with PC register
BEGIN
    S <= wrong_decision or prediction_signal;
    M <= reset_fetching_stall_PC or LW_use_case;
    L <= interrupt1 or return_interrupt or RET;
    sel_mux2 <= L & S;
    sel_mux3 <= RST & M;
    PC <= PC_signal;
    incrementd_PC <= std_logic_vector(unsigned(PC_signal) + 1);

    -- Mux #1
    with wrong_decision select mux_12 <=
    data_exe_stage when '1',
    data_prediction_circuit when others;

    -- Mux #2
    with sel_mux2 select mux_23 <=
    data_data_memory when "10" | "11",
    mux_12 when "01",
    incrementd_PC when others;

    -- Mux #3
    with sel_mux3 select PC_D <=
    data_data_memory when "10" | "11" | "1U" | "1X",  -- As signals aren't initialized at first (at fetching first instruction from data memory) 
    PC_signal when "01",
    mux_23 when others;

    -- Port map PC reg
    PC_REG: entity work.REG(BEHAVIOURAL) generic map (N=>32) port map (PC_D,'0',CLK,'1',PC_signal);
END ARCHITECTURE;	


