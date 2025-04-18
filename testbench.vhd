library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end entity;

architecture behavior of testbench is
    -- Component Declaration for the UUT (Unit Under Test)
    component computer is
        port(
            clk        : in std_logic;
            state      : out integer;
				reg_a,reg_b,ir_out,Lambda,alu_out : out std_logic_vector(15 downto 0);
				PC_value,Mem_add : out std_logic_vector(7 downto 0);
				       PC_en,
        Mem_R, 
        Mem_W, 
        RF_en, 
        IR_en, 
        JLR, 
        J, 
        JAL, 
        BEQ, 
        Mem_RW, 
        ALU_en,zeta    : out std_logic;
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

    -- Signals for testbench
    signal tb_clk   : std_logic := '0'; -- Clock signal
    signal tb_state : integer := 0;    -- FSM state output
		signal reg_Aa,reg_bb,ir_out,r0,r1,r2,r3,r4,r5,r6,r7,Lambda,alu_out : std_logic_vector(15 downto 0);
		
    -- Clock period
	 signal PC_en,
	 Mem_R, 
        Mem_W, 
        RF_en, 
        IR_en, 
        JLR, 
        J, 
        JAL, 
        BEQ, 
        Mem_RW, 
        ALU_en ,zeta	: std_logic;
    constant clk_period : time := 10 ns;
	 signal PC_value,Mem_add : std_logic_vector(7 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: computer
        port map (
            clk => tb_clk,
            state => tb_state,
				reg_a=> reg_Aa,
				reg_b=>reg_bb,
				PC_value => PC_value,
				ir_out=>ir_out,
			PC_en=> PC_en,
        Mem_R=>mem_R, 
        Mem_W=>mem_W, 
        RF_en=>RF_en, 
        IR_en=>IR_en, 
        JLR=>JLR, 
        J=>J, 
        JAL=>JAL, 
        BEQ=>BEQ, 
		  Lambda=>Lambda,
        Mem_RW=>MEM_RW, 
		  alu_out => alu_out,
        ALU_en =>ALU_en  ,
		  Mem_add=>Mem_add,
		  zeta => zeta,
		   r0 => r0,
		  r1 => r1, -- for testing purposes;
		  r2 =>r2,
		  r3 =>r3,
		  r4 =>r4,
		  r5 =>r5,
		  r6 =>r6,
		  r7 =>r7
        );

    -- Clock generation process
-- Clock generation process
clk_process : process
begin
    tb_clk <= '1';
    wait for clk_period / 2;
    tb_clk <= '0';
    wait for clk_period / 2;
end process;

-- Simulation stop process
stop_simulation: process
begin
    wait for 0.7 ms; -- Wait for 1000 ns
    report "Simulation finished at 1000 ns";
    wait; -- Halt the simulation
end process;


end architecture behavior;
