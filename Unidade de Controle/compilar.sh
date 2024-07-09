ghdl -a pc.vhd
ghdl -e pc

ghdl -a rom.vhd
ghdl -e rom

ghdl -a t_ff.vhd
ghdl -e t_ff

ghdl -a control_unit.vhd
ghdl -e control_unit

ghdl -a control_unit_top_level.vhd
ghdl -e control_unit_top_level

ghdl -a control_unit_top_level_tb.vhd
ghdl -e control_unit_top_level_tb

ghdl -r control_unit_top_level_tb --wave=control_unit_top_level_tb.ghw

gtkwave control_unit_top_level_tb.ghw