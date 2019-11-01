library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Baseado no apendice C (Register Files) do COD (Patterson & Hennessy).

entity BancoRegistradores is
    generic
    (
        larguraDados        : natural := 7;
        larguraEndBancoRegs : natural := 4   --Resulta em 2^4=16 posicoes
    );
-- Leitura de 2 registradores e escrita em 1 registrador simultaneamente.
    port
    (
        clk        : in std_logic;
--
        enderecoA       : in std_logic_vector((larguraEndBancoRegs-1) downto 0);
        enderecoB       : in std_logic_vector((larguraEndBancoRegs-1) downto 0);
        enderecoC       : in std_logic_vector((larguraEndBancoRegs-1) downto 0);
--
        dadoEscritaC    : in std_logic_vector((larguraDados-1) downto 0);
--
        escreveC        : in std_logic := '0';
        saidaA          : out std_logic_vector((larguraDados -1) downto 0);
        saidaB          : out std_logic_vector((larguraDados -1) downto 0)
    );
end entity;

architecture comportamento of BancoRegistradores is

    subtype palavra_t is std_logic_vector((larguraDados-1) downto 0);
    type memoria_t is array(2**larguraEndBancoRegs-1 downto 0) of palavra_t;

    -- Declaracao dos registradores:
    -- shared variable registrador : memoria_t;
	 
	 function init_ram
		return memoria_t is 
		variable tmp : memoria_t := (others => (others => '0'));
		begin 
			tmp(1) := std_logic_vector(to_unsigned(1, larguraDados));
			tmp(2) := std_logic_vector(to_unsigned(2, larguraDados));
			tmp(3) := std_logic_vector(to_unsigned(3, larguraDados));
			
			return tmp;
		end init_ram;	 

		-- Declare the RAM signal and specify a default value.	Quartus Prime
		-- will create a memory initialization file (.mif) based on the 
		-- default value.
		signal registrador : memoria_t := init_ram;

begin
    process(clk) is
    begin
        if (rising_edge(clk)) then
            if (escreveC = '1') then
                registrador(to_integer(unsigned(enderecoC))) <= dadoEscritaC;
            end if;
        end if;
    end process;

    -- IF endereco = 0 : retorna ZERO
     process(all) is
     begin
         if (unsigned(enderecoA) = 0) then
            saidaA <= (others => '0');
         else
            saidaA <= registrador(to_integer(unsigned(enderecoA)));
         end if;
         if (unsigned(enderecoB) = 0) then
            saidaB <= (others => '0');
         else
            saidaB <= registrador(to_integer(unsigned(enderecoB)));
        end if;
     end process;
end architecture;