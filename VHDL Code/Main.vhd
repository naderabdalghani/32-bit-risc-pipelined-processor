library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Main is
    Port (

    RST,CLK,INT : IN  STD_LOGIC ;
    IN_PORT : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
    R0,R1,R2,R3,R4,R5,R6,R7,PC,SP,OUT_PORT : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0) ;
    FLAGREG : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end Main;

ARCHITECTURE DATAFLOW OF MAIN IS 
-------------------------------------------------------------------------------------------
--------------------------- BUFFERS OUTPUT SIGNALS ----------------------------------------
-------------------------------------------------------------------------------------------
SIGNAL FETCHING_DECODE_OUTPUT :STD_LOGIC_VECTOR(64 DOWNTO 0) ;
SIGNAL DECODE_EXECUTION_OUTPUT :STD_LOGIC_VECTOR(129 DOWNTO 0) ;
SIGNAL EXECUTION_MEMORY_OUTPUT :STD_LOGIC_VECTOR(112 DOWNTO 0) ;
SIGNAL MEMORY_WRITEBACK_OUTPUT :STD_LOGIC_VECTOR(72 DOWNTO 0) ;
-------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------
--------------------------- FETCHING STAGE SIGNALS ----------------------------------------
-------------------------------------------------------------------------------------------
SIGNAL DATA_EXE_STAGE, DATA_DATA_MEMORY:   STD_LOGIC_VECTOR(31 DOWNTO 0);               
SIGNAL WRONG_DECISION, LW_USE_CASE, INTERRUPT1, RETURN_INTERRUPT, RET:   STD_LOGIC;     
SIGNAL PC_FETCH:    STD_LOGIC_VECTOR(31 DOWNTO 0);                                            
      --------------------------- PC CIRCUIT I/O DONE --------------------------------
SIGNAL INSTRUCTION_MEMORY:   STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL FE_ID:    STD_LOGIC_VECTOR(64 DOWNTO 0);
SIGNAL TWO_FETCHES:    STD_LOGIC;
      -------------------------- FETCHING_CIRCUIT DONE -------------------------------
SIGNAL WB1_CONTROL_UNIT, WB2_CONTROL_UNIT:   STD_LOGIC;
SIGNAL WB1_ID_EX ,WB2_ID_EX:   STD_LOGIC;
SIGNAL RDST_ID_EX ,RSRC_ID_EX:   STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL WB1_EX_MEM ,WB2_EX_MEM:   STD_LOGIC;
SIGNAL RDST_EX_MEM ,RSRC_EX_MEM:   STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL WB1_MEM_WB ,WB2_MEM_WB:   STD_LOGIC;
SIGNAL RDST_MEM_WB ,RSRC_MEM_WB:   STD_LOGIC_VECTOR(2 DOWNTO 0);
---------------------- ENABLE_DYNAMIC_PREDICTION DONE --------------------------
SIGNAL DYNAMIC_BRANCH_ADDRESS:   STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL JUMPING_REG:   STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL JZ_EXE_STAGE,ZERO_FLAG:   STD_LOGIC;
SIGNAL BRANCHING_REG:    STD_LOGIC_VECTOR(2 DOWNTO 0);
---------------------- DYNAMIC_BRANCH_PREDICTION DONE --------------------------
SIGNAL INTERRUPT_SIGNAL,RTI_SIGNAL_FROM_ALL_STAGES:   STD_LOGIC;
SIGNAL INT_TO_MEM_STAGE:    STD_LOGIC;
------------------------- INTERRUPT_HANDLER DONE -------------------------------
-------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------
--------------------------- DECODING STAGE SIGNALS ----------------------------------------
-------------------------------------------------------------------------------------------
SIGNAL PredictionSignal :  std_logic;
SIGNAL Dec_output: std_logic_vector(129 downto 0);
SIGNAL PC_DEC: std_logic_vector(31 downto 0);
SIGNAL WRITE_REG1,WRITE_REG2: std_logic_vector(2 downto 0);
SIGNAL ForwardA,ForwardB: std_logic_vector(1 downto 0);
SIGNAL LOAD: std_logic ;
SIGNAL WRITE_DATA1,WRITE_DATA2: std_logic_vector(31 downto 0);
SIGNAL Instruction: std_logic_vector(31 downto 0);
SIGNAL EX_MEM_rdest,MEM_WB_rdest: std_logic_vector(2 downto 0);
SIGNAL EX_MEM_WB1,EX_MEM_WB2,MEM_WB_WB1,MEM_WB_WB2: std_logic ;
SIGNAL TWO_FETCHES_FROM_FETCHING: std_logic ;
SIGNAL address_3: std_logic_vector(2 downto 0);
SIGNAL data_3: std_logic_vector(31 downto 0);
SIGNAL WB_1,WB_2: std_logic ;
-------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------
--------------------------- EXECUTION STAGE SIGNALS ----------------------------------------
-------------------------------------------------------------------------------------------
SIGNAL ID_EX     :   STD_LOGIC_VECTOR(129 downto 0); 
SIGNAL EX_MEM_in     :   STD_LOGIC_VECTOR(31 downto 0); 
SIGNAL MEM_WB     :   STD_LOGIC_VECTOR(31 downto 0); 
SIGNAL SelForwardingUnit1  :   STD_LOGIC_VECTOR(1 downto 0); 
SIGNAL SelForwardingUnit2  :   STD_LOGIC_VECTOR(1 downto 0); 
SIGNAL RTIfromWB :  std_logic ;
SIGNAL CCRfromWB :  STD_LOGIC_VECTOR(3 downto 0);
SIGNAL CCR_out :  STD_LOGIC_VECTOR(3 downto 0);
SIGNAL wrongDecision :  STD_LOGIC ;
SIGNAL From_execution_stage :  STD_LOGIC_VECTOR (31 downto 0);
SIGNAL EX_MEM_out     :   STD_LOGIC_VECTOR(112 downto 0);
-------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------
--------------------------- MEMORY STAGE SIGNALS ----------------------------------------
-------------------------------------------------------------------------------------------
  -------------------------------- INPUT --------------------------------
