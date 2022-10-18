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
			memory_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			memory_write_data : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			pc_data_jump : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			current_stage : OUT STD_LOGIC_VECTOR (16 DOWNTO 0)
		);
	END COMPONENT;

	CONSTANT Clk_period : TIME := 40 ns;
	SIGNAL Clk_count : INTEGER := 0;

	SIGNAL Signal_Stage : STD_LOGIC_VECTOR (16 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Signal_Clk : STD_LOGIC := '0';
	SIGNAL Signal_Reset : STD_LOGIC := '0';
	SIGNAL Signal_instruction : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Signal_register_data : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Signal_memory_data : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Signal_memory_write_data : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
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
		memory_write_data => Signal_memory_write_data,
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

		IF (Clk_count = 220) THEN
			REPORT "Stopping simulation after 9 cycles";
			WAIT;
		END IF;

	END PROCESS Clock_Process;

	Reset_Process : PROCESS
	BEGIN
		Signal_Reset <= '0';
		WAIT FOR 10 ns;
		Signal_Reset <= '1';
		WAIT FOR 30 ns;
		Signal_Reset <= '0';
		WAIT;
	END PROCESS Reset_Process;

	Input_Process : PROCESS
	BEGIN
		WAIT FOR 20 ns;
		Signal_instruction <= "0100100000000010"; --loi --passa 10(2) para ac0
		Signal_ctrl_enable <= '1';

		WAIT FOR Clk_period * 4; --ciclo 5
		Signal_instruction <= "0100100100000011";--loi --passa 11(3) para ac1

		WAIT FOR clk_period * 4; --ciclo 9
		Signal_instruction <= "0010100000010000"; -- mfac --passa de rd(ac0) para rf1(registrador 1)

		WAIT FOR Clk_period * 4; --ciclo 13
		Signal_instruction <= "0010100100100000"; -- mfac --passa de rd(ac1) para rf1(registrador 2)

		WAIT FOR Clk_period * 4; --ciclo 17
		Signal_instruction <= "0000001000010010"; --add --soma rf1(reg 1) e rf2(reg2) e bota em rd => Resultado: Rd(AC1) = 0000 0000 0000 0101

		WAIT FOR Clk_period * 4; --ciclo 21
		Signal_instruction <= "0000011000100001"; --sub --Sub de Rf2 e Rf1 => Resultado: Rd(AC2) = 0000 0000 0000 0001

		WAIT FOR Clk_period * 4; --ciclo 25
		Signal_instruction <= "0000101000010010"; --sll --Sll do Rf1 de 2 bits => Resultado: Rd(AC2) = Rf1 << 2 

		WAIT FOR Clk_period * 4; --ciclo 29
		Signal_instruction <= "0000111000010010"; --slr --Slr do Rf1 de 2 bits => 000011 10 0001 0010 => Resultado: Rd(AC2) = Rf1 >> 2

		WAIT FOR Clk_period * 4; --ciclo 33
		Signal_instruction <= "0001001000010010"; --sra --Sra do Rf1 de 2 bits => Resultado: Rd(AC2) = Rf1 aritmético

		WAIT FOR Clk_period * 4; --ciclo 37
		Signal_instruction <= "0001010000010010"; --Tadm --Reg usado: Registrador 1(indicado por rf1; dado = 10(2)) 

		WAIT FOR Clk_period * 4; --ciclo 41
		Signal_instruction <= "0100100100000011"; --loi --Rd(ac1) recebe 11(3) 

		WAIT FOR Clk_period * 4; --ciclo 45
		Signal_instruction <= "0010100100010000"; -- mfac --passa de rd(ac1) para rf1(registrador 1)

		WAIT FOR Clk_period * 4; --ciclo 49
		Signal_instruction <= "0001010000010010"; --Tadm --Reg usado: Registrador 1(indicado por rf1; dado = 10(2)) (tadm que entra no if)

		-- Tem que voltar o Rf1 para 0010

		WAIT FOR Clk_period * 4; --53
		Signal_instruction <= "0100100000000010"; --loi --Resultado: AC0 = 0000 0000 0000 0010 

		WAIT FOR Clk_period * 4; --57
		Signal_instruction <= "0010100000010000"; --mfac --Resultado: Rf1 = AC0 = 0000 0000 0000 0010 x

		WAIT FOR Clk_period * 4; --61
		Signal_instruction <= "0001101100010010"; --and --And do Rf1 e do Rf2 => Rd(AC3) = 0000 0000 0000 0010

		WAIT FOR Clk_period * 4; --65
		Signal_instruction <= "0001111100010010"; --or --Or do Rf1 e do Rf2 => Rd(AC3) = 0000 0000 0000 0011

		WAIT FOR Clk_period * 4; --69
		Signal_instruction <= "0010001100010010"; --xor --Xor do Rf1 e do Rf2 => Rd(AC3) = 0000 0000 0000 0001

		WAIT FOR Clk_period * 4; --73
		Signal_instruction <= "0010011100010010"; --nor --Nor do Rf1 e do Rf2 => Rd(AC3) = 1111 1111 1111 1100

		WAIT FOR Clk_period * 4; --77
		Signal_instruction <= "0011001100010010"; --slt --Slt do Rf1 para o Rf2 => Rd(AC3) = 0000 0000 0000 0001

		WAIT FOR Clk_period * 4; --81
		Signal_instruction <= "0011001100100001"; --slt --Slt do Rf2 para o Rf1 => Rd(AC3) = 0000 0000 0000 0000

		WAIT FOR Clk_period * 4; --85
		Signal_instruction <= "0011010000000000"; --mtl --Mtl do AC0 => RLH = 0000 0000 0000 0000 0000 0000 0000 0010

		WAIT FOR Clk_period * 4; --89
		Signal_instruction <= "0011100000000000"; --mfh --Mfh do AC0 => Rd(AC0) = 0000 0000 0000 0000

		WAIT FOR Clk_period * 4; --93
		Signal_instruction <= "0011110000000000"; --mfl --Mfl do AC0 => Rd(AC0) = 0000 0000 0000 0010

		--TUDO CERTO

		-- operações com imediato 11

		WAIT FOR Clk_period * 4; -- 97
		Signal_instruction <= "0100000010001111"; -- addis do Rd(AC0) => Rd(AC0) = 1111 1111 1001 0001

		WAIT FOR Clk_period * 4; -- 101
		Signal_instruction <= "0100010010001111"; -- subis do Rd(AC0) => Rd(AC0) = 1111 1111 1001 0001 - 1111 1111 1000 1111 = 0000 0000 0000 0010

		WAIT FOR Clk_period * 4; -- 105
		Signal_instruction <= "0100100010001111"; --loi do Rd(AC0) => Rd(AC0) = 0000 0000 1000 1111

		WAIT FOR Clk_period * 4; -- 109
		Signal_instruction <= "0100110010001111"; --lui do Rd(AC0) => Rd(AC0) = 1000 1111 0000 0000

		WAIT FOR Clk_period * 4; -- 113
		Signal_instruction <= "0101000010001111"; --lis do Rd(AC0) => Rd(AC0) = 1111 1111 1000 1111

		WAIT FOR Clk_period * 4; -- 117
		Signal_instruction <= "0101010000001111"; --andi do Rd(AC0) => Rd(AC0) = 0000 0000 0000 1111

		WAIT FOR Clk_period * 4; -- 121
		Signal_instruction <= "0101100011111111"; --ori do Rd(AC0) => Rd(AC0) = 0000 0000 1111 1111

		WAIT FOR Clk_period * 4; -- 125
		Signal_instruction <= "0101110000001111"; --xori do Rd(AC0) => Rd(AC0) = 0000 0000 1111 0000

		WAIT FOR Clk_period * 4; -- 129
		Signal_instruction <= "0110000000001111"; --nori do Rd(AC0) => Rd(AC0) = 1111 1111 0000 0000

		WAIT FOR Clk_period * 4;-- 133
		Signal_instruction <= "0110010000001111"; --nandi do Rd(AC0) => Rd(AC0) = 1111 1111 1111 1111
		--operacoes com acesso a memória
		WAIT FOR Clk_period * 4; --137
		Signal_instruction <= "1000000000010000"; --lwr
		Signal_memory_data <= "0000000000000001";

		WAIT FOR Clk_period * 5; -- 142
		Signal_instruction <= "1000010000010000"; --swr

		WAIT FOR Clk_period * 4; --146
		Signal_instruction <= "0010100111100000"; --mfac --Resultado: Rf1 = AC0 = 0000 0000 0000 0011 x

		WAIT FOR Clk_period * 4; -- 150
		Signal_instruction <= "1000100100000000"; --push

		WAIT FOR Clk_period * 4; -- 154
		Signal_instruction <= "1000110100000000"; --pop
		Signal_memory_data <= "0000000000000010";

		--operações com salto
		WAIT FOR Clk_period * 8; -- 162
		Signal_instruction <= "0100100100000011"; --loi --Loi de 3 para o AC1 => Resultado: AC1 =  0000 0000 0000 0011
		--pc = 0000000000100100

		WAIT FOR Clk_period * 4; --166
		Signal_instruction <= "1100000000000011"; --j --pc = 0000000000000011

		WAIT FOR Clk_period * 3; --169
		Signal_instruction <= "1100010000000011"; --jal

		WAIT FOR Clk_period * 5; --174
		Signal_instruction <= "1100100100000000"; --jr

		WAIT FOR Clk_period * 4; --178
		Signal_instruction <= "1100110100000000"; --jrl

		WAIT FOR Clk_period * 5; --183
		Signal_instruction <= "1101000100000011"; --jgtz --imm = 00000011

		WAIT FOR Clk_period * 4; --187
		Signal_instruction <= "0100110111111111"; --lui Lui de -3 para o AC1 => 010010 01 0000 10011

		WAIT FOR Clk_period * 4; --191
		Signal_instruction <= "1101010100000011"; --jltz --imm = 00000011

		WAIT FOR Clk_period * 4; -- 195
		Signal_instruction <= "1101100100000011"; --jnez

		WAIT FOR Clk_period * 4; --199
		Signal_instruction <= "0100100100000000"; --loi --Loi de O para o AC1  => Resultado: AC1 =  0000 0000 0000 0000

		WAIT FOR Clk_period * 4; --203
		Signal_instruction <= "1101110100000011"; --jize

		WAIT FOR Clk_period * 4; --207
		Signal_instruction <= "0100100100000001"; --loi

		WAIT FOR Clk_period * 4; --211
		Signal_instruction <= "1101110100000011"; --jize

		WAIT FOR Clk_period * 4; --215
		Signal_instruction <= "0010111100010011"; --mtac --rd recebe rf1(ac3 recebe 0010)

		WAIT FOR Clk_period * 5;

		WAIT;
	END PROCESS;

END Type_0;