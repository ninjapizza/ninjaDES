-- des_package.vhd
-- Package for DES
-- 25/03/2020

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package des_package is

	--##########################################################################################
	--# Data Types
	--##########################################################################################
	type array_dv_type 			is array (0 to 16) of std_logic;
	type key_half 				is array (0 to 16) of std_logic_vector(27 downto 0);
	type subkey_array 			is array (1 to 16) of std_logic_vector(47 downto 0);
	type data_half 				is array (0 to 16) of std_logic_vector(31 downto 0);
	type des_number_of_shifts_type		is array (1 to 16) of integer;

	--##########################################################################################
	--# Constants
	--##########################################################################################
	constant LEFT_SHIFT_LIST 		: des_number_of_shifts_type := (1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1);
	constant RIGHT_SHIFT_LIST 		: des_number_of_shifts_type := (0, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1);

	--##########################################################################################
	--# Data Function
	--##########################################################################################
	function des_data_IP 			(v_in : in	std_logic_vector(1 to 64)) 		return std_logic_vector;
	function des_data_FP 			(v_in : in	std_logic_vector(1 to 64)) 		return std_logic_vector;
	function des_data_E 			(v_in : in	std_logic_vector(1 to 32)) 		return std_logic_vector;
	function des_data_P 			(v_in : in	std_logic_vector(1 to 32)) 		return std_logic_vector;
	function des_data_S1 			(v_in : in	std_logic_vector(1 to 6)) 		return std_logic_vector;
	function des_data_S2 			(v_in : in	std_logic_vector(1 to 6)) 		return std_logic_vector;
	function des_data_S3 			(v_in : in	std_logic_vector(1 to 6)) 		return std_logic_vector;
	function des_data_S4 			(v_in : in	std_logic_vector(1 to 6)) 		return std_logic_vector;
	function des_data_S5 			(v_in : in	std_logic_vector(1 to 6)) 		return std_logic_vector;
	function des_data_S6 			(v_in : in	std_logic_vector(1 to 6)) 		return std_logic_vector;
	function des_data_S7 			(v_in : in	std_logic_vector(1 to 6)) 		return std_logic_vector;
	function des_data_S8 			(v_in : in	std_logic_vector(1 to 6)) 		return std_logic_vector;
		
	--##########################################################################################
	--# Key Scheduling functions
	--##########################################################################################
	function des_key_PC1 			(v_in : in	std_logic_vector(1 to 64)) 		return std_logic_vector;
	function des_key_PC2 			(v_in : in	std_logic_vector(1 to 56)) 		return std_logic_vector;
	function des_key_left_shift 		(v_in : in	std_logic_vector; nb_in : in integer)	return std_logic_vector;
	function des_key_right_shift		(v_in : in	std_logic_vector; nb_in : in integer)	return std_logic_vector;

end package des_package;

