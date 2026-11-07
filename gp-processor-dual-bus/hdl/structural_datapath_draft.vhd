
-- contador.vhd

-- 	Se complementa con una descripcion Generica
--
LIBRARY 	ieee;
USE			ieee.std_logic_1164.all;
use work.mi_paquete.ALL;

ENTITY dec_2a4 IS

PORT
(
	s: in std_logic_vector(1 downto 0);
	en: in std_logic;
	sal: out std_logic_vector(3 downto 0)
 );
END dec_2a4;

ARCHITECTURE xd OF dec_2a4 IS
	
BEGIN
	process(s,en)
	begin
        if en = '0' then
            sal<="0000";
        else
            case s is
           when "00" =>
               sal <= "0001";
           when "01" =>
               sal <= "0010";
           when "10" =>
               sal <= "0100";
           when "11" =>
               sal <= "1000";
            when others =>
                null;
        end case;
        end if;
	end process;
	
END xd;

LIBRARY 	ieee;
USE			ieee.std_logic_1164.all;
use work.mi_paquete.ALL;

ENTITY dec_3a8 IS

PORT
(
	s: in std_logic_vector(2 downto 0);
	en: in std_logic_vector(1 downto 0);
	sal: out std_logic_vector(7 downto 0)
 );
END dec_2a4;

ARCHITECTURE xd OF dec_3a8 IS
	
BEGIN
	process(s,en)
	begin
        if en = "11" then
         sal<=(others =>'0');
         case s is
           when "0000" =>
            sal(0)<='1';
           when "0001" =>
            sal(1)<='1';
           when "0010" =>
            sal(2)<='1';
           when "0011" =>
            sal(3)<='1';
           when "0100" =>
            sal(4)<='1';
           when "0101" =>
            sal(5)<='1';
           when "0110" =>
            sal(6)<='1';
           when "0111" =>
            sal(7)<='1';
           when "1000" =>
            sal(8)<='1';
           when "1001" =>
            sal(9)<='1';
           when "1010" =>
            sal(10)<='1';
           when "1011" =>
            sal(11)<='1';
           when "1100" =>
            sal(12)<='1';
           when "1101" =>
            sal(13)<='1';
           when "1110" =>
            sal(14)<='1';
           when "1111" =>
            sal(15)<='1';
        end case;
            
        else
           sal<="0000";
        end if;
	end process;
	
END xd;

--------------------- REGISTROS AUXILIARES DE LA ALU ----------------
    
    regRTmp : process(CLK) BEGIN
        if rising_edge(CLK) then
            if (sTmp = '1') then
                RTmp <= B1;
            end if;
        end if;
    END PROCESS;
    

    regROutp : process(CLK) BEGIN
        if rising_edge(CLK) then
            if (sRout = '1') then
                ROutp <= ALUout;
            end if;
        end if;
    END PROCESS;    


------------------- REGISTRO DE BANDERAS ------------------


    regBanderas : process(CLK) BEGIN
        if rising_edge(CLK) then
            if (sBnd = '1') then
                Banderas <= Bands;
            end if;
        end if;
    END PROCESS;

    Z <= Banderas(0);
    
    N <= Banderas(1);

-------------------------------------------------------------



---------------------- PROGRAM COUNTER ----------------------------
    
    
    aux3 <= not ePC;
    
    aux4 <= not sPC;
    

    PC: Counter_8bit port map (
            CLK => CLK,
            PL => aux4,
            CLR => aux2,
            CEN => clen,
            INP => B1,
            Q => B   );

    PC_buffer : buffer_74ls541 port map (
            I => B,
            OE1 => aux3,
            OE2 => aux3,
            O => B1  );

--------------------------------------------------------------------
    


---------------- REGISTROS DE PROPOSITO GENERAL -----------------------

    regR0 : process(CLK) BEGIN
        if rising_edge(CLK) then
            if (s0 = '1') then
                R0 <= B1;
            elsif (cPC = '1') then
                R0 <= "00000000";
            end if;
        end if;
    END PROCESS;

    
    regR1 : process(CLK) BEGIN
        if rising_edge(CLK) then
            if (s1 = '1') then
                R1 <= B1;
            elsif (cPC = '1') then
                R1 <= "00000000";
            end if;
        end if;
    END PROCESS;


    regR2 : process(CLK) BEGIN
        if rising_edge(CLK) then
            if (s2 = '1') then
                R2 <= B1;
            elsif (cPC = '1') then
                R2 <= "00000000";
            end if;
        end if;
    END PROCESS;


    regR3 : process(CLK) BEGIN
        if rising_edge(CLK) then
            if (s3 = '1') then
                R3 <= B1;
            elsif (cPC = '1') then
                R3 <= "00000000";
            end if;
        end if;
    END PROCESS;

-----------------------------------------------------------------------


