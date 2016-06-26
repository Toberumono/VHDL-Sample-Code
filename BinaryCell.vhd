----------------------------------------------------------------------------------
-- Author: Toberumono
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BinaryCell is
    Port ( Input : in  STD_LOGIC := '0';
           Sel : in  STD_LOGIC := '0';
           RW : in  STD_LOGIC := '1';
           Output : out  STD_LOGIC := '0');
end BinaryCell;

architecture Behavioral of BinaryCell is
	signal srq : std_logic := '0';
	signal srqnot : std_logic := '1';
	
begin
	srq <= (Sel and not RW and not Input) nor srqnot;
	srqnot <= (Sel and not RW and Input) nor srq;
	Output <= Sel and srq and RW;

end Behavioral;
