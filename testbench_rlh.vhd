LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY testbench_rlh IS

END testbench_rlh;

ARCHITECTURE Type_0 OF testbench_rlh IS

    CONSTANT Clk_period : TIME := 40 ns;
    SIGNAL Clk_count : INTEGER := 0;
    SIGNAL Signal_Clk : STD_LOGIC := '0';

    SIGNAL Signal_rlh_write : STD_LOGIC := '0';
    SIGNAL Signal_rlh_reg : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";
    SIGNAL Signal_data_in : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";
    SIGNAL Signal_data_out : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";

    COMPONENT rlh IS

        PORT (
            clk_in : IN STD_LOGIC;
            rlh_write : IN STD_LOGIC;
            rlh_reg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            data_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );

    END COMPONENT;

BEGIN

    Dut : rlh

    PORT MAP(
        clk_in => Signal_Clk,
        rlh_write => Signal_rlh_write,
        rlh_reg => Signal_rlh_reg,
        data_in => Signal_data_in,
        data_out => Signal_data_out
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
        Signal_rlh_write <= '1';
        Signal_data_in <= "00000000000000000000000000001000";
        WAIT FOR 40 ns;
        Signal_rlh_write <= '0';
        WAIT FOR 40 ns;
        REPORT "Data Out: " & INTEGER'image(to_integer(unsigned(Signal_data_out)));
        WAIT;

    END PROCESS Input_Process;
END Type_0;