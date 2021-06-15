vsim -gui work.processor
mem load -i {TwoOperand.mem} /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory
view -new wave
add wave -position insertpoint  \
sim:/processor/Clock \
sim:/processor/Reset \
sim:/processor/ResetSignal \
sim:/processor/InPort \
sim:/processor/OutPort \
sim:/processor/sp \
sim:/processor/sp_next \
sim:/processor/sp_out_MEM \
sim:/processor/pc \
sim:/processor/pc_out_IF \
sim:/processor/pc_next_IF \
sim:/processor/pc_out_MEM \
sim:/processor/pc_out_IF_ID \
sim:/processor/pc_out_ID_IE \
sim:/processor/pc_out_IE_MEM \
sim:/processor/pc_out_MEM_WB \
sim:/processor/branch_address \
sim:/processor/branch_return_address \
sim:/processor/instruction_IF \
sim:/processor/immediate_IF \
sim:/processor/instruction_IF_ID \
sim:/processor/immediate_IF_ID \
sim:/processor/immediate_ID_IE \
sim:/processor/Stall \
sim:/processor/branch \
sim:/processor/branch_return \
sim:/processor/Enable_Buffers \
sim:/processor/memoryLocationOfZero \
sim:/processor/ControlSignals \
sim:/processor/ControlSignals_ID \
sim:/processor/ControlSignals_ID_IE \
sim:/processor/ControlSignals_IE_MEM \
sim:/processor/ControlSignals_MEM_WB \
sim:/processor/RegWriteEnable \
sim:/processor/PcWrite \
sim:/processor/SpWrite \
sim:/processor/WriteBackData \
sim:/processor/ExcutionDataOut \
sim:/processor/MemoryOut \
sim:/processor/WriteBackIndex \
sim:/processor/readData1_ID \
sim:/processor/readData2_ID \
sim:/processor/readData1_ID_IE \
sim:/processor/readData2_ID_IE \
sim:/processor/readData1_IE_MEM \
sim:/processor/readData2_IE_MEM \
sim:/processor/readData1_IE \
sim:/processor/readData2_IE \
sim:/processor/regReadDataIndex1_ID_IE \
sim:/processor/regReadDataIndex2_ID_IE \
sim:/processor/regReadDataIndex1_IE_MEM \
sim:/processor/regReadDataIndex2_IE_MEM \
sim:/processor/readData2IE_MEM \
sim:/processor/readData2IE_MEM_WB \
sim:/processor/ALUOutput_IE \
sim:/processor/ALUOutput_IE_MEM \
sim:/processor/ALUOutput_MEM_WB \
sim:/processor/MemOutput_MEM \
sim:/processor/MemOutput_MEM_WB \
sim:/processor/RdstIndex_In_IE_MEM \
sim:/processor/ReadData1_Forward_Enable \
sim:/processor/ReadData2_Forward_Enable \
sim:/processor/ReadData1_Forward_Value \
sim:/processor/ReadData2_Forward_Value \
sim:/processor/CCR \
sim:/processor/CCR_C \
sim:/processor/CCR_N \
sim:/processor/CCR_Z
force -freeze sim:/processor/Clock 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/Reset 1 0
run
force -freeze sim:/processor/Reset 0 0

force -freeze sim:/processor/InPort 16'h5 0
run
run
run
force -freeze sim:/processor/InPort 16'h19 0
run
force -freeze sim:/processor/InPort 16'hFFFFFFF 0
run
force -freeze sim:/processor/InPort 16'hFFFFF320 0
run
run
run

