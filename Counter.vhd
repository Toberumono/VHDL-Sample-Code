----------------------------------------------------------------------------------
-- Author: Toberumono
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

library Work;
use Work.Helpers.all;
use Work.Digits.all;

--An arbitrary base and output-size counter with asynchronous reset, and a selectable increment index.
--For a simple base-10 counter, the only parameters needed are the number of digits (num_digits in generic),
--an output line for the counter (digits in port), and the up and down signals (again in port) if desired.
entity Counter is
	generic(num_digits : natural := 4;
			  min_value : natural := 0; -- The minimum value that a digit can take
			  max_values : DigitList := (others=>9);
			  input_frequency : real := 2.0;
			  count_frequency : real := 1.0);
	port(digits : inout DigitList(num_digits - 1 downto 0) := (others=>min_value);
		  increment_index : inout natural := 0;
		  up, down, left, right, clock, counting_direction, load : in std_logic := '0';
		  writing : in std_logic := '1';
		  increment_range : IncrementRange := (0, num_digits - 1);
		  l : DigitList(num_digits - 1 downto 0) := (others=>min_value));
	constant nd : natural := num_digits - 1;
	constant iter_limit : natural := nd - 1;
	constant num_max : natural := max_values'high; --Store this for better readability.
end Counter;

architecture Behavioral of Counter is
	signal input_clock, counter_clock, clock_reset : std_logic := '0';
	--Direction = '1' -> up, '0' -> down
	function increment(increment_index : in natural; digits : in DigitList(0 to nd); direction : in std_logic) return DigitList is
		variable new_times : DigitList(digits'range) := digits;
	begin
		if direction = '1' then
			new_times(increment_index) := new_times(increment_index) + 1;
			for i in 0 to iter_limit loop
				if new_times(i) > max_values(i mod num_max) then
					new_times(i) := min_value;
					new_times(i + 1) := new_times(i + 1) + 1;
				end if;
			end loop;
		else
			--If a value is 0, subtracting 1 rolls it around to the maximum value for it's type.
			--Hence, all of the checks still use max_value
			new_times(increment_index) := new_times(increment_index) - 1;
			for i in 0 to iter_limit loop
				if new_times(i) > max_values(i mod num_max) then
					new_times(i) := max_values(i mod num_max);
					new_times(i + 1) := new_times(i + 1) - 1;
				end if;
			end loop;
		end if;
		return new_times;
	end function;
begin
	--The next 3 lines are just for setting up the clocks.
	clock_reset <= '0';
	ic : entity work.scale_clock generic map (input_frequency) port map (clock, clock_reset, input_clock);
	cc : entity work.scale_clock generic map (count_frequency) port map (clock, clock_reset, counter_clock);
	--The compiler warns that writing and l should be on this process's sensitivity list.  They should not be.
	process (input_clock, counter_clock, load) is
		variable new_times : DigitList(0 to nd);
	begin
		if load = '1' then --Asynchronous reset.  Yep.  This is all that is needed.
			digits <= l;
		elsif writing = '1' then --If the user is writing, use the input clock, and determine up or down through the buttons
			if rising_edge(input_clock) then
				if up = '1' xor down = '1' then
					digits <= increment(increment_index, digits, up);
				end if;
			end if;
		else --If the program is doing the writing, use the counter clock (which is slower by default for things like hms clocks)
			if rising_edge(counter_clock) then
				if counting_direction = '1' or digits > min_value then
					digits <= increment(0, digits, counting_direction);
				end if;
			end if;
		end if;
	end process;
	process (input_clock, left, right) begin
		if rising_edge(input_clock) then
			if left = '1' then
				if increment_index = increment_range(1) then
					increment_index <= increment_range(0);
				else
					increment_index <= increment_index + 1;
				end if;
			elsif right = '1' then
				if increment_index = increment_range(0) then
					increment_index <= increment_range(1);
				else
					increment_index <= increment_index - 1;
				end if;
			end if;
		end if;
	end process;
end Behavioral;
