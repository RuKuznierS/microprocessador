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
        0  => B"0010_0_011_00000000", --LD R3, 0
        1  => B"0010_0_100_00000000", --LD R4, 0
        2  => B"0011_1_011_00000000", --MOV A, R3 --LOOP
        3  => B"0100_1_100_00000000", --ADD A, R4
        4  => B"0011_0_100_00000000", --MOV R4, A
        5  => B"0011_1_011_00000000", --MOV A, R3
        6  => B"1100_1_000_0_0000001", --ADDI A, 1
        7  => B"0011_0_011_00000000", --MOV R3, A
        8  => B"0010_0_101_00011110", --LD R5, 30
        9  => B"0110_1_101_0_0000000", --SUB A, R5
        10  => B"0101_0_000_11111000", --BLT (A < R5) LOOP
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
