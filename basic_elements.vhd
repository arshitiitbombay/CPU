library ieee;
use ieee.std_logic_1164.all;


package basic_elements is 



component memory is 

port(Data_in :in std_logic_vector(15 downto 0);
Data_out :out std_logic_vector(15 downto 0);
Mem_Add :in std_logic_vector(7 downto 0); -- 9 i think
Mem_W, Mem_R,clk :in std_logic


);

end component;




end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
    port(
        Data_in  : in std_logic_vector(15 downto 0);   -- 16-bit data input
        Data_out : out std_logic_vector(15 downto 0);  -- 16-bit data output
        Mem_Add  : in std_logic_vector(7 downto 0);    -- Memory address (8-bit)
        Mem_W    : in std_logic;                       -- Write enable
        Mem_R    : in std_logic;                       -- Read enable
        clk      : in std_logic                        -- Clock signal
    );
end entity Memory;
--
architecture simple of Memory is
    -- Define a constant to initialize the memory content
    -- Initialize with custom values, like: 000110 : 00100010010010..\
	 type memory_array is array (0 to 255) of std_logic_vector(15 downto 0);
    constant init_mem : memory_array := (
    -- Format: Address => Instruction (Opcode | Operands | Immediate/Address)
    -- Example Opcode Format: [Operation Code (4 bits) | Dest Reg (3 bits) | Source Reg 1 (3 bits) | Source Reg 2 (3 bits) | Immediate (6 bits)]
--	 0 => "0000000000000000",
    0 => "1001001010100001",  -- LLI R1,00000000-10100001  
    2 => "1000000001000111",  -- LHI R0,01000001-00000000  -- can change to 00000000-01000001 using lli(1001) for mult
    4 => "0000000110100000" ,  -- add r0, r6 store in r4 ----  test multiplication , and ,ora imp on this only
	 6 => "0010000111010000", -- sub r7-r0 store in r2   ------ 
	
	--- Mlt :  "0011000001100000"    mlt r0, r1 store in r4
	 --- Ora : "0101000001100000"   ora r0, r1 store in r4
	  --- Imp : "0110000001100000"   imp r0, r1 store in r4
	 --- And : "0100000001100000"   and r0, r1 store in r4
	 --- Add : "0000000110100000"   add r0, r6 store in r4
	 --- sub : "0010000111010000"   sub r7-r0 store in r2 (RB-RA)
	 
	 8=>  "1010110111100010",-- Load value of mem( r7+100010) in r6
	 10 => "1100111011000010", --BEQ check r7 and r3 and then jump by 2 (2*2=4)
	 12 => "0000000000000000", --
	 14 => "0001111101000011", --ADI store r7 + 0011 in r5
	 16 => "1100111000000010", --BEQ on r7 and r1 which is false
	 18=>  "1011110111111111",-- Storing value of r6 into mem_add : 00111111
	 20 => "1010000111111111",-- Load value of mem( r7+00111111) in r0
	 22=> "1001001000011100", -- LLI R1,00000000-00011100 
	 24 => "1111011001000000", -- JLR stores PC in r5 and goes to address in r1
	 28 => "1110111000000010", -- Jump unconditionally to Pc + 4 
	 32 => "1101101000010010",	-- JAL store in r5 and jump to pc+imm*2
--    10 => "1110100110010000", 

    34=> "0101010101010101",  
    others => (others => '0') -- Initialize other addresses to zero
);
	


    -- Define a 2D array to simulate memory (256 locations, each 16 bits wide)

    signal mem : memory_array := init_mem; -- Initialize memory with predefined values

begin
    -- Process for Write Operation
    process(clk)
    begin
        if rising_edge(clk) then
            if Mem_W = '1' then
                mem(to_integer(unsigned(Mem_Add))) <= Data_in; -- Write Data to memory
            end if;
        end if;
    end process;

    -- Process for Read Operation
--    process(Mem_Add, Mem_R)
--    begin
--        if Mem_R = '1' then
            Data_out <= mem(to_integer(unsigned(Mem_Add))); -- Read Data from memory
--        else
--            Data_out <= (others => '0'); -- Output zero when not reading
--        end if;
--    end process;

end architecture simple;

-------------------------------------------------------------------------------------------------------------------New Memory

--architecture rtl of MEMORY is
--
--    type mem_unit is array (0 to 255) of std_logic_vector(7 downto 0); -- 65535 since we have a 16 bit adress 
--    signal data : mem_unit := (
--		0  => "10010010",  1  => "10100001",  
--2  => "10000000",  3  => "01000001",  
--4  => "00000001",  5  => "10100000",  
--6  => "00100001",  7  => "11010000",  
--8  => "10101101",  9  => "11100010",  
--10 => "11001110", 11 => "11000010",  
--12 => "00000000", 13 => "00000000",  
--14 => "00011111", 15 => "01000011",  
--16 => "11001110", 17 => "00000010",  
--18 => "10111101", 19 => "11111111",  
--20 => "10100001", 21 => "11111111",  
--22 => "10010010", 23 => "00011100",  
--24 => "11110110", 25 => "01000000",  
--28 => "11101110", 29 => "00000010",  
--32 => "11011010", 33 => "00010010",  
--34 => "01010101", 35 => "01010101",  
--
--
----		7  => "0001000001000001",
----		8  => "0110000001011000",
----		9  => "1000001000000000",
----		10 => "1001000000000001",
----		11 => "1010001000000000",
----		12 => "1101000001000000",
----		13 => "0110000001111000",
----		14 => "1010001010000000",
----		15 => "0110000001010000",
----		16 => "0001000001000010",
----		17 => "1000000000000010",
----		18 => "1001000000000010",
----		19 => "1010000001000010",
----		20 => "1011000001000010",
----		21 => "1100000001000010",
----		22 => "1101000000000001",
----		23 => "1111000001000000",		
--		OTHERS => "00000000");
--
--begin
--     process (clk,Mem_w, Mem_r, Mem_Add, Data_in)
--begin
--    if Mem_w = '1' then
--        data(to_integer(unsigned(Mem_add))) <= Data_in(15 downto 8);
--        data(to_integer(unsigned(Mem_add)) + 1) <= Data_in(7 downto 0);
--    end if;
--end process;
--
---- Read data out
--Data_out(15 downto 8) <= data(to_integer(unsigned(Mem_add))) when Mem_r = '1' else "00000000";
--Data_out(7 downto 0) <= data(to_integer(unsigned(Mem_add)) + 1) when Mem_r = '1' else "00000000";
--end architecture;
