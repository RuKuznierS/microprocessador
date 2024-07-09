ghdl -a ula.vhd
ghdl -e ula

ghdl -a reg16bits.vhd
ghdl -e reg16bits

ghdl -a banco_registradores.vhd
ghdl -e banco_registradores

ghdl -a acumulador_ula.vhd
ghdl -e acumulador_ula

ghdl -a control_unit.vhd
ghdl -e control_unit

ghdl -a maq_estados.vhd
ghdl -e maq_estados

ghdl -a pc.vhd
ghdl -e pc

ghdl -a registrador_instrucao.vhd
ghdl -e registrador_instrucao

ghdl -a registrador_carry.vhd
ghdl -e registrador_carry

ghdl -a registrador_blt.vhd
ghdl -e registrador_blt

ghdl -a rom.vhd
ghdl -e rom

ghdl -a calculadora_programavel_top_level.vhd
ghdl -e calculadora_programavel_top_level

ghdl -a calculadora_programavel_top_level_tb.vhd
ghdl -e calculadora_programavel_top_level_tb

ghdl -r calculadora_programavel_top_level_tb --wave=calculadora_programavel_top_level_tb.ghw

gtkwave calculadora_programavel_top_level_tb.ghw