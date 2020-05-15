library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all; 
entity Decodingmain is port(

PredictionSignal :in  std_logic;
Dec_output:inout std_logic_vector(123 downto 0);

PC:in std_logic_vector(31 downto 0);
WRITE_REG1,WRITE_REG2:in std_logic_vector(2 downto 0);
ForwardA,ForwardB:out std_logic_vector(1 downto 0);
LOAD:out std_logic ;
WRITE_DATA1,WRITE_DATA2:in std_logic_vector(31 downto 0);
Clk,Rst:in std_logic ;
Instruction:in std_logic_vector(31 downto 0);
EX_MEM_rdest,MEM_WB_rdest:in std_logic_vector(2 downto 0);
 EX_MEM_WB1,EX_MEM_WB2,MEM_WB_WB1,MEM_WB_WB2:in std_logic

);
end Decodingmain;


architecture toplevel_arch of Decodingmain is
component RegFile is port(
Readdata1,Readdata2:out std_logic_vector(31 downto 0);
WRITE_DATA1,WRITE_DATA2:in std_logic_vector(31 downto 0);
 OP_GROUP:in std_logic_vector(1 downto 0);
OP_CODE:in std_logic_vector(2 downto 0);
Rdst,Rsrc1,Rsrc2:in std_logic_vector(2 downto 0);
 WRITE_REG1,WRITE_REG2:in std_logic_vector(2 downto 0);
WB1,WB2:in std_logic;
Clk,rst:in std_logic 
);
end component ;
component controlUnit is port (
Instruction:in std_logic_vector(6 downto 0);
 ALU_SELECTORS:out std_logic_vector(3 downto 0);
 TWO_FETCHES,OP_GROUP:out std_logic_vector(1 downto 0);
 BRANCH,MR,MW,P_IN,P_OUT,SP_INC,SP_DEC,WB1,WB2,CALL,RET,
ALU_ENABLE,RTI:out std_logic) ;
end component ;

component forwardunit is port(
--R_src1,R_src2 are from ID/EX buffer 
ForwardA,ForwardB:out std_logic_vector(1 downto 0);
R_src1,R_src2,EX_MEM_rdest,MEM_WB_rdest:in std_logic_vector(2 downto 0);
 EX_MEM_WB1,EX_MEM_WB2,MEM_WB_WB1,MEM_WB_WB2:in std_logic );

end component ;

component hazarddetection is port (
LOAD:out std_logic;
DEC_EX_MemRead:in std_logic;
F_DEC_src1,F_DEC_src2,DEC_EX_dest:in std_logic_vector(2 downto 0) 
);
end component ;

component DEC_EX_buffer is port(
buffer_output :out std_logic_vector(102 downto 0);
Readdata1:in std_logic_vector(31 downto 0);
Readdata:in  std_logic_vector(31 downto 0);
EA: in  std_logic_vector(19 downto 0);
IMM:in std_logic_vector(15 downto 0);
TWO_FETCHES:in std_logic_vector(1 downto 0);
PREDICTION_SIGNAL:in std_logic;
PC:in  std_logic_vector(31 downto 0);
WRITE_REG1:in std_logic_vector(2 downto 0);
WRITE_REG2:in std_logic_vector(2 downto 0);
clk:in std_logic
);
end component;
 signal ReadData1fromRegfile,ReadData2fromRegfile:std_logic_vector(31 downto 0);
 signal buffer_output:std_logic_vector(102 downto 0);
 signal  BRANCH,MR,MW,P_IN,P_OUT,SP_INC,SP_DEC,WB1,WB2,CALL,RET,ALU_ENABLE,RTI:std_logic;
signal ALU_SELECTORS:std_logic_vector(3 downto 0);
signal TWO_FETCHES,OP_GROUP:std_logic_vector(1 downto 0);
begin

m1:controlUnit port map(Instruction(31 downto 25),ALU_SELECTORS,TWO_FETCHES,OP_GROUP,BRANCH,MR,MW,P_IN,P_OUT,SP_INC,SP_DEC,WB1,WB2,CALL,RET,ALU_ENABLE,RTI);
m2:RegFile port map(ReadData1fromRegfile,ReadData2fromRegfile,WRITE_DATA1,WRITE_DATA2,Instruction(31 downto 30),Instruction(27 downto 25),Instruction(24 downto 22),Instruction(21 downto 19),Instruction(18 downto 16),WRITE_REG1,WRITE_REG2,WB1,WB2,Clk,Rst);
m3:forwardunit port map(ForwardA,ForwardB,Instruction(21 downto 19),Instruction(18 downto 16),EX_MEM_rdest,MEM_WB_rdest, EX_MEM_WB1,EX_MEM_WB2,MEM_WB_WB1,MEM_WB_WB2);
m4:hazarddetection port map(LOAD,Dec_output(122),Instruction(21 downto 19),Instruction(18 downto 16),Dec_output(5 downto 3));
m5:DEC_EX_buffer port map(buffer_output,ReadData1fromRegfile,ReadData2fromRegfile,Instruction(19 downto 0),Instruction(15 downto 0), TWO_FETCHES,PredictionSignal,PC,WRITE_REG1,WRITE_REG2,Clk);


Dec_output <= BRANCH&MR&MW&P_IN&P_OUT&SP_INC&SP_DEC&WB1&WB2&CALL&RET&
ALU_ENABLE&RTI&ALU_SELECTORS&TWO_FETCHES&OP_GROUP&buffer_output;


end toplevel_arch;