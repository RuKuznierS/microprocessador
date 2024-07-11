library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculadora_programavel_top_level_tb is
end entity;

architecture a_calculadora_programavel_top_level_tb of calculadora_programavel_top_level_tb is
    component calculadora_programavel_top_level is
        port(
            reset: in std_logic;
            clk: in std_logic;
            estado: out unsigned(1 downto 0);
            data_out_pc: out unsigned(7 downto 0);
            data_out_reg_instrucao: out unsigned(15 downto 0);
            data_out_banco_registrador: out unsigned(15 downto 0); --banco de registrador
            data_out_acumulador_ula: out unsigned(15 downto 0); --registrador externo
            data_out_ula: out unsigned(15 downto 0)
        );
    end component calculadora_programavel_top_level;

    constant period_time: time :=100 ns;    --clk period
    signal finished: std_logic :='0';
    signal clk: std_logic;

    signal rst: std_logic;

begin
    uut: calculadora_programavel_top_level port map(
        rst,
        clk
    );

    reset: process
    begin
        rst<='1';
        wait for 50 ns;
        rst<='0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 700 us;
        finished<='1';
        wait;
    end process;

    global_clk: process
    begin
        while finished/='1' loop
            clk<='0';
            wait for period_time/2;
            clk<='1';
            wait for period_time/2;
        end loop;
        wait;
    end process;

    main_process: process
    begin
        wait;
        
    end process;
end architecture;
