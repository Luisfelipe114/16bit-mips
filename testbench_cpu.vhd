library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


ENTITY testbench_cpu IS


END testbench_cpu;

Architecture Type_0 OF testbench_cpu IS

--INSTANCIAÇÃO
COMPONENT cpu is
	Port(
			clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			instruction : in STD_LOGIC_VECTOR (15 downto 0);
			register_data : out STD_LOGIC_VECTOR (15 downto 0);
			memory_data : out STD_LOGIC_VECTOR (15 downto 0);
			pc_data_jump : out STD_LOGIC_VECTOR (15 downto 0);
			current_stage : out STD_LOGIC_VECTOR (16 downto 0)
	);
END COMPONENT;

CONSTANT Clk_period : TIME := 40 ns;
SIGNAL Clk_count : INTEGER := 0;

SIGNAL Signal_Stage : STD_LOGIC_VECTOR (16 downto 0) := (others => '0');
SIGNAL Signal_Clk : STD_LOGIC := '0';
SIGNAL Signal_Reset : STD_LOGIC := '1';
SIGNAL Signal_instruction : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
SIGNAL Signal_register_data : STD_LOGIC_VECTOR (15 downto 0) := (others => '0'); 
SIGNAL Signal_memory_data : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
SIGNAL Signal_pc_data_jump : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

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
	current_stage => Signal_Stage
);

Clock_Process : PROCESS 
  Begin
    Signal_Clk <= '0';
    wait for Clk_period/2;  --for 0.5 ns signal is '0'.
    Signal_Clk  <= '1';
    Clk_count <= Clk_count + 1;
    wait for Clk_period/2;  --for next 0.5 ns signal is '1'.



IF (Clk_count = 5) THEN     
REPORT "Stopping simulation after 9 cycles";
    	  Wait;       
END IF;

End Process Clock_Process;

Input_Process : PROCESS 
	BEGIN	
	
		wait for 20 ns;
		Signal_instruction <= "0100100000000010";
		wait for 40 ns;
		Signal_Reset <= '0';
		

End Process;

End Type_0;
