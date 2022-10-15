library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


ENTITY testbench_ula IS


END testbench_ula;

Architecture Type_0 OF testbench_ula IS

CONSTANT Clk_period : time := 40 ns;
SIGNAL Clk_count : integer := 0;

SIGNAL	Signal_Clk		: std_logic := '0';
SIGNAL	Signal_enable		: std_logic := '1';
SIGNAL   Signal_alu_op_in		: std_logic_vector(5 DOWNTO 0) := "000000";
SIGNAL   Signal_pc_in		: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
SIGNAL	Signal_Rm		: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
SIGNAL	Signal_Rn		: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
SIGNAL	Signal_shift		: std_logic_vector(3 DOWNTO 0) := "0000";
SIGNAL	Signal_Rlh		: std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
SIGNAL	Signal_Rlh_out		: std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
SIGNAL   Signal_constant_1		: std_logic_vector(15 DOWNTO 0) := "0000000000000001";
SIGNAL   Signal_constant_0		: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
SIGNAL   Signal_imm		: std_logic_vector(7 DOWNTO 0) := "00000000";
SIGNAL   Signal_j_imm		: std_logic_vector(9 DOWNTO 0) := "0000000000";
SIGNAL   Signal_result	: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
SIGNAL   Signal_branch	: std_logic := '1';

COMPONENT ula IS

Port ( clk_in : in STD_LOGIC;
		  enable_in : in STD_LOGIC;
		  alu_op_in : in STD_LOGIC_VECTOR (5 downto 0);
		  pc_in : in STD_LOGIC_VECTOR (15 downto 0);
		  constant_1 : in STD_LOGIC_VECTOR (15 downto 0);
		  constant_0 : in STD_LOGIC_VECTOR (15 downto 0);
		  rM_data_in : in STD_LOGIC_VECTOR (15 downto 0);
		  rN_data_in : in STD_LOGIC_VECTOR (15 downto 0);
		  rlh_data_in : in STD_LOGIC_VECTOR (31 downto 0);
		  shift_data_in : in STD_LOGIC_VECTOR (3 downto 0);
		  imm_data_in : in STD_LOGIC_VECTOR (7 downto 0);
		  j_imm_data_in : in STD_LOGIC_VECTOR (9 downto 0);
		  rlh_data_out : out std_logic_vector(31 DOWNTO 0);
		  result_out : out STD_LOGIC_VECTOR (15 downto 0);
		  branch_out : out STD_LOGIC
		  --rD_write_enable_in : in STD_LOGIC;
		  --rD_write_enable_out : out STD_LOGIC);
		 );
END COMPONENT;

BEGIN

Dut: ula

PORT MAP (
  clk_in => Signal_Clk,
  enable_in => Signal_enable,
  alu_op_in => Signal_alu_op_in,
  pc_in => Signal_pc_in,
  constant_1 => Signal_constant_1,
  constant_0 => Signal_constant_0,
  rM_data_in => Signal_Rm,
  rN_data_in => Signal_Rn,
  rlh_data_in => Signal_Rlh,
  shift_data_in => Signal_shift,
  imm_data_in => Signal_imm,
  j_imm_data_in => Signal_j_imm,
  rlh_data_out => Signal_Rlh_out,
  result_out => Signal_result,
  branch_out => Signal_branch
  --branch_out : out STD_LOGIC;
  --rD_write_enable_in : in STD_LOGIC;
  --rD_write_enable_out : out STD_LOGIC
);

Clock_Process : PROCESS 
  Begin
    Signal_Clk <= '0';
    wait for Clk_period/2;  --for 0.5 ns signal is '0'.
    Signal_Clk  <= '1';
    Clk_count <= Clk_count + 1;
    wait for Clk_period/2;  --for next 0.5 ns signal is '1'.
	 
IF (Clk_count = 67) THEN     
REPORT "Stopping simulkation after 11 cycles";
    	  Wait;       
END IF;
	 
End Process Clock_Process;


