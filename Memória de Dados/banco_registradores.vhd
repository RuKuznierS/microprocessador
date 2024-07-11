library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_registradores is
    port(
        clk : in std_logic;
        rst : in std_logic;
        write_enable : in std_logic;
        read_enable: in std_logic;
        read_registrador: in unsigned(2 downto 0);
        reg_write_address: in unsigned(2 downto 0);
        reg_write_data: in unsigned(15 downto 0);
        data_out_registrador : out unsigned(15 downto 0)
    );
end entity;

architecture a_banco_registradores of banco_registradores is
    component reg16bits is
        port(
            clk: in std_logic;
            reset: in std_logic;
            wr_en: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;

    signal wr_en_signal: std_logic_vector(7 downto 0);

    signal data_out_0: unsigned(15 downto 0);
    signal data_out_1: unsigned(15 downto 0);
    signal data_out_2: unsigned(15 downto 0);
    signal data_out_3: unsigned(15 downto 0);
    signal data_out_4: unsigned(15 downto 0);
    signal data_out_5: unsigned(15 downto 0);
    signal data_out_6: unsigned(15 downto 0);
    signal data_out_7: unsigned(15 downto 0);

begin
    reg0: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(0),
        data_in => "0000000000000000", --registrador zero com valores setados para 0
        data_out => data_out_0
    );

    reg1: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(1),
        data_in => reg_write_data,
        data_out => data_out_1
    );

    reg2: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(2),
        data_in => reg_write_data,
        data_out => data_out_2
    );

    reg3: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(3),
        data_in => reg_write_data,
        data_out => data_out_3
    );
    
    reg4: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(4),
        data_in => reg_write_data,
        data_out => data_out_4
    );

    reg5: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(5),
        data_in => reg_write_data,
        data_out => data_out_5
    );

    reg6: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(6),
        data_in => reg_write_data,
        data_out => data_out_6
    );

    reg7: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(7),
        data_in => reg_write_data,
        data_out => data_out_7
    );

    wr_en_signal(0) <= '1' when reg_write_address="000" and write_enable='1' else
    '0';
    wr_en_signal(1) <= '1' when reg_write_address="001" and write_enable='1' else
    '0';
    wr_en_signal(2) <= '1' when reg_write_address="010" and write_enable='1' else
    '0';
    wr_en_signal(3) <= '1' when reg_write_address="011" and write_enable='1' else
    '0';
    wr_en_signal(4) <= '1' when reg_write_address="100" and write_enable='1' else
    '0';
    wr_en_signal(5) <= '1' when reg_write_address="101" and write_enable='1' else
    '0';
    wr_en_signal(6) <= '1' when reg_write_address="110" and write_enable='1' else
    '0';
    wr_en_signal(7) <= '1' when reg_write_address="111" and write_enable='1' else
    '0';
    
    data_out_registrador <=     data_out_0 when (read_registrador="000" and read_enable='1') else
    data_out_1 when (read_registrador="001" and read_enable='1') else
    data_out_2 when (read_registrador="010" and read_enable='1') else
    data_out_3 when (read_registrador="011" and read_enable='1') else
    data_out_4 when (read_registrador="100" and read_enable='1') else
    data_out_5 when (read_registrador="101" and read_enable='1') else
    data_out_6 when (read_registrador="110" and read_enable='1') else
    data_out_7 when (read_registrador="111" and read_enable='1') else
                                "0000000000000000";
    

end architecture;