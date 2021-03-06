LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY MyRegisterPC IS
	GENERIC (n : INTEGER := 32);
	PORT (
		Clk, Rst, Enable : IN STD_LOGIC;
		d : IN STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
		q : OUT STD_LOGIC_VECTOR((n - 1) DOWNTO 0));
END MyRegisterPC;

ARCHITECTURE ModelMyRegisterPC OF MyRegisterPC IS
BEGIN
	PROCESS (Clk, Rst)
	BEGIN
		IF Rst = '1' THEN
			q <= d;
		ELSIF Clk = '0' THEN
			IF Enable = '1' THEN
				q <= d;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;