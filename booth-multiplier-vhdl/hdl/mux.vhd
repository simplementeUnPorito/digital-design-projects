library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.mi_paquete.ALL;

entity mux is
  generic(nReg: natural := 4);
  Port ( 
    A, B: in std_logic_matrix(nReg - 1 downto 0);
    i: in std_logic_vector(1 downto 0);
    S: in std_logic;
    sal: out std_logic_vector(regLen - 1 downto 0)
  );
end mux;

architecture Behavioral of mux is
        signal mux_a,mux_b: std_logic_vector(regLen - 1 downto 0);
begin
--    mux_1:entity work.mux_4a1_8bits port map(
--        input => A,
--        S => i,
--        Sal => mux_a
--    );

--    mux_2:entity work.mux_4a1_8bits port map(
--        input => A,
--        S => i,
--        Sal => mux_b
--    );



--    Mux_3:entity work.mux_2a1_8bits port map(
--        input(0) => mux_a,
--        input(1) => mux_b,
--        s => s,
--        sal => sal
--    );


    process(i,s,a,b)
    begin
        case s is
            when '0' =>
                sal <= A(to_integer(unsigned(i)));
            when '1' =>
                 sal <= B(to_integer(unsigned(i)));
            when others =>
                null;
        end case;
    end process;
end Behavioral;
