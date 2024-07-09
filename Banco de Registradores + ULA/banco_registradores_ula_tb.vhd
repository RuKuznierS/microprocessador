library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity banco_registradores_ula_tb is
end entity;

architecture a_banco_registradores_ula_tb of banco_registradores_ula_tb is
    component banco_registradores_ula
    port(
        clk: in std_logic;
        rst: in std_logic;
        write_enable: in std_logic;
        sel_reg_1: in unsigned(2 downto 0);
        sel_reg_2: in unsigned(2 downto 0);
        sel_reg_write: in unsigned(2 downto 0);
        ula_op_selector: in unsigned(1 downto 0);
        operando_b_constante: in unsigned(15 downto 0);
        operador_b_selector: in std_logic;
        resultado_ula: out unsigned(15 downto 0)
    );
end component;

constant period_time: time :=100 ns;
signal finished: std_logic :='0';
signal clk, rst, write_enable: std_logic;

signal sel_reg_1: unsigned(2 downto 0);
signal sel_reg_2: unsigned(2 downto 0);
signal sel_reg_write: unsigned(2 downto 0);
signal operando_b_constante: unsigned(15 downto 0);
signal ula_op_selector: unsigned(1 downto 0);
signal operador_b_selector: std_logic;
signal resultado_ula: unsigned(15 downto 0);

begin
    uut: banco_registradores_ula port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable,
        sel_reg_1 => sel_reg_1,
        sel_reg_2 => sel_reg_2,
        sel_reg_write => sel_reg_write,
        ula_op_selector => ula_op_selector,
        operando_b_constante => operando_b_constante,
        operador_b_selector => operador_b_selector,
        resultado_ula => resultado_ula
    );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2;
        rst <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us; -- tempo total simulacao
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    main: process
    begin
        --reset nos registradores
        wait for 200 ns;
        
        
        write_enable<='1'; --habilito a escrita nos registradores
        
        sel_reg_1 <= "000"; -- REG = 0
        
        operador_b_selector <= '1'; --constante
        operando_b_constante <= "0000000000000011"; -- 3
        ula_op_selector <= "00"; --operação soma
        sel_reg_write<="001"; --R1 = 0 + 3 = 3

        wait for 100 ns;

        sel_reg_1 <= "001"; -- seleciona R1 = 3
        ula_op_selector <= "00"; -- operação soma
        operando_b_constante <= "0000000000000010"; -- 2
        sel_reg_write<="010"; -- escreve no R2 = 3 + 2 = 5

        wait for 100 ns;

        sel_reg_1 <= "001"; -- 3
        sel_reg_2 <= "010"; -- 5
        operador_b_selector <= '0'; --sem constante, recebe valor do data_out_reg_2 = R2
        ula_op_selector <= "00"; --seleciono adicao
        sel_reg_write<="011"; --salva no R3 = 5 + 3 = 8

        wait for 100 ns;

        sel_reg_1 <= "001"; -- 3
        sel_reg_2 <= "010"; -- 5
        operador_b_selector <= '0'; --sem constante, recebe valor do data_out_reg_2 =  R2
        ula_op_selector <= "01"; --seleciono subtracao
        sel_reg_write<="100"; --salva no R4 =  3 - 5 = -2

        wait for 100 ns;

        sel_reg_1 <= "001"; -- 3 0000000000000011
        sel_reg_2 <= "010"; -- 5 0000000000000101
        operador_b_selector <= '0'; --sem constante
        ula_op_selector <= "10"; --seleciono and
        sel_reg_write<="101"; --salva no R5 = 0000000000000001 = 1

        wait for 100 ns;
        
        sel_reg_1 <= "001"; -- 3 0000000000000011
        sel_reg_2 <= "010"; -- 5 0000000000000101
        operador_b_selector <= '0'; --sem constante
        ula_op_selector <= "11"; --seleciono or
        sel_reg_write<="110"; --salva no R6 = 0000000000000111 = 7
        
        wait for 100 ns;
        
        -- operação sem gravar nos registradores
        write_enable<='0'; --desabilito a escrita nos registradores
        
        sel_reg_1 <= "001"; -- seleciona R1 = 3
        ula_op_selector <= "00"; -- operação soma
        operador_b_selector <= '1'; --constante
        operando_b_constante <= "0000000000000011"; -- 3
        sel_reg_write<="111"; -- não escreve, R7 continua sem nada
        -- saida da ula = 6
        
        wait for 100 ns;
        
        sel_reg_1 <= "001"; -- seleciona R1 = 3
        ula_op_selector <= "01"; -- operação subtracao
        operador_b_selector <= '1'; --constante
        operando_b_constante <= "0000000000000001"; -- 1
        sel_reg_write<="111"; -- não escreve, R7 continua sem nada
        -- saida da ula = 2
        
        wait for 100 ns;
        
        write_enable<='1'; --habilito a escrita nos registradores
        sel_reg_1 <= "001"; -- seleciona R1 = 3
        ula_op_selector <= "00"; -- operação subtracao
        operador_b_selector <= '1'; --constante
        operando_b_constante <= "0000000000000001"; -- 1
        sel_reg_write<="000"; -- tento escrever no R0 (não pode dar certo)
        -- saida da ula = 4
        
        wait;
    end process;
end architecture;
