----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:49:12 10/22/2018 
-- Design Name: 
-- Module Name:    decrypt - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decrypt is
    Port ( clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (63 downto 0);
           dout : out  STD_LOGIC_VECTOR (63 downto 0));
end decrypt;

architecture Behavioral of decrypt is

SIGNAL i_cnt: STD_LOGIC_VECTOR(3 DOWNTO 0); 
  SIGNAL ab_xor: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL a_rot: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL a: STD_LOGIC_VECTOR(31 DOWNTO 0);
  --register to store value A
  SIGNAL a_reg: STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL ba_xor: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL b_rot: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL b: STD_LOGIC_VECTOR(31 DOWNTO 0);
  --register to store value B
  SIGNAL b_reg: STD_LOGIC_VECTOR(31 DOWNTO 0); 
  
  
TYPE rom IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0); 

CONSTANT skey: rom:=rom'(  x"00000000", x"00000000", x"46F8E8C5", x"460C6085",
                           x"70F83B8A", x"284B8303", x"513E1454", x"F621ED22",
                           x"3125065D", x"11A83A5D", x"D427686B", x"713AD82D",
                           x"4B792F99", x"2799A4DD", x"A7901C49", x"DEDE871A",
                           x"36C03196", x"A7EFC249", x"61A78BB8", x"3B0A1D2B",
                           x"4DBFCA76", x"AE162167", x"30D76B0A", x"43192304",
                           x"F6CC1431", x"65046380");   


begin

ba_xor <= b_reg - skey(CONV_INTEGER(i_cnt & '1'));

WITH a_reg(4 DOWNTO 0) SELECT
 b_rot <=   ba_xor(0) & ba_xor(31 DOWNTO 1)   WHEN "00001",
            ba_xor(1 DOWNTO 0) & ba_xor(31 DOWNTO 2)   WHEN "00010", 
            ba_xor(2 DOWNTO 0) & ba_xor(31 DOWNTO 3)   WHEN "00011",
            ba_xor(3 DOWNTO 0) & ba_xor(31 DOWNTO 4)   WHEN "00100",
            ba_xor(4 DOWNTO 0) & ba_xor(31 DOWNTO 5)   WHEN "00101",
            ba_xor(5 DOWNTO 0) & ba_xor(31 DOWNTO 6)  WHEN "00110",
            ba_xor(6 DOWNTO 0) & ba_xor(31 DOWNTO 7)   WHEN "00111",
            ba_xor(7 DOWNTO 0) & ba_xor(31 DOWNTO 8)   WHEN "01000",
            ba_xor(8 DOWNTO 0) & ba_xor(31 DOWNTO 9)   WHEN "01001",
            ba_xor(9 DOWNTO 0) & ba_xor(31 DOWNTO 10)   WHEN "01010",
            ba_xor(10 DOWNTO 0) & ba_xor(31 DOWNTO 11)   WHEN "01011",
            ba_xor(11 DOWNTO 0) & ba_xor(31 DOWNTO 12)   WHEN "01100",
            ba_xor(12 DOWNTO 0) & ba_xor(31 DOWNTO 13)  WHEN "01101",
            ba_xor(13 DOWNTO 0) & ba_xor(31 DOWNTO 14)  WHEN "01110",
            ba_xor(14 DOWNTO 0) & ba_xor(31 DOWNTO 15)  WHEN "01111",
            ba_xor(15 DOWNTO 0) & ba_xor(31 DOWNTO 16)   WHEN "10000",
            ba_xor(16 DOWNTO 0) & ba_xor(31 DOWNTO 17) WHEN "10001",
            ba_xor(17 DOWNTO 0) & ba_xor(31 DOWNTO 18) WHEN "10010",
            ba_xor(18 DOWNTO 0) & ba_xor(31 DOWNTO 19) WHEN "10011",
            ba_xor(19 DOWNTO 0) & ba_xor(31 DOWNTO 20) WHEN "10100",
            ba_xor(20 DOWNTO 0) & ba_xor(31 DOWNTO 21) WHEN "10101",
            ba_xor(21 DOWNTO 0) & ba_xor(31 DOWNTO 22) WHEN "10110",
            ba_xor(22 DOWNTO 0) & ba_xor(31 DOWNTO 23) WHEN "10111",
            ba_xor(23 DOWNTO 0) & ba_xor(31 DOWNTO 24) WHEN "11000",
            ba_xor(24 DOWNTO 0) & ba_xor(31 DOWNTO 25) WHEN "11001",
            ba_xor(25 DOWNTO 0) & ba_xor(31 DOWNTO 26) WHEN "11010",
            ba_xor(26 DOWNTO 0) & ba_xor(31 DOWNTO 27) WHEN "11011",
            ba_xor(27 DOWNTO 0) & ba_xor(31 DOWNTO 28) WHEN "11100",
            ba_xor(28 DOWNTO 0) & ba_xor(31 DOWNTO 29) WHEN "11101",
            ba_xor(29 DOWNTO 0) & ba_xor(31 DOWNTO 30) WHEN "11110",
            ba_xor (30 DOWNTO 0) & ba_xor(31) WHEN "11111",
            ba_xor WHEN OTHERS;


