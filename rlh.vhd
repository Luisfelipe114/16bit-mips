LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY rlh IS
    PORT (
        clk_in : IN STD_LOGIC;
		  enable_in : IN STD_LOGIC;
        rlh_write : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END rlh;

ARCHITECTURE Behavioral OF rlh IS
    --TYPE reg_array IS ARRAY (0 TO 0) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL Signal_data_out : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
    SIGNAL RLH : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000001111111111111111";
BEGIN
    PROCESS (clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF rlh_write = '0' THEN
                Signal_data_out <= RLH;
            ELSE
                RLH <= data_in;
            END IF;
        END IF;
    END PROCESS;
	 
	 data_out <= Signal_data_out;

END Behavioral;