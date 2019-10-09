----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/07/2019 05:09:17 PM
-- Design Name: 
-- Module Name: simple_26 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simple_26 is
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           --a_reg : in STD_LOGIC_VECTOR (31 downto 0);
           --b_reg : in STD_LOGIC_VECTOR (31 downto 0);
           din : in std_logic_vector (63 downto 0);
           dout : out STD_LOGIC_VECTOR (63 downto 0));
end simple_26;

architecture Behavioral of simple_26 is
SIGNAL i_cnt: STD_LOGIC_VECTOR(4 DOWNTO 0); 
SIGNAL a_reg: STD_LOGIC_VECTOR(31 DOWNTO 0); 
SIGNAL b_reg: STD_LOGIC_VECTOR(31 DOWNTO 0); 
SIGNAL final_rot: STD_LOGIC_VECTOR(4 DOWNTO 0); 
SIGNAL ab_rot: STD_LOGIC_VECTOR(31 DOWNTO 0); 
--SIGNAL final_rot: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal ab_xor : std_logic_vector(31 downto 0);
signal ab_out : std_logic_vector(31 downto 0); 

TYPE rom IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

CONSTANT skey: rom:=rom'( x"00000000", x"00000000", x"46F8E8C5", x"460C6085",
x"70F83B8A", x"284B8303", x"513E1454", x"F621ED22",
x"3125065D", x"11A83A5D", x"D427686B", x"713AD82D",
x"4B792F99", x"2799A4DD", x"A7901C49", x"DEDE871A",
x"36C03196", x"A7EFC249", x"61A78BB8", x"3B0A1D2B",
x"4DBFCA76", x"AE162167", x"30D76B0A", x"43192304",
x"F6CC1431", x"65046380");  -- "9BBBD8C8", x"1A37F7FB"


begin

ab_xor <= a_reg xor b_reg;

WITH final_rot(4 DOWNTO 0) SELECT
  
 ab_rot<=ab_xor(30 DOWNTO 0) & ab_xor(31) WHEN "00001",
     ab_xor(29 DOWNTO 0) & ab_xor(31 DOWNTO 30) WHEN "00010",
     ab_xor(28 DOWNTO 0) & ab_xor(31 DOWNTO 29) WHEN "00011",
     ab_xor(27 DOWNTO 0) & ab_xor(31 DOWNTO 28) WHEN "00100",
     ab_xor(26 DOWNTO 0) & ab_xor(31 DOWNTO 27) WHEN "00101",
     ab_xor(25 DOWNTO 0) & ab_xor(31 DOWNTO 26) WHEN "00110",
     ab_xor(24 DOWNTO 0) & ab_xor(31 DOWNTO 25) WHEN "00111",
     ab_xor(23 DOWNTO 0) & ab_xor(31 DOWNTO 24) WHEN "01000",
     ab_xor(22 DOWNTO 0) & ab_xor(31 DOWNTO 23) WHEN "01001",
     ab_xor(21 DOWNTO 0) & ab_xor(31 DOWNTO 22) WHEN "01010",
     ab_xor(20 DOWNTO 0) & ab_xor(31 DOWNTO 21) WHEN "01011",
     ab_xor(19 DOWNTO 0) & ab_xor(31 DOWNTO 20) WHEN "01100",
     ab_xor(18 DOWNTO 0) & ab_xor(31 DOWNTO 19) WHEN "01101",
     ab_xor(17 DOWNTO 0) & ab_xor(31 DOWNTO 18) WHEN "01110",
     ab_xor(16 DOWNTO 0) & ab_xor(31 DOWNTO 17) WHEN "01111",
     ab_xor(15 DOWNTO 0) & ab_xor(31 DOWNTO 16) WHEN "10000",
     ab_xor(14 DOWNTO 0) & ab_xor(31 DOWNTO 15) WHEN "10001",
     ab_xor(13 DOWNTO 0) & ab_xor(31 DOWNTO 14) WHEN "10010",
     ab_xor(12 DOWNTO 0) & ab_xor(31 DOWNTO 13) WHEN "10011",
     ab_xor(11 DOWNTO 0) & ab_xor(31 DOWNTO 12) WHEN "10100",
     ab_xor(10 DOWNTO 0) & ab_xor(31 DOWNTO 11) WHEN "10101",
     ab_xor(9 DOWNTO 0) & ab_xor(31 DOWNTO 10) WHEN "10110",
     ab_xor(8 DOWNTO 0) & ab_xor(31 DOWNTO 9) WHEN "10111",
     ab_xor(7 DOWNTO 0) & ab_xor(31 DOWNTO 8) WHEN "11000",
     ab_xor(6 DOWNTO 0) & ab_xor(31 DOWNTO 7) WHEN "11001",
     ab_xor(5 DOWNTO 0) & ab_xor(31 DOWNTO 6) WHEN "11010",
     ab_xor(4 DOWNTO 0) & ab_xor(31 DOWNTO 5) WHEN "11011",
     ab_xor(3 DOWNTO 0) & ab_xor(31 DOWNTO 4) WHEN "11100",
     ab_xor(2 DOWNTO 0) & ab_xor(31 DOWNTO 3) WHEN "11101",
     ab_xor(1 DOWNTO 0) & ab_xor(31 DOWNTO 2) WHEN "11110",
     ab_xor(0) & ab_xor(31 DOWNTO 1) WHEN "11111",             
   ab_xor WHEN OTHERS;
	
--a<=a_rot + skey(CONV_INTEGER(i_cnt));
final_rot<= a_reg(4 downto 0) when (i_cnt(0)='1') else b_reg(4 downto 0);

ab_out <= ab_rot + skey(CONV_INTEGER(i_cnt));

process(clr,clk)
begin

if(rising_edge(clk)) then
if(clr='0') then
a_reg <= x"00000000";
else
if(i_cnt="00000") then
a_reg <= din(63 downto 32);
elsif(i_cnt(0)='0') then
a_reg<= ab_out;
else
a_reg<=a_reg;

end if;
end if;
end if;
end process;

process(clr,clk)
begin
if(rising_edge(clk)) then 
if(clr='0') then
b_reg <= x"00000000";
else
if(i_cnt="00001") then
b_reg<= din(31 downto 0);
elsif(i_cnt(0)='1') then
b_reg<= ab_out;
else
b_reg<= b_reg;
end if;
end if;
end if;
end process;







PROCESS(clr, clk) 

BEGIN
 IF(clr='0') THEN 
   i_cnt<="00000";

ELSIF(clk'EVENT AND clk='1') THEN
    
 IF(i_cnt="11001") THEN
       
i_cnt<="00000";
     
ELSE
        
i_cnt<=i_cnt+'1';
   
  END IF;
   
END IF;

END PROCESS;

dout<= a_reg & b_reg;


end Behavioral;
