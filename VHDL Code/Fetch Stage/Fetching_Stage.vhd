LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Fetching_Stage IS
PORT (data_exe_stage, data_data_memory: in std_logic_vector(31 downto 0);               
      wrong_decision, LW_use_case, interrupt1, return_interrupt, RET: in std_logic;     
      PC: out std_logic_vector(31 downto 0);                                            
      --------------------------- PC Circuit I/O done --------------------------------
      instruction_memory: in std_logic_vector(15 downto 0);
      FE_ID: out std_logic_vector(64 downto 0);
      two_fetches: out std_logic;
      -------------------------- Fetching_Circuit done -------------------------------
      WB1_control_unit, WB2_control_unit: in std_logic;
      WB1_ID_EX ,WB2_ID_EX: in std_logic;
      RDST_ID_EX ,RSRC_ID_EX: in std_logic_vector(2 downto 0);
      WB1_EX_MEM ,WB2_EX_MEM: in std_logic;
      RDST_EX_MEM ,RSRC_EX_MEM: in std_logic_vector(2 downto 0);
      WB1_MEM_WB ,WB2_MEM_WB: in std_logic;
      RDST_MEM_WB ,RSRC_MEM_WB: in std_logic_vector(2 downto 0);
      ---------------------- Enable_Dynamic_Prediction done --------------------------
      dynamic_branch_address: in std_logic_vector(4 downto 0);
      jumping_reg: in std_logic_vector(31 downto 0);
      JZ_exe_stage,zero_flag: in std_logic;
      branching_reg: out std_logic_vector(2 downto 0);
      ---------------------- Dynamic_Branch_Prediction done --------------------------
      interrupt_signal,RTI_signal_from_all_stages: in std_logic;
      INT_to_mem_stage: out std_logic;
      ------------------------- Interrupt_Handler done -------------------------------
      CLK,RST: in std_logic);
END ENTITY;

ARCHITECTURE arch OF Fetching_Stage IS
signal PC_Signal: std_logic_vector(31 downto 0); -- PC out
signal branching_reg_signal: std_logic_vector(2 downto 0); -- To get the register of branching
signal two_fetches_before_DFF: std_logic; -- Holding two fetches signal before DFF
signal RDST_IF_ID ,RSRC_IF_ID: std_logic_vector(2 downto 0); -- Holding RDST,RSRC from FE/ID buffer
signal FE_ID_signal: std_logic_vector(64 downto 0); -- FE/ID signal
signal first_16_bits_inst_mem: std_logic_vector(15 downto 0); -- First 16 bit of instruction
signal enable_dynamic_prediction: std_logic; -- Enable of dynamic branch prediction
signal prediction_signal: std_logic; -- Holding prediction signal from dynamic branch prediction
signal prediction_address: std_logic_vector(31 downto 0); -- Address to branch to from dynamic prediction circuit
signal reset_fetching_and_stall_pc: std_logic; -- To stall pc and reset fetching
BEGIN
    PC <= PC_signal;
    FE_ID <= FE_ID_signal;
    RDST_IF_ID <= FE_ID_signal(24 downto 22);
    RSRC_IF_ID <= FE_ID_signal(21 downto 19);
    branching_reg <= branching_reg_signal;

    -- Getting data for dynamic branch prediction test
    with two_fetches_before_DFF select branching_reg_signal <= -- Get RDST in first feth only (as branch is a 16-bit instruction)
    instruction_memory(8 downto 6) when '0',
    branching_reg_signal when others;
    with two_fetches_before_DFF select first_16_bits_inst_mem <= -- Getting the first 16-bit of the instruction
    instruction_memory when '0',
    first_16_bits_inst_mem when others;


    -- Port map PC circuit
    PC_Circuit: entity work.PC_Circuit port map (data_exe_stage, prediction_address, data_data_memory ,CLK, RST, 
    wrong_decision, prediction_signal, reset_fetching_and_stall_pc, LW_use_case, interrupt1, return_interrupt, RET,PC_Signal);

    -- Port map fetching buffer circuit
    Fetching_circuit: entity work.Fetching_Circuit port map (instruction_memory, PC_signal,
    RST, CLK, reset_fetching_and_stall_PC, wrong_decision, LW_use_case, prediction_signal, FE_ID_signal, two_fetches,two_fetches_before_DFF);

    -- Port map Dynamic_Prediction_Enable
    Dynamic_Prediction_Enable: entity work.Dynamic_Branch_Enable port map (branching_reg_signal,WB1_control_unit, WB2_control_unit,
    RDST_IF_ID ,RSRC_IF_ID,WB1_ID_EX ,WB2_ID_EX,RDST_ID_EX ,RSRC_ID_EX,WB1_EX_MEM ,WB2_EX_MEM,RDST_EX_MEM ,RSRC_EX_MEM,WB1_MEM_WB ,WB2_MEM_WB,
    RDST_MEM_WB ,RSRC_MEM_WB,enable_dynamic_prediction);

    -- Port map dynamic branch circuit
    Dynamic_Branch_Prediction: entity work.Dynamic_Branch port map (dynamic_branch_address, jumping_reg, first_16_bits_inst_mem,
    enable_dynamic_prediction, CLK, RST, JZ_exe_stage, zero_flag, prediction_signal, branching_reg_signal, prediction_address);

    -- Port map interrupt handler
    Interrupt_Handler: entity work.INT_Handler port map (interrupt_signal, RTI_signal_from_all_stages, INTERRUPT1, CLK, RST, 
    INT_to_mem_stage, reset_fetching_and_stall_pc);
END ARCHITECTURE;
