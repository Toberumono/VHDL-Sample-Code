----------------------------------------------------------------------------------
-- Author: Toberumono
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.Math_Real.all;

package Helpers is

--This type and the constant on the line below it forms a decoder for a seven-segement display.
type SevenSegmentDecoderType is array(0 to 15) of std_logic_vector(0 to 6);
constant SevenSegmentDecoder : SevenSegmentDecoderType :=
	("0000001", "1001111", "0010010", "0000110", "1001100", "0100100",	"0100000", "0001111", "0000000", --0 to 8
	 "0000100", "0001000", "1100000", "0110001", "1000010", "0110000", "0111000"); --9 to F

function nearestPow2(x : in natural) return natural;

function nearestLog2(x : in natural) return natural;

--The input to this function is std_logic_vector(0 to 3) and the output is std_logic_vector(0 to 6)
function to_SevenSegment(input : in std_logic_vector) return std_logic_vector;

procedure make_toggle(signal source : in std_logic; signal value : inout std_logic);

-----The following function and procedure do not work at this time.-----
function generateDebouncers(signal clock : in std_logic; signal inputs : in std_logic_vector) return std_logic_vector;

procedure debounce(signal clock, input : in std_logic; variable button, oldb : inout std_logic; variable cnt : inout std_logic_vector; variable output : out std_logic);

end Helpers;

package body Helpers is

function nearestLog2(x : in natural) return natural is begin
	return integer(ceil(log2(real(x))));
end nearestLog2;

function nearestPow2(x : in natural) return natural is begin
	return 2 ** nearestLog2(x);
end nearestPow2;

function to_SevenSegment(input : in std_logic_vector) return std_logic_vector is begin
	return SevenSegmentDecoder(to_integer(unsigned(input)));
end to_SevenSegment;

--This procedure looks like it should only work for clocks.  However, buttons, switches, etc. All have rising and falling edges.
procedure make_toggle(signal source : in std_logic; signal value : inout std_logic) is
begin
	if rising_edge(source) then
		value <= not value;
	end if;
end procedure;

------The following function and procedure do not work as of this time.  If this changes, it'll be really cool.------
function generateDebouncers(signal clock : in std_logic; signal inputs : in std_logic_vector) return std_logic_vector is
	variable buttons, outputs : std_logic_vector(inputs'range) := (others=>'0');
	variable oldbs : std_logic_vector(inputs'range) := (others=>'1');
	type arr is array(natural range <>) of std_logic_vector(19 downto 0);
	variable cnts : arr(inputs'range);
begin
	for i in inputs'range loop
		debounce(clock => clock, input => inputs(i), button => buttons(i), oldb => oldbs(i), cnt => cnts(i), output => outputs(i));
	end loop;
	return outputs;
end generateDebouncers;

procedure debounce(signal clock, input : in std_logic; variable button, oldb : inout std_logic; variable cnt : inout std_logic_vector; variable output : out std_logic) is begin
	if rising_edge(clock) then
		if (input XOR oldb) = '1' then
			cnt := (others => '0');
			oldb := input;
		else
			cnt := cnt+1;
			if ((cnt = x"F423F") and ((oldb xor input) = '0')) then
				button := oldb;
			end if;
		end if;
	end if;
	output := button;
end procedure debounce;
 
end Helpers;
