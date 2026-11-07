
--
LIBRARY     ieee;
USE     ieee.std_logic_1164.all;
use work.mi_paquete.ALL;


ENTITY registro IS
GENERIC (   N : NATURAL := 4 );   -- Numero de bits del registro
PORT
(
    clk,Sin,eOut: IN  STD_LOGIC;                
    ctrl   : IN STD_LOGIC_VECTOR(2 downto 0);
    
    D: IN STD_LOGIC_VECTOR(N-1 downto 0);
    Q: OUT STD_LOGIC_VECTOR(N-1 downto 0)
 );
END registro;

ARCHITECTURE funcional OF registro IS
BEGIN
    registro:process(clk)
        variable Q_signal: STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
    begin
        if rising_edge(clk) then
            case ctrl is
                when "100"  =>
                    Q_signal := D;
                when "010" =>
                    Q_signal := (others => '0');
                when "001" =>
                    Q_signal := Sin & Q_signal(N-1 downto 1);
                when others =>
                    Q_signal := Q_signal;
            end case;
            if eOut = '1' then
                Q <= Q_signal;
            else
                Q <= (others=>'Z');
            end if;
        end if;
    end process;
  
    
END funcional;
