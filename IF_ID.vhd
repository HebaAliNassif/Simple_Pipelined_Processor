LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY IF_ID IS
    PORT (
        Clock, Reset, Enable, Stall : IN STD_LOGIC;
        instruction_in, immediate_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        pc_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instruction_out, immediate_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        pc_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END IF_ID;

ARCHITECTURE ModelIF_ID OF IF_ID IS
BEGIN
    PROCESS (Clock, Reset, Enable)
    BEGIN
        IF Reset = '1' THEN
            instruction_out <= (OTHERS => '0');
            immediate_out <= (OTHERS => '0');
            pc_out <= (OTHERS => '0');
        ELSIF rising_edge(Clock) THEN
            IF Enable = '1' AND Stall = '0' THEN
                instruction_out <= instruction_in;
                immediate_out <= immediate_in;
                pc_out <= pc_in;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;