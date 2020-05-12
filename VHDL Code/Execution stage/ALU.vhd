library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
entity ALU is
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
end ALU; 
architecture Behavioral of ALU is

signal Result : std_logic_vector (N-1 downto 0);
signal zeroflag : std_logic;
signal negativeflag: std_logic;
signal carryflag: std_logic;

begin
   
   process(A,B,Sel,Enable,reset)
variable tmp: std_logic_vector (N downto 0);
variable ALU_Result_var : std_logic_vector (N-1 downto 0);
 begin
  if reset ='1' then 
  Result<=(others=>'0');
  carryflag<='0';
  negativeflag<='0';
  zeroflag<='0';
  else
  if Enable ='1' then
  case(Sel) is
  when "0000" => -- NOT
   ALU_Result_var:=NOT (A) ;
  when "0001" => -- INCREMENT
   ALU_Result_var:=A + 1 ;
   tmp := ('0' & A) + 1;
  when "0010" => -- DECREMENT
   ALU_Result_var:=A - 1;
   tmp := ('0' & A) - 1;
  when "0011" => -- SWAP LESA MA 5ELSETSH EL MFROD ATLA3 3LA EL BUFFER EL A MKAN EL SECOND OPERAND
   ALU_Result_var:=B ;
  when "0100" | "0101" => -- ADD
   ALU_Result_var:=A + B;
   tmp := ('0' & A) + ('0' & B);
  when "0110" => -- SUB
   ALU_Result_var:=A - B;
   tmp := ('0' & A) - ('0' & B);
  when "0111" => --  AND
   ALU_Result_var:=A and B;
  when "1000" => -- OR
   ALU_Result_var:=A or B;
  when "1001" => -- SHL 
   ALU_Result_var:= std_logic_vector(shift_left(unsigned(A),TO_INTEGER(unsigned(B))));
  when "1011" => -- SHR
   ALU_Result_var:=std_logic_vector(shift_right(unsigned(A),TO_INTEGER(unsigned(B))));
  when others => ALU_Result_var:=A ; 
  end case;
  Result<=ALU_Result_var;
  if Sel ="1000" then
   carryflag<= A(32-TO_INTEGER(unsigned(B)));
  elsif Sel ="1001" then -- msh 3aref sa7 wla l2
  carryflag<=A(TO_INTEGER(unsigned(B))-1);
  elsif Sel ="0001" or Sel ="0010" or Sel ="0100" or Sel ="0101" then
  carryflag <= tmp(32); -- Carryout flag
  end if;
  if Sel = "0000" or Sel ="0001" or Sel ="0010" or Sel ="0100" or Sel ="0101" or Sel ="0110" or Sel ="0111" or Sel ="1000" or Sel ="1001" then
  if to_integer(unsigned(ALU_Result_var))=0 then
   zeroflag <= '1';
   else
   zeroflag <= '0';
   end if;
   if to_integer(signed(ALU_Result_var))<0 then
   negativeflag<='1';
   else
   negativeflag<='0';
   end if;
  end if;
  end if;
  end if;
 end process;
 Res <= Result; -- ALU out
 CCR(2) <= carryflag;
 CCR(1) <= negativeflag;
 CCR(0) <= zeroflag;

end Behavioral;
