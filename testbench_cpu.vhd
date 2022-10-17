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

        SIGNAL Signal_Reset : STD_LOGIC := '0';

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


                IF (Clk_count = 200) THEN

                        REPORT "Stopping simulation after 9 cycles";
                        WAIT;
                END IF;

        END PROCESS Clock_Process;

		  
		  Reset_Process : PROCESS 
			Begin
			Signal_Reset <= '0';
			 Wait for 10 ns;
			 Signal_Reset <= '1';
			 Wait for 30 ns;
			 Signal_Reset <= '0';
			 wait;
		 END PROCESS Reset_Process;


        Input_Process : PROCESS
        BEGIN
                WAIT FOR 20 ns;

                Signal_instruction <= "0100100000000010"; --loi --passa 10(2) para ac0
                Signal_ctrl_enable <= '1';
                
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0100100100000011";--loi --passa 11(3) para ac1
					 
                WAIT FOR clk_period * 4;
                Signal_instruction <= "0010100000010000"; -- mfac --passa de rd(ac0) para rf1(registrador 1)
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0010100100100000"; -- mfac --passa de rd(ac1) para rf1(registrador 2)
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0000001000010010"; --add --soma rf1(reg 1) e rf2(reg2) e bota em rd 
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0000011000100001"; --sub
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0000101000010010"; --sll
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0000111000010010"; --slr
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0001001000010010"; --sra
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0001010000010010"; --Tadm
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0001101100010010"; --and
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0001111100010010"; --or
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0010001100010010"; --xor
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0010011100010010"; --nor
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0011001100010010"; --slt
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0011001100100001"; --slt
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0011010000000000"; --mtl
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0011100000000000"; --mfh
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0011110000000000"; --mfl
					 
					 

                WAIT FOR Clk_period * 4;

                -- operações com imediato

                Signal_instruction <= "0100000010001111"; --addis

					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0100010010001111"; --subis
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0100100010001111"; --loi
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0100110010001111"; --lui
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0101000010001111"; --lis
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0101010000001111"; --andi
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0101100011111111"; --ori
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0101110000001111"; --xori
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0110000000001111"; --nori
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "0110010000001111"; --nandi
					 

                WAIT FOR Clk_period * 4;
                --operacoes com acesso a memória

                Signal_instruction <= "1000000000010000"; --lwr

					 
                WAIT FOR Clk_period * 5;
                Signal_instruction <= "1000010000010000"; --swr
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "1000100100000000"; --push
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "1000110100000000"; --pop
					 
                WAIT FOR Clk_period * 8;
                --operações com salto
                Signal_instruction <= "0100100100000011"; --loi
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "1100000000000011"; --j
					 
                WAIT FOR Clk_period * 3;
                Signal_instruction <= "1100010000000011"; --jal
					 
                WAIT FOR Clk_period * 5;
                Signal_instruction <= "1100100100000000"; --jr
					 
                WAIT FOR Clk_period * 5;
                Signal_instruction <= "1100110100000000"; --jrl
					 
                WAIT FOR Clk_period * 5;
                Signal_instruction <= "1101000100000011"; --jgtz
					 
                WAIT FOR Clk_period * 5;
                Signal_instruction <= "0100100100001011"; --loi
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "1101010100000011"; --jltz
					 
                WAIT FOR Clk_period * 5;
                Signal_instruction <= "1101100000000011"; --jnez
					 
                WAIT FOR Clk_period * 5;
                Signal_instruction <= "0100100100000000"; --loi
					 
                WAIT FOR Clk_period * 4;
                Signal_instruction <= "1101110100000011"; --jize
					 
                WAIT FOR Clk_period * 5;
                Signal_instruction <= "0100100100000001"; --loi
					 
                WAIT FOR Clk_period * 4;

                Signal_instruction <= "1101110100000011"; --jize
                WAIT FOR Clk_period * 5;
                WAIT;
        END PROCESS;

END Type_0;