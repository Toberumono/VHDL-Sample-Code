----------------------------------------------------------------------------------
-- Author: Toberumono
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library Work;
use Work.Helpers.all;
use Work.Digits.all;

entity SevenSegmentClockedWriter is
	generic(num_digits : natural := 4; flash_rate : real := 1.0);
   port(input : in DigitList(0 to num_digits - 1) := (others=>0);
		  output : out std_logic_vector(0 to 6) := (others=>'0');
		  anodes : out std_logic_vector(num_digits - 1 downto 0) := (0 => '0', others => '1');
		  DP : out std_logic := '1';
		  clock, flashing : in std_logic := '0');
	constant nd : natural := num_digits - 1; --For convenience
end SevenSegmentClockedWriter;

architecture Behavioral of SevenSegmentClockedWriter is
	signal current_anode : natural := 0;
	signal flashing_clock, write_clock, clock_reset : std_logic := '0';
	signal flashing_vec : std_logic_vector(0 to 6) := (others => flashing_clock and flashing);
begin
	--The next 3 lines just initialize the clocks.
	clock_reset <= '0';
	wc : entity work.scale_clock generic map (1000.0) port map (clock, clock_reset, write_clock);
	fc : entity work.scale_clock generic map (flash_rate) port map (clock, clock_reset, flashing_clock);
	--We use an inverted decoder so that we'll get vectors that work with the anode pins automatically.
	--Also, the way that this decoder is programmed, it is faster than notting the normal outputs.
	anode_dec : entity work.NaturalDecoder generic map(num_digits, true) port map (current_anode, anodes);
	DP <= '1'; --Clear the Decimal Point
	flashing_vec <= (others => flashing_clock and flashing);
	output <= SevenSegmentDecoder(input(current_anode)) or flashing_vec; --Sets all vector values to 1 on flashing_clock, creating a flashing effect
	process(write_clock) begin
		if rising_edge(write_clock) then
			current_anode <= (current_anode + 1) mod nd;
		end if;
	end process;
end Behavioral;
