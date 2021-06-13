vcom registerFile.vhd
vsim -gui work.registerfile

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /registerfile/clk
add wave -noupdate /registerfile/enable
add wave -noupdate /registerfile/readData1
add wave -noupdate /registerfile/readData2
add wave -noupdate /registerfile/readIndex1
add wave -noupdate /registerfile/readIndex2
add wave -noupdate /registerfile/registers
add wave -noupdate /registerfile/rst
add wave -noupdate /registerfile/writeData
add wave -noupdate /registerfile/writeIndex
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {68 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {1061 ps}


force -freeze sim:/registerfile/clk 1 0, 0 {50 ps} -r 100

force -freeze sim:/registerfile/rst 1 0
run
force -freeze sim:/registerfile/rst 0 0
run

force -freeze sim:/registerfile/enable 1 0

force -freeze sim:/registerfile/writeData 16#BAA00FF0 0
force -freeze sim:/registerfile/writeIndex 001 0
run

force -freeze sim:/registerfile/enable 0 0

force -freeze sim:/registerfile/readIndex1 111 0
force -freeze sim:/registerfile/readIndex2 001 0
run


