LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ID_IE IS
      PORT (
            Clock, Reset, Enable, Stall : IN STD_LOGIC;
            pc_in, regReadDataValue1_in, regReadDataValue2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            pc_out, regReadDataValue1_out, regReadDataValue2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            regReadDataIndex1_in, regReadDataIndex2_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            regReadDataIndex1_out, regReadDataIndex2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            immediateValue_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            controlSignals_in : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
            immediateValue_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            controlSignals_out : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
      );
END ID_IE;

ARCHITECTURE ModelID_IE OF ID_IE IS
BEGIN
      PROCESS (Clock, Reset, Enable)
      BEGIN
            IF  rising_edge(Clock) and Reset = '1' THEN
                  pc_out <= (OTHERS => '0');
                  regReadDataValue1_out <= (OTHERS => '0');
                  regReadDataValue2_out <= (OTHERS => '0');
                  immediateValue_out <= (OTHERS => '0');
                  controlSignals_out <= (OTHERS => '0');
                  regReadDataIndex1_out <= (OTHERS => '0');
                  regReadDataIndex2_out <= (OTHERS => '0');
            ELSIF rising_edge(Clock) THEN
                  IF Enable = '1' AND Stall = '0' THEN
                        pc_out <= pc_in;
                        regReadDataValue1_out <= regReadDataValue1_in;
                        regReadDataValue2_out <= regReadDataValue2_in;
                        immediateValue_out <= immediateValue_in;
                        controlSignals_out <= controlSignals_in;
                        regReadDataIndex1_out <= regReadDataIndex1_in;
                        regReadDataIndex2_out <= regReadDataIndex2_in;
                  END IF;
            END IF;
      END PROCESS;
END ARCHITECTURE;