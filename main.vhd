library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- For unsigned arithmetic
library work;
use work.basic_elements.all;

entity main is
    port (
        clk     : in std_logic;
        PC_en   : in std_logic;
        Mem_R   : in std_logic;
        Mem_W   : in std_logic;
        RF_en   : in std_logic;
        IR_en   : in std_logic;
        JLR ,J    : in std_logic;
        JAL     : in std_logic;
        BEQ     : in std_logic;
		  Beq_vall,zetta : out std_logic;
        Mem_RW,ALu_en  : in std_logic;
		  Reg_Aa,Reg_bb,IR_outt,Lambdaa,alu_out : out std_logic_vector(15 downto 0);
		  PC_value,Mem_Addd : out std_logic_vector(7 downto 0);
		  IR_start : out std_logic_vector(3 downto 0);
		  
		   r0 : out std_logic_vector (15 downto 0);
		  r1 : out std_logic_vector (15 downto 0);  -- for testing purposes;
		  r2 : out std_logic_vector (15 downto 0);
		  r3 : out std_logic_vector (15 downto 0);
		  r4 : out std_logic_vector (15 downto 0);
		  r5 : out std_logic_vector (15 downto 0);
		  r6 : out std_logic_vector (15 downto 0);
		  r7 : out std_logic_vector (15 downto 0)
		  
    );
end entity main;

--architecture struct of main is

    -- Component Declarations
