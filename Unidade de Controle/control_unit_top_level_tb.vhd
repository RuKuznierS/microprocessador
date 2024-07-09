library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit_top_level_tb is
end entity;

architecture a_control_unit_top_level_tb of control_unit_top_level_tb is
    component control_unit_top_level
    port(
        clk: in std_logic;
        reset: in std_logic
    );
end component;

constant period_time: time :=40 ns;
signal finished: std_logic :='0';
signal clk: std_logic;
signal rst: std_logic;

begin
    uut: control_unit_top_level port map(
        clk => clk,
        reset => rst
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
        wait for 1 us;
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
