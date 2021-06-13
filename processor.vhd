LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processor is 
	port ( Clock, Reset: std_logic
	);
end Processor;     
architecture ModelProcessor of Processor is
	component FetchStage is
		Generic (n:integer:= 32; SpaceSize:integer:= 1000);
		port (instruction, immediate: out std_logic_vector(15 downto 0);
			pc: in std_logic_vector(31 downto 0);
			pc_out, pc_next: out std_logic_vector(31 downto 0);
			Clock, Reset: std_logic
			);
	end component;

signal pc :std_logic_vector(31 downto 0);
signal pc_out, pc_next :std_logic_vector(31 downto 0);
signal instruction, immediate :std_logic_vector(15 downto 0);

begin
	fetchStageExc: FetchStage PORT MAP(instruction, immediate, pc, pc_out, pc_next, Clock, Reset);
end architecture;