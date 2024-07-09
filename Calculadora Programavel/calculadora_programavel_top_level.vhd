library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity calculadora_programavel_top_level is
    port(
        reset: in std_logic;
        clk: in std_logic;
        estado: out unsigned(1 downto 0);
        data_out_pc: out unsigned(6 downto 0);
        data_out_reg_instrucao: out unsigned(15 downto 0);
        data_out_banco_registrador: out unsigned(15 downto 0); --banco de registrador
        data_out_acumulador_ula: out unsigned(15 downto 0); --registrador externo
        data_out_ula: out unsigned(15 downto 0)
    );
end entity calculadora_programavel_top_level;

architecture a_calculadora_programavel_top_level of calculadora_programavel_top_level is
    
    component acumulador_ula is
        port(
            clk: in std_logic;
            reset: in std_logic;
            wr_en: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;

    component banco_registradores is
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
    end component;
    
    component control_unit is
        port(
            estado: in unsigned(1 downto 0);
            instruction: in unsigned(15 downto 0);
            clk: in std_logic;
            reset: in std_logic;
            rd_en_rom: out std_logic;
            rd_en_banco_registradores: out std_logic;
            jump_enable: out std_logic;
            wr_en_reg_instrucao: out std_logic;
            wr_en_acumulador_ula: out std_logic;
            wr_en_registradores: out std_logic;
            operador_registrador: out std_logic;
            operador_acumulador_ula: out unsigned(1 downto 0);
            operador_mux_banco_registradores: out unsigned(1 downto 0);
            operador_ula: out unsigned(1 downto 0)
        );
    end component;
    
    component maq_estados is
        port(
            clk: in std_logic;
            rst: in std_logic;
            estado: out unsigned(1 downto 0)
        );
    end component;
    
    component pc is
        port(
            rst: in std_logic;
            clk: in std_logic;
            wr_en: in std_logic;
            data_in: in unsigned(6 downto 0);
            data_out: out unsigned(6 downto 0)
        );
    end component;
    
    component registrador_instrucao is
        port(
            clk: in std_logic;
            instruction: in unsigned(15 downto 0);
            inst_wr: in std_logic;
            data: out unsigned(15 downto 0)
        );
    end component;
    
    component rom is
        port(
            clk: in std_logic;
            rd_en: in std_logic;
            endereco: in unsigned(6 downto 0);
            dado: out unsigned(15 downto 0);
            exception: out std_logic
        );
    end component;
    
    component ula is
        port(
            in_a: in unsigned(15 downto 0);
            in_b: in unsigned(15 downto 0);
            op_selector: in unsigned(1 downto 0);
            resultado: out unsigned(15 downto 0);
            overflow_flag: out std_logic;
            carry_flag: out std_logic
        );
    end component;

    
    signal wr_en_acumulador_ula_s: std_logic;
    signal data_in_acumulador_ula_s: unsigned(15 downto 0);
    signal data_out_acumulador_ula_s: unsigned(15 downto 0);
    signal wr_en_banco_registradores_s: std_logic;
    signal rd_en_banco_registradores_s: std_logic;
    signal instruction_s: unsigned(15 downto 0);
    signal mux_data_banco_registradores_s: unsigned(15 downto 0);
    signal data_out_banco_registradores_s: unsigned(15 downto 0);
    signal estado_s: unsigned(1 downto 0);
    signal rd_en_rom_s: std_logic;
    signal jump_en_s: std_logic;
    signal wr_en_reg_instrucao_s: std_logic;
    signal operador_registrador_s: std_logic;
    signal operador_acumulador_ula: unsigned(1 downto 0);
    signal operador_mux_banco_registradores_s: unsigned(1 downto 0);
    signal operador_ula_s: unsigned(1 downto 0);
    signal pc_wr_s: std_logic;
    signal data_in_pc_s: unsigned(6 downto 0);
    signal data_out_pc_s: unsigned(6 downto 0);
    signal rom_data_s: unsigned(15 downto 0);
    signal exception_s: std_logic;
    signal operando_b_s: unsigned(15 downto 0);
    signal resultado_s: unsigned(15 downto 0);
    signal overflow_flag_s: std_logic;
    signal carry_flag_s: std_logic;
    signal imm_signal: std_logic;
    signal imm_extended: unsigned(15 downto 0);

    
begin
    
    acumulador_ula0: acumulador_ula port map(
        clk => clk,
        reset => reset,
        wr_en => wr_en_acumulador_ula_s,
        data_in => data_in_acumulador_ula_s,
        data_out => data_out_acumulador_ula_s
    );

    banco_registradores0: banco_registradores port map(
        clk => clk,
        rst => reset,
        write_enable => wr_en_banco_registradores_s,
        read_enable => rd_en_banco_registradores_s,
        read_registrador => instruction_s(10 downto 8),
        reg_write_address => instruction_s(10 downto 8),
        reg_write_data => mux_data_banco_registradores_s,
        data_out_registrador => data_out_banco_registradores_s
    );
    
    control_unit0: control_unit port map(
        estado => estado_s,
        instruction => instruction_s,
        clk => clk,
        reset => reset,
        rd_en_rom => rd_en_rom_s,
        rd_en_banco_registradores => rd_en_banco_registradores_s,
        jump_enable => jump_en_s,
        wr_en_reg_instrucao => wr_en_reg_instrucao_s,
        wr_en_acumulador_ula => wr_en_acumulador_ula_s,
        wr_en_registradores => wr_en_banco_registradores_s,
        operador_registrador => operador_registrador_s,
        operador_acumulador_ula => operador_acumulador_ula,
        operador_mux_banco_registradores => operador_mux_banco_registradores_s,
        operador_ula => operador_ula_s
    );

    maq_estados0: maq_estados port map(
        clk => clk,
        rst => reset,
        estado => estado_s
    );

    pc0: pc port map(
        rst => reset,
        clk => clk,
        wr_en => pc_wr_s,
        data_in => data_in_pc_s,
        data_out => data_out_pc_s
    );

    registrador_instrucao0: registrador_instrucao port map(
        clk => clk,
        instruction => rom_data_s,
        inst_wr => wr_en_reg_instrucao_s,
        data => instruction_s
    );

    rom0: rom port map(
        clk => clk,
        rd_en => rd_en_rom_s,
        endereco => data_out_pc_s,
        dado =>rom_data_s,
        exception => exception_s
    );

    ula0: ula port map(
        in_a => data_out_acumulador_ula_s, --operando A será o acumulador
        in_b => operando_b_s, --operando B banco de registradores ou cte
        op_selector => operador_ula_s,
        resultado => resultado_s,
        overflow_flag => overflow_flag_s,
        carry_flag => carry_flag_s
    );
   
    
    --extensão de sinal
    imm_signal<=instruction_s(6);
    imm_extended<=imm_signal&imm_signal&imm_signal&imm_signal&imm_signal&
    imm_signal&imm_signal&imm_signal&imm_signal&imm_signal&
    instruction_s(5 downto 0);
    
    --operando A ula ------------
     --Mux de entrada para acumulador ULA ---
    data_in_acumulador_ula_s <= resultado_s when operador_acumulador_ula = "00" else --saida ula ADD A, REG
    imm_extended when operador_acumulador_ula = "10" else --LD A, cte
    data_out_banco_registradores_s when operador_acumulador_ula = "01" else -- MOV A <- REG
    "0000000000000000";

    --Mux entrada do banco de registradores --
    mux_data_banco_registradores_s <= imm_extended when operador_mux_banco_registradores_s = "10" else--LD REG, cte
    data_out_acumulador_ula_s when operador_mux_banco_registradores_s = "01" else --MOV REG <- A
    "0000000000000000";
    -----------------------------
    --operando B ula ------------
    operando_b_s <= data_out_banco_registradores_s when operador_registrador_s = '1' else
    imm_extended when operador_registrador_s = '0' else
    "0000000000000000";
    -----------------------------
    
    -- PC -----------------------
    pc_wr_s <= '1' when (estado_s = "10" and jump_en_s='1') or
    (estado_s = "10" and jump_en_s='0' ) else
    '0';
    
    data_in_pc_s <=instruction_s(6 downto 0) when jump_en_s='1' else
    data_out_pc_s + 1;
    -----------------------------
    
    estado <= estado_s;
    data_out_pc <= data_out_pc_s;
    data_out_reg_instrucao <= instruction_s;
    data_out_banco_registrador <= data_out_banco_registradores_s;
    data_out_acumulador_ula <= data_out_acumulador_ula_s;
    data_out_ula <= resultado_s;
    
end architecture a_calculadora_programavel_top_level;