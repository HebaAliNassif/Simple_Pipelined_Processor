LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

Entity Memory is
Generic (n:integer:= 32; SpaceSize:integer:= 1000);
port(
Clock,Mem_Write,Reset: in std_logic;
Address : in std_logic_vector( (n - 1) downto 0);
Write_Data : in std_logic_vector( (n - 1) downto 0);
Read_Data : out std_logic_vector( (n - 1) downto 0)
);
end Memory;

Architecture Memory_Arch of Memory is

Type Memory_type is array(0 to SpaceSize) of std_logic_vector((n/2) - 1 downto 0);
Signal Memory : Memory_type:= (others => (others => '0'));

begin
    process (Clock) is begin
        if Clock='0' AND Mem_Write = '1' then
            Memory(to_integer(unsigned(Address))) <= Write_Data(31 downto 16);
            Memory(to_integer(unsigned(Address)) + 1) <= Write_Data(15 downto 0);
        end if;
    end process;
    Read_Data <= Memory(to_integer(unsigned(Address))) & Memory(to_integer(unsigned(Address)) + 1) when Reset='0'
	else Memory(0) & Memory(1);
end Memory_Arch;