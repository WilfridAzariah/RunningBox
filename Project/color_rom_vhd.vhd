LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
 
ENTITY color_rom_vhd  IS 
	PORT( 
	    clockfpga 		: IN STD_LOGIC;
	    RESET			: IN STD_LOGIC;
	    sp				: IN STD_LOGIC;
	    i_M_US          : IN STD_LOGIC;
	    i_K_US          : IN STD_LOGIC;
	    pushatas		: IN STD_LOGIC;
	    i_pixel_column  : IN STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	    i_pixel_row     : IN STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	    o_red           : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	    o_green         : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	    o_blue          : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	    o_poin			: OUT INTEGER);
END color_rom_vhd; 

ARCHITECTURE behavioral OF color_rom_vhd  IS 
	SIGNAL MUNCUL_KOTAK:  STD_LOGIC; 
	SIGNAL MUNCUL_RINTANGAN:  STD_LOGIC;
	SIGNAL MUNCUL_ALAS:  STD_LOGIC;
	SIGNAL MUNCUL_KALAH : STD_LOGIC;
	SIGNAL MUNCUL_POIN : STD_LOGIC;
BEGIN 

	PROCESS(clockfpga, i_pixel_row,i_pixel_column, MUNCUL_KOTAK, 
	MUNCUL_RINTANGAN, MUNCUL_ALAS, MUNCUL_KALAH, RESET)
		--Kotak
		VARIABLE ATAS_KOTAK   : INTEGER := 149 ;
		VARIABLE BAWAH_KOTAK  : INTEGER := 199;
		VARIABLE KIRI_KOTAK  : INTEGER:= 10;
		VARIABLE KANAN_KOTAK : INTEGER := 60;
		--Rintangan
		CONSTANT Patokan_Atas_Rintangan : INTEGER := 250;
		VARIABLE ATAS_RINTANGAN   : INTEGER := 190;
		CONSTANT BAWAH_RINTANGAN   : INTEGER := 210;
		VARIABLE KIRI_RINTANGAN  : INTEGER:= 500;
		VARIABLE KANAN_RINTANGAN : INTEGER := 580;
		--Alas
		CONSTANT ATAS_ALAS   : INTEGER := 200;
		CONSTANT BAWAH_ALAS   : INTEGER := 480;
		VARIABLE KIRI_ALAS  : INTEGER:= 0;
		VARIABLE KANAN_ALAS : INTEGER := 640;
		VARIABLE count : INTEGER := 0;
		--Batas
		CONSTANT kiri : INTEGER := 0;
		CONSTANT kanan : INTEGER := 639;
		CONSTANT atas : INTEGER := 0;
		CONSTANT bawah : INTEGER := 480;
		--Poin
		VARIABLE ATAS_POIN   : INTEGER := 1 ;
		VARIABLE BAWAH_POIN  : INTEGER := 50;
		VARIABLE KIRI_POIN  : INTEGER:= 1;
		VARIABLE KANAN_POIN : INTEGER := 2;
		-- Variabel loncat
		variable speed : INTEGER := 1;
		variable con : INTEGER := 0;
		-- count adalah variabel penghitung clockfpga yang berlalu
		-- max adalah konstanta nilai maksimum count dalam 1 detik
		constant max : INTEGER := 4999999;
		variable count : INTEGER := 0;
		-- Variabel mengubah tinggi Rintangan  
		VARIABLE tinggiRintangan : INTEGER := 0;
		VARIABLE conR : INTEGER :=0;
		-- STATE
		VARIABLE loncat : INTEGER := 0;
		VARIABLE KALAH : INTEGER := 0;
	BEGIN
		IF (clockfpga'event and clockfpga = '1') THEN
		-- FSM
		-- Program mengecek input STATE RESET	
			IF RESET='1' THEN
			-- Jika reset = 1, maka permainan tidak dimulai
			-- Kotak Player tidak bisa bergerak 
				ATAS_KOTAK   := 149 ;
				BAWAH_KOTAK  := 199;
				KIRI_KOTAK  := 10;
				KANAN_KOTAK := 60;
				conR:=0;
			END IF;
			-- mendelay pergerakan pada visual
			IF count < max THEN
				count := count + 1;
				-- jika count belum mencapai max (count masih di interval 0 sampai
				-- 9999998), count akan terus ditambah 1			
			ELSE
				count := 0;
				-- RINTANGAN
				-- mengubah tinggi RINTANGAN
				conR := conR + 1;
				-- Mereset counter 
				if conR >20 then 
				   conR := 0 ;	
				-- Algoritma pseudorandom
					elsif conR > 10 then 
						ATAS_RINTANGAN:= ATAS_RINTANGAN- 3;		
					else 
						ATAS_RINTANGAN:= ATAS_KOTAK + 5;
				end if;
				-- Pergerakan RINTANGAN
				KIRI_RINTANGAN := KIRI_RINTANGAN - 10 - (KANAN_POIN/5);
				KANAN_RINTANGAN := KANAN_RINTANGAN - 10 - (KANAN_POIN/5);
		
				--Pergerakan kotak Player
				IF pushatas = '0' THEN
					loncat := 1;
				end if;
				-- Menentukan faktor kecepatan LONCAT
				if sp = '1' then
						speed := 15;
					else 
						speed := 10;
				end if;
				-- STATE LONCAT
				if loncat = 1 then
					-- counter loncat
					con := con + 1;
					if con >20 then 
						-- setelah counter habis, reset counter
						-- state loncat dikembailkan 0 secara otomatis
						-- setelah counter habis
							con := 0 ; 
							LONCAT := 0;
						elsif con > 10 then 
						-- kotak naik 
							ATAS_KOTAK := ATAS_KOTAK + speed;
							BAWAH_KOTAK := BAWAH_KOTAK + speed;
						else 
						-- lalu turun
							ATAS_KOTAK := ATAS_KOTAK - speed;
							BAWAH_KOTAK := BAWAH_KOTAK - speed;
					end if;			
				END IF;
				
				--BATAS KOTAK PLAYER
				--Batas, jika melewati, akan tetap tertahan 
				IF BAWAH_KOTAK > bawah THEN
					ATAS_KOTAK := bawah-50;
					BAWAH_KOTAK := bawah;
				END IF;
				IF ATAS_KOTAK < atas THEN
					ATAS_KOTAK := atas;
					BAWAH_KOTAK := atas + 50;
				END IF;
				IF KANAN_KOTAK < kiri THEN
					ATAS_KOTAK := kiri;
					BAWAH_KOTAK := kiri + 50;
				END IF;
				IF KIRI_KOTAK > kanan THEN
					ATAS_KOTAK := kanan - 50;
					BAWAH_KOTAK := kanan ;
				END IF;
				
				-- BATAS RINTANGAN
				-- batas tinggi rintangan, agar tinggi rintangan tidak
				-- lebih tinggi dari tinggi maksimal kotak meloncat
				IF ATAS_RINTANGAN < 140 THEN
					ATAS_RINTANGAN := 190;
				END IF;
				-- batas agar rintangan kembali pada posisi semula saat
				-- sudah sampai pinggir kiri, lalu poin bertambah
				IF KIRI_RINTANGAN < kiri THEN
					KIRI_RINTANGAN := kanan - 50;
					KANAN_RINTANGAN := kanan;
					KANAN_POIN:= KANAN_POIN + 10;
				END IF;
				
				-- Mekanisme Kena Rintangan
				IF (KANAN_KOTAK>=KIRI_RINTANGAN)  AND (BAWAH_KOTAK>=ATAS_RINTANGAN) THEN
					-- screen KALAH 
					KANAN_KOTAK := kanan;
					BAWAH_KOTAK := bawah;
					KIRI_KOTAK := kiri;
					ATAS_KOTAK := atas;
					KANAN_POIN:= 2;
					KIRI_RINTANGAN:= 500;
					KANAN_RINTANGAN:= 580;
				END IF;
			END IF;
			-- jika poin full, reset kembali ke awal game
			IF KANAN_POIN>=640 THEN
				KANAN_KOTAK := kanan;
				BAWAH_KOTAK := bawah;
				KIRI_KOTAK := kiri;
				ATAS_KOTAK := atas;
				KANAN_POIN:= 2;
				KIRI_RINTANGAN:= 500;
				KANAN_RINTANGAN:= 580;
			END IF;	
			
			-- DATA PATH 
			-- pixelrow dan colomn
			-- KOTAK PLAYER
			IF ((i_pixel_row > ATAS_KOTAK)  AND (i_pixel_row < BAWAH_KOTAK) ) 
			AND ((i_pixel_column >= KIRI_KOTAK)  AND (i_pixel_column < KANAN_KOTAK)  ) THEN 
					MUNCUL_KOTAK <=  '1';
				ELSE  MUNCUL_KOTAK <=  '0';
			END IF;
			-- RINTANGAN
			IF ((i_pixel_row > ATAS_RINTANGAN)  AND (i_pixel_row < BAWAH_RINTANGAN)) 
			AND ((i_pixel_column >= KIRI_RINTANGAN)  AND (i_pixel_column < KANAN_RINTANGAN) ) THEN 
					MUNCUL_RINTANGAN <=  '1';
				ELSE  MUNCUL_RINTANGAN <=  '0';
			END IF;
			-- ALAS
			IF ((i_pixel_row > ATAS_ALAS)  AND (i_pixel_row < BAWAH_ALAS)) 
            AND ((i_pixel_column >= KIRI_ALAS)  AND (i_pixel_column < KANAN_ALAS)  ) THEN 
                    MUNCUL_ALAS <=  '1';
				ELSE  MUNCUL_ALAS <=  '0';
			END IF;
			-- POIN
			IF ((i_pixel_row > ATAS_POIN)  AND (i_pixel_row < BAWAH_POIN)) 
			AND ((i_pixel_column >= KIRI_POIN)  AND (i_pixel_column < KANAN_POIN)  ) THEN 
					MUNCUL_POIN <=  '1';
				ELSE  MUNCUL_POIN <=  '0';
			END IF;
			
			-- KODE WARNA
			-- KOTAK PLAYER
			IF (MUNCUL_KOTAK = '1'  ) THEN  
				o_red <= X"FF"; o_green <= X"00"; o_blue <= X"00";
			-- RINTANGAN
			ELSIF (MUNCUL_RINTANGAN = '1' ) THEN  
				o_red <= X"00"; o_green <= X"ff"; o_blue <= X"00";
			-- ALAS
			ELSIF (MUNCUL_ALAS = '1' ) THEN  
				o_red <= X"FF"; o_green <= X"ff"; o_blue <= X"00";
			-- POIN
			ELSIF (MUNCUL_POIN = '1' ) THEN  
				o_red <= X"00"; o_green <= X"00"; o_blue <= X"FF";
			-- Selain itu, beri warna putih
			ELSE  o_red <= X"ff"; o_green <= X"ff"; o_blue <= X"ff";
			END IF;
		END IF;						  
	END PROCESS;	
	END behavioral; 


--------------------------------------------------------------------------------------------------------------------------------------------
-- edit :
-- tambah variabel kalah
-- pada saat awal, fsm akan mengecek state kalah terlebih dahulu, jika kalah, tempat kotak akan menjadi hitam,	
-- tambah variable MUNCUL_KALAH
-- kalau muncul kalah, screen merah
--
--
--
--
