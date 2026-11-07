

LIBRARY 	ieee;
USE			ieee.std_logic_1164.all;
use work.mi_paquete.ALL;


entity not_ctrl is
    Port ( input : in STD_LOGIC_VECTOR(31 downto 0);
           ctrl : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR(31 downto 0));
end not_ctrl;

architecture Behavioral of not_ctrl is

begin
    process(input,ctrl)
    begin
        if ctrl = '1' then
            output <= not input;
        else
            output <= input;
        end if;
    end process;
    

end Behavioral;
