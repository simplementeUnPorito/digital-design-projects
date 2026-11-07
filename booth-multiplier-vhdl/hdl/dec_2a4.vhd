-- contador.vhd

-- 	Se complementa con una descripcion Generica
--
LIBRARY 	ieee;
USE			ieee.std_logic_1164.all;
use work.mi_paquete.ALL;

ENTITY dec_2a4 IS

PORT
(
	s: in std_logic_vector(1 downto 0);
	sal: out std_logic_vector(3 downto 0)
 );
END dec_2a4;

ARCHITECTURE xd OF dec_2a4 IS
	
BEGIN
	process(s)
	begin
        case s is
           when "00" =>
               sal <= "0001";
           when "01" =>
               sal <= "0010";
           when "10" =>
               sal <= "0100";
           when "11" =>
               sal <= "1000";
            when others =>
                null;
        end case;
	end process;
	
END xd;