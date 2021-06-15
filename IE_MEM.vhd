LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY IE_MEM IS PORT (
    Clock, Reset, Enable : IN STD_LOGIC;
    pc_in, regReadDataValue1_in, regReadDataValue2_in, AluOutput_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    pc_out, regReadDataValue1_out, regReadDataValue2_out, AluOutput_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    regReadDataIndex1_in, regReadDataIndex2_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    regReadDataIndex1_out, regReadDataIndex2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    controlSignals_in : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    controlSignals_out : OUT STD_LOGIC_VECTOR(19 DOWNTO 0));
END IE_MEM;

ARCHITECTURE ModelIE_MEM OF IE_MEM IS BEGIN
    PROCESS (Clock, Reset, Enable) BEGIN
        IF Reset = '1' THEN
            pc_out <= (OTHERS => '0');
            regReadDataValue1_out <= (OTHERS => '0');
            regReadDataValue2_out <= (OTHERS => '0');
            AluOutput_out <= (OTHERS => '0');
            controlSignals_out <= (OTHERS => '0');
            regReadDataIndex1_out <= (OTHERS => '0');
            regReadDataIndex2_out <= (OTHERS => '0');
        ELSIF rising_edge(Clock)AND Enable = '1' THEN
            pc_out <= pc_in;
            regReadDataValue1_out <= regReadDataValue1_in;
            regReadDataValue2_out <= regReadDataValue2_in;
            AluOutput_out <= AluOutput_in;
            controlSignals_out <= controlSignals_in;
            regReadDataIndex1_out <= regReadDataIndex1_in;
            regReadDataIndex2_out <= regReadDataIndex2_in;
        END IF;
    END PROCESS;
END ARCHITECTURE;