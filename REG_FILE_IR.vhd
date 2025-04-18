library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;  -- Import numeric_std for unsigned, signed, and to_integer

entity REG_FILE_IR is
    port (
        Reg_A       : out std_logic_vector(15 downto 0);  -- Output from RF (A)
        Reg_B       : out std_logic_vector(15 downto 0);  -- Output from RF (B)
        Reg_A_add   : out std_logic_vector(2 downto 0);   -- Address for RF (A)
        Reg_B_add   : out std_logic_vector(2 downto 0);   -- Address for RF (B)
        Reg_C       : in  std_logic_vector(15 downto 0);  -- Data to write into RF
        Reg_C_add   : out std_logic_vector(2 downto 0);   -- Address for RF (C)
        IR_in       : in  std_logic_vector(15 downto 0);  -- Input to IR
        IR_out      : out std_logic_vector(15 downto 0);  -- Output from IR
        Lambda      : out std_logic_vector(15 downto 0);  -- Immediate output
        IR_en       : in  std_logic;                      -- Enable signal for IR
        RF_en       : in  std_logic;                      -- Enable signal for RF
        clk		     : in  std_logic;                       -- Clock signal AND ZZ for MUXES
		  ZZ			  : out std_logic;
		  
		  
		  		  
		  r0 : out std_logic_vector (15 downto 0);
		  r1 : out std_logic_vector (15 downto 0);  -- for testing purposes;
		  r2 : out std_logic_vector (15 downto 0);
		  r3 : out std_logic_vector (15 downto 0);
		  r4 : out std_logic_vector (15 downto 0);
		  r5 : out std_logic_vector (15 downto 0);
		  r6 : out std_logic_vector (15 downto 0);
		  r7 : out std_logic_vector (15 downto 0)
    );
end entity REG_FILE_IR;

architecture Behavioral of REG_FILE_IR is
    -- Internal signals
    signal IR_reg  : std_logic_vector(15 downto 0) ; -- IR register
    type RF_array is array (0 to 7) of std_logic_vector(15 downto 0);   -- RF memory array
    signal RF      : RF_array := (others => (others => '0'));          -- RF registers

    -- Decoder outputs
    signal A1, A2, A3, L1, L2, L3 : std_logic_vector(2 downto 0);
    signal Z                      : std_logic;
begin
    -- Instruction Register Process
    process (clk,IR_en)
    begin
            if IR_en = '1' then
                IR_reg <= IR_in; -- Load IR
            end if;

--	    IR_out <= IR_reg;
    end process;

    -- Assign IR output
    IR_out <= IR_reg;

	 -- Default values
--A1 <= "000";
--A2 <= "000";
--A3 <= "000";
--L1 <= "000";
--L2 <= "000";
--L3 <= "000";
--Z  <= '0';

-- Assign A1
with IR_reg(15 downto 12) select
    A1 <= IR_reg(11 downto 9) when "0000" | "0010" | "0011" | "0100" | "0101" | "0110" |
                                   "0001" | "1100" ,
			 IR_reg(8 downto 6)  when "1010" | "1011" | "1111",
								
          "000"              when others;

-- Assign A2
with IR_reg(15 downto 12) select
    A2 <= IR_reg(8 downto 6) when "0000" | "0010" | "0011" | "0100" | "0101" | "0110" |
                                   "1100",
          IR_reg(11 downto 9) when "1011",
          "000"              when others;

-- Assign A3
with IR_reg(15 downto 12) select
    A3 <= IR_reg(5 downto 3) when "0000" | "0010" | "0011" | "0100" | "0101" | "0110",
          IR_reg(8 downto 6) when "0001",
          IR_reg(11 downto 9) when "1000" | "1001" | "1101" | "1010" | "1111",
          "000"              when others;

-- Assign L1
with IR_reg(15 downto 12) select
    L1 <= IR_reg(8 downto 6) when "1000" | "1001" | "1101"| "1110",
--          IR_reg(11 downto 9) when "1110",
          "000"              when others;

-- Assign L2
with IR_reg(15 downto 12) select
    L2 <= IR_reg(5 downto 3) when "0001" | "1010" | "1011" | "1100" | "1110" | "1000" | "1001" | "1101",
--          IR_reg(8 downto 6) when "1000" | "1001" | "1101",
          "000"              when others;

