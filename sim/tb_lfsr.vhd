library ieee;
use ieee.std_logic_1164.all;

entity tb_lfsr is
end entity tb_lfsr;

architecture sim of tb_lfsr is

  signal clk            : std_logic := '0';
  signal reset          : std_logic := '0';
  signal activation     : std_logic := '0';
  signal charge_graine  : std_logic := '0';
  signal graine         : std_logic_vector(7 downto 0) := (others => '0');
  signal sortie_donnees : std_logic_vector(7 downto 0);
  signal bit_sortie     : std_logic;

  constant periode_clk  : time := 10 ns;

begin

  dut : entity work.lfsr
    port map (
      clk            => clk,
      reset          => reset,
      activation     => activation,
      charge_graine  => charge_graine,
      graine         => graine,
      sortie_donnees => sortie_donnees,
      bit_sortie     => bit_sortie
    );

  process_horloge : process
  begin
    clk <= '0';
    wait for periode_clk / 2;
    clk <= '1';
    wait for periode_clk / 2;
  end process;

  process_test : process
  begin
    -- Etape 1 : Reset initial
    reset <= '1';
    wait for 2 * periode_clk;
    reset <= '0';
    wait for periode_clk;

    
    activation <= '1';
    wait for 5 * periode_clk;
    activation <= '0';
    wait for periode_clk;

    
    graine <= x"A5";
    charge_graine <= '1';
    wait for periode_clk;
    charge_graine <= '0';
    wait for periode_clk;

    activation <= '1';
    wait for 10 * periode_clk;

    activation <= '0';
    wait;
  end process;

end architecture sim;
