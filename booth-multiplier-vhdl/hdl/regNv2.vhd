library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.mi_paquete.ALL;


entity RegNv2 is
    GENERIC 
    (   
        nReg : NATURAL := 4
    );   -- Numero de bits del registro
    PORT
    (
        clk,SerialIn, clear, shift: IN  STD_LOGIC;     
        enIn, enOut:IN STD_LOGIC;
        D: IN STD_LOGIC_VECTOR(regLen-1 downto 0);
        Q: INOUT STD_LOGIC_MATRIX(nReg-1 downto 0)
     );
end RegNv2;

architecture Behavioral of RegNv2 is
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
    
    signal DD: STD_LOGIC_VECTOR(regLen - 1 downto 0);
    signal DDD: STD_LOGIC_VECTOR(3 downto 0);
begin
    
    DD <= (others => D(3));
    DDD <= (others => D(3));
    
    regFinal: registro 
    generic map (N => regLen)
    port map
    (
        clk => clk,
        Sin => SerialIn,
        eOut => enOut,
        ctrl(2) => enIn,
        ctrl(1) => clear,
        ctrl(0) => shift,
        D => DD,
        Q => Q(nReg -1 )
    );
    
    
    Cascada: for i in nReg - 2 downto 1 generate
        reg:registro 
        generic map (N => regLen)
        port map
        (
            clk => clk,
            Sin => Q(i+1)(0),
            eOut => enOut,
            ctrl(2) => enIn,
            ctrl(1) => clear,
            ctrl(0) => shift,
            D => DD,
            Q => Q(i)
        );
    end generate;
    
    reg0: registro 
    generic map (N => regLen)
    port map
    (
        clk => clk,
        Sin => Q(1)(0),
        eOut => enOut,
        ctrl(2) => enIn,
        ctrl(1) => clear,
        ctrl(0) => shift,
        D(7 downto 4) => DDD,
        D(3 downto 0) => D(3 downto 0),
        Q => Q(0)
    );
   
   
    

end Behavioral;
