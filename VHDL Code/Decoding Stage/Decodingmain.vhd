LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY DECODINGMAIN IS PORT (

    PREDICTIONSIGNAL : IN STD_LOGIC;
    DEC_OUTPUT : INOUT STD_LOGIC_VECTOR(131 DOWNTO 0);

    PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    WRITE_REG1, WRITE_REG2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    FORWARDA, FORWARDB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    LOAD : OUT STD_LOGIC;
    WRITE_DATA1, WRITE_DATA2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CLK, RST : IN STD_LOGIC;
    INSTRUCTION : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    EX_MEM_RDEST, EX_MEM_RDEST2, MEM_WB_RDEST, MEM_WB_RDEST2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    EX_MEM_WB1, EX_MEM_WB2, MEM_WB_WB1, MEM_WB_WB2 : IN STD_LOGIC;
    TWO_FETCHES_FROM_FETCHING : IN STD_LOGIC;
    ADDRESS_3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    DATA_3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    REG0, REG1, REG2, REG3, REG4, REG5, REG6, REG7 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    WB_1, WB_2 : OUT STD_LOGIC;
    BUFFERWRITEENABLE : IN STD_LOGIC;
    FORWARD_A_SEL, FORWARD_B_SEL : OUT STD_LOGIC;
    WRONGDECISION : IN STD_LOGIC
);
END DECODINGMAIN;
ARCHITECTURE TOPLEVEL_ARCH OF DECODINGMAIN IS
    COMPONENT REGFILE IS PORT (
        READDATA1, READDATA2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        READ_ADDRESS_1, READ_ADDRESS_2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        WRITE_DATA1, WRITE_DATA2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        OP_GROUP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        OP_CODE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RDST, RSRC1, RSRC2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WRITE_REG1, WRITE_REG2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB1, WB2 : IN STD_LOGIC;
        CLK, RST : IN STD_LOGIC;
        ADDRESS_3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        DATA_3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        REG0, REG1, REG2, REG3, REG4, REG5, REG6, REG7 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT CONTROLUNIT IS PORT (
        INSTRUCTION : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        ALU_SELECTORS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        TWO_FETCHES, OP_GROUP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        BRANCH, MR, MW, P_IN, P_OUT, SP_INC, SP_DEC, WB1, WB2, CALL, RET,
        ALU_ENABLE, RTI, NO_OPERANDS, IGNORE_RSRC2 : OUT STD_LOGIC;
        BUFFERWRITEENABLE : IN STD_LOGIC;
        TWO_FETCHES_FROM_FETCHING : IN STD_LOGIC;
        WRONGDECISION : IN STD_LOGIC);
    END COMPONENT;

    COMPONENT FORWARDUNIT IS PORT (
        --R_SRC1,R_SRC2 ARE FROM ID/EX BUFFER 
        FORWARDA, FORWARDB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        FORWARD_A_SEL, FORWARD_B_SEL : OUT STD_LOGIC;
        R_SRC1, R_SRC2, EX_MEM_RDEST, EX_MEM_RDEST2, MEM_WB_RDEST, MEM_WB_RDEST2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        EX_MEM_WB1, EX_MEM_WB2, MEM_WB_WB1, MEM_WB_WB2, NO_OPERANDS, IGNORE_RSRC2 : IN STD_LOGIC);

    END COMPONENT;

    COMPONENT HAZARDDETECTION IS PORT (
        LOAD : OUT STD_LOGIC;
        DEC_EX_MEMREAD : IN STD_LOGIC;
        F_DEC_SRC1, F_DEC_SRC2, DEC_EX_DEST : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        OP_CODE : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        NO_OPERANDS, IGNORE_RSRC2 : IN STD_LOGIC;
        TWO_FETCHES : IN STD_LOGIC
        );
    END COMPONENT;

    COMPONENT DEC_EX_BUFFER IS PORT (
        BUFFER_OUTPUT : OUT STD_LOGIC_VECTOR(131 DOWNTO 0);
        READDATA1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        READDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        EA : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
        IMM : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        TWO_FETCHES : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        PREDICTION_SIGNAL : IN STD_LOGIC;
        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        WRITE_REG1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WRITE_REG2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        BRANCH, MR, MW, P_IN, P_OUT, SP_INC, SP_DEC, CALL, WB1, WB2, RET, ALU_ENABLE, RTI, NO_OPERANDS, IGNORE_RSRC2 : IN STD_LOGIC;
        ALU_SELECTORS : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        OP_GROUP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        READ_ADDRESS1_REGFILE, READ_ADDRESS2_REGFILE : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL LOAD_USE : STD_LOGIC;
    SIGNAL READDATA1FROMREGFILE, READDATA2FROMREGFILE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL READ_ADDRESS1_REGFILE, READ_ADDRESS2_REGFILE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL BUFFER_OUTPUT : STD_LOGIC_VECTOR(131 DOWNTO 0);
    SIGNAL BRANCH, MR, MW, P_IN, P_OUT, SP_INC, SP_DEC, CALL, WB1, WB2, RET, ALU_ENABLE, RTI, NO_OPERANDS, IGNORE_RSRC2 : STD_LOGIC;
    SIGNAL ALU_SELECTORS : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL TWO_FETCHES, OP_GROUP : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN

    M1 : CONTROLUNIT PORT MAP(INSTRUCTION(31 DOWNTO 25), ALU_SELECTORS, TWO_FETCHES, OP_GROUP, BRANCH, MR, MW, P_IN, P_OUT, SP_INC, SP_DEC, WB1, WB2, CALL, RET, ALU_ENABLE, RTI, NO_OPERANDS, IGNORE_RSRC2, LOAD_USE, TWO_FETCHES_FROM_FETCHING, WRONGDECISION);
    M2 : REGFILE PORT MAP(READDATA1FROMREGFILE, READDATA2FROMREGFILE, READ_ADDRESS1_REGFILE, READ_ADDRESS2_REGFILE, WRITE_DATA1, WRITE_DATA2, INSTRUCTION(31 DOWNTO 30), INSTRUCTION(27 DOWNTO 25), INSTRUCTION(24 DOWNTO 22), INSTRUCTION(21 DOWNTO 19), INSTRUCTION(18 DOWNTO 16), WRITE_REG1, WRITE_REG2, MEM_WB_WB1, MEM_WB_WB2, CLK, RST, ADDRESS_3, DATA_3, REG0, REG1, REG2, REG3, REG4, REG5, REG6, REG7);
    M3 : FORWARDUNIT PORT MAP(FORWARDA, FORWARDB, FORWARD_A_SEL, FORWARD_B_SEL, DEC_OUTPUT(131 DOWNTO 129), DEC_OUTPUT(128 DOWNTO 126), EX_MEM_RDEST, EX_MEM_RDEST2, MEM_WB_RDEST, MEM_WB_RDEST2, EX_MEM_WB1, EX_MEM_WB2, MEM_WB_WB1, MEM_WB_WB2, DEC_OUTPUT(125), DEC_OUTPUT(124));
    M4 : HAZARDDETECTION PORT MAP(LOAD_USE, DEC_OUTPUT(122), READ_ADDRESS1_REGFILE, READ_ADDRESS2_REGFILE, DEC_OUTPUT(5 DOWNTO 3), INSTRUCTION(31 DOWNTO 25), NO_OPERANDS, IGNORE_RSRC2, TWO_FETCHES_FROM_FETCHING);
    M5 : DEC_EX_BUFFER PORT MAP(BUFFER_OUTPUT, READDATA1FROMREGFILE, READDATA2FROMREGFILE, INSTRUCTION(19 DOWNTO 0), INSTRUCTION(15 DOWNTO 0), TWO_FETCHES, PREDICTIONSIGNAL, PC, INSTRUCTION(24 DOWNTO 22), INSTRUCTION(21 DOWNTO 19), CLK, RST, BRANCH, MR, MW, P_IN, P_OUT, SP_INC, SP_DEC, CALL, WB1, WB2, RET, ALU_ENABLE, RTI, NO_OPERANDS, IGNORE_RSRC2, ALU_SELECTORS, OP_GROUP, READ_ADDRESS1_REGFILE, READ_ADDRESS2_REGFILE);

    LOAD <= LOAD_USE;
    DEC_OUTPUT <= BUFFER_OUTPUT;
    WB_1 <= WB1;
    WB_2 <= WB2;
END TOPLEVEL_ARCH;