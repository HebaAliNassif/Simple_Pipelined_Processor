LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

Entity DataMemory is
Generic (n:integer:= 32; SpaceSize:integer:= 1000);
port(
Clock,Mem_Read,Mem_Write : in std_logic;
Address : in std_logic_vector( (n - 1) downto 0);
Write_Data : in std_logic_vector( (n - 1) downto 0);
Read_Data : out std_logic_vector( (n - 1) downto 0)
);
end DataMemory;

Architecture DataMemory_Arch of DataMemory is

Type DataMemory_type is array(0 to SpaceSize) of std_logic_vector((n/2) - 1 downto 0);
Signal DataMemory : DataMemory_type;

begin
    process (Clock) is begin
        if Clock='0' AND Mem_Write = '1' then
            DataMemory(to_integer(unsigned(Address))) <= Write_Data(31 downto 16);
            DataMemory(to_integer(unsigned(Address)) + 1) <= Write_Data(15 downto 0);
        end if;
    end process;
    Read_Data <= DataMemory(to_integer(unsigned(Address))) & DataMemory(to_integer(unsigned(Address)) + 1) when Mem_Read = '1'
    else DataMemory(0)& DataMemory(1);
end DataMemory_Arch;