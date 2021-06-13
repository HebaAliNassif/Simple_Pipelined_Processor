library IEEE;
use IEEE.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity registerFile is
	generic (n : integer := 32);
	port (clk, enable, rst : in std_logic;
	      writeData : in std_logic_vector(n-1 downto 0);
              writeIndex, readIndex1, readIndex2 : in std_logic_vector(2 downto 0);
	      readData1, readData2 : out std_logic_vector(n-1 downto 0));
end registerFile;

architecture structRegisterFile of registerFile is
      type registers_array is array(0 to 7) of std_logic_vector(n-1 downto 0);
      signal registers: registers_array;
begin
     process (clk, rst, enable)
          begin
	       if rst = '1' then
                    registers <= (others => (others => '0'));
                    report "Resetting now";
	       elsif clk = '0' and enable = '1' then
                    registers(to_integer(unsigned( writeIndex))) <= writeData;
		    report "Writing now";
	       end if;
	end process;
    readData1 <= registers(to_integer(unsigned( readIndex1)));
    readData2 <= registers(to_integer(unsigned( readIndex2)));

end structRegisterFile;
