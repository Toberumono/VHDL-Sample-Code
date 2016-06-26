----------------------------------------------------------------------------------
-- Author: Toberumono
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library Work;
use Work.Helpers.all;

entity Decoder is
	--If inverse is true, the decoder disables the selected line instead of enabling it.
	generic (output_size : natural := 16; inverse : boolean := false);
   Port (Input :  in  std_logic_vector(0 to nearestLog2(output_size) - 1);
         Output : out std_logic_vector(0 to output_size - 1));
	constant out_size : natural := nearestPow2(output_size) - 1;
end Decoder;

architecture Behavioral of Decoder is
	type gen_vectors_output is array(0 to out_size) of std_logic_vector(0 to out_size);
	--This probably looks a little bit funny, but it just generates a bunch of vectors of the length specified by output_size.
	--For the i'th vector, the i'th element in that vector is 1 while all of the others are 0
	function gen_vectors return gen_vectors_output is
		variable output : gen_vectors_output;
	begin
		if inverse then
			for i in 0 to out_size loop
				output(i) := (i => '0', others => '1');
			end loop;
		else
			for i in 0 to out_size loop
				output(i) := (i => '1', others => '0');
			end loop;
		end if;
		return output;
	end function;
	signal outputs : gen_vectors_output;
begin
	outputs <= gen_vectors; --Generate the vectors
	Output <= outputs(to_integer(unsigned(Input))); --This converts the input into an integer and uses that as the index in the output array.
end Behavioral;
