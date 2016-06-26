----------------------------------------------------------------------------------
-- Author: Toberumono
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RowOfCells is
	generic(num_bits : natural := 8);
	Port (Input  : in  STD_LOGIC_VECTOR(0 to num_bits - 1) := (others=>'0');
         Sel    : in  STD_LOGIC := '0';
         RW     : in  STD_LOGIC := '0';
         Output : out STD_LOGIC_VECTOR(0 to num_bits - 1) := (others=>'0'));
end RowOfCells;

architecture Behavioral of RowOfCells is
	component BinaryCell
		Port(Input : in STD_LOGIC; Sel : in STD_LOGIC; RW : in STD_LOGIC; Output : out STD_LOGIC);
	end component;
begin
	
	Make_Cells : for I in 0 to num_bits - 1 generate
		cell : BinaryCell port map(Input(I), Sel, RW, Output(I));
	end generate Make_Cells;
end Behavioral;
