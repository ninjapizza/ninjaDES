-- bench_des_top.vhd
-- Bench for DES
-- 25/03/2020

library ieee;
use ieee.std_logic_1164.all;

entity bench_des_top is                                                                                                                                                      
end bench_des_top;                                                                                                                                      
                                                                                                                                                           
architecture rtl of bench_des_top is                                                                                                              

	signal clk				: std_logic;
	signal rst				: std_logic;
	signal key 				: std_logic_vector(63 downto 0);
	signal plaintext 			: std_logic_vector (63 downto 0);
	signal plaintext_dv 			: std_logic;
	signal ciphertext 			: std_logic_vector(63 downto 0);
	signal ciphertext_dv			: std_logic;
	signal data               		: std_logic_vector(63 downto 0);
	signal data_v				: std_logic;

begin                                                                                                                                                  

	-- DES Encoder inst
	des_operator_enc_inst : entity work.des_operator
	generic map (
		MODE 				=> '0'				-- : std_logic -- '0' = encrypt ; '1' = decrypt
	)
	port map (
		-- Clk & rst                                                                                                                                       
		clk_in 				=> clk, 			-- : in std_logic;                                                                                                                         
		rst_in 				=> rst, 			-- : in std_logic;    
		-- key                                                                                                                                              
		key_in 				=> key, 			-- : in std_logic_vector(63 downto 0);                                                                                     
		-- plaintext                                                                                                                                       
		plaintext_in 			=> plaintext, 			-- : in std_logic_vector(63 downto 0);                                                                              
		valid_in		  	=> plaintext_dv, 		-- : in std_logic;
		-- ciphertext                                                                                                                                     
		ciphertext_out 			=> ciphertext,			-- : out std_logic_vector(63 downto 0)
		valid_out		  	=> ciphertext_dv 		-- : out std_logic;
	); 
	
	-- DES Decoder inst
	des_operator_dec_inst : entity work.des_operator
	generic map (
		MODE 				=> '1'				-- : std_logic -- '0' = encrypt ; '1' = decrypt
	)
	port map (
		-- Clk & rst                                                                                                                                       
		clk_in 				=> clk, 			-- : in std_logic;                                                                                                                         
		rst_in 				=> rst, 			-- : in std_logic;    
		-- key                                                                                                                                              
		key_in 				=> key, 			-- : in std_logic_vector(63 downto 0);                                                                                     
		-- plaintext                                                                                                                                       
		plaintext_in 			=> ciphertext, 			-- : in std_logic_vector(63 downto 0);                                                                              
		valid_in		  	=> ciphertext_dv, 		-- : in std_logic;
		-- ciphertext                                                                                                                                     
		ciphertext_out 	=> data,					-- : out std_logic_vector(63 downto 0)
		valid_out		  	=> data_v 			-- : out std_logic;
	); 
	
	-- Clock generation
	p_clk:process
	begin
		clk <= '1';
		wait for 5 ns;
		clk <= '0';
		wait for 5 ns;
	end process;
	
	-- Main bench process
	process
	begin
		-- Reset the module then start
		rst 			<= '1';
		plaintext_dv 		<= '0';
		wait for 2 us;
		rst			<= '0';
		wait for 2 us;
		
		-- Test encryption / decryption
		wait until rising_edge(clk);
		key 			<= b"00010011_00110100_01010111_01111001_10011011_10111100_11011111_11110001";
		--plaintext 		  <= b"0000_0001_0010_0011_0100_0101_0110_0111_1000_1001_1010_1011_1100_1101_1110_1111";
		plaintext 		<= "1000010111101000000100110101010000001111000010101011010000000101";
		plaintext_dv 		<= '1';
		wait until rising_edge(clk);
		plaintext_dv 		<= '0';
	
		-- End of the bench
		wait;
	end process;

end rtl;
