LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- definir os bits de saída e estados

ENTITY control IS
    PORT (
        clk_in : IN STD_LOGIC;
        reset_in : IN STD_LOGIC := '1';
        enable_in : IN STD_LOGIC := '0';
        op_code_in : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
        stage_out : OUT STD_LOGIC_VECTOR (16 DOWNTO 0));

END control;

ARCHITECTURE Behavioral OF control IS
    SIGNAL stage : STD_LOGIC_VECTOR(16 DOWNTO 0) := "00000000000000000";
    --SIGNAL stage : STD_LOGIC_VECTOR(16 DOWNTO 0) := "00000000000000000";

BEGIN
    PROCESS (clk_in)
    BEGIN
        IF rising_edge(clk_in) AND enable_in = '1' THEN
            IF reset_in = '1' THEN
                stage <= "10000000110000000";
            ELSE
                CASE stage IS

                    WHEN "10000000110000000" => -- 1

                        IF op_code_in = "100001" OR op_code_in = "001010" OR op_code_in = "001101" OR op_code_in(5 DOWNTO 4) = "11" OR op_code_in(5 DOWNTO 4) = "01" THEN
                            stage <= "00000000000100100"; -- 2
                        ELSIF op_code_in(5 DOWNTO 4) = "00" THEN
                            stage <= "00000000000101000"; -- 6

                        ELSIF op_code_in(5 DOWNTO 4) = "10" THEN
                            stage <= "00000000000110000"; -- 11
                        END IF;

                    WHEN "00000000000100100" => -- 2
                        IF op_code_in = "110001" OR op_code_in = "110011" THEN
                            stage <= "01100000000000000"; -- 3
                        ELSIF op_code_in = "110000" THEN
                            stage <= "00000000011100000"; -- 5
                        ELSE
                            stage <= "00000000000100000"; -- 4

                        END IF;

                    WHEN "01100000000000000" => -- 3
                        stage <= "00000000000100000"; -- 4

                    WHEN "00000000000100000" => -- 4
                        IF op_code_in(5 DOWNTO 4) = "11" THEN
                            stage <= "00000000011100000"; -- 5 
                        ELSIF op_code_in = "001101" THEN
                            stage <= "00001000000000000"; -- 7
                        ELSIF op_code_in = "001010" THEN
                            stage <= "01010000000000000"; -- 8
                        ELSIF op_code_in = "000101" THEN
                            stage <= "01011000000000000"; -- 10
                        ELSIF op_code_in(5 DOWNTO 4) = "00" OR op_code_in(5 DOWNTO 4) = "01" THEN
                            stage <= "01000000000000000"; -- 9

                        ELSIF op_code_in = "100000" OR op_code_in = "100011" THEN
                            stage <= "00000010100000000"; -- 12
                        ELSIF op_code_in = "100010" THEN
                            stage <= "01110011000100000"; --18
                        ELSIF op_code_in(5 DOWNTO 4) = "10" THEN
                            stage <= "00000011000000001"; -- 17

                        END IF;

                    WHEN "00000000011100000" => -- 5
                        stage <= "10000000110000000"; -- 1

                    WHEN "00000000000101000" => -- 6
                        stage <= "00000000000100000"; -- 4

                    WHEN "00001000000000000" => -- 7
                        stage <= "10000000110000000"; -- 1

                    WHEN "01010000000000000" => -- 8
                        stage <= "10000000110000000"; -- 1

                    WHEN "01000000000000000" => -- 9
                        stage <= "10000000110000000"; -- 1

                    WHEN "01011000000000000" => -- 10
                        stage <= "10000000110000000"; -- 1

                    WHEN "00000000000110000" => -- 11
                        IF op_code_in = "100010" THEN
                            stage <= "00000000000100000"; -- 18
                        ELSE
                            stage <= "00000000000100000"; -- 4
                        END IF;

                    WHEN "00000010100000000" => -- 12
                        stage <= "01000100000000000"; -- 13

                    WHEN "01000100000000000" => -- 13
                        IF op_code_in = "100011" THEN
                            stage <= "00000000000010000"; -- 14
                        ELSE
                            stage <= "10000000110000000"; -- 1
                        END IF;

                    WHEN "00000000000010000" => -- 14
                        stage <= "00000000000100010"; -- 15

                    WHEN "00000000000100010" => -- 15
                        stage <= "01110000000000000"; -- 16

                    WHEN "01110000000000000" => -- 16
                        stage <= "10000000110000000"; -- 1

                    WHEN "00000011000000001" => -- 17
                        stage <= "10000000110000000"; -- 1

                    WHEN "01110011000100000" => -- 18
                        stage <= "10000000110000000"; -- 1

                    WHEN OTHERS =>
                        stage <= "00000000000000000";
                        --stage <= "00000000000000000";
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    stage_out <= stage;

END Behavioral;