Input_Process : PROCESS 
  Begin
   wait for 40 ns;
   Signal_Rm <= "0000000000000010";
	Signal_Rn <= "0000000000000001";
	Signal_alu_op_in <= "000000";
	
	wait for 40 ns;
	 REPORT "Valor Final soma: "  & integer'image(to_integer(unsigned(Signal_result)));
	
	wait for 40 ns;
	Signal_Rm <= "0000000000000100"; --4
	Signal_Rn <= "0000000000000010"; --2
	Signal_alu_op_in <= "000001"; --sub
	
	wait for 40 ns;
	 REPORT "Valor Final sub: "  & integer'image(to_integer(unsigned(Signal_result))); --3 
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000000001"; --1
	Signal_shift <= "0010";
	Signal_alu_op_in <= "000010"; --lsl
	
	wait for 40 ns;
	 REPORT "Valor Final lsl: "  & integer'image(to_integer(unsigned(Signal_result))); --4
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000000100"; --1
	Signal_shift <= "0010";
	Signal_alu_op_in <= "000011"; --lsr
	
	wait for 40 ns;
	 REPORT "Valor Final lsr: "  & integer'image(to_integer(unsigned(Signal_result))); --1
	 
	wait for 40 ns;
	Signal_Rm <= "1000000000001000"; --1
	Signal_shift <= "0010";
	Signal_alu_op_in <= "000100"; --sra

	wait for 40 ns; -- tadm
	Signal_Rm <= "0000000000000001";
	Signal_Rlh <= "00000000000000000000000000000010";
	Signal_alu_op_in <= "000101";

	wait for 40 ns;
	REPORT "Valor Final tadm: "  & integer'image(to_integer(unsigned(Signal_result)));
	-- Saída: 00000000000000001111111111111111
	
	wait for 40 ns;
	 REPORT "Valor Final sra: "  & integer'image(to_integer(unsigned(Signal_result))); --
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000000100"; 
	Signal_Rn <= "0000000000011111"; 
	Signal_alu_op_in <= "000110"; --and
	
	wait for 40 ns;
	 REPORT "Valor Final and: "  & integer'image(to_integer(unsigned(Signal_result))); 
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000000100"; 
	Signal_Rn <= "0000000000011111"; 
	Signal_alu_op_in <= "000111"; --or
	
	wait for 40 ns;
	 REPORT "Valor Final or: "  & integer'image(to_integer(unsigned(Signal_result))); 
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000000100"; 
	Signal_Rn <= "0000000000011111"; 
	Signal_alu_op_in <= "001000"; --xor
	
	wait for 40 ns;
	 REPORT "Valor Final xor: "  & integer'image(to_integer(unsigned(Signal_result))); 
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000000100"; 
	Signal_Rn <= "0000000000011111"; 
	Signal_alu_op_in <= "001001"; --nor
	
	wait for 40 ns;
	 REPORT "Valor Final nor: "  & integer'image(to_integer(unsigned(Signal_result))); 
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000000001"; 
	Signal_imm <= "10000000";
	Signal_alu_op_in <= "001010"; --addis
	
	wait for 40 ns;
	 REPORT "Valor Final addis: "  & integer'image(to_integer(unsigned(Signal_result))); 
	 
	wait for 40 ns;
	Signal_Rm <= "1000000000000000"; 
	Signal_imm <= "00000001";
	Signal_alu_op_in <= "001011"; --subis
	
	wait for 40 ns;
	 REPORT "Valor Final subis: "  & integer'image(to_integer(unsigned(Signal_result)));
	

	wait for 40 ns; -- loi
	Signal_imm <= "11000000";
	Signal_alu_op_in <= "001100";

	wait for 40 ns;
	REPORT "Valor Final soma: "  & integer'image(to_integer(unsigned(Signal_result)));
	-- Saída: 0000000011000000


	wait for 40 ns; -- lui
	Signal_imm <= "11000000";
	Signal_alu_op_in <= "001101";

	wait for 40 ns;
	REPORT "Valor Final soma: "  & integer'image(to_integer(unsigned(Signal_result)));
	-- Saída: 1100000000000000

	wait for 40 ns; -- lis
	Signal_imm <= "10000000";
	Signal_alu_op_in <= "001110";

	wait for 40 ns;
	REPORT "Valor Final soma: "  & integer'image(to_integer(unsigned(Signal_result)));
	-- Saída: 1111111110000000


	wait for 40 ns; -- andi
	Signal_Rm <= "0000000000011111";
	Signal_imm <= "11111111";
	Signal_alu_op_in <= "001111";

	wait for 40 ns;
	REPORT "Valor Final soma: "  & integer'image(to_integer(unsigned(Signal_result)));
	-- Rd: 0000000000011111
	-- Im: 0000000011111111
	-- Saída: 0000000000011111

	
	wait for 40 ns; -- ori
	Signal_Rm <= "0000000000001111";
	Signal_imm <= "10000000";
	Signal_alu_op_in <= "010000";

	wait for 40 ns;
	REPORT "Valor Final soma: "  & integer'image(to_integer(unsigned
	(Signal_result)));
	-- Saída: 0000000000001111
	-- Saída: 0000000010000000
	-- Saída: 0000000010001111


	wait for 40 ns; -- xori
	Signal_Rm <= "0000000000000111";
	Signal_imm <= "10000000";
	Signal_alu_op_in <= "010001";

	wait for 40 ns;
	REPORT "Valor Final soma: "  & integer'image(to_integer(unsigned(Signal_result)));
	-- Saída: 0000000000001111
	-- Saída: 0000000010000000
	-- Saída: 0000000010001111


	wait for 40 ns; -- nori
	Signal_Rm <= "0000000000000111";
	Signal_imm <= "10000000";
	Signal_alu_op_in <= "010010";

	wait for 40 ns;
	REPORT "Valor Final soma: "  & integer'image(to_integer(unsigned(Signal_result)));
	-- Saída: 0000000000001111
	-- Saída: 0000000010000000
	-- Saída: 1111111101111000


	wait for 40 ns; -- nandi
	Signal_Rm <= "0000000000000111";
	Signal_imm <= "10000000";
	Signal_alu_op_in <= "010011";

	wait for 40 ns;
	REPORT "Valor Final soma: "  & integer'image(to_integer(unsigned(Signal_result)));
	-- Saída: 0000000000001111
	-- Saída: 0000000010000000
	-- Saída: 1111111111111111
	 
	wait for 40 ns;
	Signal_pc_in <= "0010100000000000"; 
	Signal_j_imm <= "0000000001";
	Signal_alu_op_in <= "010100"; --JUMP
	
	wait for 40 ns;
	 REPORT "Valor Final jump: "  & integer'image(to_integer(unsigned(Signal_result))); 
	 
	wait for 40 ns;
	Signal_pc_in <= "0000000000010000"; 
	Signal_alu_op_in <= "010101"; --JAL
	
	wait for 40 ns;
	 REPORT "Valor Final subis: "  & integer'image(to_integer(unsigned(Signal_result)));
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000000100"; 
	Signal_alu_op_in <= "010110"; --JR
	
	wait for 40 ns;
	 REPORT "Valor Final subis: "  & integer'image(to_integer(unsigned(Signal_result)));
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000000100"; 
	Signal_pc_in <= "0000010000000000"; 
	Signal_alu_op_in <= "010111"; --JGTZ
	
	wait for 40 ns;
	 REPORT "Valor Final subis: "  & integer'image(to_integer(unsigned(Signal_result)));
	 
	wait for 40 ns;
	Signal_Rm <= "1000000000000000"; 
	Signal_pc_in <= "0100000000000000"; 
	Signal_alu_op_in <= "011000"; --JLTZ
	
	wait for 40 ns;
    REPORT "Valor Final subis: "  & integer'image(to_integer(unsigned(Signal_result)));
	 
	wait for 40 ns;
	Signal_Rm <= "1000000000000000"; 
	Signal_pc_in <= "0000010001000000"; 
	Signal_alu_op_in <= "011001"; --JNEZ
	
	wait for 40 ns;
    REPORT "Valor Final subis: "  & integer'image(to_integer(unsigned(Signal_result)));
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000000000"; 
	Signal_pc_in <= "0100000000001000"; 
	Signal_alu_op_in <= "011010"; --JIEZ
	
	wait for 40 ns;
    REPORT "Valor Final subis: "  & integer'image(to_integer(unsigned(Signal_result)));
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000000000"; 
	Signal_pc_in <= "0100000000001000"; 
	Signal_alu_op_in <= "011010"; --JIEZ
	
	wait for 40 ns;
    REPORT "Valor Final subis: "  & integer'image(to_integer(unsigned(Signal_result)));
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000010000"; 
	Signal_alu_op_in <= "011100"; --SUB SP
	
	wait for 40 ns;
    REPORT "Valor Final subis: "  & integer'image(to_integer(unsigned(Signal_result)));
	 
	wait for 40 ns;
	Signal_Rm <= "0000000000011000"; 
	Signal_alu_op_in <= "011101"; --ADD SP
	
	wait for 40 ns;
    REPORT "Valor Final ADD SP: "  & integer'image(to_integer(unsigned(Signal_result)));
	
	wait for 40 ns; -- mfh
	Signal_Rlh <= "11111111111111110000000000000000";
	Signal_alu_op_in <= "100001";

	wait for 40 ns;
	REPORT "Valor Final mfh: "  & integer'image(to_integer(unsigned(Signal_result)));
	-- Saída: 1111111111111111


	wait for 40 ns; -- mfl
	Signal_Rlh <= "11111111111111110000000111101010";
	Signal_alu_op_in <= "100010";

	wait for 40 ns;
	REPORT "Valor Final mfl: "  & integer'image(to_integer(unsigned(Signal_result)));
	-- Saída: 0000000111101010


	wait for 40 ns; -- mtl
	Signal_Rm <= "1111111111111111";
	Signal_Rlh <= "11111111111111110000000111101010";
	Signal_alu_op_in <= "100011";

	wait for 40 ns;
	REPORT "Valor Final mtl: "  & integer'image(to_integer(unsigned(Signal_result)));
	-- Saída: 00000000000000001111111111111111

	
End Process Input_Process;

END Type_0;
	