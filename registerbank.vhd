LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY registerfile IS
    PORT (
        clk_in : IN STD_LOGIC;
        reg_write : IN STD_LOGIC;
        write_reg : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        RF2_or_shift_data_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        RF_data_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        RD_data_in : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        data_out_1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        data_out_2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END registerfile;

ARCHITECTURE Behavioral OF registerfile IS
    TYPE reg_array IS ARRAY (0 TO 11) OF STD_LOGIC_VECTOR (15 DOWNTO 0);
    TYPE reg_rd_fields IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL REGISTERS : reg_array := (OTHERS => x"0000");
    SIGNAL REGISTERS_RD : reg_rd_fields := (OTHERS => x"0000");

BEGIN
    PROCESS (clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reg_write = '0' THEN
                data_out_1 <= REGISTERS(to_integer(unsigned(RD_data_in)));
                data_out_2 <= REGISTERS(to_integer(unsigned(RF_data_in)));
            ELSE
                REGISTERS(to_integer(unsigned(write_reg))) <= write_data;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;