SIGNAL MEM_WB_IN :  STD_LOGIC_VECTOR(111 DOWNTO 0);
SIGNAL INT_MEM :  STD_LOGIC;
SIGNAL INSTRUCTION_MEMORY_WR :  STD_LOGIC;
SIGNAL CURRENT_PC :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL FLAG_REG_IN :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL INSTRUCTION_MEMORY_INPUT :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL INSTRUCTION_MEMORY_ADDRESS :  STD_LOGIC_VECTOR(31 DOWNTO 0);
 -------------------------------- OUTPUT -------------------------------
SIGNAL DATA_MEMORY_OUTPUT :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL INSTRUCTION_MEMORY_OUTPUT :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL INTERRUPT_1 :  STD_LOGIC;
SIGNAL RETURN_INT :  STD_LOGIC;
SIGNAL MEM_WB_OUT :  STD_LOGIC_VECTOR(72 DOWNTO 0);
-------------------------------------------------------------------------------------------
SIGNAL load_use_case :  STD_LOGIC;
SIGNAL load_FROM_DFLIPFLOP :  STD_LOGIC;
BEGIN 


-------------------------------------------------------------------------------------------
--------------------------- SETTING FETCHING SIGNALS --------------------------------------
-------------------------------------------------------------------------------------------
DATA_EXE_STAGE<=From_execution_stage;
DATA_DATA_MEMORY<=DATA_MEMORY_OUTPUT;
WRONG_DECISION<=wrongDecision; 
LW_USE_CASE<=LOAD ;
INTERRUPT1<=INTERRUPT_1;
RETURN_INTERRUPT<=RETURN_INT; 
RET<=EX_MEM_out(112);
INSTRUCTION_MEMORY<=INSTRUCTION_MEMORY_OUTPUT;
WB1_CONTROL_UNIT<=WB_1;
WB2_CONTROL_UNIT<=WB_2;
WB1_ID_EX<=Dec_output(116);
WB2_ID_EX<=Dec_output(115);
RDST_ID_EX<=Dec_output(5 downto 3);
RSRC_ID_EX<=Dec_output(2 downto 0);
WB1_EX_MEM <=EX_MEM_out(105);
WB2_EX_MEM<=EX_MEM_out(104);
RDST_EX_MEM <=EX_MEM_out(5 downto 3);
RSRC_EX_MEM<=EX_MEM_out(2 downto 0);
WB1_MEM_WB <=MEM_WB_OUT(0);
WB2_MEM_WB<=MEM_WB_OUT(1);
RDST_MEM_WB <=MEM_WB_OUT(69 DOWNTO 67);
RSRC_MEM_WB<=MEM_WB_OUT(72 DOWNTO 70);
DYNAMIC_BRANCH_ADDRESS<=EX_MEM_out(74 downto 70);
JUMPING_REG<=data_3;
JZ_EXE_STAGE<=Dec_output(123);
ZERO_FLAG<=CCR_OUT(0);
INTERRUPT_SIGNAL<=INT;
RTI_SIGNAL_FROM_ALL_STAGES<=EX_MEM_out(102) OR Dec_output(111) OR MEM_WB_OUT(2) ; 
-------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------
--------------------------- SETTING DECODING SIGNALS --------------------------------------
-------------------------------------------------------------------------------------------
PC<= PC_FETCH;
PredictionSignal <=FE_ID(64);
PC_DEC<=FE_ID(63 DOWNTO 32);
WRITE_REG1<=MEM_WB_OUT(69 DOWNTO 67);
WRITE_REG2<=MEM_WB_OUT(72 DOWNTO 70);
WRITE_DATA1<=MEM_WB_OUT(34 DOWNTO 3);
WRITE_DATA2<=MEM_WB_OUT(66 DOWNTO 35);
Instruction<=FE_ID(31 DOWNTO 0);
EX_MEM_rdest<=EX_MEM_out(5 downto 3);
MEM_WB_rdest<=MEM_WB_OUT(69 DOWNTO 67);
EX_MEM_WB1<=EX_MEM_out(105);
EX_MEM_WB2<=EX_MEM_out(104);
MEM_WB_WB1<=MEM_WB_OUT(0);
MEM_WB_WB2<=MEM_WB_OUT(1);
TWO_FETCHES_FROM_FETCHING<= TWO_FETCHES;
address_3<=BRANCHING_REG;
-------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------
--------------------------- SETTING EXECUTION SIGNALS -------------------------------------
-------------------------------------------------------------------------------------------
ID_EX <=Dec_output; 
EX_MEM_IN <=EX_MEM_out(101 downto 70); 
MEM_WB <=MEM_WB_OUT(34 DOWNTO 3); 
SELFORWARDINGUNIT1 <=ForwardA; 
SELFORWARDINGUNIT2  <=ForwardB; 
RTIFROMWB <=MEM_WB_OUT(2) ;
CCRFROMWB <=MEM_WB_IN(6 DOWNTO 3);
-------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------
--------------------------- SETTING MEMORY SIGNALS ----------------------------------------
-------------------------------------------------------------------------------------------
MEM_WB_IN <=EX_MEM_out(111 downto 0);
INT_MEM <=INT_TO_MEM_STAGE;
INSTRUCTION_MEMORY_WR <='0';
CURRENT_PC <=PC_FETCH;
FLAG_REG_IN <=CCR_OUT;
INSTRUCTION_MEMORY_INPUT <= (OTHERS=>'0');
INSTRUCTION_MEMORY_ADDRESS <=PC_FETCH;
-------------------------------------------------------------------------------------------

