LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ExecutionStage IS
	PORT (
		Clock, Reset : IN STD_LOGIC;
		Rsrc_In, Rdst_In ,InPort: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Immediate : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		ControlSignals : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
		AluOutput : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		BranchEnable : OUT STD_LOGIC;
		ReadData1_Forward_Enable, ReadData2_Forward_Enable : IN STD_LOGIC;
		ReadData1_Forward, ReadData2_Forward : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rsrc_Out, Rdst_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		CCR_Out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END ExecutionStage;

ARCHITECTURE ExecutionStage_Arch OF ExecutionStage IS
	COMPONENT ALU IS
		GENERIC (n : INTEGER := 32);
		PORT (
			clk, rst, CCR_enable, BranchOP : IN STD_LOGIC;
			Rsrc, Rdst : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			result : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			ALUControl : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			CCR : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			BranchEnable : OUT STD_LOGIC
		);

		--carry, zero and negative flags
	END COMPONENT;

	SIGNAL RsrcActualValue, RdstActualValue : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL CCRAluOutput : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Zero : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
BEGIN

	RsrcActualValue <= ReadData2_Forward WHEN ReadData2_Forward_Enable = '1' AND ControlSignals(12) = '1'
		ELSE 
		Rdst_In WHEN ControlSignals(12) = '1'
		ELSE
		ReadData1_Forward WHEN ReadData1_Forward_Enable = '1'
		ELSE
		Rsrc_In;

	RdstActualValue <= Zero & Immediate WHEN ControlSignals(12) = '1' or ControlSignals(18 downto 14) ="01110" or ControlSignals(18 downto 14)="01111"
		ELSE
		InPort WHEN ControlSignals(8) = '1'
		ELSE 
		ReadData2_Forward WHEN ReadData2_Forward_Enable = '1'
		ELSE
		Rdst_In;

	AluExec : ALU GENERIC MAP(32) PORT MAP(Clock, Reset, ControlSignals(1), ControlSignals(2), RsrcActualValue, RdstActualValue, AluOutput, ControlSignals(18 DOWNTO 14), CCRAluOutput, BranchEnable);

	Rsrc_Out <= ReadData1_Forward WHEN ReadData1_Forward_Enable = '1'
		ELSE
		Rsrc_In;
	Rdst_Out <= ReadData2_Forward WHEN ReadData2_Forward_Enable = '1'
		ELSE
		Rdst_In;
	CCR_Out <= CCRAluOutput;
END ExecutionStage_Arch;