--    component Register_file is
--        port (
--            Data_in : in std_logic_vector(15 downto 0);
--            A1, A2, A3 : in std_logic_vector(2 downto 0);
--            Reg_A, Reg_B : out std_logic_vector(15 downto 0);
--            RF_en : in std_logic
--        );
--    end component;
--
--    component Program_counter is
--        port (
--            Address_out : out std_logic_vector(7 downto 0);
--            Address_in : in std_logic_vector(7 downto 0);
--            PC_en, clk : in std_logic;
--            PC_val : out std_logic_vector(7 downto 0)
--        );
--    end component;
--
--    component ALU is
--        port (
--            ALU_o : out std_logic_vector(15 downto 0);
--            ALU_A, ALU_B : in std_logic_vector(15 downto 0);
--            clk,alu_en : in std_logic;
--            op_val : in std_logic_vector(3 downto 0);
--            carry_flag : out std_logic
--        );
--    end component;
--
--    component IR is
--        port (
--            Data_in : in std_logic_vector(15 downto 0);
--            IR_en : in std_logic;
--            Data_out : out std_logic_vector(15 downto 0)
--        );
--    end component;
--
--    component REG_FILE_IR is
--        port (
--            Reg_A       : out std_logic_vector(15 downto 0);  -- Output from RF (A)
--            Reg_B       : out std_logic_vector(15 downto 0);  -- Output from RF (B)
--            Reg_A_add   : out std_logic_vector(2 downto 0);   -- Address for RF (A)
--            Reg_B_add   : out std_logic_vector(2 downto 0);   -- Address for RF (B)
--            Reg_C       : in  std_logic_vector(15 downto 0);  -- Data to write into RF
--            Reg_C_add   : out std_logic_vector(2 downto 0);   -- Address for RF (C)
--            IR_in       : in  std_logic_vector(15 downto 0);  -- Input to IR
--            IR_out      : out std_logic_vector(15 downto 0);  -- Output from IR
--            Lambda      : out std_logic_vector(15 downto 0);  -- Immediate output
--            IR_en       : in  std_logic;                      -- Enable signal for IR
--            RF_en       : in  std_logic;                      -- Enable signal for RF
--            clk     : in  std_logic  ;                     -- Clock signal and ZZ for MUXES
--				zz : out std_logic
--		 );
--    end component;
----
--    -- Signals
--    signal PC_Mem, PC_chng1, PC_chng2, Mem_Add  : std_logic_vector(7 downto 0);
--    signal lmd, lmd_dot, C : std_logic_vector(15 downto 0);
--    signal Mem_IN, Mem_OUT: std_logic_vector(15 downto 0);
--    signal IR_in, Reg_C, Reg_A, Reg_B, IR_out : std_logic_vector(15 downto 0);
--    signal ALU_A, ALU_B, ALU_o, ALU_reg : std_logic_vector(15 downto 0); -- Added ALU_reg
--    signal zeta, z : std_logic;
--    signal BEQ_val : std_logic; -- Added BEQ_val
--
--begin
--
--    -- Program Counter Instance
--    PC : Program_counter
--        port map (
--            Address_in => PC_chng1,
--            Address_out => PC_chng2,
--            PC_en => PC_en,
--            PC_val => PC_Mem,
--            clk => clk
--        );
--
--    -- Memory Instance
--    Mem : memory
--        port map (
--            Data_in => reg_A,
--            Data_out => Mem_OUT,
--            Mem_Add => Mem_Add,
--            Mem_W => Mem_W,
--            Mem_R => Mem_R
--           
--        );
--
--    -- Register File and IR Instance
--    RF_IR : REG_FILE_IR
--        port map (
--            IR_in => IR_in,
--            IR_en => IR_en,
--            RF_en => RF_en,
--            Lambda => lmd,
--            Reg_A => Reg_A,
--            Reg_B => Reg_B,
--            clk => clk,
--            ZZ => z,
--            Reg_C => Reg_C,
--            IR_out => IR_out
--        );
--		  
--		IR_start <= IR_out(15 downto 12);
--
--	ALU_A <= Reg_A when z='0' else lmd ;
--    -- ALU Instance
--    AL : ALU
--        port map (
--            ALU_A => ALU_A,
--            ALU_B => Reg_B,
--            ALU_o => ALU_o,
--				Alu_en =>alu_en,
--            clk => clk,
--            op_val => IR_out(3 downto 0)
--        );
--		c <= Reg_B;
--
--    -- BEQ_val Calculation
--    BEQ_val <= BEQ and (not alu_o(0)) and (not alu_o(1)) and (not alu_o(2)) and (not alu_o(3)) and
--               (not alu_o(4)) and (not alu_o(5)) and (not alu_o(6)) and (not alu_o(7)) and
--               (not alu_o(8)) and (not alu_o(9)) and (not alu_o(10)) and (not alu_o(11)) and
--               (not alu_o(12)) and (not alu_o(13)) and (not alu_o(14)) and (not alu_o(15));
--	
--	beq_vall <= beq_val;
--    -- Zeta Signal
--    zeta <= J or BEQ_val;
--
--    -- ALU Register
--    alu_register : process(clk)
--    begin
--        if rising_edge(clk) then
--            ALU_reg <= ALU_o;
--        end if;
--    end process;
--
--    -- Instruction Execution Process
--    inst : process(clk)
--    begin
--        if clk= '1' then
--           if JLR = '0' then
--                if zeta = '0' then
--						-- Ensure the result is 8-bits
--						
--						PC_chng1 <= std_logic_vector(unsigned(PC_chng2) + 2)(7 downto 0);
--					else
--						-- Ensure the result is 8-bits
--						PC_chng1 <= std_logic_vector(unsigned(PC_chng2) + unsigned(lmd_dot))(7 downto 0);
--					end if;
--
--            else
--                PC_chng1 <= std_logic_vector(C)(7 downto 0);
--            end if;
--
--            if Mem_RW = '0' then
--                Mem_Add <= PC_Mem;
--                IR_in <= Mem_OUT;
--                if JAL = '1' then
--                    Reg_C <= "00000000"&PC_chng2;
--                else
--                    Reg_C <= ALU_reg; -- Use ALU_reg
--                end if;
--            else
--                Mem_Add <= ALU_reg(7 downto 0); -- Use ALU_reg
--                if JAL = '1' then
--                    Reg_C <= "00000000"&PC_chng2;
--                else
--                    Reg_C <= Mem_OUT;
--                end if;
--            end if;
--        end if;
--    end process;
--
--end architecture struct;
architecture struct of main is

    -- Component Declarations (unchanged)

    component Program_counter is
        port (
            Address_out : out std_logic_vector(7 downto 0);
            Address_in : in std_logic_vector(7 downto 0);
            PC_en, clk : in std_logic;
            PC_val : out std_logic_vector(7 downto 0)
        );
    end component;

    component ALU is
        port (
            ALU_o : out std_logic_vector(15 downto 0);
            ALU_A, ALU_B : in std_logic_vector(15 downto 0);
            clk,alu_en : in std_logic;
            op_val : in std_logic_vector(3 downto 0);
            carry_flag : out std_logic
        );
    end component;

    component IR is
        port (
            Data_in : in std_logic_vector(15 downto 0);
            IR_en : in std_logic;
            Data_out : out std_logic_vector(15 downto 0)
        );
    end component;

    component REG_FILE_IR is
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
            clk     : in  std_logic  ;                     -- Clock signal and ZZ for MUXES
				zz : out std_logic;
		  r0 : out std_logic_vector (15 downto 0);
		  r1 : out std_logic_vector (15 downto 0);  -- for testing purposes;
		  r2 : out std_logic_vector (15 downto 0);
		  r3 : out std_logic_vector (15 downto 0);
		  r4 : out std_logic_vector (15 downto 0);
		  r5 : out std_logic_vector (15 downto 0);
		  r6 : out std_logic_vector (15 downto 0);
		  r7 : out std_logic_vector (15 downto 0)
		 );
    end component;
