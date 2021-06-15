LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ControlUnit IS PORT (
	OpCode : IN STD_LOGIC_VECTOR(5 DOWNTO 0) ;
	Reset : IN STD_LOGIC;
	ControlSignals : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
);
END ControlUnit;

ARCHITECTURE ContolUnit_Arch OF ControlUnit IS
	SIGNAL CSTemp : STD_LOGIC_VECTOR(19 DOWNTO 0) := (OTHERS => '0');

BEGIN
	PROCESS (Reset, OpCode)IS BEGIN
		IF (Reset = '1') THEN----reset
			CSTemp <= (OTHERS => '0');
		ELSE
			--------------ONE OPERAND------------
			IF (OpCode = "000000") THEN --NOP
				CSTemp <= (OTHERS => '0');
			ELSIF (OpCode = "000001") THEN --SETC
				CSTemp <= "00000100000000000010";
			ELSIF (OpCode = "000010") THEN --CLRC
				CSTemp <= "00001000000000000010";
			ELSIF (OpCode = "000011") THEN --NOT Rdst
				CSTemp <= "00001110000001000010";
			ELSIF (OpCode = "000100") THEN --INC Rdst
				CSTemp <= "00010010000001000010";
			ELSIF (OpCode = "000101") THEN --DEC Rdst
				CSTemp <= "00010110000001000010";
			ELSIF (OpCode = "000110") THEN --OUT Rdst
				CSTemp <= "00000010000010000000";
			ELSIF (OpCode = "000111") THEN --IN Rdst
				CSTemp <= "00000010000101000000";

				--------------TWO OPERANDs------------
			ELSIF (OpCode = "001000") THEN --MOV Rsrc,Rdst
				CSTemp <= "00011010000001000000";
			ELSIF (OpCode = "001001") THEN --ADD Rsrc,Rdst
				CSTemp <= "00011110000001000010";
			ELSIF (OpCode = "001010") THEN --IADD Rdst,Imm
				CSTemp <= "00100001000001000010";
			ELSIF (OpCode = "001011") THEN --SUB Rsrc,Rdst
				CSTemp <= "00100110000001000010";
			ELSIF (OpCode = "001100") THEN --AND Rsrc,Rdst
				CSTemp <= "00101010000001000010";
			ELSIF (OpCode = "001101") THEN --OR Rsrc,Rdst
				CSTemp <= "00101110000001000010";
			ELSIF (OpCode = "001110") THEN --SHL Rdst,Imm
				CSTemp <= "00110001000001000010";
			ELSIF (OpCode = "001111") THEN --SHR Rdst,Imm
				CSTemp <= "00110101000001000010";

				----------------MEMORY----------------
			ELSIF (OpCode = "010000") THEN --PUSH Rdst
				CSTemp <= "00000010101000100000";
			ELSIF (OpCode = "010001") THEN --POP Rdst
				CSTemp <= "10000010011001001000";
			ELSIF (OpCode = "010010") THEN --LDM Rdst,Imm
				CSTemp <= "00011001000001000000";
			ELSIF (OpCode = "010011") THEN --LDD Rdst,Offset(Rsrc)
				CSTemp <= "10111010000001001000";
			ELSIF (OpCode = "010100") THEN --STD Rdst,Offset(Rsrc)
				CSTemp <= "00111110000000100000";

				----------------BRANCH OP-------------
			ELSIF (OpCode = "010101") THEN --JZ Rdst
				CSTemp <= "01000010000000000110";
			ELSIF (OpCode = "010110") THEN --JN Rdst
				CSTemp <= "01000110000000000110";
			ELSIF (OpCode = "010111") THEN --JC Rdst
				CSTemp <= "01001010000000000110";
			ELSIF (OpCode = "011000") THEN --JMP Rdst
				CSTemp <= "01001110000000000100";
			ELSIF (OpCode = "011001") THEN --CALL Rdst
				CSTemp <= "00000010101000110100";
			ELSIF (OpCode = "011010") THEN
				CSTemp <= "10000010011000000001";
			ELSE --unknown op
				CSTemp <= (OTHERS => '0');
			END IF;
		END IF;
	END PROCESS;
	ControlSignals <= CSTemp;
END ContolUnit_Arch;