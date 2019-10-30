library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity FluxoDeDados is
	generic (
        enderecosIntrucao : natural := 5; -- Qtd de linhas de instrucoes
		  tamanhoFunct : natural := 6; -- Tamanho do Funct
		  tamanhoOpCode : natural := 6; -- Tamanho do OpCode
		  tamanhoReg : natural := 5; -- Tamanho da qtd de enderecos de Registrador (Rs, Rt, Rd)
		  tamanhoInstrucao : natural := 32; -- Tamanho total da Intrucao
		  larguraDados : natural := 32
		  
    );
	port (
		CLOCK_50   : in std_logic;
		inPC	: in std_logic;
		operationULA : in std_logic_vector(tamanhoFunct -1 downto 0);
		enableWriteBR : in std_logic;
		opCode : out std_logic_vector(tamanhoOpCode -1 downto 0);
		LEDR : out std_logic_vector(17 downto 0);
		LEDG : out std_logic_vector(7 downto 0)
	);

end entity;
architecture Behavioral of FLuxoDeDados is

	signal entrada_A_ULA,entrada_B_ULA, saida_ULA : std_logic_vector(larguraDados-1 downto 0);
	signal sel_ULA : std_logic_vector(tamanhoFunct-1 downto 0);
	signal instrucao : std_logic_vector(tamanhoInstrucao-1 downto 0);
	signal saida_somador, saida_PC : std_logic_vector(enderecosIntrucao -1 downto 0);
	-- Registradores
	signal Rs,Rt,Rd : std_logic_vector(tamanhoReg -1 downto 0);
	
begin

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
		  sel					=> operationULA
		  
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
		  clk					=>  CLOCK_50,
        enderecoA			=>  Rs,
		  enderecoB			=>  Rt,
		  enderecoC			=>  Rd,
		  dadoEscritaC		=>  saida_ULA,
		  saidaA				=>  entrada_A_ULA,
		  saidaB				=>  entrada_B_ULA,
		  escreveC			=>  enableWriteBR
		  
    );
	 

ROM1 : entity work.ROM
	 generic map
	 (
			dataWidth  => tamanhoInstrucao,
			addrWidth  => enderecosIntrucao
			
	 )
    port map
    (		
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
		CLK		 =>  CLOCK_50,
		RST		 =>  '0'
	);


end architecture;
