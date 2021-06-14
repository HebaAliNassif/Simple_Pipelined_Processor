LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

Entity ExecutionStage is
	port (
		Clock, Reset : in std_logic;
		Rsrc_In, Rdst_In: in std_logic_vector(31 downto 0);
        Immediate : in std_logic_vector(15 downto 0);
        ControlSignals : in std_logic_vector(18 downto 0);
        --DATA_FORWARD_EN_RSRC, DATA_FORWARD_EN_RDST: IN STD_LOGIC;
		--DATA_FORWARD_RSRC, DATA_FORWARD_RDST: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		--Rsrc_Out, Rdst_Out: out std_logic_vector(31 downto 0);
		AluOutput  : out std_logic_vector(31 downto 0);
        BranchEnable: out std_logic
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
else Rsrc_In;

RdstActualValue<= Zero & Immediate  when ControlSignals(13)='0'
else Rdst_In;

AluExec: ALU Generic Map(32) Port Map(Clock,Reset,ControlSignals(1),ControlSignals(2),RsrcActualValue,RdstActualValue,AluOutput,ControlSignals(18 downto 14),CCRAluOutput,BranchEnable);

end ExecutionStage_Arch;