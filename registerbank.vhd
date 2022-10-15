LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY registerfile IS
    PORT (
        clk_in : IN STD_LOGIC;
        reg_write : IN STD_LOGIC;
        rd_write : IN STD_LOGIC;
        address_read_A : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        address_sp : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        address_rf1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        address_rf2 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        address_rd : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        write_reg : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        data_out_1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        data_out_2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END registerfile;

ARCHITECTURE Behavioral OF registerfile IS
    TYPE reg_array IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR (15 DOWNTO 0);
    TYPE reg_array_rd IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL REGISTERS : reg_array := (OTHERS => x"0000");
    SIGNAL REGISTERS_RD : reg_array_rd := (OTHERS => x"0000");

BEGIN
    CLOCK : PROCESS (clk_in, rd_write, write_data, write_reg)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reg_write = '0' THEN
                IF address_read_A = "00" THEN
                    data_out_1 <= REGISTERS_RD(to_integer(unsigned(address_rd)));
                ELSIF address_read_A = "01" THEN
                    data_out_1 <= REGISTERS(to_integer(unsigned(address_rf2)));
                ELSIF address_read_A = "10" THEN
                    data_out_1 <= REGISTERS(to_integer(unsigned(address_sp)));
                END IF;
                data_out_2 <= REGISTERS(to_integer(unsigned(address_rf1)));
            ELSE
                IF rd_write = '0' THEN
                    REGISTERS(to_integer(unsigned(write_reg))) <= write_data;
                ELSE
                    REGISTERS_RD(to_integer(unsigned(write_reg))) <= write_data;
                END IF;
            END IF;
        END IF;
    END PROCESS CLOCK;
END Behavioral;