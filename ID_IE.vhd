LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity ID_IE is
    port(Clock, Reset, Enable, Stall : in std_logic;
            pc_in, regReadDataValue1_in,  regReadDataValue2_in: in std_logic_vector(31 downto 0);
            pc_out, regReadDataValue1_out,  regReadDataValue2_out: out std_logic_vector(31 downto 0);
            regReadDataIndex1_in,  regReadDataIndex2_in: in std_logic_vector(2 downto 0);
            regReadDataIndex1_out,  regReadDataIndex2_out: out std_logic_vector(2 downto 0);
            immediateValue_in: in std_logic_vector(15 downto 0);
            controlSignals_in: in std_logic_vector(18 downto 0);
            immediateValue_out: out std_logic_vector(15 downto 0);
            controlSignals_out: out std_logic_vector(18 downto 0)
            );
end ID_IE;

architecture ModelID_IE of ID_IE is
begin
	process (Clock, Reset, Enable)
	begin
		if Reset = '1' then
            pc_out <= (others=>'0');
            regReadDataValue1_out <= (others=>'0');
            regReadDataValue2_out <= (others=>'0');
            immediateValue_out <= (others=>'0');
            controlSignals_out <= (others=>'0');
            regReadDataIndex1_out <= (others=>'0');
            regReadDataIndex2_out <= (others=>'0');
		elsif rising_edge(Clock) then
			if Enable = '1' and Stall = '0' then
                pc_out <= pc_in;
                regReadDataValue1_out <= regReadDataValue1_in;
                regReadDataValue2_out <= regReadDataValue2_in;
                immediateValue_out <= immediateValue_in;
                controlSignals_out <= controlSignals_in;
                regReadDataIndex1_out <= regReadDataIndex1_in;
                regReadDataIndex2_out <= regReadDataIndex2_in;
			end if;
		end if;
	end process;
end architecture;