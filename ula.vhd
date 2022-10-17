library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ula is
    Port ( clk_in : in STD_LOGIC;
           enable_in : in STD_LOGIC;
           alu_op_in : in STD_LOGIC_VECTOR (5 downto 0);
           pc_in : in STD_LOGIC_VECTOR (15 downto 0);
			  constant_1 : in STD_LOGIC_VECTOR (15 downto 0);
			  constant_0 : in STD_LOGIC_VECTOR (15 downto 0);
           rM_data_in : in STD_LOGIC_VECTOR (15 downto 0);
           rN_data_in : in STD_LOGIC_VECTOR (15 downto 0);
		     rlh_data_in : in STD_LOGIC_VECTOR (31 downto 0);
		     shift_data_in: in STD_LOGIC_VECTOR (3 downto 0);
           imm_data_in : in STD_LOGIC_VECTOR (7 downto 0);
		     j_imm_data_in : in STD_LOGIC_VECTOR (9 downto 0);
		     rlh_data_out : out STD_LOGIC_VECTOR (31 downto 0);
           result_out : out STD_LOGIC_VECTOR (15 downto 0);
           branch_out : out STD_LOGIC
           --rD_write_enable_in : in STD_LOGIC;
           --rD_write_enable_out : out STD_LOGIC);
		);
end ula;

-- TODO: handle overflow correctly, add more than EQ to branching
architecture Behavioral of ula is
    signal signed_add : STD_LOGIC_VECTOR (15 downto 0);
    signal signed_sub : STD_LOGIC_VECTOR (15 downto 0);
    signal bothpos : STD_LOGIC;
    signal bothneg : STD_LOGIC;
    signal overflow : STD_LOGIC;
     
