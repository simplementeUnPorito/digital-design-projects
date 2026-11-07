library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dec is
    Port ( i : in STD_LOGIC_VECTOR(1 downto 0);
           s,en : in STD_LOGIC;
           sal1,sal2 : out STD_LOGIC_VECTOR(3 downto 0));
end dec;

architecture Behavioral of dec is
    signal sal_i: STD_LOGIC_VECTOR(3 downto 0);
begin
    
    
--    dec_i: entity work.dec_2a4 port map
--    (
--    s => i,
--    sal => sal_i
--    );
    
    process(s,i,en)
    begin
    if en = '1' then
        if(s = '0') then
                case i is
               when "00" =>
                   sal1 <= "0001";
               when "01" =>
                   sal1 <= "0010";
               when "10" =>
                   sal1 <= "0100";
               when "11" =>
                   sal1 <= "1000";
                when others =>
                    null;
            end case;
            sal2 <= (others => '0');
        else
            case i is
               when "00" =>
                   sal2 <= "0001";
               when "01" =>
                   sal2 <= "0010";
               when "10" =>
                   sal2 <= "0100";
               when "11" =>
                   sal2 <= "1000";
                when others =>
                    null;
            end case;
            sal1 <= (others => '0');
        end if;
        
    else
        sal1 <= (others => '0');
        sal2 <= (others => '0');
    end if;
    end process;
end Behavioral;
