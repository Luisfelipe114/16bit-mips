LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY registerfile IS
    PORT (
        clk_in : IN STD_LOGIC;
        reg_write : IN STD_LOGIC;
        write_reg : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        address_in_1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        address_in_2 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        data_out_1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        data_out_2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END registerfile;

ARCHITECTURE Behavioral OF registerfile IS
    TYPE reg_array IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL REGISTERS : reg_array := (OTHERS => x"0000");

BEGIN
    PROCESS (clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reg_write = '0' THEN
                data_out_1 <= REGISTERS(to_integer(unsigned(address_in_1)));
                data_out_2 <= REGISTERS(to_integer(unsigned(address_in_2)));
            ELSE
                REGISTERS(to_integer(unsigned(write_reg))) <= write_data;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;