-- Package Body Section
package body des_package is

	-- Initial Permutation IP (64b to 64b)
	-- 58    50   42    34    26   18    10    02
	-- 60    52   44    36    28   20    12    04
	-- 62    54   46    38    30   22    14    06
	-- 64    56   48    40    32   24    16    08
	-- 57    49   41    33    25   17    09    01
	-- 59    51   43    35    27   19    11    03
	-- 61    53   45    37    29   21    13    05
	-- 63    55   47    39    31   23    15    07
	function des_data_IP (
		v_in : in std_logic_vector(1 to 64)
	)
	return std_logic_vector is
	begin
		return (	v_in (58) & v_in (50) & v_in (42) & v_in (34) & v_in (26) & v_in (18) & v_in (10) & v_in (02) &
				v_in (60) & v_in (52) & v_in (44) & v_in (36) & v_in (28) & v_in (20) & v_in (12) & v_in (04) &
				v_in (62) & v_in (54) & v_in (46) & v_in (38) & v_in (30) & v_in (22) & v_in (14) & v_in (06) &
				v_in (64) & v_in (56) & v_in (48) & v_in (40) & v_in (32) & v_in (24) & v_in (16) & v_in (08) &
				v_in (57) & v_in (49) & v_in (41) & v_in (33) & v_in (25) & v_in (17) & v_in (09) & v_in (01) &
				v_in (59) & v_in (51) & v_in (43) & v_in (35) & v_in (27) & v_in (19) & v_in (11) & v_in (03) &
				v_in (61) & v_in (53) & v_in (45) & v_in (37) & v_in (29) & v_in (21) & v_in (13) & v_in (05) &
				v_in (63) & v_in (55) & v_in (47) & v_in (39) & v_in (31) & v_in (23) & v_in (15) & v_in (07) 
		);
	end;
	
	-- Expension E (32b to 48b)
	-- 32    01   02    03    04   05
	-- 04    05   06    07    08   09
	-- 08    09   10    11    12   13
	-- 12    13   14    15    16   17
	-- 16    17   18    19    20   21
	-- 20    21   22    23    24   25
	-- 24    25   26    27    28   29
	-- 28    29   30    31    32   01
	function des_data_E (
		v_in : in std_logic_vector(1 to 32)
	)
	return std_logic_vector is
	begin
		return (	v_in (32) & v_in (01) & v_in (02) & v_in (03) & v_in (04) & v_in (05) &
				v_in (04) & v_in (05) & v_in (06) & v_in (07) & v_in (08) & v_in (09) &
				v_in (08) & v_in (09) & v_in (10) & v_in (11) & v_in (12) & v_in (13) &
				v_in (12) & v_in (13) & v_in (14) & v_in (15) & v_in (16) & v_in (17) &
				v_in (16) & v_in (17) & v_in (18) & v_in (19) & v_in (20) & v_in (21) &
				v_in (20) & v_in (21) & v_in (22) & v_in (23) & v_in (24) & v_in (25) &
				v_in (24) & v_in (25) & v_in (26) & v_in (27) & v_in (28) & v_in (29) &
				v_in (28) & v_in (29) & v_in (30) & v_in (31) & v_in (32) & v_in (01)
		);
	end;
	
	-- Data Permutation (32b to 32b)
	-- 16  07  20  21
	-- 29  12  28  17
	-- 01  15  23  26
	-- 05  18  31  10
	-- 02  08  24  14
	-- 32  27  03  09
	-- 19  13  30  06
	-- 22  11  04  25
	function des_data_P (
		v_in : in std_logic_vector(1 to 32)
	)
	return std_logic_vector is
	begin
		return (	v_in (16) & v_in (07) & v_in (20) & v_in (21) &
				v_in (29) & v_in (12) & v_in (28) & v_in (17) &
				v_in (01) & v_in (15) & v_in (23) & v_in (26) &
				v_in (05) & v_in (18) & v_in (31) & v_in (10) &
				v_in (02) & v_in (08) & v_in (24) & v_in (14) &
				v_in (32) & v_in (27) & v_in (03) & v_in (09) &
				v_in (19) & v_in (13) & v_in (30) & v_in (06) &
				v_in (22) & v_in (11) & v_in (04) & v_in (25)
		);
	end;

	-- S1 (6b to 4b)
	function des_data_S1 (
		v_in : in std_logic_vector(1 to 6)
	)
	return std_logic_vector is
	begin
		case v_in is				
			when "000000" 	=> return "1110";
			when "000010" 	=> return "0100";
			when "000100" 	=> return "1101";
			when "000110" 	=> return "0001";
			when "001000" 	=> return "0010";
			when "001010" 	=> return "1111";
			when "001100" 	=> return "1011";
			when "001110" 	=> return "1000";
			when "010000" 	=> return "0011";
			when "010010" 	=> return "1010";
			when "010100" 	=> return "0110";
			when "010110" 	=> return "1100";
			when "011000" 	=> return "0101";
			when "011010" 	=> return "1001";
			when "011100" 	=> return "0000";
			when "011110" 	=> return "0111";
			when "000001" 	=> return "0000";
			when "000011" 	=> return "1111";
			when "000101" 	=> return "0111";
			when "000111" 	=> return "0100";
			when "001001" 	=> return "1110";
			when "001011" 	=> return "0010";
			when "001101" 	=> return "1101";
			when "001111" 	=> return "0001";
			when "010001" 	=> return "1010";
			when "010011" 	=> return "0110";
			when "010101" 	=> return "1100";
			when "010111" 	=> return "1011";
			when "011001" 	=> return "1001";
			when "011011" 	=> return "0101";
			when "011101" 	=> return "0011";
			when "011111" 	=> return "1000";
			when "100000" 	=> return "0100";
			when "100010" 	=> return "0001";
			when "100100" 	=> return "1110";
			when "100110" 	=> return "1000";
			when "101000" 	=> return "1101";
			when "101010" 	=> return "0110";
			when "101100" 	=> return "0010";
			when "101110" 	=> return "1011";
			when "110000" 	=> return "1111";
			when "110010" 	=> return "1100";
			when "110100" 	=> return "1001";
			when "110110" 	=> return "0111";
			when "111000" 	=> return "0011";
			when "111010" 	=> return "1010";
			when "111100" 	=> return "0101";
			when "111110" 	=> return "0000";
			when "100001" 	=> return "1111";
			when "100011" 	=> return "1100";
			when "100101" 	=> return "1000";
			when "100111" 	=> return "0010";
			when "101001" 	=> return "0100";
			when "101011" 	=> return "1001";
			when "101101" 	=> return "0001";
			when "101111" 	=> return "0111";
			when "110001" 	=> return "0101";
			when "110011" 	=> return "1011";
			when "110101" 	=> return "0011";
			when "110111" 	=> return "1110";
			when "111001" 	=> return "1010";
			when "111011" 	=> return "0000";
			when "111101" 	=> return "0110";
			when "111111" 	=> return "1101";
			when  others 	=> return "1101";
		end case;
	end;
	
	-- S2 (6b to 4b)
	function des_data_S2 (
		v_in : in std_logic_vector(1 to 6)
	)
	return std_logic_vector is
	begin
		case v_in is				
			when "000000" 	=> return "1111";
			when "000010" 	=> return "0001";
			when "000100" 	=> return "1000";
			when "000110" 	=> return "1110";
			when "001000" 	=> return "0110";
			when "001010" 	=> return "1011";
			when "001100" 	=> return "0011";
			when "001110" 	=> return "0100";
			when "010000" 	=> return "1001";
			when "010010" 	=> return "0111";
			when "010100" 	=> return "0010";
			when "010110" 	=> return "1101";
			when "011000" 	=> return "1100";
			when "011010" 	=> return "0000";
			when "011100" 	=> return "0101";
			when "011110" 	=> return "1010";
			when "000001" 	=> return "0011";
			when "000011" 	=> return "1101";
			when "000101" 	=> return "0100";
			when "000111" 	=> return "0111";
			when "001001" 	=> return "1111";
			when "001011" 	=> return "0010";
			when "001101" 	=> return "1000";
			when "001111" 	=> return "1110";
			when "010001" 	=> return "1100";
			when "010011" 	=> return "0000";
			when "010101" 	=> return "0001";
			when "010111" 	=> return "1010";
			when "011001" 	=> return "0110";
			when "011011" 	=> return "1001";
			when "011101" 	=> return "1011";
			when "011111" 	=> return "0101";
			when "100000" 	=> return "0000";
			when "100010" 	=> return "1110";
			when "100100" 	=> return "0111";
			when "100110" 	=> return "1011";
			when "101000" 	=> return "1010";
			when "101010" 	=> return "0100";
			when "101100" 	=> return "1101";
			when "101110" 	=> return "0001";
			when "110000" 	=> return "0101";
			when "110010" 	=> return "1000";
			when "110100" 	=> return "1100";
			when "110110" 	=> return "0110";
			when "111000" 	=> return "1001";
			when "111010" 	=> return "0011";
			when "111100" 	=> return "0010";
			when "111110" 	=> return "1111";
			when "100001" 	=> return "1101";
			when "100011" 	=> return "1000";
			when "100101" 	=> return "1010";
			when "100111" 	=> return "0001";
			when "101001" 	=> return "0011";
			when "101011" 	=> return "1111";
			when "101101" 	=> return "0100";
			when "101111" 	=> return "0010";
			when "110001" 	=> return "1011";
			when "110011" 	=> return "0110";
			when "110101" 	=> return "0111";
			when "110111" 	=> return "1100";
			when "111001" 	=> return "0000";
			when "111011" 	=> return "0101";
			when "111101" 	=> return "1110";
			when "111111" 	=> return "1001";
			when  others 	=> return "1001";
		end case;
	end;
	
	-- S3 (6b to 4b)
	function des_data_S3 (
		v_in : in std_logic_vector(1 to 6)
	)
	return std_logic_vector is
	begin
		case v_in is				
			when "000000" 	=> return "1010";
			when "000010" 	=> return "0000";
			when "000100" 	=> return "1001";
			when "000110" 	=> return "1110";
			when "001000" 	=> return "0110";
			when "001010" 	=> return "0011";
			when "001100" 	=> return "1111";
			when "001110" 	=> return "0101";
			when "010000" 	=> return "0001";
			when "010010" 	=> return "1101";
			when "010100" 	=> return "1100";
			when "010110" 	=> return "0111";
			when "011000" 	=> return "1011";
			when "011010" 	=> return "0100";
			when "011100" 	=> return "0010";
			when "011110" 	=> return "1000";
			when "000001" 	=> return "1101";
			when "000011" 	=> return "0111";
			when "000101" 	=> return "0000";
			when "000111" 	=> return "1001";
			when "001001" 	=> return "0011";
			when "001011" 	=> return "0100";
			when "001101" 	=> return "0110";
			when "001111" 	=> return "1010";
			when "010001" 	=> return "0010";
			when "010011" 	=> return "1000";
			when "010101" 	=> return "0101";
			when "010111" 	=> return "1110";
			when "011001" 	=> return "1100";
			when "011011" 	=> return "1011";
			when "011101" 	=> return "1111";
			when "011111" 	=> return "0001";
			when "100000" 	=> return "1101";
			when "100010" 	=> return "0110";
			when "100100" 	=> return "0100";
			when "100110" 	=> return "1001";
			when "101000" 	=> return "1000";
			when "101010" 	=> return "1111";
			when "101100" 	=> return "0011";
			when "101110" 	=> return "0000";
			when "110000" 	=> return "1011";
			when "110010" 	=> return "0001";
			when "110100" 	=> return "0010";
			when "110110" 	=> return "1100";
			when "111000" 	=> return "0101";
			when "111010" 	=> return "1010";
			when "111100" 	=> return "1110";
			when "111110" 	=> return "0111";
			when "100001" 	=> return "0001";
			when "100011" 	=> return "1010";
			when "100101" 	=> return "1101";
			when "100111" 	=> return "0000";
			when "101001" 	=> return "0110";
			when "101011" 	=> return "1001";
			when "101101" 	=> return "1000";
			when "101111" 	=> return "0111";
			when "110001" 	=> return "0100";
			when "110011" 	=> return "1111";
			when "110101" 	=> return "1110";
			when "110111" 	=> return "0011";
			when "111001" 	=> return "1011";
			when "111011" 	=> return "0101";
			when "111101" 	=> return "0010";
			when "111111" 	=> return "1100";
			when  others 	=> return "1100";
		end case;
	end;
	
	-- S4 (6b to 4b)
	function des_data_S4 (
		v_in : in std_logic_vector(1 to 6)
	)
	return std_logic_vector is
	begin
		case v_in is				
			when "000000" 	=> return "0111";
			when "000010" 	=> return "1101";
			when "000100" 	=> return "1110";
			when "000110" 	=> return "0011";
			when "001000" 	=> return "0000";
			when "001010" 	=> return "0110";
			when "001100" 	=> return "1001";
			when "001110" 	=> return "1010";
			when "010000" 	=> return "0001";
			when "010010" 	=> return "0010";
			when "010100" 	=> return "1000";
			when "010110" 	=> return "0101";
			when "011000" 	=> return "1011";
			when "011010" 	=> return "1100";
			when "011100" 	=> return "0100";
			when "011110" 	=> return "1111";
			when "000001" 	=> return "1101";
			when "000011" 	=> return "1000";
			when "000101" 	=> return "1011";
			when "000111" 	=> return "0101";
			when "001001" 	=> return "0110";
			when "001011" 	=> return "1111";
			when "001101" 	=> return "0000";
			when "001111" 	=> return "0011";
			when "010001" 	=> return "0100";
			when "010011" 	=> return "0111";
			when "010101" 	=> return "0010";
			when "010111" 	=> return "1100";
			when "011001" 	=> return "0001";
			when "011011" 	=> return "1010";
			when "011101" 	=> return "1110";
			when "011111" 	=> return "1001";
			when "100000" 	=> return "1010";
			when "100010" 	=> return "0110";
			when "100100" 	=> return "1001";
			when "100110" 	=> return "0000";
			when "101000" 	=> return "1100";
			when "101010" 	=> return "1011";
			when "101100" 	=> return "0111";
			when "101110" 	=> return "1101";
			when "110000" 	=> return "1111";
			when "110010" 	=> return "0001";
			when "110100" 	=> return "0011";
			when "110110" 	=> return "1110";
			when "111000" 	=> return "0101";
			when "111010" 	=> return "0010";
			when "111100" 	=> return "1000";
			when "111110" 	=> return "0100";
			when "100001" 	=> return "0011";
			when "100011" 	=> return "1111";
			when "100101" 	=> return "0000";
			when "100111" 	=> return "0110";
			when "101001" 	=> return "1010";
			when "101011" 	=> return "0001";
			when "101101" 	=> return "1101";
			when "101111" 	=> return "1000";
			when "110001" 	=> return "1001";
			when "110011" 	=> return "0100";
			when "110101" 	=> return "0101";
			when "110111" 	=> return "1011";
			when "111001" 	=> return "1100";
			when "111011" 	=> return "0111";
			when "111101" 	=> return "0010";
			when "111111" 	=> return "1110";
			when  others 	=> return "1110";
		end case;
	end;
	
	-- S5 (6b to 4b)
	function des_data_S5 (
		v_in : in std_logic_vector(1 to 6)
	)
	return std_logic_vector is
	begin
		case v_in is				
			when "000000" 	=> return "0010";
			when "000010" 	=> return "1100";
			when "000100" 	=> return "0100";
			when "000110" 	=> return "0001";
			when "001000" 	=> return "0111";
			when "001010" 	=> return "1010";
			when "001100" 	=> return "1011";
			when "001110" 	=> return "0110";
			when "010000" 	=> return "1000";
			when "010010" 	=> return "0101";
			when "010100" 	=> return "0011";
			when "010110" 	=> return "1111";
			when "011000" 	=> return "1101";
			when "011010" 	=> return "0000";
			when "011100" 	=> return "1110";
			when "011110" 	=> return "1001";
			when "000001" 	=> return "1110";
			when "000011" 	=> return "1011";
			when "000101" 	=> return "0010";
			when "000111" 	=> return "1100";
			when "001001" 	=> return "0100";
			when "001011" 	=> return "0111";
			when "001101" 	=> return "1101";
			when "001111" 	=> return "0001";
			when "010001" 	=> return "0101";
			when "010011" 	=> return "0000";
			when "010101" 	=> return "1111";
			when "010111" 	=> return "1010";
			when "011001" 	=> return "0011";
			when "011011" 	=> return "1001";
			when "011101" 	=> return "1000";
			when "011111" 	=> return "0110";
			when "100000" 	=> return "0100";
			when "100010" 	=> return "0010";
			when "100100" 	=> return "0001";
			when "100110" 	=> return "1011";
			when "101000" 	=> return "1010";
			when "101010" 	=> return "1101";
			when "101100" 	=> return "0111";
			when "101110" 	=> return "1000";
			when "110000" 	=> return "1111";
			when "110010" 	=> return "1001";
			when "110100" 	=> return "1100";
			when "110110" 	=> return "0101";
			when "111000" 	=> return "0110";
			when "111010" 	=> return "0011";
			when "111100" 	=> return "0000";
			when "111110" 	=> return "1110";
			when "100001" 	=> return "1011";
			when "100011" 	=> return "1000";
			when "100101" 	=> return "1100";
			when "100111" 	=> return "0111";
			when "101001" 	=> return "0001";
			when "101011" 	=> return "1110";
			when "101101" 	=> return "0010";
			when "101111" 	=> return "1101";
			when "110001" 	=> return "0110";
			when "110011" 	=> return "1111";
			when "110101" 	=> return "0000";
			when "110111" 	=> return "1001";
			when "111001" 	=> return "1010";
			when "111011" 	=> return "0100";
			when "111101" 	=> return "0101";
			when "111111" 	=> return "0011";
			when  others 	=> return "0011";
		end case;
	end;
	
	-- S6 (6b to 4b)
	function des_data_S6 (
		v_in : in std_logic_vector(1 to 6)
	)
	return std_logic_vector is
	begin
		case v_in is				
			when "000000" 	=> return "1100";
			when "000010" 	=> return "0001";
			when "000100" 	=> return "1010";
			when "000110" 	=> return "1111";
			when "001000" 	=> return "1001";
			when "001010" 	=> return "0010";
			when "001100" 	=> return "0110";
			when "001110" 	=> return "1000";
			when "010000" 	=> return "0000";
			when "010010" 	=> return "1101";
			when "010100" 	=> return "0011";
			when "010110" 	=> return "0100";
			when "011000" 	=> return "1110";
			when "011010" 	=> return "0111";
			when "011100" 	=> return "0101";
			when "011110" 	=> return "1011";
			when "000001" 	=> return "1010";
			when "000011" 	=> return "1111";
			when "000101" 	=> return "0100";
			when "000111" 	=> return "0010";
			when "001001" 	=> return "0111";
			when "001011" 	=> return "1100";
			when "001101" 	=> return "1001";
			when "001111" 	=> return "0101";
			when "010001" 	=> return "0110";
			when "010011" 	=> return "0001";
			when "010101" 	=> return "1101";
			when "010111" 	=> return "1110";
			when "011001" 	=> return "0000";
			when "011011" 	=> return "1011";
			when "011101" 	=> return "0011";
			when "011111" 	=> return "1000";
			when "100000" 	=> return "1001";
			when "100010" 	=> return "1110";
			when "100100" 	=> return "1111";
			when "100110" 	=> return "0101";
			when "101000" 	=> return "0010";
			when "101010" 	=> return "1000";
			when "101100" 	=> return "1100";
			when "101110" 	=> return "0011";
			when "110000" 	=> return "0111";
			when "110010" 	=> return "0000";
			when "110100" 	=> return "0100";
			when "110110" 	=> return "1010";
			when "111000" 	=> return "0001";
			when "111010" 	=> return "1101";
			when "111100" 	=> return "1011";
			when "111110" 	=> return "0110";
			when "100001" 	=> return "0100";
			when "100011" 	=> return "0011";
			when "100101" 	=> return "0010";
			when "100111" 	=> return "1100";
			when "101001" 	=> return "1001";
			when "101011" 	=> return "0101";
			when "101101" 	=> return "1111";
			when "101111" 	=> return "1010";
			when "110001" 	=> return "1011";
			when "110011" 	=> return "1110";
			when "110101" 	=> return "0001";
			when "110111" 	=> return "0111";
			when "111001" 	=> return "0110";
			when "111011" 	=> return "0000";
			when "111101" 	=> return "1000";
			when "111111" 	=> return "1101";
			when  others 	=> return "1101";
		end case;
	end;
	
	-- S7 (6b to 4b)
	function des_data_S7 (
		v_in : in std_logic_vector(1 to 6)
	)
	return std_logic_vector is
	begin
		case v_in is				
			when "000000" 	=> return  "0100";
			when "000010" 	=> return "1011";
			when "000100" 	=> return "0010";
			when "000110" 	=> return "1110";
			when "001000" 	=> return "1111";
			when "001010" 	=> return "0000";
			when "001100" 	=> return "1000";
			when "001110" 	=> return "1101";
			when "010000" 	=> return "0011";
			when "010010" 	=> return "1100";
			when "010100" 	=> return "1001";
			when "010110" 	=> return "0111";
			when "011000" 	=> return "0101";
			when "011010" 	=> return "1010";
			when "011100" 	=> return "0110";
			when "011110" 	=> return "0001";
			when "000001" 	=> return "1101";
			when "000011" 	=> return "0000";
			when "000101" 	=> return "1011";
			when "000111" 	=> return "0111";
			when "001001" 	=> return "0100";
			when "001011" 	=> return "1001";
			when "001101" 	=> return "0001";
			when "001111" 	=> return "1010";
			when "010001" 	=> return "1110";
			when "010011" 	=> return "0011";
			when "010101" 	=> return "0101";
			when "010111" 	=> return "1100";
			when "011001" 	=> return "0010";
			when "011011" 	=> return "1111";
			when "011101" 	=> return "1000";
			when "011111" 	=> return "0110";
			when "100000" 	=> return "0001";
			when "100010" 	=> return "0100";
			when "100100" 	=> return "1011";
			when "100110" 	=> return "1101";
			when "101000" 	=> return "1100";
			when "101010" 	=> return "0011";
			when "101100" 	=> return "0111";
			when "101110" 	=> return "1110";
			when "110000" 	=> return "1010";
			when "110010" 	=> return "1111";
			when "110100" 	=> return "0110";
			when "110110" 	=> return "1000";
			when "111000" 	=> return "0000";
			when "111010" 	=> return "0101";
			when "111100" 	=> return "1001";
			when "111110" 	=> return "0010";
			when "100001" 	=> return "0110";
			when "100011" 	=> return "1011";
			when "100101" 	=> return "1101";
			when "100111" 	=> return "1000";
			when "101001" 	=> return "0001";
			when "101011" 	=> return "0100";
			when "101101" 	=> return "1010";
			when "101111" 	=> return "0111";
			when "110001" 	=> return "1001";
			when "110011" 	=> return "0101";
			when "110101" 	=> return "0000";
			when "110111" 	=> return "1111";
			when "111001" 	=> return "1110";
			when "111011" 	=> return "0010";
			when "111101" 	=> return "0011";
			when "111111" 	=> return "1100";
			when  others 	=> return "1100";
		end case;
	end;
	
	-- S8 (6b to 4b)
	function des_data_S8 (
		v_in : in std_logic_vector(1 to 6)
	)
	return std_logic_vector is
	begin
		case v_in is				
			when "000000" 	=> return "1101";
			when "000010" 	=> return "0010";
			when "000100" 	=> return "1000";
			when "000110" 	=> return "0100";
			when "001000" 	=> return "0110";
			when "001010" 	=> return "1111";
			when "001100" 	=> return "1011";
			when "001110" 	=> return "0001";
			when "010000" 	=> return "1010";
			when "010010" 	=> return "1001";
			when "010100" 	=> return "0011";
			when "010110" 	=> return "1110";
			when "011000" 	=> return "0101";
			when "011010" 	=> return "0000";
			when "011100" 	=> return "1100";
			when "011110" 	=> return "0111";
			when "000001" 	=> return "0001";
			when "000011" 	=> return "1111";
			when "000101" 	=> return "1101";
			when "000111" 	=> return "1000";
			when "001001" 	=> return "1010";
			when "001011" 	=> return "0011";
			when "001101" 	=> return "0111";
			when "001111" 	=> return "0100";
			when "010001" 	=> return "1100";
			when "010011" 	=> return "0101";
			when "010101" 	=> return "0110";
			when "010111" 	=> return "1011";
			when "011001" 	=> return "0000";
			when "011011" 	=> return "1110";
			when "011101" 	=> return "1001";
			when "011111" 	=> return "0010";
			when "100000" 	=> return "0111";
			when "100010" 	=> return "1011";
			when "100100" 	=> return "0100";
			when "100110" 	=> return "0001";
			when "101000" 	=> return "1001";
			when "101010" 	=> return "1100";
			when "101100" 	=> return "1110";
			when "101110" 	=> return "0010";
			when "110000" 	=> return "0000";
			when "110010" 	=> return "0110";
			when "110100" 	=> return "1010";
			when "110110" 	=> return "1101";
			when "111000" 	=> return "1111";
			when "111010" 	=> return "0011";
			when "111100" 	=> return "0101";
			when "111110" 	=> return "1000";
			when "100001" 	=> return "0010";
			when "100011" 	=> return "0001";
			when "100101" 	=> return "1110";
			when "100111" 	=> return "0111";
			when "101001" 	=> return "0100";
			when "101011" 	=> return "1010";
			when "101101" 	=> return "1000";
			when "101111" 	=> return "1101";
			when "110001" 	=> return "1111";
			when "110011" 	=> return "1100";
			when "110101" 	=> return "1001";
			when "110111" 	=> return "0000";
			when "111001" 	=> return "0011";
			when "111011" 	=> return "0101";
			when "111101" 	=> return "0110";
			when "111111" 	=> return "1011";
			when  others 	=> return "1011";
		end case;
	end;
	
	-- Final Permutation IP^-1 (64b to 64b)
	-- 40    08   48    16    56   24    64   32
	-- 39    07   47    15    55   23    63   31
	-- 38    06   46    14    54   22    62   30
	-- 37    05   45    13    53   21    61   29
	-- 36    04   44    12    52   20    60   28
	-- 35    03   43    11    51   19    59   27
	-- 34    02   42    10    50   18    58   26
	-- 33    01   41    09    49   17    57   25
	function des_data_FP (
		v_in : in std_logic_vector(1 to 64)
	)
	return std_logic_vector is
	begin
		return (	v_in (40) & v_in (08) & v_in (48) & v_in (16) & v_in (56) & v_in (24) & v_in (64) & v_in (32) &
				v_in (39) & v_in (07) & v_in (47) & v_in (15) & v_in (55) & v_in (23) & v_in (63) & v_in (31) &
				v_in (38) & v_in (06) & v_in (46) & v_in (14) & v_in (54) & v_in (22) & v_in (62) & v_in (30) &
				v_in (37) & v_in (05) & v_in (45) & v_in (13) & v_in (53) & v_in (21) & v_in (61) & v_in (29) &
				v_in (36) & v_in (04) & v_in (44) & v_in (12) & v_in (52) & v_in (20) & v_in (60) & v_in (28) &
				v_in (35) & v_in (03) & v_in (43) & v_in (11) & v_in (51) & v_in (19) & v_in (59) & v_in (27) &
				v_in (34) & v_in (02) & v_in (42) & v_in (10) & v_in (50) & v_in (18) & v_in (58) & v_in (26) &
				v_in (33) & v_in (01) & v_in (41) & v_in (09) & v_in (49) & v_in (17) & v_in (57) & v_in (25) 
		);
	end;

	-- PC-1 (64b to 56b)
	-- 57   49    41   33    25    17   09
	-- 01   58    50   42    34    26   18
	-- 10   02    59   51    43    35   27
	-- 19   11    03   60    52    44   36
	-- 63   55    47   39    31    23   15
	-- 07   62    54   46    38    30   22
	-- 14   06    61   53    45    37   29
	-- 21   13    05   28    20    12   04
	function des_key_PC1 (
		v_in : in std_logic_vector(1 to 64)
	)
	return std_logic_vector is
	begin
		return (	v_in (57) & v_in (49) & v_in (41) & v_in (33) & v_in (25) & v_in (17) & v_in (09) & 
				v_in (01) & v_in (58) & v_in (50) & v_in (42) & v_in (34) & v_in (26) & v_in (18) & 
				v_in (10) & v_in (02) & v_in (59) & v_in (51) & v_in (43) & v_in (35) & v_in (27) & 
				v_in (19) & v_in (11) & v_in (03) & v_in (60) & v_in (52) & v_in (44) & v_in (36) & 
				v_in (63) & v_in (55) & v_in (47) & v_in (39) & v_in (31) & v_in (23) & v_in (15) & 
				v_in (07) & v_in (62) & v_in (54) & v_in (46) & v_in (38) & v_in (30) & v_in (22) & 
				v_in (14) & v_in (06) & v_in (61) & v_in (53) & v_in (45) & v_in (37) & v_in (29) & 
				v_in (21) & v_in (13) & v_in (05) & v_in (28) & v_in (20) & v_in (12) & v_in (04)
		);
	end;
	
	-- PC-2 (56b to 48b)
	-- 14    17   11    24    01   05
	-- 03    28   15    06    21   10
	-- 23    19   12    04    26   08
	-- 16    07   27    20    13   02
	-- 41    52   31    37    47   55
	-- 30    40   51    45    33   48
	-- 44    49   39    56    34   53
	-- 46    42   50    36    29   32                
	function des_key_PC2 (
		v_in : in std_logic_vector(1 to 56)
	)
	return std_logic_vector is
	begin
		return (	v_in (14) & v_in (17) & v_in (11) & v_in (24) & v_in (01) & v_in (05) &
				v_in (03) & v_in (28) & v_in (15) & v_in (06) & v_in (21) & v_in (10) &
				v_in (23) & v_in (19) & v_in (12) & v_in (04) & v_in (26) & v_in (08) &
				v_in (16) & v_in (07) & v_in (27) & v_in (20) & v_in (13) & v_in (02) &
				v_in (41) & v_in (52) & v_in (31) & v_in (37) & v_in (47) & v_in (55) &
				v_in (30) & v_in (40) & v_in (51) & v_in (45) & v_in (33) & v_in (48) &
				v_in (44) & v_in (49) & v_in (39) & v_in (56) & v_in (34) & v_in (53) &
				v_in (46) & v_in (42) & v_in (50) & v_in (36) & v_in (29) & v_in (32) 
		);
	end;
	
	-- des_key_left_shift
	function des_key_left_shift (
		v_in 	 : in std_logic_vector;
		nb_in : in integer
	)
	return std_logic_vector is
	begin
		return (	std_logic_vector(rotate_left(unsigned(v_in), nb_in))	  );
	end;
	
	-- des_key_right_shift
	function des_key_right_shift (
		v_in 	 : in std_logic_vector;
		nb_in : in integer
	)
	return std_logic_vector is
	begin
		return (	std_logic_vector(rotate_right(unsigned(v_in), nb_in))	  );
	end;

end package body des_package;
