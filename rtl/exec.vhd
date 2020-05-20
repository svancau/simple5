-- Copyright 2020 Sebastien Van Cauwenberghe <svancau@gmail.com>
--
-- Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
--
-- 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
--
-- 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
--
-- 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute is
  port (
    clk : in std_logic; -- Input clock
    op : in std_logic_vector(9 downto 0);
    r1 : in std_logic_vector(31 downto 0);
    r2 : in std_logic_vector(31 downto 0);
    imm : in std_logic_vector(31 downto 0);
    use_imm : in std_logic;
    pc : in std_logic_vector(31 downto 0);
    pc_out : out std_logic_vector(31 downto 0);
    write_pc : out std_logic;
    r3_addr : out std_logic_vector(4 downto 0);
    r3_in : out std_logic_vector(31 downto 0);
    r3_write : out std_logic
  );
end entity;

architecture rtl of execute is

begin
  process (clk)
  begin
    if rising_edge(clk) then
      r3_write <= '0';

      if op(0) = '1' then --ADD
        r3_in <= std_logic_vector(unsigned(r1) + unsigned(r2));
        r3_write <= '1';
      end if;

      if op(1) = '1' then -- SUB
        r3_in <= std_logic_vector(unsigned(r1) - unsigned(r2));
        r3_write <= '1';
      end if;

      if op(3) = '1' then -- SLT
        if signed(r1) < signed(r2) then
          r3_in <= (0 => '1', others => '0');
        else
          r3_in <= (others => '0');
        end if;
        r3_write <= '1';
      end if;

      if op(4) = '1' then -- SLTU
        if unsigned(r1) < unsigned(r2) then
          r3_in <= (0 => '1', others => '0');
        else
          r3_in <= (others => '0');
        end if;
        r3_write <= '1';
      end if;

      if op(5) = '1' then -- XOR
        r3_in <= r1 xor r2;
        r3_write <= '1';
      end if;

      if op(8) = '1' then -- OR
        r3_in <= r1 or r2;
        r3_write <= '1';
      end if;

      if op(9) = '1' then -- AND
        r3_in <= r1 and r2;
        r3_write <= '1';
      end if;

    end if;
  end process;

end architecture;
