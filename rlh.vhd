LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY rlh IS
    PORT (
        clk_in : IN STD_LOGIC;
        rlh_write : IN STD_LOGIC;
        rlh_reg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        data_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    );
END rlh;

ARCHITECTURE Behavioral OF rlh IS

BEGIN
    PROCESS (clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF rlh_write = '0' THEN
                data_out <= rlh_reg;
            ELSE
                rlh_reg <= data_in;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;