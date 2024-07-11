library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom is
    port(
        clk: in std_logic;
        rd_en: in std_logic;
        endereco: in unsigned(7 downto 0);
        dado: out unsigned(15 downto 0);
        exception: out std_logic:='0'
    );
end entity;

architecture a_rom of rom is
    type mem is array(0 to 127) of unsigned(15 downto 0);

    constant conteudo_rom: mem:=(
        -- caso endereco => conteudo
        0=>B"0010_0_011_0_0000000", --LD  R3, 0
        1=>B"0010_1_000_0_0000001", --LD  A, 1
        2=>B"1101_1_011_0_0000000", --SW A, 0(R3) //0x0 memoria ram
        3=>B"1101_1_011_0_0000001", --SW A, 1(R3) //0x1 memoria ram
        4=>B"1101_1_011_0_0000010", --SW A, 2(R3) //0x2 memoria ram
        5=>B"1101_1_011_0_0000011", --SW A, 3(R3) //0x3 memoria ram
        6=>B"1101_1_011_0_0000100", --SW A, 4(R3) //0x4 memoria ram
        7=>B"1101_1_011_0_0000101", --SW A, 5(R3) //0x5 memoria ram
        
        8=>B"0010_1_000_0_0001010", --LD  A, 10
        9=>B"1110_1_011_0_0000000", -- LW A, 0(R3) --carrega em A o valor de 0x0
        10=>B"0010_1_000_0_0000000", --LD  A, 0
        11=>B"1110_1_011_0_0000001", -- LW A, 1(R3) --carrega em A o valor de 0x1
        12=>B"0010_1_000_0_0000000", --LD  A, 0
        13=>B"1110_1_011_0_0000010", -- LW A, 2(R3) --carrega em A o valor de 0x2
        14=>B"0010_1_000_0_0000000", --LD  A, 0
        15=>B"1110_1_011_0_0000011", -- LW A, 3(R3) --carrega em A o valor de 0x3
        16=>B"0010_1_000_0_0000000", --LD  A, 0
        17=>B"1110_1_011_0_0000100", -- LW A, 4(R3) --carrega em A o valor de 0x4
        18=>B"0010_1_000_0_0000000", --LD  A, 0
        19=>B"1110_1_011_0_0000101", -- LW A, 5(R3) --carrega em A o valor de 0x5
        20=>B"0010_1_000_0_0000000", --LD  A, 0
     
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
