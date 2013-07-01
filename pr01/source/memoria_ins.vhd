-----------------------------------------------------------------
--  
--  Fichero: memoria_ins.vhd
--  
--  Descripción:
--    Modelo de la memoria de instrucciones.
--    Contiene el programa que ejecutara el procesador
--
--  Autor: Javier Castillo
--  Fecha: 20-10-2006
--  
--  Historia:
--     20-10-2006  Versión inicial
--     22-03-2007  Modifica David Rozas Domingo. 
--                 Nuevo código para hacer pruebas: multiplicación
------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY Memoria_Ins IS
    port(address_i : IN std_logic_vector (31 DOWNTO 0);
         d_o : OUT std_logic_vector (31 DOWNTO 0));
END Memoria_Ins;

architecture funcional of  Memoria_Ins is
type memoria is array(integer range <>) of std_logic_vector(31 downto 0);
signal instrucciones : memoria(0 to 64):=
     (   0=> "00001000000000000000000000000100",
         4=> "10001100000000010000000000000000",
         8=> "10001100000000100000000000000100",
         12=> "10001100000000110000000000001000", 
         16=> "10001100000000010000000000000000",
         20=> "10001100000000100000000000000100",
         24=> "10001100000000110000000000001000",
         28=> "00000000001001010010100000100000",
         32=> "00000000010000110001000000100010",
         36=> "00011000010000001111111111111101",
         40=> "10101100000001010000000000001100",
         others=>"11111100000000000000000000000000");                  
      
      
      -- Programa que realiza un salto incondicional, y posteriormente
      -- realiza una multiplicación.
        
      --0  jump 4 (saltamos a segundo lw r1,0(r0) : 000010-0000000000.0000000000.000100 
      --4  lw  r1,0(r0)
      --8  lw  r2,4(r0)
      --12 lw  r3,8(r0)
      --16 lw  r1,0(r0)
      --20 lw  r2,4(r0)
      --24 lw  r3,8(r0)
      --28 add r5,r5,r1: 28=> "000000.00001.00101.00101.00000100000"
      --32 sub r2,r2,r3: 32=> "000000.00010.00011.00010.00000.100010"
      --36 bne r2,r0,-3: 36=> "000110.00010.00000.1111111111111101", 
      --40 sw r5,12r0:   40=> "101011.00000.00101.0000000000001100",
         -------------------------------------------------------  
         -- Salto de bne, en complemento a dos
         -- -5: 1111111111111011
         -- -3: 1111111111111101
         
   
begin
 
  d_o<=instrucciones(conv_integer(address_i));
  
end funcional; 