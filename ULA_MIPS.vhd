library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity ULA is
	generic (
        larguraDados : natural := 5;
		  qtdOp : natural := 5
    );
	port (
		inA,inB	:	in std_logic_vector(larguraDados-1 downto 0);
		outO		:	out std_logic_vector(larguraDados-1 downto 0);
		sel		:	in std_logic_vector(qtdOp -1  downto 0)
	);

end ULA;

architecture Behavioral of ULA is

-- signal Z : std_logic_vector(larguraDados-1 downto 0);

-- signal bIsZero, bIsLessA : std_logic;

begin
	
--	bIsZero <= '1' when (inB = "0000000") else '0';
--	bIsLessA <= '1' when (inB < inA) else '0';
--	Z <= "1111111" when (inA = inB) else "0000000";
--	
--	
--	outO <= 
--	inA + inB 	when (sel = "000") else -- Adicao A+B
--	inA 			when (sel = "001") else -- MOV A
--	Z				when (sel = "101") else
--	"0000000";

	


end architecture;


	
	
	
	
	

