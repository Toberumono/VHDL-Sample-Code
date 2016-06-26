----------------------------------------------------------------------------------
-- Author: Toberumono
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.Math_Real.all;

package Digits is
---This part is just function declarations.  Skip down to the package body for more interesting stuff.---
type IncrementRange is array(0 to 1) of natural;
type DigitList is array(natural range <>) of natural;

function to_natural(digits : in DigitList; base : in natural := 10) return natural;

function to_digits(number : in natural; base : in natural := 10) return DigitList;

function "="(first : in natural; second : in DigitList) return boolean;
function "="(first : in DigitList; second : in natural) return boolean;
function "="(first : in DigitList; second : in DigitList) return boolean;

function "/="(first : in natural; second : in DigitList) return boolean;
function "/="(first : in DigitList; second : in natural) return boolean;
function "/="(first : in DigitList; second : in DigitList) return boolean;

function "<="(first : in natural; second : in DigitList) return boolean;
function "<="(first : in DigitList; second : in natural) return boolean;
function "<="(first : in DigitList; second : in DigitList) return boolean;

function ">="(first : in natural; second : in DigitList) return boolean;
function ">="(first : in DigitList; second : in natural) return boolean;
function ">="(first : in DigitList; second : in DigitList) return boolean;

function "<"(first : in natural; second : in DigitList) return boolean;
function "<"(first : in DigitList; second : in natural) return boolean;
function "<"(first : in DigitList; second : in DigitList) return boolean;

function ">"(first : in natural; second : in DigitList) return boolean;
function ">"(first : in DigitList; second : in natural) return boolean;
function ">"(first : in DigitList; second : in DigitList) return boolean;

end Digits;

package body Digits is

--In this function, base is an optional parameter.  However, because it is last, using this function without providing a different value for it
--will not require specifically mapping to each value.
function to_natural(digits : in DigitList; base : in natural := 10) return natural is
	variable output : natural := 0;
	variable multiplier : natural := 1;
begin
	for i in digits'range loop
		output := output + digits(i) * multiplier;
		multiplier := multiplier * base;
	end loop;
	return output;
end to_natural;

--See previous function's comments
function to_digits(number : in natural; base : in natural := 10) return DigitList is
	variable output : DigitList(0 downto 0) := (others=>0);
	variable num : natural := number;
begin
	output(0) := num mod base;
	num := num / base;
	while num > 0 loop
		output := (num mod base) & output;
		num := num / base;
	end loop;
	return output;
end to_digits;

-----There isn't anything special below this line, unless you are interested in operator overloading------
-----If you are, you can see that there are 3 functions for each operator, each of which takes a different combination of argument types-----

function "="(first : in natural; second : in DigitList) return boolean is begin
	return first = to_natural(second);
end function;

function "="(first : in DigitList; second : in natural) return boolean is begin
	return to_natural(first) = second;
end function;

function "="(first : in DigitList; second : in DigitList) return boolean is begin
	return to_natural(first) = to_natural(second);
end function;

function "/="(first : in natural; second : in DigitList) return boolean is begin
	return first /= to_natural(second);
end function;

function "/="(first : in DigitList; second : in natural) return boolean is begin
	return to_natural(first) /= second;
end function;

function "/="(first : in DigitList; second : in DigitList) return boolean is begin
	return to_natural(first) /= to_natural(second);
end function;

function "<="(first : in natural; second : in DigitList) return boolean is begin
	return first <= to_natural(second);
end function;

function "<="(first : in DigitList; second : in natural) return boolean is begin
	return to_natural(first) <= second;
end function;

function "<="(first : in DigitList; second : in DigitList) return boolean is begin
	return to_natural(first) <= to_natural(second);
end function;

function ">="(first : in natural; second : in DigitList) return boolean is begin
	return first >= to_natural(second);
end function;

function ">="(first : in DigitList; second : in natural) return boolean is begin
	return to_natural(first) >= second;
end function;

function ">="(first : in DigitList; second : in DigitList) return boolean is begin
	return to_natural(first) >= to_natural(second);
end function;

function "<"(first : in natural; second : in DigitList) return boolean is begin
	return first < to_natural(second);
end function;

function "<"(first : in DigitList; second : in natural) return boolean is begin
	return to_natural(first) < second;
end function;

function "<"(first : in DigitList; second : in DigitList) return boolean is begin
	return to_natural(first) < to_natural(second);
end function;

function ">"(first : in natural; second : in DigitList) return boolean is begin
	return first > to_natural(second);
end function;

function ">"(first : in DigitList; second : in natural) return boolean is begin
	return to_natural(first) > second;
end function;

function ">"(first : in DigitList; second : in DigitList) return boolean is begin
	return to_natural(first) > to_natural(second);
end function;
 
end Digits;
