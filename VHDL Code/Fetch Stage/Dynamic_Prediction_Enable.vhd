LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Dynamic_Branch_Enable IS
PORT (branching_reg: in std_logic_vector(2 downto 0);
      WB1_control_unit, WB2_control_unit: in std_logic;
      RDST_IF_ID ,RSRC_IF_ID: in std_logic_vector(2 downto 0);
      WB1_ID_EX ,WB2_ID_EX: in std_logic;
      RDST_ID_EX ,RSRC_ID_EX: in std_logic_vector(2 downto 0);
      WB1_EX_MEM ,WB2_EX_MEM: in std_logic;
      RDST_EX_MEM ,RSRC_EX_MEM: in std_logic_vector(2 downto 0);
      WB1_MEM_WB ,WB2_MEM_WB: in std_logic;
      RDST_MEM_WB ,RSRC_MEM_WB: in std_logic_vector(2 downto 0);
      enable_dynamic_prediction: out std_logic);
END ENTITY;

ARCHITECTURE arch OF Dynamic_Branch_Enable IS
signal first, second, third, forth: std_logic; -- Signal is '1' if branch waiting for it
signal first1, first2, second1, second2, third1, third2, forth1, forth2: std_logic;
signal selector11, selector12, selector21, selector22, selector31, selector32, selector41, selector42: std_logic_vector(3 downto 0);
signal reg11, reg12, reg21, reg22, reg31, reg32, reg41, reg42: std_logic_vector(2 downto 0); -- Signal is '0' when it equals to branching reg
BEGIN
    -- If any reg equals to "000" then it's the same branching register
    reg11 <= RDST_IF_ID xor branching_reg;
    reg12 <= RSRC_IF_ID xor branching_reg;
    reg21 <= RDST_ID_EX xor branching_reg;
    reg22 <= RSRC_ID_EX xor branching_reg;
    reg31 <= RDST_EX_MEM xor branching_reg;
    reg32 <= RSRC_EX_MEM xor branching_reg;
    reg41 <= RDST_MEM_WB xor branching_reg;
    reg42 <= RSRC_MEM_WB xor branching_reg;

    -- Set selectors
    selector11 <= reg11 & WB1_control_unit;
    selector12 <= reg12 & WB2_control_unit;
    selector21 <= reg21 & WB1_ID_EX;
    selector22 <= reg22 & WB2_ID_EX;
    selector31 <= reg31 & WB1_EX_MEM;
    selector32 <= reg32 & WB2_EX_MEM;
    selector41 <= reg41 & WB1_MEM_WB;
    selector42 <= reg42 & WB2_MEM_WB;

    with selector11 select first1 <=
    '1' when "0001",
    '0' when others;
    with selector12 select first2 <=
    '1' when "0001",
    '0' when others;

    with selector21 select second1 <=
    '1' when "0001",
    '0' when others;
    with selector22 select second2 <=
    '1' when "0001",
    '0' when others;

    with selector31 select third1 <=
    '1' when "0001",
    '0' when others;
    with selector32 select third2 <=
    '1' when "0001",
    '0' when others;

    with selector41 select forth1 <=
    '1' when "0001",
    '0' when others;
    with selector42 select forth2 <=
    '1' when "0001",
    '0' when others;


    -- Setting signals to check if branch is waiting for one of them
    first <= first1 or first2;
    second <= second1 or second2;
    third <= third1 or third2;
    forth <= forth1 or forth2;


    enable_dynamic_prediction <= not (first or second or third or forth);

END ARCHITECTURE;
