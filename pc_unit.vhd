library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc_unit is
    Port ( clk_in : in STD_LOGIC;
           pc_write : in STD_LOGIC;
           pc_source : in STD_LOGIC;
           --pc_op_in : in STD_LOGIC_VECTOR (1 downto 0);
		     branch_in : in STD_LOGIC;
           pc_in : in STD_LOGIC_VECTOR (15 downto 0);
           pc_out : out STD_LOGIC_VECTOR (15 downto 0));
end pc_unit;

architecture Behavioral of pc_unit is
    signal pc: STD_LOGIC_VECTOR(15 downto 0) := x"0000"; --set pc to 0000
begin
    process (clk_in)
    begin
        if rising_edge(clk_in) then
            if pc_write = '1' then
                case pc_source is  
                    when '0' =>
                        pc <= STD_LOGIC_VECTOR(unsigned(pc) + 1);
                    when '1' =>
                        case branch_in is 
                            when '1' =>
                                pc <= pc_in;
                            when '0' => 
                                NULL;
									 when others =>
										  NULL;
                        end case;
						  when others =>
							 null;
                end case;
            else
                null;
            end if;
        end if;
    end process;
    
    pc_out <= pc;

end Behavioral;