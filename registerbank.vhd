LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY registerfile IS
    PORT (
        clk_in : IN STD_LOGIC;
        reg_write : IN STD_LOGIC;
        write_reg : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        RS_data_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        RT_data_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        RD_data_in : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        data_out_1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        data_out_2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END registerfile;

ARCHITECTURE Behavioral OF registerfile IS
    TYPE reg_array IS ARRAY(0 TO 15) OF STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL REGISTER : reg_array := (OTHERS => x"0000");

BEGIN
    PROCESS (clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reg_write = '0' THEN
                data_out_1 <= REGISTER(to_integer(unsigned(RS_data_in)));
                data_out_2 <= REGISTER(to_integer(unsigned(RT_data_in)));
            ELSE
                REGISTER(to_integer(unsigned(write_reg))) <= write_data;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;