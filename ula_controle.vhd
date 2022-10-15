library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity ula_controle is
    Port( clk_in : in STD_LOGIC;
			codop_signal : in STD_LOGIC_VECTOR(3 downto 0);
			enable_in : in STD_LOGIC;
			alu_op_in : in STD_LOGIC_VECTOR (1 downto 0);
			result_out : out STD_LOGIC_VECTOR (3 downto 0)
        );
end ula_controle;

architecture Behavioral of ula_controle is

begin
    process(clk_in)
    begin
	case alu_op_in (1 downto 0) is
		when "00" =>
	   		case codop_signal (3 downto 0) is
				when "0000" =>--AND 
					result_out <= "000000"; --sinal pra ula
				when "0001" =>--SUB
					result_out <= "000001";
				when "0010" =>--LSL
					result_out <= "000010";
				when "0011" =>--LSR
					result_out <= "000011";
				when "0100" =>--SRA
					result_out <= "000100";
				when "0101" =>--TADM
					result_out <= "000101";
				when "0110" =>--AND
					result_out <= "000110";
				when "0111" =>--OR
					result_out <= "000111";
				when "1000" => --XOR
					result_out <= "001000";
				when "1001" =>--NOR
					result_out <= "001001";
				when "1010" =>--MFAC
					result_out <= "011110";
				when "1011" =>--MTAC
					result_out <= "011111";
				when "1100" =>--SLT
					result_out <= "011011";
				when "1101" =>--MTL
					result_out <= "100011";
				when "1110" =>-- MFH
					result_out <= "100001";
				when "1111" =>-- MFL
					result_out <= "100010";
				
			end case;
		when "01" =>
	   		case codop_signal (3 downto 0) is
				when "0000" =>--ADDIS
					result_out <= "001010";--sinal pra ula
				when "0001" =>--SUBIS
					result_out <= "001011";
				when "0010" =>--LOI
					result_out <= "001100";
				when "0011" =>--LUI
					result_out <= "001101";
				when "0100" =>--LIS				
					result_out <= "001110";
				when "0101"=> --ANDI				
					result_out <= "001111";
				when "0110" =>--ORI			
					result_out <= "010000";
				when "0111"=> --XORI			
					result_out <= "010001";
				when "1000" =>--NORI			
					result_out <= "010010";
				when "1001"=> --NANDI		
					result_out <= "010011";
			end case;
		when "10" =>
	   		case codop_signal (3 downto 0) is
				when "0010" =>--SUB SP(PUSH)
					result_out <= "011100";--sinal pra ula
				when "0011" =>--ADD SP(POP)
					result_out <= "011100";
				
			end case;	 
				 
		when "11" =>
	   		case codop_signal (3 downto 0) is
				when "0000" =>--JUMP/JAL
					result_out <= "010100";--sinal pra ula
				when "0001" =>--JAL/JRL
					result_out <= "010101";
				when "0010"=> --JR
					result_out <= "010110";
				when "0011" =>--JGTZ
					result_out <= "010111";
				when "0100" =>--JLTZ
					result_out <= "011000";
				when "0101" =>--JNEZ
					result_out <= "011001";
				when "0101" =>--JIEZ
					result_out <= "011010";
					
			end case;		
	end case;
	end process;

end Behavioral;