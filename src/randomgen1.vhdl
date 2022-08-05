entity tb is
end entity;

library ieee;
use ieee.math_real.uniform;
use ieee.math_real.floor;

architecture sim of tb is
begin
  process is
    variable seed1 : positive;
    variable seed2 : positive;
    variable x : real;
    variable y : integer;
  begin
    seed1 := 1;
    seed2 := 1;
    for n in 1 to 10 loop
      uniform(seed1, seed2, x);
      y := integer(floor(x * 1024.0));
      report "Random number in 0 .. 1023: " & integer'image(y);
    end loop;
    wait;
  end process;
end architecture;

-- Solution based on @Morten Zilmer
-- https://stackoverflow.com/a/53353673/4374258
