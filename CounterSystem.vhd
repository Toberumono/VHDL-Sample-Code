----------------------------------------------------------------------------------
-- Author: Toberumono
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library Work;
use Work.Helpers.all;
use Work.Digits.all;

entity CounterSystem is
	port (output : out std_logic_vector(0 to 6) := (others => '0');
			hours  : out std_logic_vector(6 downto 0) := (others => '0');
			anodes : inout std_logic_vector(3 downto 0) := (0 => '0', others => '1');
			DP : out std_logic := '1';
			Clock : in std_logic := '0';
			up    : in std_logic := '0';
			down  : in std_logic := '0';
			left  : in std_logic := '0';
			right : in std_logic := '0';
			set   : in std_logic := '0';
			counting_direction : in std_logic := '0');
end CounterSystem;

architecture Behavioral of CounterSystem is
	signal u, d, l, r, s, clock_rst : std_logic := '0';
	signal writing : std_logic := '1';
	signal memory_bridge : std_logic_vector(7 downto 0);
	signal writing_index, hb : natural := 0;
	signal mb, sb : DigitList(0 to 1) := (others=>0);
	signal digits_bridge : DigitList(0 to 5) := (others=>0);
	signal debouncers, debounced : std_logic_vector(0 to 4) := (others=>'0');
begin
	----DEBOUNCERS----
	--debounced <= (up, down, left, right, set);
	--debouncers <= generateDebouncers(clock, debounced);
	--(u, d, l, r, s) <= debouncers;
	up_de : entity work.debouncer port map (clock, up, u);
	down_de : entity work.debouncer port map (clock, down, d);
	left_de : entity work.debouncer port map (clock, left, l);
	right_de : entity work.debouncer port map (clock, right, r);
	set_de : entity work.debouncer port map (clock, set, s);
	----DEBOUNCERS----
	
	make_toggle(s, writing);
	disp : entity work.SevenSegmentClockedWriter port map (input => digits_bridge(0 to 3), output => output, anodes => anodes, clock => Clock, flashing => writing);
	--The max_values list can be any length - the counter just loops through it.
	digits : entity work.counter generic map (num_digits => 6, max_values => (9, 5, 9, 5, 2, 4)) port map (digits => digits_bridge, up => u, down => d, left => l, right => r,
					clock => clock, writing => writing, increment_index => writing_index, counting_direction => counting_direction);
	DP <= '0' when anodes(writing_index) = '0' and writing = '1' else '1';
	hours <= std_logic_vector(to_unsigned(to_natural(digits_bridge(4 to 5)), 7));
end Behavioral;
