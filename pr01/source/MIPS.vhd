---------------------------------------------------------------------
--  
--  Fichero: MIPS.vhd
--  
--  Descripción:
--    Entidad que conecta la unidad de control y el datapath
--
--  Autor: Javier Castillo
--  Fecha: 20-10-2006
--  
--  Historia:
--     20-10-2006  Versión inicial
--     11-12-2006   Corregido bug en instruccion slt
--  Modifica - David Rozas Domingo:
--     08-03-2007  Creación de instancias a componentes   
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY mips IS 

port (
  clk_i : IN std_logic; 
  reset_i : IN std_logic);
END mips;

ARCHITECTURE funcional of mips IS

COMPONENT Datapath IS
port(
  clk_i : IN std_logic; 
  reset_i : IN std_logic;

  op : OUT std_logic_vector (11 downto 0);
  cero : OUT std_logic;
  EscrPC: IN std_logic;
  LeerMEM: IN std_logic;
  EscribirMEM: IN std_logic;
  MemaReg: IN std_logic;
  EscrIR: IN std_logic;
  FuentePC : IN std_logic_vector(1 downto 0);
  ALUOp : IN std_logic_vector(2 downto 0);
  SelALUA: IN std_logic;
  SelALUB: IN std_logic_vector(1 downto 0);
  EscrReg : IN std_logic;
  RegDest : IN std_logic
    
 );
 
 END COMPONENT;
 
 COMPONENT uc IS
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
END COMPONENT;

signal op : std_logic_vector (11 downto 0);
signal cero, EscrPC, LeerMEM, EscribirMEM, MemaReg, EscrIR: std_logic;
signal SelALUA, EscrReg, RegDest: std_logic;
signal FuentePC, SelALUB : std_logic_vector (1 downto 0);
signal ALUOp : std_logic_vector (2 downto 0);


BEGIN

Data : Datapath port map (clk_i, reset_i, op, cero, EscrPC, LeerMEM, EscribirMEM, MemaReg,
			 EscrIR, FuentePC, ALUOp, SelALUA, SelALUB, EscrReg, RegDest );
			 
UnidadControl: UC port map (clk_i, reset_i, op, cero, EscrPC, LeerMEM, EscribirMEM, MemaReg,
			 EscrIR, FuentePC, ALUOp, SelALUA, SelALUB, EscrReg, RegDest );
	

END funcional;
