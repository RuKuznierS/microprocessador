ghdl -a ula.vhd
ghdl -e ula

ghdl -a reg16bits.vhd
ghdl -e reg16bits

ghdl -a banco_registradores.vhd
ghdl -e banco_registradores

ghdl -a banco_registradores_ula.vhd
ghdl -e banco_registradores_ula

ghdl -a banco_registradores_ula_tb.vhd
ghdl -e banco_registradores_ula_tb

ghdl -r banco_registradores_ula_tb --wave=banco_registradores_ula_tb.ghw

gtkwave banco_registradores_ula_tb.ghw