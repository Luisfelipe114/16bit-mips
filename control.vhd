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
    SIGNAL stage : STD_LOGIC_VECTOR(5 DOWNTO 0) := "1000000011000000";

BEGIN
    PROCESS (clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reset_in = '1' THEN
                stage <= "1000000011000000";
            ELSE
                CASE stage IS

                    WHEN "1000000011000000" => -- 1

                        IF op_code_in = "100001" OR op_code_in = "001010" OR op_code_in(5 DOWNTO 4) = "11" OR op_code_in(5 DOWNTO 4) = "01" THEN
                            stage <= "0000000000010010"; -- 2
                        ELSE
                            IF op_code_in(5 DOWNTO 4) = "00" THEN
                                stage <= "0000000000010100"; -- 6

                            ELSE
                                IF op_code_in(5 DOWNTO 4) = "10" THEN
                                    stage <= "0000000000011000"; -- 11
                                END IF;
                            END IF;
                        END IF;

                    WHEN "0000000000010010" => -- 2
                        IF op_code_in = "110001" OR op_code_in = "110011" THEN
                            stage <= "0110000000000000"; -- 3
                        ELSE
                            IF op_code_in(5 DOWNTO 4) = "11" THEN
                                stage <= "0000000001110000"; -- 5
                            ELSE
                                IF op_code_in(5 DOWNTO 4) = "00" OR op_code_in(5 DOWNTO 4) = "01" THEN
                                    stage <= "0000000000001000"; -- 4
                                END IF;
                            END IF;
                        END IF;

                    WHEN "0110000000000000" => -- 3
                        stage <= "0000000000010000"; -- 4

                    WHEN "0000000000010000" => -- 4
                        IF op_code_in(5 DOWNTO 4) = "11" THEN
                            stage <= "0000000001110000"; -- 5
                        ELSE
                            IF op_code_in = "001101" THEN
                                stage <= "0000100000000000"; -- 7
                            ELSE
                                IF op_code_in = "001010" THEN
                                    stage <= "0101000000000000"; -- 8
                                ELSE
                                    IF op_code_in(5 DOWNTO 4) = "00" THEN
                                        stage <= "0100000000000000"; -- 9
                                    ELSE
                                        IF op_code_in = "000101" THEN
                                            stage <= "0101100000000000"; -- 10
                                        ELSE
                                            IF op_code_in = "100000" OR op_code_in = "100011" THEN
                                                stage <= "0000001010000000"; -- 12
                                            ELSE
                                                IF op_code_in(5 DOWNTO 4) = "10" THEN
                                                    stage <= "0000001100000000"; -- 17

                                                END IF;
                                            END IF;
                                        END IF;
                                    END IF;
                                END IF;
                            END IF;
                        END IF;

                    WHEN "0000000001110000" => -- 5
                        stage <= "1000000011000000"; -- 1

                    WHEN "0000000000010100" => -- 6
                        stage <= "0000000000010000"; -- 4

                    WHEN "0000100000000000" => -- 7
                        stage <= "1000000011000000"; -- 1

                    WHEN "0101000000000000" => -- 8
                        stage <= "1000000011000000"; -- 1

                    WHEN "0100000000000000" => -- 9
                        stage <= "1000000011000000"; -- 1

                    WHEN "0101100000000000" => -- 10
                        stage <= "1000000011000000"; -- 1

                    WHEN "0000000000011000" => -- 11
                        IF op_code_in = "100010" THEN
                            stage <= "0000000000010000"; -- 18
                        ELSE
                            stage <= "0000000000010000"; -- 4
                        END IF;

                    WHEN "0000001010000000" => -- 12
                        IF op_code_in = "100011" THEN
                            stage <= "0100010000000000"; -- 13
                        ELSE
                            stage <= "1000000011000000"; -- 1
                        END IF;

                    WHEN "0100010000000000" => -- 13
                        stage <= "0000000000001000"; -- 14

                    WHEN "0000000000001000" => -- 14
                        stage <= "0000000000010001"; -- 15

                    WHEN "0000000000010001" => -- 15
                        stage <= "0111000000000000"; -- 16

                    WHEN "0111000000000000" => -- 16
                        stage <= "1000000011000000"; -- 1

                    WHEN "0000001100000000" => -- 17
                        stage <= "1000000011000000"; -- 1

                    WHEN "0000000000010000" => -- 18
                        stage <= "0111001100010000";-- 19

                    WHEN "0111001100010000" => -- 19
                        stage <= "1000000011000000"; -- 1

                    WHEN OTHERS =>
                        stage <= "1000000011000000";
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    stage_out <= stage;

END Behavioral;