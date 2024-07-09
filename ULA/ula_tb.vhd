library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula_tb is
end entity ula_tb;

architecture a_ula_tb of ula_tb is
    component ula is
        port(
            in_a: in unsigned(15 downto 0);
            in_b: in unsigned(15 downto 0);
            op_selector: in unsigned(1 downto 0);
            resultado: out unsigned(15 downto 0);
            overflow_flag: out std_logic;
            carry_flag: out std_logic
        );
    end component;

    signal in_a_s: unsigned(15 downto 0);
    signal in_b_s: unsigned(15 downto 0);
    signal op_selector_s: unsigned(1 downto 0);
    signal resultado_s: unsigned(15 downto 0);
    signal overflow_flag_s: std_logic;
    signal carry_flag_s: std_logic;
    
begin
    
    ula_0: ula port map(
        in_a => in_a_s,
        in_b => in_b_s,
        op_selector => op_selector_s,
        resultado => resultado_s,
        overflow_flag => overflow_flag_s,
        carry_flag => carry_flag_s
    );
    
    process
    begin
        --adicao --
        in_a_s <= "0000000000010110"; -- 22
        in_b_s <= "0000000000001101"; -- 13
        op_selector_s <= "00"; -- 35
        wait for 50 ns;
        
        --adicao teste carry --
        in_a_s <= "1000000111000010";
        in_b_s <= "1000000111001100";
        op_selector_s <= "00";
        wait for 50 ns;
        
        --adicao teste overflow --
        in_a_s <= "1000000000000000";
        in_b_s <= "1000000000000000";
        op_selector_s <= "00";
        wait for 50 ns;
        ---------------------------
        
        --subtracao--
        in_a_s <= "0000000010000010"; --130
        in_b_s <= "0000000001110010"; --114
        op_selector_s <= "01"; --16
        wait for 50 ns;
        
         --subtracao teste carry --
        in_a_s <= "0000000001110010"; --114
        in_b_s <= "0000000010000010"; --130
        op_selector_s <= "01";
        wait for 50 ns;
        ---------------------------
        
        --AND--
        in_a_s <= "1010101010001001";
        in_b_s <= "0101010100001001";
        op_selector_s <= "10";
        wait for 50 ns;
        
         --OR--
        in_a_s <= "0000000110000011";
        in_b_s <= "0000000000001100";
        op_selector_s <= "11";
        wait for 50 ns;
        
        wait;
    end process;

end architecture a_ula_tb;