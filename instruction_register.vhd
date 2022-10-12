LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY instruction_register IS
    PORT (
        clk_in : IN STD_LOGIC;
        enable_in : IN STD_LOGIC;
        write_enable_in : IN STD_LOGIC;
        instruction_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        intruction_op_out : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
        imm_data_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- 16 or 8
        sel_rF_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        sel_rF2_or_shift_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        sel_rD_out : OUT STD_LOGIC_VECTOR (1 DOWNTO 0));
END instruction_register;

ARCHITECTURE Behavioral OF instruction_register IS
    SIGNAL reg_instruction : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
BEGIN
    PROCESS (clk_in)
    BEGIN
        IF rising_edge(clk_in) AND enable_in = '1' THEN

            instruction_op_out <= reg_instruction(13 DOWNTO 10);
            sel_rD_out <= reg_instruction(9 DOWNTO 8);
            sel_rF_out <= reg_instruction(7 DOWNTO 4);
            sel_rF2_or_shift_out <= reg_instruction(3 DOWNTO 0);
            imm_data_out <= reg_instruction(7 DOWNTO 0);

            IF write_enable_in = '1' THEN
                reg_instruction <= intruction_in;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;