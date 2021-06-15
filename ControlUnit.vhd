LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ControlUnit IS PORT (
	OpCode : IN STD_LOGIC_VECTOR(5 DOWNTO 0) ;
	Reset : IN STD_LOGIC;
	ControlSignals : OUT STD_LOGIC_VECTOR(18 DOWNTO 0)
);
END ControlUnit;

ARCHITECTURE ContolUnit_Arch OF ControlUnit IS
	SIGNAL CSTemp : STD_LOGIC_VECTOR(18 DOWNTO 0) := (OTHERS => '0');

BEGIN
	PROCESS (Reset, OpCode)IS BEGIN
		IF (Reset = '1') THEN----reset
			CSTemp <= (OTHERS => '0');
		ELSE
			--------------ONE OPERAND------------
			IF (OpCode = "000000") THEN --NOP
				CSTemp <= (OTHERS => '0');
			ELSIF (OpCode = "000001") THEN --SETC
				CSTemp <= "0000100000000000010";
			ELSIF (OpCode = "000010") THEN --CLRC
				CSTemp <= "0001000000000000010";
			ELSIF (OpCode = "000011") THEN --NOT Rdst
				CSTemp <= "0001110000001000010";
			ELSIF (OpCode = "000100") THEN --INC Rdst
				CSTemp <= "0010010000001000010";
			ELSIF (OpCode = "000101") THEN --DEC Rdst
				CSTemp <= "0010110000001000010";
			ELSIF (OpCode = "000110") THEN --OUT Rdst
				CSTemp <= "0000010000010000000";
			ELSIF (OpCode = "000111") THEN --IN Rdst
				CSTemp <= "0000010000101000000";

				--------------TWO OPERANDs------------
			ELSIF (OpCode = "001000") THEN --MOV Rsrc,Rdst
				CSTemp <= "0011010000001000000";
			ELSIF (OpCode = "001001") THEN --ADD Rsrc,Rdst
				CSTemp <= "0011110000001000010";
			ELSIF (OpCode = "001010") THEN --IADD Rdst,Imm
				CSTemp <= "0100001000001000010";
			ELSIF (OpCode = "001011") THEN --SUB Rsrc,Rdst
				CSTemp <= "0100110000001000010";
			ELSIF (OpCode = "001100") THEN --AND Rsrc,Rdst
				CSTemp <= "0101010000001000010";
			ELSIF (OpCode = "001101") THEN --OR Rsrc,Rdst
				CSTemp <= "0101110000001000010";
			ELSIF (OpCode = "001110") THEN --SHL Rdst,Imm
				CSTemp <= "0110001000001000010";
			ELSIF (OpCode = "001111") THEN --SHR Rdst,Imm
				CSTemp <= "0110101000001000010";

				----------------MEMORY----------------
			ELSIF (OpCode = "010000") THEN --PUSH Rdst
				CSTemp <= "0000010101000100000";
			ELSIF (OpCode = "010001") THEN --POP Rdst
				CSTemp <= "0000010011001001000";
			ELSIF (OpCode = "010010") THEN --LDM Rdst,Imm
				CSTemp <= "0011001000001000000";
			ELSIF (OpCode = "010011") THEN --LDD Rdst,Offset(Rsrc)
				CSTemp <= "0111010000001001000";
			ELSIF (OpCode = "010100") THEN --STD Rdst,Offset(Rsrc)
				CSTemp <= "0111110000000100000";

				----------------BRANCH OP-------------
			ELSIF (OpCode = "010101") THEN --JZ Rdst
				CSTemp <= "1000010000000000110";
			ELSIF (OpCode = "010110") THEN --JN Rdst
				CSTemp <= "1000110000000000110";
			ELSIF (OpCode = "010111") THEN --JC Rdst
				CSTemp <= "1001010000000000110";
			ELSIF (OpCode = "011000") THEN --JMP Rdst
				CSTemp <= "1001110000000000100";
			ELSIF (OpCode = "011001") THEN --CALL Rdst
				CSTemp <= "0000010101000110100";
			ELSIF (OpCode = "011010") THEN
				CSTemp <= "0000010011000000001";
			ELSE --unknown op
				CSTemp <= (OTHERS => '0');
			END IF;
		END IF;
	END PROCESS;
	ControlSignals <= CSTemp;
END ContolUnit_Arch;