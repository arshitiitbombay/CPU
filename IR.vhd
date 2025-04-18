library ieee;
use ieee.std_logic_1164.all;
library work;
use work.basic_elements.all;


entity IR is

port(Data_in : in std_logic_vector(15 downto 0);
IR_en : in std_logic;
Data_out : out std_logic_vector(15 downto 0)

);

end entity;


architecture struct of IR is

variable data : std_logic_vector(15 downto 0):=(others=>'0');

begin
	
	data_out<=data;

	main: process(IR_en)
	begin
		
		data <= data_in;
	
	end process;

end architecture;