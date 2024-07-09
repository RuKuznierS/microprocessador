library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_carry is
    port(
        rst: in std_logic;
        wr_en: in std_logic;
        clk: in std_logic;
        data_in: in std_logic;
        data_out: out std_logic
    );
end entity;

architecture a_registrador_carry of registrador_carry is
begin
    process(clk)
    begin
        if rst='1' then
            data_out<='0';
        elsif rising_edge(clk) then
            if wr_en='1' then
                data_out<=data_in;
            end if;
        end if;
    end process;
end architecture;