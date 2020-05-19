library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all; 
entity Decodingmain is port(

PredictionSignal :in  std_logic;
Dec_output:inout std_logic_vector(131 downto 0);

PC:in std_logic_vector(31 downto 0);
WRITE_REG1,WRITE_REG2:in std_logic_vector(2 downto 0);
ForwardA,ForwardB:out std_logic_vector(1 downto 0);
LOAD:out std_logic ;
WRITE_DATA1,WRITE_DATA2:in std_logic_vector(31 downto 0);
Clk,Rst:in std_logic ;
Instruction:in std_logic_vector(31 downto 0);
EX_MEM_rdest,EX_MEM_rdest2,MEM_WB_rdest,MEM_WB_rdest2:in std_logic_vector(2 downto 0);
EX_MEM_WB1,EX_MEM_WB2,MEM_WB_WB1,MEM_WB_WB2:in std_logic;
TWO_FETCHES_FROM_FETCHING:in std_logic ;
address_3:in std_logic_vector(2 downto 0);
data_3:out std_logic_vector(31 downto 0);
REG0,REG1,REG2,REG3,REG4,REG5,REG6,REG7:out std_logic_vector(31 downto 0);
WB_1,WB_2:out std_logic ;
BufferWriteEnable : IN STD_LOGIC;
FORWARD_A_SEL,FORWARD_B_SEL: OUT STD_LOGIC
);
end Decodingmain;


architecture toplevel_arch of Decodingmain is
component RegFile is port(
Readdata1,Readdata2:out std_logic_vector(31 downto 0);
Read_address_1,Read_address_2:out std_logic_vector(2 downto 0) ;
WRITE_DATA1,WRITE_DATA2:in std_logic_vector(31 downto 0);
 OP_GROUP:in std_logic_vector(1 downto 0);
OP_CODE:in std_logic_vector(2 downto 0);
Rdst,Rsrc1,Rsrc2:in std_logic_vector(2 downto 0);
 WRITE_REG1,WRITE_REG2:in std_logic_vector(2 downto 0);
WB1,WB2:in std_logic;
Clk,rst:in std_logic ;
address_3:in std_logic_vector(2 downto 0);
data_3:out std_logic_vector(31 downto 0);
REG0,REG1,REG2,REG3,REG4,REG5,REG6,REG7:out std_logic_vector(31 downto 0)


);
end component ;
component controlUnit is port (
Instruction:in std_logic_vector(6 downto 0);
 ALU_SELECTORS:out std_logic_vector(3 downto 0);
 TWO_FETCHES,OP_GROUP:out std_logic_vector(1 downto 0);
 BRANCH,MR,MW,P_IN,P_OUT,SP_INC,SP_DEC,WB1,WB2,CALL,RET,
ALU_ENABLE,RTI,NO_OPERANDS,IGNORE_RSRC2:out std_logic;
BufferWriteEnable : in  std_logic;
TWO_FETCHES_FROM_FETCHING:in std_logic ) ;
end component ;

component forwardunit is port(
--R_src1,R_src2 are from ID/EX buffer 
ForwardA,ForwardB:out std_logic_vector(1 downto 0);
FORWARD_A_SEL,FORWARD_B_SEL: OUT STD_LOGIC;
R_src1,R_src2,EX_MEM_rdest,EX_MEM_rdest2,MEM_WB_rdest,MEM_WB_rdest2:in std_logic_vector(2 downto 0);
 EX_MEM_WB1,EX_MEM_WB2,MEM_WB_WB1,MEM_WB_WB2,NO_OPERANDS,IGNORE_RSRC2:in std_logic );

end component ;

component hazarddetection is port (
LOAD:out std_logic;
DEC_EX_MemRead:in std_logic;
F_DEC_src1,F_DEC_src2,DEC_EX_dest:in std_logic_vector(2 downto 0) ;
OP_CODE: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
NO_OPERANDS,IGNORE_RSRC2:in std_logic
);
end component ;

