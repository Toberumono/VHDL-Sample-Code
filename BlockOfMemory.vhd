----------------------------------------------------------------------------------
-- Author: Toberumono
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library Work;
use Work.Helpers.all;

entity BlockOfMemory is
	generic (num_rows : natural := 16; bits_per_row : natural := 8);
   Port (Input :  in  STD_LOGIC_VECTOR(0 to bits_per_row - 1) := (others=>'0');
			Selection : in STD_LOGIC_VECTOR(0 to nearestLog2(num_rows) - 1) := (others=>'0');
			Sel : in STD_LOGIC := '0';
			ReadWrite : in STD_LOGIC := '0';
         Output : out STD_LOGIC_VECTOR(0 to bits_per_row - 1) := (others=>'0'));
	--For simplicity, the actual number of rows that we use is the smallest power of two greater than or equal to the number of rows that was passed.
	constant actual_rows : natural := nearestPow2(num_rows);
	constant nr : natural := actual_rows - 1;
	constant bpr : natural := bits_per_row - 1;
end BlockOfMemory;

architecture Behavioral of BlockOfMemory is
	signal SelB : STD_LOGIC_VECTOR(0 to nr) := (others => '0');
	type gen_rows_output is array(0 to nr) of std_logic_vector(0 to bpr);
	signal outputs : gen_rows_output := (others=>(others=>'0'));
begin
	decoder : entity work.Decoder generic map(actual_rows) port map(Selection, SelB);
	--This uses both a selection list and a global select flag to remove a bunch of messy array logic.
	Make_Rows : for i in 0 to nr generate
		row : entity work.RowOfCells generic map (bits_per_row) port map(Input, SelB(i) and Sel, ReadWrite, outputs(i));
	end generate Make_Rows;
	Output <= outputs(to_integer(unsigned(Selection)));
end Behavioral;
