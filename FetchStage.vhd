LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FetchStage IS
	GENERIC (
		n : INTEGER := 32;
		SpaceSize : INTEGER := 1000);
	PORT (
		instruction, immediate : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		memoryLocationOfZero : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		branch, branch_return : IN STD_LOGIC;
		branch_address, branch_return_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		pc_out, pc_next : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Clock, Reset, ResetSignal : IN STD_LOGIC
	);
END FetchStage;
ARCHITECTURE ModelFetchStage OF FetchStage IS
	COMPONENT Memory IS
		GENERIC (
			n : INTEGER := 32;
			SpaceSize : INTEGER := 1000);
		PORT (
			Clock, Mem_Write, Reset : IN STD_LOGIC;
			Address : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			Write_Data : IN STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
			Read_Data : OUT STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
			FirstLocationValue :  OUT STD_LOGIC_VECTOR((n - 1) DOWNTO 0)
		);
	END COMPONENT;
	SIGNAL Mem_Write : STD_LOGIC := '0';
	SIGNAL Address, Write_Data, Read_Data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
	INSTRUCTION_MEMORY : Memory GENERIC MAP(n, SpaceSize) PORT MAP(Clock, Mem_Write, Reset, Address, Write_Data, Read_Data);

	PROCESS (Clock)
	BEGIN
		IF falling_edge(Clock) AND Reset = '0' THEN
			Address <= pc;
		END IF;
	END PROCESS;

	pc_next <= x"00000000"  WHEN ResetSignal = '1' --& memoryLocationOfZero
		ELSE
		branch_address WHEN branch = '1'
		ELSE
		branch_return_address WHEN branch_return = '1'
		ELSE
		STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(pc)) + 2, pc_next'length)) WHEN Read_Data(31 DOWNTO 26) = "001010"
		OR Read_Data(31 DOWNTO 26) = "010010"
		OR Read_Data(31 DOWNTO 26) = "010011"
		OR Read_Data(31 DOWNTO 26) = "010100"
		ELSE
		STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(pc)) + 1, pc_next'length));
	pc_out <= pc;
	instruction <= Read_Data(31 DOWNTO 16);
	immediate <= Read_Data(15 DOWNTO 0);
END ARCHITECTURE;