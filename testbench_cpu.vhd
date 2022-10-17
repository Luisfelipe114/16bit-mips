LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;
ENTITY testbench_cpu IS
END testbench_cpu;

ARCHITECTURE Type_0 OF testbench_cpu IS

	--INSTANCIAÇÃO
	COMPONENT cpu IS
		PORT (
			clk : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			ctrl_enable : IN STD_LOGIC;
			instruction : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			register_data : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			memory_data : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			pc_data_jump : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			current_stage : OUT STD_LOGIC_VECTOR (16 DOWNTO 0)
		);
	END COMPONENT;

	CONSTANT Clk_period : TIME := 40 ns;
	SIGNAL Clk_count : INTEGER := 0;

	SIGNAL Signal_Stage : STD_LOGIC_VECTOR (16 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Signal_Clk : STD_LOGIC := '0';
	SIGNAL Signal_Reset : STD_LOGIC := '1';
	SIGNAL Signal_instruction : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Signal_register_data : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Signal_memory_data : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Signal_pc_data_jump : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Signal_ctrl_enable : STD_LOGIC := '0';

BEGIN

	-- Instancia  o do projeto a ser testado
	Dut : cpu
	PORT MAP(
		clk => Signal_Clk,
		reset => Signal_Reset,
		instruction => Signal_instruction,
		register_data => Signal_register_data,
		memory_data => Signal_memory_data,
		pc_data_jump => Signal_pc_data_jump,
		current_stage => Signal_Stage,
		ctrl_enable => Signal_ctrl_enable
	);

	Clock_Process : PROCESS
	BEGIN
		Signal_Clk <= '0';
		WAIT FOR Clk_period/2; --for 0.5 ns signal is '0'.
		Signal_Clk <= '1';
		Clk_count <= Clk_count + 1;
		WAIT FOR Clk_period/2; --for next 0.5 ns signal is '1'.

		IF (Clk_count = 13) THEN
			REPORT "Stopping simulation after 9 cycles";
			WAIT;
		END IF;

	END PROCESS Clock_Process;

	Input_Process : PROCESS
	BEGIN
		WAIT FOR 20 ns;
		Signal_instruction <= "0100100000000010";
		Signal_ctrl_enable <= '1';
		WAIT FOR Clk_period;
		Signal_Reset <= '0';
		WAIT FOR Clk_period * 2;
		Signal_instruction <= "0100100100000011";
		WAIT FOR clk_period * 4;
		Signal_instruction <= "0010100000010000";
		WAIT;
	END PROCESS;

END Type_0;