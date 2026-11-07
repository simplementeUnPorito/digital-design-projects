library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.mi_paquete.ALL;


entity RegN is
    GENERIC 
    (   
        nReg : NATURAL := 4
    );   -- Numero de bits del registro
    PORT
    (
        clk,SerialIn, clear, shift: IN  STD_LOGIC;     
        enIn, enOut:IN STD_LOGIC_VECTOR(nReg-1 downto 0);
        D: IN STD_LOGIC_VECTOR(regLen-1 downto 0);
        Q: INOUT STD_LOGIC_MATRIX(nReg-1 downto 0)
     );
end RegN;

architecture Behavioral of RegN is
    signal Sin: std_logic_vector(nReg+1 downto 0);
    component registro IS
    GENERIC (   N : NATURAL := 4 );   -- Numero de bits del registro
    PORT
    (
        clk,Sin,eOut: IN  STD_LOGIC;                
        ctrl   : IN STD_LOGIC_VECTOR(2 downto 0);
        
        D: IN STD_LOGIC_VECTOR(N-1 downto 0);
        Q: OUT STD_LOGIC_VECTOR(N-1 downto 0)
     );
    END component;
begin
    
    
    
    Cascada: for i in 0 to nReg-2 generate
        reg:registro 
        generic map (N => regLen)
        port map
        (
            clk => clk,
            Sin => Q(i+1)(0),
            eOut => enOut(i),
            ctrl(2) => enIn(i),
            ctrl(1) => clear,
            ctrl(0) => shift,
            D => D,
            Q => Q(i)
        );
    end generate;
    regFinal: registro 
    generic map (N => regLen)
    port map
    (
        clk => clk,
        Sin => SerialIn,
        eOut => enOut(nReg-1),
        ctrl(2) => enIn(nReg-1),
        ctrl(1) => clear,
        ctrl(0) => shift,
        D => D,
        Q => Q(nReg-1)
    );
   
    

end Behavioral;
