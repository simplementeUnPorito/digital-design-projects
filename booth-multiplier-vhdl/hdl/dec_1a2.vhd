
LIBRARY 	ieee;
USE			ieee.std_logic_1164.all;
use work.mi_paquete.ALL;

ENTITY dec_1a2 IS

PORT
(
	s: in std_logic;
	sal: out std_logic_vector(1 downto 0)
 );
END dec_1a2;

ARCHITECTURE xd OF dec_1a2 IS
	
BEGIN
	process(s)
	begin
        case s is
           when '0' =>
               sal <= "01";
           when '1' =>
               sal <= "10";
           when others =>
                null;
        end case;
	end process;
	
END xd;