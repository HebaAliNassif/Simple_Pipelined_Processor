vsim -gui work.processor
mem load -i {memory.mem} /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory

add wave -position insertpoint  \
sim:/processor/Clock \
sim:/processor/Reset \
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
sim:/processor/RdstIndex_In_IE_MEM

mem load -filltype value -filldata 4000 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(0)

mem load -filltype value -filldata 4000 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(0)
mem load -filltype value -filldata 0400 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(0)
mem load -filltype value -filldata 8000 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(2)
mem load -filltype value -filldata 0800 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(2)
mem load -filltype value -filldata 0C00 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(3)
mem load -filltype value -filldata 0C20 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(3)
mem load -filltype value -filldata 1020 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(4)
mem load -filltype value -filldata 1C20 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(5)
mem load -filltype value -filldata 1C40 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(6)
mem load -filltype value -filldata 0C40 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(7)
mem load -filltype value -filldata 1020 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(8)
mem load -filltype value -filldata 1440 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(9)
mem load -filltype value -filldata 1820 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(10)
mem load -filltype value -filldata 1840 -fillradix hexadecimal /processor/fetchStageExc/INSTRUCTION_MEMORY/Memory(11)

force -freeze sim:/processor/Clock 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/Reset 1 0

run
force -freeze sim:/processor/Reset 0 0
