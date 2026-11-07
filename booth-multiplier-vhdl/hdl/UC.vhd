library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UC is
  Port ( 
    clk: in std_logic;
    sennal: in std_logic_vector(5 downto 0); --(Q(0),cont=0,Q0=Qac,i<nreg-1,i<nreg,Ini)
    fin: out std_logic;
    sal: inout std_logic_vector(13 downto 0) 
  );
end UC;

architecture Behavioral of UC is
    subtype natural_mem is natural range 0 to 31;
    signal in_Mem:  natural_mem;
    signal out_Mem0:  std_logic_vector(7 downto 0);
    signal out_Mem1:  std_logic_vector(7 downto 0);
    
--    signal s_dec_bus: std_logic;
    
    signal incr_cont,load_cont: std_logic;
    subtype natural_cont is natural range 0 to 7;
    signal cont: natural := 0;  
    
    
    signal out_mux: std_logic;
begin
    
    
    process(cont,sennal(4))
    begin
        if(cont = 5 and sennal(4) = '1') then
            fin <= '1';
        else
            fin<= '0';
        end if;
    end process;

    mux: process(sennal,cont)
    begin
        case cont is
            when 0 =>
                out_mux<= sennal(0);
            when 1 =>
                out_mux<= sennal(1);
            when 2 =>
                out_mux<= sennal(2);
            when 3 =>
                out_mux<= sennal(3);
            when 4 =>
                out_mux<= sennal(2);
            when 5 =>
                out_mux<= sennal(4);    
            when others =>
                out_mux<= '0';
        end case;
    end process;
    
    
    incr_cont<=out_mem1(7);
    load_cont<=out_mem1(6);
    cont_process: process(clk)
        variable ctrl: std_logic_vector(1 downto 0);
        variable cont_bin: std_logic_vector(2 downto 0);
    begin
        ctrl := incr_cont & load_cont;
        cont_bin := std_logic_vector(to_unsigned(cont, cont_bin'length));
        if rising_edge(clk) then
            if ctrl = "10" then -- incrementar 
                if cont < 5 then
                    cont <= cont + 1;
                else
                    cont <= 0;
                end if;
            elsif ctrl = "01" then --cargar
                cont_bin(2) := not cont_bin(2); -- negar el bit de la entrada del load
                cont_bin(1) := not cont_bin(1);
                cont <= to_integer(unsigned(cont_bin));
            end if;
        end if;
    end process;
    
    in_Mem<=TO_INTEGER(unsigned(std_logic_vector(to_unsigned(cont, 3)) & sennal(5) & out_mux));
    
    
    memorias: process(in_Mem)
    begin
        case in_Mem is
        when 0 =>
            out_Mem1 <="00001000";
            out_Mem0 <="00000000";
        when 1 =>
            out_Mem1 <="10110000";
            out_Mem0 <="00000000";
        when 2 =>
            out_Mem1 <="00001000";
            out_Mem0 <="00000000";
        when 3 =>
            out_Mem1 <="10110000";
            out_Mem0 <="00000000";
        when 4 =>
            out_Mem1 <="10011110";
            out_Mem0 <="00000000";
        when 5 =>
            out_Mem1 <="00110000";
            out_Mem0 <="00000000";
        when 6 =>
            out_Mem1 <="10011110";
            out_Mem0 <="00000000";
        when 7 =>
            out_Mem1 <="00110000";
            out_Mem0 <="00000000";
        when 8 =>
            out_Mem1 <="10101011";
            out_Mem0 <="10000000";
        when 9 =>
            out_Mem1 <="00100001";
            out_Mem0 <="10000000";
        when 10 =>
            out_Mem1 <="10101011";
            out_Mem0 <="10000000";
        when 11 =>
            out_Mem1 <="00100001";
            out_Mem0 <="10000000";
        when 12 =>
            out_Mem1 <="10000000";
            out_Mem0 <="00000000";
        when 13 =>
            out_Mem1 <="01000000";
            out_Mem0 <="00000000";
        when 14 =>
            out_Mem1 <="10000000";
            out_Mem0 <="00000000";
        when 15 =>
            out_Mem1 <="01000000";
            out_Mem0 <="00000000";
        when 16 =>
            out_Mem1 <="10101011";
            out_Mem0 <="00011011";
        when 17 =>
            out_Mem1 <="00100001";
            out_Mem0 <="00011010";
        when 18 =>
            out_Mem1 <="10101011";
            out_Mem0 <="00011111";
        when 19 =>
            out_Mem1 <="00100001";
            out_Mem0 <="00011110";
        when 20 =>
            out_Mem1 <="01000000";
            out_Mem0 <="01100000";
        when 21 =>
            out_Mem1 <="10001000";
            out_Mem0 <="01100000";
        when 22 =>
            out_Mem1 <="01000000";
            out_Mem0 <="01100000";
        when 23 =>
            out_Mem1 <="10001000";
            out_Mem0 <="01100000";
        when others =>
            out_Mem1 <="00000000";
            out_Mem0 <="00000000";
        end case;
    end process;

--    process(cont,out_mux)
--    begin
--        if cont = 1 and out_mux = '0' then
--            s_dec_bus <= '1';
--        else
--            s_dec_bus <= '0';
--        end if;
--    end process;


--    sal<=s_dec_bus & out_mem1(5 downto 0) & out_mem0;
    sal<=out_mem1(5 downto 0) & out_mem0;
    
    


end Behavioral;
