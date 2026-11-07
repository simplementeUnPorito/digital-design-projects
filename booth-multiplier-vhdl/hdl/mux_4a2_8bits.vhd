library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.mi_paquete.ALL;


entity mux_4a1_8bits is
    Port ( input: in STD_LOGIC_MATRIX(3 downto 0);
           s: in STD_LOGIC_VECTOR(1 downto 0);
           Sal : out STD_LOGIC_VECTOR(regLen-1 downto 0));
end mux_4a1_8bits;

architecture Behavioral of mux_4a1_8bits is
    
begin
    process(input,S)
    begin
        case s is
           when "00" =>
                sal <= input(0);
           when "01" =>
                sal <= input(1);
           when "10" =>
                sal <= input(2);
           when "11" =>
                sal <= input(3);
           when others =>
                null;
        end case;
    end process;

end Behavioral;