Load_use_case<=NOT(load_FROM_DFLIPFLOP);

-------------------------------------------------------------------------------------------
--------------------------- PORT MAPPING STAGES -------------------------------------------
-------------------------------------------------------------------------------------------
U1 : ENTITY WORK.FETCHING_STAGE   PORT MAP ( DATA_EXE_STAGE, DATA_DATA_MEMORY               
 ,WRONG_DECISION, LW_USE_CASE, INTERRUPT1, RETURN_INTERRUPT,RET     
 ,PC_FETCH                                           
 ,INSTRUCTION_MEMORY
 ,FE_ID    
 ,TWO_FETCHES
 ,WB1_CONTROL_UNIT, WB2_CONTROL_UNIT
 ,WB1_ID_EX ,WB2_ID_EX
 ,RDST_ID_EX ,RSRC_ID_EX   
 ,WB1_EX_MEM ,WB2_EX_MEM
 ,RDST_EX_MEM ,RSRC_EX_MEM   
 ,WB1_MEM_WB ,WB2_MEM_WB
 ,RDST_MEM_WB ,RSRC_MEM_WB  
 ,DYNAMIC_BRANCH_ADDRESS
 ,JUMPING_REG
 ,JZ_EXE_STAGE,ZERO_FLAG
 ,BRANCHING_REG    
 ,INTERRUPT_SIGNAL,RTI_SIGNAL_FROM_ALL_STAGES
 ,INT_TO_MEM_STAGE,CLK,RST);


 U2 : ENTITY WORK.Decodingmain   PORT MAP ( PredictionSignal,
 Dec_output,
 PC_DEC,
 WRITE_REG1,WRITE_REG2,
 ForwardA,ForwardB,
 LOAD,
 WRITE_DATA1,WRITE_DATA2,
 Clk,Rst,
 Instruction,
 EX_MEM_rdest,MEM_WB_rdest,
 EX_MEM_WB1,EX_MEM_WB2,MEM_WB_WB1,MEM_WB_WB2,TWO_FETCHES_FROM_FETCHING,address_3,data_3,R0,R1,R2,R3,R4,R5,R6,R7,WB_1,WB_2,Load_use_case);



U3 : ENTITY WORK.ExecutionStage   PORT MAP (ID_EX, 
EX_MEM_in, 
MEM_WB, 
RST,CLK,
SelForwardingUnit1, 
SelForwardingUnit2, 
RTIfromWB,
CCRfromWB,
CCR_out,
wrongDecision,
From_execution_stage,
EX_MEM_out,Load_use_case);



U4 : ENTITY WORK.MEMORY_STAGE   PORT MAP (CLK,RST, MEM_WB_IN ,
 INT,
 INSTRUCTION_MEMORY_WR,
 CURRENT_PC,
 IN_PORT,
 FLAG_REG_IN,
 INSTRUCTION_MEMORY_INPUT,
 INSTRUCTION_MEMORY_ADDRESS,
 DATA_MEMORY_OUTPUT,
 INSTRUCTION_MEMORY_OUTPUT,
 OUT_PORT,
 INTERRUPT_1,
 RETURN_INT,
 MEM_WB_OUT,Load_use_case);

 U5 : ENTITY WORK.DFF PORT MAP (LOAD,RST,CLK,load_FROM_DFLIPFLOP);
-------------------------------------------------------------------------------------------

END DATAFLOW;