----------------------------------------------------------------------------------
-- Author: Toberumono
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity NaturalDecoder is
	--If inverse is true, the decoder disables the selected line instead of enabling it.
	generic (output_size : natural := 16; inverse : boolean := false);
	port (input  : in natural := 0;
			output : out std_logic_vector(0 to output_size - 1));
	constant out_size : natural := output_size - 1; --For convinience
end NaturalDecoder;

architecture Behavioral of NaturalDecoder is
	type gen_vectors_output is array(0 to out_size) of std_logic_vector(0 to out_size);
	--This probably looks a little bit funny, but it just generates a bunch of vectors of the length specified by output_size.
	--For the i'th vector, the i'th element in that vector is 1 while all of the others are 0
	function gen_vectors return gen_vectors_output is
		variable output : gen_vectors_output;
	begin
		for i in 0 to out_size loop
			output(i) := (i => '0', others => '1') when inverse else (i => '1', others => '0');
		end loop;
		return output;
	end function;
	signal outputs : gen_vectors_output;
begin
	--Yep.  This is it.
	outputs <= gen_vectors;
	output <= outputs(input);

end Behavioral;
