LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE std.textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

ENTITY ula_controle IS
	PORT (
		clk_in : IN STD_LOGIC;
		pop : IN STD_LOGIC;
		store_word : IN STD_LOGIC;
		pc_increment : IN STD_LOGIC;
		codop_signal : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		enable_in : IN STD_LOGIC;
		alu_op_control_in : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		result_out : OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
	);
END ula_controle;

ARCHITECTURE Behavioral OF ula_controle IS

BEGIN
	PROCESS (clk_in)
	BEGIN
		CASE alu_op_control_in (1 DOWNTO 0) IS
			WHEN "00" =>
				CASE codop_signal (3 DOWNTO 0) IS
					WHEN "0000" => --AND 
						result_out <= "000000"; --sinal pra ula
					WHEN "0001" => --SUB
						result_out <= "000001";
					WHEN "0010" => --LSL
						result_out <= "000010";
					WHEN "0011" => --LSR
						result_out <= "000011";
					WHEN "0100" => --SRA
						result_out <= "000100";
					WHEN "0101" => --TADM
						result_out <= "000101";
					WHEN "0110" => --AND
						result_out <= "000110";
					WHEN "0111" => --OR
						result_out <= "000111";
					WHEN "1000" => --XOR
						result_out <= "001000";
					WHEN "1001" => --NOR
						result_out <= "001001";
					WHEN "1010" => --MFAC
						result_out <= "011110";
					WHEN "1011" => --MTAC
						result_out <= "011111";
					WHEN "1100" => --SLT
						result_out <= "011011";
					WHEN "1101" => --MTL
						result_out <= "100011";
					WHEN "1110" => -- MFH
						result_out <= "100001";
					WHEN "1111" => -- MFL
						result_out <= "100010";
					WHEN OTHERS =>
						NULL;
				END CASE;
			WHEN "01" =>
				CASE codop_signal (3 DOWNTO 0) IS
					WHEN "0000" => --ADDIS
						result_out <= "001010";--sinal pra ula
					WHEN "0001" => --SUBIS
						result_out <= "001011";
					WHEN "0010" => --LOI
						result_out <= "001100";
					WHEN "0011" => --LUI
						result_out <= "001101";
					WHEN "0100" => --LIS				
						result_out <= "001110";
					WHEN "0101" => --ANDI				
						result_out <= "001111";
					WHEN "0110" => --ORI			
						result_out <= "010000";
					WHEN "0111" => --XORI			
						result_out <= "010001";
					WHEN "1000" => --NORI			
						result_out <= "010010";
					WHEN "1001" => --NANDI		
						result_out <= "010011";
					WHEN OTHERS =>
						NULL;
				END CASE;

			WHEN "10" =>
				CASE codop_signal (3 DOWNTO 0) IS
					WHEN "0010" => --SUB SP(PUSH)
						result_out <= "011100";--sinal pra ula

					WHEN "0011" => --ADD SP(POP)
						CASE pop IS
							WHEN '1' =>
								result_out <= "011101";
							WHEN '0' =>
								result_out <= "011110";
							WHEN OTHERS =>
								NULL;
						END CASE;

					WHEN "0000" => --LW
						result_out <= "100100";

					WHEN "0001" => --SW
						CASE store_word IS
							WHEN '0' =>
								result_out <= "100100"; --transparencia rM
							WHEN '1' =>
								result_out <= "011110"; --transparencia rN
							WHEN OTHERS =>
								NULL;
						END CASE;
					WHEN OTHERS =>
						NULL;
				END CASE;
			WHEN "11" =>
				IF pc_increment = '1' AND ((codop_signal = "0001") OR (codop_signal = "0010")) THEN
					result_out <= "010101";--JR/JRL
				ELSE
					CASE codop_signal (3 DOWNTO 0) IS
						WHEN "0000" => --JUMP
							result_out <= "010100";--sinal pra ula
						WHEN "0001" => --JAL
							result_out <= "010100";
						WHEN "0010" => --JR
							result_out <= "010110";
						WHEN "0011" => --JRL
							result_out <= "010110";
						WHEN "0100" => --JGTZ
							result_out <= "010111";
						WHEN "0101" => --JLTZ
							result_out <= "011000";
						WHEN "0110" => --JNEZ
							result_out <= "011001";
						WHEN "0111" => --JIEZ
							result_out <= "011010";
						WHEN OTHERS =>
							NULL;

					END CASE;
				END IF;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS;

END Behavioral;