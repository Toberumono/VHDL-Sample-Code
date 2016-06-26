----------------------------------------------------------------------------------
-- Author: Toberumono
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use IEEE.Math_Real.all;

library work;
use work.helpers.all;

entity scale_clock is
	generic (hertz : real := 1000.0);
	port (
		clk_50Mhz : in  std_logic;
		rst       : in  std_logic := '0';
		scaled    : out std_logic);
	constant edge : natural := natural(50000000.0 / hertz); --This is the number of clock cycles needed to get the requested frequency.
end scale_clock;

architecture Behavioral of scale_clock is
  signal prescaler : unsigned(nearestLog2(edge) - 1 downto 0); --This gets the number of bits required to hold edge, and creates an unsigned value of that size.
  signal scaled_out : std_logic;
begin

  gen_clk : process (clk_50Mhz, rst)
  begin  -- process gen_clk
    if rst = '1' then
      scaled_out   <= '0';
      prescaler   <= (others => '0');
    elsif rising_edge(clk_50Mhz) then --While clk_50Mhz'event and clk_50Mhz = '1' appears to be equivalent, rising_edge(clock) is better.
      if prescaler = edge then
        prescaler   <= (others => '0');
        scaled_out   <= not scaled_out;
      else
        prescaler <= prescaler + "1";
      end if;
    end if;
  end process gen_clk;

scaled <= scaled_out;

end Behavioral;