begin
 process(clk_in)
 begin
		  
  if rising_edge(clk_in) and enable_in='1' then

  
		
		
		case alu_op_in(5 downto 0) is -- 3-0 is opcode, alu_on_in(4) is condition bit
			when "000000" => -- ADD 
			 	result_out <= STD_LOGIC_VECTOR(unsigned(rM_data_in) + unsigned(rN_data_in));
			  -- unsigned overflow possible
			  	branch_out <= '0';
				  
			when "000001" => -- SUB 
				result_out <= STD_LOGIC_VECTOR(unsigned(rM_data_in) - unsigned(rN_data_in));
				branch_out <= '0';
			
			when "000010" => -- LSL RRI(5)
				result_out <= STD_LOGIC_VECTOR(shift_left(unsigned(rM_data_in), to_integer(unsigned(shift_data_in))));
				branch_out <= '0';
				
			when "000011" => -- LSR RRI(5)
				result_out <= STD_LOGIC_VECTOR(shift_right(unsigned(rM_data_in), to_integer(unsigned((shift_data_in)))));
				branch_out <= '0';
				
			when "000100"  => --SRA
				result_out <= STD_LOGIC_VECTOR(shift_right(signed(rM_data_in), to_integer(unsigned((shift_data_in)))));
				branch_out <= '0';

			when "000101" => --TADM 
				IF rN_data_in(0) = '1' THEN 
					rlh_data_out <= STD_LOGIC_VECTOR(shift_left(unsigned(rlh_data_in) + resize(unsigned(rM_data_in), 32), 1));
					result_out <= STD_LOGIC_VECTOR(shift_right(unsigned(rM_data_in), 1));
				ELSE 
					result_out <= STD_LOGIC_VECTOR(shift_right(unsigned(rM_data_in), 1));
					rlh_data_out <= STD_LOGIC_VECTOR(shift_left(unsigned(rlh_data_in), 1));
				END IF;
				branch_out <= '0';
				
			when "000110" => -- AND RRR
				result_out <= rM_data_in and rN_data_in;
				branch_out <= '0';  
				
			when "000111" => -- OR RRR
				result_out <= rM_data_in or rN_data_in;
				branch_out <= '0';	  
				
			when "001000" => -- XOR RRR
				result_out <= rM_data_in xor rN_data_in;
				branch_out <= '0';	  
				
			when "001001" => -- NOR RRR
				result_out <= rM_data_in nor rN_data_in;
				branch_out <= '0';
				 
			when "001010" => -- ADDIS
				result_out <= STD_LOGIC_VECTOR(signed(rN_data_in) + resize(signed((imm_data_in(7) & imm_data_in)), 16));
				branch_out <= '0';
				
			when "001011" => -- SUBIS
				result_out <= STD_LOGIC_VECTOR(signed(rN_data_in) - resize(signed((imm_data_in(7) & imm_data_in)), 16));
				branch_out <= '0';
			
			when "001100" => -- LOI
				result_out <= x"00" & imm_data_in;
				branch_out <= '0';
					  
			when "001101" => -- LUI
				result_out <= imm_data_in & x"00";
				branch_out <= '0';
				
			when "001110" => -- LIS
				result_out <= STD_LOGIC_VECTOR(resize(signed(imm_data_in(7) & imm_data_in), 16));
				branch_out <= '0';
				
			when "001111" => -- ANDI
				result_out <= rM_data_in and (x"00" & imm_data_in);
				branch_out <= '0';
				
			when "010000" => -- ORI
				result_out <= rM_data_in or (x"00" & imm_data_in);
				branch_out <= '0';
				
			when "010001" => -- XORI
				result_out <= rM_data_in xor (x"00" & imm_data_in);
				branch_out <= '0';
				
			when "010010" => -- NORI
				result_out <= rM_data_in nor (x"00" & imm_data_in);
				branch_out <= '0';
				
			when "010011" => -- NANDI
				result_out <= rM_data_in nand (x"00" & imm_data_in);
				branch_out <= '0';
				
			--TIPO J
				
			when "010100" => -- JUMP/JAL(parte 2 do JAL)
				result_out <= pc_in(15 downto 10) & j_imm_data_in;
				branch_out <= '1';
					  
			when "010101" => -- PC Increment
				result_out <= pc_in + constant_1;
				branch_out <= '1';
			
			when "010110" => -- JR/JRL (parte 2 do JRL)
				result_out <= rN_data_in;
				branch_out <= '1';
				
			when "010111" => -- JGTZ
				IF rM_data_in > constant_0 THEN
					result_out <= pc_in + constant_1 + (x"00" & imm_data_in);
					branch_out <= '1';
				ELSE 
					branch_out <= '0';
				END IF;
			
			when "011000" => -- JLTZ
				IF rN_data_in < constant_0 THEN
					result_out <= pc_in + constant_1 + (x"00" & imm_data_in);
					branch_out <= '1';
				ELSE 
					branch_out <= '0';
				END IF;
				
			when "011001" => -- JNEZ
				IF rN_data_in /= constant_0 THEN
					result_out <= pc_in + constant_1 + (x"00" & imm_data_in);
					branch_out <= '1';
				ELSE 
					branch_out <= '0';
				END IF;
				
			when "011010" => -- JIEZ
				IF rN_data_in = constant_0 THEN
					result_out <= pc_in + constant_1 + (x"00" & imm_data_in);
					branch_out <= '1';
				ELSE 
					branch_out <= '0';
				END IF;
				
			when "011011" => --SLT
				IF rM_data_in < rN_data_in THEN 
					result_out <= constant_1;
				ELSE
					result_out <= constant_0;
					
				END IF;
				branch_out <= '0';
					
			when "011100" => --SUB SP(PUSH)
				result_out <= rM_data_in - constant_1;
				branch_out <= '0';
				
			when "011101" => --ADD SP(POP)
				result_out <= rM_data_in + constant_1;
				branch_out <= '0';
				
			when "011110" => --MFAC (transparencia rN(pop/sw)) 
				result_out <= rN_data_in;
				branch_out <= '0';
				
			when "011111" => --MTAC
				result_out <= rM_data_in;
				branch_out <= '0';
				
			when "100001" => --MFH
				result_out <= rlh_data_in(31 downto 16);
				branch_out <= '0';
				
			when "100010" => --MFL
				result_out <= rlh_data_in(15 downto 0);
				branch_out <= '0';
				
			when "100011" => --MTL
				rlh_data_out(31 downto 16) <= constant_0;
				rlh_data_out(15 downto 0) <= rM_data_in;
				branch_out <= '0';
				
			when "100100" => --transparencia rM(sw/lw)
				result_out <= rM_data_in;
				branch_out <= '0';

				
			when others => 
				NULL;
		
		
		end case;
  end if;   
end process;  
  
end Behavioral;