library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity computer is
    port(
        clk        : in std_logic;
        state      : out integer;
		  reg_a,reg_b,ir_out,Lambda,alu_out : out std_logic_vector(15 downto 0);
		  
		  PC_value,mem_add : out std_logic_vector(7 downto 0);
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
--        IR_start  : out std_logic_vector(3 downto 0)
    );
end entity;

architecture struct of computer is

    -- Component declaration for 'main'
    component main is
        port (
            clk       : in std_logic;
            PC_en     : in std_logic;
            Mem_R     : in std_logic;
            Mem_W     : in std_logic;
            RF_en     : in std_logic;
            IR_en     : in std_logic;
            JLR       : in std_logic;
            J         : in std_logic;
            JAL       : in std_logic;
            BEQ       : in std_logic;
            beq_vall,zetta  : out std_logic;
            Mem_RW    : in std_logic;
            ALU_en    : in std_logic;
				 Reg_Aa,Reg_bb,ir_outt,Lambdaa,alu_out : out std_logic_vector(15 downto 0);
				 
		  PC_value,mem_addd : out std_logic_vector(7 downto 0);
            IR_start  : out std_logic_vector(3 downto 0);
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

    -- State enumeration
    type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15);
    signal present_s, next_s : state_type := s0;

    -- Intermediate signals for FSM outputs
    signal PC_en_fsm, Mem_R_fsm, Mem_W_fsm, RF_en_fsm, IR_en_fsm, JLR_fsm, J_fsm, JAL_fsm, BEQ_fsm : std_logic ;
    signal Mem_RW_fsm, ALU_en_fsm : std_logic ;
    signal IR_start_fsm_internal : std_logic_vector(3 downto 0) ; -- Internal signal
    signal beq_vall : std_logic;
	 signal r_a,r_b : std_logic_vector(15 downto 0);

begin

    -- Instantiate the 'main' component
    u_main : main
        port map (
            clk       => clk,
            PC_en     => PC_en_fsm,
            Mem_R     => Mem_R_fsm,
            Mem_W     => Mem_W_fsm,
            RF_en     => RF_en_fsm,
            IR_en     => IR_en_fsm,
            JLR       => JLR_fsm,
            J         => J_fsm,
            JAL       => JAL_fsm,
            BEQ       => BEQ_fsm,
            beq_vall  => beq_vall,
            Mem_RW    => Mem_RW_fsm,
            ALU_en    => ALU_en_fsm,
				 Reg_Aa	=> r_a,
				 Reg_bb	=> r_b,
				 ir_outt =>ir_out,
		  PC_value =>PC_value,
		  alu_out => alu_out,
		  Lambdaa =>Lambda,
            IR_start  => IR_start_fsm_internal,
				Mem_addd => Mem_add,
				zetta =>zeta,
				 r0 => r0,
		  r1 => r1, -- for testing purposes;
		  r2 =>r2,
		  r3 =>r3,
		  r4 =>r4,
		  r5 =>r5,
		  r6 =>r6,
		  r7 =>r7
        );
		  
	reg_a <=r_a;
	reg_b <= r_b;

    -- Process for state transitions
    process(clk)
    begin
        if rising_edge(clk) then
            present_s <= next_s;
        end if;
    end process;

    -- Process for FSM logic and output assignments
    process(present_s, IR_start_fsm_internal, beq_vall)
    begin
        -- Default signal assignments
        PC_en_fsm   <= '0';
        Mem_R_fsm   <= '0';
        Mem_W_fsm   <= '0';
        RF_en_fsm   <= '0';
        IR_en_fsm   <= '0';
        JLR_fsm     <= '0';
        J_fsm       <= '0';
        JAL_fsm     <= '0';
        BEQ_fsm     <= '0';
        Mem_RW_fsm  <= '0';
        ALU_en_fsm  <= '0';
        next_s      <= present_s;

        case present_s is
            when s0 =>
                state <= 0;
                Mem_R_fsm <= '1';
                IR_en_fsm <= '1';
                if IR_start_fsm_internal = "0000" or IR_start_fsm_internal = "0010" or IR_start_fsm_internal = "0011" or
                   IR_start_fsm_internal = "0100" or IR_start_fsm_internal = "0101" or IR_start_fsm_internal = "0110" then
                    next_s <= s1;
                elsif IR_start_fsm_internal = "0001" then
                    next_s <= s4;
                elsif IR_start_fsm_internal = "1000" or IR_start_fsm_internal = "1001" then
                    next_s <= s5;
                elsif IR_start_fsm_internal = "1010" then
                    next_s <= s6;
                elsif IR_start_fsm_internal = "1011" then
                    next_s <= s8;
                elsif IR_start_fsm_internal = "1100" then
                    next_s <= s10;
                elsif IR_start_fsm_internal = "1101" then
                    next_s <= s12;
                elsif IR_start_fsm_internal = "1111" then
                    next_s <= s14;
                elsif IR_start_fsm_internal = "1110" then
                    next_s <= s13;
                end if;
					 
				 when s1 =>
                state <= 1;
                ALU_en_fsm <= '1';
                next_s <= s2;

            when s2 =>
                state <= 2;
                RF_en_fsm <= '1';
                next_s <= s3;

            when s3 =>
                state <= 3;
                PC_en_fsm <= '1';
                next_s <= s0;

            when s4 =>
                state <= 4;
                ALU_en_fsm <= '1';
                next_s <= s2;

            when s5 =>
                state <= 5;
                ALU_en_fsm <= '1';
                next_s <= s2;

            when s6 =>
                state <= 6;
                ALU_en_fsm <= '1';
                next_s <= s7;

            when s7 =>
                state <= 7;
                Mem_RW_fsm <= '1';
                Mem_R_fsm <= '1';
                RF_en_fsm <= '1';
                next_s <= s3;

            when s8 =>
                state <= 8;
                ALU_en_fsm <= '1';
                next_s <= s9;

            when s9 =>
                state <= 9;
                Mem_RW_fsm <= '1';
                Mem_W_fsm <= '1';
                next_s <= s3;

            when s10 =>
                state <= 10;
					 BEQ_fsm <= '1';
                ALU_en_fsm <= '1';
                if beq_vall = '1' then
                    next_s <= s11;
                else
                    next_s <= s3;
                end if;

            when s11 =>
                state <= 11;
                PC_en_fsm <= '1';
					 BEQ_fsm <= '1';
                next_s <= s0;

            when s12 =>
                state <= 12;
                RF_en_fsm <= '1';
                JAL_fsm <= '1';
                next_s <= s13;

            when s13 =>
                state <= 13;
                J_fsm <= '1';
					 PC_en_fsm <= '1';
                next_s <= s0;

            when s14 =>
                state <= 14;
                RF_en_fsm <= '1';
                JAL_fsm <= '1';
                next_s <= s15;

            when s15 =>
                state <= 15;
                JLR_fsm <= '1';
                PC_en_fsm <= '1';
                next_s <= s0;
        
            when others =>
                next_s <= s0; -- Default to reset state
        end case;
    end process;

    -- Map internal signals to top-level ports
    PC_en <= PC_en_fsm;
    Mem_R <= Mem_R_fsm;
    Mem_W <= Mem_W_fsm;
    RF_en <= RF_en_fsm;
    IR_en <= IR_en_fsm;
    JLR <= JLR_fsm;
    J <= J_fsm;
    JAL <= JAL_fsm;
    BEQ <= BEQ_fsm;
    Mem_RW <= Mem_RW_fsm;
    ALU_en <= ALU_en_fsm;
--    IR_start <= IR_start_fsm_internal;

end architecture;
