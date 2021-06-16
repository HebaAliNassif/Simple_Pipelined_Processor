LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Memory IS
    GENERIC (
        n : INTEGER := 32;
        SpaceSize : INTEGER := 1000);
    PORT (
        Clock, Mem_Write, Reset : IN STD_LOGIC;
        Address : IN STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
        Write_Data : IN STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
        Read_Data : OUT STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
        FirstLocationValue :  OUT STD_LOGIC_VECTOR((n - 1) DOWNTO 0)
    );
END Memory;

ARCHITECTURE Memory_Arch OF Memory IS

    TYPE Memory_type IS ARRAY(0 TO SpaceSize) OF STD_LOGIC_VECTOR((n/2) - 1 DOWNTO 0);
    SIGNAL Memory : Memory_type := (OTHERS => (OTHERS => '0'));

BEGIN
    PROCESS (Clock) IS BEGIN
        IF falling_edge(Clock) AND Mem_Write = '1' THEN
            Memory(to_integer(unsigned(Address))) <= Write_Data(31 DOWNTO 16);
            Memory(to_integer(unsigned(Address)) + 1) <= Write_Data(15 DOWNTO 0);
        END IF;
    END PROCESS;
    Read_Data <= Memory(to_integer(unsigned(Address))) & Memory(to_integer(unsigned(Address)) + 1) WHEN Reset = '0'
        ELSE
        Memory(0) & Memory(1);
    FirstLocationValue <=  Memory(0) & Memory(1);
END Memory_Arch;