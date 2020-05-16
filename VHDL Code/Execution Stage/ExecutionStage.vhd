library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
entity ExecutionStage is
    Port (
    ID_EX     : in  STD_LOGIC_VECTOR(129 downto 0); 
    EX_MEM_in     : in  STD_LOGIC_VECTOR(31 downto 0); 
    MEM_WB     : in  STD_LOGIC_VECTOR(31 downto 0); 
    reset,clock : in std_logic ;
    SelForwardingUnit1  : in  STD_LOGIC_VECTOR(1 downto 0); 
    SelForwardingUnit2  : in  STD_LOGIC_VECTOR(1 downto 0); 
    RTIfromWB : in std_logic ;
    CCRfromWB : in STD_LOGIC_VECTOR(3 downto 0);
    CCR_out : out STD_LOGIC_VECTOR(3 downto 0);
    wrongDecision : out STD_LOGIC ;
    From_execution_stage : out STD_LOGIC_VECTOR (31 downto 0);
    EX_MEM_out     : out  STD_LOGIC_VECTOR(114 downto 0)
    );
end ExecutionStage;

ARCHITECTURE dataflow OF ExecutionStage IS
 signal check1 : STD_LOGIC;
 signal check2 : STD_LOGIC;
 signal check3 : STD_LOGIC;
 signal CCR_Enable : STD_LOGIC;
 signal AluEnable : STD_LOGIC;
 signal SelAlu   :  STD_LOGIC_VECTOR(3 downto 0);
 signal result1 : std_logic_vector (31 downto 0);
 signal result2 : std_logic_vector (31 downto 0);
 signal operand_1 : std_logic_vector (31 downto 0);
 signal operand_2 : std_logic_vector (31 downto 0);
 signal CCR_ALU : std_logic_vector (3 downto 0);
 signal CCR_REG : std_logic_vector (3 downto 0);
 signal CCR_reg_input : std_logic_vector (3 downto 0);
 signal BUFF_IN : std_logic_vector (114 downto 0);

COMPONENT EX_MEM_BUFFER IS
PORT ( clock, reset,writeEnable : IN STD_LOGIC;
 REG_IN : IN STD_LOGIC_VECTOR (114 downto 0);
 REG_OUT : OUT STD_LOGIC_VECTOR (114 downto 0) );
END COMPONENT; 
component ALU is
  generic ( 
     N: integer := 32  
    );
  
    Port (
    A, B     : in  STD_LOGIC_VECTOR(N-1 downto 0); 
    Enable,reset : in std_logic ;
    Sel  : in  STD_LOGIC_VECTOR(3 downto 0); 
    Res   : out  STD_LOGIC_VECTOR(N-1 downto 0);
    CCR : out STD_LOGIC_VECTOR (3 downto 0)
    );
end component; 

component ConditionCodeRegister IS
 PORT ( clock, reset,writeEnable : IN STD_LOGIC;
 CCRIN : IN STD_LOGIC_VECTOR (3 downto 0);
 CCROUT : OUT STD_LOGIC_VECTOR (3 downto 0) );
END component; 


 BEGIN
 CCR_Enable<= AluEnable or RTIfromWB;
AluEnable<= ID_EX(112);
SelAlu<= ID_EX(110 downto 107);
with SelForwardingUnit1 select operand_1 <= -- MUX 1 --
	MEM_WB when "00",
	EX_MEM_in when "01",
	ID_EX(101 downto 70) when "10",
	ID_EX(101 downto 70) when others;


with SelForwardingUnit2 select operand_2 <= -- MUX 2 --
	MEM_WB when "00",
	EX_MEM_in when "01",
	ID_EX(69 downto 38) when "10",
	ID_EX(69 downto 38) when others;

with SelAlu select result2 <= -- MUX 3 -- handling swap by passing B in alu and operand one get into place of operand 2 in buffer
        operand_1 when "0011",
        operand_2 when others;



check1<= ( ID_EX (102) xor CCR_REG(0) ) and ID_EX (123) ;
check2<= not(ID_EX (102)) and not(ID_EX (123)) ;
check3<= check1 or check2;
with check3 select wrongDecision <=
	'1' when '1',
        '0' when others;

with ID_EX (102) select From_execution_stage <=
	operand_1 when '0',
	ID_EX(37 downto 6) when others;


--handling rti from WB
with RTIfromWB select CCR_reg_input <=
	CCRfromWB when '1',
        CCR_ALU when others;

-- out 
BUFF_IN (2 downto 0) <= ID_EX(2 downto 0);
BUFF_IN (5 downto 3) <= ID_EX(5 downto 3);
BUFF_IN (37 downto 6) <= ID_EX(37 downto 6);
BUFF_IN (69 downto 38) <= result2;
BUFF_IN (101 downto 70) <= result1;
BUFF_IN (102) <= ID_EX(111);
BUFF_IN (111 downto 103) <= ID_EX(122 downto 114);
BUFF_IN (114 downto 111) <= CCR_REG;
CCR_out<=CCR_REG;
-- port mapping
u1: ALU generic map(32)
            port map(operand_1, operand_2, AluEnable,reset, SelAlu,result1,CCR_ALU);
u2: ConditionCodeRegister  port map(clock, reset,CCR_Enable ,CCR_reg_input,CCR_REG);
u3: EX_MEM_BUFFER  port map(clock, reset,'1', BUFF_IN,EX_MEM_OUT);

END dataflow;