-- contador.vhd

-- 	Se complementa con una descripcion Generica
--
LIBRARY 	ieee;
USE			ieee.std_logic_1164.all;
ENTITY contador IS
GENERIC
(
	MIN_COUNT : NATURAL := 0;
	MAX_COUNT : NATURAL := 3
);
PORT
(
	clk	: IN  STD_ULOGIC;		--	Reloj
	preset	: IN  STD_ULOGIC;   --	Iniciar la cuenta en MAX
	reset : in STD_LOGIC;       -- Iniciar la cuenta en MIN
	dec	: IN  STD_ULOGIC;		-- Decrementar la cuenta
	incr: IN  STD_ULOGIC;		-- Incrementar la cuenta
	Q	: OUT NATURAL RANGE MIN_COUNT to MAX_COUNT
 );
END contador;

ARCHITECTURE rtl OF contador IS
	
BEGIN
	PROCESS(clk)
		VARIABLE   cnt	: NATURAL RANGE MIN_COUNT to MAX_COUNT;
	BEGIN 
		IF(clk'EVENT AND clk='1') THEN
			IF (preset = '1') THEN
				cnt := MAX_COUNT;
		    ELSIF (reset = '1') THEN
		        cnt := MIN_COUNT;
			ELSIF (dec = '1' ) THEN
				IF cnt = MIN_COUNT THEN
					cnt := MAX_COUNT;
				ELSE
					cnt := cnt -1;
				END IF;
		    ELSIF (incr = '1' ) THEN
				IF cnt = MAX_COUNT THEN
					cnt := MIN_COUNT;
				ELSE
					cnt := cnt + 1;
				END IF;  
			END IF;
		END IF;
		-- Asignacion del conteo
		Q 	<= cnt;	
		
		
	END PROCESS;
	
END rtl;