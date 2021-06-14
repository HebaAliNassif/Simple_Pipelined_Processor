LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity MyRegister is
generic ( n : integer := 32);
port( Clk, Rst, Enable : in std_logic;
d : in std_logic_vector((n-1) downto 0);
q : out std_logic_vector((n-1) downto 0));
end MyRegister;

architecture ModelMyRegister of MyRegister is
begin
	process (Clk,Rst)
	begin
		if Rst = '1' then
			q <= (others=>'0');
		elsif rising_edge(Clk) then
			if Enable = '1' then
				q <= d;
			end if;
		end if;
	end process;
end architecture;