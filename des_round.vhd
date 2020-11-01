-- des_round.vhd
-- Round for DES
-- 25/03/2020

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.des_package.all;

entity des_round is
port (

	-- Clk & rst                                                                                                                                       
	clk_in 		: in 	std_logic;                                                                                                                         
	rst_in 		: in 	std_logic;
	
	-- R & L
	R_in 		: in	std_logic_vector(31 downto 0);
	L_in 		: in	std_logic_vector(31 downto 0);
	R_out 		: out	std_logic_vector(31 downto 0);
	L_out 		: out	std_logic_vector(31 downto 0);
	
	-- data valids
	dv_in 		: in 	std_logic;
	dv_out		: out	std_logic;
	
	-- Subkey
	subkey_in       : in	std_logic_vector(47 downto 0)

);
end des_round;                                                                                                                                      

architecture rtl of des_round is         

begin

	p_des_round:process(clk_in)

		-- We use VHDL variables here in order to do one DES round in one cycle
		variable data_post_E 		: std_logic_vector(47 downto 0);
		variable data_post_xor 	        : std_logic_vector(47 downto 0);
		variable data_post_S 		: std_logic_vector(31 downto 0);
		variable  data_post_P 		: std_logic_vector(31 downto 0);

	begin
	
		if rising_edge(clk_in) then
		
			if rst_in = '1' then
			
				dv_out <= '0';
			
			else

				-- Expension Permutation E
				data_post_E := des_data_E(R_in);
				
				-- XOR data with subkey
				data_post_xor := data_post_E xor subkey_in;
				
				-- S-box : S1 .. S8
				data_post_S (31 downto 28) := des_data_S1(data_post_xor(47 downto 42));
				data_post_S (27 downto 24) := des_data_S2(data_post_xor(41 downto 36));
				data_post_S (23 downto 20) := des_data_S3(data_post_xor(35 downto 30));
				data_post_S (19 downto 16) := des_data_S4(data_post_xor(29 downto 24));
				data_post_S (15 downto 12) := des_data_S5(data_post_xor(23 downto 18));
				data_post_S (11 downto 08) := des_data_S6(data_post_xor(17 downto 12));
				data_post_S (07 downto 04) := des_data_S7(data_post_xor(11 downto 06));
				data_post_S (03 downto 00) := des_data_S8(data_post_xor(05 downto 00));
				
				-- Permutation P
				data_post_P := des_data_P(data_post_S);

				-- Outputs
				R_out   <= L_in xor data_post_P;
				L_out   <= R_in;
				dv_out 	<= dv_in;
			
			end if;
		
		end if;
	
	end process;

end rtl;
