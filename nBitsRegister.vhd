LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nBitsRegister IS
     GENERIC (n : INTEGER := 32);
     PORT (
          clk, enable, rst : IN STD_LOGIC;
          d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
          q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
END nBitsRegister;

ARCHITECTURE struct_register OF nBitsRegister IS
BEGIN
     PROCESS (clk, rst, enable)
     BEGIN
          IF rst = '1' THEN
               q <= (OTHERS => '0');
          ELSIF clk = '0' AND enable = '1' THEN
               q <= d;
          END IF;
     END PROCESS;
END struct_register;