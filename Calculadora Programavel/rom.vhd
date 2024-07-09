library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom is
    port(
        clk: in std_logic;
        rd_en: in std_logic;
        endereco: in unsigned(6 downto 0);
        dado: out unsigned(15 downto 0);
        exception: out std_logic
    );
end entity;

architecture a_rom of rom is
    type mem is array(0 to 127) of unsigned(15 downto 0);

    constant conteudo_rom: mem:=(
        -- caso endereco => conteudo
        0  => B"0010_0_011_00000101", --LD R3, 5
        1  => B"0010_0_100_00001000", --LD R4, 8
        2  => B"0011_1_011_00000000", --MOV A, R3
        3  => B"0100_1_100_00000000", --ADD A, R4
        4  => B"0011_0_101_00000000", --MOV R5, A
        5  => B"0010_0_111_00000001", --LD R7, 1
        6  => B"0110_1_111_00000000", --SUB A, R7
        7  => B"0011_0_101_00000000", --MOV R5, A
        8  => B"1010_00000_0010100", --JUMP 20
        9  => B"0010_0_101_00000000", --LD R5, 0
        20 => B"0011_1_101_00000000", --MOV A, R5
        21 => B"0011_0_011_00000000", --MOV R3, A
        22 => B"1010_00000_0000011", --JUMP 3
        23 => B"0010_0_011_00000000", --LD R3, 0
       -- abaixo: casos omissos => (zero em todos os bits)
        others => (others=>'0')
    );

    
begin
    process(clk, rd_en)
    begin
        if rising_edge(clk) then
            --habilita leitura
            if rd_en='1' then
                -- verifica se o endereço está no intervalo válido
                if to_integer(endereco) <= 127 then
                    dado<=conteudo_rom(to_integer(endereco));
                else
                    exception <= '1';
                end if;
            end if;
        end if;
    end process;
end architecture;
