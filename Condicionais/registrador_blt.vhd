library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_blt is
    port(
        rst: in std_logic;
        state: in unsigned(1 downto 0);
        clk: in std_logic;
        data_in: in std_logic;
        data_out: out std_logic
    );
end entity;

architecture a_registrador_blt of registrador_blt is
begin
    process(clk)
    begin
        if rst='1' then
            data_out<='0';
        elsif rising_edge(clk) then
            if state="00" then
                data_out<=data_in;
            end if;
        end if;
    end process;
end architecture;
