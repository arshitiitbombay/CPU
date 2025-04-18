library ieee;
use ieee.std_logic_1164.all;
library work;
use work.basic_elements.all;

entity Program_counter is

port(Address_out : out std_logic_vector(7 downto 0);
Address_in : in std_logic_vector(7 downto 0);
PC_en ,clk: in std_logic;
PC_val : out std_logic_vector(7 downto 0)
);

end entity;



architecture struct of Program_counter is
signal counter : std_logic_vector(7 downto 0) := "00000000";
begin
	counter <= Address_in when PC_en = '1' else counter;
	pc_val <= counter;
	address_out <= counter;
	
end architecture;



--architecture struct of Program_counter is
--
--
--signal pcpc : std_logic_vector(7 downto 0):= (others => '0');
--
--begin
--
--
--
--whole : process(PC_en,clk)
--
--variable PC_1,PC_2 : std_logic_vector(7 downto 0):=(others=>'0');
--
--begin
--	
--	PC_val <= PC_1;
--	
--	address_out <= PC_2;
--	
--	if rising_edge(PC_en) then
--			
--			PC_2 := PC_1;
--			PC_1 := Address_in;		--update the PC val
----		else
----			
----			-- do nothing
----			
----			PC_1 := PC_1;
----			PC_2 := PC_2;
--		
--		end if;
--
--
--end process;
--
--
--  
--	 
--end architecture;
