library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity banco_registradores_ula is
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
end entity;

architecture a_banco_registradores_ula of banco_registradores_ula is
    component banco_registradores
    port(
        clk: in std_logic;
        rst: in std_logic;
        write_enable: in std_logic;
        sel_reg_1: in unsigned(2 downto 0);
        sel_reg_2: in unsigned(2 downto 0);
        sel_reg_write: in unsigned(2 downto 0);
        data_write: in unsigned(15 downto 0);
        data_out_reg_1: out unsigned(15 downto 0);
        data_out_reg_2: out unsigned(15 downto 0)
    );
end component;

component ula
port(
    in_a: in unsigned(15 downto 0);
    in_b: in unsigned(15 downto 0);
    op_selector: in unsigned(1 downto 0);
    resultado: out unsigned(15 downto 0);
    overflow_flag: out std_logic;
    carry_flag: out std_logic
);
end component;

signal resultado_ula_sinal: unsigned(15 downto 0);
signal data_out_reg_1: unsigned(15 downto 0);
signal data_out_reg_2: unsigned(15 downto 0);
signal operando_b: unsigned(15 downto 0);

begin
    banco_registradores_uut: banco_registradores port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable ,
        sel_reg_1 => sel_reg_1,
        sel_reg_2 => sel_reg_2,
        sel_reg_write => sel_reg_write,
        data_write => resultado_ula_sinal,
        data_out_reg_1 => data_out_reg_1,
        data_out_reg_2 => data_out_reg_2
    );

    ula_uut: ula port map(
        in_a => data_out_reg_1, --sempre será a saída do registrador
        in_b => operando_b, --MUX recebe registrador ou constante
        resultado => resultado_ula_sinal,
        op_selector => ula_op_selector
    );

    --mux para o operando b: escolho entre a saida do registrador e a carga de uma constante
    operando_b <= data_out_reg_2 when operador_b_selector = '0' else
    operando_b_constante when operador_b_selector = '1' else
        "0000000000000000";

    resultado_ula <= resultado_ula_sinal;
end architecture;