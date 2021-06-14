LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

Entity DataForward is
	port (
		RegWriteEnable, MemWriteEnable, MemToRegEnable : in std_logic;
		ReadDataIndex2_ID_IE, ReadDataIndex2_IE_Mem,ReadDataIndex2_Mem_WB, ReadDataIndex1_ID_IE: in std_logic_vector(2 downto 0);
		ReadDataIndex1_ID,ReadDataIndex2_ID : in std_logic_vector(2 downto 0);
        ALUOutput_IE_Mem, ALUOutput_Mem_WB, MemOutput_Mem_WB: in std_logic_vector(31 downto 0);
		ReadData1_Forward_Enable, ReadData2_Forward_Enable, StallEnable: out std_logic;
		ReadData1_Forward, ReadData2_Forward: out std_logic_vector(31 downto 0));
end DataForward;


Architecture DataForward_Arch of DataForward is begin

ReadData1_Forward_Enable <= '1' when (RegWriteEnable = '1' and ReadDataIndex2_IE_Mem = ReadDataIndex1_ID) or (MemWriteEnable = '1' and ReadDataIndex2_Mem_WB=ReadDataIndex1_ID)
else '0';

ReadData2_Forward_Enable <= '1' when (RegWriteEnable = '1' and ReadDataIndex2_ID_IE = ReadDataIndex2_IE_Mem) or (MemWriteEnable = '1' and ReadDataIndex2_ID_IE = ReadDataIndex2_Mem_WB)
else '0';


ReadData1_Forward <= ALUOutput_IE_Mem when (RegWriteEnable = '1' and ReadDataIndex1_ID = ReadDataIndex2_IE_Mem)
else ALUOutput_Mem_WB when (MemWriteEnable = '1' and ReadDataIndex1_ID = ReadDataIndex2_Mem_WB) and MemToRegEnable = '0'
else MemOutput_Mem_WB when (MemWriteEnable = '1' and ReadDataIndex1_ID = ReadDataIndex2_Mem_WB) and MemToRegEnable = '1'
else (OTHERS => '0');

ReadData2_Forward <= ALUOutput_IE_Mem when (RegWriteEnable = '1' and ReadDataIndex2_ID_IE = ReadDataIndex2_IE_Mem)
else ALUOutput_Mem_WB when (MemWriteEnable = '1' and ReadDataIndex2_ID_IE = ReadDataIndex2_Mem_WB) and MemToRegEnable = '0'
else MemOutput_Mem_WB when (MemWriteEnable = '1' and ReadDataIndex2_ID_IE = ReadDataIndex2_Mem_WB) and MemToRegEnable = '1'
else (OTHERS => '0');

StallEnable <= '1' when MemWriteEnable = '0' and (ReadDataIndex1_ID_IE = ReadDataIndex2_ID_IE  or ReadDataIndex2_ID = ReadDataIndex2_ID_IE)
else '0';

end DataForward_Arch;