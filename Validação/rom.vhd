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
        0=>B"0010_0_111_0_0100000", --LD R7, 32 - limite superior
        1=>B"0010_0_001_0_0000000", --LD  R1, 0 - endereço/contador
        2=>B"0010_0_011_0_0000000", --LD  R3, 0 - salva endereço antigo loop
        -- LOOP ---
        3=>B"0011_1_001_0_0000000", --MOV A, R1 LOOP
        4=>B"1100_1_000_0_0000001", --ADDI A, 1
        5=>B"0011_0_001_0_0000000", --MOV R1, A
        6=>B"0011_0_011_0_0000000", --MOV R3, A -- copia
        7=>B"1101_1_001_0_0000000", --SW A, 0(R1) //R1 memoria ram
        8=>B"0011_1_011_0_0000000", --MOV A, R3
        9=>B"0110_1_111_0_0000000", --SUB A, R7
        10=>B"0101_0_000_11111000", -- BLT (A < R7) LOOP
        
        --- LOOP ----

        11=>B"1101_1_000_0_0000001", --SW A, 1(R0)


        12=>B"0010_0_001_0_0000010", --LD  R1, 2 - endereço/contador
        13=>B"0010_0_010_0_0000001", --LD  R2, 1
        
        --- MAIN ---------------------------------------------
        14=>B"1110_1_001_0_0000000", -- LW A, 0(R1) --carrega em A o valor da RAM
        15=>B"0110_1_001_0_0000000", --SUB A, R1 --- 2-2 = 0
        16=>B"0101_0_000_00011000", -- BLT (A < R1) INCREMENTA P

        17=>B"0011_1_001_0_0000000", --MOV A, R1
        18=>B"0011_0_110_0_0000000", --MOV R6, A
        
        19=>B"0011_0_100_0_0000000", --MOV R4, A
        20=>B"0011_0_110_0_0000000", --MOV R6, A
        
        
        21=>B"0100_1_100_0_0000000", --ADD A, R4
        22=>B"0011_0_100_0_0000000", --MOV R4, A
        23=>B"0010_0_101_0_0000000", --LD R5, 0
        
        -- MULTIPLO ------------------------------------------
        24=>B"0011_1_101_0_0000000", --MOV A, R5
        25=>B"0100_1_100_0_0000000", --ADD A, R4
        26=>B"0011_0_101_0_0000000", --MOV R5, A
        
        27=>B"0011_0_111_0_0000000", --MOV R7, A
        28=>B"0010_1_000_0_0100000", --LD A, 32
        
        29=>B"0110_1_111_0_0000000", --SUB A, R7
        30=>B"0101_0_000_00001010", -- BLT (A < R7) INCREMENTA P
        
        31=>B"0011_1_101_0_0000000", --MOV A, R5
        32=>B"0010_0_111_0_0100000", --LD R7, 32
        
        --multiplos recebem o 0 --
        33=>B"0010_1_000_0_0000000", --LD A, 0
        34=>B"1101_1_101_0_0000000", --SW A, 0(R5)
        -------------------------
        35=>B"0011_1_110_0_0000000", --MOV A, R6
        36=>B"0011_0_100_0_0000000", --MOV R4, A
        
        37=>B"0011_1_101_0_0000000", --MOV A, R5
        
        38=>B"0110_1_111_0_0000000", --SUB A, R7 ---
        39=>B"0101_0_000_11110001", -- BLT (A < R7) MULTIPLO
        
         -- INCREMENTA P -------------------------------------
        
        40=>B"0010_1_000_0_0000001", --LD A, 1
        41=>B"0100_1_001_0_0000000", --ADD A, R1
        42=>B"0011_0_001_0_0000000", --MOV R1, A
        
        43=>B"0110_1_111_0_0000000", --SUB A, R7 ---
        44=>B"0101_0_000_11100010", -- BLT (A < R7) MAIN
        
        --- exibição dos números primos ---------------------------------
        45=>B"0010_0_111_0_0100000", --LD R7, 32
        
        46=>B"0010_0_001_0_0000000", --LD  R1, 1 - endereço/contador
        
        47=>B"0011_1_001_0_0000000", --MOV A, R1 DISPLAY
        48=>B"1100_1_000_0_0000001", --ADDI A, 1
        49=>B"0011_0_001_0_0000000", --MOV R1, A
        50=>B"0011_0_011_0_0000000", --MOV R3, A -- copia
        51=>B"1110_1_001_0_0000000", -- LW A, 0(R1) --carrega em A o valor da RAM
        52=>B"0011_0_101_0_0000000", --MOV R5, A -- copia
        53=>B"0110_1_011_0_0000000", --SUB A, R3 ---
        54=>B"0101_0_000_00000011", -- BLT (A < R3) ZERO
        55=>B"0011_1_101_0_0000000", --MOV A, R5
       
        56=>B"0011_0_110_0_0000000", --MOV R6, A --- primos serão exibidos em R6
        
        57=>B"0011_1_011_0_0000000", --MOV A, R3 --ZERO
        58=>B"0110_1_111_0_0000000", --SUB A, R7
        59=>B"0101_0_000_11110100", -- BLT (A < R7) DISPLAY
        
        -----------------------------------------------------------------
        60=>B"1010_0_000_11111111", --validação de endereço inválido memória
        
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
