LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

Entity ControlUnit is port(
OpCode:in std_logic_vector(5 downto 0);
Reset:in std_logic;
ControlSignals:out std_logic_vector(19 downto 0)
);
end ControlUnit;

Architecture ContolUnit_Arch of ControlUnit is
Signal CSTemp:std_logic_vector(19 downto 0);

begin 
process(Reset,OpCode)is begin
	if(Reset='1') then----reset
		CSTemp<=(others=>'0');
	else     
		--------------ONE OPERAND------------
		if(OpCode="000000")then --NOP
			CSTemp<=(others=>'0');
		elsif(OpCode="000001")then --SETC
			CSTemp<="00001000000000000010";
		elsif(OpCode="000010")then --CLRC
			CSTemp<="00010000000000000010";
		elsif(OpCode="000011")then --NOT Rdst
			CSTemp<="00011100000010000010";
		elsif(OpCode="000100")then --INC Rdst
			CSTemp<="00100100000010000010";
		elsif(OpCode="000101")then --DEC Rdst
			CSTemp<="00101100000010000010";
		elsif(OpCode="000110")then --OUT Rdst
			CSTemp<="00000100000100000000";
		elsif(OpCode="000111")then --IN Rdst
			CSTemp<="00000100001010000000";

		--------------TWO OPERANDs------------
		elsif(OpCode="001000")then --MOV Rsrc,Rdst
			CSTemp<="00110100000010000000";
		elsif(OpCode="001001")then --ADD Rsrc,Rdst
			CSTemp<="00111100000010000010";
		elsif(OpCode="001010")then --IADD Rdst,Imm
			CSTemp<="01000010000010000010";
		elsif(OpCode="001011")then --SUB Rsrc,Rdst
			CSTemp<="01001100000010000010";
		elsif(OpCode="001100")then --AND Rsrc,Rdst
			CSTemp<="01010100000010000010";
		elsif(OpCode="001101")then --OR Rsrc,Rdst
			CSTemp<="01011100000010000010";
		elsif(OpCode="001110")then --SHL Rdst,Imm
			CSTemp<="01100010000010000010";
		elsif(OpCode="001111")then --SHR Rdst,Imm
			CSTemp<="01101010000010000010";

		----------------MEMORY----------------
		elsif(OpCode="010000")then --PUSH Rdst
			CSTemp<="00000101010001000000";
		elsif(OpCode="010001")then --POP Rdst
			CSTemp<="00000100110010011000";
		elsif(OpCode="010010")then --LDM Rdst,Imm
			CSTemp<="00110010000010000000";
		elsif(OpCode="010011")then --LDD Rdst,Offset(Rsrc)
			CSTemp<="01110100000010011000";
		elsif(OpCode="010100")then --STD Rdst,Offset(Rsrc)
			CSTemp<="01111100000001000000";

		----------------BRANCH OP-------------
		elsif(OpCode="010101")then --JZ Rdst
			CSTemp<="10000100000000000110";
		elsif(OpCode="010110")then --JN Rdst
			CSTemp<="10001100000000000110";
		elsif(OpCode="010111")then --JC Rdst
			CSTemp<="10010100000000000110";
		elsif(OpCode="011000")then --JMP Rdst
			CSTemp<="10011100000000000100";
		elsif(OpCode="011001")then --CALL Rdst
			CSTemp<="00000101010001100100";
		elsif(OpCode="011010")then
			CSTemp<="00000100110000001001";
		else --unknown op
			CSTemp<=(others=>'0');
 		end if;
	end if;
end Process;
	ControlSignals <= CSTemp;
end ContolUnit_Arch;