library ieee;
use ieee.std_logic_1164.all;

entity nBitsRegister is
     generic(n : integer := 32);
     port(clk, enable, rst : in std_logic;
	  d: in std_logic_vector(n-1 downto 0);
	  q: out std_logic_vector(n-1 downto 0));
end nBitsRegister;

architecture struct_register of nBitsRegister is
begin
     process(clk, rst, enable)
     begin
          if rst = '1' then
	       q <= (others=>'0');
	  elsif clk = '0' and enable = '1' then
	       q <= d;
	  end if;
     end process;
end struct_register;
