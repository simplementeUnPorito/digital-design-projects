-- contador.vhd

-- 	Se complementa con una descripcion Generica
--
LIBRARY 	ieee;
USE			ieee.std_logic_1164.all;
use work.mi_paquete.ALL;

ENTITY mux_2a1_8bits IS

PORT
(
	s: in std_logic;
	input: in std_logic_matrix(1 downto 0);
	sal: out std_logic_vector(regLen-1 downto 0)
 );
END mux_2a1_8bits;

ARCHITECTURE xd OF mux_2a1_8bits IS
	component mux_2a1 IS

    PORT
    (
        s: in std_logic;
        input: in std_logic_vector(1 downto 0);
        sal: out std_logic
     );
    END component;
BEGIN
	Cascada:for i in regLen - 1 downto 0 generate
	   mux_generate:mux_2a1 port MAP(
	   s => s,
	   input(1) => input(1)(i),
	   input(0) => input(0)(i),
	   sal =>sal(i)
	   );
	end generate;
	
END xd;