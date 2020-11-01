-- des_operator.vhd
-- Encoder / Decoder for DES
-- 25/03/2020

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.des_package.all;

entity des_operator is
generic (
	MODE : std_logic := '0' -- '0' = encrypt ; '1' = decrypt
);
port (

	-- Clk & rst
	clk_in 				: in    	std_logic;
	rst_in 				: in    	std_logic;

	-- key
	key_in 				: in    	std_logic_vector(63 downto 0);

	-- plaintext
	plaintext_in 		        : in		std_logic_vector(63 downto 0);
	valid_in		  	: in		std_logic;
	-- ciphertext
	ciphertext_out 	                : out		std_logic_vector(63 downto 0);
	valid_out 			: out		std_logic

);
end des_operator;

architecture rtl of des_operator is

	-- Subkeys & CD
	signal subkeys 					: subkey_array;				-- Subkeys : K1 .. K16
	signal key_after_PC 				: std_logic_vector(55 downto 0);	-- Key after PC
	signal key_half_C 				: key_half;	                        -- C0 .. C15
	signal key_half_D 				: key_half;	                        -- D0 .. D15
	
	-- Data
	signal data_after_initial_permutation 		: std_logic_vector(63 downto 0);       	-- Inital Permutation
	signal data_half_L 				: data_half;	                      	-- L0 .. L15
	signal data_half_R	 			: data_half;	                  	-- R0 .. R15
	signal array_dv 				: array_dv_type;	              	-- Data valids

begin

	--##########################################################################################
	--# INPUTS & OUTPUTS			
	--# Apply Initial permutation and last permutation
	--##########################################################################################
	
	-- Inputs
	data_after_initial_permutation 	<= des_data_IP(plaintext_in);
	p_data_delay:process(clk_in)
	begin
		if rising_edge(clk_in) then
			if rst_in = '1' then
				array_dv(0<= '0';
			else
				array_dv(0) 		<= valid_in;
				data_half_L(0)		<= data_after_initial_permutation(63 downto 32);
				data_half_R(0)		<= data_after_initial_permutation(31 downto 0);
			end if;
		end if;		
	end process;
	
	-- Outputs
	ciphertext_out 		<= des_data_FP(data_half_R(16) & data_half_L(16) );
	valid_out 		<= array_dv(16);
	
	--##########################################################################################
	--##########################################################################################

	--##########################################################################################
	--# DES ROUNDS			
	--# Computing the 16 rounds	
	--##########################################################################################
	DES_ROUNDS : for I in 0 to 15 generate
		des_round_inst : entity work.des_round
		port map (

			-- Clk & rst
			clk_in 		=> clk_in, 			-- : in	std_logic;
			rst_in 		=> rst_in, 			-- : in	std_logic;

			-- R & L
			R_in 		=> data_half_R(I), 		-- : in	std_logic_vector(31 downto 0);
			L_in 		=> data_half_L	(I), 		-- : in	std_logic_vector(31 downto 0);
			R_out 		=> data_half_R (I+1), 		-- : out std_logic_vector(31 downto 0);
			L_out 		=> data_half_L	(I+1),		-- : out std_logic_vector(31 downto 0);

			-- data valids
			dv_in 		=> array_dv(I), 		-- : in std_logic;
			dv_out		=> array_dv(I+1), 		-- : out std_logic;

			-- Subkey
			subkey_in 	=> subkeys(I+1)   		-- : in	std_logic_vector(47 downto 0)

		);
	end generate DES_ROUNDS;
	
	--##########################################################################################
	--##########################################################################################

	--##########################################################################################
	--# Key Scheduling						
	--# Computing the 16 subkeys		
	--##########################################################################################
	key_after_PC 	<= des_key_PC1(key_in);
	p_key_scheduling:process(clk_in)
	begin
		if rising_edge(clk_in) then

			-- Encrypt : apply des_key_left_shift
			if MODE = '0' then

				-- Compute the first subkey
				subkeys(1) 		<= des_key_PC2(des_key_left_shift (key_after_PC(55 downto 28), LEFT_SHIFT_LIST(1)) & des_key_left_shift (key_after_PC(27 downto 0), LEFT_SHIFT_LIST(1)));
				key_half_C(1) 		<= des_key_left_shift (key_after_PC(55 downto 28), LEFT_SHIFT_LIST(1));
				key_half_D(1) 		<= des_key_left_shift (key_after_PC(27 downto 0), LEFT_SHIFT_LIST(1));

				-- Compute the other subkeys
				for I in 2 to 16 loop
					key_half_C(I) 	<= des_key_left_shift (key_half_C(I-1), LEFT_SHIFT_LIST(I));
					key_half_D(I) 	<= des_key_left_shift (key_half_D(I-1), LEFT_SHIFT_LIST(I));
					subkeys(I) 	<= des_key_PC2(des_key_left_shift ( key_half_C(I-1), LEFT_SHIFT_LIST(I)) &  des_key_left_shift ( key_half_D(I-1), LEFT_SHIFT_LIST(I)));
				end loop;

			-- Decrypt : apply des_key_right_shift
			else

				-- Compute the first subkey
				subkeys(1) 		<= des_key_PC2(des_key_right_shift (key_after_PC(55 downto 28), RIGHT_SHIFT_LIST(1)) & des_key_right_shift ( key_after_PC(27 downto 0), RIGHT_SHIFT_LIST(1)));
				key_half_C(1) 		<= des_key_right_shift (key_after_PC(55 downto 28), RIGHT_SHIFT_LIST(1));
				key_half_D(1) 		<= des_key_right_shift (key_after_PC(27 downto 0), RIGHT_SHIFT_LIST(1));

				-- Compute the other subkeys
				for I in 2 to 16 loop
					key_half_C(I) 	<= des_key_right_shift (key_half_C(I-1), RIGHT_SHIFT_LIST(I));
					key_half_D(I) 	<= des_key_right_shift (key_half_D(I-1), RIGHT_SHIFT_LIST(I));
					subkeys(I) 	<= des_key_PC2(des_key_right_shift ( key_half_C(I-1), RIGHT_SHIFT_LIST(I)) &  des_key_right_shift ( key_half_D(I-1), RIGHT_SHIFT_LIST(I)));
				end loop;

			end if;

		end if;
	end process;
	
	--##########################################################################################
	--##########################################################################################

end rtl;
