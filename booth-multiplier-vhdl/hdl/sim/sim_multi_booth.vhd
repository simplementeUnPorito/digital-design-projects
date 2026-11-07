library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.mi_paquete.ALL;

entity sim_MultiBooth is
--  Port ( );
end sim_MultiBooth;

architecture Behavioral of sim_MultiBooth is
    constant nReg: natural := 4;
    signal clk, ini, fin: std_logic;
    signal busIN: std_logic_vector(regLen - 1 downto 0);
    signal result: std_logic_vector(2*nReg*regLen - 1 downto 0);
begin
    MultiBooth_inst:entity work.MultiBooth generic map(nReg => nReg)
    port map(
        clk => clk,
        ini => ini,
        busIN => busIN,
        result => result,
        fin => fin
    );
    
        
    signals:process
    begin
        ini <= '0';
        
        clk <= '0';
        wait for 15 ns;
        clk <= '1';
        wait for 15 ns;
       
        clk <= '0';
        wait for 15 ns;
        clk <= '1';
        wait for 15 ns;
        
        ini<= '1';
        BusIN<="10111011"; --Mreg0
        
        
        clk <= '0';
        wait for 15 ns;
        clk <= '1';
        wait for 15 ns;
        
        ini<= '0';
        
        BusIN<="11010110"; --Mreg1
        
        clk <= '0';
        wait for 15 ns;
        clk <= '1';
        wait for 15 ns;
        
         BusIN<="00010110"; --Mreg2
        
        clk <= '0';
        wait for 15 ns;
        clk <= '1';
        wait for 15 ns;
        
         BusIN<="01011011"; --Mreg3
        
        clk <= '0';
        wait for 15 ns;
        clk <= '1';
        wait for 15 ns;

        
    
        BusIN<="11110111"; --Qreg
        clk <= '0';
        wait for 15 ns;
        clk <= '1';
        wait for 15 ns;
        
        loop
            clk <= not clk;
            wait for 15 ns;
        end loop;
    end process;
    
    
    
    
end Behavioral;
