---------------------------------------------------------------------
--  
--  Fichero: UC.vhd
--  
--  Descripci�n:
--    Unidad de Control. Controla el flujo de ejecuci�n.
--
--  Autor: David Rozas Domingo
--  Fecha: 08-03-2007
--  
--------------------------------------------------------------------


library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY UC IS 
port(
	clk_i : IN std_logic;
	reset_i : IN std_logic;
	op : IN std_logic_vector (11 downto 0);
	cero : IN std_logic;
	
	EscrPC: OUT std_logic;
	LeerMEM: OUT std_logic;
	EscribirMEM: OUT std_logic;
	MemaReg: OUT std_logic;
	EscrIR: OUT std_logic;
	FuentePC : OUT std_logic_vector(1 downto 0);
	ALUOp : OUT std_logic_vector(2 downto 0);
	SelALUA: OUT std_logic;
	SelALUB: OUT std_logic_vector(1 downto 0);
	EscrReg : OUT std_logic;
	RegDest : OUT std_logic);
END UC;

ARCHITECTURE funcional of UC IS
	type estados is range 0 to 10;
	signal estado,estado_siguiente:estados;
	signal n_ciclo : natural;
begin

  process(estado,op,cero)
	begin
	
	-- Inicializaci�n de variables  
  	EscrPC<='0';
  	LeerMEM<='0';
  	EscribirMEM<='0';
  	MemaReg<='0';
  	EscrIR<='0';
  	FuentePC<="00";
  	ALUOp <="000";
  	SelALUA<='0';
  	SelALUB<="00";
  	EscrReg <='0';
  	RegDest <='0';

	case estado is
	    -- Instruction Fetch: Leemos la instrucci�n de memoria (com�n a todas las instrucciones)
	    ----------------------------------------------------------------------------------------
	    when 0 =>
         --Cargamos en el registro de instrucciones la instrucci�n
         EscrIR <= '1';
         --Aumentamos en 4 el PC
         selALUA<='0';
         selALUB<="01";
         ALUOp<="000";
         FuentePC<="00";
         EscrPC<='1';
         
         estado_siguiente<=1;

	    -- Instruction Decodification (decodificaci�n de instrucci�n, com�n): 
	    ------------------------------
       when 1 =>
           SelALUA <= '0';
           SelALUB <= "11";
           
           -- Decodificaci�n de c�digo de instrucci�n
           case op (11 downto 6) is
           when "000000" =>
              -- Operaci�n tipo R
              estado_siguiente <= 6;
           when "100011" =>
              -- Operaci�n de load
              estado_siguiente <= 2;
           when "101011" =>
              -- Operaci�n de store
              estado_siguiente <= 2;
           when "000010" =>
              -- Operaci�n jump
              estado_siguiente <= 9; 
           when "000100" =>
              -- Operaci�n BEQ
              estado_siguiente <= 8;
            when "000110" =>
              -- Operaci�n BNE (c�digo inventado)
              estado_siguiente <= 10;
           when others =>
               --Si no conocemos el c�digo, saltamos la instrucci�n
               estado_siguiente <=0;
           end case; 
        
        
	    -- Ejecuci�n, acceso a memoria y escritura de resultados: 
	    ---------------------------------------------------------
	       -- Operaciones de tipo R
	       --------------------------------------------
        when 6 =>
              --Leemos datos de registros, y decodificamos c�digo de operaci�n
              case op(5 downto 0) is
                  when "100000" =>
                      -- Suma
                      SelALUA <= '1';
                      SelALUB <= "00";
                      ALUOp <= "000";
                      estado_siguiente <= 7;
                  when "100010" =>
                      -- Resta
                      SelALUA <= '1';
                      SelALUB <= "00";
                      ALUOp <= "001";
                      estado_siguiente <= 7;
                  when "100100" =>
                      -- And
                      SelALUA <= '1';
                      SelALUB <= "00";
                      ALUOp <= "011";
                      estado_siguiente <= 7;
                  when "100101" =>
                      -- Or
                      SelALUA <= '1';
                      SelALUB <= "00";
                      ALUOp <= "010";
                      estado_siguiente <= 7;
                  when others =>
                      -- Volvemos a estado inicial
                      estado_siguiente <= 0;
                  end case; 
                  
         
         when 7 =>
                -- Escritura en el registro destino de la operaci�n tipo R
                MemaReg <= '0';
                RegDest <= '0'; 
                EscrReg <= '1';
                estado_siguiente <= 0;
                      
            --------------------------------
            
            -- Operaci�n load y store: ejecuci�n, accesos y write-back (s�lo load)
            ---------------------------------------------------------------------
         when 2 =>
                --ALUOut<- A* + ext(inmed)
                SelALUA <= '1';
                SelALUB <= "10";
                ALUOp <= "000";
                
                -- Decodificaci�n de operaci�n: load o store
                case op(11 downto 6) is
                    when "100011" =>
                        --load
                        estado_siguiente <= 3;
                    when "101011" =>
                        --store
                        estado_siguiente <= 5;
                    when others =>
                        estado_siguiente <=0;
                    end case;
            
         -- Acceso a memoria de operaci�n load
         when 3 =>
                LeerMem <= '1';
                estado_siguiente <= 4;
            
         -- Escritura del contenido de memoria en registro de load
         when 4 =>
                EscrReg <= '1';
                MemaReg <= '1';
                RegDest <= '1';
                estado_siguiente <=0;
          
         -- Acceso a memoria para la operaci�n store      
         when 5 =>
                selALUB <= "00";
                EscribirMEM <= '1';
                estado_siguiente <= 0;
                
        ---------------Fin ejec,acceso,wb de load y store ----------
                      
         -- Operaci�n BEQ: ejecuci�n
         ---------------------------------------------
         when 8 =>
                --Restamos registros a y b
                SelALUA <= '1';
                SelALUB <= "00";
                ALUOP <= "001";
                if (cero='1') then
                   --Si son iguales, saltamos (cambiamos valor de pc)
                   EscrPC <= '1';
                   FuentePC <= "01";
                end if;
                --Saltemos o no, pasamos a leer una nueva inst
                estado_siguiente <= 0;
         -------------------------------------------------
         
         -- Operaci�n JUMP: ejecuci�n
         ----------------------------------------------------
         when 9 =>
                EscrPC <= '1';
                FuentePC <= "10";
                estado_siguiente <= 0;
         ------------------------------------------------------  
         
         -- Operaci�n BNE: ejecuci�n
         ---------------------------------------------
         when 10 =>
                --Restamos registros a y b
                SelALUA <= '1';
                SelALUB <= "00";
                ALUOP <= "001";
                if (cero/='1') then
                   --Si son distintos, saltamos (cambiamos valor de pc)
                   EscrPC <= '1';
                   FuentePC <= "01";
                end if;
                --Saltemos o no, pasamos a leer una nueva inst
                estado_siguiente <= 0;
         -------------------------------------------------   
                
                      
         when others =>
	   end case; 
  end process;
  
process(clk_i,reset_i)
begin
   if(reset_i='1') then
	   estado<=0;
	   n_ciclo<=0;
   elsif (clk_i'event and clk_i='1') then
	   estado<=estado_siguiente;
	   n_ciclo<= n_ciclo + 1;
   end if;
end process;
end funcional;