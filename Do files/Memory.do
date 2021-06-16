vsim -gui work.processor
mem load -i {Memory.mem} /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory
add wave -position insertpoint  \
sim:/processor/Clock \
sim:/processor/Reset \
sim:/processor/ResetSignal \
sim:/processor/InPort \
sim:/processor/OutPort \
sim:/processor/CCR_C \
sim:/processor/CCR_N \
sim:/processor/CCR_Z
force -freeze sim:/processor/Clock 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/Reset 1 0
run
force -freeze sim:/processor/Reset 0 0

force -freeze sim:/processor/InPort 16'h19 0
run
run
run
force -freeze sim:/processor/InPort 16'hFFFF 0
run
force -freeze sim:/processor/InPort 16'hF320 0
run
force -freeze sim:/processor/InPort 16'h10 0
run



