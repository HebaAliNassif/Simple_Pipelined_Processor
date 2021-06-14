LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

Entity ExecutionStage is
	port (
		Clock, Reset : in std_logic;
		Rsrc_In, Rdst_In: in std_logic_vector(31 downto 0);
        Immediate : in std_logic_vector(15 downto 0);
        ControlSignals : in std_logic_vector(18 downto 0);
		AluOutput  : out std_logic_vector(31 downto 0);
        BranchEnable: out std_logic;
		ReadData1_Forward_Enable, ReadData2_Forward_Enable: in std_logic;
		ReadData1_Forward, ReadData2_Forward: in std_logic_vector(31 downto 0);
		Rsrc_Out, Rdst_Out: out std_logic_vector(31 downto 0)
    );
end ExecutionStage;

Architecture ExecutionStage_Arch of ExecutionStage is
Component ALU is
     generic (n : integer := 32);
     port (clk, rst, CCR_enable,BranchOP: in std_logic;
           Rsrc, Rdst: in std_logic_vector(n-1 downto 0);
           result: out std_logic_vector(n-1 downto 0);
           ALUControl : in std_logic_vector(4 downto 0);
	   CCR: inout std_logic_vector(2 downto 0);
	   BranchEnable: out std_logic
	   ); 
	   
	   --carry, zero and negative flags
end Component;

signal RsrcActualValue,RdstActualValue:std_logic_vector(31 downto 0):=(others=>'0');
signal CCRAluOutput:std_logic_vector(2 downto 0):=(others=>'0');
signal Zero:std_logic_vector(15 downto 0):=(others=>'0');
begin

RsrcActualValue<=Rdst_In when ControlSignals(12)='1'
else ReadData1_Forward when ReadData1_Forward_Enable='1'
else Rsrc_In;

RdstActualValue<= Zero & Immediate  when ControlSignals(13)='0'
else ReadData2_Forward when ReadData2_Forward_Enable='1'
else Rdst_In;

AluExec: ALU Generic Map(32) Port Map(Clock,Reset,ControlSignals(1),ControlSignals(2),RsrcActualValue,RdstActualValue,AluOutput,ControlSignals(18 downto 14),CCRAluOutput,BranchEnable);

Rsrc_Out<=ReadData1_Forward when ReadData1_Forward_Enable='1'
else Rsrc_In;
Rdst_Out<=ReadData2_Forward when ReadData2_Forward_Enable='1'
else Rdst_In;

end ExecutionStage_Arch;