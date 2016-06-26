----------------------------------------------------------------------------------
-- Author: Toberumono
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debouncer is
    Port ( clk : in  STD_LOGIC;
           buttonin : in  STD_LOGIC;
           buttonout : out  STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is

	signal button: STD_LOGIC := '0';

begin

	process(clk, button)
		variable oldb:STD_LOGIC := '1';
		variable cnt:STD_LOGIC_VECTOR(19 downto 0);
	begin
		if rising_edge(clk) then
			if (buttonin XOR oldb) = '1' then
				cnt := (others => '0');
				oldb := buttonin;
			else
				cnt := cnt+1;
				if ((cnt = x"F423F") and ((oldb xor buttonin) = '0')) then
					button <= oldb;
				end if;
			end if;
		end if;
		buttonout <= button;
	end process;
	
end Behavioral;
