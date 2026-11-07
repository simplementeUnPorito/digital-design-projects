library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


package mi_paquete is
    constant regLen: natural := 8;
    type std_logic_matrix is array(natural range <>) of std_logic_vector(regLen - 1 downto 0);
    type boolean_vector is array(natural range<>) of boolean;
    type estado is (T0, T1, T2, T3,T4, T5);
    FUNCTION "+"(a, b : std_logic_vector) return std_logic_vector;
end package mi_paquete;

package body mi_paquete is
    FUNCTION "+"(a, b : std_logic_vector) return std_logic_vector is
    variable temp: unsigned(regLen downto 0);
    begin
        temp := RESIZE(unsigned(a),regLen+1) + RESIZE(unsigned(b),regLen+1);
        return STD_LOGIC_VECTOR(temp);
    end "+";
end package body mi_paquete;
