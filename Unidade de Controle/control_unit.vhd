library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port(
        instruction: in unsigned(15 downto 0);
        clk: in std_logic;
        reset: in std_logic;
        rd_en: out std_logic;
        pc_wr: out std_logic;
        jump_enable: out std_logic;
        jump_address: out unsigned(6 downto 0)
    );
end entity;

architecture a_control_unit of control_unit is
    component t_ff
    port(
        t: in std_logic;
        clk: in std_logic;
        reset: in std_logic;
        state: out std_logic
    );
end component;

signal state_s: std_logic;
signal opcode_s: unsigned(3 downto 0);

begin
    t_ff0: t_ff port map(
        t => '1',
        clk => clk,
        reset => reset, --reset geral
        state => state_s
    );

    --leitura da rom no estado 0 (fetch)
    rd_en <= '1' when state_s='0' else --fetch
    '0';

    --atualiza pc no estado 1 (decode/execute)
    pc_wr <= '1' when state_s='1' else
    '0';

    -- opcode nos 4 bits MSB
    opcode_s<=instruction(15 downto 12);

    -- 1 quando os 4 bits MSB forem iguais a 1111
    jump_enable <=  '1' when opcode_s="1111"  else
    '0';

    -- endereco para salto
    jump_address<=instruction(6 downto 0);


end architecture;
