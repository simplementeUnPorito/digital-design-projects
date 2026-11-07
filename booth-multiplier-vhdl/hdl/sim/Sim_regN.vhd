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
