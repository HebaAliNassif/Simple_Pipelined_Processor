LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

Entity MemoryStage is 
Generic (n:integer:= 32);
port(
Clock,Reset : in std_logic;
Rdst_Data,SP,PC,AluOutput : in std_logic_vector((n-1) downto 0);
ControlSignals: in std_logic_vector(18 downto 0);
MemOutput,SP_Out, PC_Out: out std_logic_vector((n-1) downto 0)
);
end MemoryStage;

Architecture MemoryStage_Arch of MemoryStage is 

Component Memory is
Generic (n:integer:= 32; SpaceSize:integer:= 1000);
port(
Clock,Mem_Write,Reset: in std_logic;
Address : in std_logic_vector( (n - 1) downto 0);
Write_Data : in std_logic_vector( (n - 1) downto 0);
Read_Data : out std_logic_vector( (n - 1) downto 0)
);
end Component;
Signal MemWriteSignal,SPSrc,PC_To_Mem: std_logic;
Signal Address,Write_Data,Read_Data,CurrentSP : std_logic_vector( (n - 1) downto 0);
Signal SP_OP:std_logic_vector( 1 downto 0);
begin
MemWriteSignal<=ControlSignals(5); 

SPSrc<=ControlSignals(9);
SP_OP( 1 downto 0)<=ControlSignals(11 downto 10);

CurrentSP<=std_logic_vector(to_unsigned(to_integer(unsigned(SP)) - 2,CurrentSP'length )) when  SP_OP="10" and Clock = '1'
else std_logic_vector(to_unsigned(to_integer(unsigned(SP)) + 2,CurrentSP'length )) when  SP_OP="01" and Clock = '1'
else (others => '0') when Reset='1'
else SP;

Address<=CurrentSP when SPSrc='1' and MemWriteSignal='0'
else SP when SPSrc='1' and MemWriteSignal='1'
else AluOutput when SPSrc='0' and MemWriteSignal='1'
else (others => '0');

PC_To_Mem<=ControlSignals(4);
Write_Data<= PC when PC_To_Mem='1'
else Rdst_Data;


DataMemory:Memory GENERIC MAP(n/2,1048576) PORT MAP(Clock, MemWriteSignal, Reset, Address, Write_Data, Read_Data);

MemOutput<=(OTHERS => '0') WHEN Reset = '1'
else Read_Data;

SP_Out<=CurrentSP;

end MemoryStage_Arch;
