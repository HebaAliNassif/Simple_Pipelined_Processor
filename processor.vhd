LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Processor IS
	PORT (
		Clock, Reset, ResetSignal : IN STD_LOGIC;
		InPort : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		OutPort : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END Processor;
ARCHITECTURE ModelProcessor OF Processor IS
	COMPONENT FetchStage IS
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
	END COMPONENT;
	COMPONENT IF_ID IS
		PORT (
			Clock, Reset, Enable, Stall : IN STD_LOGIC;
			instruction_in, immediate_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			instruction_out, immediate_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT ControlUnit IS
		PORT (
			OpCode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			Reset : IN STD_LOGIC;
			ControlSignals : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT MyRegister IS
		GENERIC (n : INTEGER := 32);
		PORT (
			Clk, Rst, Enable : IN STD_LOGIC;
			d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	COMPONENT registerFile IS
		GENERIC (n : INTEGER := 32);
		PORT (
			clk, enable, rst : IN STD_LOGIC;
			writeData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			writeIndex, readIndex1, readIndex2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			readData1, readData2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	COMPONENT ID_IE IS
		PORT (
			Clock, Reset, Enable, Stall : IN STD_LOGIC;
			pc_in, regReadDataValue1_in, regReadDataValue2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			pc_out, regReadDataValue1_out, regReadDataValue2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			regReadDataIndex1_in, regReadDataIndex2_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			regReadDataIndex1_out, regReadDataIndex2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			immediateValue_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			controlSignals_in : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
			immediateValue_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			controlSignals_out : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT ExecutionStage IS
		PORT (
			Clock, Reset : IN STD_LOGIC;
			Rsrc_In, Rdst_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Immediate : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			ControlSignals : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
			AluOutput : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			BranchEnable : OUT STD_LOGIC;
			ReadData1_Forward_Enable, ReadData2_Forward_Enable : IN STD_LOGIC;
			ReadData1_Forward, ReadData2_Forward : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Rsrc_Out, Rdst_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			CCR_Out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT IE_MEM IS
		PORT (
			Clock, Reset, Enable : IN STD_LOGIC;
			pc_in, regReadDataValue1_in, regReadDataValue2_in, AluOutput_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			pc_out, regReadDataValue1_out, regReadDataValue2_out, AluOutput_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			regReadDataIndex1_in, regReadDataIndex2_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			regReadDataIndex1_out, regReadDataIndex2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			controlSignals_in : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
			controlSignals_out : OUT STD_LOGIC_VECTOR(19 DOWNTO 0));
	END COMPONENT;
	COMPONENT MemoryStage IS
		GENERIC (n : INTEGER := 32);
		PORT (
			Clock, Reset : IN STD_LOGIC;
			Rdst_Data, SP, PC, AluOutput : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ControlSignals : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
			MemOutput, SP_Out, PC_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			FirstLocationValue :  OUT STD_LOGIC_VECTOR((n - 1) DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT Mem_WB IS
		PORT (
			Clock, Reset, WriteEnable : IN STD_LOGIC;
			RdstIndex_In : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			ControlSignals_In : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
			PC_In, AluOutput_In, MemOutput_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			PC_Out, AluOutput_Out, MemOutput_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			ControlSignals_Out : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
			WriteBackIndex_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT DataForward IS
		PORT (
		MemRead_ID_IE,RegWriteEnable_IE_MEM, RegWriteEnable_MEM_WB, MemToRegEnable_MEM_WB : IN STD_LOGIC;
		ReadDataIndex2_ID_IE, ReadDataIndex2_IE_Mem, ReadDataIndex2_Mem_WB, ReadDataIndex1_ID_IE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		ReadDataIndex1_ID, ReadDataIndex2_ID : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		ALUOutput_IE_Mem, ALUOutput_Mem_WB, MemOutput_Mem_WB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ReadData1_Forward_Enable, ReadData2_Forward_Enable, StallEnable : OUT STD_LOGIC;
		ReadData1_Forward, ReadData2_Forward : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	SIGNAL sp, sp_next, sp_out_MEM : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL pc, pc_out_IF, pc_next_IF, pc_out_MEM : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL pc_out_IF_ID, pc_out_ID_IE, pc_out_IE_MEM, pc_out_MEM_WB : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL branch_address, branch_return_address : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL instruction_IF, immediate_IF : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL instruction_IF_ID, immediate_IF_ID, immediate_ID_IE : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Stall, branch, branch_return, Enable_Buffers : STD_LOGIC := ('0');
	SIGNAL memoryLocationOfZero : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

	SIGNAL ControlSignals : STD_LOGIC_VECTOR(19 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ControlSignals_ID : STD_LOGIC_VECTOR(19 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ControlSignals_ID_IE, ControlSignals_IE_MEM, ControlSignals_MEM_WB : STD_LOGIC_VECTOR(19 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RegWriteEnable, PcWrite, SpWrite : STD_LOGIC := ('0');

	SIGNAL WriteBackData, ExcutionDataOut, MemoryOut : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL WriteBackIndex : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

	SIGNAL readData1_ID, readData2_ID : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL readData1_ID_IE, readData2_ID_IE : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL readData1_IE_MEM, readData2_IE_MEM : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL readData1_IE, readData2_IE: STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL regReadDataIndex1_ID_IE, regReadDataIndex2_ID_IE : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL regReadDataIndex1_IE_MEM, regReadDataIndex2_IE_MEM : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

	SIGNAL readData2IE_MEM : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL readData2IE_MEM_WB : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ALUOutput_IE : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ALUOutput_IE_MEM, ALUOutput_MEM_WB : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL MemOutput_MEM : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0') ;
	SIGNAL MemOutput_MEM_WB : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RdstIndex_In_IE_MEM : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ReadData1_Forward_Enable, ReadData2_Forward_Enable : STD_LOGIC := '0';
	SIGNAL ReadData1_Forward_Value, ReadData2_Forward_Value : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

	SIGNAL CCR  : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL CCR_C, CCR_N, CCR_Z  : STD_LOGIC :=  '0';

BEGIN

	--------Signals Assign-----------
	CCR_C <= CCR(0);
	CCR_N <= CCR(1);
	CCR_Z <= CCR(2);
	
	OutPort <= WriteBackData when  ControlSignals_MEM_WB(7) = '1' else  (OTHERS => '0');
	PcWrite <= NOT Stall;
	RegWriteEnable <= ControlSignals_MEM_WB(6);
	SpWrite <= '1' WHEN ControlSignals_IE_MEM(11 DOWNTO 10) = "01" OR  ControlSignals_IE_MEM(11 DOWNTO 10) = "10"
					ELSE '0';

	--------PC register-----------
	PCReg : MyRegister PORT MAP(Clock, Reset, PcWrite, pc_next_IF, pc);
	--------SP register-----------
	SPReg : MyRegister PORT MAP(Clock, Reset, SpWrite, sp_next, sp);

	--------Fetch stage-----------
	fetchStageExc : FetchStage PORT MAP(
		instruction_IF, immediate_IF, memoryLocationOfZero(31 downto 16), branch, branch_return, branch_address, branch_return_address, pc, pc_out_IF, pc_next_IF,
		Clock, Reset, ResetSignal);

	IF_IDExc : IF_ID PORT MAP(
		Clock, Reset, Enable_Buffers, Stall, instruction_IF, immediate_IF, pc_out_IF, instruction_IF_ID, immediate_IF_ID,
		pc_out_IF_ID);

	--------Decode stage-----------
	controlUnit_ID : ControlUnit PORT MAP(instruction_IF_ID(15 DOWNTO 10), Reset, ControlSignals_ID);

	registerFile_ID : registerFile PORT MAP(
		Clock, RegWriteEnable, Reset, WriteBackData, WriteBackIndex, instruction_IF_ID(7 DOWNTO 5),
		instruction_IF_ID(2 DOWNTO 0), readData1_ID, readData2_ID);

	ID_IEExc : ID_IE PORT MAP(
		Clock, Reset, Enable_Buffers, Stall, pc_out_IF_ID, readData1_ID, readData2_ID, pc_out_ID_IE,
		readData1_ID_IE, readData2_ID_IE, instruction_IF_ID(7 DOWNTO 5), instruction_IF_ID(2 DOWNTO 0),
		regReadDataIndex1_ID_IE, regReadDataIndex2_ID_IE, immediate_IF_ID, ControlSignals_ID,
		immediate_ID_IE, ControlSignals_ID_IE);

	--------Execute stage-----------
	branch_address <= readData2_ID_IE; --RDS out mn el ex stage
	executionStageExc : ExecutionStage PORT MAP(
		Clock, Reset, readData1_ID_IE, readData2_ID_IE, immediate_ID_IE, ControlSignals_ID_IE,
		ALUOutput_IE, branch, ReadData1_Forward_Enable, ReadData2_Forward_Enable,ReadData1_Forward_Value, ReadData2_Forward_Value,
		readData1_IE, readData2_IE, CCR);

	IE_MEMExc : IE_MEM PORT MAP(
		Clock, Reset, Enable_Buffers, pc_out_ID_IE, readData1_IE, readData2_IE, ALUOutput_IE, pc_out_IE_MEM,
		readData1_IE_MEM, readData2_IE_MEM, ALUOutput_IE_MEM, regReadDataIndex1_ID_IE, regReadDataIndex2_ID_IE,
		regReadDataIndex1_IE_MEM, regReadDataIndex2_IE_MEM, ControlSignals_ID_IE, ControlSignals_IE_MEM);

	--------Memory stage-----------
	branch_return <= ControlSignals_IE_MEM(0);
	branch_return_address <= MemOutput_MEM;

	memoryStageExc : MemoryStage PORT MAP(
		Clock, Reset, readData2_IE_MEM, sp, pc_out_IE_MEM, ALUOutput_IE_MEM, ControlSignals_IE_MEM,
		MemOutput_MEM, sp_next, pc_out_MEM, memoryLocationOfZero);

	MEM_WBExc : Mem_WB PORT MAP(
		Clock, Reset, Enable_Buffers, regReadDataIndex2_IE_MEM, ControlSignals_IE_MEM,
		pc_out_MEM, ALUOutput_IE_MEM, MemOutput_MEM, pc_out_MEM_WB, ALUOutput_MEM_WB, MemOutput_MEM_WB,
		ControlSignals_MEM_WB, WriteBackIndex);

	--------WriteBack stage-----------
	WriteBackData <= MemOutput_MEM_WB WHEN ControlSignals_MEM_WB(3) = '1'
		ELSE
		ALUOutput_MEM_WB;

	-------DataForwarding--------------
	DF : DataForward PORT MAP(
		ControlSignals_ID_IE(19),ControlSignals_IE_MEM(6), ControlSignals_MEM_WB(6), ControlSignals_MEM_WB(3),
		regReadDataIndex2_ID_IE, regReadDataIndex2_IE_MEM, WriteBackIndex, regReadDataIndex1_ID_IE,
		instruction_IF_ID(7 DOWNTO 5), instruction_IF_ID(2 DOWNTO 0), ALUOutput_IE_MEM, ALUOutput_MEM_WB, MemOutput_MEM_WB,
		ReadData1_Forward_Enable, ReadData2_Forward_Enable, Stall, ReadData1_Forward_Value, ReadData2_Forward_Value);


	PROCESS (Reset, Clock)
	BEGIN
		IF Reset = '1' THEN
			Enable_Buffers <= '0';
		ELSIF (Clock = '1') THEN
			Enable_Buffers <= '1';
		END IF;

	END PROCESS;

END ARCHITECTURE;