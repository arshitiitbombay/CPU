library ieee;
use ieee.std_logic_1164.all;
library work;
use work.basic_elements.all;

package alu_elem is

component FA is 
    port(A,B,C : in std_logic;
         OP : out std_logic_vector(1 downto 0)
    );
end component;

component sb_AS is
    port(
        a, b    : in  std_logic_vector(15 downto 0); -- Operands
        m       : in  std_logic;                    -- Mode: 0 for add, 1 for subtract
        sum     : out std_logic_vector(15 downto 0); -- Result
        c_out   : out std_logic                     -- Carry out
    );
end component;

component mlp is
    port(
        A : in std_logic_vector(3 downto 0); -- 4-bit input A
        B : in std_logic_vector(3 downto 0); -- 4-bit input B
        P : out std_logic_vector(15 downto 0) -- 8-bit product output
    );
end component;

component And_16bit is
    port(A: in std_logic_vector(15 downto 0);
         B: in std_logic_vector(15 downto 0);
         Y: out std_logic_vector(15 downto 0)
    );
end component;

component OR_16bit is
    port(A: in std_logic_vector(15 downto 0);
         B: in std_logic_vector(15 downto 0);
         Y: out std_logic_vector(15 downto 0)
    );
end component;

component BUTOR_16bit is
    port(A: in std_logic_vector(15 downto 0);
         B: in std_logic_vector(15 downto 0);
         Y: out std_logic_vector(15 downto 0)
    );
end component;

component left8 is
    port(A: in std_logic_vector(15 downto 0);
         Y: out std_logic_vector(15 downto 0)
    );
end component;

component right8 is
    port(A: in std_logic_vector(15 downto 0);
         Y: out std_logic_vector(15 downto 0)
    );
end component;

end package;

----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity FA is 
    port(A,B,C : in std_logic;
         OP : out std_logic_vector(1 downto 0)
    );
end entity;

architecture struct of FA is
begin
    OP(0) <= a xor b xor c;
    OP(1) <= ((a and b) or (b and c)) or (c and a);
end architecture;

----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity sb_AS is
    port(
        a       : in  std_logic_vector(15 downto 0); -- Operand A
        b       : in  std_logic_vector(15 downto 0); -- Operand B
        m       : in  std_logic;                     -- Mode: 0 for add, 1 for subtract
        sum     : out std_logic_vector(15 downto 0); -- Sum result
        c_out   : out std_logic                      -- Carry out
    );
end entity;

architecture struct of sb_AS is

    -- Full adder component
    component FA is
        port(
            A    : in std_logic;                      -- First operand
            B    : in std_logic;                      -- Second operand
            C    : in std_logic;                      -- Carry-in
            OP   : out std_logic_vector(1 downto 0)   -- Output [Sum, Carry]
        );
    end component;

    -- Internal signals
    signal carry    : std_logic_vector(15 downto 0);   -- Internal carry signals
    signal b_xor_m  : std_logic_vector(15 downto 0);   -- XOR of b and mode (for subtraction)
    signal sum_temp : std_logic_vector(15 downto 0);   -- Temporary sum signal

begin

    -- Generate XOR for subtraction logic (loop over each bit for XOR)
    gen_xor : for i in 0 to 15 generate
        b_xor_m(i) <= b(i) xor m;
    end generate;

    -- Handle first bit (i = 0) separately
    fa_inst_0 : FA
        port map (
            A  => a(0),
            B  => b_xor_m(0),
            C  => m,               -- Carry-in for first bit (set to mode for subtraction)
            OP(0) => sum_temp(0),  -- Sum for first bit
            OP(1) => carry(0)      -- Carry for first bit
        );

    -- Loop for i = 1 to 15
    gen_fa : for i in 1 to 15 generate
        fa_inst : FA
            port map (
                A  => a(i),
                B  => b_xor_m(i),
                C  => carry(i-1),  -- Carry-in from the previous bit
                OP(0) => sum_temp(i),  -- Sum for current bit
                OP(1) => carry(i)      -- Carry for current bit
            );
    end generate;

    -- Assign final sum and carry-out
    sum <= sum_temp;
    c_out <= carry(15); -- Final carry-out

end architecture;
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mlp is
    port(
        A : in std_logic_vector(3 downto 0); -- 4-bit input A
        B : in std_logic_vector(3 downto 0); -- 4-bit input B
        P : out std_logic_vector(15 downto 0) -- 8-bit product output
    );
end entity;

architecture behavioral of mlp is
begin

   process(A, B)
    variable product : unsigned(7 downto 0); -- 8-bit product for 4-bit multiplication
begin
    -- Perform multiplication using unsigned arithmetic
    product :=  unsigned(A(3 downto 0)) * unsigned(B(3 downto 0));  -- Multiply only the last 4 bits

    -- Convert the product back to std_logic_vector and assign to the output
    P <="00000000" & std_logic_vector(product); -- Convert unsigned to std_logic_vector
end process;


end architecture;

----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity And_16bit is
    port(A: in std_logic_vector(15 downto 0);
         B: in std_logic_vector(15 downto 0);
         Y: out std_logic_vector(15 downto 0)
    );
end entity;

architecture struct of And_16bit is
begin
    inst: for i in 0 to 15 generate
        y(i) <= a(i) and b(i);
    end generate;
end architecture;

----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OR_16bit is
    port(A: in std_logic_vector(15 downto 0);
         B: in std_logic_vector(15 downto 0);
         Y: out std_logic_vector(15 downto 0)
    );
end entity;

architecture struct of OR_16bit is
begin
    inst: for i in 0 to 15 generate
        y(i) <= a(i) or b(i);
    end generate;
end architecture;

----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Butor_16bit is
    port(A: in std_logic_vector(15 downto 0);
         B: in std_logic_vector(15 downto 0);
         Y: out std_logic_vector(15 downto 0)
    );
end entity;

architecture struct of Butor_16bit is
begin
    inst: for i in 0 to 15 generate
        y(i) <= (not a(i)) or b(i);
    end generate;
end architecture;

----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity left8 is
    port(A: in std_logic_vector(15 downto 0);
         Y: out std_logic_vector(15 downto 0)
    );
end entity;

architecture struct of left8 is
begin
--    inst1: for i in 0 to 7 generate
--        y(i) <= '0';
--    end generate;
--
--    inst2: for i in 8 to 15 generate
--        y(i) <= a(i-8);
--    end generate;

y <= a(7 downto 0) & "00000000";
end architecture;

----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity right8 is
    port(A: in std_logic_vector(15 downto 0);
         Y: out std_logic_vector(15 downto 0)
    );
end entity;

architecture struct of right8 is
begin
--    inst1: for i in 8 to 15 generate
--        y(i) <= '0';
--    end generate;
--
--    inst2: for i in 0 to 7 generate
--        y(i) <= a(i);
--    end generate;
y<= "00000000" & a(7 downto 0);
end architecture;
