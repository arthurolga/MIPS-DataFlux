
library ieee;
use ieee.std_logic_1164.all;

entity Chaves is
    generic (
        quantidadeChaves    : natural := 6
    );
    port
    (
        entradaChaves   : IN STD_LOGIC_VECTOR(quantidadeChaves-1 downto 0);
        habilita        : IN  STD_LOGIC;
        saida           : OUT STD_LOGIC_VECTOR(quantidadeChaves-1 downto 0)
    );
end entity;