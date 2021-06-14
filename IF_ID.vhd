LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity IF_ID is
    port(Clock, Reset, Enable, Stall : in std_logic;
            instruction_in, immediate_in : in std_logic_vector(15 downto 0);
            pc_in : in std_logic_vector(31 downto 0);
            instruction_out, immediate_out : out std_logic_vector(15 downto 0);
            pc_out : out std_logic_vector(31 downto 0)
            );
end IF_ID;

architecture ModelIF_ID of IF_ID is
begin
	process (Clock, Reset, Enable)
	begin
		if Reset = '1' then
			instruction_out <= (others=>'0');
            immediate_out <= (others=>'0');
            pc_out <= (others=>'0');
		elsif rising_edge(Clock) then
			if Enable = '1' and Stall = '0' then
				instruction_out <= instruction_in;
                immediate_out <= immediate_in;
                pc_out <= pc_in;
			end if;
		end if;
	end process;
end architecture;