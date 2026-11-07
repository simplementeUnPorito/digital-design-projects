-- contador.vhd

-- 	Se complementa con una descripcion Generica
--
LIBRARY 	ieee;
USE			ieee.std_logic_1164.all;
use work.mi_paquete.ALL;

ENTITY mux_2a1 IS

PORT
(
	s: in std_logic;
	input: in std_logic_vector(1 downto 0);
	sal: out std_logic
 );
END mux_2a1;

ARCHITECTURE xd OF mux_2a1 IS
	
BEGIN
	process(s,input)
	begin
        case s is
           when '0' =>
                sal <= input(0);
           when '1' =>
                sal <= input(1);
           when others =>
                null;
        end case;
	end process;
	
END xd;