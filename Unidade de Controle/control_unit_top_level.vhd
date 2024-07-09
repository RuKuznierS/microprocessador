library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit_top_level is
    port(
        clk: in std_logic;
        reset: in std_logic
    );
end entity;

architecture a_control_unit_top_level of control_unit_top_level is
    component t_ff
    port(
        t: in std_logic;
        clk: in std_logic;
        reset: in std_logic;
        state: out std_logic
    );
end component;

component control_unit
port(
    instruction: in unsigned(15 downto 0);
    clk: in std_logic;
    reset: in std_logic;
    rd_en: out std_logic;
    pc_wr: out std_logic;
    jump_enable: out std_logic;
    jump_address: out unsigned(6 downto 0)
);
end component;

component pc
port(
    rst: in std_logic;
    clk: in std_logic;
    wr_en: in std_logic;
    data_in: in unsigned(6 downto 0);
    data_out: out unsigned(6 downto 0)
);
end component;

component rom is
    port(
        clk: in std_logic;
        rd_en: in std_logic;
        endereco: in unsigned(6 downto 0);
        dado: out unsigned(15 downto 0)
    );
end component;


signal state_s: std_logic;
signal pc_wr_s: std_logic;
signal rd_en_s: std_logic;
signal opcode_s: unsigned(3 downto 0); --4 bits
signal data_in_pc_s: unsigned(6 downto 0);
signal data_out_pc_s: unsigned(6 downto 0);
signal data_out_rom_s: unsigned(15 downto 0);
signal jump_enable_s: std_logic;
signal jump_address_s: unsigned(6 downto 0);
begin
    
    control_unit0: control_unit port map(
        instruction => data_out_rom_s,
        clk => clk,
        reset => reset, --reset global
        rd_en => rd_en_s,
        pc_wr => pc_wr_s,
        jump_enable => jump_enable_s,
        jump_address => jump_address_s
    );
    
    t_ff0: t_ff port map(
        t => '1',
        clk => clk,
        reset => reset, --reset global
        state => state_s
    );

    pc0: pc
    port map (
        rst => reset, --reset global
        clk => clk,
        wr_en => pc_wr_s,
        data_in => data_in_pc_s,
        data_out => data_out_pc_s
    );


    rom0: rom
    port map (
        clk => clk,
        rd_en => rd_en_s,
        endereco => data_out_pc_s,
        dado => data_out_rom_s
    );

    -- atualização do pc ---
    data_in_pc_s <= data_out_pc_s + "0000001" when jump_enable_s = '0' else
    jump_address_s when jump_enable_s = '1' else
    "0000000";

end architecture;
