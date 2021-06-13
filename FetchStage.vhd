LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity FetchStage is 
	Generic (n:integer:= 32; SpaceSize:integer:= 1000);
	port (instruction, immediate: out std_logic_vector(15 downto 0);
		pc: in std_logic_vector(31 downto 0);
		pc_out, pc_next: out std_logic_vector(31 downto 0);
		Clock, Reset: std_logic
	);
end FetchStage;     
architecture ModelFetchStage of FetchStage is
	component Memory is
		Generic (n:integer:= 32; SpaceSize:integer:= 1000);
		port(
			Clock, Mem_Write, Reset: in std_logic;
			Address : in std_logic_vector(n - 1 downto 0);
			Write_Data : in std_logic_vector( (n - 1) downto 0);
			Read_Data : out std_logic_vector( (n - 1) downto 0)
			);
	end component;
	signal  Mem_Write :std_logic := '0';
	signal  Address, Write_Data, Read_Data: std_logic_vector(31 downto 0):= (OTHERS => '0');
begin
	INSTRUCTION_MEMORY: Memory GENERIC MAP(n, SpaceSize) PORT MAP(Clock, Mem_Write, Reset, Address, Write_Data, Read_Data);

	process (Clock)
	begin
		if falling_edge(Clock) and Reset = '0' then
			Address <= pc;
                    	Mem_Write <= '1';
		end if;
	end process;

	pc_next <=  x"0000" & Read_Data(31 downto 16) when Reset = '1'
        else std_logic_vector(to_unsigned(to_integer(unsigned(pc)) + 2, pc_next'length )) when Read_Data(31 downto 26) = "001010" 
												or Read_Data(31 downto 26) = "010010" 
												or Read_Data(31 downto 26) = "010011" 
												or Read_Data(31 downto 26) = "010100" 
        else std_logic_vector(to_unsigned(to_integer(unsigned(pc)) + 1, pc_next'length ));

	pc_out <= pc;
        instruction <= Read_Data(31 downto 16);
        immediate <= Read_Data(15 downto 0);
end architecture;