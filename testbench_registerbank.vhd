LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY testbench_registerbank IS

END testbench_registerbank;

ARCHITECTURE Type_0 OF testbench_registerbank IS

    CONSTANT Clk_period : TIME := 40 ns;
    SIGNAL Clk_count : INTEGER := 0;
    SIGNAL Signal_Clk : STD_LOGIC := '0';

    SIGNAL Signal_reg_write : STD_LOGIC := '0';
    SIGNAL Signal_RD_data_in : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL Signal_RF_data_in : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL Signal_RF2_or_shift_data_in : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL Signal_write_reg : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL Signal_write_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    SIGNAL Signal_data_out_1 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    SIGNAL Signal_data_out_2 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";

    COMPONENT registerfile IS

        PORT (
            clk_in : IN STD_LOGIC;
            RF_data_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            RF2_or_shift_data_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            RD_data_in : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            write_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            write_reg : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            reg_write : IN STD_LOGIC;
            data_out_1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            data_out_2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );

    END COMPONENT;

BEGIN

    Dut : registerfile

    PORT MAP(
        clk_in => Signal_Clk,
        RF_data_in => Signal_RF_data_in,
        RF2_or_shift_data_in => Signal_RF2_or_shift_data_in,
        RD_data_in => Signal_RD_data_in,
        write_data => Signal_write_data,
        write_reg => Signal_write_reg,
        reg_write => Signal_reg_write,
        data_out_1 => Signal_data_out_1,
        data_out_2 => Signal_data_out_2
    );

    Clock_Process : PROCESS
    BEGIN
        Signal_Clk <= '0';
        WAIT FOR Clk_period/2;
        Signal_Clk <= '1';
        Clk_count <= Clk_count + 1;
        WAIT FOR Clk_period/2;
        IF (Clk_count = 4) THEN
            REPORT "Stopping simulkation after 4 cycles";
            WAIT;
        END IF;

    END PROCESS Clock_Process;

    Input_Process : PROCESS
    BEGIN
        WAIT FOR 40 ns;
        Signal_reg_write <= '1';
        Signal_write_data <= "0000000000001000";
        Signal_write_reg <= Signal_RF_data_in;
        WAIT FOR 40 ns;
        Signal_reg_write <= '0';
        WAIT FOR 40 ns;
        REPORT "Data Out 2: " & INTEGER'image(to_integer(unsigned(Signal_data_out_2)));
        WAIT;

    END PROCESS Input_Process;
END Type_0;