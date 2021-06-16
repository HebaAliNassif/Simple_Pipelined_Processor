vsim -gui work.processor
mem load -i {Branch.mem} /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory
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


force -freeze sim:/processor/InPort 16'h30 0
run
run
run
force -freeze sim:/processor/InPort 16'h50  0
run
force -freeze sim:/processor/InPort 16'h100 0
run
force -freeze sim:/processor/InPort 16'h300 0
run
force -freeze sim:/processor/InPort 16'h200 0
run
run
run