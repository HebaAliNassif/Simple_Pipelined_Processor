LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

Entity Mem_WB is
port (
Clock, Reset,WriteEnable : in std_logic;
RdstIndex_In  : in std_logic_vector(2 downto 0);
ControlSignals_In : in std_logic_vector(18 downto 0);
PC_In, AluOutput_In, MemOutput_In   : in std_logic_vector(31 downto 0);
PC_Out, AluOutput_Out, MemOutput_Out  : out std_logic_vector(31 downto 0);
ControlSignals_Out : out std_logic_vector(18 downto 0);
WriteBackIndex_out : out std_logic_vector(2 downto 0)
);
end Mem_WB;

Architecture Mem_WB_Arch of Mem_WB is begin

process (Clock,Reset,WriteEnable)begin

if Reset = '1' then
	MemOutput_Out<= (others => '0');
	PC_Out<= (others => '0');
	AluOutput_Out<= (others => '0');
	ControlSignals_Out<= (others => '0');
        WriteBackIndex_out<= (others => '0');
	
elsif Rising_edge(Clock) and WriteEnable = '1' then
	MemOutput_Out<= MemOutput_In;
	PC_Out<= PC_In;
	AluOutput_Out<= AluOutput_In;
	ControlSignals_Out<= ControlSignals_In;
        WriteBackIndex_out<= RdstIndex_In;
end if;
end process;
end Mem_WB_Arch;