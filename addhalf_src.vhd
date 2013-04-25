
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity addhalf is
	port (
				data_i: in std_logic_vector (7 downto 0);
				data_o: out std_logic_vector (7 downto 0)
			);
end addhalf;

architecture Behavioral of addhalf is
signal data: unsigned (7 downto 0);
begin
	process(data_i)
	begin
		data <= "10000000";
		data_o <= std_logic_vector(data + unsigned(data_i)); --  half of max (i.e, 2^8/2)
	end process;

end Behavioral;