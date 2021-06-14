library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
     generic (n : integer := 32);
     port (clk, rst, CCR_enable,BranchOP: in std_logic;
           Rsrc, Rdst: in std_logic_vector(n-1 downto 0);
           result: out std_logic_vector(n-1 downto 0);
           ALUControl : in std_logic_vector(4 downto 0);
	   CCR: inout std_logic_vector(2 downto 0);
	   BranchEnable: out std_logic
	   ); 
	   --carry, zero and negative flags
	   
end entity ALU;

architecture structALU of ALU is
     component nBitsAdder is
          port (A, B : in std_logic_vector(n-1 downto 0);
                Cin: in std_logic;
		F : out std_logic_vector (n-1 downto 0); 
		Cout : out std_logic);
     end component;
     
     signal carryIn, carryOut : std_logic;
     signal operand1, operand2, ALUResult, adderResult : std_logic_vector(n-1 downto 0); 
     signal zero: std_logic_vector(n-1 downto 0) := (others => '0');
     signal shift : integer := 0;
     signal flag: std_logic_vector (2 downto 0):= "000";
  
begin
shift <= to_integer(unsigned(Rdst(4 downto 0)));

process(clk)
     begin
        if clk = '1' then
            flag <= CCR;
        end if;
     end process;

     
     operand1 <= Rsrc            when ALUControl = "00111"                               --add
                                   or ALUControl = "01001"                               --sub
 				   or ALUControl = "01110"				 --ldd
 				   or ALUControl = "01000"				 --std
				   or ALUControl = "00111"                               --iadd
				 
     else Rdst                   when ALUControl = "00100"                               --inc
                                   or ALUControl = "00101"                               --dec

     else (others => '0');

     operand2 <= Rdst            when ALUControl = "00111"                               --add
				   or ALUControl = "01000"                               --iadd
 				   or ALUControl = "01110"				 --ldd
 				   or ALUControl = "01111" 				 --std
     
     else (NOT Rdst)             when ALUControl = "01001"                               --sub
     else (others => '1')        when ALUControl = "00101"                               --dec      
     else (others => '0');


     carryIn <= '1'              when ALUControl = "00100"                               --inc
                                   or ALUControl = "01001"                               --sub

     else '0';

    u0: nBitsAdder generic map(n) port map(operand1, operand2, carryIn, adderResult, carryOut);

    ALUResult <= Rsrc            when ALUControl = "00000"                                --nop
                                   or ALUControl = "00110"                                --mov
				   or ALUControl = "10000"	                          --jz           
				   or ALUControl = "10001"                                --jn
				   or ALUControl = "10010"                                --jc             
  				   or ALUControl = "10011"                                --jmp
                                   or ALUControl = "00110"                                --ldm


    else Rsrc AND Rdst           when ALUControl = "01010"                                --and

    else Rsrc OR Rdst            when ALUControl = "01011"                                --or  

    else (NOT Rdst)               when ALUControl = "00011"                               --not
          
    else adderResult             when ALUControl = "00111"				  --add
                                   or ALUControl = "01001"                                --sub
                                   or ALUControl = "00100"                                --inc 
                                   or ALUControl = "00101"                                --dec
				   or ALUControl = "01000"                                --iadd
     				   or ALUControl = "01110"				  --ldd
 				   or ALUControl = "01111" 				  --std

    else std_logic_vector(shift_left(unsigned(Rsrc), shift)) when ALUControl = "01100"    --shl


    else std_logic_vector(shift_right(unsigned(Rsrc), shift)) when ALUControl = "01101"   --shr

    else (others => '0');

    result <= (others => '0') when rst = '1'
    else ALUResult;
    

    CCR(0) <= '0'               when rst ='1'                                             --rst
                                  or (CCR_enable = '1' and ALUControl = "00010")          --clrc 
                                  or (ALUControl = b"10010" and clk = '0')                --jc

    else '1'                    when CCR_enable = '1' and ALUControl = "00001"            --setc    

    else carryOut               when CCR_enable = '1' and (ALUControl = "00111"           --add
                                                        or ALUControl = "01001"           --sub
                                                        or ALUControl = "00100"           --inc
                                                        or ALUControl = "00101"           --dec 
                                                        or ALUControl = "00111"           --iadd
 				                        or ALUControl = "01110"	          --ldd	
		  				        or ALUControl = "01111")	  --std		
	  
    else Rsrc(n-shift)          when CCR_enable = '1' and ALUControl = "01100"            --shl

    else Rsrc(shift-1)          when CCR_enable = '1' and ALUControl = "01101"            --shr

    else CCR(0);


    CCR(1) <= '0'               when rst ='1'                                             --rst
                                  or (ALUControl = "10001" and clk = '0')                 --jn

    else ALUResult(n-1)         when CCR_enable = '1'

    else CCR(1);


    CCR(2) <= '0'               when rst ='1'                                             --rst
				or (ALUControl = "10000" and clk = '0')                   --jz
				or (CCR_enable = '1' and ALUResult /= zero)                                                     
 
    else '1'                    when (CCR_enable = '1' and ALUResult = zero
                                  and ALUControl /= "00001" and ALUControl /= "00010")               

    else CCR(2); 
	
	BranchEnable<='1' when BranchOP='1' and ((CCR(0)='1' and ALUControl="10010") or (CCR(1)='1' and ALUControl="10001") or (CCR(2)='1' and ALUControl="10000"))
	else '0';
	
end structALU;