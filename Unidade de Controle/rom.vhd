library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom is
    port(
        clk: in std_logic;
        rd_en: in std_logic;
        endereco: in unsigned(6 downto 0);
        dado: out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array(0 to 127) of unsigned(15 downto 0);

    constant conteudo_rom: mem:=(
        -- caso endereco => conteudo
        0  => B"0000_000000000010",
        1  => B"1010_100000000000",
        2  => B"0101_000000000000",
        3  => B"0011_000000000000",
        4  => B"1111_00000_0000001", --jump, 1
        5  => B"0001_000000000010",

        6  => "0000111100000011",
        7  => "0101000000000010",
        8  => "1010000000000010",
        9  => "0101000000000000",
        10 => "1100000000000000",
       -- abaixo: casos omissos => (zero em todos os bits)
        others => (others=>'0')
    );

    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rd_en = '1' then
                dado<=conteudo_rom(to_integer(endereco));
            end if;
        end if;
    end process;
end architecture;
