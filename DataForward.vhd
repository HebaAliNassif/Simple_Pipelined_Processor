LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY DataForward IS
	PORT (
		RegWriteEnable_IE_MEM, RegWriteEnable_MEM_WB, MemToRegEnable_MEM_WB, MemRead_ID_IE : IN STD_LOGIC;
		ReadDataIndex2_ID_IE, ReadDataIndex2_IE_Mem, ReadDataIndex2_Mem_WB, ReadDataIndex1_ID_IE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		ReadDataIndex1_ID, ReadDataIndex2_ID : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ALUOutput_IE_Mem, ALUOutput_Mem_WB, MemOutput_Mem_WB: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ReadData1_Forward_Enable, ReadData2_Forward_Enable, StallEnable: OUT STD_LOGIC;
		ReadData1_Forward, ReadData2_Forward: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END DataForward;

ARCHITECTURE arch_DataForward OF DataForward IS
BEGIN

ReadData1_Forward_Enable <= '1' WHEN (RegWriteEnable_IE_MEM = '1' AND ReadDataIndex2_Mem_WB = ReadDataIndex2_ID_IE) OR (RegWriteEnable_MEM_WB = '1' AND ReadDataIndex2_Mem_WB = ReadDataIndex2_IE_Mem)
ELSE '0';

ReadData2_Forward_Enable <= '1' WHEN (RegWriteEnable_IE_MEM = '1' AND ReadDataIndex1_ID_IE = ReadDataIndex2_ID_IE) OR (RegWriteEnable_MEM_WB = '1' AND ReadDataIndex1_ID_IE = ReadDataIndex2_IE_Mem)
ELSE '0';


ReadData1_Forward <= ALUOutput_IE_Mem WHEN (RegWriteEnable_IE_MEM = '1' AND ReadDataIndex2_Mem_WB = ReadDataIndex2_ID_IE)
ELSE ALUOutput_Mem_WB WHEN (RegWriteEnable_MEM_WB = '1' AND ReadDataIndex2_Mem_WB = ReadDataIndex2_IE_Mem) AND MemToRegEnable_MEM_WB = '0'
ELSE MemOutput_Mem_WB WHEN (RegWriteEnable_MEM_WB = '1' AND ReadDataIndex2_Mem_WB = ReadDataIndex2_IE_Mem) AND MemToRegEnable_MEM_WB = '1'
ELSE (OTHERS => '0');

ReadData2_Forward <= ALUOutput_IE_Mem WHEN (RegWriteEnable_IE_MEM = '1' AND ReadDataIndex1_ID_IE = ReadDataIndex2_ID_IE)
ELSE ALUOutput_Mem_WB WHEN (RegWriteEnable_MEM_WB = '1' AND ReadDataIndex1_ID_IE = ReadDataIndex2_IE_Mem) AND MemToRegEnable_MEM_WB = '0'
ELSE MemOutput_Mem_WB WHEN (RegWriteEnable_MEM_WB = '1' AND ReadDataIndex1_ID_IE = ReadDataIndex2_IE_Mem) AND MemToRegEnable_MEM_WB = '1'
ELSE (OTHERS => '0');

StallEnable <= '1' WHEN MemRead_ID_IE = '1' AND (ReadDataIndex1_ID = ReadDataIndex1_ID_IE  OR ReadDataIndex2_ID = ReadDataIndex1_ID_IE)
ELSE '0';

END arch_DataForward;