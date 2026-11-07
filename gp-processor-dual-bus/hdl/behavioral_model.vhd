library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;



entity GpProcessor is
    Port ( ini : in STD_LOGIC;
           int : in STD_LOGIC;
           input: in STD_LOGIC_VECTOR(7 downto 0);
           clk : in STD_LOGIC);
end GpProcessor;

architecture Behavioral of GpProcessor is
    
    function naturalToStd(val: natural; len: natural) return std_logic_vector is  
    begin
        return std_logic_vector(to_unsigned(val, len));
    end function;
    
    function STDToNatural(val: std_logic_vector) return natural is
    begin
        return to_integer(unsigned(val));
    end function;
    
    function "+"(s1:std_logic_vector;s2:std_logic_vector) return std_logic_vector is
    begin
        return std_logic_vector(resize(unsigned(s1),s1'length+1)+resize(unsigned(s2),s1'length+1));
    end function;
    
    
    type memory is array (0 to 257) of std_logic_vector(7 downto 0);
    
    signal m: memory:=(others => (others => '0'));
    
    subtype pointer is natural range 0 to 257;
    
    signal pc: pointer:=0;
    signal sp: pointer:=257;
    signal op,ar,a,alu: std_logic_vector(7 downto 0):=(others=>'0');
    signal band,ri: std_logic_vector(3 downto 0):=(others=>'0');
    signal mode: std_logic:='0';
    type regGen is array(0 to 3) of std_logic_vector(7 downto 0);
    signal r: regGen := (others=>(others=>'0'));
    
    subtype state is natural range 0 to 15; --emulando un contador
    signal est: state:= 0;
