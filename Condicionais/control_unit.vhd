library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port(
        estado: in unsigned(1 downto 0);
        instruction: in unsigned(15 downto 0);
        clk: in std_logic;
        reset: in std_logic;
        rd_en_rom: out std_logic;
        rd_en_banco_registradores: out std_logic;
        jump_enable: out std_logic;
        blt_enable: out std_logic;
        wr_en_reg_instrucao: out std_logic;
        wr_en_acumulador_ula: out std_logic;
        wr_en_registradores: out std_logic;
        wr_en_registrador_carry: out std_logic;
        operador_registrador: out std_logic;
        operador_acumulador_ula: out unsigned(1 downto 0);
        operador_mux_banco_registradores: out unsigned(1 downto 0);
        operador_ula: out unsigned(1 downto 0)
        
    );
end entity;

architecture a_control_unit of control_unit is
    
    signal opcode: unsigned(3 downto 0);
    signal registrador: unsigned(2 downto 0);
    signal constantes: unsigned(6 downto 0);
    signal acumulador_destino_origem_s: std_logic;

begin
    
    opcode <= instruction(15 downto 12);
    
    --escolho se utilizo ou não o acumulador
    acumulador_destino_origem_s <= instruction(11); -- 1 se primeiro operando for o acumulador
    
    registrador <= instruction(10 downto 8);
    constantes <= instruction(6 downto 0);
    
    jump_enable <=  '1' when opcode="1010"  else
    '0';
    
    blt_enable <= '1' when (opcode="0101") else
    '0';
    
    --leitura da rom no estado 00 (fetch)
    rd_en_rom <= '1' when estado="00" else --fetch
    '0';
    
    -- le do banco de registradores 10 (execute)
    rd_en_banco_registradores<='1' when estado="10" else
    '0';

    --escreve no registrador de instrucoes 01 (decode)
    wr_en_reg_instrucao<='1' when estado="01" else
    '0';
    
    
     --habilita escrita no acumulador acumulador
    wr_en_acumulador_ula <= '1' when (opcode="0100" and estado="10") or
    (opcode="0110" and estado="10") or
    (opcode="0010" and acumulador_destino_origem_s = '1' and estado="10") or
    (opcode="1100" and acumulador_destino_origem_s = '1' and estado="10") or
    (opcode="0011" and acumulador_destino_origem_s = '1' and estado="10") else
    '0';
    
    --habilita escrita nos registradores
    wr_en_registradores <= '1' when (opcode="0010" and acumulador_destino_origem_s = '0' and estado="10") or
    (opcode="0011" and acumulador_destino_origem_s = '0' and estado="10") else
    '0';
    
     -- write enable do registrador de carry (uso em BLT)
    wr_en_registrador_carry <= '1' when opcode="0110" or --SUB
    opcode="0100" or opcode="1100" else --ADD, ADDI
    '0';
    
    
    --instruções LD A, cte e MOV A <- REG
    operador_acumulador_ula <= "01" when (opcode="0011" and acumulador_destino_origem_s = '1' and estado="10") else --MOV
    "10" when (opcode="0010" and acumulador_destino_origem_s = '1' and estado="10") else --LD
    "00"; --saida da ula

    --instruções LD REG /cte e MOV REG <- A / LW REG, imm(REG)
    operador_mux_banco_registradores <= "01" when (opcode="0011" and acumulador_destino_origem_s = '0' and estado="10") else -- MOV
    "10" when (opcode="0010" and acumulador_destino_origem_s = '0' and estado="10") else -- LD
    "00"; --saida da ula

    --operacoes ula -- 10 (execute)
    operador_ula<=  "00" when(opcode="1100" and estado="10") or -- ADDI
    (opcode="0100" and estado="10") else -- ADD
    "01" when(opcode="0110" and estado="10") else -- SUB
    "00";

     -- operador b da ULA
    operador_registrador <='0' when (opcode="1100" and estado="10") or
    (opcode="0111" and estado="10") else --recebe cte
    '1'; --recebe do registrador
    

end architecture;
