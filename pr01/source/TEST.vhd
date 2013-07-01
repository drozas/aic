---------------------------------------------------------------------
--  
--  Fichero: TEST.vhd
--  
--  Descripción:
--    Aplica los estímulos al procesador.
--
--  Autor: David Rozas Domingo
--  Fecha: 08-03-2007
--  
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY test IS
END test;

ARCHITECTURE funcional of test is

COMPONENT MIPS IS

port (clk_i: IN std_logic;
reset_i: IN std_logic);
END COMPONENT;

signal clk : std_logic :='0';
signal reset: std_logic;

BEGIN
   clk <= not(clk) after 10ns;
   reset <= '1', '0' after 20 ns;
   UUT : MIPS port map(clk, reset);
END funcional;
