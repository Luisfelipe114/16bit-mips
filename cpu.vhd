LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY cpu IS
	PORT (
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		ctrl_enable : IN STD_LOGIC := '0';
		instruction : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		register_data : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		memory_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		memory_write_data : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		pc_data_jump : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		current_stage : OUT STD_LOGIC_VECTOR (16 DOWNTO 0)
	);

END cpu;

ARCHITECTURE behavorial OF cpu IS

	COMPONENT instruction_register
		PORT (
			clk_in : IN STD_LOGIC;
			enable_in : IN STD_LOGIC;
			instruction_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			op_code_out : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			instruction_op_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			alu_op_out : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
			imm_data_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- 16 or 8
			j_imm_data_out : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			sel_rF_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			sel_rF2_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			sel_rD_out : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT registerbank
		PORT (
			clk_in : IN STD_LOGIC;
			reg_write : IN STD_LOGIC;
			ctrl_reg_dest : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			ctrl_address_read_A : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			address_sp : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			address_rf1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			address_rf2 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			address_rd : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			address_j : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			write_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			data_out_1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			data_out_2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ula_controle
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
	END COMPONENT;
	COMPONENT ula
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
		);
	END COMPONENT;

	COMPONENT rlh
		PORT (
			clk_in : IN STD_LOGIC;
			enable_in : IN STD_LOGIC;
			rlh_write : IN STD_LOGIC;
			data_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			data_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT pc_unit
		PORT (
			clk_in : IN STD_LOGIC;
			pc_write : IN STD_LOGIC;
			pc_source : IN STD_LOGIC;
			branch_in : IN STD_LOGIC;
			pc_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			pc_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT control
		PORT (
			clk_in : IN STD_LOGIC;
			reset_in : IN STD_LOGIC;
			enable_in : IN STD_LOGIC;
			op_code_in : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			stage_out : OUT STD_LOGIC_VECTOR (16 DOWNTO 0)
		);
	END COMPONENT;

	--SIGNAL Cpu_clock : STD_LOGIC := '0';
	--SIGNAL Signal_reset : STD_LOGIC := '0';

	--SIGNAL Signal_instruction : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

	--IR
	SIGNAL Signal_codop : STD_LOGIC_VECTOR (5 DOWNTO 0) := (OTHERS => '0'); --IR --controle
	SIGNAL Signal_alu_op_group : STD_LOGIC_VECTOR (1 DOWNTO 0) := (OTHERS => '0'); --IR --ula_controle
	SIGNAL Signal_instruction_op_out : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0'); --IR --ula_controle
	SIGNAL Signal_immediate : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0'); --IR --ula
	SIGNAL Signal_j_immediate : STD_LOGIC_VECTOR (9 DOWNTO 0) := (OTHERS => '0'); --IR --ula
	--BANK REGISTER
	SIGNAL Signal_Reg_read1_data : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0'); --regfile --ula
	SIGNAL Signal_Reg_read2_data : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0'); --regfile --ula
	SIGNAL Signal_Reg_write_data : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0'); --regfile --ula

	SIGNAL Signal_ctrl_reg_dest : STD_LOGIC_VECTOR (1 DOWNTO 0) := (OTHERS => '0'); --controle --regfile
	SIGNAL Signal_address_read_A : STD_LOGIC_VECTOR (1 DOWNTO 0) := (OTHERS => '0'); --regfile --controle

	SIGNAL Signal_Reg_read1_address : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0'); --regfile
	SIGNAL Signal_Reg_read2_address_or_shift : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0'); --regfile
	SIGNAL Signal_Reg_readSP_address : STD_LOGIC_VECTOR (3 DOWNTO 0) := "1110"; --regfile
	SIGNAL Signal_Reg_readJ_address : STD_LOGIC_VECTOR (3 DOWNTO 0) := "1111"; --regfile
	SIGNAL Signal_Reg_readRD_address : STD_LOGIC_VECTOR (1 DOWNTO 0) := (OTHERS => '0'); --regfile

	--ULA
	SIGNAL Signal_constant_1 : STD_LOGIC_VECTOR (15 DOWNTO 0) := "0000000000000001"; --ula
	SIGNAL Signal_constant_0 : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0'); --ula
	SIGNAL Signal_result_ula : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0'); --ula --dado(register or pc)
	SIGNAL Signal_result_ula_rlh : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0'); --ula --RLH register
	SIGNAL Signal_branch : STD_LOGIC := '0'; --ula --pc unit

	--ULA CONTROLE
	SIGNAL Signal_pc_increment : STD_LOGIC := '0'; --controle --ula control
	--SIGNAL Signal_ula_op_control : STD_LOGIC_VECTOR (1 downto 0) := (others => '0'); --IR --ula control
	--SIGNAL Signal_ula_codop_control : STD_LOGIC_VECTOR (3 downto 0) := (others => '0'); --IR --ula control
	SIGNAL Signal_ula_op : STD_LOGIC_VECTOR (5 DOWNTO 0) := (OTHERS => '0'); --ula control --ula

	--RLH
	SIGNAL Signal_Rlh_write : STD_LOGIC := '0'; --RLH
	SIGNAL Signal_Rlh_data_out : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0'); --RLH --Ula

	--PC Unit
	SIGNAL Signal_pc_out : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0'); --PC unit --ula

	--CONTROL
	SIGNAL Signal_stage : STD_LOGIC_VECTOR (16 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Signal_pc_source : STD_LOGIC := '0'; --Controle --Pc unit
	SIGNAL Signal_pop : STD_LOGIC := '0'; --Controle --Pc unit
	SIGNAL Signal_store_word : STD_LOGIC := '0';

	--ENABLES
	SIGNAL Signal_Ula_enable : STD_LOGIC := '0';
	SIGNAL Signal_Ula_control_enable : STD_LOGIC := '0';
	SIGNAL Signal_Register_write_enable : STD_LOGIC := '0';
	SIGNAL Signal_RI_enable : STD_LOGIC := '0';
	SIGNAL Signal_Rlh_enable : STD_LOGIC := '0';
	SIGNAL Signal_Pc_enable : STD_LOGIC := '0';
	-- MEMORY
	SIGNAL Signal_Mem_read : STD_LOGIC := '0';
	SIGNAL Signal_Mem_write : STD_LOGIC := '0';

	--MULTIPLEXADORES
	SIGNAL Signal_mem_to_reg : STD_LOGIC := '0';
	SIGNAL Signal_IorD : STD_LOGIC := '0';

	SIGNAL Signal_memory_data : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Signal_memory_address : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
BEGIN

	--SINAIS DE CONTROLE
	Signal_RI_enable <= Signal_stage(16); -- IR_write_enable
	Signal_Register_write_enable <= Signal_stage(15); -- reg_write_enable
	Signal_ctrl_reg_dest <= Signal_stage(14 DOWNTO 13); -- reg_dest
	Signal_Rlh_write <= Signal_stage(12); -- rlh_write_enable
	Signal_mem_to_reg <= Signal_stage(11); -- mem_to_reg
	Signal_IorD <= Signal_stage(10); -- IorD
	Signal_Mem_write <= Signal_stage(9); -- mem_write
	Signal_Mem_read <= Signal_stage(8); -- mem_read
	Signal_Pc_enable <= Signal_stage(7); -- pc_write
	Signal_pc_source <= Signal_stage(6); -- pc_source
	Signal_Ula_enable <= Signal_stage(5); -- alu_enable
	Signal_address_read_A <= Signal_stage(4 DOWNTO 3); -- reg_read_A
	Signal_pc_increment <= Signal_stage(2); -- increment_PC
	Signal_pop <= Signal_stage(1); -- pop
	Signal_store_word <= Signal_stage(0); -- store_word

	-- GERAÇÃO DOS SINAIS DE SAÍDA
	Signal_Reg_write_data <= memory_data WHEN Signal_mem_to_reg = '1' ELSE
		Signal_result_ula;
	Signal_memory_address <= Signal_pc_out WHEN Signal_IorD = '0' ELSE
		Signal_result_ula;

	--SINAIS PARA TESTEBENCH
	register_data <= Signal_Reg_write_data;
	memory_write_data <= Signal_Reg_read1_data;
	pc_data_jump <= Signal_pc_out;
	current_stage <= Signal_stage;

	--Signal_codop <= instruction(15 downto 10);
	--Signal_alu_op <= instruction(15 downto 14);
	--Signal_instruction_op_out <= instruction(13 downto 10); 
	--Signal_immediate <= instruction(7 downto 0); 
	--Signal_j_immediate <= instruction(9 downto 0); 
	--Signal_Reg_read1_address <= instruction(7 downto 4); 
	--Signal_Reg_read2_address_or_shift <= instruction(3 downto 0);
	--Signal_Reg_readRD_address <= instruction(9 downto 8);
	--- INSTANCIAÇÃO DOs COMPONENTEs
	IR : instruction_register
	PORT MAP(
		clk_in => clk,
		enable_in => Signal_RI_enable,
		instruction_in => instruction,
		instruction_op_out => Signal_instruction_op_out,
		op_code_out => Signal_codop,
		alu_op_out => Signal_alu_op_group,
		imm_data_out => Signal_immediate,
		j_imm_data_out => Signal_j_immediate,
		sel_rF_out => Signal_Reg_read1_address,
		sel_rF2_out => Signal_Reg_read2_address_or_shift,
		sel_rD_out => Signal_Reg_readRD_address
	);

	Registers : registerbank
	PORT MAP(
		clk_in => clk,
		reg_write => Signal_Register_write_enable,
		ctrl_reg_dest => Signal_ctrl_reg_dest,
		write_data => Signal_Reg_write_data,
		ctrl_address_read_A => Signal_address_read_A,
		address_rf1 => Signal_Reg_read1_address,
		address_rf2 => Signal_Reg_read2_address_or_shift,
		address_rd => Signal_Reg_readRD_address,
		address_sp => Signal_Reg_readSP_address,
		address_j => Signal_Reg_readJ_address,
		data_out_1 => Signal_Reg_read1_data,
		data_out_2 => Signal_Reg_read2_data
	);
	Alu : ula
	PORT MAP(
		clk_in => clk,
		enable_in => Signal_Ula_enable,
		alu_op_in => Signal_ula_op,
		pc_in => Signal_pc_out,
		constant_1 => Signal_constant_1,
		constant_0 => Signal_constant_0,
		rM_data_in => Signal_Reg_read2_data,
		rN_data_in => Signal_Reg_read1_data,
		rlh_data_in => Signal_Rlh_data_out,
		shift_data_in => Signal_Reg_read2_address_or_shift,
		imm_data_in => Signal_immediate,
		j_imm_data_in => Signal_j_immediate,
		rlh_data_out => Signal_result_ula_rlh,
		result_out => Signal_result_ula,
		branch_out => Signal_branch
	);

	Control_Alu : ula_controle
	PORT MAP(
		clk_in => clk,
		pc_increment => Signal_pc_increment,
		store_word => Signal_store_word,
		pop => Signal_pop,
		enable_in => Signal_Ula_control_enable,
		codop_signal => Signal_instruction_op_out,
		alu_op_control_in => Signal_alu_op_group,
		result_out => Signal_ula_op
	);
	Rlh_Register : rlh
	PORT MAP(
		clk_in => clk,
		enable_in => Signal_Rlh_enable,
		rlh_write => Signal_Rlh_write,
		data_in => Signal_result_ula_rlh,
		data_out => Signal_Rlh_data_out
	);

	PC : pc_unit
	PORT MAP(
		clk_in => clk,
		pc_write => Signal_Pc_enable,
		pc_source => Signal_pc_source,
		branch_in => Signal_branch,
		pc_in => Signal_result_ula,
		pc_out => Signal_pc_out
	);

	Control_Unit : control
	PORT MAP(
		clk_in => clk,
		reset_in => reset,
		enable_in => ctrl_enable,
		op_code_in => Signal_codop,
		stage_out => Signal_stage
	);

END behavorial;