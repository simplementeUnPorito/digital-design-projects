library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.mi_paquete.ALL;


entity MultiBooth is
    generic(
        nReg: natural := 4
     );
     
    Port(
        clk,ini: in std_logic;
        busIN : in std_logic_vector(regLen - 1 downto 0);
        Result: out std_logic_vector(2*nReg*regLen - 1 downto 0);
        fin: inout std_logic
    );
   
end MultiBooth;

architecture Behavioral of MultiBooth is
    constant n: natural := nReg*regLen;
    signal RA,RQ: std_logic_vector(nReg*regLen - 1 downto 0);
    signal M,Mc2,one,A,Q: std_logic_matrix(nReg-1 downto 0);
    signal cont: natural;
    signal Asig,Qac,acarreo: std_logic;
    signal clrPreset: std_logic;
    
    signal shift: std_logic;
    
    --Señales del negador controlado
    signal not_ctrl_in,not_ctrl_out: std_logic_vector(nReg*regLen - 1 downto 0);
    signal ctrl_not: std_logic;
    --Señales del dec para el bus
    signal dec_bus1,dec_bus2:  std_logic_vector(nReg-1 downto 0);
    signal i_logic: std_logic_vector(1 downto 0);
    signal s_dec_bus, en_dec_bus,not_s_dec_bus: std_logic;
    --Señales del contador i
    signal i: natural;
    signal clr_i,incr_i: std_logic;
    --Señales sumador
    signal S1, S2, suma: std_logic_vector(regLen-1 downto 0);
    --Señales acarreo
    signal enIn_acarr,clr_acarr, in_acarr,out_acarr : std_logic;
    --Señales MUX S1, MUX S2
    signal selector_S1,selector_S2: std_logic;
    --Señales Asig
    signal clr_asig,enIn_asig,out_asig: std_logic;
    --Señales Qac
    signal clr_qac,enIn_qac,out_qac: std_logic;
    --señales dec suma
    signal dec_suma1,dec_suma2:  std_logic_vector(nReg-1 downto 0);
    signal s_dec_suma, en_dec_suma: std_logic;
    --señales comprador
    signal i_logic_8bits,cont_logic_8bits,zero_8bits,two_8bits, 
    nReg_8bits,Q00Qac, nRegM1_8bits, mux_comp_a,mux_comp_b: 
    std_logic_vector(regLen-1 downto 0);
    signal s_comp0,s_comp1,s_comp2,s_comp3: std_logic_vector(1 downto 0);
    signal comp_out0,comp_out1,comp_out2,comp_out3: std_logic_vector(2 downto 0);
    
    --señales regA
    signal clr_a: std_logic;
    --señales cont
    signal preset_cont,decr_cont,qigualdad: std_logic;
    
    
