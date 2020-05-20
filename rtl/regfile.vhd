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

entity regfile is
  port (
    clk : in std_logic; -- Input clock
    r1_addr : in std_logic_vector(4 downto 0);
    r2_addr : in std_logic_vector(4 downto 0);
    rden : in std_logic;
    r1_out : out std_logic_vector(31 downto 0);
    r2_out : out std_logic_vector(31 downto 0);
    r3_addr : in std_logic_vector(4 downto 0);
    r3_in : in std_logic_vector(31 downto 0);
    r3_write : in std_logic
  );
end entity;

architecture rtl of regfile is

  signal r1_ram, r2_ram : std_logic_vector(31 downto 0);
begin

  dpram32x32_i : entity work.dpram32x32
  port map (
    data_a => r3_in,
    data_b => X"00000000",
    addr_a => to_integer(unsigned(r1_addr)),
    addr_b => to_integer(unsigned(r2_addr)),
    we_a   => r3_write,
    we_b   => '0',
    clk    => clk,
    q_a    => r1_ram,
    q_b    => r2_ram
  );

  r1_out <= r1_ram when r1_addr /= "00000" else (others => '0');
  r2_out <= r2_ram when r2_addr /= "00000" else (others => '0');

end architecture;