------------------- ADDRESS REGISTER --------------------------

    regAR : process(CLK) BEGIN
        if rising_edge(CLK) then
            if (sAR = '1') then
                AR <= B1;
            end if;
        end if;
    END PROCESS;


-------------------------- STACK POINTER ---------------------------
    
    SP <= "11111111";
    
    process (eSP, eAR) begin
        if (eSP = '1') then
            B2 <= SP;
        elsif (eAR = '1') then
            B2 <= AR;
        else
            B2 <= (others => 'Z');
        end if;
    end process;
    
    regSP : process (CLK) begin
        if rising_edge(CLK) then
            if (uSP = '1') then
                SP <= std_logic_vector(unsigned(SP) + 1);
            elsif (dSP = '1') then
                SP <= std_logic_vector(unsigned(SP) - 1);
            end if;
        end if;
    end process;    

--------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.mi_paquete.ALL;

ENTITY RegN_tb IS
END RegN_tb;

ARCHITECTURE behavior OF RegN_tb IS
    -- Declaración de señales para el testbench
    SIGNAL clk_tb, SerialIn_tb, clear_tb, shift_tb: STD_LOGIC := '0';
    SIGNAL enIn_tb, enOut_tb: STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL D_tb: STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL Q_tb: STD_LOGIC_MATRIX(3 downto 0);

BEGIN
    -- Instanciar el componente RegN
    UUT: entity work.RegN
        GENERIC MAP (
            nReg => 4
        )
        PORT MAP (
            clk => clk_tb,
            SerialIn => SerialIn_tb,
            clear => clear_tb,
            shift => shift_tb,
            enIn => enIn_tb,
            enOut => enOut_tb,
            D => D_tb,
            Q => Q_tb
        );

    -- Proceso para generar el clock
    clk_process: PROCESS
    BEGIN
        clk_tb <= '0';
        WAIT FOR 5 ns;
        clk_tb <= '1';
        WAIT FOR 5 ns;
    END PROCESS clk_process;

    -- Proceso de prueba
    test_process: PROCESS
    BEGIN
        -- Establecer valores iniciales
        SerialIn_tb <= '0';
        clear_tb <= '0';
        shift_tb <= '0';
        D_tb <= "10101111";
        enIn_tb <= "1000";
        enOut_tb <= "0000";
        WAIT UNTIL rising_edge(clk_tb);
        D_tb <= "11101111";
        enOut_tb <= "1000";
        WAIT UNTIL rising_edge(clk_tb);
        enIn_tb <= "0000";
        clear_tb <= '1';
        WAIT UNTIL rising_edge(clk_tb);
        enOut_tb <= "1111";
        WAIT UNTIL rising_edge(clk_tb);
        clear_tb <= '0';
        WAIT UNTIL rising_edge(clk_tb);
        SerialIn_tb <= '1';
        enIn_tb <= "1111";
        D_tb <= "10101010";
        WAIT UNTIL rising_edge(clk_tb);
        enIn_tb <= "0000";
        shift_tb <= '1';
        WAIT UNTIL rising_edge(clk_tb);
        WAIT UNTIL rising_edge(clk_tb);
        
        WAIT UNTIL rising_edge(clk_tb);
        enOut_tb <= "0000";
        WAIT UNTIL rising_edge(clk_tb);
        WAIT UNTIL rising_edge(clk_tb);
        WAIT UNTIL rising_edge(clk_tb);
        WAIT UNTIL rising_edge(clk_tb);
        WAIT UNTIL rising_edge(clk_tb);
        enOut_tb <= "1111";
        
        WAIT;
    END PROCESS test_process;

END behavior;

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


--
LIBRARY     ieee;
USE     ieee.std_logic_1164.all;
use work.mi_paquete.ALL;


ENTITY registro IS
GENERIC (   N : NATURAL := 4 );   -- Numero de bits del registro
PORT
(
    clk,Sin,eOut: IN  STD_LOGIC;                
    ctrl   : IN STD_LOGIC_VECTOR(2 downto 0);
    
    D: IN STD_LOGIC_VECTOR(N-1 downto 0);
    Q: OUT STD_LOGIC_VECTOR(N-1 downto 0)
 );
END registro;

ARCHITECTURE funcional OF registro IS
BEGIN
    registro:process(clk)
        variable Q_signal: STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
    begin
        if rising_edge(clk) then
            case ctrl is
                when "100"  =>
                    Q_signal := D;
                when "010" =>
                    Q_signal := (others => '0');
                when "001" =>
                    Q_signal := Sin & Q_signal(N-1 downto 1);
                when others =>
                    Q_signal := Q_signal;
            end case;
            if eOut = '1' then
                Q <= Q_signal;
            else
                Q <= (others=>'Z');
            end if;
        end if;
    end process;
  
    
END funcional;

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





