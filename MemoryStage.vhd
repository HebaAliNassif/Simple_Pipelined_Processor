LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY MemoryStage IS
    GENERIC (n : INTEGER := 32);
    PORT (
        Clock, Reset : IN STD_LOGIC;
        Rdst_Data, SP, PC, AluOutput : IN STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
        ControlSignals : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
        MemOutput, SP_Out, PC_Out : OUT STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
        FirstLocationValue :  OUT STD_LOGIC_VECTOR((n - 1) DOWNTO 0)
    );
END MemoryStage;

ARCHITECTURE MemoryStage_Arch OF MemoryStage IS

    COMPONENT Memory IS
        GENERIC (
            n : INTEGER := 32;
            SpaceSize : INTEGER := 1000);
        PORT (
            Clock, Mem_Write, Reset : IN STD_LOGIC;
            Address : IN STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
            Write_Data : IN STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
            Read_Data : OUT STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
            FirstLocationValue :  OUT STD_LOGIC_VECTOR((n - 1) DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL MemWriteSignal,MemReadSignal, SPSrc, PC_To_Mem : STD_LOGIC := '0';
    SIGNAL Address, Write_Data, Read_Data, CurrentSP, firstMemoryLocationValue : STD_LOGIC_VECTOR((n - 1) DOWNTO 0) := (OTHERS => '0');
    SIGNAL SP_OP : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    MemWriteSignal <= ControlSignals(5);
	MemReadSignal<=ControlSignals(19);

    SPSrc <= ControlSignals(9);
    SP_OP(1 DOWNTO 0) <= ControlSignals(11 DOWNTO 10);

    CurrentSP <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(SP)) - 2, CurrentSP'length)) WHEN SP_OP = "10" AND Clock = '1' and MemWriteSignal='1'
        ELSE
        STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(SP)) + 2, CurrentSP'length)) WHEN SP_OP = "01" AND Clock = '1' and MemReadSignal='1'
        ELSE
        (OTHERS => '0') WHEN Reset = '1'
        ELSE
        SP;

    Address <= CurrentSP WHEN SPSrc = '1' AND MemReadSignal = '1'
        ELSE
        SP WHEN SPSrc = '1' AND MemWriteSignal = '1'
        ELSE
        AluOutput WHEN SPSrc = '0' AND (MemWriteSignal = '1' or MemReadSignal='1')
        ELSE
        (OTHERS => '0');

    PC_To_Mem <= ControlSignals(4);
    Write_Data <= PC WHEN PC_To_Mem = '1'
        ELSE
        Rdst_Data;
    DataMemory : Memory GENERIC MAP(n, 1048576) PORT MAP(Clock, MemWriteSignal, Reset, Address, Write_Data, Read_Data, firstMemoryLocationValue);

    MemOutput <= (OTHERS => '0') WHEN Reset = '1'
        ELSE
        Read_Data;

    SP_Out <= CurrentSP;
    FirstLocationValue <= firstMemoryLocationValue;
    PC_Out <= PC;
END MemoryStage_Arch;