b <= b_rot xor a_reg;   

a_rot <= a_reg - skey(CONV_INTEGER(i_cnt & '0')); -- S [2*1]

WITH b(4 DOWNTO 0) SELECT
    ab_xor <=  a_rot(0) & a_rot(31 DOWNTO 1)   WHEN "00001",
	           a_rot(1 DOWNTO 0) & a_rot(31 DOWNTO 2)   WHEN "00010", 
	           a_rot(2 DOWNTO 0) & a_rot(31 DOWNTO 3)   WHEN "00011",
	           a_rot(3 DOWNTO 0) & a_rot(31 DOWNTO 4)   WHEN "00100",
	           a_rot(4 DOWNTO 0) & a_rot(31 DOWNTO 5)   WHEN "00101",
	           a_rot(5 DOWNTO 0) & a_rot(31 DOWNTO 6)  WHEN "00110",
	           a_rot(6 DOWNTO 0) & a_rot(31 DOWNTO 7)   WHEN "00111",
	           a_rot(7 DOWNTO 0) & a_rot(31 DOWNTO 8)   WHEN "01000",
	           a_rot(8 DOWNTO 0) & a_rot(31 DOWNTO 9)   WHEN "01001",
	           a_rot(9 DOWNTO 0) & a_rot(31 DOWNTO 10)  WHEN "01010",
	           a_rot(10 DOWNTO 0) & a_rot(31 DOWNTO 11) WHEN "01011",
	           a_rot(11 DOWNTO 0) & a_rot(31 DOWNTO 12) WHEN "01100",
	           a_rot(12 DOWNTO 0) & a_rot(31 DOWNTO 13) WHEN "01101",
	           a_rot(13 DOWNTO 0) & a_rot(31 DOWNTO 14) WHEN "01110",
	           a_rot(14 DOWNTO 0) & a_rot(31 DOWNTO 15) WHEN "01111",
	           a_rot(15 DOWNTO 0) & a_rot(31 DOWNTO 16) WHEN "10000",
	           a_rot(16 DOWNTO 0) & a_rot(31 DOWNTO 17) WHEN "10001",
	           a_rot(17 DOWNTO 0) & a_rot(31 DOWNTO 18) WHEN "10010",
	           a_rot(18 DOWNTO 0) & a_rot(31 DOWNTO 19) WHEN "10011",
	           a_rot(19 DOWNTO 0) & a_rot(31 DOWNTO 20) WHEN "10100",
	           a_rot(20 DOWNTO 0) & a_rot(31 DOWNTO 21) WHEN "10101",
	           a_rot(21 DOWNTO 0) & a_rot(31 DOWNTO 22) WHEN "10110",
	           a_rot(22 DOWNTO 0) & a_rot(31 DOWNTO 23) WHEN "10111",
	           a_rot(23 DOWNTO 0) & a_rot(31 DOWNTO 24) WHEN "11000",
	           a_rot(24 DOWNTO 0) & a_rot(31 DOWNTO 25) WHEN "11001",
	           a_rot(25 DOWNTO 0) & a_rot(31 DOWNTO 26) WHEN "11010",
	           a_rot(26 DOWNTO 0) & a_rot(31 DOWNTO 27) WHEN "11011",
	           a_rot(27 DOWNTO 0) & a_rot(31 DOWNTO 28) WHEN "11100",
	           a_rot(28 DOWNTO 0) & a_rot(31 DOWNTO 29) WHEN "11101",
               a_rot(29 DOWNTO 0) & a_rot(31 DOWNTO 30) WHEN "11110",
	           a_rot (30 DOWNTO 0) & a_rot(31) WHEN "11111",
	           a_rot WHEN OTHERS;

a<= ab_xor xor b;


-- a_reg
PROCESS(clr, clk)  
BEGIN
 IF(clr='0') THEN a_reg <= din(63 DOWNTO 32);
 ELSIF(rising_edge(clk)) THEN a_reg<=a;
END IF;
END PROCESS;

-- b_reg
   
PROCESS(clr, clk)
 BEGIN
      IF(clr='0') THEN b_reg<=din(31 DOWNTO 0);
      ELSIF(rising_edge(clk)) THEN b_reg<=b;
      END IF;
  END PROCESS;   
  

-- 4 bit downcounter
PROCESS(clr, clk) 
    BEGIN
        IF(clr='0') THEN 
            i_cnt<="1100";
        ELSIF(rising_edge(clk)) THEN
        IF(i_cnt="0001") THEN
            i_cnt<="1100";
        ELSE
            i_cnt<=i_cnt-'1';

        END IF;
        END IF;
END PROCESS;	
dout    <=  a_reg & b_reg;
end Behavioral;