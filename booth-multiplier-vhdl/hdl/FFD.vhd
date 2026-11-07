--Modelo de uno de los flip flops en un SN/74LS74A 
--adaptado con un 74F126 para enableOut y enableIn
--y negando set y clear con 74ls04
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FFD is 
Port (
   clk, d, set, clear, enableOut, enableIn: in std_logic;
   Q,Qn: out std_logic 
   );
end FFD;

architecture Behavioral of FFD is
    
begin
    flifloh: process(clk)
        variable Q_signal,Qn_signal: std_logic;
    begin
        if(rising_edge(clk)) then
            
            
            if set = '1' then
                Q_signal := '1';
                Qn_signal := '0';
            elsif clear = '1' then
                Q_signal := '0';
                Qn_signal := '1';
            elsif enableIn = '1' then
                Q_signal := D;
                Qn_signal := not D;
            end if;
           
           if(enableOut = '1') then
                Q<=Q_signal;
                Qn<=Qn_signal;
           else
                Q<='Z';
                Qn<='Z';
           end if;
        end if;
    end process;
end Behavioral;
