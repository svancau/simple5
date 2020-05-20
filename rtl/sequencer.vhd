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

entity sequencer is
  port (
    clk : in std_logic; -- Input clock
    instr_read : out std_logic
  );
end entity;

architecture rtl of sequencer is
  type sequencer_state_t is (FETCH, DECODE, EXEC);
  signal sequencer_state : sequencer_state_t := FETCH;
  signal instr_read_i : std_logic := '1';

begin

  instr_read <= instr_read_i;

  process (clk)
  begin
    if rising_edge(clk) then

      instr_read_i <= '0';

      case sequencer_state is
        when FETCH =>
          sequencer_state <= DECODE;

        when DECODE =>
          sequencer_state <= EXEC;

        when EXEC =>
          sequencer_state <= FETCH;
          instr_read_i <= '1';

      end case;

    end if;
  end process;

end architecture;