begin
    M(3) <= not_ctrl_in(31 downto 24);
    M(2) <= not_ctrl_in(23 downto 16);
    M(1) <= not_ctrl_in(15 downto 8);
    M(0) <= not_ctrl_in(7 downto 0);
    
    
    RA_signal:process(A)
    begin
        for index in 0 to nReg - 1 loop
            RA(regLen - 1 + index*regLen downto index*regLen)<=A(index);
        end loop;
    end process;
    
    RQ_signal:process(Q)
    begin
        for index in 0 to nReg - 1 loop
            RQ(regLen - 1 + index*regLen downto index*regLen)<=Q(index);
        end loop;
    end process;
    Result<= RA&RQ;
    
    not_s_dec_bus <= s_dec_bus;
    
    not_control: entity work.not_ctrl port map(not_ctrl_in,ctrl_not,not_ctrl_out);
    
   process(i)
   begin
    i_logic <= std_logic_vector(to_unsigned(i, 2));
    i_logic_8bits <= std_logic_vector(to_unsigned(i, 8));
   end process; 
   
   process(cont)
   begin
    cont_logic_8bits <=std_logic_vector(to_unsigned(cont, 8));
   end process;
   
   process(Q(0)(0),Qac)
   begin
    Q00Qac <= (others => '0');
    Q00Qac(1 downto 0) <= Q(0)(0)&Qac; 
   end process;
   
   process(ini)
   begin
    zero_8bits <= (others => '0');
    two_8bits <=(others => '0');
    nReg_8bits <= std_logic_vector(to_unsigned(nReg, 8));
    nRegM1_8bits <= std_logic_vector(to_unsigned(nReg -1, 8));
    two_8bits(1) <= '1';
    for i in nReg - 1 downto 0 loop
        one(i) <= (others => '0');
    end loop;
    one(0)(0) <= '1';
    
   end process;
   
   s_dec_bus <= clrPreset;
   unidadControl: entity work.uc port map(
    clk=> clk,
    fin => fin,
    sennal(0) => ini,
    sennal(1) => comp_out0(0),
    sennal(2) => comp_out1(0),
    sennal(3) => qigualdad,
    sennal(4) =>comp_out2(1),
    sennal(5) => Q(0)(0),
    sal(13) => incr_i,
    sal(12) => en_dec_bus,
    sal(11) => clr_i,
    sal(10) => clrPreset,
    sal(9) => clr_acarr,
    sal(8) => en_dec_suma,
    sal(7) => ctrl_not,
    sal(6) => shift,
    sal(5) => decr_cont,
    sal(4) => enIn_acarr,
    sal(3) => selector_S1,
    sal(2) => selector_S2,
    sal(1) => s_dec_suma,
    sal(0) => enIN_asig
   );
   
    
    dec_bus: entity work.dec 
    port map(
    i=>i_logic, 
    s => s_dec_bus,
    en => en_dec_bus, 
    sal1 =>dec_bus1, 
    sal2 =>dec_bus2
    );
    
    regM: entity work.regN
    generic map( nReg => nReg)
    port map(
        clk => clk,
        serialIn => '0',
        clear => '0',
        shift => '0',
        enIn => dec_bus1,
        enOut => (others => '1'),
        D => BusIN,
        Q(3) => not_ctrl_in(31 downto 24),
        Q(2) => not_ctrl_in(23 downto 16),
        Q(1) => not_ctrl_in(15 downto 8),
        Q(0) => not_ctrl_in(7 downto 0)
    );
    
    cont_i: entity work.contador 
    generic map(MIN_COUNT => 0, MAX_COUNT => 4)
    port map(
    clk=>clk,
    preset=>'0',
    reset =>clr_i,
    dec=>'0',
    incr=>incr_i,
    Q=>i);
    
    cont_cont: entity work.contador 
    generic map(MIN_COUNT => 0, MAX_COUNT => n-1)
    port map(
    clk=>clk,
    preset=> preset_cont,
    reset =>'0',
    dec=>decr_cont,
    incr=>'0',
    Q=>cont);
    
    
    regQ: entity work.regNv2
    generic map( nReg => nReg)
    port map(
        clk => clk,
        serialIn => A(0)(0),
        clear => '0',
        shift => shift,
        enIn => not_s_dec_bus,
        enOut => '1',
        D => BusIN,
        Q => Q
    );
    
    
    sumador: entity work.sumadorN
    generic map( N => 8)
    port map(
        A => S1,
        B => S2,
        Cin => out_acarr,
        S => Suma,
        V => open,
        C => in_acarr
    );
    
    mux_S1: entity work.mux
    generic map(nReg => 4)
    port map(
        A => one,
        B => A,
        i => i_logic,
        S => selector_S1,
        sal => s1
    );
    
    mux_S2: entity work.mux
    generic map(nReg => 4)
    port map(
        A(3) => not_ctrl_out(31 downto 24),
        A(2) => not_ctrl_out(23 downto 16),
        A(1) => not_ctrl_out(15 downto 8),
        A(0) => not_ctrl_out(7 downto 0),
        B =>Mc2,
        i => i_logic,
        S => selector_S2,
        sal => s2
    );
    Asig <= out_asig;
    FFD_Asig: entity work.FFD
    port map(
        clk => clk,
        d =>suma(regLen-1),
        set => '0',
        clear =>clr_asig,
        enableOut=> '1',
        enableIN => enIn_asig,
        q =>out_asig,
        qn => open
    );
    
    regA: entity work.regN
    generic map( nReg => nReg)
    port map(
        clk => clk,
        serialIn => out_asig,
        clear => clr_a,
        shift => shift,
        enIn => dec_suma2,
        enOut => (others => '1'),
        D => suma,
        Q => A
    );
    qac<=out_qac;
    FFD_Qac: entity work.FFD
    port map(
        clk => clk,
        d =>Q(0)(0),
        set => '0',
        clear =>clr_qac,
        enableOut=> '1',
        enableIN => Shift,
        q =>out_qac,
        qn => open
    );
    acarreo<=out_acarr;
    FFD_acarr: entity work.FFD
    port map(
        clk => clk,
        d =>in_acarr,
        set => '0',
        clear =>clr_acarr,
        enableOut=> '1',
        enableIN => enIn_acarr,
        q =>out_acarr,
        qn => open
    );
    
    
 
    
    
    dec_suma: entity work.dec 
    port map(
        i=>i_logic, 
        s => s_dec_suma,
        en => en_dec_suma, 
        sal1 =>dec_suma1, 
        sal2 =>dec_suma2
    );
    
    regMC2: entity work.regN
    generic map( nReg => nReg)
    port map(
        clk => clk,
        serialIn => '0',
        clear => '0',
        shift => '0',
        enIn => dec_suma1,
        enOut => (others => '1'),
        D => suma,
        Q => MC2
    );
    
    
    
    comp_0: entity work.comp_8bits
    port map(
        A=>i_logic_8bits,
        B=>nReg_8bits,
        sal => comp_out0
    );
    
    comp_1: entity work.comp_8bits
    port map(
        A=>i_logic_8bits,
        B=>nRegM1_8bits,
        sal => comp_out1
    );
    
    comp_2: entity work.comp_8bits
    port map(
        A=>cont_logic_8bits,
        B=>zero_8bits,
        sal => comp_out2
    );
 
    comp_3: entity work.comp_8bits
    port map(
        A=>Q00Qac,
        B=>two_8bits,
        sal => comp_out3
    );
    
  
    
    
    qigualdad <= not (Q(0)(0) xor Qac); -- Q(0)(0) = Qac 
    clr_a<= clrPreset;
    clr_asig<=clrPreset;
    clr_qac<=clrPreset;
    preset_cont<=clrPreset;
    
    
    
    
    
    
   
    
end Behavioral;