--

    -- Signals
    signal PC_Mem, PC_chng1, PC_chng2, Mem_Add,mem_ad : std_logic_vector(7 downto 0):= (others=>'0');
    signal temp_pc_chng1 : std_logic_vector(15 downto 0); -- Intermediate signal for PC calculation
    signal temp_alu_reg : std_logic_vector(15 downto 0); -- Intermediate signal for ALU output
    signal lmd, lmd_dot, C : std_logic_vector(15 downto 0);
    signal Mem_IN, Mem_OUT : std_logic_vector(15 downto 0);
    signal IR_in, Reg_C, Reg_A, Reg_B, IR_out : std_logic_vector(15 downto 0);
    signal ALU_A, ALU_B, ALU_o, ALU_reg : std_logic_vector(15 downto 0); -- ALU signals
    signal zeta, z : std_logic;
    signal BEQ_val : std_logic;

begin

    -- Program Counter Instance
    PC : Program_counter
        port map (
            Address_in => PC_chng1,
            Address_out => PC_chng2,
            PC_en => PC_en,
            PC_val => PC_Mem,
            clk => clk
        );
	
	PC_value <= PC_Mem;

    -- Memory Instance
    Mem : memory
        port map (
            Data_in => reg_A,
            Data_out => Mem_OUT,
            Mem_Add => Mem_Add,
            Mem_W => Mem_W,
            Mem_R => Mem_R,
				clk=>clk
        );

    -- Register File and IR Instance
    RF_IR : REG_FILE_IR
        port map (
            IR_in => IR_in,
            IR_en => IR_en,
            RF_en => RF_en,
            Lambda => lmd,
            Reg_A => Reg_A,
            Reg_B => Reg_B,
            clk => clk,
            ZZ => z,
            Reg_C => Reg_C,
            IR_out => IR_out,
		  r0 => r0,
		  r1 => r1, -- for testing purposes;
		  r2 =>r2,
		  r3 =>r3,
		  r4 =>r4,
		  r5 =>r5,
		  r6 =>r6,
		  r7 =>r7
        );
		 IR_outt <= IR_out;
	mem_ad<= mem_add;
	reg_aa <=reg_A;
	reg_bb <=reg_b;

    IR_start <= IR_out(15 downto 12);
	Lambdaa <=lmd;
	ALU_A <= Reg_A when z = '0' else lmd;
    -- ALU Instance
    AL : ALU
        port map (
            ALU_A => ALU_A,
            ALU_B => Reg_B,
            ALU_o => ALU_o,
            alu_en => alu_en,
            clk => clk,
            op_val => IR_out(15 downto 12)
        );

    c <= Reg_B;

	     -- ALU Register
ALU_reg <= ALU_o when ALU_en='1' else ALU_reg;
	alu_out <= alu_reg;
    -- BEQ_val Calculation
    BEQ_val <= BEQ and (not alu_reg(0)) and (not alu_reg(1)) and (not alu_reg(2)) and (not alu_reg(3)) and
               (not alu_reg(4)) and (not alu_o(5)) and (not alu_reg(6)) and (not alu_reg(7)) and
               (not alu_reg(8)) and (not alu_reg(9)) and (not alu_reg(10)) and (not alu_reg(11)) and				---zero flag
               (not alu_reg(12)) and (not alu_reg(13)) and (not alu_reg(14)) and (not alu_reg(15));

    beq_vall <= BEQ_val;

    -- Zeta Signal
   
	 
	 --lmd dot 
	 
	 lmd_dot <= lmd(14 downto 0) & "0";


    

-- Compute zeta concurrentl
zeta <= J or BEQ_val;

zetta<= zeta;
  
    inst : process(clk,zeta,JLR)				-- PC_en gets high for 1 clock cycle so adds 1 for half cycle and then lmd_dot
    begin
--		 zeta <= J or BEQ_val;
        if clk = '0' then
            if JLR = '0' then
					
                if zeta = '0'  then
						
                    temp_pc_chng1 <= "00000000" & std_logic_vector(unsigned(PC_chng2) + 2);
                    PC_chng1 <= temp_pc_chng1(7 downto 0);
						 
                else
                    temp_pc_chng1 <= std_logic_vector(unsigned(PC_chng2) + unsigned(lmd_dot));  
                    PC_chng1 <= temp_pc_chng1(7 downto 0);
                end if;
					
            else
                PC_chng1 <= C(7 downto 0);
            end if;
		end if;
	end process;



	
	Mem_Add <= PC_Mem when Mem_RW = '0' else alu_reg(7 downto 0);

IR_in <= Mem_OUT when Mem_RW = '0' else IR_in; -- Only assigned when Mem_RW = '0'

Reg_C <= "00000000" & PC_chng2 when JAL = '1' else 
         Mem_OUT when Mem_RW = '1' else
         ALU_reg;


end architecture struct;

