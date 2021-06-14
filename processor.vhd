LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processor is 
	port ( Clock, Reset: std_logic;
			InPort : in std_logic_vector(31 downto 0);
			OutPort : out std_logic_vector(31 downto 0)
	);
end Processor;     
architecture ModelProcessor of Processor is
	component FetchStage is
		Generic (n:integer:= 32; SpaceSize:integer:= 1000);
		port (instruction, immediate: out std_logic_vector(15 downto 0);
				branch, branch_return : in std_logic;
				branch_address, branch_return_address : in std_logic_vector(31 downto 0);
				pc: in std_logic_vector(31 downto 0);
				pc_out, pc_next: out std_logic_vector(31 downto 0);
				PcWrite: out std_logic;
				Clock, Reset, Stall: in std_logic
	);
	end component;
	component IF_ID is
		port(Clock, Reset, Enable, Stall : in std_logic;
            	instruction_in, immediate_in : in std_logic_vector(15 downto 0);
            	pc_in : in std_logic_vector(31 downto 0);
            	instruction_out, immediate_out : out std_logic_vector(15 downto 0);
            	pc_out : out std_logic_vector(31 downto 0)
            	);
	end component;
	component ControlUnit is
		port(OpCode:in std_logic_vector(5 downto 0);
				Reset:in std_logic;
				ControlSignals:out std_logic_vector(18 downto 0)
				);
	end component;
	component MyRegister is
		generic ( n : integer := 32);
		port( Clk, Rst, Enable : in std_logic;
				d : in std_logic_vector(31 downto 0);
				q : out std_logic_vector(31 downto 0));
	end component;
	component registerFile is
		generic (n : integer := 32);
		port(clk, enable, rst : in std_logic;
	      	writeData : in std_logic_vector(31 downto 0);
            writeIndex, readIndex1, readIndex2 : in std_logic_vector(2 downto 0);
	      	readData1, readData2 : out std_logic_vector(31 downto 0));
	end component;
	component ID_IE is
		port(Clock, Reset, Enable, Stall : in std_logic;
            pc_in, regReadDataValue1_in,  regReadDataValue2_in: in std_logic_vector(31 downto 0);
            pc_out, regReadDataValue1_out,  regReadDataValue2_out: out std_logic_vector(31 downto 0);
            regReadDataIndex1_in,  regReadDataIndex2_in: in std_logic_vector(2 downto 0);
            regReadDataIndex1_out,  regReadDataIndex2_out: out std_logic_vector(2 downto 0);
            immediateValue_in: in std_logic_vector(15 downto 0);
            controlSignals_in: in std_logic_vector(18 downto 0);
            immediateValue_out: out std_logic_vector(15 downto 0);
            controlSignals_out: out std_logic_vector(18 downto 0)
            );
	end component;
	component ExecutionStage is
			port (Clock, Reset : in std_logic;
				Rsrc_In, Rdst_In: in std_logic_vector(31 downto 0);
				Immediate : in std_logic_vector(15 downto 0);
				ControlSignals : in std_logic_vector(18 downto 0);
				--DATA_FORWARD_EN_RSRC, DATA_FORWARD_EN_RDST: IN STD_LOGIC;
				--DATA_FORWARD_RSRC, DATA_FORWARD_RDST: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
				--Rsrc_Out, Rdst_Out: out std_logic_vector(31 downto 0);
				AluOutput  : out std_logic_vector(31 downto 0);
				BranchEnable: out std_logic
			);
	end component;
	component IE_MEM is
		port (Clock, Reset, Enable: in std_logic;
				pc_in, regReadDataValue1_in,  regReadDataValue2_in,AluOutput_in: in std_logic_vector(31 downto 0);
				pc_out, regReadDataValue1_out,  regReadDataValue2_out,AluOutput_out: out std_logic_vector(31 downto 0);
				regReadDataIndex1_in,  regReadDataIndex2_in: in std_logic_vector(2 downto 0);
				regReadDataIndex1_out,  regReadDataIndex2_out: out std_logic_vector(2 downto 0);
				controlSignals_in: in std_logic_vector(18 downto 0);
				controlSignals_out: out std_logic_vector(18 downto 0));
	end component;
	component MemoryStage is
		Generic (n:integer:= 32);
		port(
			Clock,Reset : in std_logic;
			Rdst_Data,SP,PC,AluOutput : in std_logic_vector(31 downto 0);
			ControlSignals: in std_logic_vector(18 downto 0);
			MemOutput,SP_Out, PC_Out: out std_logic_vector(31 downto 0)
		);
	end component;
	component Mem_WB is
		port (Clock, Reset, WriteEnable : in std_logic;
				RdstIndex_In  : in std_logic_vector(2 downto 0);
				ControlSignals_In : in std_logic_vector(18 downto 0);
				PC_In, AluOutput_In, MemOutput_In   : in std_logic_vector(31 downto 0);
				PC_Out, AluOutput_Out, MemOutput_Out  : out std_logic_vector(31 downto 0);
				ControlSignals_Out : out std_logic_vector(18 downto 0);
				WriteBackIndex_out : out std_logic_vector(2 downto 0)
				);
	end component;
	
	
