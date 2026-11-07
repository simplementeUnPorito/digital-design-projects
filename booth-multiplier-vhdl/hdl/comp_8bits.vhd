library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.mi_paquete.ALL;


entity comp_8bits is
    Port ( A : in STD_LOGIC_vector(regLen-1 downto 0);
           B : in STD_LOGIC_vector(regLen-1 downto 0);
           sal : out STD_LOGIC_vector(2 downto 0) --MAYOR,IGUAL,MENOR
    );
end comp_8bits;

architecture Behavioral of comp_8bits is
begin
    process(A,B)
        variable A_var, B_var : integer;
    begin
        A_var := to_integer(unsigned(A));
        B_var := to_integer(unsigned(B));
        if (A_var > B_var) then
            sal <= "100";
        elsif (A_var = B_var) then
            sal <= "010";
        else
            sal <= "001";
        end if;
    end process;


end Behavioral;
