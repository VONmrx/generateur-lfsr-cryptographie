library ieee;
use ieee.std_logic_1164.all;

entity tb_stream_cipher is
end entity tb_stream_cipher;

architecture sim of tb_stream_cipher is

  signal clk               : std_logic := '0';
  signal reset             : std_logic := '0';
  signal activation        : std_logic := '0';
  signal charge_graine     : std_logic := '0';
  signal graine            : std_logic_vector(7 downto 0) := (others => '0');

  signal donnee_entree     : std_logic := '0';  
  signal donnee_chiffree   : std_logic;         
  signal donnee_dechiffree : std_logic;         

  constant periode_clk : time := 10 ns;

begin


  chiffreur : entity work.stream_cipher
    port map (
      clk            => clk,
      reset          => reset,
      activation     => activation,
      charge_graine  => charge_graine,
      graine         => graine,
      donnee_entree  => donnee_entree,
      donnee_sortie  => donnee_chiffree
    );

 
  dechiffreur : entity work.stream_cipher
    port map (
      clk            => clk,
      reset          => reset,
      activation     => activation,
      charge_graine  => charge_graine,
      graine         => graine,
      donnee_entree  => donnee_chiffree,
      donnee_sortie  => donnee_dechiffree
    );

  process_horloge : process
  begin
    clk <= '0';
    wait for periode_clk / 2;
    clk <= '1';
    wait for periode_clk / 2;
  end process;

  process_test : process
    constant message_a_envoyer : std_logic_vector(15 downto 0) := x"ABCD";
    constant chiffre_attendu   : std_logic_vector(15 downto 0) := x"0134"; 
    variable nb_erreurs        : integer := 0;
  begin
    -- Reset initial
    reset <= '1';
    wait for 2 * periode_clk;
    reset <= '0';
    wait for periode_clk;

    -- Chargement de la graine
    graine        <= x"AA";
    charge_graine <= '1';
    wait until rising_edge(clk);  
    wait for 1 ns;
    charge_graine <= '0';
    activation    <= '1';          
    for i in 15 downto 0 loop
      donnee_entree <= message_a_envoyer(i);
      wait for 1 ns;              

      
      if donnee_chiffree /= chiffre_attendu(i) then
        report "ERREUR chiffrement au bit " & integer'image(i) severity error;
        nb_erreurs := nb_erreurs + 1;
      end if;

      -- Verif 2 : apres dechiffrement, on retrouve le message d'origine
      if donnee_dechiffree /= message_a_envoyer(i) then
        report "ERREUR dechiffrement au bit " & integer'image(i) severity error;
        nb_erreurs := nb_erreurs + 1;
      end if;

      wait until rising_edge(clk); 
      wait for 1 ns;               
    end loop;

    activation    <= '0';
    donnee_entree <= '0';
    wait for 5 * periode_clk;

    -- Bilan
    if nb_erreurs = 0 then
      report "TEST OK : chiffrement et dechiffrement corrects" severity note;
    else
      report "TEST ECHOUE : " & integer'image(nb_erreurs) & " erreur(s)" severity error;
    end if;

    wait;
  end process;

end architecture sim;