signal sp, sp_next, sp_out_MEM :std_logic_vector(31 downto 0) := (OTHERS => '0');
signal pc, pc_out_IF, pc_next_IF, pc_out_MEM :std_logic_vector(31 downto 0) := (OTHERS => '0');
signal pc_out_IF_ID, pc_out_ID_IE, pc_out_IE_MEM, pc_out_MEM_WB :std_logic_vector(31 downto 0) := (OTHERS => '0');
signal branch_address, branch_return_address :std_logic_vector(31 downto 0) := (OTHERS => '0');
signal instruction_IF, immediate_IF :std_logic_vector(15 downto 0) := (OTHERS => '0');
signal instruction_IF_ID, immediate_IF_ID, immediate_ID_IE :std_logic_vector(15 downto 0) := (OTHERS => '0');
signal Stall, branch, branch_return, Enable_Buffers : std_logic := ('0');

signal ControlSignals:std_logic_vector(18 downto 0) := (OTHERS => '0');
signal ControlSignals_ID:std_logic_vector(18 downto 0) := (OTHERS => '0');
signal ControlSignals_ID_IE, ControlSignals_IE_MEM, ControlSignals_MEM_WB:std_logic_vector(18 downto 0) := (OTHERS => '0');
signal RegWriteEnable, PcWrite, SpWrite:std_logic  := ('0');

signal WriteBackData, ExcutionDataOut, MemoryOut:std_logic_vector(31 downto 0) := (OTHERS => '0');
signal  WriteBackIndex :std_logic_vector(2 downto 0) := (OTHERS => '0');

signal readData1_ID, readData2_ID : std_logic_vector(31 downto 0)  := (OTHERS => '0');
signal readData1_ID_IE, readData2_ID_IE : std_logic_vector(31 downto 0)  := (OTHERS => '0');
signal readData1_IE_MEM, readData2_IE_MEM : std_logic_vector(31 downto 0)  := (OTHERS => '0');
signal regReadDataIndex1_ID_IE, regReadDataIndex2_ID_IE : std_logic_vector(2 downto 0)  := (OTHERS => '0');
signal regReadDataIndex1_IE_MEM, regReadDataIndex2_IE_MEM : std_logic_vector(2 downto 0)  := (OTHERS => '0');

