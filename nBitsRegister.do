vcom nBitsRegister.vhd
vsim -gui work.nbitsregister

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /nbitsregister/clk
add wave -noupdate /nbitsregister/d
add wave -noupdate /nbitsregister/enable
add wave -noupdate /nbitsregister/q
add wave -noupdate /nbitsregister/rst
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {327 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {1214 ps}


force -freeze sim:/nbitsregister/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/nbitsregister/d 16#F0F00FF0 0
force -freeze sim:/nbitsregister/enable 1 0
run

force -freeze sim:/nbitsregister/rst 1 0
run

force -freeze sim:/nbitsregister/rst 0 0
run