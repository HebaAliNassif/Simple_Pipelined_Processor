LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

Entity ControlUnit is port(
OpCode:in std_logic_vector(5 downto 0);
Reset:in std_logic;
ControlSignals:out std_logic_vector(18 downto 0)
);
end ControlUnit;

Architecture ContolUnit_Arch of ControlUnit is
Signal CSTemp:std_logic_vector(18 downto 0);

begin 
process(Reset,OpCode)is begin
	if(Reset='1') then----reset
		CSTemp<=(others=>'0');
	else     
		--------------ONE OPERAND------------
		if(OpCode="000000")then --NOP
			CSTemp<=(others=>'0');
		elsif(OpCode="000001")then --SETC
			CSTemp<="0000100000000000010";
		elsif(OpCode="000010")then --CLRC
			CSTemp<="0001000000000000010";
		elsif(OpCode="000011")then --NOT Rdst
			CSTemp<="0001110000001000010";
		elsif(OpCode="000100")then --INC Rdst
			CSTemp<="0010010000001000010";
		elsif(OpCode="000101")then --DEC Rdst
			CSTemp<="0010110000001000010";
		elsif(OpCode="000110")then --OUT Rdst
			CSTemp<="0000010000010000000";
		elsif(OpCode="000111")then --IN Rdst
			CSTemp<="0000010000101000000";

		--------------TWO OPERANDs------------
		elsif(OpCode="001000")then --MOV Rsrc,Rdst
			CSTemp<="0011010000001000000";
		elsif(OpCode="001001")then --ADD Rsrc,Rdst
			CSTemp<="0011110000001000010";
		elsif(OpCode="001010")then --IADD Rdst,Imm
			CSTemp<="0100001000001000010";
		elsif(OpCode="001011")then --SUB Rsrc,Rdst
			CSTemp<="0100110000001000010";
		elsif(OpCode="001100")then --AND Rsrc,Rdst
			CSTemp<="0101010000001000010";
		elsif(OpCode="001101")then --OR Rsrc,Rdst
			CSTemp<="0101110000001000010";
		elsif(OpCode="001110")then --SHL Rdst,Imm
			CSTemp<="0110001000001000010";
		elsif(OpCode="001111")then --SHR Rdst,Imm
			CSTemp<="0110101000001000010";

		----------------MEMORY----------------
		elsif(OpCode="010000")then --PUSH Rdst
			CSTemp<="0000010101000100000";
		elsif(OpCode="010001")then --POP Rdst
			CSTemp<="0000010011001001000";
		elsif(OpCode="010010")then --LDM Rdst,Imm
			CSTemp<="0011001000001000000";
		elsif(OpCode="010011")then --LDD Rdst,Offset(Rsrc)
			CSTemp<="0111010000001001000";
		elsif(OpCode="010100")then --STD Rdst,Offset(Rsrc)
			CSTemp<="0111110000000100000";

		----------------BRANCH OP-------------
		elsif(OpCode="010101")then --JZ Rdst
			CSTemp<="1000010000000000110";
		elsif(OpCode="010110")then --JN Rdst
			CSTemp<="1000110000000000110";
		elsif(OpCode="010111")then --JC Rdst
			CSTemp<="1001010000000000110";
		elsif(OpCode="011000")then --JMP Rdst
			CSTemp<="1001110000000000100";
		elsif(OpCode="011001")then --CALL Rdst
			CSTemp<="0000010101000110100";
		elsif(OpCode="011010")then
			CSTemp<="0000010011000000001";
		else --unknown op
			CSTemp<=(others=>'0');
 		end if;
	end if;
end Process;
	ControlSignals <= CSTemp;
end ContolUnit_Arch;