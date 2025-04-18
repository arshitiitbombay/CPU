library ieee;
use ieee.std_logic_1164.all;
library work;
use work.basic_elements.all;

entity Register_file is

port(Data_in :in std_logic_vector(15 downto 0);
A1,A2,A3 :in std_logic_vector(2 downto 0);
Reg_A,Reg_B :out std_logic_vector(15 downto 0);
RF_en :in std_logic
);

end entity;



architecture struct of Register_file is

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if RF_en = '1' then
                reg(to_integer(unsigned(A3))) <= Data_in; -- Write operation
            end if;
				flag <= '1';
					
		else flag <= '0';
		
        end if;
    end process;

    inst_output : RF_mux
        generic map (N => 8, WIDTH => 16)
        port map (
            Inputs => reg, -- Memory array for reading
            sel => to_integer(unsigned(A1 and flag)), -- Address selection
            Y => Reg_B -- Read data to Data_out
        );
		  
	 inst_output : RF_mux
        generic map (N => 8, WIDTH => 16)
        port map (
            Inputs => reg, -- Memory array for reading
            sel => to_integer(unsigned(A2 and flag)), -- Address selection
            Y => Reg_A -- Read data to Data_out
        );
	 
	 
end architecture;
