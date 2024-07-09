library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity banco_registradores is
    port(
        clk : in std_logic;
        rst : in std_logic;
        write_enable : in std_logic;
        
        sel_reg_1 : in unsigned(2 downto 0);
        sel_reg_2 : in unsigned(2 downto 0);
        
        sel_reg_write : in unsigned(2 downto 0); --em qual registrador escrever
        data_write : in unsigned(15 downto 0); -- valor que será escrito
        data_out_reg_1 : out unsigned(15 downto 0); --saida registrador 1
        data_out_reg_2 : out unsigned(15 downto 0) --saida registrador 2
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

    signal read_data_out_reg_1: unsigned (15 downto 0);
    signal read_data_out_reg_2: unsigned (15 downto 0);

begin
   
    reg0: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(0),
        data_in => "0000000000000000",
        data_out => data_out_0
    );

    reg1: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(1),
        data_in => data_write,
        data_out => data_out_1
    );

    reg2: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(2),
        data_in => data_write,
        data_out => data_out_2
    );

    reg3: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(3),
        data_in => data_write,
        data_out => data_out_3
    );
    
    reg4: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(4),
        data_in => data_write,
        data_out => data_out_4
    );

    reg5: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(5),
        data_in => data_write,
        data_out => data_out_5
    );

    reg6: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(6),
        data_in => data_write,
        data_out => data_out_6
    );

    reg7: reg16bits port map(
        clk => clk,
        reset => rst,
        wr_en => wr_en_signal(7),
        data_in => data_write,
        data_out => data_out_7
    );

    wr_en_signal(0) <= '1' when sel_reg_write="000" and write_enable='1' else
    '0';
    wr_en_signal(1) <= '1' when sel_reg_write="001" and write_enable='1' else
    '0';
    wr_en_signal(2) <= '1' when sel_reg_write="010" and write_enable='1' else
    '0';
    wr_en_signal(3) <= '1' when sel_reg_write="011" and write_enable='1' else
    '0';
    wr_en_signal(4) <= '1' when sel_reg_write="100" and write_enable='1' else
    '0';
    wr_en_signal(5) <= '1' when sel_reg_write="101" and write_enable='1' else
    '0';
    wr_en_signal(6) <= '1' when sel_reg_write="110" and write_enable='1' else
    '0';
    wr_en_signal(7) <= '1' when sel_reg_write="111" and write_enable='1' else
    '0';
    
    data_out_reg_1 <=   data_out_0 when sel_reg_1="000" else
    data_out_1 when sel_reg_1="001" else
    data_out_2 when sel_reg_1="010" else
    data_out_3 when sel_reg_1="011" else
    data_out_4 when sel_reg_1="100" else
    data_out_5 when sel_reg_1="101" else
    data_out_6 when sel_reg_1="110" else
    data_out_7 when sel_reg_1="111" else
                        "0000000000000000";
    
    data_out_reg_2 <=   data_out_0 when sel_reg_2="000" else
    data_out_1 when sel_reg_2="001" else
    data_out_2 when sel_reg_2="010" else
    data_out_3 when sel_reg_2="011" else
    data_out_4 when sel_reg_2="100" else
    data_out_5 when sel_reg_2="101" else
    data_out_6 when sel_reg_2="110" else
    data_out_7 when sel_reg_2="111" else
                        "0000000000000000";

end architecture;