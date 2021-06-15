LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Mem_WB IS
	PORT (
		Clock, Reset, WriteEnable : IN STD_LOGIC;
		RdstIndex_In : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		ControlSignals_In : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
		PC_In, AluOutput_In, MemOutput_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_Out, AluOutput_Out, MemOutput_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ControlSignals_Out : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
		WriteBackIndex_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END Mem_WB;

ARCHITECTURE Mem_WB_Arch OF Mem_WB IS BEGIN

	PROCESS (Clock, Reset, WriteEnable)BEGIN

		IF Reset = '1' THEN
			MemOutput_Out <= (OTHERS => '0');
			PC_Out <= (OTHERS => '0');
			AluOutput_Out <= (OTHERS => '0');
			ControlSignals_Out <= (OTHERS => '0');
			WriteBackIndex_out <= (OTHERS => '0');

		ELSIF Rising_edge(Clock) AND WriteEnable = '1' THEN
			MemOutput_Out <= MemOutput_In;
			PC_Out <= PC_In;
			AluOutput_Out <= AluOutput_In;
			ControlSignals_Out <= ControlSignals_In;
			WriteBackIndex_out <= RdstIndex_In;
		END IF;
	END PROCESS;
END Mem_WB_Arch;