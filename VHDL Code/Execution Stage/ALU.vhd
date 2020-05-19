LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY ALU IS
   GENERIC (
      N : INTEGER := 32
   );

   PORT (
      A, B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      ENABLE, RESET : IN STD_LOGIC;
      SEL : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      RES : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      CCR : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
   );
END ALU;
ARCHITECTURE BEHAVIORAL OF ALU IS

   SIGNAL RESULT : STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
   SIGNAL ZEROFLAG : STD_LOGIC;
   SIGNAL NEGATIVEFLAG : STD_LOGIC;
   SIGNAL CARRYFLAG : STD_LOGIC;

BEGIN

   PROCESS (A, B, SEL, ENABLE, RESET)
      VARIABLE TMP : STD_LOGIC_VECTOR (N DOWNTO 0);
      VARIABLE ALU_RESULT_VAR : STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
   BEGIN
      IF RESET = '1' THEN
         RESULT <= (OTHERS => '0');
      ELSE
         IF ENABLE = '1' THEN
            CASE(SEL) IS
               WHEN "0000" => -- NOT
               ALU_RESULT_VAR := NOT (A);
               WHEN "0001" => -- INCREMENT
               ALU_RESULT_VAR := A + 1;
               TMP := ('0' & A) + 1;
               WHEN "0010" => -- DECREMENT
               ALU_RESULT_VAR := A - 1;
               TMP := ('0' & A) + ('0'& x"FFFFFFFF");
               WHEN "0011" => -- SWAP 
               ALU_RESULT_VAR := B;
               WHEN "0100" | "0101" => -- ADD
               ALU_RESULT_VAR := A + B;
               TMP := ('0' & A) + ('0' & B);
               WHEN "0110" => -- SUB
               ALU_RESULT_VAR := A - B;
               TMP := ('0' & A) - ('0' & B);
               WHEN "0111" => --  AND
               ALU_RESULT_VAR := A AND B;
               WHEN "1000" => -- OR
               ALU_RESULT_VAR := A OR B;
               WHEN "1001" => -- SHL 
               ALU_RESULT_VAR := STD_LOGIC_VECTOR(SHIFT_LEFT(UNSIGNED(A), TO_INTEGER(UNSIGNED(B))));
               WHEN "1011" => -- SHR
               ALU_RESULT_VAR := STD_LOGIC_VECTOR(SHIFT_RIGHT(UNSIGNED(A), TO_INTEGER(UNSIGNED(B))));
               WHEN OTHERS => ALU_RESULT_VAR := A;
            END CASE;
            RESULT <= ALU_RESULT_VAR;
            IF SEL = "1001" THEN
               CARRYFLAG <= A(20 - TO_INTEGER(UNSIGNED(B)));
            ELSIF SEL = "1011" THEN
               CARRYFLAG <= A(TO_INTEGER(UNSIGNED(B)) - 1);
            ELSIF SEL = "0001" OR SEL = "0010" OR SEL = "0100" OR SEL = "0110" THEN
               CARRYFLAG <= TMP(32); -- CARRYOUT FLAG
            END IF;
            IF SEL = "0000" OR SEL = "0001" OR SEL = "0010" OR SEL = "0100" OR SEL = "0110" OR SEL = "0111" OR SEL = "1000" OR SEL = "1001" OR SEL = "1011" THEN
               IF TO_INTEGER(UNSIGNED(ALU_RESULT_VAR)) = 0 THEN
                  ZEROFLAG <= '1';
               ELSE
                  ZEROFLAG <= '0';
               END IF;
               IF TO_INTEGER(SIGNED(ALU_RESULT_VAR)) < 0 THEN
                  NEGATIVEFLAG <= '1';
               ELSE
                  NEGATIVEFLAG <= '0';
               END IF;
            END IF;
         ELSE
            RESULT <= A;
         END IF;
      END IF;
   END PROCESS;
   RES <= RESULT; -- ALU OUT
   CCR(2) <= CARRYFLAG;
   CCR(1) <= NEGATIVEFLAG;
   CCR(0) <= ZEROFLAG;

END BEHAVIORAL;