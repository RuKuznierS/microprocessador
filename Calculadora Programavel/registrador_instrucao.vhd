library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_instrucao is
    port(
        clk: in std_logic;
        instruction: in unsigned(15 downto 0);
        inst_wr: in std_logic;
        data: out unsigned(15 downto 0)
    );
end entity;

architecture a_registrador_instrucao of registrador_instrucao is

begin
    process(clk,inst_wr)
    begin
        if rising_edge(clk) then
            if inst_wr='1' then
                data<=instruction;
            end if;
        end if;
    end process;
end architecture;
