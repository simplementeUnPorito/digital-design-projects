-- contador.vhd

-- 	Se complementa con una descripcion Generica
--
LIBRARY 	ieee;
USE			ieee.std_logic_1164.all;
use work.mi_paquete.ALL;

ENTITY dec_3a8 IS

PORT
(
	s: in std_logic_vector(2 downto 0);
	en: in std_logic_vector(1 downto 0);
	sal: out std_logic_vector(7 downto 0)
 );
END dec_2a4;

ARCHITECTURE xd OF dec_3a8 IS
	
BEGIN
	process(s,en)
	begin
        if en = "11" then
         sal<=(others =>'0');
         case s is
           when "0000" =>
            sal(0)<='1';
           when "0001" =>
            sal(1)<='1';
           when "0010" =>
            sal(2)<='1';
           when "0011" =>
            sal(3)<='1';
           when "0100" =>
            sal(4)<='1';
           when "0101" =>
            sal(5)<='1';
           when "0110" =>
            sal(6)<='1';
           when "0111" =>
            sal(7)<='1';
           when "1000" =>
            sal(8)<='1';
           when "1001" =>
            sal(9)<='1';
           when "1010" =>
            sal(10)<='1';
           when "1011" =>
            sal(11)<='1';
           when "1100" =>
            sal(12)<='1';
           when "1101" =>
            sal(13)<='1';
           when "1110" =>
            sal(14)<='1';
           when "1111" =>
            sal(15)<='1';
        end case;
            
        else
           sal<="0000";
        end if;
	end process;
	
END xd;