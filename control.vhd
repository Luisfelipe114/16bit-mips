LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- definir os bits de saída e estados

ENTITY control IS
    PORT (
        clk_in : IN STD_LOGIC;
        reset_in : IN STD_LOGIC;
        op_code_in : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
        stage_out : OUT STD_LOGIC_VECTOR (5 DOWNTO 0));

END control;

ARCHITECTURE Behavioral OF control IS
    SIGNAL stage : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000001";

BEGIN
    PROCESS (clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reset_in = '1' THEN
                stage <= "000001";
            ELSE
                CASE stage IS

                    WHEN OTHERS =>
                        stage <= "000001";
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    stage_out <= stage;

END Behavioral;