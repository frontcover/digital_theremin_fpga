-- project_top.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
use work.dds_synthesizer_pkg.all;
use work.sine_lut_pkg.all;

--Declaration of the module's inputs and outputs
entity project_top is
    port (
		mclock: 	in 		std_logic;
		sw:		in			std_logic_vector(7 downto 0);
		JA: 		inout 	std_logic_vector(7 downto 0);
		JB:      in       std_logic_vector(6 downto 0);
		an: 		out 		std_logic_vector(3 downto 0);
		seg: 		out 		std_logic_vector(0 to 6);
		dp_o:		out		std_logic
    ); 
end project_top;

--Defining the modules behavior
architecture project_top of project_top is
	component clkdiv is
		port(
			mclk: 	in 	std_logic;
			clr: 		in 	std_logic;
			clk49k:	out 	std_logic;
			clk190:	out 	std_logic
		);
	end component;
	
	component dds_synthesizer
		port(
			clk_i:	in  	std_logic;
			rst_i:	in  	std_logic;
			ftw_i: 	in  	std_logic_vector(7 downto 0);
			phase_i:	in  	std_logic_vector(PHASE_WIDTH-1 downto 0);
			phase_o:	out 	std_logic_vector(PHASE_WIDTH-1 downto 0);
			ampl_o: 	out 	std_logic_vector(AMPL_WIDTH-1 downto 0)
		);
	end component;
	
	component addhalf
		port (
			data_i: in		std_logic_vector(7 downto 0);
			data_o: out 	std_logic_vector(7 downto 0)
		);
	end component;
	
	signal s: 				std_logic_vector(1 downto 0);
	signal aen: 			std_logic_vector (3 downto 0);
	signal ftw: 			std_logic_vector(7 downto 0);
	signal sig_out:   	std_logic_vector(7 downto 0);
	signal rst: 			std_logic := '0';
	signal init_phase:	std_logic_vector(phase_width-1 downto 0);
	signal phase_out: 	std_logic_vector(phase_width-1 downto 0);
	signal clr:				std_logic;
	signal clk49k: 		std_logic;
	signal clk190:			std_logic;
	signal hex: 			std_logic_vector(3 downto 0);
	signal hex3: 			std_logic_vector(3 downto 0);
	signal hex2: 			std_logic_vector(3 downto 0);
	signal hex1: 			std_logic_vector(3 downto 0);
	signal hex0: 			std_logic_vector(3 downto 0);
	signal dp:				std_logic;
	constant N: 			integer:=18;

begin
	
	aen <= "1111";	
	
	process(sw,hex0,hex1,hex2,hex3,JB)
	begin
	  if (sw(7)='0') then
			hex3 <= conv_std_logic_vector(190*conv_integer(sw(6 downto 0))/10000,4);
			hex2 <= conv_std_logic_vector(190*conv_integer(sw(6 downto 0))/1000 - (190*conv_integer(sw(6 downto 0))/10000)*10,4);
			hex1 <= conv_std_logic_vector(190*conv_integer(sw(6 downto 0))/100 - (190*conv_integer(sw(6 downto 0))/1000)*10,4);
			hex0 <= conv_std_logic_vector(190*conv_integer(sw(6 downto 0))/10 - (190*conv_integer(sw(6 downto 0))/100)*10,4);
	  else 
			hex3 <= conv_std_logic_vector(190*conv_integer(JB(6 downto 0))/10000,4);
			hex2 <= conv_std_logic_vector(190*conv_integer(JB(6 downto 0))/1000 - (190*conv_integer(JB(6 downto 0))/10000)*10,4);
			hex1 <= conv_std_logic_vector(190*conv_integer(JB(6 downto 0))/100 - (190*conv_integer(JB(6 downto 0))/1000)*10,4);
			hex0 <= conv_std_logic_vector(190*conv_integer(JB(6 downto 0))/10 - (190*conv_integer(JB(6 downto 0))/100)*10,4);	  
	  end if;
	end process;
	

	-- register
	process(clk190)
	begin
	  if (clk190'event and clk190='1') then
		 s <= s+1;
	  end if;
	end process;

	process(s,hex0,hex1,hex2,hex3)
	begin
	  case s is
		 when "00" =>
			an <= "1110";
			hex <= hex0;
			dp <= '1';
		 when "01" =>
			an <= "1101";
			hex <= hex1;
			dp <= '1';
		 when "10" =>
			an <= "1011";
			hex <= hex2;
			dp <= '0';
		 when others =>
			an <= "0111";
			hex <= hex3;
			dp <= '1';
	  end case;
	end process;
	   -- hex-to-7-segment led decoding
	with hex select
	  seg <=
		 "0000001" when "0000",
		 "1001111" when "0001",
		 "0010010" when "0010",
		 "0000110" when "0011",
		 "1001100" when "0100",
		 "0100100" when "0101",
		 "0100000" when "0110",
		 "0001111" when "0111",
		 "0000000" when "1000",
		 "0000100" when "1001",
		 "0001000" when "1010", --a
		 "1100000" when "1011", --b
		 "0110001" when "1100", --c
		 "1000010" when "1101", --d
		 "0110000" when "1110", --e
		 "0111000" when others; --f
	-- decimal point
	dp_o <= dp;

process(sw,JB)
begin
	if (sw(7)='0') then
	  ftw(6 downto 0) <= sw(6 downto 0);
	else
	  ftw(6 downto 0) <= JB(6 downto 0);
	end if;
end process;

	ftw(7) <= '0';
	init_phase <= (others => '0');
	rst <= '0';

U1: clkdiv
	port map (
		mclk => mclock,
		clr => clr,
		clk49k => clk49k,
		clk190 => clk190
	);

U2: addhalf
	port map (
		data_i => sig_out,
		data_o => JA
	);
	
dds : dds_synthesizer	
	port map (
		clk_i => clk49k,
		rst_i => rst,
		ftw_i => ftw,
		phase_i => init_phase,
		phase_o => phase_out,
		ampl_o => sig_out
	);
end project_top;