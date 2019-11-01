library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity FluxoDeDados is
	generic (
        enderecosIntrucao : natural := 32; -- Qtd de linhas de instrucoes
		  tamanhoFunct : natural := 6; -- Tamanho do Funct
		  tamanhoOpCode : natural := 6; -- Tamanho do OpCode
		  tamanhoReg : natural := 5; -- Tamanho da qtd de enderecos de Registrador (Rs, Rt, Rd)
		  tamanhoInstrucao : natural := 32; -- Tamanho total da Intrucao
		  larguraDados : natural := 32
		  
    );
	port (
		inPC	: in std_logic;
		opCode : out std_logic_vector(tamanhoOpCode -1 downto 0);
		LEDR : out std_logic_vector(17 downto 0);
		LEDG : out std_logic_vector(7 downto 0);
		SW : in std_logic_vector(17 downto 0);
		KEY : in std_ulogic_vector(3 downto 0);
		HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7 : out std_logic_vector(6 downto 0)
	);

end entity;
architecture Behavioral of FLuxoDeDados is

	signal entrada_A_ULA,entrada_B_ULA, saida_ULA : std_logic_vector(larguraDados-1 downto 0);
	signal sel_ULA : std_logic_vector(tamanhoFunct-1 downto 0);
	signal instrucao : std_logic_vector(tamanhoInstrucao-1 downto 0);
	signal saida_somador, saida_PC : std_logic_vector(enderecosIntrucao -1 downto 0);
	-- Registradores
	signal Rs,Rt,Rd : std_logic_vector(tamanhoReg -1 downto 0);
	
	signal clock,enableC : std_logic;
	
begin

clock <= KEY(0);
sel_ULA <= "100000" when (SW(1)='0') else "100010";
LEDG(7 downto 0) <= saida_somador(7 downto 0);
enableC <= SW(2);

LEDR <= SW;


CONV1 : entity work.Conv7seg
	port map
    (		
			dadoHex 		=> entrada_A_ULA(3 downto 0),
			HEX			=> HEX7
		  
    );
CONV2 : entity work.Conv7seg
	port map
    (		
			dadoHex 		=> entrada_B_ULA(3 downto 0),
			HEX			=> HEX6
		  
    );
CONV3 : entity work.Conv7seg
	port map
    (		
			dadoHex 		=> saida_ULA(3 downto 0),
			HEX			=> HEX5
		  
    );
	 
	 

ULA1 : entity work.ULA
	 generic map
	 (
		larguraDados => larguraDados,
		qtdOp => tamanhoFunct
	 )
    port map
    (		
        inA					=> entrada_A_ULA,
		  inB					=> entrada_B_ULA,
		  outO				=> saida_ULA,
		  sel					=> sel_ULA
		  
    );
	 
	 
Rs <= instrucao(25 downto 21);
Rt <= instrucao(20 downto 16);
Rd <= instrucao(15 downto 11);
opCode <= instrucao(31 downto 26);


BR1 : entity work.BancoRegistradores
    generic map
    (
        larguraDados        =>  larguraDados,
        larguraEndBancoRegs =>  tamanhoReg   --Resulta em 2^4=16 posicoes
    )
    port map
    (		
		  clk					=>  clock,
        enderecoA			=>  Rs,
		  enderecoB			=>  Rt,
		  enderecoC			=>  Rd,
		  dadoEscritaC		=>  saida_ULA,
		  saidaA				=>  entrada_A_ULA,
		  saidaB				=>  entrada_B_ULA,
		  escreveC			=>  enableC
		  
    );
	 

ROM1 : entity work.ROM
	 generic map
	 (
			dataWidth  => tamanhoInstrucao,
			addrWidth  => enderecosIntrucao
			
	 )
    port map
    (	
		  clk				=> clock,
		  Endereco		=> saida_PC,
		  Dado			=> instrucao
		  
    );

PC1 : entity work.ProgramCounter
	generic map
	(
		larguraDados  => enderecosIntrucao
	)
	port map
	(
		DOUT      =>  saida_PC,
		ENABLE    =>  inPC,
		DIN		 =>  saida_somador,
		CLK		 =>  clock,
		RST		 =>  '0'
	);
	
	
SOAMDOR1 : entity work.Somador
	generic map
	(
		larguraDados  => enderecosIntrucao
	)
	port map
	(
		entradaA => saida_PC, 
		entradaB => "00000000000000000000000000000100",
		saida => saida_somador
	);

	

end architecture;
