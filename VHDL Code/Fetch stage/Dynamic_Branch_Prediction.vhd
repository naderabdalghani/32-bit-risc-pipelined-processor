LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity Dynamic_Branch IS
    PORT(address: in std_logic_vector(4 downto 0); -- Address to be updated from execute stage
         reg_data: in std_logic_vector(31 downto 0); -- Register data to jump to
         first_16_bits_inst_mem: in std_logic_vector(15 downto 0); -- First 16 bit of the instruction which contains the op code , dest reg
         enable,CLK,RST,JZ_exe_stage,zero_flag: in std_logic;
         prediction: out std_logic;
         select_reg: out std_logic_vector(2 downto 0);
         prediction_address: out std_logic_vector(31 downto 0));
end entity;

architecture arch OF Dynamic_Branch IS
-- Dynamic branch prediction cache
type states is (strongly_not_taken,weakly_not_taken,weakly_taken,strongly_taken);
type dynamic_branch_cache is array(0 to 31) of states;
signal cache : dynamic_branch_cache;
signal prediction_signal: std_logic;
signal unconditional_jmp: std_logic; -- Equals to '1' when jmp,call
signal jz_signal: std_logic; -- Equals '1' when the current instruction in fetching stage is JZ
begin
    -- Edit dynamic branch cache based on execution unit
    process (clk) is
    variable current_state : states;
    begin
        if rising_edge(clk) then
            if RST = '1' then
                cache <= (others => strongly_not_taken);
            -- Update cache when it's a JZ operation
            elsif JZ_exe_stage = '1' then   
                case current_state is
                    when strongly_not_taken => 
                        if zero_flag = '1' then current_state := weakly_not_taken; else current_state := strongly_not_taken; end if;
                    when weakly_not_taken =>
                        if zero_flag = '1' then current_state := weakly_taken; else current_state := strongly_not_taken; end if;
                    when weakly_taken =>
                        if zero_flag = '1' then current_state := strongly_taken; else current_state := weakly_not_taken; end if;
                    when strongly_taken =>
                        if zero_flag = '1' then current_state := strongly_taken; else current_state := weakly_taken; end if;    
                end case;
                cache(to_integer(unsigned(address))) <= current_state;
            end if ;
        end if ;
    end process;

    -- Prediction signal to PC
    process (clk) is
    begin
        if falling_edge(clk) then
            if jz_signal = '1' then
                case cache(to_integer(unsigned(reg_data(4 downto 0)))) is
                    when weakly_taken | strongly_taken => prediction_signal <= '1';
                    when others => prediction_signal <= '0';
                end case ;
            else
                prediction_signal <= '0';
            end if ;
        end if ;
    end process;

    jz_signal <= (not first_16_bits_inst_mem(15)) and first_16_bits_inst_mem(14) and (not first_16_bits_inst_mem(11)) and (not first_16_bits_inst_mem(10)) and (not first_16_bits_inst_mem(9)); 
    unconditional_jmp <= ((not first_16_bits_inst_mem(15)) and first_16_bits_inst_mem(14)) and (not first_16_bits_inst_mem(11)) and (first_16_bits_inst_mem(10) or first_16_bits_inst_mem(9));
    prediction <= (prediction_signal or unconditional_jmp) and enable;
    prediction_address <= reg_data;
    select_reg <= first_16_bits_inst_mem(8 downto 6);

end architecture;

