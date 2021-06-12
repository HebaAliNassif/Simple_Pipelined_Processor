vcom controlunit.vhd
vsim work.controlunit
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /controlunit/OpCode
add wave -noupdate -radix binary /controlunit/Reset
add wave -noupdate -radix binary /controlunit/ControlSignals
add wave -noupdate -radix binary /controlunit/CSTemp
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
WaveRestoreZoom {396 ps} {716 ps}
force -freeze sim:/controlunit/OpCode 000000 0
force -freeze sim:/controlunit/Reset 0 0
run
force -freeze sim:/controlunit/OpCode 000001 0
run
force -freeze sim:/controlunit/OpCode 000010 0
run
force -freeze sim:/controlunit/OpCode 000011 0
run
force -freeze sim:/controlunit/OpCode 000100 0
run
force -freeze sim:/controlunit/OpCode 000101 0
run
force -freeze sim:/controlunit/OpCode 000110 0
run
force -freeze sim:/controlunit/OpCode 000111 0
run
force -freeze sim:/controlunit/OpCode 001000 0
run
force -freeze sim:/controlunit/OpCode 001001 0
run
force -freeze sim:/controlunit/OpCode 001010 0
run
force -freeze sim:/controlunit/OpCode 001011 0
run
force -freeze sim:/controlunit/OpCode 001100 0
run
force -freeze sim:/controlunit/OpCode 001101 0
run
force -freeze sim:/controlunit/OpCode 001110 0
run
force -freeze sim:/controlunit/OpCode 001111 0
run
force -freeze sim:/controlunit/OpCode 010000 0
run
force -freeze sim:/controlunit/OpCode 010001 0
run
force -freeze sim:/controlunit/OpCode 010010 0
run
force -freeze sim:/controlunit/OpCode 010011 0
run
force -freeze sim:/controlunit/OpCode 010100 0
run
force -freeze sim:/controlunit/OpCode 010101 0
run
force -freeze sim:/controlunit/OpCode 010110 0
run
force -freeze sim:/controlunit/OpCode 010111 0
run
force -freeze sim:/controlunit/OpCode 011000 0
run
force -freeze sim:/controlunit/OpCode 011001 0
run
force -freeze sim:/controlunit/OpCode 011010 0
run
force -freeze sim:/controlunit/Reset 1 0
run