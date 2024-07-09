library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port(
        in_a: in unsigned(15 downto 0);
        in_b: in unsigned(15 downto 0);
        op_selector: in unsigned(1 downto 0);
        resultado: out unsigned(15 downto 0);
        overflow_flag: out std_logic;
        carry_flag: out std_logic
    );
end entity ula;

architecture a_ula of ula is
    signal  soma, subtracao, operacao_and, operacao_or: unsigned(15 downto 0);
    signal in_a_17,in_b_17,soma_17: unsigned(16 downto 0);
    signal overflow_sinal, overflow_soma, overflow_subtracao, overflow_and, overflow_or: unsigned(16 downto 0);
    signal carry_soma, carry_subtr: std_logic;
begin
 -- operacoes unsigned -------
    soma <= in_a + in_b;
    subtracao <= in_a - in_b;
    operacao_and <= in_a and in_b;
    operacao_or <= in_a or in_b;
    
    resultado  <=  soma    when    op_selector="00" else
    subtracao    when    op_selector="01" else
    operacao_and    when    op_selector="10" else
    operacao_or    when    op_selector="11" else
    "0000000000000000";
    ------------------------------
    
    -- FLAGS ----
     --carry---
    in_a_17 <= '0' & in_a;      -- passamos in_a para 17 bits
    in_b_17 <= '0' & in_b;      -- idem in_b
    soma_17 <= in_a_17+in_b_17;
    
    -------------------------
    carry_soma <= soma_17(16);  -- o carry eh o MSB da soma 17 bits
    
    carry_subtr <= '0' when in_b<=in_a else
    '1';
    
    -- MUX para flag carry ---
    carry_flag <= carry_soma when op_selector="00" else
    carry_subtr when op_selector="01" else
    '0';
    -------------------------

    --overflow---
    overflow_soma<=('0' & in_a) + ('0' & in_b);
    overflow_subtracao<=('0' & in_b) - ('0' & in_a);
    overflow_and<=('0' & in_a) and ('0' & in_b);
    overflow_or<=('0' & in_a) or ('0' & in_b);
    
    overflow_sinal <=   overflow_soma when op_selector="00" else
    overflow_subtracao when op_selector="01" else
    overflow_and when op_selector="10" else
    overflow_or when op_selector="11" else
                       "00000000000000000";
    
    -- MUX para flag overflow ---
    overflow_flag <= '1' when overflow_sinal="10000000000000000" else
    '0';
    -------------
    

end architecture a_ula;