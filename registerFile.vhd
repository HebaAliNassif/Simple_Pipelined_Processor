LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RegisterFile IS
      GENERIC (n : INTEGER := 32);
      PORT (
            clk, enable, rst : IN STD_LOGIC;
            writeData : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            writeIndex, readIndex1, readIndex2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            readData1, readData2 : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
END RegisterFile;

ARCHITECTURE structRegisterFile OF RegisterFile IS
      TYPE registers_array IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR(n - 1 DOWNTO 0) ;
      SIGNAL registers : registers_array :=(OTHERS => (OTHERS => '0'));
BEGIN
      PROCESS (clk, rst, enable)
      BEGIN
            IF rst = '1' THEN
                  registers <= (OTHERS => (OTHERS => '0'));
                  REPORT "Resetting now";
            ELSIF clk = '0' AND enable = '1' THEN
                  registers(to_integer(unsigned(writeIndex))) <= writeData;
                  REPORT "Writing now";
            END IF;
      END PROCESS;
      readData1 <= registers(to_integer(unsigned(readIndex1)));
      readData2 <= registers(to_integer(unsigned(readIndex2)));

END structRegisterFile;