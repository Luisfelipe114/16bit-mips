LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY registerfile IS
    PORT (
        clk_in : IN STD_LOGIC;
        reg_write : IN STD_LOGIC;
        ctrl_reg_dest : IN STD_LOGIC;
        ctrl_address_read_A : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        address_sp : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        address_rf1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        address_rf2 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        address_rd : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        address_j : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
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

    VARIABLE address_read_1 : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
    VARIABLE write_address : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000"

BEGIN
    CLOCK : PROCESS (clk_in, rd_write, write_data, write_reg)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reg_write = '0' THEN
                address_read_1 <= address_rd WHEN ctrl_address_read_A = "00" ELSE
                    address_rf2 WHEN ctrl_address_read_A = "01" ELSE
                    address_sp;

                data_out_1 <= REGISTERS_RD(to_integer(unsigned(address_read_1))) WHEN ctrl_address_read_A = "00" ELSE
                    REGISTERS(to_integer(unsigned(address_read_1)));

                data_out_2 <= REGISTERS(to_integer(unsigned(address_rf1)));
            ELSE
                write_address <= address_rd WHEN ctrl_reg_dest = "00" ELSE
                    address_rf1 WHEN ctrl_reg_dest = "01" ELSE
                    address_j WHEN ctrl_reg_dest = "10" ELSE
                    address_sp;

                IF ctrl_reg_dest = "00" THEN
                    REGISTERS_RD(to_integer(unsigned(write_address))) <= write_data;
                ELSE
                    REGISTERS(to_integer(unsigned(write_address))) <= write_data;
                END IF;
            END IF;
        END IF;
    END PROCESS CLOCK;
END Behavioral;