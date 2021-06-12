vcom datamemory.vhd
vsim work.datamemory
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datamemory/Clock
add wave -noupdate -radix binary /datamemory/Mem_Read
add wave -noupdate -radix binary /datamemory/Mem_Write
add wave -noupdate -radix hexadecimal /datamemory/Address
add wave -noupdate -radix hexadecimal /datamemory/Write_Data
add wave -noupdate -radix hexadecimal /datamemory/Read_Data
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
force -freeze sim:/datamemory/Clock 0 0, 1 {50 ps} -r 100
force -freeze sim:/datamemory/Mem_Read 0 0
force -freeze sim:/datamemory/Mem_Write 0 0
force -freeze sim:/datamemory/Address 16'h0 0
force -freeze sim:/datamemory/Write_Data 16'h1 0
run
force -freeze sim:/datamemory/Mem_Write 1 0
run
run
force -freeze sim:/datamemory/Address 16'h5 0
force -freeze sim:/datamemory/Write_Data 16'h2 0
run
force -freeze sim:/datamemory/Mem_Read 1 0
force -freeze sim:/datamemory/Mem_Write 0 0
run
force -freeze sim:/datamemory/Mem_Write 1 0
force -freeze sim:/datamemory/Write_Data 16'h3 0
run
run