LIBRARY ieee;
LIBRARY work;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU IS
     GENERIC (n : INTEGER := 32);
     PORT (
          clk, rst, CCR_enable, BranchOP : IN STD_LOGIC;
          Rsrc, Rdst : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
          result : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
          ALUControl : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
          CCR : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          BranchEnable : OUT STD_LOGIC
     );
     --carry, zero and negative flags

END ENTITY ALU;

ARCHITECTURE structALU OF ALU IS
     COMPONENT nBitsAdder IS
          PORT (
               A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
               Cin : IN STD_LOGIC;
               F : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
               Cout : OUT STD_LOGIC);
     END COMPONENT;

     SIGNAL carryIn, carryOut : STD_LOGIC;
     SIGNAL operand1, operand2, ALUResult, adderResult : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
     SIGNAL zero : STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0');
     SIGNAL shift : INTEGER := 0;
     SIGNAL flag : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";

BEGIN
     shift <= to_integer(unsigned(Rdst(4 downto 0))) when ALUControl = "01100" or ALUControl = "01101"
          else      1;

     PROCESS (clk)
     BEGIN
          IF RISING_EDGE(clk) THEN
               flag <= CCR;
          END IF;
     END PROCESS;
     operand1 <= Rsrc WHEN ALUControl = "00111" --add
          OR ALUControl = "01001" --sub
          OR ALUControl = "01110" --ldd
          OR ALUControl = "01000" --iadd
          OR ALUControl = "01111" --std

          ELSE
          Rdst WHEN ALUControl = "00100" --inc
          OR ALUControl = "00101" --dec

          ELSE
          (OTHERS => '0');

     operand2 <= Rdst WHEN ALUControl = "00111" --add
          OR ALUControl = "01000" --iadd
          OR ALUControl = "01110" --ldd
          OR ALUControl = "01111" --std

          ELSE
          (NOT Rdst) WHEN ALUControl = "01001" --sub
          ELSE
          (OTHERS => '1') WHEN ALUControl = "00101" --dec      
          ELSE
          (OTHERS => '0');
     carryIn <= '1' WHEN ALUControl = "00100" --inc
          OR ALUControl = "01001" --sub

          ELSE
          '0';

     u0 : nBitsAdder GENERIC MAP(n) PORT MAP(operand1, operand2, carryIn, adderResult, carryOut);

     ALUResult <= Rdst WHEN ALUControl = "00000" --nop
          OR ALUControl = "10000" --jz           
          OR ALUControl = "10001" --jn
          OR ALUControl = "10010" --jc             
          OR ALUControl = "10011" --jmp
          OR ALUControl = "10100" --ldm
          ELSE
          Rsrc WHEN ALUControl = "00110" --mov
          ELSE
          Rsrc AND Rdst WHEN ALUControl = "01010" --and

          ELSE
          Rsrc OR Rdst WHEN ALUControl = "01011" --or  

          ELSE
          (NOT Rdst) WHEN ALUControl = "00011" --not

          ELSE
          adderResult WHEN ALUControl = "00111" --add
          OR ALUControl = "01001" --sub
          OR ALUControl = "00100" --inc 
          OR ALUControl = "00101" --dec
          OR ALUControl = "01000" --iadd
          OR ALUControl = "01110" --ldd
          OR ALUControl = "01111" --std

          ELSE
          STD_LOGIC_VECTOR(shift_left(unsigned(Rsrc), shift)) WHEN ALUControl = "01100" --shl
          ELSE
          STD_LOGIC_VECTOR(shift_right(unsigned(Rsrc), shift)) WHEN ALUControl = "01101" --shr

          ELSE
          (OTHERS => '0');

     result <= (OTHERS => '0') WHEN rst = '1'
          ELSE
          ALUResult;
     CCR(0) <= '0' WHEN rst = '1' --rst
          OR (CCR_enable = '1' AND ALUControl = "00010") --clrc 
          OR (ALUControl = b"10010" AND clk = '0') --jc

          ELSE
               '1' WHEN CCR_enable = '1' AND ALUControl = "00001" --setc    

          ELSE
               carryOut WHEN CCR_enable = '1' AND (ALUControl = "00111" --add
               OR ALUControl = "01001" --sub
               OR ALUControl = "00100" --inc
               OR ALUControl = "00101" --dec 
               OR ALUControl = "00111" --iadd
               OR ALUControl = "01110" --ldd	
               OR ALUControl = "01111") --std		

          ELSE
               Rsrc(n - shift) WHEN CCR_enable = '1' AND ALUControl = "01100" AND shift /= 0 --shl

          ELSE
               Rsrc(shift - 1) WHEN CCR_enable = '1' AND ALUControl = "01101" AND shift /= 0 --shr

          ELSE
               CCR(0);

     CCR(1) <= '0' WHEN rst = '1' --rst
          OR (ALUControl = "10001" AND clk = '0') --jn

          ELSE
               ALUResult(n - 1) WHEN CCR_enable = '1'

          ELSE
               CCR(1);

     CCR(2) <= '0' WHEN rst = '1' --rst
          OR (ALUControl = "10000" AND clk = '0') --jz
          OR (CCR_enable = '1' AND ALUResult /= zero)

          ELSE
               '1' WHEN (CCR_enable = '1' AND ALUResult = zero
               AND ALUControl /= "00001" AND ALUControl /= "00010")

          ELSE
               CCR(2);

     BranchEnable <= '1' WHEN BranchOP = '1' AND ((CCR(0) = '1' AND ALUControl = "10010") OR (CCR(1) = '1' AND ALUControl = "10001") OR (CCR(2) = '1' AND ALUControl = "10000"))
               ELSE
               '0';

END structALU;