library ieee;
use ieee.std_logic_1164.all;

entity stream_cipher is
  port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    activation     : in  std_logic;
    charge_graine  : in  std_logic;
    graine         : in  std_logic_vector(7 downto 0);
    donnee_entree  : in  std_logic;
    donnee_sortie  : out std_logic
  );
end entity stream_cipher;

architecture struct of stream_cipher is
  signal keystream : std_logic;
begin

  inst_lfsr : entity work.lfsr
    port map (
      clk            => clk,
      reset          => reset,
      activation     => activation,
      charge_graine  => charge_graine,
      graine         => graine,
      sortie_donnees => open,
      bit_sortie     => keystream
    );

  donnee_sortie <= donnee_entree xor keystream;

end architecture struct;