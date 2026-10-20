library ieee;
use ieee.std_logic_1164.all;

entity lfsr is
  port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    activation     : in  std_logic;
    charge_graine  : in  std_logic;
    graine         : in  std_logic_vector(7 downto 0);
    sortie_donnees : out std_logic_vector(7 downto 0);
    bit_sortie     : out std_logic
  );
end entity lfsr;

architecture behav of lfsr is
  signal registre_interne : std_logic_vector(7 downto 0) := x"01";
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        registre_interne <= x"01";
      elsif charge_graine = '1' then
        if graine = x"00" then
          registre_interne <= x"01";
        else
          registre_interne <= graine;
        end if;
      elsif activation = '1' then
        registre_interne <= registre_interne(6 downto 0) & 
                            (registre_interne(7) xor registre_interne(5) xor 
                             registre_interne(4) xor registre_interne(3));
      end if;
    end if;
  end process;

  sortie_donnees <= registre_interne;
  bit_sortie     <= registre_interne(7);

end architecture behav;