signal readData2IE_MEM: std_logic_vector(31 downto 0)  := (OTHERS => '0');
signal readData2IE_MEM_WB: std_logic_vector(31 downto 0)  := (OTHERS => '0');
signal ALUOutput_IE: std_logic_vector(31 downto 0) := (OTHERS => '0');
signal ALUOutput_IE_MEM,  ALUOutput_MEM_WB: std_logic_vector(31 downto 0) := (OTHERS => '0');
signal MemOutput_MEM: std_logic_vector(31 downto 0) := (OTHERS => '0');
signal MemOutput_MEM_WB: std_logic_vector(31 downto 0) := (OTHERS => '0');
signal RdstIndex_In_IE_MEM : std_logic_vector(2 downto 0)  := (OTHERS => '0');
begin

	--------PC register-----------
	PCReg: MyRegister PORT MAP(Clock, Reset, PcWrite, pc_next_IF, pc);
	--------SP register-----------
	SPReg: MyRegister PORT MAP(Clock, Reset, PcWrite, sp_next, sp);

	--------Fetch stage-----------
	fetchStageExc: FetchStage PORT MAP(instruction_IF, immediate_IF, branch, branch_return, branch_address, branch_return_address, pc, pc_out_IF, pc_next_IF, PcWrite,
										Clock, Reset, Stall);
	
	IF_IDExc: IF_ID  PORT MAP(Clock, Reset, Enable_Buffers, Stall, instruction_IF, immediate_IF, pc_out_IF, instruction_IF_ID, immediate_IF_ID, pc_out_IF_ID);

	--------Decode stage-----------
	controlUnit_ID: ControlUnit PORT MAP(instruction_IF_ID(15 DOWNTO 10), Reset, ControlSignals_ID);

	registerFile_ID: registerFile PORT MAP(Clock, RegWriteEnable, Reset, WriteBackData, WriteBackIndex, instruction_IF_ID(7 downto 5), instruction_IF_ID(2 downto 0), readData1_ID, readData2_ID);

	ID_IEExc: ID_IE  PORT MAP(Clock, Reset, Enable_Buffers, Stall, pc_out_IF_ID, readData1_ID, readData2_ID, pc_out_ID_IE,
								 readData1_ID_IE, readData2_ID_IE, instruction_IF_ID(7 downto 5), instruction_IF_ID(2 downto 0),
								 regReadDataIndex1_ID_IE, regReadDataIndex2_ID_IE, immediate_IF_ID, ControlSignals_ID,
								 immediate_ID_IE, ControlSignals_ID_IE);

	--------Execute stage-----------
	branch_address <= readData2_ID_IE;			--RDS out mn el ex stage
	executionStageExc: ExecutionStage PORT MAP(Clock, Reset, readData1_ID_IE, readData2_ID_IE, immediate_ID_IE, ControlSignals_ID_IE, 
												ALUOutput_IE, branch);

	
	IE_MEMExc: IE_MEM PORT MAP(Clock, Reset, Enable_Buffers, pc_out_ID_IE, readData1_ID_IE, readData2_ID_IE, ALUOutput_IE, pc_out_IE_MEM,
							readData1_IE_MEM, readData2_IE_MEM, ALUOutput_IE_MEM, regReadDataIndex1_ID_IE, regReadDataIndex2_ID_IE,
							regReadDataIndex1_IE_MEM, regReadDataIndex2_IE_MEM, ControlSignals_ID_IE, ControlSignals_IE_MEM);

	--------Memory stage-----------
	branch_return <= ControlSignals_IE_MEM(0);
	branch_return_address <= MemOutput_MEM;

	memoryStageExc: MemoryStage PORT MAP(Clock, Reset, readData2_IE_MEM, sp, pc_out_IE_MEM, ALUOutput_IE_MEM, ControlSignals_IE_MEM,
											MemOutput_MEM, sp_out_MEM, pc_out_MEM);

	MEM_WBExc: Mem_WB PORT MAP(Clock, Reset, Enable_Buffers, RdstIndex_In_IE_MEM, ControlSignals_IE_MEM, 
								pc_out_MEM, ALUOutput_IE_MEM, MemOutput_MEM, pc_out_MEM_WB, ALUOutput_MEM_WB, MemOutput_MEM_WB,
								ControlSignals_MEM_WB, WriteBackIndex);

	 

	--------WriteBack stage-----------
	--MemoryOut from MemStage
	--RdstIndexIn from instruction
	--ExcutionDataOut from ExcStage

	RegWriteEnable<= ControlSignals(6);
	WriteBackData <= MemoryOut when ControlSignals(3) = '1'
		else InPort when ControlSignals(8) = '1' 
		else ExcutionDataOut;

		--RdstIndex<= RdstIndexIn(2 DOWNTO 0);	
		
	--writing WriteBackData at RdstIndex with enable=RegWriteEnable in Register file

	process (Reset, Clock)
    begin
        if Reset = '1' then
            Enable_Buffers <= '0';
        elsif (Clock = '1') then
            Enable_Buffers <= '1';      
        end if;

    end process;

end architecture;