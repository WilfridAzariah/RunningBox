LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY top_level_vhd  IS 
	PORT( 
	    CLOCK_50   : IN STD_LOGIC;
	    SW         : IN STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	    sp         : IN STD_LOGIC;
	    RESET	   : IN STD_LOGIC;
	    pushatas   : IN STD_LOGIC;
	    VGA_R      : OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	    VGA_G      : OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	    VGA_B      : OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	    VGA_HS     : OUT STD_LOGIC;
	    VGA_VS     : OUT STD_LOGIC;
	    VGA_CLK    : OUT STD_LOGIC;
	    VGA_BLANK  : OUT STD_LOGIC;
	    GPIO_0     : OUT STD_LOGIC_VECTOR( 35 DOWNTO 0 );
	    LEDR       : OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	    
END top_level_vhd; 

ARCHITECTURE behavioral OF top_level_vhd  IS 
COMPONENT display_vhd  IS 
	PORT( 
	    i_clk           : IN STD_LOGIC;                                  
	    i_M_US          : IN STD_LOGIC;
	    i_K_US          : IN STD_LOGIC;
	    RESET			: IN STD_LOGIC;
	    sp              : IN STD_LOGIC;
	    pushataso		: IN STD_LOGIC;
	    VGA_R           : OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	    VGA_G           : OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	    VGA_B           : OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	    VGA_HS          : OUT STD_LOGIC;
	    VGA_VS          : OUT STD_LOGIC;
	    VGA_CLK         : OUT STD_LOGIC;
	    VGA_BLANK       : OUT STD_LOGIC;
	    poin			: OUT INTEGER);
END COMPONENT;

BEGIN 
module_vga : display_vhd 
   PORT MAP (
   i_clk                =>  CLOCK_50,  
   i_M_US               =>  M_US,  
   i_K_US               =>  K_US,  
   sp 					=>  sp,
   RESET				=>  RESET,
   pushataso			=>  pushatas,
   VGA_R                =>  VGA_R,  
   VGA_G                =>  VGA_G,  
   VGA_B                =>  VGA_B,
   VGA_HS               =>  VGA_HS,  
   VGA_VS               =>  VGA_VS,
   VGA_CLK              =>  VGA_CLK,
   VGA_BLANK            =>  VGA_BLANK,
   poin					=>	poin
);

END behavioral; 