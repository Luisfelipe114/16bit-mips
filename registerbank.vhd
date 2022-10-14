LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
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
    TYPE reg_array IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR (15 DOWNTO 0);
    TYPE reg_rd_fields IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL REGISTER : reg_array := ("0000000000000000");
    SIGNAL REGISTERS_RD : reg_rd_fields := ("0000");

BEGIN
    PROCESS (clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reg_write = '0' THEN
                data_out_1 <= REGISTER(to_integer(unsigned(RD_data_in)));
                data_out_2 <= REGISTER(to_integer(unsigned(RF_data_in)));
            ELSE
                REGISTER(to_integer(unsigned(write_reg))) <= write_data;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;