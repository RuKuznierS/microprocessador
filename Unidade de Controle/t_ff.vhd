library IEEE;
use IEEE.std_logic_1164.all;

entity t_ff is
    port(
        t: in std_logic;
        clk: in std_logic;
        reset: in std_logic;
        state: out std_logic
    );
end entity;

architecture behavioral of t_ff is
    signal state_signal: std_logic;

begin
    process(clk, reset)
    begin
        if reset='1' then
            state_signal<='0';
        elsif t='1' then
            if rising_edge(clk) then
                state_signal<=not(state_signal);
            end if;
        end if;
    end process;
    state<=state_signal;
end architecture;