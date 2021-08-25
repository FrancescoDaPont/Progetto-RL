
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.all;

entity project_reti_logiche is
port (
i_clk : in std_logic;
i_rst : in std_logic;
i_start : in std_logic;
i_data : in std_logic_vector(7 downto 0); --pixel da attualizzare
o_address : out std_logic_vector(15 downto 0); --indirizzo di memoria in cui mettere pixel attualizzato
o_done : out std_logic;
o_en : out std_logic;
o_we : out std_logic;
o_data : out std_logic_vector (7 downto 0) --pixel attualizzato
);
end project_reti_logiche;

--essendo l'entity project_reti_logiche in grado di processare solo un pixel alla volta, avrò bisogno di definire altre entità che coordinino la sequenza di pixel data

architecture Behavioral of project_reti_logiche is
signal temp_pixel : std_logic_vector (7 downto 0);
begin
  process(i_data, min_pixel, shift_lvl, o_data) --TEMP_PIXEL = (CURRENT_PIXEL_VALUE - MIN_PIXEL_VALUE) << SHIFT_LEVEL
  begin
    before_shift <= (i_data - min_pixel);
    temp_pixel <= before_shift*(2**(shift_lvl));

    if(temp_pixel <= '255') then --NEW_PIXEL_VALUE = MIN( 255 , TEMP_PIXEL)
      o_data <= temp_pixel;
    else
      o_data <= '255';
  end process;


end Behavioral;
