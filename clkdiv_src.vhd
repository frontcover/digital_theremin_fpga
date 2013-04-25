-- Example 6: Clock Divider
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity clkdiv is
	port(
		mclk: 	in 	std_logic;
		clr : 	in		std_logic;
		clk49k:	out	std_logic;
		clk190: out std_logic
	    );
end clkdiv;

architecture clkdiv of clkdiv is
signal q: std_logic_vector(23 downto 0);
begin
	-- clock divider
	process (mclk,clr)
	 begin
	   if clr = '1' then
		q <= X"000000";
	   elsif mclk'event and mclk = '1' then
		q <= q + 1;
	   end if;
	end process;

	clk49k <= q(10);   	--  48.6 kHz
	clk190 <= q(18);  	-- 190 Hz

end clkdiv;
