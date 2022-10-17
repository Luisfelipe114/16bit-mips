LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY registerbank IS
    PORT (
        clk_in : IN STD_LOGIC;
        reg_write : IN STD_LOGIC;
        ctrl_reg_dest : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
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
END registerbank;

ARCHITECTURE Behavioral OF registerbank IS
    TYPE reg_array IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR (15 DOWNTO 0);
    TYPE reg_array_rd IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR (15 DOWNTO 0);

    SIGNAL REGISTERS : reg_array := (OTHERS => x"0000");
    SIGNAL REGISTERS_RD : reg_array_rd := (OTHERS => x"0000");

    --VARIABLE address_read_1 : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
    --VARIABLE write_address : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";

BEGIN
    PROCESS (clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reg_write = '0' THEN
					case ctrl_address_read_A is
						when "00" =>
							data_out_1 <= REGISTERS_RD(to_integer(unsigned(address_rd)));
						when "01" =>
							data_out_1 <= REGISTERS(to_integer(unsigned(address_rf2)));
						when others =>
							data_out_1 <= REGISTERS(to_integer(unsigned(address_sp)));
                end case;

                data_out_2 <= REGISTERS(to_integer(unsigned(address_rf1)));
            ELSE
					case ctrl_reg_dest is 
						when "00" =>
							REGISTERS_RD(to_integer(unsigned(address_rd))) <= write_data;
						when "01" =>
							REGISTERS_RD(to_integer(unsigned(address_rf1))) <= write_data;
						when "10" =>
							REGISTERS_RD(to_integer(unsigned(address_j))) <= write_data;
						when others =>
							REGISTERS_RD(to_integer(unsigned(address_sp))) <= write_data;
					end case;

                
            END IF;
        END IF;
    END PROCESS;
END Behavioral;