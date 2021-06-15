library ieee;
use ieee.std_logic_1164.all;

Entity nBitsAdder is    
generic (n : integer := 32);  
port( 
A, B : in std_logic_vector (n-1 downto 0);
Cin : in std_logic; 
F : out std_logic_vector (n-1 downto 0); 
Cout : out std_logic);
end nBitsAdder; 

architecture myAdder of nBitsAdder is 
signal temp : std_logic_vector(n-1 downto 0); 

begin
F(0) <= A(0) xor B(0) xor Cin; 
temp(0) <= (A(0) and B(0)) or (Cin and (A(0) xor B(0)));
 
loop1: for i in 1 to n-1 generate
       	F(i) <= A(i) xor B(i) xor temp(i-1); 
	temp(i) <= (A(i) and B(i)) or (temp(i-1) and (A(i) xor B(i))); 
end generate; 
Cout <= temp(n-1); 
end myAdder;