begin
    process(clk)
    variable aux: std_logic_vector(8 downto 0);
    variable c,z,v,n: std_logic;
    begin
        if rising_edge(clk) then
            case est is
                when 0=>
                pc<=0;
                
                if ini = '1' then
                    est<=est+1;
                end if;
                
                when 1=>
                if int = '1' then
                    sp<=sp-1;
                    
                    est<=est+1;
                else
                    est<=8;
                end if;
                
                when 2=>
                    M(sp)<=naturalToStd(pc, 8);
                    pc<=STDToNatural(input);
                    sp<=sp-1;
                    
                    est<=est+1;
                when 3=>
                    M(sp)<=r(0);
                    sp<=sp-1;
                    
                    est<=est+1;
                when 4=>
                    M(sp)<=r(1);
                    sp<=sp-1;
                    
                    est<=est+1;
                when 5=>
                    M(sp)<=r(2);
                    sp<=sp-1;
                    
                    est<=est+1;
                when 6=>
                    M(sp)<=r(3);
                    sp<=sp-1;
                    
                    est<=est+1;
                when 7=>
                    M(sp)<="0000"&band;
                    sp<=sp-1;
                    
                    est<=est+1;
                when 8=>
                    ri<=M(pc)(7 downto 4);
                    mode<=M(pc)(3);
                    pc<=pc+1;
                    
                    est<=est+1;
                when 9=>
                    op<=M(pc);
                    ar<=M(pc);
                    case ri is 
                        when "0000" => --bz
                            est<=est+1;
                            
                        when "0001" => --jmp
                             est<=est+1;
                        when "0010" => --call
                           sp<=sp-1;
                           est<=est+1;
                        when "0011" => --ret/i
                            if mode = '0' then
                                est<=est+1;
                                band<=M(sp)(3 downto 0);
                                sp<=sp+1;
                            else
                                est<=14;
                            end if;
                            
                        
                        when "0100" => --addn
                            est<=est+1;
                            
                            
                        when "0101" => --addr
                            est<=est+1;
                           
                         when "0110" => --cmpn
                            est<=est+1;
                            
                         when "0111" => --not 
                            est<=est+1;
                            
                         when "1000" => --andn
                            est<=est+1;

                         when "1001" => --clr
                            est<=est+1;
                         when "1010" => --sxlc
                            est<=est+1;
                         when "1011" => --sxa
                            est<=est+1;
                         when "1100" => --mov
                            est<=est+1;
                            pc<=pc+1;
                         when "1101" => --st
                            est<=est+1;
                         when "1110" => --push
                            est<=est+1;
                         when "1111" => --pop
                            est<=est+1;
                            sp<=sp+1;
                    end case;
                when 10=>
                    case ri is 
                        when "0000" => --bz
                            if (mode xnor band(0)) = '0' then
                                pc<=pc+1;
                            else
                                pc<=stdtonatural(op);
                            end if;
                            
                            est<=1;
                        when "0001" => --jmp
                             if mode = '0' then
                                pc<=stdtonatural(op);
                             else
                                pc<=stdtonatural(m(stdtonatural(ar)));
                             end if;
                             est<=1;
                        when "0010" => --call
                            M(sp)<=naturaltostd(pc,8);
                            if mode = '0' then
                                pc<=stdtonatural(op);
                            else
                                pc<=stdtonatural(m(stdtonatural(ar)));
                            end if;
                            est<=1;
                        when "0011" => --ret/i
                            R(3)<=M(sp);
                            sp<=sp+1;
                            
                            est<=est+1;
                            
                        
                        when "0100" => --addn
                            est<=est+1;
                            pc<=pc+1;
                            if mode = '0' then
                                a<=m(STDToNatural(ar));
                            else
                                a<=r(STDToNatural(op));
                            end if;
                            
                            
                        when "0101" => --addr
                            est<=est+1;
                            pc<=pc+1;
                            a<=m(STDToNatural(ar));
                         when "0110" => --cmpn
                            est<=est+1;
                            pc<=pc+1;
                            if mode = '0' then
                                a<=m(stdtonatural(ar));
                            else
                                a<=r(stdtonatural(op));
                            end if;   
                            
                            est<=est+1;
                         when "0111" => --not 
                            est<=est+1;
                            
                            if mode = '0' then
                                a<=m(stdtonatural(ar));
                            else
                                a<=r(stdtonatural(op));
                            end if;
                            
                         when "1000" => --andn
                            est<=est+1;
                            pc<=pc+1;
                            
                            if mode = '0' then
                                a<=m(stdtonatural(ar));
                            else
                                a<=r(stdtonatural(op));
                            end if;
                            
                         when "1001" => --clr
                            op<=(others=>'0');
                            if mode = '0' then
                                ar<=m(stdtonatural(ar));
                            else
                                ar<=r(stdtonatural(op));
                            end if;
                            est<=est+1;
                         when "1010" => --sxlc
                            a<=m(stdtonatural(ar));
                            est<=est+1;
                         when "1011" => --sxa
                            a<=m(stdtonatural(ar));
                            est<=est+1;
                         when "1100" => --mov
                            est<=est+1;
                            pc<=pc+1;
                         when "1101" => --st
                            est<=est+1;
                            pc<=pc+1;
                            ar<=naturaltostd(stdtonatural(ar)+1,8); 
                         when "1110" => --push
                            if mode = '0' then
                                m(sp)<="0000"&band;
                            else
                                m(sp)<=r(stdtonatural(op));
                            end if;
                            est<=1;
                            sp<=sp-1;
                         when "1111" => --pop
                            est <= 1;
                            if mode = '0' then
                                band<= m(sp)(3 downto 0);
                            else
                                r(stdtonatural(op))<=m(sp);
                            end if;
                    end case;
                
                
                    
                when 11=>
                
                    case ri is 
                        when "0000" => --bz
                            est <= 1;
                        when "0001" => --jmp
                             est <= 1;
                        when "0010" => --call
                             est <= 1;
                        when "0011" => --ret/i
                            r(2)<=M(2);
                            sp<=sp+1;
                            est <= est+1;
                        when "0100" => --addn
                            aux:=a+m(pc);
                            alu<=aux(7 downto 0);
                            c:=aux(8);
                            est <= est+1;
                        when "0101" => --addr
                            if mode = '0' then
                                aux:=a+r(stdtonatural(op));
                            else
                                aux:=a+r(stdtonatural(op))+c;
                            end if;
                            
                            alu<=aux(7 downto 0);
                            c:=aux(8);
                            est <= est+1;
                         when "0110" => --cmpn
                            
                         when "0111" => --not 
                            
                         when "1000" => --andn
                            
                         when "1001" => --clr                      
                            
                         when "1010" => --sxlc
                            
                         when "1011" => --sxa
                            
                         when "1100" => --mov
                            
                         when "1101" => --st
                            
                         when "1110" => --push
                            
                         when "1111" => --pop
                           
                    end case;
                when 12=>
                
                    case ri is 
                        when "0000" => --bz
           
                        when "0001" => --jmp
                             
                        when "0010" => --call
                           
                        when "0011" => --ret/i
                            
                        when "0100" => --addn
                            
                        when "0101" => --addr
                            
                         when "0110" => --cmpn
                            
                         when "0111" => --not 
                            
                         when "1000" => --andn
                            
                         when "1001" => --clr                      
                            
                         when "1010" => --sxlc
                            
                         when "1011" => --sxa
                            
                         when "1100" => --mov
                            
                         when "1101" => --st
                            
                         when "1110" => --push
                            
                         when "1111" => --pop
                           
                    end case;
                    
                when 13=>
                    case ri is 
                        when "0000" => --bz
           
                        when "0001" => --jmp
                             
                        when "0010" => --call
                           
                        when "0011" => --ret/i
                            
                        when "0100" => --addn
                            
                        when "0101" => --addr
                            
                         when "0110" => --cmpn
                            
                         when "0111" => --not 
                            
                         when "1000" => --andn
                            
                         when "1001" => --clr                      
                            
                         when "1010" => --sxlc
                            
                         when "1011" => --sxa
                            
                         when "1100" => --mov
                            
                         when "1101" => --st
                            
                         when "1110" => --push
                            
                         when "1111" => --pop
                           
                    end case;
                when 14=>
                    case ri is 
                        when "0000" => --bz
           
                        when "0001" => --jmp
                             
                        when "0010" => --call
                           
                        when "0011" => --ret/i
                            
                        when "0100" => --addn
                            
                        when "0101" => --addr
                            
                         when "0110" => --cmpn
                            
                         when "0111" => --not 
                            
                         when "1000" => --andn
                            
                         when "1001" => --clr                      
                            
                         when "1010" => --sxlc
                            
                         when "1011" => --sxa
                            
                         when "1100" => --mov
                            
                         when "1101" => --st
                            
                         when "1110" => --push
                            
                         when "1111" => --pop
                           
                    end case;
                
                
                
                
            end case;
            
            band<=c&v&n&z;
        end if;
    end process;
    
    


end Behavioral;
