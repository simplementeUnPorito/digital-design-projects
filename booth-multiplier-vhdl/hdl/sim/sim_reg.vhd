LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registro_tb IS
END registro_tb;

ARCHITECTURE behavior OF registro_tb IS 
    -- Componente que se va a probar
    COMPONENT registro
        GENERIC (
            N : NATURAL := 4
        );
        PORT (
            clk, Sin, eOut: IN STD_LOGIC;
            ctrl: IN STD_LOGIC_VECTOR(2 downto 0);
            D: IN STD_LOGIC_VECTOR(N-1 downto 0);
            Q: OUT STD_LOGIC_VECTOR(N-1 downto 0)
        );
    END COMPONENT;
    
    -- Declaración de señales para el testbench
    SIGNAL clk_tb, Sin_tb, eOut_tb: STD_LOGIC := '0';
    SIGNAL ctrl_tb: STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL D_tb, Q_tb: STD_LOGIC_VECTOR(3 downto 0);

BEGIN

    -- Instanciar el componente registro
    UUT: registro
    GENERIC MAP (
        N => 4
    )
    PORT MAP (
        clk => clk_tb,
        Sin => Sin_tb,
        eOut => eOut_tb,
        ctrl => ctrl_tb,
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
        Sin_tb <= '0';
        eOut_tb <= '1';
        ctrl_tb <= "000";
        D_tb <= "0000";
        
        -- Esperar un ciclo de reloj
        WAIT UNTIL rising_edge(clk_tb);
        
        -- Establecer nuevos valores
        Sin_tb <= '1';
        ctrl_tb <= "100";
        D_tb <= "1100";
        
        -- Esperar dos ciclos de reloj
        WAIT FOR 10 ns;
        D_tb <= "1011";
        WAIT FOR 10 ns;
        D_tb <= "1010";
        WAIT FOR 10 ns;
        D_tb <= "1111";
        WAIT FOR 10 ns;
        D_tb <= "1100";
        -- Establecer nuevos valores
        ctrl_tb <= "010";
        
        -- Esperar dos ciclos de reloj
        WAIT FOR 20 ns;
        
        -- Establecer nuevos valores
        ctrl_tb <= "001";
        
        -- Esperar dos ciclos de reloj
        WAIT FOR 10 ns;
        Sin_tb <= '1';
        WAIT FOR 10 ns;
        Sin_tb <= '1';
        WAIT FOR 10 ns;
        Sin_tb <= '0';
        WAIT FOR 10 ns;
        Sin_tb <= '0';
        WAIT FOR 10 ns;
        ctrl_tb <= "011";
        
        WAIT FOR 10 ns;
        
        ctrl_tb <= "111";
        WAIT FOR 10 ns;
        
        ctrl_tb <= "110";
        -- Finalizar la simulación
        
        wait for 10 ns;
         eOut_tb <= '0';
        WAIT;
    END PROCESS test_process;

END behavior;