component DEC_EX_buffer is port(
buffer_output :out std_logic_vector(131 downto 0);
Readdata1:in std_logic_vector(31 downto 0);
Readdata:in  std_logic_vector(31 downto 0);
EA: in  std_logic_vector(19 downto 0);
IMM:in std_logic_vector(15 downto 0);
TWO_FETCHES:in std_logic_vector(1 downto 0);
PREDICTION_SIGNAL:in std_logic;
PC:in  std_logic_vector(31 downto 0);
WRITE_REG1:in std_logic_vector(2 downto 0);
WRITE_REG2:in std_logic_vector(2 downto 0);
clk:in std_logic;
Rst:in std_logic;
BRANCH,MR,MW,P_IN,P_OUT,SP_INC,SP_DEC,CALL,WB1,WB2,RET,ALU_ENABLE,RTI,NO_OPERANDS,IGNORE_RSRC2: IN std_logic;
ALU_SELECTORS: IN std_logic_vector(3 downto 0);
OP_GROUP: IN std_logic_vector(1 downto 0);
Read_Address1_Regfile,Read_Address2_Regfile: IN STD_LOGIC_VECTOR(2 DOWNTO 0)
);
end component;
signal load_use : std_logic ;
 signal ReadData1fromRegfile,ReadData2fromRegfile:std_logic_vector(31 downto 0);
 signal Read_Address1_Regfile,Read_Address2_Regfile:std_logic_Vector(2 downto 0);
 signal buffer_output:std_logic_vector(131 downto 0);
 signal  BRANCH,MR,MW,P_IN,P_OUT,SP_INC,SP_DEC,CALL,WB1,WB2,RET,ALU_ENABLE,RTI,NO_OPERANDS,IGNORE_RSRC2:std_logic;
signal ALU_SELECTORS:std_logic_vector(3 downto 0);
signal TWO_FETCHES,OP_GROUP:std_logic_vector(1 downto 0);
begin

m1:controlUnit port map(Instruction(31 downto 25),ALU_SELECTORS,TWO_FETCHES,OP_GROUP,BRANCH,MR,MW,P_IN,P_OUT,SP_INC,SP_DEC,WB1,WB2,CALL,RET,ALU_ENABLE,RTI,NO_OPERANDS,IGNORE_RSRC2,load_use,TWO_FETCHES_FROM_FETCHING);
m2:RegFile port map(ReadData1fromRegfile,ReadData2fromRegfile,Read_Address1_Regfile,Read_Address2_Regfile,WRITE_DATA1,WRITE_DATA2,Instruction(31 downto 30),Instruction(27 downto 25),Instruction(24 downto 22),Instruction(21 downto 19),Instruction(18 downto 16),WRITE_REG1,WRITE_REG2,MEM_WB_WB1,MEM_WB_WB2,Clk,Rst,address_3,data_3,REG0,REG1,REG2,REG3,REG4,REG5,REG6,REG7);
m3:forwardunit port map(ForwardA,ForwardB,FORWARD_A_SEL,FORWARD_B_SEL,Dec_output(131 downto 129),Dec_output(128 downto 126),EX_MEM_rdest,EX_MEM_rdest2,MEM_WB_rdest,MEM_WB_rdest2, EX_MEM_WB1,EX_MEM_WB2,MEM_WB_WB1,MEM_WB_WB2,Dec_output(125),Dec_output(124));
m4:hazarddetection port map(load_use,Dec_output(122),Read_Address1_regfile,Read_Address2_Regfile,Dec_output(5 downto 3),Instruction(31 DOWNTO 25),NO_OPERANDS,IGNORE_RSRC2);
m5:DEC_EX_buffer port map(buffer_output,ReadData1fromRegfile,ReadData2fromRegfile,Instruction(19 downto 0),Instruction(15 downto 0),TWO_FETCHES,PredictionSignal,PC,Instruction(24 downto 22),Instruction(21 downto 19),Clk,Rst,BRANCH,MR,MW,P_IN,P_OUT,SP_INC,SP_DEC,CALL,WB1,WB2,RET,ALU_ENABLE,RTI,NO_OPERANDS,IGNORE_RSRC2,ALU_SELECTORS,OP_GROUP,Read_Address1_Regfile,Read_Address2_Regfile);

LOAD<=load_use;
Dec_output <= buffer_output;
WB_1<= WB1;
WB_2 <=WB2;
end toplevel_arch;
