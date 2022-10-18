LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE std.textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY ula IS
	PORT (
		clk_in : IN STD_LOGIC;
		enable_in : IN STD_LOGIC;
		alu_op_in : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		pc_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		constant_1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		constant_0 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rM_data_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rN_data_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rlh_data_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		shift_data_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		imm_data_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		j_imm_data_in : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		rlh_data_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		result_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		branch_out : OUT STD_LOGIC
		--rD_write_enable_in : in STD_LOGIC;
		--rD_write_enable_out : out STD_LOGIC);
	);
END ula;

-- TODO: handle overflow correctly, add more than EQ to branching
ARCHITECTURE Behavioral OF ula IS
	SIGNAL signed_add : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL signed_sub : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL bothpos : STD_LOGIC;
	SIGNAL bothneg : STD_LOGIC;
	SIGNAL overflow : STD_LOGIC;

BEGIN
	PROCESS (clk_in)
	BEGIN

		IF rising_edge(clk_in) AND enable_in = '1' THEN
			CASE alu_op_in(5 DOWNTO 0) IS -- 3-0 is opcode, alu_on_in(4) is condition bit
				WHEN "000000" => -- ADD 
					result_out <= STD_LOGIC_VECTOR(unsigned(rM_data_in) + unsigned(rN_data_in));
					-- unsigned overflow possible
					branch_out <= '0';

				WHEN "000001" => -- SUB 
					result_out <= STD_LOGIC_VECTOR(unsigned(rM_data_in) - unsigned(rN_data_in));
					branch_out <= '0';

				WHEN "000010" => -- LSL RRI(5)
					result_out <= STD_LOGIC_VECTOR(shift_left(unsigned(rM_data_in), to_integer(unsigned(shift_data_in))));
					branch_out <= '0';

				WHEN "000011" => -- LSR RRI(5)
					result_out <= STD_LOGIC_VECTOR(shift_right(unsigned(rM_data_in), to_integer(unsigned((shift_data_in)))));
					branch_out <= '0';

				WHEN "000100" => --SRA
					result_out <= STD_LOGIC_VECTOR(shift_right(signed(rM_data_in), to_integer(unsigned((shift_data_in)))));
					branch_out <= '0';

				WHEN "000101" => --TADM 
					IF rM_data_in(0) = '1' THEN
						rlh_data_out <= STD_LOGIC_VECTOR(shift_left(unsigned(rlh_data_in) + resize(unsigned(rM_data_in), 32), 1));
						result_out <= STD_LOGIC_VECTOR(shift_right(unsigned(rM_data_in), 1));
					ELSE
						result_out <= STD_LOGIC_VECTOR(shift_right(unsigned(rM_data_in), 1));
						rlh_data_out <= STD_LOGIC_VECTOR(shift_left(unsigned(rlh_data_in), 1));
					END IF;
					branch_out <= '0';

				WHEN "000110" => -- AND RRR
					result_out <= rM_data_in AND rN_data_in;
					branch_out <= '0';

				WHEN "000111" => -- OR RRR
					result_out <= rM_data_in OR rN_data_in;
					branch_out <= '0';

				WHEN "001000" => -- XOR RRR
					result_out <= rM_data_in XOR rN_data_in;
					branch_out <= '0';

				WHEN "001001" => -- NOR RRR
					result_out <= rM_data_in NOR rN_data_in;
					branch_out <= '0';

				WHEN "001010" => -- ADDIS
					result_out <= STD_LOGIC_VECTOR(signed(rN_data_in) + resize(signed((imm_data_in(7) & imm_data_in)), 16));
					branch_out <= '0';

				WHEN "001011" => -- SUBIS
					result_out <= STD_LOGIC_VECTOR(signed(rN_data_in) - resize(signed((imm_data_in(7) & imm_data_in)), 16));
					branch_out <= '0';

				WHEN "001100" => -- LOI
					result_out <= x"00" & imm_data_in;
					branch_out <= '0';

				WHEN "001101" => -- LUI
					result_out <= imm_data_in & x"00";
					branch_out <= '0';

				WHEN "001110" => -- LIS
					result_out <= STD_LOGIC_VECTOR(resize(signed(imm_data_in(7) & imm_data_in), 16));
					branch_out <= '0';

				WHEN "001111" => -- ANDI
					result_out <= rN_data_in AND (x"00" & imm_data_in);
					branch_out <= '0';

				WHEN "010000" => -- ORI
					result_out <= rN_data_in OR (x"00" & imm_data_in);
					branch_out <= '0';

				WHEN "010001" => -- XORI
					result_out <= rN_data_in XOR (x"00" & imm_data_in);
					branch_out <= '0';

				WHEN "010010" => -- NORI
					result_out <= rN_data_in NOR (x"00" & imm_data_in);
					branch_out <= '0';

				WHEN "010011" => -- NANDI
					result_out <= rN_data_in NAND (x"00" & imm_data_in);
					branch_out <= '0';

					--TIPO J

				WHEN "010100" => -- JUMP/JAL(parte 2 do JAL)
					result_out <= pc_in(15 DOWNTO 10) & j_imm_data_in;
					branch_out <= '1';

				WHEN "010101" => -- PC Increment
					result_out <= pc_in + constant_1;
					branch_out <= '1';

				WHEN "010110" => -- JR/JRL (parte 2 do JRL)
					result_out <= rN_data_in;
					branch_out <= '1';

				WHEN "010111" => -- JGTZ
					IF rN_data_in > constant_0 THEN
						result_out <= pc_in + constant_1 + (x"00" & imm_data_in);
						branch_out <= '1';
					ELSE
						branch_out <= '0';
					END IF;

				WHEN "011000" => -- JLTZ
					IF signed(rN_data_in) < 0 THEN
						result_out <= pc_in + constant_1 + (x"00" & imm_data_in);
						branch_out <= '1';
					ELSE
						branch_out <= '0';
					END IF;

				WHEN "011001" => -- JNEZ
					IF rN_data_in /= constant_0 THEN
						result_out <= pc_in + constant_1 + (x"00" & imm_data_in);
						branch_out <= '1';
					ELSE
						branch_out <= '0';
					END IF;

				WHEN "011010" => -- JIEZ
					IF rN_data_in = constant_0 THEN
						result_out <= pc_in + constant_1 + (x"00" & imm_data_in);
						branch_out <= '1';
					ELSE
						branch_out <= '0';
					END IF;

				WHEN "011011" => --SLT
					IF rM_data_in < rN_data_in THEN
						result_out <= constant_1;
					ELSE
						result_out <= constant_0;

					END IF;
					branch_out <= '0';

				WHEN "011100" => --SUB SP(PUSH)
					result_out <= rN_data_in - constant_1;
					branch_out <= '0';

				WHEN "011101" => --ADD SP(POP)
					result_out <= rN_data_in + constant_1;
					branch_out <= '0';

				WHEN "011110" => --MFAC (transparencia rN(pop/sw)) 
					result_out <= rN_data_in;
					branch_out <= '0';

				WHEN "011111" => --MTAC
					result_out <= rM_data_in;
					branch_out <= '0';

				WHEN "100001" => --MFH
					result_out <= rlh_data_in(31 DOWNTO 16);
					branch_out <= '0';

				WHEN "100010" => --MFL
					result_out <= rlh_data_in(15 DOWNTO 0);
					branch_out <= '0';

				WHEN "100011" => --MTL
					rlh_data_out(31 DOWNTO 16) <= constant_0;
					rlh_data_out(15 DOWNTO 0) <= rN_data_in;
					branch_out <= '0';

				WHEN "100100" => --transparencia rM(sw/lw)
					result_out <= rM_data_in;
					branch_out <= '0';
				WHEN OTHERS =>
					NULL;
			END CASE;
		END IF;
	END PROCESS;

END Behavioral;