-- Assign L3
with IR_reg(15 downto 12) select
    L3 <= IR_reg(2 downto 0) when "0001" | "1010" | "1011" | "1100" |
                                   "1000" | "1001" | "1101" | "1110",
          "000"              when others;

-- Assign Z
with IR_reg(15 downto 12) select
    Z <= '1' when "0001" | "1000" | "1001" | "1011" | "1010",
         '0' when others;


  ZZ <= Z;
--    -- Decoding Logic
--    process (IR_reg)
--    begin
--        -- Default values
--        A1 <= "000";
--        A2 <= "000";
--        A3 <= "000";
--        L1 <= "000";
--        L2 <= "000";
--        L3 <= "000";
--        Z  <= '0';
--
--        case IR_reg(15 downto 12) is
--    when "0000" | "0010" | "0011" | "0100" | "0101" | "0110" =>
--        A1 <= IR_reg(11 downto 9);  -- Corrected range
--        A2 <= IR_reg(8 downto 6);   -- Corrected range
--        A3 <= IR_reg(5 downto 3);   -- Corrected range
--        Z  <= '0';
--
--    when "0001" =>
--        A1 <= IR_reg(11 downto 9);  -- Corrected range
--        A3 <= IR_reg(8 downto 6);   -- Corrected range
--        L2 <= IR_reg(5 downto 3);   -- Corrected range
--        L3 <= IR_reg(2 downto 0);   -- Corrected range
--        Z  <= '1';
--
--    when "1000" | "1001" | "1101" =>
--        A3 <= IR_reg(11 downto 9);  -- Corrected range
--        L1 <= IR_reg(8 downto 6);   -- Corrected range
--        L2 <= IR_reg(5 downto 3);   -- Corrected range
--        L3 <= IR_reg(2 downto 0);   -- Corrected range
--        Z  <= '1';
--
--    when "1010" =>
--        A3 <= IR_reg(11 downto 9);  -- Corrected range
--        A1 <= IR_reg(8 downto 6);   -- Corrected range
--        L2 <= IR_reg(5 downto 3);   -- Corrected range
--        L3 <= IR_reg(2 downto 0);   -- Corrected range
--        Z  <= '1';
--
--    when "1011" =>
--        A2 <= IR_reg(11 downto 9);  -- Corrected range
--        A1 <= IR_reg(8 downto 6);   -- Corrected range
--        L2 <= IR_reg(5 downto 3);   -- Corrected range
--        L3 <= IR_reg(2 downto 0);   -- Corrected range
--        Z  <= '0';
--
--    when "1100" =>
--        A1 <= IR_reg(11 downto 9);  -- Corrected range
--        A2 <= IR_reg(8 downto 6);   -- Corrected range
--        L2 <= IR_reg(5 downto 3);   -- Corrected range
--        L3 <= IR_reg(2 downto 0);   -- Corrected range
--        Z  <= '0';
--
--    when "1111" =>
--        A3 <= IR_reg(11 downto 9);  -- Corrected range
--        A1 <= IR_reg(8 downto 6);   -- Corrected range
--        Z  <= '0';
--
--    when "1110" =>
--        L1 <= IR_reg(11 downto 9);  -- Corrected range
--        L2 <= IR_reg(8 downto 6);   -- Corrected range
--        L3 <= IR_reg(5 downto 3);   -- Corrected range
--        Z  <= '0';
--
--
--
--            when others =>
--                null;
--        end case;
--    end process;

    -- Register File Read
    Reg_A <= RF(to_integer(unsigned(A2))); -- RF Read A
    Reg_B <= RF(to_integer(unsigned(A1))); -- RF Read B

    -- Register File Write
    process (clk)
    begin
--        if clk = '1' then
            if RF_en = '1' then
                RF(to_integer(unsigned(A3))) <= Reg_C;
            end if;
--        end if;
    end process;
    
  

    -- Immediate Output (Lambda)
    Lambda <="0000000"& std_logic_vector(unsigned(L1) & unsigned(L2) & unsigned(L3));
	 
		r0 <= RF(0);  -- testing purpooses
		r1 <= RF(1);
		r2 <= RF(2);
		r3 <= RF(3);
		r4 <= RF(4);
		r5 <= RF(5);
		r6 <= RF(6);
		r7 <= RF(7);

end architecture Behavioral;
