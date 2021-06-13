vcom memory.vhd
vsim work.memory
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory/Clock
add wave -noupdate -radix binary /memory/Mem_Write
add wave -noupdate -radix hexadecimal /memory/Reset
add wave -noupdate -radix hexadecimal /memory/Address
add wave -noupdate -radix hexadecimal /memory/Write_Data
add wave -noupdate -radix hexadecimal /memory/Read_Data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
force -freeze sim:/memory/Clock 1 0, 0 {50 ps} -r 100
force -freeze sim:/memory/Mem_Write 1 0
force -freeze sim:/memory/Reset 0 0
force -freeze sim:/memory/Address 16'h0 0
force -freeze sim:/memory/Write_Data 16'h1 0
run
force -freeze sim:/memory/Address 16'h5 0
force -freeze sim:/memory/Write_Data 16'h2 0
run
force -freeze sim:/memory/Write_Data 16'h3 0
run