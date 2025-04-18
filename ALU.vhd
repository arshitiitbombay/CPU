library ieee;
use ieee.std_logic_1164.all;
library work;
use work.basic_elements.all;
use work.alu_elem.all;

entity ALU is
port(
    ALU_o : out std_logic_vector(15 downto 0);
    ALU_A, ALU_B : in std_logic_vector(15 downto 0);
    clk,alu_en : in std_logic;
    op_val : in std_logic_vector(3 downto 0);
    carry_flag : out std_logic
);
end entity;

architecture arch of ALU is

    -- Declare the components outside of the process
    signal add_sub_out,Lw_sw_out,BEQ_out : std_logic_vector(15 downto 0);
    signal mul_out : std_logic_vector(15 downto 0);
    signal and_out : std_logic_vector(15 downto 0);
    signal or_out : std_logic_vector(15 downto 0);
    signal imp_out : std_logic_vector(15 downto 0);
    signal lhi_out : std_logic_vector(15 downto 0);
    signal lli_out : std_logic_vector(15 downto 0);
	 signal crr,crr1,crr2 : std_logic;

begin

    -- Instantiating components outside the case block
    add_sub: sb_AS port map (a => ALU_A, b => ALU_B, m => op_val(1), sum => add_sub_out, c_out => crr);
	 Lw_Sw :sb_AS port map (a => ALU_A, b => ALU_B, m => '0', sum => lw_sw_out, c_out => crr2);
	 BEQ :sb_AS port map (a => ALU_A, b => ALU_B, m => '1', sum => BEQ_out, c_out => crr1);
    mul: mlp port map (a => ALU_A(3 downto 0), b => ALU_B(3 downto 0), p => mul_out);
    and_op: and_16bit port map (a => ALU_A, b => ALU_B, y => and_out);
    or_op: OR_16bit port map (a => ALU_A, b => ALU_B, y => or_out);
    imp: BUTOR_16bit port map (a => ALU_A, b => ALU_B, y => imp_out);
    lhi: left8 port map (a => ALU_A, y => lhi_out);
    lli: right8 port map (a => ALU_A, y => lli_out);

    -- Main process
    main: process(clk)
    begin
        if alu_en = '1' then
            case op_val is
                when "0000" | "0010" | "0001"  =>
                    ALU_o <= add_sub_out;
                    carry_flag <= crr; -- carry_flag is already set in the component instantiation
                    
                when "0011" =>
                    ALU_o <= mul_out;
                    carry_flag <= '0'; -- No carry flag for multiplication
                    
                when "0100" =>
                    ALU_o <= and_out;
                    carry_flag <= '0'; -- No carry flag for AND operation
                
                when "0101" =>
                    ALU_o <= or_out;
                    carry_flag <= '0'; -- No carry flag for OR operation
                
                when "0110" =>
                    ALU_o <= imp_out;
                    carry_flag <= '0'; -- No carry flag for IMP operation
                
                when "1000" =>
                    ALU_o <= lhi_out;
                    carry_flag <= '0'; -- No carry flag for left8 operation
                
                when "1001" =>
                    ALU_o <= lli_out;
                    carry_flag <= '0'; -- No carry flag for right8 operation
                
                when "1010" | "1011"=>
						  Alu_o <= lw_sw_out;
						  carry_flag <= crr2;
					when "1100" =>
							Alu_o <= beq_out;
						  carry_flag <= crr1;
					
						
                when others =>
                    ALU_o <= "0000000000000000";
                    carry_flag <= '0';
            end case;
        end if;
    end process;

end architecture;
